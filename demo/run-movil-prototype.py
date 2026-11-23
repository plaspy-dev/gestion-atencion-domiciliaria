"""Build the archived mobile prototype and register a fictional account."""

from argparse import ArgumentParser
from http.cookiejar import CookieJar
import json
import os
from pathlib import Path
import re
import runpy
from secrets import token_hex
import subprocess
from tempfile import TemporaryDirectory
import time
from urllib.error import URLError
from urllib.parse import urljoin, urlsplit
from urllib.request import build_opener, HTTPCookieProcessor, ProxyHandler
from xml.etree import ElementTree as ET
from zipfile import ZipFile


DEMO = Path(__file__).resolve().parent
ACCOUNT = 'operadora_demo'


def config(assemblies, binary):
    document = ET.Element('configuration')
    application = ET.SubElement(document, 'system.web')
    ET.SubElement(application, 'customErrors', mode='Off')
    for section in ('compilation', 'httpRuntime'):
        ET.SubElement(application, section, targetFramework='4.5.2')
    pages = ET.SubElement(application, 'pages')
    namespaces = ET.SubElement(pages, 'namespaces')
    for name in ('System.Web.Optimization', 'Microsoft.AspNet.Identity'):
        ET.SubElement(namespaces, 'add', namespace=name)
    controls = ET.SubElement(pages, 'controls')
    package = 'Microsoft.AspNet.Web.Optimization.WebForms'
    ET.SubElement(controls, 'add', tagPrefix='webopt', namespace=package, assembly=package)
    settings = ET.SubElement(document, 'appSettings')
    ET.SubElement(settings, 'add', key='ValidationSettings:UnobtrusiveValidationMode', value='None')
    runtime = ET.SubElement(document, 'runtime')
    bindings = ET.SubElement(runtime, 'assemblyBinding', xmlns='urn:schemas-microsoft-com:asm.v1')
    output = subprocess.check_output(['pwsh', '-NoProfile', '-Command',
        'Get-ChildItem -LiteralPath $env:DOMICILIO_PROTOTYPE_ASSEMBLIES -Filter *.dll | ForEach-Object {'
        '  [Reflection.AssemblyName]::GetAssemblyName($_.FullName).FullName }'],
        env={**os.environ, 'DOMICILIO_PROTOTYPE_ASSEMBLIES': str(binary)}, text=True, timeout=50)
    identities = {match[1]: (match[2], match[3]) for match in
                  re.finditer(r'(?m)^([\w.]+), Version=([0-9.]+), Culture=neutral, PublicKeyToken=([a-f0-9]{16})\s*$', output)}
    for name in assemblies:
        version, token = identities[name]
        item = ET.SubElement(bindings, 'dependentAssembly')
        ET.SubElement(item, 'assemblyIdentity', name=name, publicKeyToken=token, culture='neutral')
        ET.SubElement(item, 'bindingRedirect', oldVersion='0.0.0.0-' + version, newVersion=version)
    return ET.ElementTree(document)


def build(source, scratch, builder, specification):
    site = source / 'movil.no'
    binary = site / 'Bin'
    binary.mkdir(exist_ok=True)
    for name, version, digest, members in specification['packages']:
        with builder['official_package'](name, version, digest) as archive:
            for member in members:
                (binary / Path(member).name).write_bytes(archive.read(member))
    config(specification['binding_redirects'], binary).write(site / 'Web.config', encoding='utf-8', xml_declaration=True)
    startup = site / 'Global.asax'
    if startup.exists():
        raise RuntimeError('The archived prototype already has an entry point.')
    startup.write_bytes((DEMO / 'movil-prototype-startup.asax').read_bytes())
    compiler = Path(os.environ['WINDIR']) / 'Microsoft.NET/Framework/v4.0.30319/aspnet_compiler.exe'
    subprocess.run([compiler, '-v', '/', '-p', site, '-f', scratch / 'compiled'], check=True, cwd=site)
    print('The archived mobile prototype precompiled.', flush=True)
    return site


