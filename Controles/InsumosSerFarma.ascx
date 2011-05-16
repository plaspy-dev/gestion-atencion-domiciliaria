<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="InsumosSerFarma.ascx.vb" Inherits="ML.InsumosSerFarma" %>
<asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="300px">
    <asp:Panel ID="pnlTitulo" runat="server" 
        Style="text-align:center;cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;" Height="16px">
                <div style="text-align:center">
                    Selección de Insumos</div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" Style="height:300px;overflow:auto;">
    <asp:GridView ID="GridView1" runat="server" 
    AutoGenerateColumns="False" EmptyDataText="No se encuentran Insumos para programar">
    
        <Columns>
            <asp:BoundField DataField="insId" HeaderText="Id" />
            <asp:BoundField DataField="insDescripcion" HeaderText="Insumo" />
            <asp:TemplateField HeaderText="Sel">
                <ItemTemplate>
                    <ml:CheckBox ID="CheckBox1" runat="server"/>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
            </asp:Panel>
  <asp:LinkButton ID="lnkAceptar" runat="server">Aceptar</asp:LinkButton>
    &nbsp;<asp:LinkButton ID="lnkCancelar" runat="server">Cancelar</asp:LinkButton>
    <br />
</asp:Panel>
  
    <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>

<asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
    BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True" 
    TargetControlID="lnkAux" PopupControlID="Panel1" CancelControlID="" OkControlID=""
    DropShadow="true"
    PopupDragHandleControlID="pnlTitulo">
</asp:ModalPopupExtender>
