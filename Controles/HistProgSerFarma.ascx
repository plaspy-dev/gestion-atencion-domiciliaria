<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="HistProgSerFarma.ascx.vb" Inherits="ML.HistProgSerFarma" Debug="false" %>
<asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="365px">
    <asp:Panel ID="pnlTitulo" runat="server" Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small; height:10%">
                <div>
                    <p class="">Historia de Programaciones servicio Farmacéutico</p>
                </div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" Style="height:300px;overflow:auto;">
    <asp:GridView ID="GridView1" runat="server" 
    AutoGenerateColumns="False" 
            EmptyDataText="Este paciente no tiene Programaciones registradas" 
            EnableViewState="False">
    
        <Columns>
            <asp:BoundField DataField="proFecha" HeaderText="Fecha" 
                DataFormatString="{0:dd/MM/yy}" />
            <asp:BoundField DataField="insDescripcion" HeaderText="Artículo" />
            <asp:BoundField DataField="proCantidad" HeaderText="Cant" />
            <asp:BoundField DataField="proObservaciones" HeaderText="Observaciones" />
        </Columns>
    </asp:GridView>
    </asp:Panel> 
    <asp:LinkButton ID="lnkCancelar" runat="server">Aceptar</asp:LinkButton>
    <br />
</asp:Panel>
  
    <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>

<asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
    BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True" 
    TargetControlID="lnkAux" PopupControlID="Panel1" CancelControlID="lnkCancelar" OkControlID=""
    DropShadow="true"
    PopupDragHandleControlID="pnlTitulo">
</asp:ModalPopupExtender>
