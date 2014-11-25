<%@ Page Title="Categoría censo" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="categoria_censo.aspx.cs" Inherits="administrador_categoria_censo" %>

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
<table width="100%" border="0">
      <tr>
        <td>
<table width="100%" border="0" style="border-collapse: collapse;">
          <tr>
            <td>Nombre</td>
            <td>
                <asp:TextBox ID="TNombre" runat="server"></asp:TextBox>
              </td>
            <td>
                <asp:RequiredFieldValidator ID="R1" runat="server" 
                    ControlToValidate="TNombre" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un nombre." SetFocusOnError="True"></asp:RequiredFieldValidator>
              </td>
          </tr>
          <tr>
            <td>Descripción</td>
            <td>
                <asp:TextBox ID="TDescripcion" runat="server" EnableViewState="False"></asp:TextBox>
              </td>
            <td align="right">
                <asp:HiddenField ID="HId" runat="server" />
              </td>
          </tr>
          <tr>
            <td colspan="3" class="celdaTitulo">Procedimientos</td></tr>
            <tr>
                <td colspan="3" class="tdl tdr">
                    <asp:GridView ID="GProcedimientos" runat="server" AutoGenerateColumns="False" 
                        EmptyDataText="No se encontraron procedimientos" Width="100%" DataKeyNames="Id" 
                        onrowdeleting="GProcedimientos_RowDeleting">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField HeaderText="Procedimiento" DataField="Nombre" ItemStyle-Width="100%" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td class="tdl tdb">Procedimiento<asp:RequiredFieldValidator ControlToValidate="TProcedimientoID" ValidationGroup="proc"
                                ErrorMessage="Por favor ingrese un procedimiento." ID="R4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
                <td class="tdb"><asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hide"></asp:TextBox></td>
                <td class="tdr tdb"><asp:Button runat="server" Text="+" ID="BMas" ValidationGroup="proc" onclick="BMas_Click" /></td>
            </tr>
          <tr>
            <td></td>
            <td></td>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" CausesValidation="False" Text="Cancelar" onclick="BCancelar_Click" />
                <asp:HiddenField ID="HTipo" runat="server" />
              </td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td>
            <asp:GridView ID="GResultado" runat="server" AutoGenerateColumns="False" Width="100%" 
                DataKeyNames="id" DataSourceID="SqlDataSource1" 
                onselectedindexchanged="GResultado_SelectedIndexChanged" >
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                    <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="descripcion" HeaderText="Descripción" SortExpression="descripcion" ItemStyle-Width="100%" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre, descripcion FROM varios WHERE tipo=33 AND szReservado IS NULL ORDER BY nombre" 
                DeleteCommand="UPDATE varios SET szReservado=-1 WHERE id=@id" >
            </asp:SqlDataSource>
          </td>
      </tr>
    </table>
</asp:Content>

