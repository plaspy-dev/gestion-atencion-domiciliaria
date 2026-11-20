<%@ Page Title="Informes EPS" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="auditoria_OrganizationExample51" Codebehind="OrganizationExample51.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .top {
            vertical-align: top;
        }
    </style>
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
            <td>Tipo Evento</td>
            <td>Documento</td>
            <td>&nbsp;</td>
        </tr>
        <tr class="top">
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
                    <asp:ListItem Text="SuperSalud" Value="GSuperSalud"></asp:ListItem>
                    <asp:ListItem Text="Compensar" Value="GMalla"></asp:ListItem>
                    <asp:ListItem Text="Seguimiento diario" Value="GSeguimiento"></asp:ListItem>
                    <asp:ListItem Text="Crónicos Famisanar" Value="GCronicosFamisanar"></asp:ListItem>
                    <asp:ListItem Text="Malla facturación Compensar" Value="GFacturacionCompensar"></asp:ListItem>
                    <asp:ListItem Text="Cómite Historias clínicas" Value="GHC"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList ID="DTipoEvento" runat="server" 
                                            DataSourceID="STipoEvento" DataTextField="nombre" 
                                            DataValueField="id" AppendDataBoundItems="true">
                                            <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                            </asp:DropDownList>
                            <asp:SqlDataSource ID="STipoEvento" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT tipECod id,tipEDescripcion nombre FROM tipo_evento WHERE tipEActivo=1">
                            </asp:SqlDataSource>
            </td>
            <td>
                <asp:TextBox runat="server" ID="TDocumentos" TextMode="MultiLine"></asp:TextBox>
            </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />

    <asp:GridView ID="GMalla" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SMalla">
            <Columns>
                <asp:TemplateField HeaderText="MES" SortExpression="fecha">
                    <ItemTemplate>
                        <asp:HyperLink runat="server" ID="H" Target="_blank" Text='<%# string.Format("{0:MMMM}", (DateTime)Eval("fecha")) %>' NavigateUrl='<%# string.Format("~/paciente/formulacion.aspx?fid={0}", Eval("id")) %>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField HeaderText="IPS DOMICILIARIA" DataField="ips" SortExpression="ips" />
                <asp:BoundField HeaderText="FECHA DE PRESENTACION" SortExpression="fpresentacion" DataField="fpresentacion" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:d}" />
                <asp:BoundField HeaderText="HORA PRESENTACION" SortExpression="hpresentacion" DataField="hpresentacion" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="DOCUMENTO" DataField="pacDocumento" SortExpression="pacDocumento" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="NOMBRES COMPLETOS" DataField="pacNombres" SortExpression="pacNombres" />
                <asp:BoundField HeaderText="EDAD" DataField="edad" SortExpression="edad" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="PLAN DE BENEFICIOS" DataField="plan" SortExpression="plan" />
                <asp:BoundField HeaderText="DIRECCION" DataField="pacDireccion" SortExpression="pacDireccion" />
                <asp:BoundField HeaderText="BARRIO" DataField="pacBarrio" SortExpression="pacBarrio" />
                <asp:BoundField HeaderText="LOCALIDAD" DataField="locDescripcion" SortExpression="locDescripcion" />
                <asp:BoundField HeaderText="CODIGO CIE10" DataField="cieCodDx" SortExpression="cieCodDx" />
                <asp:BoundField HeaderText="DX" DataField="cirDescripcion" SortExpression="cirDescripcion" />
                <asp:BoundField HeaderText="TRATAMIENTO" />
                <asp:BoundField HeaderText="MEICAMENTO 1" />
                <asp:BoundField HeaderText="DOSIS" />
                <asp:BoundField HeaderText="FRECUENCIA" />
                <asp:BoundField HeaderText="MEDICAMENTO 2" />
                <asp:BoundField HeaderText="DOSIS" />
                <asp:BoundField HeaderText="FRECUENCIA" />
                <asp:BoundField HeaderText="TR" DataField="TR" SortExpression="TR" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="TF" DataField="TF" SortExpression="TF" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="TL" DataField="TL" SortExpression="TL" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="TO" DataField="TO" SortExpression="TO" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="VM" DataField="VM" SortExpression="VM" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="NUTRICION" DataField="nutricion" SortExpression="nutricion" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="ENFERMERIA " DataField="enfermeria" SortExpression="enfermeria" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="CURACION" DataField="curacion" SortExpression="curacion" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="PSICOLOGÍA" DataField="psicologia" SortExpression="psicologia" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="TRABAJO SOCIAL" DataField="trabajosocial" SortExpression="trabajosocial" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="FECHA VALORACION DE EGRESO" DataField="fechavaloracionegreso" SortExpression="fechavaloracionegreso" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="HORA DE VALORACION DE EGRESO" DataField="horavaloracionegreso" SortExpression="horavaloracionegreso" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="IPS REMITE" DataField="IPSRemitente" SortExpression="IPSRemitente"  />
                <asp:BoundField HeaderText="SERVICIO/IPS"  />
                <asp:BoundField HeaderText="PACIENTE APTO"  />
                <asp:BoundField HeaderText="CAUSA DE NO INGRESO" />
                <asp:BoundField HeaderText="EGRESO (SI ó NO)" />
                <asp:BoundField HeaderText="CORREO/ PERSONA REPORTE" DataField="correo" SortExpression="correo" />
                <asp:BoundField HeaderText="FECHA INICIO PRESTACION (Solo PHD)" DataField="fechainicio" SortExpression="fechainicio" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:d}" />
                <asp:BoundField HeaderText="FECHA FINALIZACION SERVICIOS (Solo PHD)" DataField="fechafinalizacion" SortExpression="fechafinalizacion" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:d}" />
                <asp:BoundField HeaderText="DIAS DE ESTANCIA" DataField="diasestancia" SortExpression="diasestancia" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="FECHA VALORACION FINAL (Solo PHD)" DataField="fechavaloracion" SortExpression="fechavaloracion" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:d}" />
                <asp:BoundField HeaderText="HOSPITALIZADO" />
                <asp:BoundField HeaderText="RE-HOSPITALIZACION" DataField="rehospitalizado" SortExpression="rehospitalizado" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:d}" />
                <asp:BoundField HeaderText="OBSERVACIONES" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SMalla" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="
        SELECT paciente.pacId,formulacion.id
