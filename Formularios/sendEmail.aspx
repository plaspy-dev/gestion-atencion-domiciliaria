<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="sendEmail.aspx.vb" Inherits="ML.sendEmail"  ValidateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <asp:LinkButton ID="lnkEnviar" runat="server">Enviar</asp:LinkButton>
    <input type="hidden" id="contenido" name="contenido" />
    </form>
</body>
</html>
