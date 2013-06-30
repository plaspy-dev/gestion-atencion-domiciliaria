<%@ Page Title="Formato CTC" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="formatoctc.aspx.cs" Inherits="paciente_formatoctc" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
addFunctionToStart(function() {
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
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
<!--<asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
<ContentTemplate>-->
    <asp:HiddenField ID="HIdFormulacion" runat="server" />
    <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
    <table>
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                            <asp:Button ID="BFecha" CssClass="hide" runat="server" Text="..." onclick="BFecha_Click" /></td>
                <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese una fecha." SetFocusOnError="true" ControlToValidate="TFecha" Display="Dynamic">*</asp:RequiredFieldValidator><asp:RangeValidator ID="RangeValidator1" runat="server" MinimumValue="12/12/1900" MaximumValue="12/12/2100" SetFocusOnError="true" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                <td align="right">
                    <asp:Button ID="BFormula" runat="server" CausesValidation="False" onclick="BFormula_Click" Text="Última" />
                </td>
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
                                        <asp:ImageButton CommandArgument='<%# Eval("fecha") %>' ID="IIr" runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" onclick="IIr_Click"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="cantidad" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Right" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SFormulaciones" runat="server" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT formato_ctc.fecha,COUNT(*) AS cantidad
                                        FROM formato_ctc
                                        LEFT JOIN formato_ctc_items ON (formato_ctc_items.formato_ctc=formato_ctc.id)
                                        WHERE formato_ctc.paciente=@paciente
                                        GROUP BY formato_ctc.fecha
                                        ORDER BY formato_ctc.fecha DESC;">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </asp:Panel>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:GridView ID="GFormulacion" runat="server" AutoGenerateColumns="False" DataKeyNames="IdGrid" onselectedindexchanged="GFormulacion_SelectedIndexChanged" onrowdeleting="GFormulacion_RowDeleting" EmptyDataText="No hay medicamentos" >
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <SelectedRowStyle CssClass="selecteditem" />
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField DataField="Nombre" HeaderText="Nombre del medicamento" />
                            <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="Tiempo" HeaderText="Tiempo de utilización" />
                            <asp:BoundField DataField="Efecto" HeaderText="Efecto deseado" />
                            <asp:BoundField DataField="Respuesta" HeaderText="Tiempo de respuesta esperado" />
                            <asp:BoundField DataField="EfectosSecundarios" HeaderText="Efectos secundarios y posibles riesgos" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td colspan="4"><asp:Label runat="server" ID="LMensajeMedicamento" ForeColor="Red"></asp:Label></td>
            </tr>
            <tr>
                <td>
                    Nombre
                    <asp:RequiredFieldValidator ControlToValidate="TNombre" ErrorMessage="Por favor ingrese un nombre." runat="server" Display="Dynamic" SetFocusOnError="true" ValidationGroup="medicamento">*</asp:RequiredFieldValidator>
                </td>
                <td colspan="3">
                    <asp:TextBox ID="TNombre" runat="server" Width="99%"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>Cantidad<asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="TCantidad" ErrorMessage="Por favor ingrese una cantidad." runat="server" Display="Dynamic" SetFocusOnError="true" ValidationGroup="medicamento">*</asp:RequiredFieldValidator></td>
                <td><asp:TextBox runat="server" ID="TCantidad" CssClass="float"></asp:TextBox></td>
                <td>Tiempo de utilización<asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="TTiempo" ErrorMessage="Por favor ingrese un tiempo." runat="server" Display="Dynamic" SetFocusOnError="true" ValidationGroup="medicamento">*</asp:RequiredFieldValidator></td>
                <td><asp:TextBox runat="server" ID="TTiempo"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Efecto deseado<asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="TEfecto" ErrorMessage="Por favor ingrese un efecto." runat="server" Display="Dynamic" SetFocusOnError="true" ValidationGroup="medicamento">*</asp:RequiredFieldValidator></td>
                <td colspan="3"><asp:TextBox runat="server" ID="TEfecto" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Tiempo de respuesta esperado<asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="TRespuesta" ErrorMessage="Por favor ingrese una respuesta." runat="server" Display="Dynamic" SetFocusOnError="true" ValidationGroup="medicamento">*</asp:RequiredFieldValidator></td>
                <td colspan="3"><asp:TextBox runat="server" ID="TRespuesta" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Efectos secundarios y posibles riesgos<asp:RequiredFieldValidator ID="RequiredFieldValidator6" ControlToValidate="TEfectosSecundarios" ErrorMessage="Por favor ingrese un efecto." runat="server" Display="Dynamic" SetFocusOnError="true" ValidationGroup="medicamento">*</asp:RequiredFieldValidator></td>
                <td colspan="3"><asp:TextBox runat="server" ID="TEfectosSecundarios" Width="99%"></asp:TextBox></td>
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
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" onclick="BAceptar_Click" /><asp:Button ID="BCancelar" CausesValidation="false" runat="server" Text="Cancelar" onclick="BCancelar_Click" />
                </td>
            </tr>
        </table>
<!--</ContentTemplate>
</asp:UpdatePanel>-->
</asp:Content>