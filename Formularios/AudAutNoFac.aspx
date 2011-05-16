<%@ Page Title="Consulta de autorizaciones contra facturación" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AudAutNoFac.aspx.vb" Inherits="ML.AudAutNoFac" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<table border="1">
    <tr><th colspan="4">
        Filtrar por rango de Fechas
    </th>
    </tr>
    <td>
    Mes
    </td>
    <td>
        <uc1:DropDownListU ID="ddlMes" runat="server" />
    </td>
    <td>Año</td>
    <td>
        <ml:TextBox ID="txtAnio" runat="server" TipoTextBox="Entero" MaxLength="4"></ml:TextBox></td>
    </tr>
    <tr><td colspan="4" align="center">
        <asp:ImageButton ID="imbBuscar" runat="server" Height="16px" SkinID="imbBuscar" 
            Width="19px" />
    </td>
    </tr>
    </table>
    <br />
    <br />
    <ml:GridView ID="grvAut" runat="server">
    </ml:GridView>
</asp:Content>
