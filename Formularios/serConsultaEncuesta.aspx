<%@ Page Title="Consulta Encuestas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serConsultaEncuesta.aspx.vb" Inherits="ML.serConsultaEncuesta" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table border="1">
        <tr>
            <th>Seleccione Encuesta</th>
            <th>Fecha Inicial</th>
            <th>Fecha Final</th>
        </tr>
        <tr>
            <td>
                <uc1:DropDownListU ID="ddlEnc" runat="server" />
            </td>
            <td>
                <uc2:Fecha ID="fchIni" runat="server" />
            </td>
            <td>
                <uc2:Fecha ID="fchFin" runat="server" />
            </td>
        </tr>
        <tr><td colspan="3" align="center">
            <asp:ImageButton runat="server" ID="imbBuscar" SkinID="imbBuscar" Width="20px" Height="20px" />
        </td></tr>
    </table>
   
    <asp:GridView ID="grvEncuestas" runat="server" DataKeyNames="encId" AutoGenerateColumns="false">
    <Columns>
        <asp:BoundField DataField="encNombre" HeaderText="Encuesta" />
        <asp:BoundField DataField="denFecha" HeaderText="Fecha" />
        <asp:BoundField DataField="tipoEnc" HeaderText="Tipo cliente" />
        <asp:BoundField DataField="per" HeaderText="Persona Encuestada" />
        <asp:BoundField DataField="segUsuario" HeaderText="Usuario Diligencia" />
        <asp:CommandField HeaderText="sel" ShowSelectButton="true" SelectText="Sel" />
    </Columns>
    
    </asp:GridView>
</asp:Content>
