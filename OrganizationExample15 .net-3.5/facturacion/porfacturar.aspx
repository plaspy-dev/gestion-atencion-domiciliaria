<%@ Page Title="Servicios por facturar" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="porfacturar.aspx.cs" Inherits="facturacion_porfacturar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table>
        <tr>
            <td>Inicio<asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TInicio" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Fin<asp:RequiredFieldValidator ControlToValidate="TFin" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFin" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Asegurador</td>
            <td nowrap=nowrap>Actividad o CUPS</td>
            <td>Área</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox></td>
            <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox></td>
            <td><asp:DropDownList ID="DAsegurador" runat="server"  CssClass="anchomaxcombo"
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
            <asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hide"></asp:TextBox>
            </td>
            <td><asp:DropDownList ID="DArea" runat="server" DataSourceID="SArea" CssClass="anchomaxcombo" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SArea" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT CAST(IFNULL(GROUP_CONCAT(medicamentos.id),-1) AS CHAR) AS id, varios.nombre FROM varios LEFT JOIN medicamentos ON (medicamentos.grupo=varios.id) WHERE varios.tipo=22 AND varios.szReservado IS NULL GROUP BY varios.id ORDER BY varios.nombre;">
                </asp:SqlDataSource>
            </td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" onclick="BBuscar_Click" /></td>
        </tr>
        </table>
        
<asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Visible="true"
    AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" 
    AllowSorting="True">
    <RowStyle CssClass="GridRow"></RowStyle>
    <FooterStyle CssClass="GridFooter"></FooterStyle>
    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
    <Columns>
        <asp:HyperLinkField HeaderText="Autorización" SortExpression="autorizacion" DataTextField="autorizacion" DataNavigateUrlFields="autorizacion" Target="_blank" DataNavigateUrlFormatString="~/facturacion/facturacion.aspx?aut={0}" />
        <asp:HyperLinkField HeaderText="Fecha" SortExpression="fecha" DataTextField="fecha" DataNavigateUrlFields="autorizacion" Target="_blank" DataNavigateUrlFormatString="~/facturacion/facturacion.aspx?aut={0}" DataTextFormatString="{0:d}" />
        <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Documento" DataNavigateUrlFields="pacId" SortExpression="pacDocumento"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-HorizontalAlign="Right" />
        <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" DataNavigateUrlFields="pacId" SortExpression="pacNombres"
            DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-Wrap="false" />
        <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre"/>
        <asp:BoundField HeaderText="Actividades (Autorizadas-Programadas-Diarias)" DataField="detalles" SortExpression="detalles" ItemStyle-Wrap="false" HtmlEncode="false"/>
    </Columns>
</asp:GridView>
<div align=right>
    <asp:Label runat="server" ID="LResultados"></asp:Label>
</div>
<asp:SqlDataSource ID="SResultados" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT 
                        autorizacion.autNumero AS autorizacion
                        ,autorizacion.autFecha AS fecha
                        ,paciente.pacDocumento,paciente.pacNombres,paciente.pacId
                        ,asegurador.entNombre
                        ,detalles.detalle AS detalles
                        FROM autorizacion
                        LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                        LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                        LEFT JOIN facturacion_autorizacion ON (facturacion_autorizacion.autorizacion=autorizacion.autNumero)
                        LEFT JOIN (
                            	SELECT autorizacion_detalle.autNumero
											 ,GROUP_CONCAT(CONCAT(medicamentos.nombre, ' (', IFNULL(autorizacion_detalle.autNumSesiones,0),'-',IFNULL(autorizacion_detalle.autSesionesDia,0),')') SEPARATOR '<br/>') AS detalle
                                FROM autorizacion_detalle
                                LEFT JOIN medicamentos ON (medicamentos.id=autorizacion_detalle.actId)
                                GROUP BY autorizacion_detalle.autNumero
						) AS detalles ON (detalles.autNumero = autorizacion.autNumero)
                        WHERE 
                        DATE(autorizacion.autFechaVenc) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                        AND autorizacion.autActivo=1
                        AND (@asegurador=0 OR autorizacion.entId=@asegurador)
                        AND facturacion_autorizacion.autorizacion IS NULL
                        AND (@procedimiento=0 OR EXISTS (SELECT 1 FROM autorizacion_detalle WHERE  autorizacion_detalle.autNumero=autorizacion.autNumero AND  autorizacion_detalle.actId=@procedimiento))
                        AND ('@area'='0' OR EXISTS (SELECT 1 FROM autorizacion_detalle WHERE  autorizacion_detalle.autNumero=autorizacion.autNumero AND  autorizacion_detalle.actId IN (@area)))
                        ORDER BY autorizacion.autFecha
                        ">
             <SelectParameters>
                <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
             </SelectParameters>
</asp:SqlDataSource>
</asp:Content>

