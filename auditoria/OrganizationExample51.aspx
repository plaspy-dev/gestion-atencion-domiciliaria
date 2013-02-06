<%@ Page Title="OrganizationExample51" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="OrganizationExample51.aspx.cs" Inherits="auditoria_OrganizationExample51" %>

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
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" 
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SResultados" onrowdatabound="GResultados_RowDataBound" >
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
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="SELECT phdPaciente.pacNombres,phdPaciente.pacFechaNac,phdPaciente.pacDocumento
    ,CASE phdPaciente.entId WHEN 8 THEN 'MP' ELSE 'EPS' END AS tipo
    ,ISNULL(phdPaciente.cieCodDx,'')+ ',' + ISNULL(phdPaciente.cieCodDx_1,'') + ','+ ISNULL(phdPaciente.cieCodDx_2,'') AS cied10
    ,phdPaciente.pacFecIngPrograma
	,SUM(enfermeria.autNumSesiones) AS enfermeria
	,SUM(tfisica.autNumSesiones) AS tfisica
	,SUM(trespiratoria.autNumSesiones) AS trespiratoria
	,SUM(tocupacional.autNumSesiones) AS tocupacional
	,SUM(tlenguaje.autNumSesiones) AS tlenguaje
	,SUM(vmedica.autNumSesiones) AS vmedica
    ,phdPaciente.pacObservaciones
    FROM phdPaciente
    LEFT JOIN phdAutorizacion ON (phdAutorizacion.pacId=phdPaciente.pacId)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM phdDetalleAutorizacion WHERE actId IN (5024,5025,10004,10005,10006,10007,10008,10009,10010,10011,10012,10015,10016,10022) GROUP BY autNumero) AS enfermeria ON (enfermeria.autNumero=phdAutorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM phdDetalleAutorizacion WHERE actId IN (5029,10023) GROUP BY autNumero) AS tfisica ON (tfisica.autNumero=phdAutorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM phdDetalleAutorizacion WHERE actId IN (5030,10024,10035) GROUP BY autNumero) AS trespiratoria ON (trespiratoria.autNumero=phdAutorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM phdDetalleAutorizacion WHERE actId IN (5031,10025) GROUP BY autNumero) AS tocupacional ON (tocupacional.autNumero=phdAutorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM phdDetalleAutorizacion WHERE actId IN (5028,10026) GROUP BY autNumero) AS tlenguaje ON (tlenguaje.autNumero=phdAutorizacion.autNumero)
	LEFT JOIN (SELECT autNumero,SUM(autNumSesiones) AS autNumSesiones FROM phdDetalleAutorizacion WHERE actId IN (5021,5022,5033,10013,10029,10030,10031,10032,10033,10034) GROUP BY autNumero) AS vmedica ON (vmedica.autNumero=phdAutorizacion.autNumero)
    WHERE phdPaciente.entId IN (7,8)
    AND phdAutorizacion.AutFecha BETWEEN @inicio AND @fin
	GROUP BY phdPaciente.pacNombres,phdPaciente.pacFechaNac,phdPaciente.pacDocumento,phdPaciente.entId,phdPaciente.pacFecIngPrograma,phdPaciente.cieCodDx,phdPaciente.cieCodDx_1,phdPaciente.cieCodDx_2,phdPaciente.pacObservaciones">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text" />
                 </SelectParameters>
    </asp:SqlDataSource>        
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

