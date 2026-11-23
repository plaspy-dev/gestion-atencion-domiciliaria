"""Exercise the protected Web Forms pages and the discharge download in the MVC packages."""

from io import BytesIO
from urllib.error import HTTPError
from urllib.parse import urlencode
from urllib.request import Request
from xml.etree import ElementTree
from zipfile import ZipFile, is_zipfile


ROUTES = (
    '/programacion/programacion.aspx',
    '/paciente/paciente.aspx',
    '/rh/funcionario.aspx',
    '/administrador/usuario.aspx',
)


def verify_pages(request, client, address):
    complete = True
    for route in ROUTES:
        status, document = request(client, address + route)
        opened = status == 200 and '__VIEWSTATE' in document
        print(f'Web Forms {route}: HTTP {status}. Server-rendered form {opened}.')
        complete &= opened
    if not complete:
        raise RuntimeError('At least one Web Forms page did not return its form.')


def verify_discharge_workbook(request, client, address, query, form_parser):
    query("""
ALTER TABLE paciente ADD pacDocumento VARCHAR(80), ADD entId INT, ADD egresoClinicaHeridas DATE;
INSERT INTO paciente (pacId,pacNombres,pacDocumento,entId,egresoClinicaHeridas)
VALUES (9401,'Paciente Ficticio de Visitas','DEMO-9401',71,'2020-02-12');
""")
    route = address + '/ClinicaHeridas/Egresos'
    status, document = request(client, route)
    if status != 200:
        raise RuntimeError(f'The discharge form returned HTTP {status}.')
    parsed = form_parser()
    parsed.feed(document)
    values = {'Desde':'2020-02-01', 'Hasta':'2020-02-29', 'Entidad':'71'}
    for _, fields in parsed.forms:
        if '__RequestVerificationToken' in fields:
            values['__RequestVerificationToken'] = fields['__RequestVerificationToken']
            break
    try:
        response = client.open(Request(route,data=urlencode(values).encode()), timeout=30)
    except HTTPError as error:
        raise RuntimeError(f'The discharge download returned HTTP {error.code}.') from error
    with response:
        code = response.code
        media = response.headers.get_content_type()
        attached = 'attachment' in response.headers.get('Content-Disposition','').casefold()
        payload = BytesIO(response.read(1_000_001))
    worksheet = matched = False
    if is_zipfile(payload):
        with ZipFile(payload) as workbook:
            sheet = ElementTree.fromstring(workbook.read('xl/worksheets/sheet1.xml'))
            worksheet = sheet.tag == '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}worksheet'
            matched = 'Paciente Ficticio de Visitas' in ''.join(sheet.itertext())
    print(f'Excel discharge download HTTP {code}. MIME {media}. Attachment {attached}. '
          f'Open XML worksheet {worksheet}. Fictional discharge row {matched}.')
    if not (code == 200 and media == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            and attached and worksheet and matched):
        raise RuntimeError('The download did not contain the expected fictional discharge workbook.')
