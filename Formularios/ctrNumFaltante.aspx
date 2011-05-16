<%@ Page Title="Números de Factura Faltantes" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ctrNumFaltante.aspx.vb" Inherits="ML.ctrNumFaltante" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <br />
    <table class="style1">
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Número Inicial"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtNumIni" runat="server" TipoTextBox="Entero" Requerido="true"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Numero Final"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtNumFin" runat="server" TipoTextBox="Entero" Requerido="true" 
                    CausesValidation="True"></ml:TextBox>
                <asp:ImageButton ID="imbBuscar" runat="server" SkinID="imbBuscar" Height="17px" 
                    Width="28px" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
            <ml:GridView ID="grvNums" runat="server" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="facNumero" HeaderText="Numero Fac" />
                </Columns>
            </ml:GridView>
            </td>
        </tr>
    </table>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    </asp:UpdatePanel>
</asp:Content>
