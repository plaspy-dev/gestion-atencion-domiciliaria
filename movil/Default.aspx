<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ingreso</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link type="text/css" rel="Stylesheet" href="<%: HomeCareVersion.CssPath("m.min.css") %>" />
    <link type="text/css" rel="Stylesheet" href="<%: HomeCareVersion.CssPath("jquery.mobile.icons.min.css") %>" />
    <link type="text/css" rel="Stylesheet" href="<%: HomeCareVersion.CssPath("jquery.mobile.structure-1.4.5.min.css") %>" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div data-role="page">
            <div role="main" class="ui-content">
                <asp:Image runat="server" ID="I" ImageUrl="~/img/logo.jpg" />
                <table style="width: 100%">
                    <tr>
                        <td>Usuario<asp:RequiredFieldValidator ControlToValidate="TU" ErrorMessage="Por favor ingrese un nombre de usuario." ID="R4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td><asp:TextBox runat="server" ID="TU"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Contraseña</td>
                        <td><asp:TextBox TextMode="Password" runat="server" ID="TC"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label runat="server" ID="LM" ForeColor="Red"></asp:Label>
                            <asp:ValidationSummary runat="server" ID="V" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Button runat="server" ID="BA" Text="Ingresar" data-theme="b" OnClick="BA_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    </form>
    <script type="text/javascript" src="<%=HomeCareVersion.JSPath("jquery-2.1.4.min.js")%>"></script>
    <script type="text/javascript" src="<%=HomeCareVersion.JSPath("jquery.mobile-1.4.5.min.js")%>"></script>
    <script type="text/javascript">
        $(function() {
            $.mobile.ajaxEnabled = false;
            document.addEventListener("deviceready", function () { }, false);
        });
    </script>
</body>
</html>
