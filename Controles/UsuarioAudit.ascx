<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UsuarioAudit.ascx.vb" Inherits="ML.UsuarioAudit" %>
<%@ Register src="Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
    <style type="text/css">

        .style2
        {
            width: 24px;
        }
    </style>
    <table>
        <tr>
            <td colspan="8" style="text-align: center">
                <asp:Label ID="lblTit" runat="server" SkinID="EtiquetaSubT" 
                    Text="Información del Sistema"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblUsIng" runat="server" Text="Usuario Registro"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtUsuario" runat="server" MaxLength="25" 
                    OrigenDatos="segUsuarioIngreso" ReadOnly="True" Width="100px"></ml:TextBox>
            </td>
            <td class="style2">
                <asp:Label ID="lblFecIng" runat="server" Text="Fecha Registro"></asp:Label>
            </td>
            <td style="margin-left: 40px">
                <uc1:Fecha ID="fecIng" runat="server" OrigenDatos="segFechaIngreso" 
                    Enabled="False" Requerido="false" />
            </td>
            <td>
                <asp:Label ID="lblUsuMod" runat="server" Text="Usuario Modifica"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtUsuarioModifica" runat="server" MaxLength="25" 
                    OrigenDatos="segUsuarioModifica" ReadOnly="True" Width="100px"></ml:TextBox>
            </td>
            <td>
                <asp:Label ID="lblFecMod" runat="server" Text="Fecha Modifica"></asp:Label>
            </td>
            <td>
                <uc1:Fecha ID="fecModif" runat="server" OrigenDatos="segFechaModifica" 
                    Enabled="False" Requerido="false" />
            </td>
        </tr>
    </table>
