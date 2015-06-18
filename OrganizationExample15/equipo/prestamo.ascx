<%@ Control Language="C#" AutoEventWireup="true" CodeFile="prestamo.ascx.cs" Inherits="equipo_prestamo" %>
<%@ Register Src="~/paciente/pacienteSimple.ascx" TagName="pacienteSimple" TagPrefix="uc1" %>
<%@ Register Src="~/rh/funcionarioSimple.ascx" TagName="funcionarioSimple" TagPrefix="uc1" %>
<asp:Panel runat="server" ID="PPrestamo" Visible="false">
    <div id="dPrestamo" class="hide" align="left" title="Prestamo">
        <table>
            <tr>
                <td>Fecha<asp:RequiredFieldValidator ValidationGroup="prestamo" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFecha" ValidationGroup="prestamo" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Devolución<asp:RangeValidator ControlToValidate="TEstimado" ValidationGroup="prestamo" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                <td><asp:TextBox runat="server" ID="TEstimado" CssClass="fecha"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Paciente<asp:RequiredFieldValidator ID="RPaciente" ValidationGroup="prestamo" ControlToValidate="UCPaciente$TPacienteID" runat="server" ErrorMessage="Por favor ingrese un paciente" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><uc1:pacienteSimple runat="server" ID="UCPaciente" /></td>
            </tr>
            <tr>
                <td>Funcionario<asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="prestamo" ControlToValidate="UCFuncionario$TFuncionarioID" runat="server" ErrorMessage="Por favor ingrese un funcionario" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><uc1:funcionarioSimple runat="server" ID="UCFuncionario" /></td>
            </tr>
            <tr>
                <td>Familiar</td>
                <td><asp:TextBox runat="server" Width="200px" ID="TFamiliar"></asp:TextBox></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:CheckBox runat="server" ID="CPagare" Text="Pagare" /></td>
            </tr>
            <tr>
                <td>Observaciones</td>
                <td><asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="200px"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2"><asp:ValidationSummary runat="server" ValidationGroup="prestamo" /></td>
            </tr>
            <tr>
                <td colspan="2" align="right"><asp:Button runat="server" ID="BAceptar" Text="Aceptar" ValidationGroup="prestamo" onclick="BAceptar_Click" />
                    <asp:Button runat="server" ID="BCancelar" CausesValidation="false" Text="Cancelar" onclick="BCancelar_Click" /></td>
            </tr>
        </table>
    </div>
</asp:Panel>