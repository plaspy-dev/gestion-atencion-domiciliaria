<%@ Page Title="Contraseña" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="contrasena.aspx.cs" Inherits="contrasena" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="c" Runat="Server">
    <table style="width: 100%">
    <tr>
        <td>Actual<asp:RequiredFieldValidator ID="R3" runat="server" ControlToValidate="m_EContrasena" Display="Dynamic" ErrorMessage="Por favor ingrese una contraseña" SetFocusOnError="True">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox ID="m_EActual" runat="server" TextMode="Password"></asp:TextBox></td>
    </tr>
        <tr>
            <td>Nueva<asp:RegularExpressionValidator ID="R1" runat="server" ErrorMessage="Por favor ingrese una contraseña valida, mínimo 8 carácteres, una letra mayúscula, una letra minúscula y un numero." ControlToValidate="m_EContrasena" Display="Dynamic" SetFocusOnError="True" ValidationExpression="^.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*$">*</asp:RegularExpressionValidator>
                <asp:CompareValidator ID="C2" runat="server" ControlToCompare="m_EActual" ControlToValidate="m_EConfirmar" Display="Dynamic" ErrorMessage="La contraseña nueva es igual a la actual" SetFocusOnError="True" Operator="NotEqual">*</asp:CompareValidator>
            </td>
            <td><asp:TextBox ID="m_EContrasena" runat="server" TextMode="Password"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Confirmar<asp:CompareValidator ID="C1" runat="server" ControlToCompare="m_EContrasena" ControlToValidate="m_EConfirmar" Display="Dynamic" ErrorMessage="Las contraseñas no coinciden" SetFocusOnError="True">*</asp:CompareValidator>
            <asp:RequiredFieldValidator ID="R2" runat="server" ControlToValidate="m_EConfirmar"
                    Display="Dynamic" ErrorMessage="Por favor confirme la contraseña" SetFocusOnError="True">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox ID="m_EConfirmar" runat="server" TextMode="Password"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
                <asp:ValidationSummary runat="server" ID="V" />
            </td>
        </tr>
    <tr>
        <td colspan="2" align="right">
            <asp:Button ID="m_BCambiar" data-theme="b" runat="server" OnClick="m_BCambiar_Click" Text="Cambiar" />
            <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" />
        </td>
    </tr>
</table>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="s" Runat="Server">
</asp:Content>

