<%@ Page Title="Factura" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="factura.aspx.cs" Inherits="facturacion_factura" %>
<%@ Register Src="~/facturacion/facturactrl.ascx" TagPrefix="uc" TagName="Factura" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table class="tablecollapse">
    <tr>
        <td>Numero</td>
        <td colspan="3"><asp:TextBox runat="server" CssClass="entero" ID="TFactura"></asp:TextBox>
        <asp:Button runat="server" ID="BBuscar" OnClick="BBuscar_Click" Text="Buscar" /></td>
    </tr>
    <uc:Factura runat="server" ID="UCFactura" Visible="false" OnBCancelarClicked="BCancelar_Clicked" />
</table>
</asp:Content>