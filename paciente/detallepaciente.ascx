<%@ Control Language="C#" AutoEventWireup="true" CodeFile="detallepaciente.ascx.cs" Inherits="phd_detallepaciente" %>
<%@ Register src="~/paciente/autorizaciones.ascx" tagname="autorizaciones" tagprefix="uc1" %>
<table style="width: 100%;" border="1">
    <asp:HiddenField ID="HIdPaciente" runat="server" />
        <tr>
            <td colspan="4" style="text-align: center" class="celdaTitulo">Información personal
            </td>
            <td style="text-align: center" class="celdaTitulo">
                Servicios
            </td>
        </tr>
       <tr>
            <td>
                Fecha Nacimiento
            </td>
            <td colspan="2">
                    <asp:Label ID="LFechaNacimiento" Font-Bold="true" runat="server" Text=""></asp:Label> - <asp:Label Font-Bold="true" ID="LEdad" runat="server" Text=""></asp:Label>
            </td>
            <td>
                Sexo
                <asp:Label ID="LSexo" Font-Bold="true" runat="server" Text=""></asp:Label>
            </td>
            <td rowspan="8" valign="top">
                <uc1:autorizaciones ID="UCAutorizaciones" runat="server" />
            </td>
       </tr>
        <tr>
            <td>
                Asegurador
            </td>
            <td>
                <asp:HiddenField ID="HIdAsegurador" runat="server" />
                <asp:Label ID="LAsegurador" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            <td>
                Carné
            </td>
            <td>
                <asp:Label ID="LCarnet" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Dirección
            </td>
            <td>
                <asp:Label ID="LDireccion" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            <td>
                Barrio
            </td>
            <td style="margin-left: 40px">
                <asp:Label ID="LBarrio" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Teléfono
            </td>
            <td>
                <asp:Label ID="LTelefono" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            <td>
                Celular
            </td>
            <td>
                <asp:Label ID="LMovil" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Pago Dir
            </td>
            <td>
                <asp:Label ID="LTipoPago" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            <td>
                Estancia
            </td>
            <td>
                <asp:Label ID="LEstancia" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Familiar</td>
            <td>
                <asp:Label ID="LFamiliar" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            <td>
                Parentesco
            </td>
            <td>
                <asp:Label ID="LParentesco" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Label ID="LCIE10" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        </table>