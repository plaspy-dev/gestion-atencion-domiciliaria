"""Compile an archived MVC edition and verify a fictional account in IIS Express."""

from argparse import ArgumentParser
from contextlib import contextmanager
from http.cookiejar import CookieJar
import json
from pathlib import Path, PureWindowsPath
import runpy
from secrets import token_hex
import shutil
import subprocess
from tempfile import TemporaryDirectory
import time
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode, urljoin, urlsplit
from urllib.request import HTTPCookieProcessor, HTTPRedirectHandler, ProxyHandler, Request, build_opener
from xml.etree import ElementTree as ET
from zipfile import ZipFile


DEMO=Path(__file__).resolve().parent
NOTIFICATIONS='''
from http.server import BaseHTTPRequestHandler, HTTPServer
class LocalNotifications(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(204)
        self.end_headers()
    do_POST = do_GET
HTTPServer(("0.0.0.0", 8080), LocalNotifications).serve_forever()
'''


@contextmanager
def notification_server():
    name='prueba-gestion-atencion-domiciliaria-notificaciones-'+token_hex(5)
    owned=subprocess.check_output(['docker','run','--detach','--rm','--pull','never','--name',name,
        '--publish','127.0.0.1::8080','python@sha256:5e2bdb1b0d542d5039cffb8181c65930093949194a65c365dfb1b0fe13a4fa5b','python','-c',NOTIFICATIONS],text=True).strip()
    try:
        location=subprocess.check_output(['docker','port',owned,'8080/tcp'],text=True).strip()
        if not location.startswith('127.0.0.1:') or not location.rsplit(':',1)[-1].isdigit():
            raise RuntimeError('The fictional notification server must listen on loopback.')
        yield 'http://'+location
    finally:
        subprocess.run(['docker','stop','--time','3',owned],check=False,stdout=subprocess.DEVNULL)


def prepare(source, site, scratch, endpoint, edition, edit=False):
    assemblies=sorted((scratch/'edition/obj').glob('*.dll'))
    if not assemblies:
        raise RuntimeError('Build the MVC assemblies before starting the demo.')
    for artifact in assemblies:
        shutil.copy2(artifact,site/'Bin'/artifact.name)
    config=ET.parse(source/'demo/mvc-configs'/f'{edition}.config')
    settings=ET.Element('appSettings')
    for key,value in {
        'app':'domicilio','filelogs':str(scratch/'mvc.log'),'pathfiles':str(scratch/'files'),
        'servidornotificacion':endpoint,'servidor':endpoint,
        'ClientValidationEnabled':'true','UnobtrusiveJavaScriptEnabled':'true',
    }.items():
        ET.SubElement(settings,'add',key=key,value=value)
    project,=site.glob('*.csproj')
    manifest=ET.parse(project)
    for item in manifest.getroot().iter():
        if not item.tag.endswith('}HintPath') or not item.text:
            continue
        relative=PureWindowsPath(item.text)
        if relative.is_absolute() or '$(' in item.text or relative.suffix.casefold()!='.dll':
            continue
        dependency=(site/Path(*relative.parts)).resolve()
        if not dependency.is_relative_to(source.resolve()):
            raise RuntimeError('A dependency points outside the archived edition.')
        if dependency.is_file() and dependency.parent!=(site/'Bin').resolve():
            shutil.copy2(dependency,site/'Bin'/dependency.name)
    assembly=next(item.text for item in manifest.getroot().iter() if item.tag.endswith('}AssemblyName'))
    ET.SubElement(settings,'add',key='Usuario',value=assembly+',CUsuario')
    config.getroot().insert(1 if config.find('configSections') is not None else 0,settings)
    config.write(site/'Web.config',encoding='utf-8',xml_declaration=True)
    (site/'dbupgrade.json').write_text('[]\n',encoding='utf-8')
    (site/'directorio.xml').write_text('<paginas><seccion><titulo>Demostración</titulo><pagina>'
        '<titulo>Portada</titulo><url>~/Inicio</url></pagina></seccion>'
        + ('<seccion><titulo>Permisos_Especiales</titulo><pagina><titulo>Consulta ficticia</titulo>'
           '<url>~/Demostracion/Permiso</url></pagina></seccion>' if edit else '')
        + '</paginas>\n',encoding='utf-8')


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, *args):
        return None


def request(client, url, data=None, ajax=False):
    if urlsplit(url).hostname!='127.0.0.1':
        raise RuntimeError('The demo uses only loopback HTTP requests.')
    try:
        headers={'X-Requested-With':'XMLHttpRequest'} if ajax else {}
        reply=client.open(Request(url,data=data,headers=headers),timeout=120)
    except HTTPError as error:
        reply=error
    with reply:
        return reply.code,reply.read(200000).decode('utf-8',errors='replace')