,MAX(paciente.pacFecIngPrograma) fecha
,'OrganizationExample15' ips
,COUNT(medicamento_formulacion.id) item
,NULL presentacion
,paciente.pacDocumento
,paciente.pacNombres
,TIMESTAMPDIFF(YEAR, paciente.pacFechaNac, NOW()) AS edad
,paciente_tipo_pago.pdirDescripcion plan
,paciente.pacDireccion
,paciente.pacBarrio
,localidad.locDescripcion
,paciente.cieCodDx
,cie10.cirDescripcion
,paciente.presentacion fpresentacion
,TIME(paciente.presentacion) hpresentacion
,NULL tratamiento
,NULL medicamento1
,NULL dosis1
,NULL frecuencia1
,NULL medicamento2
,NULL dosis2
,NULL frecuencia2
,ips.nombre IPSRemitente
,SUM(IF(medicamento_formulacion.medicamento IN (5030,10024,10035), IF(medicamento_formulacion.formulada=0, 1, medicamento_formulacion.formulada), NULL)) TR
,SUM(IF(medicamento_formulacion.medicamento IN (5029,10023), IF(medicamento_formulacion.formulada=0, 1, medicamento_formulacion.formulada), NULL)) TF
,SUM(IF(medicamento_formulacion.medicamento IN (5028,10026), IF(medicamento_formulacion.formulada=0, 1, medicamento_formulacion.formulada), NULL)) TL
,SUM(IF(medicamento_formulacion.medicamento IN (5031,10025), IF(medicamento_formulacion.formulada=0, 1, medicamento_formulacion.formulada), NULL)) 'TO'
,SUM(IF(medicamento_formulacion.medicamento IN (5021,10013), IF(medicamento_formulacion.formulada=0, 1, medicamento_formulacion.formulada), NULL)) VM
,SUM(IF(medicamento_formulacion.medicamento IN (5025), IF(medicamento_formulacion.formulada=0, 1, medicamento_formulacion.formulada), NULL)) nutricion
,SUM(IF(medicamento_formulacion.medicamento IN (5024,10004,10005,10008,10009,10010,10011,10012,10022,12450,12451,12480,12452,13792,12453,12454,12481,12456,12457,12458), IF(medicamento_formulacion.formulada=0, 1, medicamento_formulacion.formulada), NULL)) enfermeria
,SUM(IF(medicamento_formulacion.medicamento IN (12463,12464,12462), IF(medicamento_formulacion.formulada=0, 1, medicamento_formulacion.formulada), NULL)) curacion 
,SUM(IF(medicamento_formulacion.medicamento IN (5026), IF(medicamento_formulacion.formulada=0, 1, medicamento_formulacion.formulada), NULL)) psicologia 
,SUM(IF(medicamento_formulacion.medicamento IN (5027), IF(medicamento_formulacion.formulada=0, 1, medicamento_formulacion.formulada), NULL)) trabajosocial
,CONCAT(
	IFNULL((SELECT DATE(programacion.prgFechaProg) FROM programacion WHERE programacion.pacId=paciente.pacId AND actId=12465 ORDER BY programacion.prgFechaProg LIMIT 1),'')
    ,','
    ,IFNULL((SELECT DATE(programacion.prgFechaProg) FROM programacion WHERE programacion.pacId=paciente.pacId AND actId=5021 ORDER BY programacion.prgFechaProg LIMIT 1),'')
    ,','
    ,IFNULL((SELECT DATE(programacion.prgFechaProg) FROM programacion WHERE programacion.pacId=paciente.pacId AND actId=10022 ORDER BY programacion.prgFechaProg LIMIT 1),'')
) fechavaloracionegreso
,CONCAT(
	IFNULL((SELECT TIME(programacion.segFechaIngreso) FROM programacion WHERE programacion.pacId=paciente.pacId AND actId=12465 ORDER BY programacion.prgFechaProg LIMIT 1),'')
    ,','
    ,IFNULL((SELECT TIME(programacion.segFechaIngreso) FROM programacion WHERE programacion.pacId=paciente.pacId AND actId=5021 ORDER BY programacion.prgFechaProg LIMIT 1),'')
    ,','
    ,IFNULL((SELECT TIME(programacion.segFechaIngreso) FROM programacion WHERE programacion.pacId=paciente.pacId AND actId=10022 ORDER BY programacion.prgFechaProg LIMIT 1),'')
) horavaloracionegreso
,NULL ips
,NULL servicio
,NULL pacienteapto
,NULL causaingreso
,'auditoria@equipo-demo.example.invalid' correo
,(SELECT MIN(programacion.prgFechaProg) FROM programacion WHERE programacion.pacId=paciente.pacId AND actId IN (12481,12456,12457,12458,12462,12463,12464,12484,5028,5029,5030,5031)) fechainicio
,(SELECT MAX(programacion.prgFechaProg) FROM programacion WHERE programacion.pacId=paciente.pacId AND actId IN (12481,12456,12457,12458,12462,12463,12464,12484,5028,5029,5030,5031)) fechafinalizacion 
,TIMESTAMPDIFF(DAY
	,(SELECT MIN(programacion.prgFechaProg) FROM programacion WHERE programacion.pacId=paciente.pacId AND actId IN (12481,12456,12457,12458,12462,12463,12464,12484,5028,5029,5030,5031))
    ,(SELECT MAX(programacion.prgFechaProg) FROM programacion WHERE programacion.pacId=paciente.pacId AND actId IN (12481,12456,12457,12458,12462,12463,12464,12484,5028,5029,5030,5031))
) diasestancia
,(SELECT fecha FROM evolucion_paciente WHERE evolucion_paciente.paciente=paciente.pacId ORDER BY fecha DESC LIMIT 1) fechavaloracion
,NULL hospitalizado
,(SELECT MAX(audFecha) from paciente_auditoria_servicios WHERE paciente_auditoria_servicios.pacId=paciente.pacId AND paciente_auditoria_servicios.cegId IN (3,4,5)) rehospitalizado
,NULL observaciones
FROM paciente
LEFT JOIN formulacion ON (formulacion.paciente=paciente.pacId AND formulacion.fecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') AND formulacion.tipo=173)
LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id)
LEFT JOIN varios AS ips ON (ips.id=paciente.ips_remitente)
LEFT JOIN paciente_tipo_pago ON (paciente.pdirId = paciente_tipo_pago.pdirId)
LEFT JOIN localidad ON (localidad.locId=paciente.locId)
LEFT JOIN cie10 ON (cie10.cieCodDx=paciente.cieCodDx)
                    WHERE 
                    paciente.pacFecIngPrograma BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                    AND paciente.entId IN (9,69)
                    AND (@tipoevento=0 OR paciente.tipECod=@tipoevento)
                    GROUP BY paciente.pacId
        ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text" />
                     <asp:ControlParameter ControlID="DTipoEvento" Name="tipoevento" PropertyName="SelectedValue" />
                     <asp:Parameter Name="documentos" />
                 </SelectParameters>
    </asp:SqlDataSource>

    <asp:GridView ID="GSuperSalud" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SSuperSalud">
            <Columns>
                <asp:BoundField HeaderText="TIPO DE IDENTIFICACION DEL USUARIO" DataField="tipodocumento" SortExpression="tipodocumento" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="NUMERO DE IDENTIFICACION DEL USUARIO" DataField="pacDocumento" SortExpression="pacDocumento" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right"/>
                <asp:BoundField HeaderText="FECHA DE NACIMIENTO DEL USUARIO" DataField="pacFechaNac" SortExpression="pacFechaNac" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:d}" />
                <asp:BoundField HeaderText="SEXO DEL USUARIO" DataField="sexo" SortExpression="sexo" ItemStyle-Wrap="false" />
                
                <asp:BoundField HeaderText="PRIMER APELLIDO DEL USUARIO" DataField="pacPApellido" SortExpression="pacPApellido" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="SEGUNDO APELLIDO DEL USUARIO" DataField="pacSApellido" SortExpression="pacSApellido" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="PRIMER NOMBRE DEL USUARIO" DataField="pacPNombre" SortExpression="pacPNombre" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="SEGUNDO NOMBRE DEL USUARIO" DataField="pacSNombre" SortExpression="pacSNombre" ItemStyle-Wrap="false" />
                
                <asp:BoundField HeaderText="FECHA DE LA PRIMERA VALORACION MÉDICA DEL SEMESTRE" DataField="valoracion" SortExpression="valoracion" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="ASEGURADOR" DataField="asegurador" SortExpression="asegurador" ItemStyle-Wrap="false" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SSuperSalud" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT paciente.pacId,
        paciente.pacNombres,paciente.pacFechaNac,paciente.pacDocumento
        ,CASE paciente.sexoId WHEN 1 THEN 'Femenino' WHEN 2 THEN 'Masculino' END AS sexo
        ,tipo_documento.tdocDescripcion AS tipodocumento
        ,asegurador.entNombre AS asegurador
        ,paciente.pacPApellido,paciente.pacSApellido,paciente.pacPNombre,paciente.pacSNombre
        ,MIN(IFNULL(evolucion_paciente.fecha,ingreso_paciente.fecha)) AS valoracion
        FROM evolucion_paciente
        LEFT JOIN ingreso_paciente ON (ingreso_paciente.paciente=evolucion_paciente.paciente)
        LEFT JOIN paciente ON (evolucion_paciente.paciente=paciente.pacId)
        LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
        LEFT JOIN tipo_documento ON (tipo_documento.tdocId=paciente.tdocId)
        WHERE
        (DATE(evolucion_paciente.fecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
        OR DATE(ingreso_paciente.fecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y'))
        AND (@tipoevento=0 OR paciente.tipECod=@tipoevento)
	    GROUP BY paciente.pacId">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text" />
                     <asp:ControlParameter ControlID="DTipoEvento" Name="tipoevento" PropertyName="SelectedValue" />
                     <asp:Parameter Name="documentos" />
                 </SelectParameters>
    </asp:SqlDataSource>



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
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5024,10004,10005,10008,10009,10010,10011,10012,10022,12450,12451,12480,12452,13792,12453,12454,12481,12456,12457,12458) GROUP BY autNumero) AS enfermeria ON (enfermeria.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5029,10023) GROUP BY autNumero) AS tfisica ON (tfisica.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5030,10024,10035) GROUP BY autNumero) AS trespiratoria ON (trespiratoria.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5031,10025) GROUP BY autNumero) AS tocupacional ON (tocupacional.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5028,10026) GROUP BY autNumero) AS tlenguaje ON (tlenguaje.autNumero=autorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM autorizacion_detalle WHERE actId IN (5021,10013) GROUP BY autNumero) AS vmedica ON (vmedica.autNumero=autorizacion.autNumero)
    WHERE paciente.entId IN (7,8)
    AND DATE(autorizacion.AutFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
    AND (@tipoevento=0 OR paciente.tipECod=@tipoevento)
	GROUP BY paciente.pacNombres,paciente.pacFechaNac,paciente.pacDocumento,paciente.entId,paciente.pacFecIngPrograma,paciente.cieCodDx,paciente.cieCodDx_1,paciente.cieCodDx_2,paciente.pacObservaciones">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text" />
                     <asp:ControlParameter ControlID="DTipoEvento" Name="tipoevento" PropertyName="SelectedValue" />
                     <asp:Parameter Name="documentos" />
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
    AND DATE(autorizacion.AutFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
    AND (@tipoevento=0 OR paciente.tipECod=@tipoevento)
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
                     <asp:ControlParameter ControlID="DTipoEvento" Name="tipoevento" PropertyName="SelectedValue" />
                     <asp:Parameter Name="documentos" />
                 </SelectParameters>
    </asp:SqlDataSource>


    
    <asp:GridView ID="GSeguimiento" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SSeguimiento">
            <Columns>
                <asp:BoundField HeaderText="Documento" DataField="pacDocumento" SortExpression="pacDocumento" />
                <asp:BoundField HeaderText="Paciente" DataField="pacNombres" SortExpression="pacNombres" ItemStyle-CssClass="nw" />
                <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-CssClass="nw" />
                <asp:BoundField HeaderText="Servicio" DataField="servicio" SortExpression="servicio" />
                <asp:BoundField HeaderText="Auxiliar asignada" DataField="auxiliar" SortExpression="auxiliar" ItemStyle-CssClass="nw" />
                <asp:BoundField HeaderText="01" DataField="01" SortExpression="01" />
                <asp:BoundField HeaderText="02" DataField="02" SortExpression="02" />
                <asp:BoundField HeaderText="03" DataField="03" SortExpression="03" />
                <asp:BoundField HeaderText="04" DataField="04" SortExpression="04" />
                <asp:BoundField HeaderText="05" DataField="05" SortExpression="05" />
                <asp:BoundField HeaderText="06" DataField="06" SortExpression="06" />
                <asp:BoundField HeaderText="07" DataField="07" SortExpression="07" />
                <asp:BoundField HeaderText="08" DataField="08" SortExpression="08" />
                <asp:BoundField HeaderText="09" DataField="09" SortExpression="09" />
                <asp:BoundField HeaderText="10" DataField="10" SortExpression="10" />
                <asp:BoundField HeaderText="11" DataField="11" SortExpression="11" />
                <asp:BoundField HeaderText="12" DataField="12" SortExpression="12" />
                <asp:BoundField HeaderText="13" DataField="13" SortExpression="13" />
                <asp:BoundField HeaderText="14" DataField="14" SortExpression="14" />
                <asp:BoundField HeaderText="15" DataField="15" SortExpression="15" />
                <asp:BoundField HeaderText="16" DataField="16" SortExpression="16" />
                <asp:BoundField HeaderText="17" DataField="17" SortExpression="17" />
                <asp:BoundField HeaderText="18" DataField="18" SortExpression="18" />
                <asp:BoundField HeaderText="19" DataField="19" SortExpression="19" />
                <asp:BoundField HeaderText="20" DataField="20" SortExpression="20" />
                <asp:BoundField HeaderText="21" DataField="21" SortExpression="21" />
                <asp:BoundField HeaderText="22" DataField="22" SortExpression="22" />
                <asp:BoundField HeaderText="23" DataField="23" SortExpression="23" />
                <asp:BoundField HeaderText="24" DataField="24" SortExpression="24" />
                <asp:BoundField HeaderText="25" DataField="25" SortExpression="25" />
                <asp:BoundField HeaderText="26" DataField="26" SortExpression="26" />
                <asp:BoundField HeaderText="27" DataField="27" SortExpression="27" />
                <asp:BoundField HeaderText="28" DataField="28" SortExpression="28" />
                <asp:BoundField HeaderText="29" DataField="29" SortExpression="29" />
                <asp:BoundField HeaderText="30" DataField="30" SortExpression="30" />
                <asp:BoundField HeaderText="31" DataField="31" SortExpression="31" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SSeguimiento" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
autorizacion.autNumero,
autorizacion.autFecha,
paciente.pacDocumento,
paciente.pacNombres,
asegurador.entNombre,
CASE autorizacion_detalle.actId WHEN 12450 THEN '12h noche' WHEN 12451 THEN '24h' WHEN 12480 THEN '12h día' END servicio
,GROUP_CONCAT(DISTINCT IF(recurso_humano.perId=0, NULL, recurso_humano.perNombre)) auxiliar
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-01'), LEFT(bites.nombre, 1), NULL)) '01'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-02'), LEFT(bites.nombre, 1), NULL)) '02'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-03'), LEFT(bites.nombre, 1), NULL)) '03'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-04'), LEFT(bites.nombre, 1), NULL)) '04'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-05'), LEFT(bites.nombre, 1), NULL)) '05'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-06'), LEFT(bites.nombre, 1), NULL)) '06'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-07'), LEFT(bites.nombre, 1), NULL)) '07'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-08'), LEFT(bites.nombre, 1), NULL)) '08'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-09'), LEFT(bites.nombre, 1), NULL)) '09'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-10'), LEFT(bites.nombre, 1), NULL)) '10'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-11'), LEFT(bites.nombre, 1), NULL)) '11'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-12'), LEFT(bites.nombre, 1), NULL)) '12'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-13'), LEFT(bites.nombre, 1), NULL)) '13'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-14'), LEFT(bites.nombre, 1), NULL)) '14'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-15'), LEFT(bites.nombre, 1), NULL)) '15'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-16'), LEFT(bites.nombre, 1), NULL)) '16'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-17'), LEFT(bites.nombre, 1), NULL)) '17'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-18'), LEFT(bites.nombre, 1), NULL)) '18'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-19'), LEFT(bites.nombre, 1), NULL)) '19'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-20'), LEFT(bites.nombre, 1), NULL)) '20'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-21'), LEFT(bites.nombre, 1), NULL)) '21'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-22'), LEFT(bites.nombre, 1), NULL)) '22'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-23'), LEFT(bites.nombre, 1), NULL)) '23'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-24'), LEFT(bites.nombre, 1), NULL)) '24'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-25'), LEFT(bites.nombre, 1), NULL)) '25'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-26'), LEFT(bites.nombre, 1), NULL)) '26'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-27'), LEFT(bites.nombre, 1), NULL)) '27'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-28'), LEFT(bites.nombre, 1), NULL)) '28'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-29'), LEFT(bites.nombre, 1), NULL)) '29'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-30'), LEFT(bites.nombre, 1), NULL)) '30'
,MAX(IF(DATE(bitacora_turno.bitFecha)=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'),'%Y-%m-31'), LEFT(bites.nombre, 1), NULL)) '31'
FROM autorizacion
LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
LEFT JOIN programacion ON (programacion.autNumero=autorizacion.autNumero AND programacion.actId=autorizacion_detalle.actId AND programacion.prgActivo=1)
LEFT JOIN bitacora_turno ON (bitacora_turno.pacId=autorizacion.pacId)
LEFT JOIN varios bites ON (bites.id=bitacora_turno.estado)
LEFT JOIN recurso_humano ON (recurso_humano.perId=programacion.perId)
LEFT JOIN medicamentos ON (medicamentos.id=autorizacion_detalle.actId)
WHERE 
    DATE(autorizacion.AutFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
    AND autorizacion_detalle.actId IN (12450,12451,12480)
    AND (@documentos=-1 OR FIND_IN_SET(paciente.pacDocumento, @documentos)!=0)
    GROUP BY autorizacion.autNumero,autorizacion_detalle.actId,paciente.pacDocumento,paciente.pacNombres,asegurador.entNombre
    ORDER BY IF(@documentos=-1, paciente.pacNombres, FIND_IN_SET(paciente.pacDocumento, @documentos))
">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text" />
                     <asp:ControlParameter ControlID="DTipoEvento" Name="tipoevento" PropertyName="SelectedValue" />
                     <asp:Parameter Name="documentos" />
                 </SelectParameters>
    </asp:SqlDataSource>



<asp:GridView ID="GCronicosFamisanar" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SCronicosFamisanar">
            <Columns>
                <asp:BoundField HeaderText="MES DE PRESTACIÓN DE LOS SERVICIOS" DataField="Month" SortExpression="Month" />
                <asp:BoundField HeaderText="¿EL USUARIO FUÉ VALORADO  EN EL MES VIGENTE? (SI o NO)" DataField="valorado" SortExpression="valorado" />
                <asp:BoundField HeaderText="¿CUÁL FUE LA CAUSA DE LA NO VALORACIÓN EN EL MES VIGENTE?" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="FECHA DE LA ÚLTIMA VALORACIÓN MÉDICA EFECTIVA" DataField="ultimav" SortExpression="ultimav" DataFormatString="{0:d}" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="NOMBRE DEL USUARIO" DataField="pacNombres" SortExpression="pacNombres" />
                <asp:BoundField HeaderText="TIPO DE DOCUMENTO" DataField="tdocDescripcion" SortExpression="tdocDescripcion" />
                <asp:BoundField HeaderText="NÚMERO DE DOCUMENTO" DataField="pacDocumento" SortExpression="pacDocumento" />
                <asp:BoundField HeaderText="EDAD" DataField="edad" SortExpression="edad" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="DX (CÓDIGO CIE 10)" DataField="cieCodDx" SortExpression="cieCodDx" />
                <asp:BoundField HeaderText="DIAGNÓSTICO PRIMARIO" DataField="cirDescripcion" SortExpression="cirDescripcion" />
                <asp:BoundField HeaderText="IPS PRIMARIA" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="CIUDAD - DEPARTAMENTO" DataField="ciudad" SortExpression="ciudad" />
                <asp:BoundField HeaderText="DIRECCIÓN" DataField="pacDireccion" SortExpression="pacDireccion" />
                <asp:BoundField HeaderText="BARRIO" DataField="pacBarrio" SortExpression="pacBarrio" />
                <asp:BoundField HeaderText="TELÉFONOS FIJO Y CELÚLAR" DataField="pacTelefono" SortExpression="pacTelefono" />
                <asp:BoundField HeaderText="ÍNDICE DE BARTHEL (0 - 100)" DataField="barthel" SortExpression="barthel" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="ESCALA DE INCAPACIDAD CRUZ ROJA FISICA (0 - 5)" DataField="cruzroja" SortExpression="cruzroja" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="ESCALA DE INCAPACIDAD CRUZ ROJA MENTAL (0 - 5)" DataField="" SortExpression="" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="PUNTUACIÓN ESCALA DE NORTON (1 - 20)" DataField="norton" SortExpression="norton" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="PLAN DE MANEJO DOMICILIARIO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="CANTIDAD VALORACION MEDICA IPS DOMICILIARIA" DataField="VM" SortExpression="VM" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="CANTIDAD TF IPS DOMICILIARIA" DataField="TF" SortExpression="TF" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="CANTIDAD TR IPS DOMICILIARIA" DataField="TR" SortExpression="TR" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="CANTIDAD TR + SUCCION IPS DOMICILIARIA" DataField="" SortExpression="" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="CANTIDAD TO IPS DOMICILIARIA" DataField="TO" SortExpression="TO" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="CANTIDAD TL IPS DOMICILIARIA" DataField="TL" SortExpression="TL" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="CANTIDAD NUTRICION IPS DOMICILIARIA" DataField="Nutricion" SortExpression="Nutricion" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="CANTIDAD PSICOLOGIA IPS DOMICILIARIA" DataField="sicologia" SortExpression="sicologia" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="TOMA DE LABORATORIOS IPS DOMICILIARIA" DataField="" SortExpression="" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="TIPO DE LABORATORIO IPS DOMICILIARIA" DataField="" SortExpression="" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="CANTIDAD CATETERISMO VESICAL IPS DOMICILIARIA" DataField="" SortExpression="" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="# DE TURNOS DE ENFERMERIA IPS DOMICILIARIA" DataField="enfermeria" SortExpression="enfermeria" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="# DE HORAS DE ENFERMERIA IPS DOMICILIARIA" DataField="horas" SortExpression="horas" />
                <asp:BoundField HeaderText="TEMPORALIDAD ENFERMERIA" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="DESPLAZAMIENTO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="MEDICO IPS DOMICILIARIA QUE VALORA" DataField="medico" SortExpression="medico" />
                <asp:BoundField HeaderText="IPS DOMICILIARIA QUE EJECUTA VM" DataField="ipsejecuta" SortExpression="ipsejecuta" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SCronicosFamisanar" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
MONTH(formulacion.fecha) Month
,IF(DATE_FORMAT(MAX(ingreso_paciente.fecha), '%y%m')=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'), '%y%m') OR DATE_FORMAT(MAX(evolucion_paciente.fecha), '%y%m')=DATE_FORMAT(STR_TO_DATE(@inicio, '%d/%m/%Y'), '%y%m'), 'SI', 'NO') valorado
,IFNULL(MAX(evolucion_paciente.fecha),MAX(ingreso_paciente.fecha)) ultimav
,paciente.pacNombres
,tipo_documento.tdocDescripcion
,paciente.pacDocumento
,paciente.cieCodDx
,paciente.pacDireccion
,paciente.pacBarrio
,paciente.pacTelefono
,cie10.cirDescripcion
,TIMESTAMPDIFF(YEAR, paciente.pacFechaNac, NOW()) edad
,(SELECT SUM(varios.descripcion) FROM indice_barthel LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id) LEFT JOIN varios ON (varios.id=analisis_barthel.resultado) WHERE indice_barthel.paciente=paciente.pacId AND indice_barthel.tipo=8 GROUP BY indice_barthel.id ORDER BY indice_barthel.fecha DESC LIMIT 1) barthel
,(SELECT SUM(varios.descripcion) FROM indice_barthel LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id) LEFT JOIN varios ON (varios.id=analisis_barthel.resultado) WHERE indice_barthel.paciente=paciente.pacId AND indice_barthel.tipo=77 GROUP BY indice_barthel.id ORDER BY indice_barthel.fecha DESC LIMIT 1) cruzroja
,(SELECT SUM(varios.descripcion) FROM indice_barthel LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id) LEFT JOIN varios ON (varios.id=analisis_barthel.resultado) WHERE indice_barthel.paciente=paciente.pacId AND indice_barthel.tipo=79 GROUP BY indice_barthel.id ORDER BY indice_barthel.fecha DESC LIMIT 1) norton
,SUM(IF(medicamento_formulacion.medicamento IN (5021,10013), medicamento_formulacion.formulada, 0)) VM
,SUM(IF(medicamento_formulacion.medicamento IN (5029,10023), medicamento_formulacion.formulada, 0)) TF
,SUM(IF(medicamento_formulacion.medicamento IN (5030,10024,10035), medicamento_formulacion.formulada, 0)) TR
,SUM(IF(medicamento_formulacion.medicamento IN (5031,10025), medicamento_formulacion.formulada, 0)) 'TO'
,SUM(IF(medicamento_formulacion.medicamento IN (5028,10026), medicamento_formulacion.formulada, 0)) TL
,SUM(IF(medicamento_formulacion.medicamento IN (5025), medicamento_formulacion.formulada, 0)) Nutricion
,SUM(IF(medicamento_formulacion.medicamento IN (5026), medicamento_formulacion.formulada, 0)) sicologia
,SUM(IF(medicamento_formulacion.medicamento IN (5024,5025,10004,10005,10006,10007,10008,10009,10010,10011,10012,10015,10016,10022,12480,12451,12450), medicamento_formulacion.formulada, 0))  enfermeria
,GROUP_CONCAT(DISTINCT CASE medicamento_formulacion.medicamento WHEN 12450 THEN '12h noche' WHEN 12451 THEN '24h' WHEN 12480 THEN '12h día' END) horas
,IFNULL(rhe.perNombre, recurso_humano.perNombre) medico
,'BOGOTÁ D.C' ciudad
,'OrganizationExample15 - BOGOTA' ipsejecuta
FROM formulacion
LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id)
LEFT JOIN paciente ON (paciente.pacId=formulacion.paciente)
LEFT JOIN tipo_documento ON (tipo_documento.tdocId=paciente.tdocId)
LEFT JOIN ingreso_paciente ON (ingreso_paciente.paciente=formulacion.paciente)
LEFT JOIN evolucion_paciente ON (evolucion_paciente.id=(SELECT id FROM evolucion_paciente WHERE evolucion_paciente.paciente=formulacion.paciente ORDER BY id DESC LIMIT 1))
LEFT JOIN recurso_humano ON (recurso_humano.perId=ingreso_paciente.medico)
LEFT JOIN recurso_humano rhe ON (rhe.perId=evolucion_paciente.medico)
LEFT JOIN cie10 ON (cie10.cieCodDx=paciente.cieCodDx)
WHERE 
    DATE(formulacion.fecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
    AND paciente.entId IN (12, 13)
    AND (@documentos=-1 OR FIND_IN_SET(paciente.pacDocumento, @documentos)!=0)
    GROUP BY paciente.pacId,paciente.pacDocumento,paciente.pacNombres
    ORDER BY IF(@documentos=-1, paciente.pacNombres, FIND_IN_SET(paciente.pacDocumento, @documentos))
">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text" />
                     <asp:ControlParameter ControlID="DTipoEvento" Name="tipoevento" PropertyName="SelectedValue" />
                     <asp:Parameter Name="documentos" />
                 </SelectParameters>
    </asp:SqlDataSource>


    <asp:GridView ID="GFacturacionCompensar" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SFacturacionCompensar">
            <Columns>
                <asp:BoundField HeaderText="REGISTRO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="MES  DEL EVENTO " DataField="mes" SortExpression="mes" />
                <asp:BoundField HeaderText="IPS DOMICILIO" DataField="OrganizationExample15" SortExpression="OrganizationExample15" />
                <asp:BoundField HeaderText="OBSERVACIONES AUDITORIA" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="EVOLUCION ENFERMEDAD" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="FECHA INGRESO" DataField="ingreso" SortExpression="ingreso" DataFormatString="{0:d}" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="FECHA EGRESO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="DIAS ESTANCIA" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="CODIGO CIE 10 PRINCIPAL" DataField="cieCodDx" SortExpression="cieCodDx" />
                <asp:BoundField HeaderText="DESCRIPCION DIAGNOSTICO CIE 10 (PRINCIPAL)" DataField="cirDescripcion" SortExpression="cirDescripcion" />
                <asp:BoundField HeaderText="CODIGO CIE 10 SECUNDARIO" DataField="cieCodDx_1" SortExpression="cieCodDx_1" />
                <asp:BoundField HeaderText="DESCRIPCION DIAGNOSTICO CIE 10 (SECUNDARIO)" DataField="cirDescripcion" SortExpression="cirDescripcion" />
                <asp:BoundField HeaderText="PROCEDIMIENTOS" DataField="procedimiento" SortExpression="procedimiento" />
                <asp:BoundField HeaderText="RECOBRO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="CUPS SERVICIO" DataField="cups" SortExpression="cups" />
                <asp:BoundField HeaderText="BARTHEL" DataField="barthel" SortExpression="barthel" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="TIPO DOCUMENTO" DataField="tdocDescripcion" SortExpression="tdocDescripcion" />
                <asp:BoundField HeaderText="NUMERO DOCUMENTO" DataField="pacDocumento" SortExpression="pacDocumento" />
                <asp:BoundField HeaderText="APELLIDOS Y NOMBRE" DataField="pacNombres" SortExpression="pacNombres" />
                <asp:BoundField HeaderText="EDAD" DataField="edad" SortExpression="edad" />
                <asp:BoundField HeaderText="GRUPO ETAREO" DataField="grupoe" SortExpression="grupoe" />
                <asp:BoundField HeaderText="SEXO" DataField="sexo" SortExpression="sexo" />
                <asp:BoundField HeaderText="PLAN DE BENEFICIOS" DataField="plan" SortExpression="plan" />
                <asp:BoundField HeaderText="IPS QUE REMITE" DataField="ips" SortExpression="ips" />
                <asp:BoundField HeaderText="AUTORIZACION" DataField="autNumero" SortExpression="autNumero" />
                <asp:BoundField HeaderText="FACTURA" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="TOTAL VALOR  FACTURADO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="VALOR INSUMOS" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="VALOR MEDICAMENTOS" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="VALOR ALQUILER EQUIPOS" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="COSTO ENFERMERIA " DataField="" SortExpression="" />
                <asp:BoundField HeaderText="VALOR HONORARIOS MEDICOS" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="VALOR APOYO  TERAPEUTICO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="TF" DataField="TF" SortExpression="TF" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="TR" DataField="TR" SortExpression="TR" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="TO" DataField="TO" SortExpression="TO" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="TL" DataField="TL" SortExpression="TL" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="PSICOLOGIA" DataField="sicologia" SortExpression="sicologia" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="NUTRICION" DataField="nutricion" SortExpression="nutricion" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="TRABAJO SOCIAL" DataField="trabajosocial" SortExpression="trabajosocial" ItemStyle-CssClass="r" />
                <asp:BoundField HeaderText="VALOR APOYO DX." DataField="" SortExpression="" />
                <asp:BoundField HeaderText="PAQUETE VENTILADO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="PAQUETE PALIATIVO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="PAQUETE DESTETE OXIGENO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="PAQUETE ANTICOAGULADO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="COPAGO/CUOTA MODERADORA" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="VALOR OBJETADO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="VALOR  GLOSADO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="DESCRIPCION GLOSA" DataField="" SortExpression="" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SFacturacionCompensar" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
CAST(@ingreso:=(SELECT autorizacion.autFecha FROM autorizacion WHERE autorizacion.pacId=paciente.pacId ORDER BY autorizacion.id LIMIT 1) AS DATETIME) ingreso
,CASE MONTH(@ingreso) 
 WHEN 1 THEN 'ENE'
 WHEN 2 THEN 'FEB'
 WHEN 3 THEN 'MAR'
 WHEN 4 THEN 'ABR'
 WHEN 5 THEN 'MAY'
 WHEN 6 THEN 'JUN'
 WHEN 7 THEN 'JUL'
 WHEN 8 THEN 'AGO'
 WHEN 9 THEN 'SEP'
 WHEN 10 THEN 'OCT'
 WHEN 11 THEN 'NOV'
 WHEN 12 THEN 'DIC'
END mes
,paciente.cieCodDx
,cie10.cirDescripcion
,paciente.cieCodDx_1
,cie102.cirDescripcion
,GROUP_CONCAT(DISTINCT medicamentos.nombre) procedimiento
,GROUP_CONCAT(DISTINCT medicamentos.codigo) cups
,(SELECT SUM(varios.descripcion) FROM indice_barthel LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id) LEFT JOIN varios ON (varios.id=analisis_barthel.resultado) WHERE indice_barthel.paciente=paciente.pacId AND indice_barthel.tipo=8 GROUP BY indice_barthel.id ORDER BY indice_barthel.fecha DESC LIMIT 1) barthel
,tipo_documento.tdocDescripcion
,paciente.pacDocumento
,paciente.pacNombres
,@e:=TIMESTAMPDIFF(YEAR, paciente.pacFechaNac, NOW()) edad
,CASE  WHEN @e>74 THEN '75 AÑOS O MAS'
 WHEN @e>69 THEN '70 A 74 AÑOS'
 WHEN @e>64 THEN '65 A 69 AÑOS'
 WHEN @e>59 THEN '60 A 64 AÑOS'
 WHEN @e>54 THEN '55 A 59 AÑOS'
 WHEN @e>49 THEN '50 A 54 AÑOS'
 WHEN @e>44 THEN '45 A 49 AÑOS'
 WHEN @e>18 THEN '19 A 44 AÑOS'
 WHEN @e>14 THEN '15 A 18 AÑOS'
 WHEN @e>4 THEN '5 A 14 AÑOS'
 WHEN @e>0 THEN '1 A 4 AÑOS'
 ELSE 'MENOR DE 1 AÑO'
