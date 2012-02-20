<%@ Page Title="Formulación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="formulacion.aspx.cs" Inherits="paciente_formulacion" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    function iniciopagina() {
        $("#<%= TMedicamento.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetMedicamentos",
                    data: "{}",
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
                $("#<%= TMedicamentoID.ClientID %>").val(ui.item.value);
                $("#<%= TMedicamento.ClientID %>").val(ui.item.label);
                return false;
            },
            search: function(event, ui) {
                $("#<%= TMedicamentoID.ClientID %>").val("");
                // $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
            }
        }).change(function() { if ($(this).val() == "") $("#<%= TMedicamentoID.ClientID %>").val(""); });
    };
    $(function() {
        $("#<%= TFecha.ClientID %>").datepicker({
            onClose: function(dateText, inst) { if ($.getUrlVar('f') != $(this).val()) $("#<%=BFecha.ClientID %>").click(); }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<div id="dImprimir">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:Panel runat="server" id="PDatos" Visible="false">
        <asp:HiddenField ID="HIdFormulacion" runat="server" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table>
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                            <asp:Button ID="BFecha" CssClass="hide" runat="server" Text="..." onclick="BFecha_Click" /></td>
                <td><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese una fecha." SetFocusOnError="true" ControlToValidate="TFecha" Display="Dynamic"></asp:RequiredFieldValidator><asp:RangeValidator ID="RangeValidator1" runat="server" MinimumValue="12/12/1900" MaximumValue="12/12/2100" SetFocusOnError="true" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." Display="Dynamic" Type="Date"></asp:RangeValidator></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Formulación</td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:GridView ID="GFormulacion" runat="server" DataSourceID="SFormulacion" 
                    AutoGenerateColumns="False" DataKeyNames="id"
                                        onselectedindexchanged="GFormulacion_SelectedIndexChanged" >
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField DataField="medicamen_id" HeaderText="idMedicamento" ItemStyle-CssClass="hide" HeaderStyle-CssClass="hide" />
                            <asp:BoundField DataField="medicamento" HeaderText="Nombre del medicamento" />
                            <asp:BoundField DataField="formulada" HeaderText="Cantidad formulada" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="posologia" HeaderText="Posología" />
                        </Columns>
                        <SelectedRowStyle CssClass="selecteditem" />
                    </asp:GridView>
                    <sdg:CustomDataSource ID="SFormulacion" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT medicamento_formulacion.id,medicamento_formulacion.medicamento AS medicamen_id,medicamento_formulacion.formulada,medicamento_formulacion.posologia 
                                            ,CONCAT(medicamentos.nombre,' (',medicamentos.cantidad,medicamentos.umedida,'), vía ',medicamentos.via,'-',medicamentos.forma) AS medicamento
                                            FROM medicamento_formulacion 
                                            LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento)
                                            WHERE formulacion=@formulacion"
                            DeleteCommand="DELETE FROM medicamento_formulacion WHERE id=@id"
                            InsertCommand="INSERT INTO medicamento_formulacion (formulacion,medicamento,posologia,formulada) VALUES (@formulacion,@medicamen_id,@posologia,@formulada)"
                            UpdateCommand="UPDATE medicamento_formulacion SET medicamento=@medicamen_id,posologia=@posologia,formulada=@formulada WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdFormulacion" DefaultValue="0" PropertyName="Value" Name="formulacion" />
                            </SelectParameters>
                    </sdg:CustomDataSource>
                </td>
            </tr>
            <tr>
                <td>Medicamento<asp:RequiredFieldValidator ValidationGroup="medicamento" ControlToValidate="TMedicamentoID" ErrorMessage="Por favor ingrese un medicamento." ID="RMedicamento" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                                <td colspan="3"><asp:TextBox Width="99%" runat="server" ID="TMedicamento"></asp:TextBox><asp:TextBox runat="server" ID="TMedicamentoID" CssClass="hide"></asp:TextBox>
                                </td>
            </tr>
            <tr>
                <td>Cantidad<asp:RequiredFieldValidator ValidationGroup="medicamento" ControlToValidate="TCantidad" ErrorMessage="Por favor ingrese una cantidad." ID="RCantidad" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                                    <td><asp:TextBox runat="server" ID="TCantidad" Width="50px" CssClass="entero"></asp:TextBox>
                                </td>
                                <td>Posología<asp:RequiredFieldValidator ValidationGroup="medicamento" ControlToValidate="TPosologia" ErrorMessage="Por favor ingrese una posología." ID="RPosologia" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                                <td><asp:TextBox runat="server" ID="TPosologia" Width="400px"></asp:TextBox>
                                </td>
            </tr>
            <tr>
                <td colspan="4" align="right">
                                <asp:ValidationSummary runat="server" ID="ValidationSummary1" ShowMessageBox="true" ValidationGroup="medicamento" />
                                <asp:Button ID="BMasFormulacion" ValidationGroup="medicamento" runat="server" onclick="BMasFormulacion_Click" Text="+" />
                                </td>
            </tr>
            <tr>
                <td align="right" colspan="4">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" /><asp:Button ID="BCancelar" 
                    CausesValidation="false" runat="server" Text="Cancelar" 
                    onclick="BCancelar_Click" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    </div>
</asp:Content>