<%@ Page Title="Formulación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="medicamentos.aspx.cs" Inherits="administrador_medicamentos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <script type="text/javascript">
    addFunctionToStart(function() {
        $("#accordion").accordion({
            autoHeight: false,
            navigation: true,
            collapsible: true,
            active: false
        });
        $("#<%= TCodigo.ClientID%>,#<%= TNombre.ClientID %> ").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetMedicamentos",
                    data: "{ 'q': '" + request.term + "', 't': " + $("#<%= LTipos.ClientID %>").val() + " }",
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
                $.goURL("imp=" + ui.item.value);
                return false;
            }
        });
    });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:UpdatePanel runat="server" ID="PDatos" UpdateMode="Conditional">
<ContentTemplate>
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
                  Área</td>
              <td><asp:DropDownList ID="DGrupo" runat="server" DataSourceID="SGrupo" AppendDataBoundItems="true"
                    DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SGrupo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=22 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
                  </td>
              <td>
                  &nbsp;</td>
          </tr>
          <tr>
            <td></td>
            <td><asp:CheckBox runat="server" ID="CAutomatica" Text="Programación automática" Visible="false" /></td>
            <td></td>
          </tr>
          <tr>
              <td colspan="3">
              <div id="accordion">
                    <h3><a href="#">Cargo</a></h3>
                    <div class="hide">
                        <asp:GridView ID="GCargos" runat="server" DataSourceID="SCargos" 
                            DataKeyNames="id" AutoGenerateColumns="false" ShowHeader="false"
                            AllowSorting="True" onrowdatabound="GCargos_RowDataBound">
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField HeaderText="Permiso">
                                    <ItemTemplate>
                                        <asp:CheckBox runat="server" ID="CCargo" Checked="false" Text='<%# Eval("nombre").ToString() %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SCargos" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                                SelectCommand="SELECT carId id,carDescripcion nombre FROM dbo.admCargo ORDER BY 2;">
                        </asp:SqlDataSource>
                    </div>
                    <h3><a href="#">Costos y restricciones</a></h3>
                    <div class="hide">
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
                                <asp:TemplateField HeaderText="Formulación máxima mensual paciente">
                                    <ItemTemplate>
                                        <asp:TextBox runat="server" CssClass="entero" ID="TMaxima"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SEntidades" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:connBD %>" 
                            SelectCommand="SELECT entId id,entNombre nombre FROM dbo.admEntidad WHERE entEPS=1 ORDER BY 2">
                        </asp:SqlDataSource>
                    </div>
                    </div>
                  </td>
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
                    <asp:BoundField DataField="codigo" HeaderText="Código" SortExpression="codigo" />
                    <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" />
                    <asp:BoundField DataField="principio" HeaderText="Principio activo" SortExpression="principio" />
                    <asp:BoundField DataField="forma" HeaderText="Forma" SortExpression="forma" />
                    <asp:BoundField DataField="concentracion" HeaderText="Concentración" SortExpression="concentracion" />
                    <asp:BoundField DataField="aclaracion" HeaderText="Aclaración" SortExpression="aclaracion" />
                    <asp:BoundField DataField="grupo" HeaderText="Área" SortExpression="grupo" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT medicamentos.id, medicamentos.nombre, medicamentos.forma,medicamentos.codigo, medicamentos.principio, medicamentos.concentracion, medicamentos.aclaracion,grupo.nombre AS grupo FROM medicamentos LEFT JOIN varios AS grupo ON (grupo.id=medicamentos.grupo) WHERE medicamentos.tipo=@tipo AND medicamentos.estado IS NULL ORDER BY medicamentos.nombre" 
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
</ContentTemplate>
</asp:UpdatePanel>
</asp:Content>