END grupoe
,IF(paciente.sexoId=1, 'F', 'M') sexo
,IF(paciente_tipo_pago.pdirDescripcion='PC', 'PLAN COMPLEMENTARIO', paciente_tipo_pago.pdirDescripcion) plan
,ips.nombre ips
,autorizacion.autNumero
,SUM(IF(autorizacion_detalle.actId IN (5029,10023), 1, 0)) TF
,SUM(IF(autorizacion_detalle.actId IN (5030,10024,10035), 1, 0)) TR
,SUM(IF(autorizacion_detalle.actId IN (5031,10025), 1, 0)) 'TO'
,SUM(IF(autorizacion_detalle.actId IN (5028,10026), 1, 0)) TL
,SUM(IF(autorizacion_detalle.actId IN (5026), 1, 0)) sicologia
,SUM(IF(autorizacion_detalle.actId IN (5025), 1, 0)) nutricion
,SUM(IF(autorizacion_detalle.actId IN (5027), 1, 0)) trabajosocial
,'OrganizationExample15' OrganizationExample15
FROM autorizacion
LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
LEFT JOIN tipo_documento ON (tipo_documento.tdocId=paciente.tdocId)
LEFT JOIN cie10 ON (cie10.cieCodDx=paciente.cieCodDx)
LEFT JOIN cie10 cie102 ON (cie10.cieCodDx=paciente.cieCodDx_1)
LEFT JOIN medicamentos ON (medicamentos.id=autorizacion_detalle.actId)
LEFT JOIN paciente_tipo_pago ON (paciente_tipo_pago.pdirId=paciente.pdirId)
LEFT JOIN varios AS ips ON (ips.id=paciente.ips_remitente)
WHERE 
    DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
    AND paciente.entId IN (9,69)
    AND (@documentos=-1 OR FIND_IN_SET(paciente.pacDocumento, @documentos)!=0)
    GROUP BY autorizacion.autNumero
    ORDER BY IF(@documentos=-1, autorizacion.autFecha, FIND_IN_SET(paciente.pacDocumento, @documentos))
