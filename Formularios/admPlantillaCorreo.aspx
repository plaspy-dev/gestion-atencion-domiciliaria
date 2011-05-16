<%@ Page validateRequest="false" Title="Plantillas de Correo" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="admPlantillaCorreo.aspx.vb" Inherits="ML.admPlantillaCorreo" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style type="text/css">
    .style1
    {
        width: 100%;
        text-align:left ;
    }
    .style2
    {
        width: 100%;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:Panel ID="pnlContenido" runat="server" Visible="false">    
    <table class="style2">
        <tr>
            <td style="text-align: right">
                <asp:LinkButton ID="lnkNuevo" runat="server">Nueva Plantilla</asp:LinkButton>
            </td>
        </tr>
        <tr>
            <td>
    <ml:GridView ID="grvPlantilla" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="plantId" EmptyDataText="No hay Plantillas registradas" 
                    TotalPaginas="0">
        <Columns>
        <asp:TemplateField HeaderText="Tipo">
        <ItemTemplate>
        
            <%#System.Enum.GetName(GetType(ML.Datos.Administrativo.EnumTipoCorreo), Eval("plantTipo"))%>
        </ItemTemplate>
        </asp:TemplateField>
            <asp:BoundField DataField="plantAsunto" HeaderText="Factura Nro." />
            <asp:BoundField DataField="plantTexto" HeaderText="A-Z." />
            <asp:CommandField EditText="Editar" HeaderText="Editar" ShowEditButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
        </Columns>
    </ml:GridView>
            </td>
        </tr>
    </table>
    <asp:Panel ID="pnlNuevo" runat="server" Visible="false">
    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="500px">
    <asp:Panel ID="pnlTitulo" runat="server" Style=" height:10%;cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;">
                <div>
                    <p>Plantilla de Correo</p>
                </div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" >
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
    <table class="style1">
    <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Asunto"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtAsunto" runat="server" MaxLength="50" Requerido="True" 
                    Width="300px" ValidationGroup="GuardarAut"></ml:TextBox>
            </td>
        </tr>
    <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Texto"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtTexto" runat="server" MaxLength="200" Requerido="True" 
                    Width="400px" ValidationGroup="GuardarAut" Height="300px" 
                    TextMode="MultiLine"></ml:TextBox>
            </td>
        </tr>
    <tr>
            <td>
                <asp:Label ID="Label5" runat="server" Text="Tipo"></asp:Label>
            </td>
            <td>
                <uc2:DropDownListU ID="ddlTipo" runat="server" />

            </td>
        </tr>
  </table>
          </ContentTemplate>
</asp:UpdatePanel>
    </asp:Panel> 
    <asp:LinkButton ID="lnkGuardar" runat="server" ValidationGroup="GuardarAut">Aceptar</asp:LinkButton>
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
    </asp:Panel>
</asp:Content>
