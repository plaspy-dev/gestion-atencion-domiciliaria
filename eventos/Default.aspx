<%@ Page Title="Contactos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="eventos_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table>
        <tr>
            <td>
                <table>
        <tr>
            <td>
                Nombre
            </td>
            <td>
                <asp:TextBox ID="TNombre" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="TNombre" Display="Dynamic" SetFocusOnError="true" runat="server" ErrorMessage="Por favor ingrese un nombre"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Entidad
            </td>
            <td>
                <asp:TextBox ID="TEntidad" runat="server"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Teléfono
                contacto</td>
            <td>
                <asp:TextBox ID="TTelefono" runat="server"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
        </tr>
    </table>
            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" /><asp:Button ID="BCancelar"
                    runat="server" Text="Cancelar" CausesValidation="false" 
                    onclick="BCancelar_Click" /></td>
        </tr>
        <tr>
            <td>
                <asp:GridView ID="GContacto" runat="server" AutoGenerateColumns="False" Width="100%"
                DataKeyNames="id" DataSourceID="SContacto" AllowPaging="true" PageSize="20"
                    onselectedindexchanged="GContacto_SelectedIndexChanged" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                    <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" ItemStyle-Width="100%" />
                    <asp:BoundField DataField="direccion" HeaderText="Entidad" SortExpression="direccion" />
                    <asp:BoundField DataField="telefono" HeaderText="Teléfono" SortExpression="telefono" />
                </Columns>
                <SelectedRowStyle CssClass="selecteditem" />
            </asp:GridView>
            <asp:SqlDataSource ID="SContacto" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre, direccion, telefono FROM contacto WHERE estado IS NULL ORDER BY nombre" 
                DeleteCommand="UPDATE contacto SET estado=-1 WHERE id=@id" >
            </asp:SqlDataSource>
                </td>
        </tr>
    </table>
</asp:Content>

