<%@ Control Language="C#" AutoEventWireup="true" CodeFile="autorizaciones.ascx.cs" Inherits="paciente_autorizaciones" %>
<style type="text/css">
    #tdMas {cursor: pointer;}
    #tdMas:hover { text-decoration: underline; }
    #tAutorizaciones tr { display: none; }
</style>
<asp:HiddenField ID="HId" runat="server" />
<asp:Repeater runat="server" ID="RDetalles" onitemdatabound="RDetalles_ItemDataBound">
<HeaderTemplate>
<table cellpadding="0" cellspacing="0" id="tAutorizaciones">
</HeaderTemplate>
<ItemTemplate>
        <tr>
        <td nowrap="nowrap" colspan="2">
            <b>AUTORIZACIÓN <asp:label runat="server" id="LA" Text='<%# DataBinder.Eval(Container.DataItem, "Autorizacion") %>'></asp:label> (<%# DataBinder.Eval(Container.DataItem, "fecha", "{0:d}") %>-<%# DataBinder.Eval(Container.DataItem, "vencimiento", "{0:d}")%>)</b>
        </td>
        <tr><td colspan="2"><hr /></td></tr>
        </tr>
        <asp:Repeater runat="server" ID="RDDetalle">
            <ItemTemplate>
                <tr>
                    <td align="right"><b><%# DataBinder.Eval(Container.DataItem, "Cantidad")%></b></td>
                    <td nowrap="nowrap" title="&nbsp;<%# DataBinder.Eval(Container.DataItem, "NombreCompleto") %>" onclick="expandText(this);">&nbsp;<%# DataBinder.Eval(Container.DataItem, "NombreCorto") %></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <tr><td colspan="2"><hr /></td></tr>
</ItemTemplate>
<FooterTemplate>
<tr>
    <td colspan="2" id="tdMas" class="celdaTitulo" onclick="showAut();">Más</td>
</tr>
</table>
</FooterTemplate>
</asp:Repeater>