<%@ Page Title="Inactivar Pacientes" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdEgreso.aspx.vb" Inherits="ML.phdEgreso" %>
<%@ Register src="../Controles/ConPacientes.ascx" tagname="ConPacientes" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:ConPacientes ID="ConPacientes1" runat="server" NomListaTabla="PacienteAut"  />
    <br/>
    <table border="1" runat="server" id="tblEgr" visible="false">
    <tr><td>Fecha Inactivación</td><td>
    
        <uc2:Fecha ID="fecEgreso" runat="server" Requerido="True" 
            ValidationGroup="Egreso" />
    
        </td></tr>
    <tr><td>Motivo</td><td>
    
        <uc3:DropDownListU ID="ddlMotivoEgreso" runat="server" Requerido="True" 
            ValidationGroup="Egreso" />
    
        </td></tr>
    <tr><td>Observaciones</td><td>
    
        <ml:TextBox ID="txtObs" runat="server" Height="51px" TextMode="MultiLine" 
            Width="178px"></ml:TextBox>
    
        </td></tr>
    <tr><td colspan="2" style="text-align: center">
        <asp:LinkButton ID="lnkGenEgr" runat="server" 
            
            onclientclick="if(!confirm('Confirma que desea inactivar el paciente?'))return false;" 
            ValidationGroup="Egreso">Inactivar Paciente</asp:LinkButton>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
            ValidationGroup="Egreso" />
        </td></tr>
    </table>
</asp:Content>
