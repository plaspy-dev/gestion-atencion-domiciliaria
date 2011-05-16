<%@ Page Title="Indicadores" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AudIndicadores.aspx.vb" Inherits="ML.AudIndicadores" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
            text-align:center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<table border="1">
    <tr>
        <td colspan="2" class="celdaTitulo">
            Rango de Fechas
        </td>
    </tr>
    <tr>
        <td>
            Fecha inicial
        </td>
        <td>
            Fecha Final
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
        <td colspan="2" style="text-align: center">
            Seleccione Indicador
        </td>
    </tr>
     <tr>
        <td colspan="2" style="text-align: center">            
            <asp:DropDownList ID="ddlInd" runat="server">
            <asp:ListItem Text="Indicadores Supersalud" Value="1" Selected="True"></asp:ListItem>
            <asp:ListItem Text="Indicadores Secretaria de Salud" Value="2"></asp:ListItem>
            </asp:DropDownList>
            
        </td>
    </tr>
     <tr>
        <td colspan="2" style="text-align: center">
            Asegurador
        </td>
    </tr>
     <tr>
        <td colspan="2" style="text-align: center">
            <uc2:DropDownListU ID="ddlAseg" runat="server">
            </uc2:DropDownListU>
            
        </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align: center">
            <asp:ImageButton ID="imbBuscar" runat="server" SkinID="imbBuscar" 
                ValidationGroup="BuscarPrg" Height="16px" Width="18px" />
        </td>
    </tr>

</table>
        <ml:GridView ID="grvInd" runat="server" EmptyDataText="No hay datos para mostrar">
        <Columns>
            <asp:TemplateField>
            <ItemTemplate>
            <a href="AudIndicadoresDet.aspx?e=<%=ddlAseg.valor%>&fi=<%=fchIni.fechaString %>&ff=<%=fchFin.fechaString %>&id=<%#ddlInd.selectedIndex+1%>_<%# Container.DataItemIndex + 1 %>&nu=<%#eval("valorNumerador")%>&de=<%#eval("valorDenominador")%>">Detalles</a>
            </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        </ml:GridView>
        <br />
        <br />
        <ml:GridView ID="grvAd" runat="server"></ml:GridView>
</asp:Content>