def sign_in(helpers, address, process, password, query, edit=False, catalogs=False):
    query("ALTER TABLE usuario ADD COLUMN forceurl VARCHAR(150) DEFAULT '', "
          'ADD COLUMN personal VARCHAR(120), ADD COLUMN cargos VARCHAR(120), '
          'ADD COLUMN entidades VARCHAR(120), ADD COLUMN cumpleanos DATE;')
    query("\nCREATE TABLE IF NOT EXISTS grupo (\n    id INT NOT NULL PRIMARY KEY,\n    nombre VARCHAR(120),\n    descripcion VARCHAR(200),\n    eliminado DATETIME\n);\nINSERT INTO grupo (id,nombre,descripcion) VALUES\n    (81,'Equipo ficticio de visitas','Grupo para comprobar el filtro');\n")
    cookies=CookieJar()
    client=build_opener(ProxyHandler({}),HTTPCookieProcessor(cookies),NoRedirect())
    landing=address+'/'
    for _ in range(45):
        try:
            status,markup=request(client,landing)
            break
        except URLError:
            if process.poll() is not None:
                raise RuntimeError('IIS Express stopped before the demo opened.') from None
            time.sleep(.5)
    else:
        raise RuntimeError('IIS Express did not finish opening the MVC edition.')
    if status!=200:
        raise RuntimeError(f'The MVC sign-in page returned HTTP {status}.')
    form=helpers['LoginForm']()
    form.feed(markup)
    action,fields=next((action,values) for action,values in form.forms if 'User' in values and 'Password' in values)
    if '__RequestVerificationToken' not in fields:
        raise RuntimeError('The archived sign-in form did not supply its form token.')
    before,_=request(client,address+'/Inicio')
    fields.update(User=helpers['ACCOUNT'],Password=password)
    target=urljoin(landing,action or landing)
    if urlsplit(target).netloc!=urlsplit(landing).netloc:
        raise RuntimeError('The sign-in form points outside its test server.')
    post,_=request(client,target,urlencode(fields).encode('ascii'))
    after,body=request(client,address+'/Inicio')
    recorded=query('SELECT COUNT(*) FROM usuario WHERE id=781 AND ingreso IS NOT NULL;').strip()==b'1'
    cookie=any(item.name=='contrasena' for item in cookies)
    account='alicia ejemplo' in body.casefold()
    print(f'GET /Inicio before sign-in {before}. POST sign-in {post}. GET /Inicio after sign-in {after}.')
    print(f'Session cookie {cookie}. MySQL recorded the sign-in {recorded}. Fictional name visible {account}.')
    if (before,post,after,cookie,recorded,account)!=(302,302,200,True,True,True):
        raise RuntimeError('The MVC edition did not complete the fictional sign-in.')
    group_page, markup = request(client, address + '/Administrador/Grupos')
    search = urlencode({'current': 1, 'rowCount': 10, 'searchPhrase': 'Equipo ficticio'}).encode('ascii')
    group_status, result = request(client, address + '/Administrador/__Grupos', search)
    found = False
    if group_status == 200:
        try:
            groups = json.loads(result)
            found = 'Equipo ficticio de visitas' in json.dumps(groups, ensure_ascii=False)
        except ValueError:
            pass
    print(f'Group view HTTP {group_page}. Filter HTTP {group_status}. Fictional group found {found}.')
    if group_page != 200 or 'grupos' not in markup.lower() or not found:
        raise RuntimeError('The MVC edition did not return the fictional group from MySQL.')


    if edit:
        change_group(helpers,client,address,query)
    if catalogs:
        check_catalogs(client,address,query)