">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text" />
                     <asp:ControlParameter ControlID="DTipoEvento" Name="tipoevento" PropertyName="SelectedValue" />
                     <asp:Parameter Name="documentos" />
                 </SelectParameters>
    </asp:SqlDataSource>






    <asp:GridView ID="GHC" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SHC">
            <Columns>
                <asp:BoundField HeaderText="Mes" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="NUM." DataField="id" SortExpression="id" />
                <asp:BoundField HeaderText="NOMBRE PACIENTE" DataField="pacNombres" SortExpression="pacNombres" />
                <asp:BoundField HeaderText="DOCUMENTO" DataField="pacDocumento" SortExpression="pacDocumento" />
                <asp:BoundField HeaderText="FECHA VALORACION" DataField="fecha" SortExpression="fecha" />
                <asp:BoundField HeaderText="MEDICO EVALUADO" DataField="perNombre" SortExpression="perNombre" />
                <asp:BoundField HeaderText="DATOS DEL PACIENTE " DataField="dp" SortExpression="dp" />
                <asp:BoundField HeaderText="FECHA PV" DataField="fp" SortExpression="fp" />
                <asp:BoundField HeaderText="HORA PV" DataField="hp" SortExpression="hp" />
                <asp:BoundField HeaderText="MOTIVO CONSULTA PV" DataField="mp" SortExpression="mp" />
                <asp:BoundField HeaderText="ENFERMEDAD ACTUAL PV" DataField="eap" SortExpression="eap" />
                <asp:BoundField HeaderText="REVISION POR SISTEMAS" DataField="rsp" SortExpression="rsp" />
                <asp:BoundField HeaderText="ANTECEDENTES PATOLOGICOS PV" DataField="app" SortExpression="app" />
                <asp:BoundField HeaderText="ANTECEDENTES HOSPITALARIOS" DataField="ahp" SortExpression="ahp" />
                <asp:BoundField HeaderText="ANTECEDENTES QUIRURGICOS" DataField="aqp" SortExpression="aqp" />
                <asp:BoundField HeaderText="ANTECEDENTES ALERGICOS" DataField="aap" SortExpression="aap" />
                <asp:BoundField HeaderText="ANTECEDENTES FARMACOLOGICOS" DataField="afp" SortExpression="afp" />
                <asp:BoundField HeaderText="ANTECEDENTES TRANSFUSIONALES" DataField="atp" SortExpression="atp" />
                <asp:BoundField HeaderText="ANTECEDENTES FAMILIARES" DataField="amp" SortExpression="amp" />
                <asp:BoundField HeaderText="ANTECEDENTES TRAUMATOLOGICOS PV" DataField="arp" SortExpression="arp" />
                <asp:BoundField HeaderText="ANTECEDENTES GINECOLOGICOS" DataField="agp" SortExpression="agp" />
                <asp:BoundField HeaderText="ANTECEDENTES NEONATALES" DataField="anp" SortExpression="anp" />
                <asp:BoundField HeaderText="ANTECEDENTES PSICOLOGICOS" DataField="asp" SortExpression="asp" />
                <asp:BoundField HeaderText="ANTECEDENTES VACUNACION" DataField="avp" SortExpression="avp" />
                <asp:BoundField HeaderText="EXAMEN FISICO" DataField="efp" SortExpression="efp" />
                <asp:BoundField HeaderText="RIESGOS" DataField="rp" SortExpression="rp" />
                <asp:BoundField HeaderText="ANALISIS" DataField="analisis" SortExpression="analisis" />
                <asp:BoundField HeaderText="CONDUCTA INICIAL" DataField="conducta" SortExpression="conducta" />
                <asp:BoundField HeaderText="NOMBRE Y REGISTRO DEL MEDICO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="DATOS DEL PACIENTE " DataField="de" SortExpression="de" />
                <asp:BoundField HeaderText="FECHA " DataField="fe" SortExpression="fe" />
                <asp:BoundField HeaderText="HORA" DataField="he" SortExpression="he" />
                <asp:BoundField HeaderText="MOTIVO CONSULTA " DataField="me" SortExpression="me" />
                <asp:BoundField HeaderText="ENFERMEDAD ACTUAL " DataField="eae" SortExpression="eae" />
                <asp:BoundField HeaderText="ANTECEDENTES PATOLOGICOS PV" DataField="ape" SortExpression="ape" />
                <asp:BoundField HeaderText="ANTECEDENTES HOSPITALARIOS" DataField="ahe" SortExpression="ahe" />
                <asp:BoundField HeaderText="ANTECEDENTES QUIRURGICOS" DataField="aqe" SortExpression="aqe" />
                <asp:BoundField HeaderText="ANTECEDENTES ALERGICOS" DataField="aae" SortExpression="aae" />
                <asp:BoundField HeaderText="ANTECEDENTES FARMACOLOGICOS" DataField="afe" SortExpression="afe" />
                <asp:BoundField HeaderText="ANTECEDENTES TRANSFUSIONALES" DataField="ate" SortExpression="ate" />
                <asp:BoundField HeaderText="ANTECEDENTES FAMILIARES" DataField="ame" SortExpression="ame" />
                <asp:BoundField HeaderText="ANTECEDENTES TRAUMATOLOGICOS PV" DataField="are" SortExpression="are" />
                <asp:BoundField HeaderText="ANTECEDENTES GINECOLOGICOS" DataField="age" SortExpression="age" />
                <asp:BoundField HeaderText="ANTECEDENTES NEONATALES" DataField="ane" SortExpression="ane" />
                <asp:BoundField HeaderText="ANTECEDENTES PSICOLOGICOS" DataField="ase" SortExpression="ase" />
                <asp:BoundField HeaderText="ANTECEDENTES VACUNACION" DataField="ave" SortExpression="ave" />
                <asp:BoundField HeaderText="EXAMEN FISICO" DataField="efe" SortExpression="efe" />
                <asp:BoundField HeaderText="RIESGOS" DataField="rpe" SortExpression="rpe" />
                <asp:BoundField HeaderText="PLAN EDUCATIVO" DataField="pee" SortExpression="pee" />
                <asp:BoundField HeaderText="ANALISIS" DataField="analisise" SortExpression="analisise" />
                <asp:BoundField HeaderText="PLAN DE MANEJO" DataField="plan_manejoe" SortExpression="plan_manejoe" />
                <asp:BoundField HeaderText="NOMBRE Y REGISTRO DEL MEDICO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="UTILIZACION ABREVIATURAS" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="HISTORIA CLINICA INCOMPLETA" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="OBSERVACIONES AL MEDICO" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="OBSERVACIONES A LA INSTITUCION" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="REVISADO POR" DataField="" SortExpression="" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SHC" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
