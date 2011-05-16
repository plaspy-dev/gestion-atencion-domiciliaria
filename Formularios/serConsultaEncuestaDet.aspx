<%@ Page Title="Detalle de encuesta" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serConsultaEncuestaDet.aspx.vb" Inherits="ML.serConsultaEncuestaDet" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
   <table border="1">   
        <tr>
            <th>
                
                Nombre
                
            </th>
            <th>
                
                Fecha de Diligenciamiento</th>
            <th>
                
                Tipo Cliente</th>
            <th>
                
                Persona Encuestada</th>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblNom" runat="server" Text=""></asp:Label>
            </td>
            <td>
                <asp:Label ID="lblFec" runat="server" Text=""></asp:Label>
            </td>
            <td>
                <asp:Label ID="lblTC" runat="server" Text=""></asp:Label>
            </td>
            <td>
                <asp:Label ID="lblNomCli" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <th colspan="4" style="text-align:center;">
                Comentarios
            </th>
        </tr>
        <tr>
            <td colspan="4" style="text-align:center;">
                <asp:Label ID="lblComent" runat="server" Text=""></asp:Label>
            </td>
        </tr>
   </table>
   <div runat="server" id="dvDet"></div>
</asp:Content>
