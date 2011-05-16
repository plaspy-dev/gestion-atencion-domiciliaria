<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="pacProgramacion.ascx.vb" Inherits="ML.pacProgramacion" Debug="false" %>
<asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="700px">
    <asp:Panel ID="pnlTitulo" runat="server" Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small; height:10%">
                <div>
                    <p class="">Programaciones al dia de hoy</p>
                </div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" Style="height:300px;overflow:auto;">
    <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        TotalPaginas="0">
        <Columns>
            <asp:BoundField DataField="prgFechaProg" DataFormatString="{0:dd/MM/yyyy}" 
                HeaderText="Fecha" />
            <asp:BoundField DataField="perNombre" HeaderText="Profesional" />
            <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
            <asp:BoundField DataField="autNumero" HeaderText="Autorización" />
        </Columns>
    </ml:GridView>
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
