<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administrador de Servicios Médicos OrganizationExample15::Inicio</title>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
    <link href="css/estilo.css" type="text/css" rel="stylesheet" />
    <style type="text/css">
        .style1
        {
            width: 167px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <br />
    <br />
    <br />
<table cellpadding="2" cellspacing="2" width="100%">
<tr><td align="center">
            <asp:Panel ID="Panel1" runat="server" CssClass="PanelInicio">
            <table width="300px" cellpadding="0" cellspacing="0"><tr><td align="center" colspan="2">
            <asp:Image ID="Image1" runat="server" ImageUrl="~/imgs/Logo.jpg"/>
                <hr />
                <br />
                </td></tr><tr><td align="center" colspan="2">
                <asp:Label ID="m_SMensaje" runat="server" Text="acceso al sistema" Width="100%" CssClass="lblsubTitulo"></asp:Label>
                    </td></tr>
                    <tr><td>
                <asp:Label ID="Label1" runat="server" Text="Usuario"></asp:Label>
                    </td><td align="left"><asp:TextBox ID="m_EUsuario" runat="server" MaxLength="25"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="m_EUsuario" Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                        </td></tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label2" runat="server" Text="Clave"></asp:Label>
                        </td>
                        <td align="left">
                            <asp:TextBox ID="m_EContrasena" runat="server" MaxLength="25" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="m_EContrasena" Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                        </td>
                </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Button ID="m_BIngresar" runat="server" Text="Aceptar" onclick="m_BIngresar_Click" />
                        </td>
                </tr>
                    </table>
            </asp:Panel>
</td></tr>
</table>
</form>
</body>
</html>
