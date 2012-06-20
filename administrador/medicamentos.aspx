<%@ Page Title="Formulación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="medicamentos.aspx.cs" Inherits="administrador_medicamentos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= TCodigo.ClientID%>,#<%= TNombre.ClientID %> ").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetMedicamentos",
                    data: "{ 'q': '" + request.term + "', 't': '<%= LTipos.SelectedValue %>' }",
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
                $.goURL("iMP=" + ui.item.value);
                return false;
            }
        });
    });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel ID="Panel1" runat="server" DefaultButton="BAceptar">
    <table width="100%" border="0">
  <tr>
    <td valign="top">
        <asp:ListBox ID="LTipos" runat="server" Height="200px"
            DataSourceID="STipos" DataTextField="nombre" DataValueField="id" AutoPostBack="true" 
            onselectedindexchanged="LTipos_SelectedIndexChanged">
        </asp:ListBox>
        <asp:SqlDataSource ID="STipos" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT id,nombre FROM varios WHERE tipo=19 AND szReservado IS NULL ORDER BY nombre" >
        </asp:SqlDataSource>
        <br />
      </td>
    <td valign="top"><table width="100%" border="0">
      <tr>
        <td class="Titulo">
            <asp:Label ID="LTipo" runat="server"></asp:Label>
          </td>
      </tr>
      <tr>
        <td>
<table width="100%" border="0">
          <tr>
            <td>Código</td>
            <td>
                <asp:TextBox ID="TCodigo" runat="server"></asp:TextBox>
              </td>
            <td align="right">
                <asp:HiddenField ID="HId" runat="server" />
              </td>
          </tr>
          <tr>
            <td>Nombre</td>
            <td>
                <asp:TextBox ID="TNombre" runat="server" Width="99%"></asp:TextBox>
              </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="TNombre" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un nombre." SetFocusOnError="True"></asp:RequiredFieldValidator>
              </td>
          </tr>
          <tr>
            <td>Principio activo</td>
            <td>
                <asp:TextBox ID="TPrincipio" runat="server"></asp:TextBox>
              </td>
            <td></td>
          </tr>
          <tr>
            <td>Forma</td>
            <td>
                <asp:TextBox ID="TForma" runat="server" Width="99%"></asp:TextBox>
              </td>
            <td></td>
          </tr>
          <tr>
            <td>Concentración</td>
            <td>
                <asp:TextBox ID="TConcentracion" runat="server"></asp:TextBox>
              </td>
            <td></td>
          </tr>
          <tr>
            <td>Aclaración</td>
            <td>
                <asp:TextBox ID="TAclaracion" runat="server" Width="99%"></asp:TextBox>
              </td>
            <td></td>
          </tr>
          <tr>
              <td>
                  Area</td>
              <td>
                  <asp:DropDownList ID="DCargo" runat="server" AppendDataBoundItems="true" 
                    DataSourceID="SCargo" DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SCargo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT carId id,carDescripcion nombre FROM dbo.admCargo ORDER BY 2">
                </asp:SqlDataSource>
              </td>
              <td>
                  &nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" CausesValidation="False" 
                    Text="Cancelar" onclick="BCancelar_Click" />
              </td>
            <td>
                &nbsp;
              </td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td>
            <asp:GridView ID="GResultado" runat="server" AutoGenerateColumns="False" 
                AllowPaging="true" PageSize="50"
                DataKeyNames="id" DataSourceID="SqlDataSource1" AllowSorting="true"
                onselectedindexchanged="GResultado_SelectedIndexChanged" 
                onrowdatabound="GResultado_RowDataBound">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                    <asp:BoundField DataField="codigo" HeaderText="Código" SortExpression="codigo" />
                    <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" />
                    <asp:BoundField DataField="principio" HeaderText="Principio activo" SortExpression="principio" />
                    <asp:BoundField DataField="forma" HeaderText="Forma" SortExpression="forma" />
                    <asp:BoundField DataField="concentracion" HeaderText="Concentración" SortExpression="concentracion" />
                    <asp:BoundField DataField="aclaracion" HeaderText="Aclaración" SortExpression="aclaracion" />
                    <asp:BoundField DataField="area" HeaderText="Área" SortExpression="area" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre, forma,codigo, principio, concentracion, aclaracion,area FROM medicamentos WHERE tipo=@tipo AND estado IS NULL ORDER BY nombre" 
                DeleteCommand="UPDATE medicamento SET estado=-1 WHERE id=@id" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="LTipos" PropertyName="SelectedValue" Name="tipo" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
          </td>
      </tr>
    </table></td>
  </tr>
</table>
</asp:Panel>
</asp:Content>

