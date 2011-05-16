<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="admLiqAct.ascx.vb" Inherits="ML.admLiqAct" %>
<style type="text/css">
    .style1
    {
        width: 100%;
    }
</style>
<hr />
   <asp:Panel ID="pnlTitulo" runat="server" Height="17px" Width="100%">
        <table class="style1"><tr><td class="style1">
                <asp:Label ID="lblTitulo" runat="server" Text="Actividades" CssClass="lblEnl"></asp:Label></td>
            <td>
                <asp:ImageButton ID="imbExp" runat="server"   CausesValidation="false" SkinID="imbBajar"/>
            </td></tr></table>
    </asp:Panel>

<asp:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" Collapsed="true"
    TargetControlID="pnlContenido" ExpandControlID="pnlTitulo" ExpandedText="(Ocultar)" CollapsedText="(Mostrar)" CollapseControlID="pnlTitulo"
    ImageControlID="imbExp">
    </asp:CollapsiblePanelExtender>
<asp:Panel ID="pnlContenido" runat="server" Height="20px" >
                        <ml:GridView ID="grvDet" runat="server" TotalPaginas="0">
            </ml:GridView>
    </asp:Panel>
