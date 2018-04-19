<%@ Page Title="Paraclínicos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="paraclinicos.aspx.cs" Inherits="paciente_paraclinicos" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<%= SDG.Componentes.HtmlUtil.RenderScript("~/js/tinymce.min.js") %>
<script type="text/javascript">
    addFunctionToStart(function() {
        $("#<%= PParaclinicos.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });
        FullRowSelect("#<%= GParaclinicos.ClientID %>");
        $("#<%= TPlanManejo.ClientID %>")._tinyMCE({ idMirrorTextArea: "elm1", readonly: <%= TPlanManejo.ReadOnly ? "true" : "false" %>});
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
<asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
    <ContentTemplate>
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table width="100%">
            <tr>
                <td colspan="4">
                <asp:Panel ID="PParaclinicos" runat="server">
                    <h3><a href="#"><asp:Label runat="server" ID="LParaclinicos"></asp:Label></a></h3>
                    <div class="hidet">
                        <asp:GridView ID="GParaclinicos" runat="server" AutoGenerateColumns="False"
                            DataSourceID="SParaclinicos" Width="100%"
                            EmptyDataText="No se encontraron Paraclinicos de este paciente" 
                            onrowdatabound="GParaclinicos_RowDataBound">
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:LinkButton CommandArgument='<%# Eval("id") %>' ID="IIr" onclick="IIr_Click" runat="server" CssClass="btn btn-success btn-xs" CausesValidation="False" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="medico" HeaderText="Médico" ItemStyle-Width="100%" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SParaclinicos" runat="server" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT paraclinico.id,paraclinico.fecha,paraclinico.medico
                                        FROM paraclinico
                                        WHERE paraclinico.paciente=@paciente
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
        	    <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
        	    <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
        	    <td>
                    Médico que atiende</td>
                <td>
                    <asp:DropDownList ID="DMedico" runat="server" DataSourceID="SMedicos" 
                        DataTextField="perNombre" DataValueField="perId"></asp:DropDownList>
                    <asp:SqlDataSource ID="SMedicos" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT perId,perNombre FROM recurso_humano WHERE eEstId=1 and carId=6 ORDER BY perNombre">
                    </asp:SqlDataSource></td>
        	</tr>
            <tr>
                <td>Análisis clínico<asp:RequiredFieldValidator ControlToValidate="TAnalisis" ErrorMessage="Por favor ingrese un análisis." ID="RequiredFieldValidator12" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td colspan="3"><asp:TextBox ID="TAnalisis" runat="server" Height="120px" TextMode="MultiLine" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Plan de manejo</td>
                <td colspan="3"><asp:TextBox ID="TPlanManejo" ReadOnly="true" runat="server" Height="200px" TextMode="MultiLine" Width="99%" CssClass="hidet"></asp:TextBox>
                <textarea id="elm1" name="elm1" style="width: 99%; height: 200px;" rows="2" cols="20"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="right">
                    <asp:ValidationSummary runat="server" />
                    <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                    <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" />
                    <asp:Button Text="Eliminar" runat="server" ID="BEliminar" Visible="false" OnClientClick="confirm('¿Esta seguro de eliminar este paraclínico?')" CausesValidation="false" onclick="BEliminar_Click" /></td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>