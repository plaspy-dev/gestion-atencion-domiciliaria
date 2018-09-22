<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SeleccionarPaciente.ascx.cs" Inherits="paciente_SeleccionarPaciente" %>
<script type="text/javascript">
    if (typeof jQuery != 'undefined')
        $(function () {
        $("#<%= TPaciente.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetPacienteI",
            data: { 'e': '<%= CUsuario.GetInstance()["entidades"] %>' },
            redirectURL: "<%= Request.Url.AbsolutePath + "?pid=" %>"
        });
    });
</script>
Paciente: <asp:TextBox runat="server" ID="TPaciente"></asp:TextBox><asp:Label runat="server" Font-Bold="true" ID="LPaciente"></asp:Label>
<asp:RequiredFieldValidator ControlToValidate="TPaciente" runat="server" ValidationGroup="selpac">*</asp:RequiredFieldValidator>