t.t,t.id,paciente.pacId,paciente.pacNombres,paciente.pacDocumento,fecha,recurso_humano.perNombre
,IF(t.t=0, 1, NULL) dp
,IF(t.t=0, 1, NULL) fp
,IF(t.t=0, 1, NULL) hp
,IF(t.t=0, IF(t.motivo IS NOT NULL, 1, 2), NULL) mp
,IF(t.t=0, IF(t.enfermedad_actual IS NOT NULL, 1, 2), NULL) eap
,IF(t.t=0, IF(t.ri IS NOT NULL, 1, 2), NULL) rsp
,IF(t.t=0, IF(t.ap IS NOT NULL, 1, 2), NULL) app
,IF(t.t=0, IF(t.ah IS NOT NULL, 1, 2), NULL) ahp
,IF(t.t=0, IF(t.aq IS NOT NULL, 1, 2), NULL) aqp
,IF(t.t=0, IF(t.aa IS NOT NULL, 1, 2), NULL) aap
,IF(t.t=0, IF(t.af IS NOT NULL, 1, 2), NULL) afp
,IF(t.t=0, IF(t.at IS NOT NULL, 1, 2), NULL) atp
,IF(t.t=0, IF(t.am IS NOT NULL, 1, 2), NULL) amp
,IF(t.t=0, IF(t.ar IS NOT NULL, 1, 2), NULL) arp
,IF(t.t=0, IF(t.ag IS NOT NULL, 1, 2), NULL) agp
,IF(t.t=0, IF(t.an IS NOT NULL, 1, 2), NULL) anp
,IF(t.t=0, IF(t.as IS NOT NULL, 1, 2), NULL) asp
,IF(t.t=0, IF(t.av IS NOT NULL, 1, 2), NULL) avp
,IF(t.t=0, IF(t.ef IS NOT NULL, 1, 2), NULL) efp
,IF(t.t=0, IF(t.r IS NOT NULL, 1, 2), NULL) rp
,IF(t.t=0, IF(t.analisis IS NOT NULL, 1, 2), NULL) analisis
,IF(t.t=0, IF(t.conducta IS NOT NULL, 1, 2), NULL) conducta
        ,IF(t.t=1, 1, NULL) de