def change_group(helpers, client, address, query):
    query("GRANT INSERT ON domicilio_demo.modificaciones TO 'domicilio_demo'@'%'; "
          "GRANT INSERT, DELETE ON domicilio_demo.permisos TO 'domicilio_demo'@'%';")
    endpoint=address+'/Administrador/_Grupos'
    opened,markup=request(client,endpoint+'?id=81',ajax=True)
    form=helpers['LoginForm']()
    form.feed(markup)
    candidates=[(action,fields) for action,fields in form.forms if fields.get('Id')=='81' and 'Nombre' in fields]
    if opened!=200 or len(candidates)!=1:
        raise RuntimeError('Could not open the fictional group edit form.')
    (action,fields),=candidates
    url=urljoin(address+'/',action or endpoint)
    if urlsplit(url).netloc!=urlsplit(address).netloc:
        raise RuntimeError('The edit form points outside its test server.')
    fields.update(Nombre='Equipo ficticio de visitas actualizado',
                  Descripcion='Cambio comprobado en el entorno local')
    saved,response=request(client,url,urlencode(fields).encode('ascii'),ajax=True)
    persisted=query("SELECT COUNT(*) FROM grupo WHERE id=81 AND nombre='Equipo ficticio de visitas actualizado' "
                    "AND descripcion='Cambio comprobado en el entorno local';").strip()==b'1'
    print(f'Group edit GET {opened}. Save HTTP {saved}. Confirmation {"toastr.success" in response}. MySQL stored the fictional change {persisted}.')
    if saved!=200 or 'toastr.success' not in response or not persisted:
        raise RuntimeError('MySQL did not retain the fictional group change.')


def check_catalogs(client, address, query):
    query("""
CREATE TABLE IF NOT EXISTS asegurador (entid INT PRIMARY KEY, entnombre VARCHAR(80), eliminado DATETIME,
 enteps INT, entafp INT, entarp INT, entprgnoaut INT, maximo_mensual INT, maximo_paciente INT);
INSERT INTO asegurador (entid,entnombre) VALUES (71,'Aseguradora Ficticia de Visitas');
CREATE TABLE IF NOT EXISTS varios (id INT PRIMARY KEY, nombre VARCHAR(100), descripcion VARCHAR(100),
 tipo INT, eliminado DATETIME);
INSERT INTO varios (id,nombre,descripcion,tipo) VALUES (84,'Valor Ficticio de Catalogo','Dato de demostracion',7);
GRANT SELECT ON domicilio_demo.asegurador TO 'domicilio_demo'@'%';
GRANT SELECT ON domicilio_demo.varios TO 'domicilio_demo'@'%';
""")
    verified = []
    for name, search, expected, parameters in (
        ('Aseguradores', 'Aseguradora Ficticia', 'Aseguradora Ficticia de Visitas', {}),
        ('Usuarios', 'alicia_demo', 'alicia_demo', {}),
        ('Parametros', 'Valor Ficticio', 'Valor Ficticio de Catalogo', {'t': 7}),
    ):
        filters = urlencode({'current': 1, 'rowCount': 10, 'searchPhrase': search, **parameters})
        status, body = request(client, address + '/Administrador/__' + name + '?' + filters, ajax=True)
        try:
            record = json.loads(body) if status == 200 else None
        except ValueError:
            record = None
        found = isinstance(record, dict) and len(record.get('rows') or []) == 1 and expected in json.dumps(record)
        print(f'{name}: HTTP {status}. Fictional catalog row {found}.')
        verified.append(found)
    if not all(verified):
        raise RuntimeError('One or more catalog queries did not return the expected fictional row.')


def main():
    builder=runpy.run_path(str(DEMO/'build-mvc.py'))
    helpers=runpy.run_path(str(DEMO/'run-webforms.py'))
    manifest=json.loads((DEMO/'mvc-packages.json').read_text(encoding='utf-8'))
    editions=manifest['editions']
    parser=ArgumentParser(description=__doc__)
    parser.add_argument('--edition',choices=editions,default=editions[0])
    parser.add_argument('--msbuild',default='MSBuild.exe')
    parser.add_argument('--edit-group',action='store_true',help='verify a fictional group edit')
    parser.add_argument('--catalogs', action='store_true', help='verify three fictional catalog queries')
    args=parser.parse_args()
    repo=DEMO.parent
    version=subprocess.check_output(['git','-C',repo,'rev-parse','HEAD'],text=True).strip()
    print(f'SHA {version}',flush=True)
    with TemporaryDirectory(prefix='home-care-mvc-demo-') as temporary:
        scratch=Path(temporary)
        archive=scratch/'edition.zip'
        subprocess.run(['git','-C',repo,'archive','-o',archive,'--format=zip',version],check=True)
        source=scratch/'source'
        with ZipFile(archive) as packed:
            builder['unpack'](packed,source)
        site=source/args.edition
        builder['build'](args.msbuild,source,scratch,args.edition,manifest)
        with notification_server() as address:
            prepare(source,site,scratch,address,args.edition,edit=args.edit_group)
            password=token_hex(16)
            with (helpers['mysql'](password) as (port,query),helpers['sqlserver']() as database,
                  helpers['web'](site,scratch,port,password,database) as (endpoint,process)):
                sign_in(helpers,endpoint,process,password,query,edit=args.edit_group,catalogs=args.catalogs)


if __name__=='__main__':
    main()
