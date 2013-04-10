<%@ Page Title="Orden médica" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="formulacion.aspx.cs" Inherits="paciente_formulacion" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        $("#<%= TMedicamento.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetMedicamentos",
                    data: "{}",
                    data: "{ 'q': '" + request.term + "', 't': '" + $("#<%= DTipo.ClientID %>").val() + "' }",
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

        $("#<%= TFecha.ClientID %>").datepicker({
            onClose: function(dateText, inst) { if ($.getUrlVar('f') != $(this).val()) $("#<%=BFecha.ClientID %>").click(); }
        });
        $("#<%= PFormulaciones.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });

        FullRowSelect("#<%= GFormulaciones.ClientID %>");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<div id="dImprimir">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
        <ContentTemplate>
        <asp:HiddenField ID="HIdFormulacion" runat="server" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table>
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                            <asp:Button ID="BFecha" CssClass="hide" runat="server" Text="..." onclick="BFecha_Click" /></td>
                <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese una fecha." SetFocusOnError="true" ControlToValidate="TFecha" Display="Dynamic"></asp:RequiredFieldValidator><asp:RangeValidator ID="RangeValidator1" runat="server" MinimumValue="12/12/1900" MaximumValue="12/12/2100" SetFocusOnError="true" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." Display="Dynamic" Type="Date"></asp:RangeValidator></td>
                <td align="right">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td>
                    Tipo</td>
                <td>
                    <asp:DropDownList ID="DTipo" runat="server" DataSourceID="STipo" DataTextField="nombre" DataValueField="id" AutoPostBack="true" OnSelectedIndexChanged="BFecha_Click">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="STipo" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=19 AND szReservado IS NULL ORDER BY nombre">
                    </asp:SqlDataSource></td>
                <td>
                    &nbsp;</td>
                <td align="right">
                    <asp:Button ID="BFormula" runat="server" CausesValidation="False" 
                        onclick="BFormula_Click" Text="Última" /></td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:Panel ID="PFormulaciones" runat="server">
                    <h3><a href="#"><asp:Label runat="server" ID="LFormulaciones"></asp:Label></a></h3>
                    <div class="hide">
                        <asp:GridView ID="GFormulaciones" runat="server" AutoGenerateColumns="False" 
                            DataSourceID="SFormulaciones" EmptyDataText="No se encontraron Formulaciones de este usuario" >
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton CommandArgument='<%# Eval("fecha") %>' CommandName='<%# Eval("idtipo") %>' ID="IIr" runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" onclick="IIr_Click"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="tipo" HeaderText="Tipo" />
                                <asp:BoundField DataField="medicamentos" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Right" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SFormulaciones" runat="server" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT formulacion.fecha,formulacion.tipo AS idtipo,varios.nombre AS tipo, COUNT(*) AS medicamentos
                                        FROM formulacion
                                        LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id)
                                        LEFT JOIN varios ON (varios.id=formulacion.tipo)
                                        WHERE formulacion.paciente=@paciente
                                        GROUP BY formulacion.fecha,tipo
                                        ORDER BY fecha DESC;">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </asp:Panel>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo"><asp:Label runat="server" ID="LFormulacion" Text="Formulación"></asp:Label></td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:GridView ID="GFormulacion" runat="server" DataSourceID="SFormulacion" 
                    AutoGenerateColumns="False" DataKeyNames="id,codigo"
                                        onselectedindexchanged="GFormulacion_SelectedIndexChanged" >
                                        <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField DataField="medicamen_id" HeaderText="idMedicamento" ItemStyle-CssClass="hide" HeaderStyle-CssClass="hide" />
                            <asp:BoundField DataField="medicamento" HeaderText="Nombre del medicamento" />
                            <asp:BoundField DataField="formulada" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="posologia" HeaderText="Posología" />
                            <asp:BoundField DataField="tiempo" HeaderText="Tiempo" />
                            <asp:BoundField DataField="via" HeaderText="Vía" />
                        </Columns>
                        <SelectedRowStyle CssClass="selecteditem" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="SFormulacion" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT medicamento_formulacion.id,medicamento_formulacion.medicamento AS medicamen_id,medicamento_formulacion.formulada,medicamento_formulacion.posologia 
                                            ,IF(medicamentos.principio IS NULL,medicamentos.nombre,CONCAT(medicamentos.nombre,' [',medicamentos.principio,'], ',medicamentos.concentracion,'-',IFNULL(medicamentos.forma,''))) AS medicamento
                                            ,medicamento_formulacion.via,medicamento_formulacion.tiempo,medicamento_formulacion.costo
                                            ,medicamentos.codigo AS codigo
                                            FROM medicamento_formulacion 
                                            LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento)
                                            WHERE formulacion=@formulacion
                                            ORDER BY (codigo>900000 AND codigo<921100)"
                            DeleteCommand="DELETE FROM medicamento_formulacion WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdFormulacion" DefaultValue="0" PropertyName="Value" Name="formulacion" />
                            </SelectParameters>
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                                <td colspan="3"><asp:Label runat="server" ID="LMensajeMedicamento" ForeColor="Red"></asp:Label></td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="LMedicamento" runat="server" Text="Medicamento"></asp:Label>
                    <asp:RequiredFieldValidator ID="RMedicamento" runat="server" 
                        ControlToValidate="TMedicamentoID" Display="Dynamic" 
                        ErrorMessage="Por favor ingrese un medicamento." SetFocusOnError="true" 
                        ValidationGroup="medicamento">*</asp:RequiredFieldValidator>
                </td>
                <td colspan="3">
                    <asp:TextBox ID="TMedicamento" runat="server" Width="99%"></asp:TextBox>
                    <asp:TextBox ID="TMedicamentoID" runat="server" CssClass="hide"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>Cantidad<asp:RequiredFieldValidator ValidationGroup="medicamento" ControlToValidate="TCantidad" ErrorMessage="Por favor ingrese una cantidad." ID="RCantidad" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                                    <td><asp:TextBox runat="server" ID="TCantidad" Width="50px" CssClass="entero"></asp:TextBox>
                                </td>
                                <td><asp:Label runat="server" ID="LPosologia" Text="Posología"></asp:Label></td>
                                <td><asp:TextBox runat="server" ID="TPosologia" Width="400px"></asp:TextBox>
                                </td>
            </tr>
            <tr runat="server" id="trPosologia">
                <td>
                    Tiempo</td>
                <td>
                    <asp:TextBox runat="server" ID="TTiempo"></asp:TextBox></td>
                <td>
                    Vía de administración</td>
                <td>
                    <asp:TextBox runat="server" ID="TVia"></asp:TextBox></td>
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
        </ContentTemplate>
    </asp:UpdatePanel>
    </div>
</asp:Content>