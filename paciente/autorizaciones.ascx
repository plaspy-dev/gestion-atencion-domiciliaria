<%@ Control Language="C#" AutoEventWireup="true" CodeFile="autorizaciones.ascx.cs" Inherits="paciente_autorizaciones" %>
<asp:HiddenField ID="HId" runat="server" />
<asp:Repeater runat="server" ID="RDetalles" DataSourceID="SDetalles">
<HeaderTemplate>
    <table border="1">
    <tbody>
</HeaderTemplate>
<ItemTemplate>
        <tr><th colSpan="2">AUTORIZACIÓN <asp:Label runat="server" ID="LAutorizacion" Text='<%# DataBinder.Eval(Container.DataItem, "autnumero") %>'></asp:Label></th></tr>
        <tr><td><%# DataBinder.Eval(Container.DataItem, "autFecha", "{0:d}") %></td><td><%# DataBinder.Eval(Container.DataItem, "autFechaVenc", "{0:d}")%></td></tr>
        <asp:Repeater runat="server" ID="RDDetalle" DataSourceID="SDDetalle" onitemdatabound="RDetalle_ItemDataBound">
            <ItemTemplate>
                <tr><td nowrap="false"><asp:Label ID="LD" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "actDescripcion") %>'></asp:Label></td><td align="right"><%# DataBinder.Eval(Container.DataItem, "autNumSesiones") %></td></tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SDDetalle" runat="server"
            ConnectionString="<%$ ConnectionStrings:connBD %>" 
            SelectCommand="SELECT ISNULL(phdActividad.actDescripcion, phdDetalleAutorizacion.actId) AS actDescripcion,phdDetalleAutorizacion.autNumSesiones
                FROM phdDetalleAutorizacion
                LEFT JOIN phdActividad ON (phdActividad.actId=phdDetalleAutorizacion.actId)
                WHERE 
                phdDetalleAutorizacion.autNumero=@autorizacion">
                <SelectParameters>
                    <asp:ControlParameter ControlID="LAutorizacion" PropertyName="Text" Name="autorizacion" />
                </SelectParameters>
         </asp:SqlDataSource>
</ItemTemplate>
<FooterTemplate>
    </tbody>
    </table>
</FooterTemplate>
</asp:Repeater>
<asp:SqlDataSource ID="SDetalles" runat="server" 
ConnectionString="<%$ ConnectionStrings:connBD %>" 
SelectCommand="SELECT autNumero,autFecha,autFechaVenc
                FROM phdAutorizacion
                WHERE 
                autActivo=1 AND
                GETDATE()<=ISNULL(autFechaVenc+30,autFecha+60) AND
                pacId=@paciente
                ">
                <SelectParameters>
                    <asp:ControlParameter ControlID="HId" Name="paciente" DefaultValue="0" PropertyName="Value" />
                </SelectParameters>
</asp:SqlDataSource>