<%@ Control Language="C#" AutoEventWireup="true" CodeFile="funcionarioc.ascx.cs" Inherits="rh_funcionarioc" %>
<script type="text/javascript">
    $(function() {
        $("#<%= TFuncionario.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPersonal",
                    data: "{ 'q': '" + request.term + "' }",
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
                $.goURL("fid=" + ui.item.value);
                return false;
            }
        });
    });
</script>
<asp:TextBox runat="server" ID="TFuncionario"></asp:TextBox><asp:label runat="server" ID="LNombre" Font-Bold="true"></asp:label>
<asp:HiddenField runat="server" ID="HIdFuncionario" />