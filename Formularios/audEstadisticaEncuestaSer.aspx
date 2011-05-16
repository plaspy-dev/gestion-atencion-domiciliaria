<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="audEstadisticaEncuestaSer.aspx.vb" Inherits="ML.audEstadisticaEncuestaSer" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
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
            <uc1:fecha ID="fchIni" runat="server" ValidationGroup="BuscarPrg" 
                Requerido="true"/>
        </td>
        <td>
            <uc1:fecha ID="fchFin" runat="server" ValidationGroup="BuscarPrg" 
                Requerido="true"/>
        </td>
    </tr>
    <tr>
    <td >
            <asp:Label ID="Label4" runat="server" Text="Asegurador"></asp:Label>    
    </td>
    <td>
        
        <uc2:DropDownListU ID="ddlEnt" runat="server"/>
        
    </td>
    </tr>
    <tr>
    <td >
            <asp:Label ID="Label5" runat="server" Text="Tipo Actividad"></asp:Label>    
    </td>
    <td>
        
        <uc2:DropDownListU ID="ddlTpa" runat="server"/>
        
    </td>
    </tr>
     <tr>
        <td colspan="2" style="text-align: center">
            <asp:ImageButton ID="imbBuscar" runat="server" SkinID="imbBuscar" 
                ValidationGroup="BuscarPrg" Height="16px" Width="18px" />
        </td>
    </tr>
</table>
<div runat="server" id="dvEst">
   
</div>

</asp:Content>
