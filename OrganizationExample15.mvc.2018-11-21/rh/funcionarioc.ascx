<%@ Control Language="C#" AutoEventWireup="true" Inherits="rh_funcionarioc" Codebehind="funcionarioc.ascx.cs" %>
<script type="text/javascript">
    $(function () {
        $("#<%= TFuncionario.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetPersonal",
            redirectURL: "<%= Request.Url.AbsolutePath + "?fid=" %>"
        });
    });
</script>
<asp:TextBox runat="server" ID="TFuncionario"></asp:TextBox><asp:label runat="server" ID="LNombre" Font-Bold="true"></asp:label>
<asp:HiddenField runat="server" ID="HIdFuncionario" />