<%@ Page Title="Recibo" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="recibos.aspx.cs" Inherits="admisiones_recibos" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(function () {
        $("#<%= TNumero.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetAutorizaciones",
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

                $.goURL("aut=" + ui.item.value);
                return false;
            }
        });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc4:detallepaciente ID="CCDetallePaciente" runat="server" Visible="false" />
<asp:UpdatePanel runat="server" ID="P" UpdateMode="Conditional">
    <ContentTemplate>
        <table style="width: 100%;">
            <tr>
                <td width=1><asp:HyperLink runat="server" ID="HA" Target="_blank" Text="Autorización"></asp:HyperLink></td>
                <td width=1>
                    <asp:TextBox ID="TNumero" runat="server"></asp:TextBox>
                </td>
                <td colspan="2"></td>
            </tr>
        <asp:PlaceHolder runat="server" ID="PD" Visible="false">
            <tr>
                <td class="nw">Valor Autorización</td>
                <td class="tar"><asp:Label runat="server" ID="LValor" Font-Bold="true"></asp:Label></td>
                <td>Valor Pagado</td>
                <td class="tar"><asp:Label runat="server" ID="LPagado" Font-Bold="true"></asp:Label></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Recibos</td>
            </tr>
            <tr>
                <td colspan="4" class="tdr tdl">
                    <asp:GridView ID="GPagos" runat="server" AutoGenerateColumns="False"  Width="100%"
                    DataKeyNames="id" DataSourceID="SPagos" EmptyDataText="No hay recibos" 
                        onselectedindexchanged="GPagos_SelectedIndexChanged" OnRowDeleted="GPagos_RowDeleted" >
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
                            <asp:BoundField DataField="recibo" HeaderText="Recibo" ItemStyle-Width="100%" />
                            <asp:TemplateField HeaderText="Valor">
                                <ItemTemplate>
                                    <span id="vpagado"><%# Eval("valor", "{0:c}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SPagos" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT id,valor,recibo FROM pago_autorizacion WHERE autNumero=@autorizacion"
                        DeleteCommand="DELETE FROM pago_autorizacion WHERE id=@id">
                        <SelectParameters>
                            <asp:Parameter Name="autorizacion" DefaultValue="0" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr class="tdl tdr">
                <td>Número recibo<asp:RequiredFieldValidator ControlToValidate="TRecibo" ErrorMessage="Por favor ingrese un numero de recibo." ID="RR" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>
                    <asp:TextBox ID="TRecibo" CssClass="entero" runat="server"></asp:TextBox>
                </td>
                <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RF" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
            </tr>
            <tr class="tdl tdr">
                <td>
                    Valor recibo<asp:RequiredFieldValidator ControlToValidate="TAbono" ErrorMessage="Por favor ingrese un valor de recibo." ID="RV" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>
                    <asp:TextBox ID="TAbono" CssClass="dinero" runat="server"></asp:TextBox>
                </td>
                <td></td>
                <td></td>
            </tr>
            <tr class="tdl tdr tdb">
                <td colspan="4">
                    <asp:ValidationSummary runat="server" ID="V" />
                    <asp:Label runat="server" Id="LMessage" ForeColor="Red"></asp:Label>
                    <div class="pull-right">
                        <asp:Button ID="BAgregar" runat="server" Text="Agregar" CssClass="" 
                            onclick="BAgregar_Click" />&nbsp;<asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                            CssClass="" CausesValidation="false" OnClick="BCancelar_Click" />
                    </div>
                </td>
            </tr>
        </asp:PlaceHolder>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>