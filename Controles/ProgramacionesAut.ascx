<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ProgramacionesAut.ascx.vb" Inherits="ML.ProgramacionesAut" %>
<%@ Register src="DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="300px">
    <asp:Panel ID="pnlTitulo" runat="server" 
        Style="text-align:center;cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;" Height="16px">
                <div style="text-align:center">
                    Selección de Programaciones del Paciente</div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" Style="height:300px;overflow:auto;">
        <br />
        <asp:DropDownList ID="ddlTipAct" runat="server" AutoPostBack="True">
        </asp:DropDownList>
    <asp:GridView ID="grvPrg" runat="server"  DataKeyNames="prgTipo,prgId"
    AutoGenerateColumns="False" EmptyDataText="El paciente no tiene programaciones sin autorización">
    <Columns>
            <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
            <asp:BoundField DataField="perNombre" HeaderText="Profesional" />            
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
