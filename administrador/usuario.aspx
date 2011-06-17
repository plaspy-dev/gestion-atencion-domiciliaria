<%@ Page Title="Usuario" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="usuario.aspx.cs" Inherits="administrador_usuario" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <fieldset>
        <legend>Usuario</legend>
        <table>
        <tr>
            <td>
                Nombres<asp:HiddenField ID="HId" runat="server" />
            </td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="TNombres" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un nombre." SetFocusOnError="True"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Usuario</td>
            <td>
                <asp:TextBox ID="TUsuario" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="TUsuario" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un usuario." SetFocusOnError="True"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Grupo</td>
            <td>
                <asp:DropDownList ID="DGrupos" runat="server" DataSourceID="SGrupos" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="Administrador" Value="0" Selected="True"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SGrupos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM grupo" >
            </asp:SqlDataSource>
            </td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Contraseña</td>
            <td>
                <asp:TextBox ID="TContrasena" TextMode="Password" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RContrasena" runat="server" 
                    ControlToValidate="TContrasena" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese una contraseña." SetFocusOnError="True"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Confirmar contraseña</td>
            <td>
                <asp:TextBox ID="TConfirmar" TextMode="Password" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ControlToCompare="TContrasena" ControlToValidate="TConfirmar" Display="Dynamic" 
                    ErrorMessage="Las contraseñas no coinciden." SetFocusOnError="True"></asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                    CausesValidation="false" onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
    </fieldset>
    <asp:GridView ID="GUsuarios" runat="server" DataSourceID="SUsuarios" 
        DataKeyNames="id" AutoGenerateColumns="false" 
        onselectedindexchanged="GUsuarios_SelectedIndexChanged">
        <Columns>
                    <asp:CommandField ButtonType="Image" 
                        ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" 
                        ShowDeleteButton="True" />
                    <asp:BoundField DataField="nombre" HeaderText="Nombres" SortExpression="nombre" />
                    <asp:BoundField DataField="usuario" HeaderText="Usuario" SortExpression="usuario" />
                    <asp:BoundField DataField="grupo" HeaderText="Grupo" SortExpression="grupo" />
                    <asp:BoundField DataField="ingreso" HeaderText="Último ingreso" SortExpression="ingreso" />
        </Columns>
        <SelectedRowStyle CssClass="selecteditem" />
    </asp:GridView>
    <asp:SqlDataSource ID="SUsuarios" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT usuario.id AS id,usuario.nombre AS nombre,usuario.usuario AS usuario,IFNULL(grupo.nombre,'Administrador') AS grupo,usuario.ingreso AS ingreso FROM usuario LEFT JOIN grupo ON (usuario.grupo=grupo.id) WHERE usuario.estado IS NULL OR usuario.estado!=-1 ORDER BY usuario.nombre" 
                 DeleteCommand="UPDATE usuario SET estado=-1 WHERE id=@id">
    </asp:SqlDataSource>
</asp:Content>

