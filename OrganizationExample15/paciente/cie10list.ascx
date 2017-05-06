<%@ Control Language="C#" AutoEventWireup="true" CodeFile="cie10list.ascx.cs" Inherits="paciente_cie10list" %>
<script type="text/javascript">
    $inicio(function () {
        $("#<%= TCIE10.ClientID %>").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetCodigoDiagnosticos",
                    data: "{}",
                    data: "{ 'q': '" + request.term + "' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function (data) { return data; },
                    success: function (data) {
                        response($.map(data.d, function (item) {
                            return {
                                value: item.Name, label: item.Name
                            }
                        }))
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 2,
            select: function (event, ui) {
            },
            search: function (event, ui) {
                // $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
            }
        });
    });
</script>
<asp:GridView ID="GCDiagnostico" runat="server" Width="100%"
    AutoGenerateColumns="False" DataKeyNames="Id"
    onselectedindexchanged="GCDiagnostico_SelectedIndexChanged" OnRowDeleting="GCDiagnostico_RowDeleting" >
    <RowStyle CssClass="GridRow"></RowStyle>
<FooterStyle CssClass="GridFooter"></FooterStyle>
<PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
<SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
<HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
<AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
    <Columns>
        <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="S" CssClass="btn btn-success btn-xs" CausesValidation="False" CommandName="Select" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
        <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="D" CssClass="btn btn-danger btn-xs" CausesValidation="False" CommandName="Delete" ToolTip="Eliminar"><i class="fa fa-trash-o"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
        <asp:BoundField DataField="Id" HeaderText="Código" />
        <asp:BoundField DataField="Nombre" HeaderText="Descripción" ItemStyle-Width="100%" />
    </Columns>
    <SelectedRowStyle CssClass="selecteditem" />
</asp:GridView>
<asp:Panel runat="server" ID="P" DefaultButton="BMasCDiagnostico">
<table style="width: 100%">
    <tr>
        <td class="nowrap">CIE10<asp:RequiredFieldValidator ControlToValidate="TCIE10" ValidationGroup="cie10" ErrorMessage="Por favor ingrese un CIE10." ID="R5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td style="width: 100%"><asp:TextBox runat="server" Width="100%" ID="TCIE10"></asp:TextBox></td>
        <td><asp:Button ID="BMasCDiagnostico" runat="server" OnClick="BMasCDiagnostico_Click" Text="+" ValidationGroup="cie10" /></td>
    </tr>
</table>
</asp:Panel>