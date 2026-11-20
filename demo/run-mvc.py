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
from urllib.request import HTTPCookieProcessor, HTTPRedirectHandler, ProxyHandler, build_opener
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
        '--publish','127.0.0.1::8080','python:3.12-slim','python','-c',NOTIFICATIONS],text=True).strip()
    try:
        location=subprocess.check_output(['docker','port',owned,'8080/tcp'],text=True).strip()
        if not location.startswith('127.0.0.1:') or not location.rsplit(':',1)[-1].isdigit():
            raise RuntimeError('The fictional notification server must listen on loopback.')
        yield 'http://'+location
    finally:
        subprocess.run(['docker','stop','--time','3',owned],check=False,stdout=subprocess.DEVNULL)


def prepare(source, site, scratch, endpoint, edition):
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
        '<titulo>Portada</titulo><url>~/Inicio</url></pagina></seccion></paginas>\n',encoding='utf-8')


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, *args):
        return None


def request(client, url, data=None):
    if urlsplit(url).hostname!='127.0.0.1':
        raise RuntimeError('The demo uses only loopback HTTP requests.')
    try:
        reply=client.open(url,data=data,timeout=120)
    except HTTPError as error:
        reply=error
    with reply:
        return reply.code,reply.read(200000).decode('utf-8',errors='replace')


def sign_in(helpers, address, process, password, query):
    query("ALTER TABLE usuario ADD COLUMN forceurl VARCHAR(150) DEFAULT '', "
          'ADD COLUMN personal VARCHAR(120), ADD COLUMN cargos VARCHAR(120), '
          'ADD COLUMN entidades VARCHAR(120), ADD COLUMN cumpleanos DATE;')
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


def main():
    builder=runpy.run_path(str(DEMO/'build-mvc.py'))
    helpers=runpy.run_path(str(DEMO/'run-webforms.py'))
    manifest=json.loads((DEMO/'mvc-packages.json').read_text(encoding='utf-8'))
    editions=manifest['editions']
    parser=ArgumentParser(description=__doc__)
    parser.add_argument('--edition',choices=editions,default=editions[0])
    parser.add_argument('--msbuild',default='MSBuild.exe')
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
            prepare(source,site,scratch,address,args.edition)
            password=token_hex(16)
            with (helpers['mysql'](password) as (port,query),helpers['sqlserver']() as database,
                  helpers['web'](site,scratch,port,password,database) as (endpoint,process)):
                sign_in(helpers,endpoint,process,password,query)


if __name__=='__main__':
    main()
