<%@ Page Title="Epicrisis apoyo terapeútico" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="epicrisis.aspx.cs" Inherits="paciente_epicrisis" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<div id="dImprimir">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
        <ContentTemplate>
        <asp:HiddenField runat="server" ID="HIdEpicrisis" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
    <table width="100%">
        <tr>
            <td>
                <table width="100%">
                    <tr>
                        <td>
                            Fecha
                        </td>
                        <td>
                        <asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                        </td>
                        <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ErrorMessage="Por favor ingrese una fecha." ControlToValidate="TFecha" 
                    Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator><asp:RangeValidator ID="RangeValidator1" runat="server" MinimumValue="12/12/1900" MaximumValue="12/12/2100" SetFocusOnError="true" Display="Dynamic" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." Type="Date"></asp:RangeValidator>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
            <fieldset>
                <legend>Resultados valoración inicial</legend>
                <asp:TextBox ID="TValoracionInicial" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                    ErrorMessage="Por favor ingrese una valoración inicial." ControlToValidate="TValoracionInicial" 
                    Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
            </fieldset>
            <fieldset>
                <legend>Resultados valoración final</legend>
                <asp:TextBox ID="TValoracionFinal" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            <fieldset>
                <legend>Plan de intervención propuesto</legend>
                <asp:TextBox ID="TIntervencionPropuesta" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                    ErrorMessage="Por favor ingrese una intervención propuesta." ControlToValidate="TIntervencionPropuesta" 
                    Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
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
            <td align="right">
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