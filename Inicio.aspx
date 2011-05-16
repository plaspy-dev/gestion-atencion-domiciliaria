<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Inicio.aspx.vb" Inherits="ML.Inicio" %>
<%@ Register src="Controles/AuditServicios.ascx" tagname="AuditServicios" tagprefix="uc1" %>
<%@ Register src="Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Administrador de Servicios Médicos Gestión de atención domiciliaria::Incio</title>
    <script type="text/javascript" src="Util/Util.js"></script>
    <style type="text/css">
        .style1
        {
            width: 167px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <br />
    <br />
    <br />
<table cellpadding="2" cellspacing="2" width="100%">
<tr><td align="center">
    
            <asp:Panel ID="Panel1" runat="server" CssClass="PanelInicio">
            <table width="300px" cellpadding="0" cellspacing="0"><tr><td align="center" colspan="2">
            <asp:Image ID="Image1" runat="server" SkinID="imgLogo"/>
                <br />
                <br />
                </td></tr><tr><td align="center" colspan="2">
                <asp:Label ID="Label3" runat="server" Text="acceso al sistema" Width="100%" SkinID="lblsubTitulo"></asp:Label>
                    </td></tr>
                    <tr><td>
                <asp:Label ID="Label1" runat="server" Text="Usuario"></asp:Label>
                    </td><td align="left"><asp:TextBox ID="txtUsuario" runat="server" MaxLength="25"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="txtUsuario" Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                        </td></tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label2" runat="server" Text="Clave"></asp:Label>
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtClave" runat="server" MaxLength="25" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="txtClave" Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                        </td>
                </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" />                            
                        </td>
                </tr>
                    </table>                
                
            </asp:Panel>
</td></tr>
</table>
<asp:DropShadowExtender ID="dse" runat="server"
    TargetControlID="Panel1" 
    Opacity=".8" 
    Rounded="true"
    Radius="6"
    TrackPosition="true"/>
    </form>
    <script type="text/javascript">
        <%if txtUsuario.text="" %>
            setTimeout("getEl('<%=txtUsuario.clientId%>').focus()", 500);
        <%else%>    
            setTimeout("getEl('<%=txtClave.clientId%>').focus()", 500);
        <%end if %>
    </script>
    <p>
        &nbsp;</p>
        <br />
        <br />
        <br />
        <br />
        <br />
    
    
</body>
</html>
