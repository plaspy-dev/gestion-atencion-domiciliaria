<%@ Page Title="Epicrisis apoyo terapeútico" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="epicrisis.aspx.cs" Inherits="paciente_epicrisis" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#<%= PHistorial.ClientID %>").accordion({
                autoHeight: false,
                collapsible: true,
                active: false
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<div id="dImprimir">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
        <ContentTemplate>
        <asp:HiddenField runat="server" ID="HIdEpicrisis" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
    <asp:Panel ID="PHistorial" runat="server" Visible="false">
        <h3><a href="#"><asp:Label runat="server" ID="LHistorial"></asp:Label></a></h3>
        <div class="hidet">
            <asp:UpdatePanel runat="server" ID="U" UpdateMode="Conditional">
                <ContentTemplate>
            <asp:GridView ID="GHistorial" runat="server" AutoGenerateColumns="False" Width="100%" 
                DataSourceID="SHistorial" AllowPaging="true" PageSize="10"
                EmptyDataText="No se encontraron epicrisis de este paciente">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:HyperLink runat="server" ID="L" NavigateUrl='<%# string.Format("~/paciente/epicrisis.aspx?pid={0}&epid={1}", Eval("paciente"), Eval("id")) %>'>
                                <asp:Image runat="server" ID="I" ImageUrl="~/imgs/edit.gif" />
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="fecha" HeaderText="Fecha" ItemStyle-Wrap="false" DataFormatString="{0:d}"  />
                    <asp:BoundField DataField="perNombre" HeaderText="Funcionario" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="nombre" HeaderText="Tipo" ItemStyle-Wrap="false" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SHistorial" runat="server" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                SelectCommand="SELECT epicrisis.id,epicrisis.fecha
                            ,recurso_humano.perNombre, CONCAT(medicamentos.codigo, ' - ',medicamentos.nombre) AS nombre
                            ,epicrisis.paciente
                            FROM epicrisis
                            LEFT JOIN medicamentos ON (medicamentos.id=epicrisis.tipo)
                            LEFT JOIN recurso_humano ON (recurso_humano.perId=epicrisis.funcionario)
                            WHERE epicrisis.paciente=@paciente
                            ORDER BY fecha DESC;">
                <SelectParameters>
                    <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                </SelectParameters>
            </asp:SqlDataSource>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </asp:Panel><br />
    <table width="100%">
        <tr>            
            <td width="1">Fecha<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ErrorMessage="Por favor ingrese una fecha." ControlToValidate="TFecha" 
                    Display="Dynamic" SetFocusOnError="True">*</asp:RequiredFieldValidator><asp:RangeValidator ID="RangeValidator1" runat="server" MinimumValue="12/12/1900" MaximumValue="12/12/2100" SetFocusOnError="true" Display="Dynamic" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." Type="Date">*</asp:RangeValidator></td>
            <td width="1"><asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox></td>
            <td width="1">Tipo<asp:RequiredFieldValidator ControlToValidate="DTipo" ErrorMessage="Por favor seleccione un tipo." ID="RequiredFieldValidator5" 
	            runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:DropDownList ID="DTipo" runat="server" DataSourceID="STipo"
                    DataTextField="nombre" DataValueField="id" CssClass="anchomaxcombo">
                </asp:DropDownList>
                <asp:SqlDataSource ID="STipo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT programacion.actId AS id, CONCAT(medicamentos.codigo, ' - ',medicamentos.nombre) AS nombre
                        FROM programacion 
                        LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId)
                        WHERE programacion.pacId=@paciente 
                        AND programacion.prgFechaProg>SYSDATE()-INTERVAL 7 DAY 
                        AND (@canUpdate=1 OR programacion.perId=@funcionario)
                        GROUP BY programacion.actId 
                        ORDER BY nombre">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                        <asp:ControlParameter ControlID="UCFuncionario" PropertyName="IdFuncionario" Name="funcionario" DefaultValue="0" />
                        <asp:Parameter Name="canUpdate" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td style="white-space: nowrap;">Atendido por<asp:RequiredFieldValidator ControlToValidate="UCFuncionario$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="RequiredFieldValidator1" 
	            runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><uc1:funcionario runat="server" ID="UCFuncionario" /></td>
        </tr>
        <tr>
            <td colspan="4">
            <fieldset>
                <legend>Resultados valoración inicial<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                    ErrorMessage="Por favor ingrese una valoración inicial." ControlToValidate="TValoracionInicial" 
                    Display="Dynamic" SetFocusOnError="True">*</asp:RequiredFieldValidator></legend>
                <asp:TextBox ID="TValoracionInicial" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            <fieldset>
                <legend>Resultados valoración final</legend>
                <asp:TextBox ID="TValoracionFinal" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            <fieldset>
                <legend>Plan de intervención propuesto<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                    ErrorMessage="Por favor ingrese una intervención propuesta." ControlToValidate="TIntervencionPropuesta" 
                    Display="Dynamic" SetFocusOnError="True">*</asp:RequiredFieldValidator></legend>
                <asp:TextBox ID="TIntervencionPropuesta" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            <fieldset>
                <legend>Intervención realizada</legend>
                <asp:TextBox ID="TIntervencionRealizada" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            <fieldset>
                <legend>Logros obtenidos</legend>
                <asp:TextBox ID="TLogros" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            <fieldset>
                <legend>Observaciones</legend>
                <asp:TextBox ID="TObservaciones" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            </td>
        </tr>
        <tr>
            <td colspan="4"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
                        <asp:ValidationSummary runat="server" ID="V" /></td>
        </tr>
        <tr>
            <td><asp:Button Text="Eliminar" runat="server" ID="BEliminar" Visible="false" OnClientClick="confirm('¿Esta seguro de eliminar esta epicrisis?')" 
                                CausesValidation="false" onclick="BEliminar_Click" /></td>
            <td align="right" colspan="3">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" /><asp:Button ID="BCancelar"
                    runat="server" Text="Cancelar" CausesValidation="false" 
                    onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
    </ContentTemplate>
    </asp:UpdatePanel>
    </div>
</asp:Content>