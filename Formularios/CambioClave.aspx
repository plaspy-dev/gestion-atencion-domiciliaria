<%@ Page Title="Cambio de Clave" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="CambioClave.aspx.vb" Inherits="ML.CambioClave"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
    .style2
    {
        width: 100%;
        border-style: solid;
        border-width: 1px;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table class="style2">
    <tr>
        <td>
            <asp:Label ID="Label3" runat="server" Text="Digite la Clave Actual"></asp:Label>
        </td>
        <td>
            <asp:TextBox ID="txtClaveAnt" runat="server" TextMode="Password" MaxLength="25"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                ControlToValidate="txtClaveAnt" Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label1" runat="server" Text="Digite la nueva Clave"></asp:Label>
        </td>
        <td>
            <asp:TextBox ID="txtClave" runat="server" TextMode="Password" MaxLength="25"></asp:TextBox>
            <asp:PasswordStrength ID="txtClave_PasswordStrength" runat="server" 
                Enabled="True" MinimumLowerCaseCharacters="4" MinimumNumericCharacters="2" 
                PreferredPasswordLength="8" PrefixText="Seguridad: " TargetControlID="txtClave" 
                TextCssClass="verificadorClave" 
                TextStrengthDescriptions="Vacío;Débil;Promedio;Buena;Excelente">
            </asp:PasswordStrength>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                ControlToValidate="txtClave" Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label2" runat="server" Text="Confirme la nueva Clave"></asp:Label>
        </td>
        <td>
            <asp:TextBox ID="txtConfirmaClave" runat="server" TextMode="Password" 
                MaxLength="25"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                ControlToValidate="txtConfirmaClave" Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
&nbsp;<asp:CompareValidator ID="CompareValidator1" runat="server" 
                ControlToCompare="txtClave" ControlToValidate="txtConfirmaClave" 
                CssClass="validador" Display="Dynamic" ErrorMessage="Las Claves no coinciden"></asp:CompareValidator>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align: center">
            <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" />
        </td>
    </tr>
</table>
</asp:Content>
