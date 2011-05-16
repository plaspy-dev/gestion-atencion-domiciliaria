<%@ Page Title="Número de Pacientes Programados" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdConPacPrg.aspx.vb" Inherits="ML.PhdConPacPrg" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<table border="1">
    <tr>
        <td colspan="2" class="celdaTitulo">
            <asp:Label ID="Label1" runat="server" Text="Rango de Fechas" SkinID="lblsubTitulo"></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label2" runat="server" Text="Fecha inicial"></asp:Label>
        </td>
        <td>
            <asp:Label ID="Label3" runat="server" Text="Fecha Final"></asp:Label>
        </td>
    </tr>
        <tr>
        <td>
            <uc1:Fecha ID="fchIni" runat="server" ValidationGroup="BuscarPrg" Requerido="true"/>
        </td>
        <td>
            <uc1:Fecha ID="fchFin" runat="server" ValidationGroup="BuscarPrg" Requerido="true"/>
        </td>
    </tr>
     <tr>
        <td colspan="2" style="text-align: center">
            <asp:ImageButton ID="imbBuscar" runat="server" SkinID="imbBuscar" 
                ValidationGroup="BuscarPrg" Height="16px" Width="18px" />
        </td>
    </tr>
</table>
    <asp:TreeView ID="trwPrg" runat="server" SkinId="TreeViewEtiqueta">
    </asp:TreeView>

</asp:Content>
