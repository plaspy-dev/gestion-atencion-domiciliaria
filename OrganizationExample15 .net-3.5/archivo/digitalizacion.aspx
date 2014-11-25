<%@ Page Title="Digitalización" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="digitalizacion.aspx.cs" Inherits="archivo_digitalizacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= TPaciente.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPacienteI",
                    data: "{ 'q': '" + request.term + "', 'e': '<%= ViewState["entidades"].ToString() %>' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            select: function(event, ui) {

                $("#<%= TPaciente.ClientID %>").val(ui.item.label);
                $("#<%= TPacienteID.ClientID %>").val(ui.item.value);
                return false;
            },
            search: function(event, ui) {
                $("#<%= TPacienteID.ClientID %>").val("");
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="P" DefaultButton="BActualizar">
    <table>
        <tr>
            <td>Paciente</td>
            <td>Factura</td>
            <td>Asegurador</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox ID="TPaciente" runat="server"></asp:TextBox>
            <asp:TextBox runat="server" ID="TPacienteID" CssClass="hide"></asp:TextBox></td>
            <td><asp:TextBox ID="TFactura" runat="server"></asp:TextBox></td>
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
            <td><asp:Button runat="server" ID="BActualizar" Text="Buscar" onclick="BActualizar_Click" /></td>
        </tr>
    </table>
</asp:Panel>
<asp:GridView ID="GArchivo" runat="server" AutoGenerateColumns="False" DataSourceID="SArchivo" EmptyDataText="No se encontraron archivos" AllowPaging="true" PageSize="50" AllowSorting="true">
    <RowStyle CssClass="GridRow"></RowStyle>
    <FooterStyle CssClass="GridFooter"></FooterStyle>
    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
    <Columns>
        <asp:BoundField DataField="fecha" HeaderText="Fecha" SortExpression="fecha" DataFormatString="{0:d}" />
        <asp:BoundField HeaderText="Documento reportado" DataField="documento" SortExpression="documento" />
        <asp:BoundField HeaderText="Factura" DataField="factura" SortExpression="factura" ItemStyle-HorizontalAlign="Right" />
        <asp:BoundField HeaderText="Paciente" DataField="pacNombres" SortExpression="pacNombres" ItemStyle-Wrap="false" />
        <asp:BoundField HeaderText="Aseguradora reportada" DataField="aseguradora" SortExpression="aseguradora" ItemStyle-Wrap="false" />
        <asp:BoundField HeaderText="Aseguradora Paciente" DataField="entNombre" SortExpression="entNombre" />
        <asp:HyperLinkField HeaderText="Archivo" SortExpression="archivo" DataNavigateUrlFields="archivo" DataNavigateUrlFormatString="~/archivo/archivo.ashx?n={0}.tif&t=d" DataTextField="archivo" ItemStyle-Wrap="false" />
        <asp:BoundField HeaderText="Páginas" DataField="paginas" SortExpression="paginas" ItemStyle-HorizontalAlign="Right" />
    </Columns>
</asp:GridView>
    <asp:SqlDataSource ID="SArchivo" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT fecha,paciente,factura,documento,aseguradora,archivo,paginas 
                    ,paciente.pacNombres,asegurador.entNombre
                    FROM digitalizacion
                    LEFT JOIN paciente ON (paciente.pacId=digitalizacion.paciente)
                    LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                    WHERE 
                    (@paciente=0 OR @paciente=digitalizacion.paciente)
                    AND (@factura=0 OR digitalizacion.factura LIKE CONCAT('%',@factura,'%'))
                    AND (@asegurador=0 OR @asegurador=paciente.entId)
                    ">
          <SelectParameters>
            <asp:ControlParameter ControlID="TPacienteID" Name="paciente" DefaultValue="0" />
            <asp:ControlParameter ControlID="TFactura" Name="factura" DefaultValue="0" />
            <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
          </SelectParameters>
</asp:SqlDataSource>
<div align="right">
    <asp:Label runat="server" ID="LTotal"></asp:Label>
</div>
<asp:PlaceHolder runat="server" ID="PImportacion" Visible="false">
<table>
    <tr>
        <td colspan="3">
        Consideraciones para importar la formulación
        <ul>
            <li>La primera linea de importacion se omite.</li>
            <li>Despues de una columna con el título en blanco el resto son omitidas</li>
            <li>Despues de una fila en blanco el resto de filas son omitidas</li>
            <li>El formato de fecha es YYYYMMDD</li>
            <li>El archivo debe estar codificado en UTF-7.</li>
        </ul>
        </td>
    </tr>
    <tr>
        <td>Importar archivo separador por comas (Max: 20MB)</td>
        <td><asp:FileUpload runat="server" ID="FImportar" /></td>
        <td><asp:Button runat="server" ID="BImportar" Text="Importar" ValidationGroup="archivo" onclick="BImportar_Click" /></td>
    </tr>
    <tr>
        <td colspan="3">
            <asp:RegularExpressionValidator ValidationGroup="archivo" ID="RFoto1" SetFocusOnError="true" ValidationExpression="^.+\.((csv)|(CSV))$" Display="Dynamic" ControlToValidate="FImportar" runat="server" ErrorMessage="Por favor seleccione un archivo csv valido."></asp:RegularExpressionValidator>
            <asp:RequiredFieldValidator ValidationGroup="archivo" ControlToValidate="FImportar" ErrorMessage="Por favor seleccione una archivo." ID="RFFoto1" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
        </td>
    </tr>
</table>
</asp:PlaceHolder>
</asp:Content>

