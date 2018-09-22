<%@ Page Title="Importación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="importacion.aspx.cs" Inherits="facturacion_importacion" %>
<%@ Register Src="~/facturacion/facturactrl.ascx" TagPrefix="uc" TagName="Factura" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table class="tablecollapse">
    <tr>
        <td colspan="4">
            <asp:FileUpload runat="server" ID="FArchivo" />
            <asp:Button runat="server" ID="BSubir" Text="Subir" ValidationGroup="archivo" OnClick="BSubir_Click" />
            <asp:RequiredFieldValidator ControlToValidate="FArchivo" ValidationGroup="archivo" ErrorMessage="Por favor seleccione un archivo." ID="R1" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
            <asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
        </td>
    </tr>
    <tr>
        <td colspan="4">&nbsp;</td>
    </tr>
    <asp:PlaceHolder runat="server" ID="PDatos" Visible="false">
    <uc:Factura runat="server" ID="UCFactura" OnBCancelarClicked="BCancelar_Clicked" />
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="celdaTitulo" colspan="4">Facturas</td>
    </tr>
    <tr>
        <td colspan="4">
        <asp:GridView ID="GFacturas" runat="server" AutoGenerateColumns="False" 
            EmptyDataText="No se encontraron datos" Width="100%" DataKeyNames="_Documento"
            OnSelectedIndexChanged="GFacturas_SelectedIndexChanged">
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Columns>
                <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="S" CssClass="btn btn-success btn-xs" CausesValidation="False" CommandName="Select" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
                <asp:BoundField DataField="_Documento" HeaderText="Factura" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="_Fecha" HeaderText="Fecha" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="_NIT" HeaderText="NIT" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="_DescripcionDelMovimiento" HeaderText="Descripción producto" ItemStyle-Width="100%" />
                <asp:BoundField DataField="_ValorMovimiento" HeaderText="Valor" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
            </Columns>
        </asp:GridView>
    </td>
    </tr>
    </asp:PlaceHolder>
</table>
</asp:Content>

