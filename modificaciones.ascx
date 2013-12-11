<%@ Control Language="C#" AutoEventWireup="true" CodeFile="modificaciones.ascx.cs" Inherits="modificaciones" %>
<asp:Panel runat="server" ID="PModificaciones">
<table style="border-collapse: collapse; ">
    <tr class="GridRow">
        <td class="tda" nowrap="nowrap">Creador</td>
        <td class="tda" nowrap="nowrap"><asp:Label ID="LCreadoPor" runat="server" Text=""></asp:Label></td>
    </tr>
    <tr class="GridAltRow">
        <td class="tda" nowrap="nowrap">Fecha creación</td>
        <td class="tda" nowrap="nowrap"><asp:Label ID="LFechaCreacion" runat="server" Text=""></asp:Label></td>
    </tr>
    <tr class="GridRow">
        <td class="tda" nowrap="nowrap">Último modificador</td>
        <td class="tda" nowrap="nowrap"><asp:Label ID="LModificadoPor" runat="server" Text=""></asp:Label></td>
    </tr>
    <tr class="GridAltRow">
        <td class="tda" nowrap="nowrap">Última modificación</td>
        <td class="tda" nowrap="nowrap"><asp:Label ID="LFechaModificacion" runat="server" Text=""></asp:Label></td>
    </tr>
</table>
</asp:Panel>
<table>
    <asp:PlaceHolder runat="server" ID="PMasModificaciones" Visible="false">
    <tr>
        <td width=1>Modificaciones</td>
        <td><hr /></td>
    </tr>
    <tr>
        <td colspan="2">
        <asp:GridView ID="GModificaciones" runat="server" ShowHeader="false" AutoGenerateColumns="false" EmptyDataText="No se encontraron modificaciones" EmptyDataRowStyle-Wrap="false" EmptyDataRowStyle-BorderWidth="0">
            <RowStyle CssClass="GridRow"></RowStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Columns>
                <asp:BoundField DataField="usuario" HeaderText="Usuario" ItemStyle-Font-Size="8px" />
                <asp:BoundField DataField="fecha" HeaderText="Fecha" ItemStyle-Font-Size="8px" ItemStyle-Wrap="false" />
            </Columns>
        </asp:GridView>
        </td>
    </tr>
    </asp:PlaceHolder>
    <asp:PlaceHolder runat="server" ID="PImpresion" Visible="false">
    <tr>
        <td>Impresiones</td>
        <td><hr /></td>
    </tr>
    <tr>
        <td colspan="2">
        <asp:GridView ID="GImpresiones" runat="server" ShowHeader="false" AutoGenerateColumns="false" EmptyDataText="No se encontraron modificaciones" EmptyDataRowStyle-Wrap="false" EmptyDataRowStyle-BorderWidth="0">
            <RowStyle CssClass="GridRow"></RowStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Columns>
                <asp:BoundField DataField="usuario" HeaderText="Usuario" ItemStyle-Font-Size="8px" />
                <asp:BoundField DataField="fecha" HeaderText="Fecha" ItemStyle-Font-Size="8px" ItemStyle-Wrap="false" />
            </Columns>
        </asp:GridView>
        </td>
    </tr>
    </asp:PlaceHolder>
</table>