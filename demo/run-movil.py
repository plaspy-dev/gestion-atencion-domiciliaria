"""Compile the archived mobile Web Forms edition and verify a fictional login."""

from argparse import ArgumentParser
from hashlib import sha256
from http.cookiejar import CookieJar
import json
import os
from pathlib import Path, PurePosixPath
import runpy
from secrets import token_hex
import shutil
import subprocess
from tempfile import TemporaryDirectory
import time
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode, urljoin, urlsplit
from urllib.request import build_opener, HTTPCookieProcessor, HTTPRedirectHandler, ProxyHandler, Request
from xml.etree import ElementTree as ET
from zipfile import ZipFile


DEMO = Path(__file__).resolve().parent


class LocalRedirect(HTTPRedirectHandler):
    def redirect_request(self, request, response, code, message, headers, url):
        if urlsplit(url).netloc != urlsplit(request.full_url).netloc:
            raise RuntimeError('The archived site attempted to leave its loopback server.')
        return None


def request(client, target, fields=None, timeout=25):
    try:
        response = client.open(Request(target, data=urlencode(fields).encode() if fields else None), timeout=timeout)
    except HTTPError as error:
        response = error
    with response:
        return response.code, response.headers.get('Location', ''), response.read(180000).decode('utf-8', errors='replace')


def sign_in(helpers, address, process, password, query):
    query("ALTER TABLE usuario ADD COLUMN forceurl VARCHAR(150) DEFAULT '',"
          ' ADD COLUMN personal VARCHAR(120), ADD COLUMN cargos VARCHAR(120),'
          ' ADD COLUMN entidades VARCHAR(120), ADD COLUMN cumpleanos DATE;')
    cookies = CookieJar()
    client = build_opener(ProxyHandler({}), HTTPCookieProcessor(cookies), LocalRedirect())
    start = address + '/Default.aspx'
    for _ in range(50):
        try:
            status, _, page = request(client, start)
            break
        except URLError:
            if process.poll() is not None:
                raise RuntimeError('IIS Express stopped before the mobile edition loaded.') from None
            time.sleep(.4)
    else:
        raise RuntimeError('The mobile edition did not respond on loopback.')
    if status != 200:
        raise RuntimeError(f'The mobile sign-in page returned HTTP {status}.')
    parser = helpers['LoginForm']()
    parser.feed(page)
    (action, fields), = [(action, fields) for action, fields in parser.forms if 'TU' in fields and 'TC' in fields]
    fields.update(TU=helpers['ACCOUNT'], TC=password)
    target = urljoin(start, action or start)
    if urlsplit(target).netloc != urlsplit(start).netloc:
        raise RuntimeError('The mobile form points outside the demonstration server.')
    status, location, _ = request(client, target, fields)
    signed = any(cookie.name == 'contrasena' and cookie.value for cookie in cookies)
    stored = query('SELECT COUNT(*) FROM usuario WHERE id=781 AND ingreso IS NOT NULL;').strip() == b'1'
    home = 0
    if status == 302 and location:
        destination = urljoin(target, location)
        if urlsplit(destination).netloc != urlsplit(start).netloc:
            raise RuntimeError('The mobile application redirected outside its demonstration server.')
        home, _, _ = request(client, destination)
    print(f'Mobile sign-in HTTP {status}. Session cookie {signed}. MySQL recorded the fictional sign-in {stored}. Home HTTP {home}.')
    if (status, signed, stored, home) != (302, True, True, 200):
        raise RuntimeError('The mobile edition did not complete the fictional sign-in.')


def build(builder, source, scratch, manifest):
    site = source / 'movil'
    binary = site / 'Bin'
    binary.mkdir(exist_ok=True)
    for name, version, digest in manifest['packages']:
        with builder['official_package'](name, version, digest) as archive:
            assemblies = [path for path in archive.namelist()
                          if PurePosixPath(path).suffix == '.dll'
                          and PurePosixPath(path).parent.as_posix() in ('lib/net40', 'lib/net40-full', 'lib/net45')]
            for assembly in assemblies:
                (binary / PurePosixPath(assembly).name).write_bytes(archive.read(assembly))
    connector = binary / 'MySql.Data.dll'
    archived_connector = source / manifest['mysql_path']
    if sha256(archived_connector.read_bytes()).hexdigest() != manifest['mysql']:
        raise RuntimeError('The provider does not match the archived mobile project.')
    shutil.copyfile(archived_connector, connector)
    library = source / 'vendor/componentes-movil'
    references = source / 'vendor/references'
    references.mkdir(exist_ok=True)
    (references / connector.name).write_bytes(connector.read_bytes())
    (project,) = library.glob('*.csproj')
    subprocess.run(['dotnet', 'build', project, '--configuration', 'Release', '--nologo'], cwd=library, check=True)
    output = library / 'bin/Release/net48/SDG.Componentes.dll'
    (binary / output.name).write_bytes(output.read_bytes())
    config = ET.Element('configuration')
    settings = ET.SubElement(config, 'appSettings')
    ET.SubElement(settings, 'add', key='Usuario', value='CUsuario')
    ET.SubElement(settings, 'add', key='ValidationSettings:UnobtrusiveValidationMode', value='None')
    system = ET.SubElement(config, 'system.web')
    for name in ('compilation', 'httpRuntime'):
        ET.SubElement(system, name, targetFramework=manifest['framework'])
    ET.ElementTree(config).write(site / 'Web.config', encoding='utf-8', xml_declaration=True)
    compiler = Path(os.environ['WINDIR']) / 'Microsoft.NET/Framework/v4.0.30319/aspnet_compiler.exe'
    subprocess.run([compiler, '-v', '/', '-p', site, '-f', scratch / 'compiled'], check=True, cwd=site)
    print('The archived mobile Web Forms site compiled.', flush=True)
    return site


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--compile-only', action='store_true', help='precompile the mobile site without starting a server')
    options = parser.parse_args()
    builder = runpy.run_path(str(DEMO / 'build-mvc.py'))
    helpers = runpy.run_path(str(DEMO / 'run-webforms.py'))
    manifest = json.loads((DEMO / 'movil-dependencies.json').read_text(encoding='utf-8'))
    with TemporaryDirectory(prefix='domicilio-movil-demo-') as temporary:
        scratch = Path(temporary)
        archive = scratch / 'candidate.zip'
        repo = DEMO.parent
        revision = subprocess.check_output(['git', '-C', repo, 'rev-parse', 'HEAD'], text=True).strip()
        print(f'SHA {revision}', flush=True)
        subprocess.run(['git', '-C', repo, 'archive', '-o', archive, '--format=zip', revision], check=True)
        source = scratch / 'source'
        with ZipFile(archive) as package:
            builder['unpack'](package, source)
        site = build(builder, source, scratch, manifest)
        if not options.compile_only:
            password = token_hex(8)
            with (helpers['mysql'](password) as (port, query), helpers['sqlserver']() as sql,
                  helpers['web'](site, scratch, port, password, sql) as (address, process)):
                sign_in(helpers, address, process, password, query)


if __name__ == '__main__':
    main()
