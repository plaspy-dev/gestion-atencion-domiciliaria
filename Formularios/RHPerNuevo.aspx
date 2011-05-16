<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="RHPerNuevo.aspx.vb" Inherits="ML.RHPerNuevo" %>

<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/Correo.ascx" tagname="Correo" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table border="1">
    <tr>
        <td>Fecha Inicial</td>
        <td>
            <uc2:Fecha ID="fchIni" runat="server" />
        </td>
    </tr>
        <tr>
        <td>Fecha Final</td>
        <td>
            <uc2:Fecha ID="fchFin" runat="server" />
            </td>
    </tr>
    <tr><td colspan="2" style="text-align:center;"><asp:ImageButton runat="server" 
            ID="imbBuscar" SkinID="imbBuscar" Height="16px" Width="16px" /></td></tr>
    </table>

    <ml:GridView runat="server" ID="grvPac" EmptyDataText="No se encuentran registros" AutoGenerateColumns="false" DataKeyNames="perId">
        <Columns>
            <asp:TemplateField  HeaderText="Sel">
                <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkSel" Checked="true" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="Documento" DataField="perDocumento" />
            <asp:BoundField HeaderText="Nombre" DataField="perNombre" />
            <asp:BoundField HeaderText="Cargo" DataField="carDescripcion" />            
            <asp:BoundField HeaderText="Correo" DataField="perCorreoElectronico" />
            <asp:BoundField HeaderText="Fecha registro en sistema" DataField="segFechaIngreso" />
        </Columns>
    </ml:GridView>
    <br />
    <asp:LinkButton ID="lnkAceptar" runat="server" >Enviar Correo</asp:LinkButton>
    <uc3:Correo ID="Correo1" runat="server" TipoCorreo="Personal" />
    
</asp:Content>
