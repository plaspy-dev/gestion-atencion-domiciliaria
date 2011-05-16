<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="admLiqGlosa.ascx.vb" Inherits="ML.admLiqGlosa" %>

   <%@ Register src="DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<%@ Register src="Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>

<hr />
   <asp:Panel ID="pnlTitulo" runat="server" Height="17px" Width="100%">
        <table class="style1"><tr><td class="style1">
                <asp:Label ID="lblTitulo" runat="server" Text="Glosas" CssClass="lblEnl"></asp:Label></td>
            <td>
                <asp:ImageButton ID="imbExp" runat="server"   CausesValidation="false" SkinID="imbBajar"/>
            </td></tr></table>
    </asp:Panel>

<asp:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" Collapsed="true"
    TargetControlID="pnlContenido" ExpandControlID="pnlTitulo" ExpandedText="(Ocultar)" CollapsedText="(Mostrar)" CollapseControlID="pnlTitulo"
    ImageControlID="imbExp">
    </asp:CollapsiblePanelExtender>
<asp:Panel ID="pnlContenido" runat="server" Height="20px" >
            <div class="style1" style="text-align:right">
            <asp:LinkButton ID="lnkNuevo" runat="server">Nueva Glosa</asp:LinkButton>
            </div>
            <ml:GridView ID="grvDet" runat="server" TotalPaginas="0" EmptyDataText="No se han registrado Glosas a esta persona">
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
           <tr><td>
           
               <asp:Label ID="Label4" runat="server" Text="Actividad"></asp:Label>
           
           </td>
               <td>
                   <uc1:DropDownListU ID="ddlActividad" runat="server" Requerido="True" 
                       ValidationGroup="GuardarAut" />
               </td>
           </tr>
           <tr>
               <td style="text-align: left">
                   <asp:Label ID="Label5" runat="server" Text="Fecha"></asp:Label>
               </td>
               <td>
                   <uc2:Fecha ID="fchGlosa" runat="server" Requerido="True" 
                       ValidationGroup="GuardarAut" />
               </td>
           </tr>
           <tr>
               <td>
                   <asp:Label ID="Label6" runat="server" Text="Cantidad"></asp:Label>
               </td>
               <td>
                   <ml:TextBox ID="txtCantidad" runat="server" MaxLength="2" Requerido="True" 
                       TipoTextBox="Entero" ValidationGroup="GuardarAut" Width="38px"></ml:TextBox>
               </td>
           </tr>
           <tr>
               <td>
                   <asp:Label ID="Label7" runat="server" Text="Valor Unitario"></asp:Label>
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
    <br />
</asp:Panel>
  
    <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>

<asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
    BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True" 
    TargetControlID="lnkAux" PopupControlID="Panel1" CancelControlID="" OkControlID=""
    DropShadow="true"
    PopupDragHandleControlID="pnlTitulo1">
</asp:ModalPopupExtender>
</asp:Panel>

