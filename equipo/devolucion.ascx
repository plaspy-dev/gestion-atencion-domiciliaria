<%@ Control Language="C#" AutoEventWireup="true" CodeFile="devolucion.ascx.cs" Inherits="equipo_devolucion" %>
<asp:Panel runat="server" ID="PDevolucion" Visible="false">
    <div id="dDevolucion" class="hide" align="left" title="Devolución">
        <table>
            <tr>
                <td>Fecha<asp:RequiredFieldValidator ValidationGroup="devolucion" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFecha" ValidationGroup="devolucion" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2"><asp:ValidationSummary runat="server" ValidationGroup="devolucion" /></td>
            </tr>
            <tr>
                <td colspan="2" align="right"><asp:Button runat="server" ID="BAceptar" Text="Aceptar" ValidationGroup="devolucion" onclick="BAceptar_Click" />
                    <asp:Button runat="server" ID="BCancelar" CausesValidation="false" Text="Cancelar" onclick="BCancelar_Click" /></td>
            </tr>
        </table>
    </div>
</asp:Panel>