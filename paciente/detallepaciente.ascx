<%@ Control Language="C#" AutoEventWireup="true" CodeFile="detallepaciente.ascx.cs" Inherits="phd_detallepaciente" %>
<%@ Register src="~/paciente/autorizaciones.ascx" tagname="autorizaciones" tagprefix="uc1" %>
<asp:HiddenField ID="HIdPaciente" runat="server" />
<table style="width: 100%; border-collapse: collapse;" cellpadding="0" cellspacing="0">
    <tr>
        <td class="celdaTitulo">Información personal</td>
        <td class="celdaTitulo" id="tServicios" runat="server">Servicios</td>
    </tr>
    <tr>
        <td class="tdl" valign="top">
            <table style="width: 100%; border-collapse: collapse;" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="tdb" nowrap="nowrap">Fecha Nacimiento</td>
                    <td nowrap="nowrap" class="tdb"><asp:Label ID="LFechaNacimiento" Font-Bold="true" runat="server" Text=""></asp:Label> - <asp:Label Font-Bold="true" ID="LEdad" runat="server" Text=""></asp:Label></td>
                    <td class="tdb">Sexo</td>
                    <td class="tdb"><asp:Label ID="LSexo" Font-Bold="true" runat="server" Text=""></asp:Label></td>
               </tr>
                <tr>
                    <td class="tdb">Asegurador</td>
                    <td nowrap="nowrap" class="tdb"><asp:Label ID="LAsegurador" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                    <td class="tdb">Carné</td>
                    <td class="tdb"><asp:Label ID="LCarnet" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                </tr>
                <tr>
                    <td class="tdb">Dirección</td>
                    <td class="tdb"><asp:Label ID="LDireccion" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                    <td class="tdb">Barrio</td>
                    <td nowrap="nowrap" class="tdb"><asp:Label ID="LBarrio" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                </tr>
                <tr>
                    <td class="tdb">Teléfono</td>
                    <td class="tdb"><asp:Label ID="LTelefono" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                    <td class="tdb">Celular</td>
                    <td nowrap="nowrap" class="tdb"><asp:Label ID="LMovil" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                </tr>
                <tr>
                    <td class="tdb">Pago Dir</td>
                    <td nowrap="nowrap" class="tdb"><asp:Label ID="LTipoPago" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                    <td class="tdb">Estancia</td>
                    <td class="tdb"><asp:Label ID="LEstancia" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                </tr>
                <tr>
                    <td class="tdb">Familiar</td>
                    <td nowrap="nowrap" class="tdb"><asp:Label ID="LFamiliar" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                    <td class="tdb">Parentesco</td>
                    <td class="tdb"><asp:Label ID="LParentesco" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                </tr>
                <tr>
                    <td class="tdb">Grupo</td>
                    <td class="tdb"><asp:Label ID="LGrupo" runat="server" Font-Bold="true" Text=""></asp:Label></td>
                    <td class="tdb"></td>
                    <td class="tdb"></td>
                </tr>
            </table>
        </td>
        <td valign="top" class="tdl tdr"><uc1:autorizaciones ID="UCAutorizaciones" runat="server" /></td>
    </tr>
    <tr>
        <td colspan="2" class="celdaTitulo">CIE10</td>
    </tr>
    <tr>
        <td colspan="2" class="tdl tdr tdb"><asp:Literal ID="LCIE10" runat="server" Text=""></asp:Literal></td>
    </tr>
</table>