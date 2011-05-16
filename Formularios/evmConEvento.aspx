<%@ Page Title="Eventos Masivos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="evmConEvento.aspx.vb" Inherits="ML.evmConEvento" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<table border="1">
    <tr><th colspan="4">
        Filtrar por rango de Fechas
    </th>
    </tr>
    <td>
    Fecha incial
    </td>
    <td>
        
        <uc1:Fecha ID="fchIni" runat="server" />
        
    </td>
        <td>
    Fecha final
    </td>
    <td>
        
        <uc1:Fecha ID="fchfin" runat="server" />
        
    </td>
    </tr>
    <tr><td colspan="4" align="center">
        <asp:ImageButton ID="imbBuscar" runat="server" Height="16px" SkinID="imbBuscar" 
            Width="19px" />
    </td>
    </tr>
    </table>
    <hr />
    <br />
    <ml:GridView ID="grvEv" runat="server" DataKeyNames="eveId" 
        EmptyDataText="No hay eventos registrados en el rango consultado" 
        AutoGenerateColumns="false" AllowPaging="true">
    <Columns>
    <asp:BoundField HeaderText="Nombre" DataField="eveDescripcion" />
    <asp:BoundField HeaderText="Fecha" DataField="eveFecha" DataFormatString="{0:dd/MM/yyyy}" />
    <asp:BoundField HeaderText="Hora Ini" DataField="eveFecha" DataFormatString="{0:HH:mm}" />
    <asp:BoundField HeaderText="Hora Fin" DataField="eveHoraFin" DataFormatString="{0:HH:mm}" />
    <asp:CommandField ShowSelectButton="true" SelectText="Sel" HeaderText="Sel" />
    </Columns>
    </ml:GridView>
</asp:Content>
