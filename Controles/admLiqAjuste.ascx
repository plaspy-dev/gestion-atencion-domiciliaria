<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="admLiqAjuste.ascx.vb" Inherits="ML.admLiqAjuste" %>
<style type="text/css">
    .style1
    {
        width: 100%;
    }
</style>
<hr />
<asp:Panel ID="pnlTitulo" runat="server" Height="17px" Width="100%">
    <table class="style1">
        <tr><td class="style1">
                <asp:Label ID="lblTitulo" runat="server" Text="Ajustes" CssClass="lblEnl"></asp:Label>
            </td>
            <td>
                <asp:ImageButton ID="imbExp" runat="server"   CausesValidation="false" SkinID="imbBajar"/>
            </td>
        </tr>
    </table>
</asp:Panel>
<asp:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" Collapsed="true"
    TargetControlID="pnlContenido" ExpandControlID="pnlTitulo" ExpandedText="(Ocultar)" CollapsedText="(Mostrar)" CollapseControlID="pnlTitulo"
    ImageControlID="imbExp">
</asp:CollapsiblePanelExtender>
<asp:Panel ID="pnlContenido" runat="server" Height="20px" >
    <div class="style1" style="text-align:right">
        <asp:LinkButton ID="lnkNuevo" runat="server">Nuevo Ajuste</asp:LinkButton>
    </div>
    <ml:GridView ID="grvDet" runat="server" TotalPaginas="0" EmptyDataText="No se han registrado Ajustes a esta persona">
        <Columns>
            <asp:CommandField  DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="true"/>
        </Columns>
    </ml:GridView>
</asp:Panel>
<asp:Panel ID="pnlNuevo" runat="server">
    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="365px">
        <asp:Panel ID="pnlTitulo1" runat="server" Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;">
            <div>
                <p class="">Nueva Glosa</p>
            </div>
        </asp:Panel>
        <asp:Panel ID="Panel2" runat="server" Style="height:300px;overflow:auto;">
            <table>
               <tr>
                   <td>
                       <asp:Label ID="Label6" runat="server" Text="Concepto"></asp:Label>
                   </td>
                   <td>
                       <ml:TextBox ID="txtConcepto" runat="server" MaxLength="50" Requerido="True" 
                           ValidationGroup="GuardarAut" Width="200px"></ml:TextBox>
                   </td>
               </tr>
               <tr>
                   <td>
                       <asp:Label ID="Label7" runat="server" Text="Valor"></asp:Label>
                   </td>
                   <td>
                       <ml:TextBox ID="txtValor" runat="server" Requerido="True" TipoTextBox="Float" MaxLength="15"
                           ValidationGroup="GuardarAut"></ml:TextBox>
                   </td>
               </tr>
            </table>
        </asp:Panel> 
        <asp:LinkButton ID="lnkAceptar" runat="server" ValidationGroup="GuardarAut">Aceptar</asp:LinkButton>
        &nbsp;
        <asp:LinkButton ID="lnkCancelar" runat="server">Cancelar</asp:LinkButton>
    </asp:Panel>
    <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>
    <asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
        BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True" 
        TargetControlID="lnkAux" PopupControlID="Panel1" CancelControlID="" OkControlID=""
        DropShadow="true"
        PopupDragHandleControlID="pnlTitulo1">
    </asp:ModalPopupExtender>
</asp:Panel>