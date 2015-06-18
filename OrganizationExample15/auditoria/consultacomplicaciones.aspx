<%@ Page Title="Consulta complicaciones" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="consultacomplicaciones.aspx.cs" Inherits="auditoria_consultacomplicaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">.ancho { min-width: 400px; }</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Inicio</td>
            <td>Fin</td>
            <td>Asegurador</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TInicio" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFin" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFin" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:DropDownList ID="DAsegurador" runat="server" 
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
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron actividades" AllowSorting="True" OnRowDataBound="GResultados_RowDataBound" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField HeaderText="Fecha" DataField="fecha" SortExpression="fecha" ItemStyle-Wrap="false" DataFormatString="{0:d}" />
            <asp:HyperLinkField DataTextField="paciente" HeaderText="Paciente" DataNavigateUrlFields="id" 
                DataNavigateUrlFormatString="~/auditoria/eventoa.aspx?eaid={0}" SortExpression="paciente" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Funcionario" DataField="funcionario" SortExpression="funcionario" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Descripcion" DataField="descripcion" SortExpression="descripcion" HeaderStyle-CssClass="ancho" />
            <asp:BoundField HeaderText="Tipo" DataField="tipo" SortExpression="tipo" HtmlEncode="false" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Observaciones" DataField="observaciones" SortExpression="observaciones" HeaderStyle-CssClass="ancho" />
            <asp:BoundField HeaderText="Consecuencias" DataField="consecuencia" SortExpression="consecuencia" HtmlEncode="false" ItemStyle-Wrap="false" />
        </Columns>
    </asp:GridView>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id,paciente,fecha,descripcion,observaciones,funcionario
                                ,(SELECT GROUP_CONCAT(varios.nombre SEPARATOR '<br/>') FROM tipo_evento_adverso LEFT JOIN varios ON (varios.id=tipo_evento_adverso.tipo) WHERE tipo_evento_adverso.evento=evento_adverso.id) AS tipo
                                ,(SELECT GROUP_CONCAT(varios.nombre SEPARATOR '<br/>') FROM consecuencias_evento_adverso LEFT JOIN varios ON (consecuencias_evento_adverso.consecuencia=varios.id) WHERE consecuencias_evento_adverso.evento=evento_adverso.id) AS consecuencia
                                FROM evento_adverso
                                WHERE 
                                DATE(fecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                                AND (@asegurador=0 OR @asegurador=entidad)
                                ORDER BY fecha;">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="desde" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="hasta" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>