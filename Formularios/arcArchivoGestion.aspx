<%@ Page Title="Archivo Gestión" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="arcArchivoGestion.aspx.vb" Inherits="ML.arcArchivoGestion" %>
<%@ Register src="../Controles/ConPacientesLightM.ascx" tagname="ConPacientesLightM" tagprefix="uc1" %>
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
    <asp:Label ID="lblIniciar" runat="server" 
        Text="Para inciar, seleccione el paciente"></asp:Label>
    <uc1:ConPacientesLightM ID="ConPacientesLight1" runat="server"  nomTabla="PacientesTotal"/>
    <asp:Panel ID="pnlContenido" runat="server" Visible="false">    
    <table class="style2">
        <tr>
            <td style="text-align: right">
                <asp:LinkButton ID="lnkNuevo" runat="server">Nuevo Registro de Archivo</asp:LinkButton>
            </td>
        </tr>
        <tr>
            <td>
    <ml:GridView ID="grvArchivo" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="arcId" EmptyDataText="El paciente no tiene Archivos registrados" 
                    TotalPaginas="0">
        <Columns>
            <asp:BoundField DataField="arcFactura" HeaderText="Factura Nro." />
            <asp:BoundField DataField="arcAZ" HeaderText="A-Z." />
            <asp:BoundField DataField="arcAnio" HeaderText="Año" />
            <asp:BoundField DataField="arcMes" HeaderText="Mes" />
            <asp:BoundField DataField="arcObservaciones" HeaderText="Obs" />
            <asp:CommandField EditText="Edit" HeaderText="Edit"  ShowEditButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
        </Columns>
    </ml:GridView>
            </td>
        </tr>
    </table>
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
                <asp:Label ID="Label1" runat="server" Text="Factura No."></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtFac" runat="server" MaxLength="10" Requerido="True" 
                    TipoTextBox="Entero" Width="300px" ValidationGroup="GuardarAut"></ml:TextBox>
            </td>
        </tr>
    <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="A-Z."></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtAZ" runat="server" MaxLength="100" Requerido="True" 
                    Width="300px" ValidationGroup="GuardarAut"></ml:TextBox>
            </td>
        </tr>
    <tr>
            <td>
                <asp:Label ID="Label5" runat="server" Text="Año"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtAnio" runat="server" MaxLength="4" Requerido="True" 
                    Width="50px" ValidationGroup="GuardarAut" TipoTextBox="Entero"></ml:TextBox>
                <asp:CompareValidator ID="CompareValidator3" runat="server" 
                    ControlToValidate="txtAnio" ErrorMessage="El número Año debe ser mayor a 0" 
                    Operator="GreaterThan" ValueToCompare="0" ValidationGroup="GuardarAut" Display="Dynamic"></asp:CompareValidator>

            </td>
        </tr>
    <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="Mes"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtMes" runat="server" MaxLength="2" Requerido="True" 
                    Width="30px" ValidationGroup="GuardarAut" TipoTextBox="Entero"></ml:TextBox>
                <asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ControlToValidate="txtMes" ErrorMessage="El número mes debe ser menor a 12" Type="Integer"
                    Operator="LessThanEqual" ValueToCompare="12" ValidationGroup="GuardarAut" Display="Dynamic"></asp:CompareValidator>
                <asp:CompareValidator ID="CompareValidator2" runat="server" 
                    ControlToValidate="txtMes" ErrorMessage="El número del mes no puede ser menor a cero" Type="Integer"
                    Operator="GreaterThanEqual" ValueToCompare="0" ValidationGroup="GuardarAut" Display="Dynamic"></asp:CompareValidator>

            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server" Text="Observaciones"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtObs" runat="server" MaxLength="500" TextMode="MultiLine"
                    Width="300px"></ml:TextBox>
            </td>
        </tr>
    <tr>
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
