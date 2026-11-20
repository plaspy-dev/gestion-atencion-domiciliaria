"""Compile the verified archived edition and test its local, fictional operator."""

from argparse import ArgumentParser
from contextlib import contextmanager
from html.parser import HTMLParser
from http.cookiejar import CookieJar
import os
from pathlib import Path
import re
from secrets import token_hex
import socket
import subprocess
from tempfile import TemporaryDirectory
import time
from urllib.parse import urlencode, urljoin, urlsplit
from urllib.error import HTTPError
from urllib.request import build_opener, HTTPCookieProcessor, HTTPRedirectHandler, ProxyHandler
from xml.etree import ElementTree as ET
from zipfile import ZipFile


VERIFIED_EDITION = '0133c745fde25672d3e35392d44642c069800548'
IMAGE = 'mysql@sha256:4bc6bc963e6d8443453676cae56536f4b8156d78bae03c0145cbe47c2aad73bb'
SQL_IMAGE = 'mcr.microsoft.com/mssql/server@sha256:4525e3efac9f3e241cb003bb2ff2a82818b502f37e12049d788b1a9fa7e13b7f'
DATABASE = 'domicilio_demo'
ACCOUNT = 'alicia_demo'
IIS = Path(os.environ.get('ProgramFiles', r'C:\Program Files')) / 'IIS Express'


def local_port():
    with socket.socket() as listener:
        listener.bind(('127.0.0.1', 0))
        return listener.getsockname()[1]


