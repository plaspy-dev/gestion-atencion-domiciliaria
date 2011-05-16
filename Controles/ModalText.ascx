<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ModalText.ascx.vb" Inherits="ML.ModalText" %>
<asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="700px">
    <asp:Panel ID="pnlTitulo" runat="server" Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small; height:10%">
                  <div runat="server" id="dvTitulo" ></div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" Style="height:300px;overflow:auto; text-align:left ">
                  <div runat="server" id="dvTexto" ></div> 
                  <asp:TextBox runat="server" id="txtT" Height="256px" Width="337px" Visible="false"></asp:TextBox>   
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
