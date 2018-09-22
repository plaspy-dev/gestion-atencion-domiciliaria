<%@ Page Title="Orden médica" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="formulacion.aspx.cs" Inherits="paciente_formulacion" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<%@ Register src="~/ctrl/sharehistory.ascx" tagname="ShareHistory" tagprefix="uc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {

        $("#<%= TMedicamento.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetMedicamentos",
            data: function () {
                return { t: $("#<%= DTipo.ClientID %>").val() };
            },
            idField: "<%= TMedicamentoID.ClientID %>"
        });

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
<uc:ShareHistory runat="server" ID="SH" />
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
        <ContentTemplate>
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table>
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                            <asp:Button ID="BFecha" CssClass="hidet" runat="server" Text="..." onclick="BFecha_Click" /></td>
                <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese una fecha." SetFocusOnError="true" ControlToValidate="TFecha" Display="Dynamic">*</asp:RequiredFieldValidator><asp:RangeValidator ID="RangeValidator1" runat="server" MinimumValue="12/12/1900" MaximumValue="12/12/2100" SetFocusOnError="true" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                <td align="right">
                    <asp:HyperLink runat="server" ID="HAutorizacion" Target="_blank"></asp:HyperLink>
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
                                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=19 AND (szReservado IS NULL OR szReservado!='-1') ORDER BY nombre">
                    </asp:SqlDataSource></td>
                <td>
                    &nbsp;</td>
                <td align="right">
                    <asp:Button ID="BFormula" runat="server" CausesValidation="False" onclick="BFormula_Click" Text="Última" /></td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:Panel ID="PFormulaciones" runat="server">
                    <h3><a href="#"><asp:Label runat="server" ID="LFormulaciones"></asp:Label></a></h3>
                    <div class="hidet">
                        <asp:GridView ID="GFormulaciones" runat="server" AutoGenerateColumns="False"  Width="100%"
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
                                        <asp:LinkButton CommandArgument='<%# Eval("fecha") %>' CommandName='<%# Eval("idtipo") %>' ID="IIr" onclick="IIr_Click" runat="server" CssClass="btn btn-success btn-xs" CausesValidation="False" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="tipo" HeaderText="Tipo" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="medicamentos" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="100%" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SFormulaciones" runat="server" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT formulacion.fecha,formulacion.tipo AS idtipo,varios.nombre AS tipo, COUNT(medicamento_formulacion.id) AS medicamentos
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
                    <asp:GridView ID="GFormulacion" runat="server" AutoGenerateColumns="False" DataKeyNames="IdGrid" onselectedindexchanged="GFormulacion_SelectedIndexChanged" onrowdeleting="GFormulacion_RowDeleting" Width="100%" >
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
                            <asp:BoundField DataField="Nombre" HeaderText="Nombre del medicamento" ItemStyle-Width="100%" />
                            <asp:BoundField DataField="Formulada" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="Posologia" HeaderText="Posología" />
                            <asp:BoundField DataField="Tiempo" HeaderText="Tiempo" />
                            <asp:BoundField DataField="Via" HeaderText="Vía" />
                        </Columns>
                        <SelectedRowStyle CssClass="selecteditem" />
                    </asp:GridView>
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
                    <asp:TextBox ID="TMedicamentoID" runat="server" CssClass="hidet"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>Cantidad<asp:RequiredFieldValidator ValidationGroup="medicamento" ControlToValidate="TCantidad" ErrorMessage="Por favor ingrese una cantidad." ID="RCantidad" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ValidationGroup="medicamento" ControlToValidate="TCantidad" ErrorMessage="Por favor ingrese un valor valido" ID="RR" runat="server" Display="Dynamic" SetFocusOnError="true" Type="Integer" MinimumValue="1" MaximumValue="999999">*</asp:RangeValidator>
                </td>
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
                                <asp:HiddenField runat="server" ID="HFormulacion" EnableViewState="false" />
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