def docker(*args, data=None, env=None):
    return subprocess.run(['docker', *args], input=data, env=env, check=True,
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout


@contextmanager
def mysql(password):
    env = {**os.environ, 'MYSQL_ROOT_PASSWORD': token_hex(18)}
    identity = docker('run', '--rm', '-d', '--pull', 'never',
                      '--name', 'prueba-gestion-atencion-domiciliaria-' + token_hex(4) + '-mysql',
                      '-p', '127.0.0.1::3306', '-e', 'MYSQL_ROOT_PASSWORD',
                      '-e', f'MYSQL_DATABASE={DATABASE}', IMAGE, env=env).decode().strip()
    if not re.fullmatch('[0-9a-f]{64}', identity):
        raise RuntimeError('Docker did not return the disposable MySQL container ID.')
    sql = ('MYSQL_PWD="$MYSQL_ROOT_PASSWORD" exec mysql --protocol=TCP -h 127.0.0.1 '
           '--user=root --batch --skip-column-names "$MYSQL_DATABASE"')

    def query(text):
        return docker('exec', '-i', identity, 'sh', '-ec', sql, data=text.encode())

    try:
        for _ in range(105):
            try:
                if query('SELECT 1;').strip() == b'1':
                    break
            except subprocess.CalledProcessError:
                time.sleep(.45)
        else:
            raise RuntimeError('The disposable MySQL server did not start.')
        table = f'''
CREATE TABLE usuario (id BIGINT PRIMARY KEY, nombre VARCHAR(150), usuario VARCHAR(150),
    contrasena VARCHAR(150), grupo INT, marcas VARCHAR(150), estado INT NULL, ingreso DATETIME NULL);
CREATE TABLE permisos (grupo INT, url VARCHAR(150), permiso INT);
CREATE TABLE modificaciones (id VARCHAR(80), url VARCHAR(180), fecha DATETIME, usuario BIGINT);
INSERT INTO usuario VALUES (781,'Alicia Ejemplo','{ACCOUNT}',PASSWORD('{password}'),0,'',NULL,NULL);
INSERT INTO permisos VALUES (0,'Inicio.aspx',1);
CREATE USER 'domicilio_demo'@'%' IDENTIFIED BY '{password}';
GRANT SELECT, UPDATE ON {DATABASE}.* TO 'domicilio_demo'@'%';
'''
        query(table)
        binding = docker('port', identity, '3306/tcp').decode().strip()
        assigned = re.fullmatch(r'127\.0\.0\.1:(\d+)', binding)
        if assigned is None or assigned[1] == '3306':
            raise RuntimeError('Expected a separate MySQL port on loopback.')
        yield int(assigned[1]), query
    finally:
        docker('rm', '-f', identity)


@contextmanager
def sqlserver():
    env = {**os.environ, 'MSSQL_SA_PASSWORD': 'Demo1!' + token_hex(18)}
    identity = docker('run', '--rm', '-d', '--pull', 'never',
                      '--name', 'prueba-gestion-atencion-domiciliaria-' + token_hex(4) + '-sqlserver',
                      '-p', '127.0.0.1::1433', '-e', 'ACCEPT_EULA=Y',
                      '-e', 'MSSQL_PID=Developer', '-e', 'MSSQL_SA_PASSWORD', SQL_IMAGE, env=env).decode().strip()
    if not re.fullmatch('[0-9a-f]{64}', identity):
        raise RuntimeError('Docker did not return the disposable SQL Server container ID.')
    sql = ('SQLCMDPASSWORD="$MSSQL_SA_PASSWORD" exec /opt/mssql-tools18/bin/sqlcmd '
           '-S 127.0.0.1 -U sa -C -b -l 4')

    def query(text):
        return docker('exec', '-i', identity, 'sh', '-ec', sql, data=text.encode())

    try:
        ready_until = time.monotonic() + 600
        while time.monotonic() < ready_until:
            try:
                query('SELECT 1;\nGO\n')
                break
            except subprocess.CalledProcessError:
                time.sleep(.65)
        else:
            raise RuntimeError('The disposable SQL Server did not start.')
        account_password = 'Demo1!' + token_hex(18)
        query(f"""
CREATE DATABASE domicilio_demo_sql;
GO
CREATE LOGIN domicilio_demo WITH PASSWORD='{account_password}';
GO
USE domicilio_demo_sql;
GO
CREATE USER domicilio_demo FOR LOGIN domicilio_demo;
ALTER ROLE db_datareader ADD MEMBER domicilio_demo;
CREATE TABLE dbo.seg_menu (
    meidmenu INT PRIMARY KEY, meidmenupadre INT NULL, medescmenu NVARCHAR(100), meruta VARCHAR(150)
);
GO
CREATE FUNCTION dbo.fnseg_conmenu(@usuario VARCHAR(150), @flag INT)
RETURNS TABLE AS RETURN
SELECT 81 AS idmenu, 1 AS ins, 1 AS modif, 1 AS elim WHERE @usuario='alicia_demo';
GO
INSERT INTO dbo.seg_menu VALUES (81, NULL, 'Inicio de demostracion', '~/Inicio.aspx');
GO
""")
        binding = docker('port', identity, '1433/tcp').decode().strip()
        assigned = re.fullmatch(r'127\.0\.0\.1:(\d+)', binding)
        if assigned is None:
            raise RuntimeError('Expected SQL Server on loopback.')
        yield (f'Data Source=127.0.0.1,{assigned[1]};Initial Catalog=domicilio_demo_sql;'
               f'User ID=domicilio_demo;Password={account_password};TrustServerCertificate=True;')
    finally:
        docker('rm', '-f', identity)


def write_web_config(config, path):
    # System.Configuration expects the assembly namespace on assemblyBinding.
    raw = ET.tostring(config.getroot(), encoding='utf-8', xml_declaration=True)
    namespace = b'urn:schemas-microsoft-com:asm.v1'
    match = re.search(rb'\sxmlns:(ns\d+)="' + re.escape(namespace) + rb'"', raw)
    if match:
        prefix = match[1] + b':'
        raw = raw[:match.start()] + raw[match.end():]
        raw = raw.replace(b'<' + prefix + b'assemblyBinding',
                          b'<assemblyBinding xmlns="' + namespace + b'"')
        raw = raw.replace(b'<' + prefix, b'<').replace(b'</' + prefix, b'</')
    ET.fromstring(raw)
    path.write_bytes(raw)


@contextmanager
def web(site, root, db_port, password, sql_config):
    config = ET.parse(site / 'Web.config')
    settings = config.find('appSettings')
    if settings is None:
        settings = ET.SubElement(config.getroot(), 'appSettings')
    for key, value in (('app', 'domicilio'), ('filelogs', str(root / 'application.log'))):
        for old in settings.findall('add'):
            if old.get('key') == key:
                settings.remove(old)
        ET.SubElement(settings, 'add', key=key, value=value)
    connections = config.find('connectionStrings')
    if connections is None:
        connections = ET.SubElement(config.getroot(), 'connectionStrings')
    for entry in list(connections):
        connections.remove(entry)
    ET.SubElement(connections, 'add', name='MySQLConnectionString',
                  providerName='MySql.Data.MySqlClient',
                  connectionString=f'Server=127.0.0.1;Port={db_port};Database={DATABASE};Uid=domicilio_demo;Pwd={password};')
    ET.SubElement(connections, 'add', name='ConnBD', providerName='System.Data.SqlClient',
                  connectionString=sql_config)
    application = config.find('system.web')
    errors = application.find('customErrors')
    if errors is None:
        errors = ET.SubElement(application, 'customErrors')
    errors.set('mode', 'Off')
    write_web_config(config, site / 'Web.config')
    port = local_port()
    host = ET.parse(IIS / 'config/templates/PersonalWebServer/applicationhost.config')
    sites = host.find('./system.applicationHost/sites')
    for item in sites.findall('site'):
        sites.remove(item)
    app = ET.SubElement(sites, 'site', name='HomeCareDemo', id='1')
    alias = '/domicilio'
    for path in ('/', alias):
        scope = ET.SubElement(app, 'application', path=path, applicationPool='Clr4IntegratedAppPool')
        ET.SubElement(scope, 'virtualDirectory', path='/', physicalPath=str(site))
    ET.SubElement(ET.SubElement(app,'bindings'), 'binding', protocol='http',
                  bindingInformation=f'127.0.0.1:{port}:127.0.0.1')
    host_config = root / 'applicationhost.config'
    host.write(host_config, encoding='utf-8', xml_declaration=True)
    env = {**os.environ, 'IIS_USER_HOME': str(root / 'IISExpress')}
    for suffix in ('', '_2', '_3', '_4', '_5'):
        env['DOMICILIO_SESSION_KEY' + suffix] = token_hex(4)
    address = f'http://127.0.0.1:{port}{alias}'
    with (root / 'iis.log').open('wb') as report, subprocess.Popen(
        [IIS / 'iisexpress.exe', f'/config:{host_config}', '/site:HomeCareDemo', '/systray:false'],
        env=env, cwd=site, stdout=report, stderr=subprocess.STDOUT, creationflags=subprocess.CREATE_NO_WINDOW,
    ) as process:
        try:
            yield address, process
        finally:
            if process.poll() is None:
                process.terminate()
            process.wait(timeout=15)


class LoginForm(HTMLParser):
    def __init__(self):
        super().__init__()
        self.forms = []
        self.current = None

    def handle_starttag(self, tag, attributes):
        fields = dict(attributes)
        if tag == 'form':
            self.current = (fields.get('action', ''), {})
            self.forms.append(self.current)
        elif tag == 'input' and self.current and 'name' in fields:
            self.current[1][fields['name']] = fields.get('value', '')

    def handle_endtag(self, tag):
        if tag == 'form':
            self.current = None


def login(address, process, password, query):
    origin = urlsplit(address).netloc

    class LoopbackOnly(HTTPRedirectHandler):
        def redirect_request(self, request, fp, status, message, headers, newurl):
            if urlsplit(newurl).netloc != origin or not newurl.startswith('http://'):
                raise RuntimeError('The historical app redirected outside the local test.')
            return super().redirect_request(request, fp, status, message, headers, newurl)

    cookies = CookieJar()
    client = build_opener(ProxyHandler({}), HTTPCookieProcessor(cookies), LoopbackOnly())
    for _ in range(65):
        try:
            with client.open(address + '/Default.aspx', timeout=20) as response:
                page = response.read().decode('utf-8', errors='replace')
                form_url = response.url
            break
        except OSError:
            if process.poll() is not None:
                raise RuntimeError('The local IIS Express process stopped.') from None
            time.sleep(.4)
    else:
        raise RuntimeError('The local sign-in page did not become available.')
    markup = LoginForm()
    markup.feed(page)
    action, fields = next(form for form in markup.forms
                          if any(name.lower().endswith('m_econtrasena') for name in form[1]))
    fields[next(name for name in fields if name.lower().endswith('m_eusuario'))] = ACCOUNT
    fields[next(name for name in fields if name.lower().endswith('m_econtrasena'))] = password
    target = urljoin(form_url, action)
    if urlsplit(target).netloc != origin or not target.startswith('http://'):
        raise RuntimeError('The sign-in form points outside the local test.')
    try:
        with client.open(target, data=urlencode(fields).encode(), timeout=30) as response:
            content = response.read().decode('utf-8', errors='replace')
            page_passed = (
                response.status == 200
                and urlsplit(response.url).path.casefold() == '/domicilio/inicio.aspx'
                and 'Alicia Ejemplo' in content
            )
    except HTTPError as error:
        content = error.read(100000).decode('utf-8', errors='replace')
        kinds = sorted(set(re.findall(r'\b[A-Za-z]+Exception\b', content)))
        raise RuntimeError(f'Local sign-in failed with HTTP {error.code} ({kinds}).') from None
    names = {cookie.name.casefold() for cookie in cookies if cookie.value}
    receipt = query('SELECT COUNT(*) FROM usuario WHERE id=781 AND ingreso IS NOT NULL;').strip()
    if not page_passed or 'usuario' not in names or receipt != b'1':
        raise RuntimeError('The fictional session or its MySQL record was not verified.')
    print('The Web Forms demo reached its protected home page and recorded the fictional sign-in in MySQL.', flush=True)


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--serve', action='store_true', help='keep the verified example running until Ctrl+C')
    parser.add_argument('--repo', type=Path, default=Path(__file__).resolve().parents[1])
    options = parser.parse_args()
    password = os.environ.get('DOMICILIO_DEMO_PASSWORD', '') if options.serve else token_hex(8)
    if not re.fullmatch('[0-9a-fA-F]{16}', password):
        parser.error('For --serve, set DOMICILIO_DEMO_PASSWORD to 16 hexadecimal characters for the fictional user.')
    with TemporaryDirectory(prefix='home-care-webforms-demo-') as directory:
        root = Path(directory)
        archive = root / 'edition.zip'
        subprocess.run(['git', '-C', options.repo, 'archive', '--format=zip', '-o', archive, VERIFIED_EDITION], check=True)
        with ZipFile(archive) as contents:
            contents.extractall(root / 'edition')
        subprocess.run(['pwsh', '-NoProfile', '-File', 'demo/Build.ps1', '-Output', root / 'application'],
                       cwd=root / 'edition', check=True)
        with (mysql(password) as (port, query), sqlserver() as sql_config,
              web(root / 'application/site', root, port, password, sql_config) as (url, service)):
            login(url, service, password, query)
            if options.serve:
                print(f'{url}/Default.aspx · {ACCOUNT} · Ctrl+C to stop.', flush=True)
                try:
                    service.wait()
                except KeyboardInterrupt:
                    pass


if __name__ == '__main__':
    main()