,IF(t.t=1, 1, NULL) fe
,IF(t.t=1, 1, NULL) he
,IF(t.t=1, IF(t.motivo IS NOT NULL, 1, 2), NULL) me
,IF(t.t=1, IF(t.enfermedad_actual IS NOT NULL, 1, 2), NULL) eae
,IF(t.t=1, IF(t.ap IS NOT NULL, 1, 2), NULL) ape
,IF(t.t=1, IF(t.ah IS NOT NULL, 1, 2), NULL) ahe
,IF(t.t=1, IF(t.aq IS NOT NULL, 1, 2), NULL) aqe
,IF(t.t=1, IF(t.aa IS NOT NULL, 1, 2), NULL) aae
,IF(t.t=1, IF(t.af IS NOT NULL, 1, 2), NULL) afe
,IF(t.t=1, IF(t.at IS NOT NULL, 1, 2), NULL) ate
,IF(t.t=1, IF(t.am IS NOT NULL, 1, 2), NULL) ame
,IF(t.t=1, IF(t.ar IS NOT NULL, 1, 2), NULL) are
,IF(t.t=1, IF(t.ag IS NOT NULL, 1, 2), NULL) age
,IF(t.t=1, IF(t.an IS NOT NULL, 1, 2), NULL) ane
,IF(t.t=1, IF(t.as IS NOT NULL, 1, 2), NULL) ase
,IF(t.t=1, IF(t.av IS NOT NULL, 1, 2), NULL) ave
,IF(t.t=1, IF(t.ef IS NOT NULL, 1, 2), NULL) efe
,IF(t.t=1, IF(t.pe IS NOT NULL, 1, 2), NULL) pee
,IF(t.t=1, IF(t.r IS NOT NULL, 1, 2), NULL) rpe
,IF(t.t=1, IF(t.analisis IS NOT NULL, 1, 2), NULL) analisise
,IF(t.t=1, IF(t.plan_manejo IS NOT NULL, 1, 2), NULL) plan_manejoe
FROM 
((SELECT 0 t, ingreso_paciente.id, ingreso_paciente.paciente,ingreso_paciente.fecha,ingreso_paciente.medico
,ingreso_paciente.motivo,ingreso_paciente.enfermedad_actual
,IF(MAX(revision_ingreso.observaciones) IS NOT NULL, 1, NULL) ri
,MAX(IF(a.nombre='Patólogicos', antecedentes_ingreso.observaciones, NULL)) ap
,MAX(IF(a.nombre='Hospitalarios', antecedentes_ingreso.observaciones, NULL)) ah
,MAX(IF(a.nombre='Quirúrgicos', antecedentes_ingreso.observaciones, NULL)) aq
,MAX(IF(a.nombre='Alérgicos', antecedentes_ingreso.observaciones, NULL)) aa
,MAX(IF(a.nombre='Farmacológicos', antecedentes_ingreso.observaciones, NULL)) af
,MAX(IF(a.nombre='Transfusionales', antecedentes_ingreso.observaciones, NULL)) at
,MAX(IF(a.nombre='Familiares', antecedentes_ingreso.observaciones, NULL)) am
,MAX(IF(a.nombre='Traumáticos', antecedentes_ingreso.observaciones, NULL)) ar
,MAX(IF(a.nombre='Ginecológicos', antecedentes_ingreso.observaciones, NULL)) ag
,MAX(IF(a.nombre='Neonatales', antecedentes_ingreso.observaciones, NULL)) an
,MAX(IF(a.nombre='Psicológicos', antecedentes_ingreso.observaciones, NULL)) 'as'
,MAX(IF(a.nombre='Vacunación', antecedentes_ingreso.observaciones, NULL)) av
,IF(MAX(examen_ingreso.observaciones) IS NOT NULL, 1, NULL) ef
,IF(MAX(ingreso_riesgos.observaciones) IS NOT NULL, 1, NULL) r
,NULL pe
,ingreso_paciente.analisis
,IFNULL(ingreso_paciente.conducta,(SELECT COUNT(*) FROM formulacion WHERE formulacion.paciente=ingreso_paciente.paciente AND DATE(formulacion.fecha)=DATE(ingreso_paciente.fecha))) conducta
,NULL plan_manejo
FROM ingreso_paciente
LEFT JOIN revision_ingreso ON (revision_ingreso.ingreso_paciente=ingreso_paciente.id)
LEFT JOIN antecedentes_ingreso ON (antecedentes_ingreso.ingreso_paciente=ingreso_paciente.id)
LEFT JOIN varios a ON (a.id=antecedentes_ingreso.motivo)
LEFT JOIN examen_ingreso ON (examen_ingreso.ingreso_paciente=ingreso_paciente.id)
LEFT JOIN ingreso_riesgos ON (ingreso_riesgos.ingreso_paciente=ingreso_paciente.id) 
WHERE DATE(ingreso_paciente.fecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
GROUP BY ingreso_paciente.id
) UNION (
SELECT 1, evolucion_paciente.id, evolucion_paciente.paciente,evolucion_paciente.fecha,evolucion_paciente.medico
,evolucion_paciente.motivo,NULL
,NULL ri
,MAX(IF(a.nombre='Patólogicos', antecedentes_evolucion.observaciones, NULL)) ap
,MAX(IF(a.nombre='Hospitalarios', antecedentes_evolucion.observaciones, NULL)) ah
,MAX(IF(a.nombre='Quirúrgicos', antecedentes_evolucion.observaciones, NULL)) aq
,MAX(IF(a.nombre='Alérgicos', antecedentes_evolucion.observaciones, NULL)) aa
,MAX(IF(a.nombre='Farmacológicos', antecedentes_evolucion.observaciones, NULL)) af
,MAX(IF(a.nombre='Transfusionales', antecedentes_evolucion.observaciones, NULL)) at
,MAX(IF(a.nombre='Familiares', antecedentes_evolucion.observaciones, NULL)) am
,MAX(IF(a.nombre='Traumáticos', antecedentes_evolucion.observaciones, NULL)) ar
,MAX(IF(a.nombre='Ginecológicos', antecedentes_evolucion.observaciones, NULL)) ag
,MAX(IF(a.nombre='Neonatales', antecedentes_evolucion.observaciones, NULL)) an
,MAX(IF(a.nombre='Psicológicos', antecedentes_evolucion.observaciones, NULL)) 'as'
,MAX(IF(a.nombre='Vacunación', antecedentes_evolucion.observaciones, NULL)) av
,IF(MAX(examen_evolucion.observaciones) IS NOT NULL, 1, NULL) ef
,IF(MAX(evolucion_riesgos.observaciones) IS NOT NULL, 1, NULL) r
,IF(MAX(evolucion_plan_educativo.estado) IS NOT NULL, 1, NULL) pe
,evolucion_paciente.analisis analisis
,NULL conducta
,IFNULL(evolucion_paciente.plan_manejo, (SELECT COUNT(*) FROM formulacion WHERE formulacion.paciente=evolucion_paciente.paciente AND DATE(formulacion.fecha)=DATE(evolucion_paciente.fecha))) plan_manejo
FROM evolucion_paciente
LEFT JOIN antecedentes_evolucion ON (antecedentes_evolucion.evolucion_paciente=evolucion_paciente.id)
LEFT JOIN varios a ON (a.id=antecedentes_evolucion.motivo)
LEFT JOIN examen_evolucion ON (examen_evolucion.evolucion_paciente=evolucion_paciente.id)
LEFT JOIN evolucion_riesgos ON (evolucion_riesgos.evolucion_paciente=evolucion_paciente.id) 
LEFT JOIN evolucion_plan_educativo ON (evolucion_plan_educativo.evolucion_paciente=evolucion_paciente.id) 
WHERE DATE(evolucion_paciente.fecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
GROUP BY evolucion_paciente.id
)) t
LEFT JOIN paciente ON (paciente.pacId=t.paciente)
LEFT JOIN recurso_humano ON (recurso_humano.perId=t.medico)
WHERE (@documentos=-1 OR FIND_IN_SET(paciente.pacDocumento, @documentos)!=0)
ORDER BY fecha;
">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text" />
                     <asp:ControlParameter ControlID="DTipoEvento" Name="tipoevento" PropertyName="SelectedValue" />
                     <asp:Parameter Name="documentos" />
                 </SelectParameters>
    </asp:SqlDataSource>






        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
</asp:Content>

