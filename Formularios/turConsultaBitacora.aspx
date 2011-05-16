<%@ Page Title="Bitácora Diaria" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="turConsultaBitacora.aspx.vb" Inherits="ML.turConsultaBitacora" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<%@ Register src="../Controles/ModalText.ascx" tagname="ModalText" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.ServiciosMedicos.turBitacora" Campos="segUsuarioRegistro,bitFecha" Titulos="Buscar por Usuario,Fecha de Bitácora" Referencias="UsuariosC," />
   
    <br />
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
        </Columns>
    </ml:GridView>
</asp:Content>
