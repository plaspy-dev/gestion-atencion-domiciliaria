<%@ Page Title="Intensidad procedimientos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="intensidad.aspx.cs" Inherits="administrador_intensidad" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= TProcedimiento.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetMedicamentos",
                    data: "{ 'q': '" + request.term + "', 't': '173' }",
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
                $("#<%= TProcedimientoID.ClientID %>").val(ui.item.value);
                $("#<%= TProcedimiento.ClientID %>").val(ui.item.label);
                return false;
            },
            search: function(event, ui) {
                $("#<%= TProcedimientoID.ClientID %>").val("");
            }
        }).change(function() { if ($(this).val() == "") $("#<%= TProcedimientoID.ClientID %>").val(""); });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:UpdatePanel runat="server" ID="PDatos" UpdateMode="Conditional">
<ContentTemplate>
    <asp:Panel ID="PBoton" runat="server" DefaultButton="BAceptar">
    <table style="width: 100%;">
        <tr>
            <td>
                <table style="width: 100%;">
        <tr>
            <td>
                Nombre</td>
            <td>
                <asp:TextBox runat="server" ID="TNombre"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ControlToValidate="TNombre" ErrorMessage="Por favor ingrese un nombre." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>Procedimiento</td>
            <td><asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hide"></asp:TextBox></td>
            <td><asp:RequiredFieldValidator ControlToValidate="TProcedimientoID" ErrorMessage="Por favor ingrese un procedimiento." ID="RProcedimiento" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td colspan="3" class="GridHeader">Costos por entidad</td>
        </tr>
        <tr>
            <td colspan="3">
                <asp:GridView ID="GEntidades" runat="server" AutoGenerateColumns="False" DataSourceID="SEntidades" 
                    EmptyDataText="No se encontraron entidades" DataKeyNames="id" onrowdatabound="GEntidades_RowDataBound">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField HeaderText="Entidad" DataField="nombre" />
                        <asp:TemplateField HeaderText="Costo del servicio">
                            <ItemTemplate>
                                <asp:TextBox runat="server" CssClass="dinero" ID="TCosto"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SEntidades" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM dbo.admEntidad WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                <asp:Button ID="BCancelar" runat="server" onclick="BCancelar_Click" Text="Cancelar" CausesValidation="False" />
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>
            </td>
        </tr>
        <tr>
            <td>
                <asp:GridView ID="GResultado" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="id,idproc" DataSourceID="SqlDataSource2" 
                    onselectedindexchanged="GResultado_SelectedIndexChanged" 
                    onrowdeleted="GResultado_RowDeleted">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                    <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" />
                    <asp:BoundField DataField="procedimiento" HeaderText="Procedimiento" SortExpression="procedimiento" />
                </Columns>
                <SelectedRowStyle CssClass="selecteditem" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id,varios.nombre
                        ,CONCAT(medicamentos.codigo, ' - ',medicamentos.nombre) AS procedimiento,varios.parametro1 AS idproc
                        FROM varios
                        LEFT JOIN medicamentos ON (medicamentos.id=varios.parametro1)
                        WHERE varios.tipo=21 AND varios.estado IS NULL ORDER BY nombre;" 
                DeleteCommand="UPDATE varios SET estado=-1 WHERE id=@id" >
            </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
        </tr>
    </table>
    </asp:Panel>
    </ContentTemplate></asp:UpdatePanel>
</asp:Content>

