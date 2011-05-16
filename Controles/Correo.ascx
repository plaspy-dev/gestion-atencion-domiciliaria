<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Correo.ascx.vb" Inherits="ML.Correo" Debug="false" %>
<%@ Register src="DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="500px">
    <asp:Panel ID="pnlTitulo" runat="server" Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small; height:30px">
                <div>
                    <p class="">Envío de Correo</p>
                </div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" Style="height:300px;overflow:auto;">
        <br />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
            <asp:Label runat="server" ID="lblt" Text="Seleccione la Plantilla de correo"></asp:Label>
                <uc1:DropDownListU ID="ddlAsunto" runat="server" AutoPostBack="True" />
                <br />
                <asp:Label runat="server" ID="Label1" Text="Vista Previa:"></asp:Label>
                <div id="divTxt" style="text-align:left; overflow:auto; border-style:solid; border-width:thin;" runat="server" Width="328px" Height="125px"></div>
            </ContentTemplate>
        </asp:UpdatePanel>
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
