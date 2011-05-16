<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Filtro.ascx.vb" Inherits="ML.Filtro" %>

<table border="1">
    <tr>
        <td>
            <asp:Panel ID="pnlEnc" runat="server" >
            <asp:Table runat="server" ID="tbl1">
                <asp:TableRow runat="server">
                    <asp:TableCell runat="server">
                    <asp:Label ID="Label1" runat="server" Text="Buscar"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell runat="server"></asp:TableCell>
                    <asp:TableCell runat="server">
                        <asp:ImageButton ID="imbBuscar" runat="server" ToolTip="Buscar" SkinID="lupa" CausesValidation="false" />
                    </asp:TableCell>
                </asp:TableRow>
                </asp:Table>
            </asp:Panel>
        </td>
    </tr>
    <tr runat="server" id="trOpciones" visible="false" ><td>
    <asp:Panel ID="pnlTitulo" runat="server" Height="17px" Width="170px">
        <asp:Label ID="Label3" runat="server" Text="Opciones de Búsqueda" SkinId="EtiquetaHand"></asp:Label>
        <asp:ImageButton ID="imbExp" runat="server"   CausesValidation="false" SkinID="imbBajar"/>
            </asp:Panel>

<asp:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" Collapsed="true"
    TargetControlID="pnlContenido" ExpandControlID="pnlTitulo" ExpandedText="(Ocultar)" CollapsedText="(Mostrar)" CollapseControlID="pnlTitulo"
    ImageControlID="imbExp"  AutoCollapse="False"
    AutoExpand="False"
 ExpandDirection="Vertical">
    </asp:CollapsiblePanelExtender>
<asp:Panel ID="pnlContenido" runat="server" Height="20px" >
            <asp:Table runat="server" ID="tbl2" Width="100%"></asp:Table>
    
</asp:Panel>
    </td></tr>
</table>
 