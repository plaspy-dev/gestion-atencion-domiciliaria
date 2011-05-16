<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Lista.ascx.vb" Inherits="ML.Lista" %>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <div >
            
                    <ml:TextBox ID="txtCod" runat="server" AutoPostBack="true" Width="68px"></ml:TextBox>
                    <ml:TextBox ID="txtDes" runat="server" AutoPostBack="true" Width="331px"></ml:TextBox>                 
                     <asp:ImageButton ID="imbBuscar" runat="server" style="width: 14px" SkinID="imbBuscar" ToolTip="Buscar" />
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                         ControlToValidate="txtCod" ErrorMessage="Requerido" Display="Dynamic" Visible="False"></asp:RequiredFieldValidator>            
        </div>
        <asp:Panel ID="pnlBuscar" runat="server" Visible="false">
        <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="400px">
            <asp:Panel ID="pnlTitulo" runat="server" 
                Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;" 
                Height="16px">
                        <div style="text-align:center">
                            Búsqueda</div>
                    </asp:Panel>
            <asp:Panel ID="Panel2" runat="server" Style="height:300px;overflow:auto; text-align:center">
                <table cellpadding="0" cellspacing="0" >
                    <tr>
                        <td>
                            <asp:Label ID="Label1" runat="server" Text="Digite la descripción a buscar"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtBuscarDesc" runat="server" MaxLength="25" Width="250px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center">
                            <asp:LinkButton ID="lnkBuscar" runat="server">Buscar</asp:LinkButton>
                        </td>
                    </tr>
                </table>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                    EmptyDataText="La búsqueda no arrojó Resultados" AllowPaging="True" 
                    PageSize="100">
                    <Columns>
                        <asp:CommandField HeaderText="Sel" SelectText="Sel" 
                            ShowSelectButton="True" />
                        <asp:BoundField DataField="codigo" HeaderText="Código" />
                        <asp:BoundField DataField="descripcion" HeaderText="Descripción" />
                    </Columns>
                </asp:GridView>
                    </asp:Panel>
            <asp:LinkButton ID="lnkCancelar" runat="server">Cancelar</asp:LinkButton>
            <br />
        </asp:Panel>
        <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>

        <asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
            BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True" 
            TargetControlID="lnkAux" PopupControlID="Panel1" CancelControlID="" OkControlID=""
            DropShadow="true"
            PopupDragHandleControlID="pnlTitulo">
        </asp:ModalPopupExtender>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:LinkButton runat="server" id="lnkPostBack" visible="false" ></asp:LinkButton>
