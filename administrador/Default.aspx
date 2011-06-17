<%@ Page Title="Parametros" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="administrador_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel ID="Panel1" runat="server" DefaultButton="BAceptar">
    <table width="100%" border="0">
  <tr>
    <td valign="top">
        <asp:GridView ID="GTipo" runat="server" AutoGenerateColumns="False">
            <Columns>
                <asp:HyperLinkField DataNavigateUrlFields="tipo" 
                    DataNavigateUrlFormatString="~/administrador/?tipo={0}" 
                    DataTextField="nombre"  />
            </Columns>
        </asp:GridView>
      </td>
    <td><table width="100%" border="0">
      <tr>
        <td align="center" bgcolor="#406BAF" style="color: #FFF">
            <asp:Label ID="LTipo" runat="server"></asp:Label>
          </td>
      </tr>
      <tr>
        <td>
<table width="100%" border="0">
          <tr>
            <td>Nombre</td>
            <td>
                <asp:TextBox ID="TNombre" runat="server"></asp:TextBox>
              </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
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
            <td>&nbsp;</td>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" CausesValidation="False" 
                    Text="Cancelar" onclick="BCancelar_Click" />
              </td>
            <td>
                <asp:HiddenField ID="HTipo" runat="server" />
              </td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td>
            <asp:GridView ID="GResultado" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="id" DataSourceID="SqlDataSource1" 
                onselectedindexchanged="GResultado_SelectedIndexChanged">
                <Columns>
                    <asp:CommandField ButtonType="Image" 
                        ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" 
                        ShowDeleteButton="True" />
                    <asp:BoundField DataField="nombre" HeaderText="nombre" 
                        SortExpression="nombre" />
                    <asp:BoundField DataField="descripcion" HeaderText="descripcion" 
                        SortExpression="descripcion" />
                </Columns>
                <SelectedRowStyle CssClass="selecteditem" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre, descripcion FROM varios WHERE tipo=@tipo AND szReservado IS NULL" 
                DeleteCommand="UPDATE varios SET szReservado=-1 WHERE id=@id" >
                <SelectParameters>
                    <asp:QueryStringParameter QueryStringField="tipo" Name="tipo" Type="Int32" DefaultValue="1" />
                </SelectParameters>
            </asp:SqlDataSource>
          </td>
      </tr>
    </table></td>
  </tr>
</table>
</asp:Panel>
</asp:Content>

