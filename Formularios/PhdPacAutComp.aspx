<%@ Page Title="Comparativo de autorizaciones" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdPacAutComp.aspx.vb" Inherits="ML.PhdPacAutComp" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table border="1" style="width:300px;" >
        <tr>
        <td>
            Asegurador
        </td>
        <td>
            <uc1:DropDownListU ID="ddlAseg" runat="server" />        
        </td>
        </tr>
    <tr><td colspan="2"><asp:ImageButton runat="server" ID="imbBuscar" 
            SkinID="imbBuscar" Height="19px" Width="16px" /></td></tr>
    </table>
     <asp:GridView ID="grvPac" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encuentran Pacientes">
        <Columns>
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                SortExpression="pacDocumento" />
            <asp:BoundField DataField="pacNombres" HeaderText="Nombre" 
                SortExpression="pacNombres" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" 
                SortExpression="entNombre" />
            <asp:BoundField DataField="pacFecIngPrograma" HeaderText="Fec Ing Programa" 
                SortExpression="pacFecIngPrograma" />
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
