<%@ Page Title="Bitácora Diaria" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="turBitacora.aspx.vb" Inherits="ML.turBitacora" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<%@ Register src="../Controles/ModalText.ascx" tagname="ModalText" tagprefix="uc2" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc3" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <br />
    <asp:LinkButton ID="lnkRegBitacora" runat="server">Registrar Bitácora</asp:LinkButton>
    <ml:GridView ID="grvBit" runat="server" AllowPaging="True" 
        EmptyDataText="No se encuentran registros" AutoGenerateColumns="False" 
        DataKeyNames="bitId" PageSize="20">
        <Columns>
            <asp:BoundField DataField="bitFecha" DataFormatString="{0:dd/MM/yyyy}" 
                HeaderText="Fecha (d/m/a)" />
            <asp:BoundField DataField="segUsuarioRegistro" 
                HeaderText="Usuario" />
            <asp:BoundField DataField="tpaDescripcion" 
                HeaderText="Tipo Actividad" />                
            <asp:TemplateField HeaderText="Observaciones">
                <ItemTemplate>
                <asp:UpdatePanel runat="server"><ContentTemplate>
                    <asp:LinkButton ID="lnkObs" runat="server" CommandArgument='<%#bind("bitId")%>' Text='<%#eval("bitObservaciones")+"..."%>' onclick="lnkObs_Click" ToolTip="Haga click para ver Observación completa"></asp:LinkButton>
                    </ContentTemplate></asp:UpdatePanel>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField DeleteText="Elim" ShowDeleteButton="True" />
        </Columns>
    </ml:GridView>
       <asp:Panel ID="pnlNuevo" runat="server" Visible="false">
    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="400px">
    <asp:Panel ID="pnlTitulo" runat="server" Style=" height:10%;cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;">
                <div>
                    <p>Nuevo Registro de Archivo</p>
                </div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" >
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
    <table class="style1">
    <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Fecha"></asp:Label>
            </td>
            <td style="margin-left: 40px">
                <uc3:Fecha ID="fchBitacora" runat="server" Requerido="True" 
                    ValidationGroup="GuardarBit" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="Tipo de Actividad"></asp:Label>
            </td>
            <td style="text-align: left; margin-left: 40px">
                <uc4:DropDownListU ID="ddlTipoAct" runat="server" Requerido="True" 
                    ValidationGroup="GuardarBit"/>
            </td>
        </tr>
    <tr>
            <td colspan="2">
                <asp:Label ID="Label2" runat="server" Text="Observaciones del día"></asp:Label>
            </td>
        </tr>
    <tr>
            <td colspan="2">
                <ml:TextBox ID="txtObs" runat="server" Height="256px" MaxLength="2000" 
                    Requerido="True" TextMode="MultiLine" ValidationGroup="GuardarBit" 
                    Width="337px"></ml:TextBox>
            </td>
        </tr>
  </table>
          </ContentTemplate>
</asp:UpdatePanel>
    </asp:Panel> 
    <asp:LinkButton ID="lnkGuardar" runat="server" ValidationGroup="GuardarBit">Aceptar</asp:LinkButton>
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
</asp:Content>
