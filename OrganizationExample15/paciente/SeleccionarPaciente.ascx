<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SeleccionarPaciente.ascx.cs" Inherits="paciente_SeleccionarPaciente" %>
<script type="text/javascript">
    if (typeof jQuery != 'undefined')
    $(function() {
        $("#<%= TPaciente.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: <%= PacienteURL %>,
                    data: "{ 'q': '" + request.term + "', 'e': '<%= CUsuario.GetInstance()["entidades"] %>'}",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            select: function(event, ui) {
                $.goURL("pid=" + ui.item.value);
                return false;
            }
        });
    });
</script>
Paciente: <asp:TextBox runat="server" ID="TPaciente"></asp:TextBox><asp:Label runat="server" Font-Bold="true" ID="LPaciente"></asp:Label>
<asp:RequiredFieldValidator ControlToValidate="TPaciente" runat="server" ValidationGroup="selpac">*</asp:RequiredFieldValidator>