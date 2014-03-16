<%@ Page Title="Informes EPS" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="OrganizationExample51.aspx.cs" Inherits="auditoria_OrganizationExample51" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Desde</td>
            <td>
                Hasta</td>
            <td>Tipo</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
            <td>
                <asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="THasta" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td>
                <asp:DropDownList runat="server" ID="DTipo">
                    <asp:ListItem Text="OrganizationExample51" Value="GOrganizationExample51"></asp:ListItem>
                    <asp:ListItem Text="Aliansalud y Colmedica" Value="GColmedica"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <asp:GridView ID="GOrganizationExample51" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SOrganizationExample51" onrowdatabound="GOrganizationExample51_RowDataBound" >
            <Columns>
                <asp:BoundField HeaderText="Nombre del usuario" DataField="pacNombres" SortExpression="pacNombres" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="Edad" DataField="pacFechaNac" SortExpression="pacFechaNac" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Documento" DataField="pacDocumento" SortExpression="pacDocumento" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right"/>
                <asp:BoundField HeaderText="Producto" DataField="tipo" SortExpression="tipo" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="Diagnóstico" DataField="cied10" SortExpression="cied10" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="Servicio de enfermería" DataField="enfermeria" SortExpression="enfermeria" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Terapia física" DataField="tfisica" SortExpression="tfisica" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Terapia respiratoria" DataField="trespiratoria" SortExpression="trespiratoria" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Terapia ocupacional" DataField="tocupacional" SortExpression="tocupacional" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Terapia lenguaje" DataField="tlenguaje" SortExpression="tlenguaje" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Valoración médica" DataField="vmedica" SortExpression="vmedica" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="pacFecIngPrograma" SortExpression="pacFecIngPrograma" HeaderText="Fecha ingreso" DataFormatString="{0:d}" />
                <asp:BoundField HeaderText="Observaciones" DataField="pacObservaciones" SortExpression="pacObservaciones" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SOrganizationExample51" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT paciente.pacNombres,paciente.pacFechaNac,paciente.pacDocumento
    ,CASE paciente.entId WHEN 8 THEN 'MP' ELSE 'EPS' END AS tipo
    ,IFNULL(paciente.cieCodDx,'')+ ',' + IFNULL(paciente.cieCodDx_1,'') + ','+ IFNULL(paciente.cieCodDx_2,'') AS cied10
    ,paciente.pacFecIngPrograma
	,SUM(enfermeria.autNumSesiones) AS enfermeria
	,SUM(tfisica.autNumSesiones) AS tfisica
	,SUM(trespiratoria.autNumSesiones) AS trespiratoria
	,SUM(tocupacional.autNumSesiones) AS tocupacional
	,SUM(tlenguaje.autNumSesiones) AS tlenguaje
	,SUM(vmedica.autNumSesiones) AS vmedica
    ,paciente.pacObservaciones
    FROM paciente
    LEFT JOIN autorizacion ON (autorizacion.pacId=paciente.pacId)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5024,5025,10004,10005,10006,10007,10008,10009,10010,10011,10012,10015,10016,10022) GROUP BY autNumero) AS enfermeria ON (enfermeria.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5029,10023) GROUP BY autNumero) AS tfisica ON (tfisica.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5030,10024,10035) GROUP BY autNumero) AS trespiratoria ON (trespiratoria.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5031,10025) GROUP BY autNumero) AS tocupacional ON (tocupacional.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5028,10026) GROUP BY autNumero) AS tlenguaje ON (tlenguaje.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5021,5022,5033,10013,10029,10030,10031,10032,10033,10034) GROUP BY autNumero) AS vmedica ON (vmedica.autNumero=autorizacion.autNumero)
    WHERE paciente.entId IN (7,8)
    AND autorizacion.AutFecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
	GROUP BY paciente.pacNombres,paciente.pacFechaNac,paciente.pacDocumento,paciente.entId,paciente.pacFecIngPrograma,paciente.cieCodDx,paciente.cieCodDx_1,paciente.cieCodDx_2,paciente.pacObservaciones">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <asp:GridView ID="GColmedica" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SColmedica" onrowdatabound="GColmedica_RowDataBound" >
            <Columns>
                <asp:BoundField HeaderText="NUMERO" DataField="" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="REGIONAL" DataField="REGIONAL" SortExpression="REGIONAL" />
                <asp:BoundField HeaderText="CIUDAD" DataField="CIUDAD" SortExpression="CIUDAD" />
                <asp:BoundField HeaderText="IPS DOMICILIARIA" DataField="IPS DOMICILIARIA" SortExpression="IPS DOMICILIARIA" />
                <asp:BoundField HeaderText="PRODUCTO" DataField="PRODUCTO" SortExpression="PRODUCTO" />
                <asp:BoundField HeaderText="TUTELA" DataField="TUTELA" SortExpression="TUTELA" />
                <asp:BoundField HeaderText="PROGRAMA" DataField="PROGRAMA" SortExpression="PROGRAMA" />
                <asp:BoundField HeaderText="FECHA INGRESO DE AL PROGRAMA CRONICO" DataField="FECHA INGRESO DE AL PROGRAMA CRONICO" SortExpression="FECHA INGRESO DE AL PROGRAMA CRONICO" DataFormatString="{0:d}" />
                <asp:BoundField HeaderText="NOMBRE DEL PACIENTE" DataField="NOMBRE DEL PACIENTE" SortExpression="NOMBRE DEL PACIENTE" />
                <asp:BoundField HeaderText="TIPO ID" DataField="TIPO ID" SortExpression="TIPO ID" />
                <asp:BoundField HeaderText="IDENTIFICACION" DataField="IDENTIFICACION" SortExpression="IDENTIFICACION" />
                <asp:BoundField HeaderText="EDAD" DataField="EDAD" SortExpression="EDAD" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="DIRECCION" DataField="DIRECCION" SortExpression="DIRECCION" />
                <asp:BoundField HeaderText="TELEFONO" DataField="TELEFONO" SortExpression="TELEFONO" />
                <asp:BoundField HeaderText="DIAGNOSTICO PRINCIPAL" DataField="DIAGNOSTICO PRINCIPAL" SortExpression="DIAGNOSTICO PRINCIPAL" />
                <asp:BoundField HeaderText="CODIGO DE DX CIE-10" DataField="CODIGO DE DX CIE-10" SortExpression="CODIGO DE DX CIE-10" />
                <asp:BoundField HeaderText="DIAGNOSTICO SECUNDARIO" DataField="DIAGNOSTICO SECUNDARIO" SortExpression="DIAGNOSTICO SECUNDARIO" />
                <asp:BoundField HeaderText="OTROS DIAGNOSTICOS" DataField="OTROS DIAGNOSTICOS" SortExpression="OTROS DIAGNOSTICOS" />
                <asp:BoundField HeaderText="FECHA DE EGRESO DEL PROGRAMA" DataField="FECHA DE EGRESO DEL PROGRAMA" SortExpression="FECHA DE EGRESO DEL PROGRAMA" DataFormatString="{0:d}" />
                <asp:BoundField HeaderText="CAUSA EGRESO DEL PROGRAMA" DataField="CAUSA EGRESO DEL PROGRAMA" SortExpression="CAUSA EGRESO DEL PROGRAMA" />
                <asp:BoundField HeaderText="OBSERVACIONES DEL PRESTADOR" DataField="OBSERVACIONES DEL PRESTADOR" SortExpression="OBSERVACIONES DEL PRESTADOR" />
                <asp:BoundField HeaderText="CONSULTA MEDICA GENERAL" DataField="CONSULTA MEDICA GENERAL" SortExpression="CONSULTA MEDICA GENERAL" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="CONSULTA MEDICA ESPECIALIZADA" DataField="CONSULTA MEDICA ESPECIALIZADA" SortExpression="CONSULTA MEDICA ESPECIALIZADA" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="VISITA ENFERMERIA PROFESIONAL" DataField="VISITA ENFERMERIA PROFESIONAL" SortExpression="VISITA ENFERMERIA PROFESIONAL" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="ACTIVIDAD PUNTAL DE ENFERMERIA" DataField="ACTIVIDAD PUNTAL DE ENFERMERIA" SortExpression="ACTIVIDAD PUNTAL DE ENFERMERIA" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="CURACIONES" DataField="CURACIONES" SortExpression="CURACIONES" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="ENFERMERIA 3-6-8 HORAS" DataField="ENFERMERIA 3-6-8 HORAS" SortExpression="ENFERMERIA 3-6-8 HORAS" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="ENFERMERIA 12H" DataField="ENFERMERIA 12H" SortExpression="ENFERMERIA 12H" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="ENFERMERIA 24H" DataField="ENFERMERIA 24H" SortExpression="ENFERMERIA 24H" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="TERAPIA RESPIRATORIA" DataField="TERAPIA RESPIRATORIA" SortExpression="TERAPIA RESPIRATORIA" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="OXIGENOTERAPIA EN DOMICILIO" DataField="OXIGENOTERAPIA EN DOMICILIO" SortExpression="OXIGENOTERAPIA EN DOMICILIO" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="OXIMETRIAS" DataField="OXIMETRIAS" SortExpression="OXIMETRIAS" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="TERAPIA FISICA" DataField="TERAPIA FISICA" SortExpression="TERAPIA FISICA" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="TERAPIA OCUPACIONAL" DataField="TERAPIA OCUPACIONAL" SortExpression="TERAPIA OCUPACIONAL" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="FONOAUDIOLOGIA" DataField="FONOAUDIOLOGIA" SortExpression="FONOAUDIOLOGIA" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="CONSULTA NUTRICION" DataField="CONSULTA NUTRICION" SortExpression="CONSULTA NUTRICION" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="CONSULTA PSICOLOGIA" DataField="CONSULTA PSICOLOGIA" SortExpression="CONSULTA PSICOLOGIA" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="CONSULTA TRABAJO SOCIAL" DataField="CONSULTA TRABAJO SOCIAL" SortExpression="CONSULTA TRABAJO SOCIAL" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="TOMA DE EXAMENES DE LABORATORIO" DataField="TOMA DE EXAMENES DE LABORATORIO" SortExpression="TOMA DE EXAMENES DE LABORATORIO" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="PROCESAMIENTO EXAMENES DE LABORATORIO" DataField="PROCESAMIENTO EXAMENES DE LABORATORIO" SortExpression="PROCESAMIENTO EXAMENES DE LABORATORIO" ItemStyle-HorizontalAlign="Right" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SColmedica" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
	'Cundinamarca' AS REGIONAL
	,'Bogotá' AS CIUDAD
	,'OrganizationExample15' AS 'IPS DOMICILIARIA'
	,CASE paciente.entId WHEN 4 THEN 'EPS' WHEN 25 THEN 'MEDICINA PREPAGADA' ELSE 'CRUCE' END AS PRODUCTO
	,CASE paciente.pdirId WHEN 2 THEN 'SI' ELSE 'NO' END AS 'TUTELA'
	,tipo_evento.tipEDescripcion AS PROGRAMA
	,CASE paciente.tipECod WHEN 2 THEN paciente.pacFecIngPrograma ELSE NULL END AS 'FECHA INGRESO DE AL PROGRAMA CRONICO'
	,paciente.pacNombres AS 'NOMBRE DEL PACIENTE'
	,tipo_documento.tdocDescripcion AS 'TIPO ID'
	,paciente.pacDocumento AS 'IDENTIFICACION'
	,paciente.pacFechaNac AS 'EDAD'
	,paciente.pacDireccion AS 'DIRECCION'
	,paciente.pacTelefono AS 'TELEFONO'
	,cie10.cirDescripcion AS 'DIAGNOSTICO PRINCIPAL'
	,paciente.cieCodDx AS 'CODIGO DE DX CIE-10'
	,cie102.cirDescripcion AS 'DIAGNOSTICO SECUNDARIO'
	,cie103.cirDescripcion AS 'OTROS DIAGNOSTICOS'
	,CASE WHEN paciente.estId=2 THEN 
	(SELECT egrFecha FROM paciente_egreso WHERE pacId=paciente.pacId ORDER BY egrFecha DESC LIMIT 1) 
	ELSE NULL END AS 'FECHA DE EGRESO DEL PROGRAMA'
	,CASE WHEN paciente.estId=2 THEN 
	(SELECT causa_egreso.cegDescripcion FROM paciente_egreso LEFT JOIN causa_egreso ON (causa_egreso.cegId=paciente_egreso.cegId) WHERE pacId=paciente.pacId ORDER BY egrFecha DESC LIMIT 1) 
	ELSE NULL END AS 'CAUSA EGRESO DEL PROGRAMA'
	-- ,paciente_egreso.egrFecha  AS 'FECHA DE EGRESO DEL PROGRAMA'
	-- ,causa_egreso.cegDescripcion AS 'CAUSA EGRESO DEL PROGRAMA'
	,'' AS 'OBSERVACIONES DEL PRESTADOR'
	,SUM(medicog.autNumSesiones) AS 'CONSULTA MEDICA GENERAL'
	,SUM(medicoe.autNumSesiones) AS 'CONSULTA MEDICA ESPECIALIZADA'
	,SUM(enfermeriap.autNumSesiones) AS 'VISITA ENFERMERIA PROFESIONAL'
	,SUM(enfermeriapuntual.autNumSesiones) AS 'ACTIVIDAD PUNTAL DE ENFERMERIA'
	,SUM(curaciones.autNumSesiones) AS 'CURACIONES'
	,SUM(enfermeria368h.autNumSesiones) AS 'ENFERMERIA 3-6-8 HORAS'
	,SUM(enfermeria12.autNumSesiones) AS 'ENFERMERIA 12H'
	,SUM(enfermeria24.autNumSesiones) AS 'ENFERMERIA 24H'
	,SUM(trespiratoria.autNumSesiones)  AS 'TERAPIA RESPIRATORIA'
	,NULL  AS 'OXIGENOTERAPIA EN DOMICILIO'
	,SUM(oximetrias.autNumSesiones)  AS 'OXIMETRIAS'
	,SUM(tfisica.autNumSesiones)  AS 'TERAPIA FISICA'
	,SUM(tocupacional.autNumSesiones)  AS 'TERAPIA OCUPACIONAL'
	,SUM(fonoaudiologia.autNumSesiones)  AS 'FONOAUDIOLOGIA'
	,SUM(nutricion.autNumSesiones)  AS 'CONSULTA NUTRICION'
	,SUM(sicologia.autNumSesiones)  AS 'CONSULTA PSICOLOGIA'
	,SUM(tsocial.autNumSesiones)  AS 'CONSULTA TRABAJO SOCIAL'
	,SUM(laboratorio.autNumSesiones) AS 'TOMA DE EXAMENES DE LABORATORIO'
	,NULL AS 'PROCESAMIENTO EXAMENES DE LABORATORIO'
    FROM paciente
    LEFT JOIN autorizacion ON (autorizacion.pacId=paciente.pacId)
	LEFT JOIN tipo_documento ON (tipo_documento.tdocId=paciente.tdocId)
	LEFT JOIN cie10 ON (cie10.cieCodDx=paciente.cieCodDx)
	LEFT JOIN cie10 AS cie102 ON (cie102.cieCodDx=paciente.cieCodDx_1)
	LEFT JOIN cie10 AS cie103 ON (cie103.cieCodDx=paciente.cieCodDx_2)
	-- LEFT JOIN paciente_egreso ON (paciente.estId=2 AND paciente_egreso.pacId=paciente.pacId)
	-- LEFT JOIN causa_egreso ON (causa_egreso.cegId=paciente_egreso.cegId)
	LEFT JOIN tipo_evento ON (tipo_evento.tipECod=paciente.tipECod)
	-- LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5021,10013,10029) GROUP BY autNumero) AS medicog ON (medicog.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5022,10032,10033,10034) GROUP BY autNumero) AS medicoe ON (medicoe.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (10015,10022) OR (actId=5024 AND intensidad IN (204,219,220)) GROUP BY autNumero) AS enfermeriap ON (enfermeriap.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (10002,10003) OR (actId=5024 AND intensidad IN (197,201,203,213,214,216)) GROUP BY autNumero) AS enfermeriapuntual ON (enfermeriapuntual.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (10017) OR (actId=5024 AND intensidad IN (198,198,199,200)) GROUP BY autNumero) AS curaciones ON (curaciones.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (10009,10010,10011,10012) OR (actId=5024 AND intensidad IN (192,193)) GROUP BY autNumero) AS enfermeria368h ON (enfermeria368h.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (10001,10004,10005,10006,10007) OR (actId=5024 AND intensidad IN (194,195)) GROUP BY autNumero) AS enfermeria12 ON (enfermeria12.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (10008) OR (actId=5024 AND intensidad IN (196)) GROUP BY autNumero) AS enfermeria24 ON (enfermeria24.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (10024) GROUP BY autNumero) AS trespiratoria ON (trespiratoria.autNumero=autorizacion.autNumero)
	-- LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN () GROUP BY autNumero) AS oxigenoterapia ON (oxigenoterapia.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5030,10018,10027,10035) OR (actId=5024 AND intensidad IN (217)) GROUP BY autNumero) AS oximetrias ON (oximetrias.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5029,10023) GROUP BY autNumero) AS tfisica ON (tfisica.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5031,10025,10026) GROUP BY autNumero) AS tocupacional ON (tocupacional.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5028) OR (actId=5024 AND intensidad IN (218)) GROUP BY autNumero) AS fonoaudiologia ON (fonoaudiologia.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5025,10019) GROUP BY autNumero) AS nutricion ON (nutricion.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5026,10030) GROUP BY autNumero) AS sicologia ON (sicologia.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5027,10031) GROUP BY autNumero) AS tsocial ON (tsocial.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (10028) OR (actId=5024 AND intensidad IN (205)) GROUP BY autNumero) AS laboratorio ON (laboratorio.autNumero=autorizacion.autNumero)
	-- LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN () GROUP BY autNumero) AS prolaboratorio ON (prolaboratorio.autNumero=autorizacion.autNumero)
    WHERE paciente.entId IN (4,25,62) -- aliansalud, colmedica mp, cruce
    AND autorizacion.AutFecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
	GROUP BY 
	tipo_documento.tdocDescripcion
	,paciente.pdirId
	,paciente.tipECod
	,tipo_evento.tipEDescripcion
	,paciente.entId
	,paciente.pacDocumento
	,paciente.pacFechaNac
	,paciente.pacDireccion
	,paciente.pacTelefono
	,cie10.cirDescripcion
	,paciente.cieCodDx
	,cie102.cirDescripcion
	,cie103.cirDescripcion
	,paciente.pacId
	,paciente.estId
	-- ,paciente_egreso.egrFecha
	-- ,causa_egreso.cegDescripcion
	,paciente.pacNombres,paciente.pacFechaNac,paciente.pacDocumento,paciente.entId,paciente.pacFecIngPrograma,paciente.cieCodDx,paciente.cieCodDx_1,paciente.cieCodDx_2;
">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text" />
                 </SelectParameters>
    </asp:SqlDataSource>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
</asp:Content>