def stored_identity(connection):
    value = subprocess.check_output(['pwsh', '-NoProfile', '-Command',
        '$probe = [System.Data.SqlClient.SqlConnection]::new($env:DOMICILIO_PROTOTYPE_SQL);'
        'try { $probe.Open(); $query = $probe.CreateCommand();'
        " $query.CommandText = \"SELECT COUNT(*) FROM dbo.AspNetUsers WHERE UserName = N'operadora_demo'\";"
        ' $query.ExecuteScalar() } finally { $probe.Dispose() }'],
        env={**os.environ, 'DOMICILIO_PROTOTYPE_SQL': connection}, text=True, timeout=25)
    return value.strip() == '1'


def register(address, process, parser_type, request, connection):
    cookies = CookieJar()
    local_redirect = runpy.run_path(str(DEMO / 'run-movil.py'))['LocalRedirect']
    client = build_opener(ProxyHandler({}), HTTPCookieProcessor(cookies), local_redirect())
    page = address + '/Account/Register.aspx'
    for _ in range(60):
        try:
            status, _, contents = request(client, page)
            break
        except (URLError, ConnectionError):
            if process.poll() is not None:
                raise RuntimeError('IIS Express stopped before the prototype loaded.') from None
            time.sleep(.4)
    else:
        raise RuntimeError('The prototype did not respond on loopback.')
    if status != 200:
        raise RuntimeError(f'The prototype registration page returned HTTP {status}.')
    parser = parser_type()
    parser.feed(contents)
    (action, fields), = [(action, fields) for action, fields in parser.forms
                         if sum(name.endswith('$UserName') for name in fields) == 1]
    password = 'Demo!' + token_hex(10)
    for suffix, value in (('$UserName', ACCOUNT), ('$Password', password), ('$ConfirmPassword', password)):
        (key,) = (name for name in fields if name.endswith(suffix))
        fields[key] = value
    target = urljoin(page, action or page)
    if urlsplit(target).netloc != urlsplit(page).netloc:
        raise RuntimeError('The registration form points outside its local server.')
    status, _, _ = request(client, target, fields)
    signed_in = any(cookie.name == '.AspNet.ApplicationCookie' and cookie.value for cookie in cookies)
    stored = stored_identity(connection) if signed_in else False
    print(f'Registration HTTP {status}. Session cookie {signed_in}. SQL Server stored the fictional account {stored}.')
    if (status, signed_in, stored) != (302, True, True):
        raise RuntimeError('The registration did not create the expected local account.')


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--compile-only', action='store_true', help='precompile without starting a server')
    args = parser.parse_args()
    builder = runpy.run_path(str(DEMO / 'build-mvc.py'))
    common = runpy.run_path(str(DEMO / 'run-webforms.py'))
    mobile = runpy.run_path(str(DEMO / 'run-movil.py'))
    inputs = json.loads((DEMO / 'movil-prototype-packages.json').read_text(encoding='utf-8'))
    with TemporaryDirectory(prefix='domicilio-movil-prototype-') as directory:
        scratch = Path(directory)
        repo = DEMO.parent
        version = subprocess.check_output(['git', '-C', repo, 'rev-parse', 'HEAD'], text=True).strip()
        print(f'SHA {version}', flush=True)
        archive = scratch / 'candidate.zip'
        subprocess.run(['git', '-C', repo, 'archive', '-o', archive, '--format=zip', version], check=True)
        source = scratch / 'source'
        with ZipFile(archive) as package:
            builder['unpack'](package, source)
        site = build(source, scratch, builder, inputs)
        if not args.compile_only:
            with (common['sqlserver'](identity_demo=True) as connection,
                  common['web'](site, scratch, None, None, connection, sql_key='DefaultConnection') as (address, process)):
                register(address, process, common['LoginForm'], mobile['request'], connection)


if __name__ == '__main__':
    main()
