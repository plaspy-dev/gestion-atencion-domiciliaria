<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ListaMulti.ascx.vb" Inherits="ML.ListaMulti" %>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <div >
            <asp:LinkButton ID="lnkSel" runat="server">Seleccionar</asp:LinkButton><%=getNumSel()%>
        </div>
        <asp:Panel ID="pnlBuscar" runat="server" Visible="false">
        <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="500px">
            <asp:Panel ID="pnlTitulo" runat="server" 
                Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;" 
                Height="16px">
                <div style="text-align:center">
                    Búsqueda
                </div>
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
                <table>
                <tr>
                    <td>
                        <asp:GridView ID="grvL" runat="server" AutoGenerateColumns="False" 
                            EmptyDataText="La búsqueda no arrojó Resultados" AllowPaging="True" 
                            PageSize="100" DataKeyNames="codigo">
                            <Columns>
                                <asp:TemplateField HeaderText="Sel" >
                                <HeaderTemplate>
                                    <input type="checkbox" onclick="selTodo('<%=grvL.ClientId %>',this.checked);" value="Sel" title="sel" >
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSel" runat="server" Checked='<%#GetSelL(Eval("codigo"))%>'/>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="descripcion" HeaderText="Descripción" />
                            </Columns>
                        </asp:GridView>
                    </td>
                    <td style="text-align:left;vertical-align:top;">
                        <%=getTxtL()%>
                    </td>
                </tr></table>
                </asp:Panel>
            &nbsp;<asp:LinkButton ID="lnkAceptar" runat="server" >Aceptar</asp:LinkButton>
            &nbsp;
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
        <script type="text/javascript">
            function selTodo(id,ck) {
                var j = 0;
                for (i in a = document.getElementsByTagName("input")) {
                    if (a[i].type == "checkbox")
                        if (a[i].id.substring(0, id.length) == id)
                            a[i].checked = ck;
                }
            }
        </script>
    </ContentTemplate>
</asp:UpdatePanel>

