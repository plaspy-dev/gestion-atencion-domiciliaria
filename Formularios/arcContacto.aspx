<%@ Page Title="Contactos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="arcContacto.aspx.vb" Inherits="ML.arcContacto" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.ServiciosMedicos.arcContacto" campos="conEntidad,conNombreContacto" Titulos="Entidad,Nombre Contacto" />
    <br />
    <asp:GridView ID="grvCon" runat="server" EmptyDataText="No hay Contactos" 
        AutoGenerateColumns="False" DataKeyNames="conId">
        <Columns>
            <asp:BoundField DataField="areaDesc" HeaderText="Area" 
                SortExpression="areaDesc" />
            <asp:BoundField DataField="conEntidad" HeaderText="Entidad" 
                SortExpression="conEntidad" />
            <asp:BoundField DataField="conNombreContacto" HeaderText="NombreContacto" 
                SortExpression="conNombreContacto" />
            <asp:BoundField DataField="conTelefono" HeaderText="Teléfono" 
                SortExpression="conTelefono" />
            <asp:BoundField DataField="conDireccion" HeaderText="Dirección" 
                SortExpression="conDireccion" />
             <asp:BoundField DataField="conEmail" HeaderText="E-mail" 
                SortExpression="conEmail" />
            <asp:BoundField DataField="conObs" HeaderText="Observaciones" 
                SortExpression="conObs" />
            <asp:CommandField EditText="Editar" ShowEditButton="True" />
            <asp:CommandField DeleteText="Elim" ShowDeleteButton="True" />
        </Columns>
</asp:GridView>
<asp:Panel ID="pnlNuevo" runat="server" Visible="false">
<asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="500px">
    <asp:Panel ID="pnlTitulo" runat="server" Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small; height:10%">
                <div>
                    <p >Contacto</p>
                </div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" Style="height:200px;overflow:auto;">
        <table>
        <tr>
        <td style="margin-left: 80px">
            <asp:Label ID="Label7" runat="server" Text="Area"></asp:Label>
        </td>
            <td style="text-align: left">
                <uc2:DropDownListU ID="ddlArea" runat="server" OrigenDatos="areaId"/>
            </td>
        </tr>   
            <tr>
                <td style="margin-left: 80px">
                    <asp:Label ID="Label1" runat="server" Text="Entidad"></asp:Label>
                </td>
                <td>
                    <ml:TextBox ID="txtEntidad" runat="server" Requerido="true"  OrigenDatos="conEntidad"
                        ValidationGroup="GuardarCon" Width="224px"></ml:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label2" runat="server" Text="Nombre Contacto"></asp:Label>
                </td>
                <td>
                    <ml:TextBox ID="txtNomContacto" runat="server" Width="224px"  OrigenDatos="conNombreContacto" Requerido="true" ValidationGroup="GuardarCon"></ml:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label3" runat="server" Text="Teléfono"></asp:Label>
                </td>
                <td>
                    <ml:TextBox ID="txtTelefono" runat="server" Width="224px"  OrigenDatos="conTelefono" Requerido="true" ValidationGroup="GuardarCon"></ml:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label4" runat="server" Text="Dirección"></asp:Label>
                </td>
                <td>
                    <ml:TextBox ID="txtDireccion" runat="server" Width="224px"  OrigenDatos="conDireccion"></ml:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label5" runat="server" Text="E-Mail"></asp:Label>
                </td>
                <td>
                    <ml:TextBox ID="txtEMail" runat="server" Width="224px" OrigenDatos="conEmail"></ml:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label6" runat="server" Text="Observaciones"></asp:Label>
                </td>
                <td>
                    <ml:TextBox ID="txtObs" runat="server" Width="224px" OrigenDatos="conObs"></ml:TextBox>
                </td>
            </tr>
        </table>
    </asp:Panel> 
    <asp:LinkButton ID="lnkAceptar" runat="server">Aceptar</asp:LinkButton>
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
