CREATE TABLE archivos_temporales (
    archivo VARCHAR(190) PRIMARY KEY, original VARCHAR(190), fecha DATETIME
);
CREATE TABLE impresiones LIKE modificaciones;
CREATE TABLE usuario_alerta (tarId INT, usIdUsuario VARCHAR(150));
CREATE TABLE alerta (tarId INT PRIMARY KEY, tarTitulo VARCHAR(150), consulta TEXT,
    url VARCHAR(180), consultaCount TEXT, MySQL INT);
CREATE TABLE cargo (carId INT PRIMARY KEY, carDescripcion VARCHAR(120));
INSERT INTO cargo VALUES (42,'Coordinacion ficticia');
CREATE TABLE tipo_documento (tdocId INT PRIMARY KEY, tdocDescripcion VARCHAR(120));
INSERT INTO tipo_documento VALUES (7,'Documento ficticio');
CREATE TABLE varios (id INT PRIMARY KEY, nombre VARCHAR(100), descripcion VARCHAR(100),
    tipo INT, eliminado DATETIME, szReservado VARCHAR(100));
CREATE TABLE directorio (perId INT PRIMARY KEY, acta INT, actm INT, pacienteh INT,
    fechaf DATETIME, pacientef INT);
CREATE TABLE programacion (perId INT, actId INT, prgFechaProg DATETIME, prgActivo INT, pacId INT);
ALTER TABLE programacion ADD autNumero VARCHAR(60);
CREATE TABLE estado_civil (estCivilId INT PRIMARY KEY, estCivDescripcion VARCHAR(120), estCivCompanero INT);
INSERT INTO estado_civil VALUES (1,'Estado civil ficticio',0);
CREATE TABLE localidad (locId INT PRIMARY KEY, locDescripcion VARCHAR(120));
INSERT INTO localidad VALUES (1,'Localidad ficticia');
CREATE TABLE paciente_tipo_pago (pdirId INT PRIMARY KEY, pdirDescripcion VARCHAR(120), pdirActivo INT);
CREATE TABLE paciente_estado (estId INT PRIMARY KEY, estDesc VARCHAR(120));
CREATE TABLE tipo_evento (tipECod INT PRIMARY KEY, tipEDescripcion VARCHAR(120), tipEActivo INT);
CREATE TABLE recurso_humano (perId INT PRIMARY KEY, perNombre VARCHAR(120), eEstId INT, carId INT);
CREATE TABLE funcionario_estados (eEstId INT PRIMARY KEY, eEstDesc VARCHAR(120));
CREATE TABLE tipo_contrato (tipContId INT PRIMARY KEY, tipContDesc VARCHAR(120));
CREATE TABLE area (areaId INT PRIMARY KEY, areaDesc VARCHAR(120));
CREATE TABLE disponibilidad (dispId INT PRIMARY KEY, dispDescripcion VARCHAR(120));
CREATE TABLE banco (banId INT PRIMARY KEY, banDesc VARCHAR(120));
CREATE TABLE motivo_retiro (mteId INT PRIMARY KEY, mteDescripcion VARCHAR(120));
CREATE TABLE profesion (profId INT PRIMARY KEY, profNombre VARCHAR(120));
CREATE TABLE funcionario_documentos (docId INT PRIMARY KEY, docDesc VARCHAR(120), docTipoEntrega INT);
CREATE TABLE recurso_humano_documento (perId INT, docId INT, archivo VARCHAR(120), vencimiento DATE);
CREATE TABLE funcionario_formacion (ipId INT PRIMARY KEY, ipDescripcion VARCHAR(120));
CREATE TABLE recurso_humano_formacion (perId INT, ipId INT, infAno INT, infInstitucion VARCHAR(120),
    profId INT, infNroActa VARCHAR(120));
CREATE TABLE recurso_humano_curso (funcionario INT, curso INT, vencimiento DATE);
CREATE TABLE paciente (pacId INT PRIMARY KEY, pacNombres VARCHAR(120));
CREATE TABLE medicamentos (id INT PRIMARY KEY, nombre VARCHAR(120));
CREATE TABLE causa_reingreso (cingId INT PRIMARY KEY, cingDescripcion VARCHAR(120));
CREATE TABLE causa_egreso (cegId INT PRIMARY KEY, cegDescripcion VARCHAR(120));
CREATE TABLE paciente_auditoria_servicios (pacId INT, cingId INT, cegId INT, audIngreso DATE,
    audEgreso DATE, audUsuario VARCHAR(120), audFecha DATETIME, audObs TEXT, segFechaIngreso DATE);
