<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ParGenTareas.aspx.vb" Inherits="ML.ParGenTareas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        DataKeyNames="tarId">
        <Columns>
            <asp:BoundField DataField="tarTitulo" HeaderText="Tarea" />
            <asp:CommandField SelectText="Asignaciones" ShowSelectButton="True" />
        </Columns>
</asp:GridView>


    <asp:Panel ID="pnlNuevo" runat="server" Visible="false">
    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="400px">
    <asp:Panel ID="pnlTitulo" runat="server" Style=" height:10%;cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;">
                <div>
                    <p>Usuarios asignados a la alrma</p>
                </div>
    </asp:Panel>    
        <asp:GridView ID="grvUsAsig" runat="server" DataKeyNames="usIdUsuario" 
            AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="usNombreUsuario" HeaderText="Tarea" />
            <asp:TemplateField HeaderText="Asignar?">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkAsign" Checked='<%#bind("asig")%>' />
            </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        </asp:GridView>
    
    <asp:LinkButton ID="lnkGuardar" runat="server" ValidationGroup="GuardarAut">Aceptar</asp:LinkButton>
        &nbsp;
    <asp:LinkButton ID="lnkCancelar" runat="server">Cancelar</asp:LinkButton>
    <br />
</asp:Panel>
    <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>

<asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
    BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True"  
    TargetControlID="lnkAux" PopupControlID="Panel1" CancelControlID="lnkCancelar" OkControlID=""
    DropShadow="true"
    PopupDragHandleControlID="pnlTitulo">
</asp:ModalPopupExtender>
 
    </asp:Panel>
</asp:Content>
