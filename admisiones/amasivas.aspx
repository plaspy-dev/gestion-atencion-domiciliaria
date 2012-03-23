<%@ Page Title="Autorizaciones masivas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="amasivas.aspx.cs" Inherits="admisiones_amasivas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= TPaciente.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPacienteI",
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

                $("#<%= TPaciente.ClientID %>").val(ui.item.label);
                $("#<%= TPacienteID.ClientID %>").val(ui.item.value);
                return false;
            }
        });
        $("#<%=BAceptar.ClientID %>").click(function() { return confirm("¿Esta seguro de hacer " + $('input[src*="eliminar.gif"]').length + " programaciones?"); });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table style="width: 100%;">
        <tr>
            <td colspan="4">
                <asp:Label Text="" runat="server" ID="LError" ForeColor="Red"></asp:Label>
                <asp:ValidationSummary runat="server" ID="ValidationSummary1" />
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GPacientes" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="pacId" onrowdeleting="GPacientes_RowDeleting" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                        <asp:BoundField DataField="Paciente" HeaderText="Paciente" />
                        <asp:BoundField DataField="Entidad" HeaderText="Entidad" />
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td>
                Paciente
            </td>
            <td colspan="2">
                <asp:TextBox ID="TPaciente" Width="99%" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ValidationGroup="paciente" ControlToValidate="TPacienteID" ErrorMessage="Por favor seleccione un paciente." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                <asp:TextBox ID="TPacienteID" CssClass="hide" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:Button ID="BAgregar" runat="server" Text="+" ValidationGroup="paciente" onclick="BAgregar_Click" />
            </td>
        </tr>
        <tr>
            <td>
                Fecha</td>
            <td>
                <asp:TextBox ID="TFecha" CssClass="fecha" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td>
                Vencimiento</td>
            <td>
                <asp:TextBox ID="TVencimiento" CssClass="fecha" runat="server"></asp:TextBox>
                <asp:RangeValidator ControlToValidate="TVencimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                <asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ErrorMessage="Por favor ingrese una fecha mayor." ControlToCompare="TFecha" 
                    ControlToValidate="TVencimiento" Display="Dynamic" Operator="GreaterThan" 
                    SetFocusOnError="True" Type="Date">*</asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td>
                Observaciones</td>
            <td colspan="3">
                <asp:TextBox ID="TObservaciones" runat="server" TextMode="MultiLine" Width="99%"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GActivades" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="actId" DataSourceID="SActividades" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
                        <asp:TemplateField HeaderText="Núm. ses.">
                            <ItemStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:TextBox ID="TNSesiones" Width="40" CssClass="entero" runat="server" Text=""></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Ses./día">
                            <ItemStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:TextBox ID="TSDia" Width="40" CssClass="entero" runat="server" Text=""></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SActividades" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT phdActividad.actId,phdActividad.actDescripcion
                                FROM phdActividad
                                ORDER BY phdActividad.actDescripcion;">
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                    CausesValidation="false" onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
</asp:Content>

