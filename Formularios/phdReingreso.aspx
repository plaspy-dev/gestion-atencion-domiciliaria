<%@ Page Title="Reactivar Pacientes" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdReingreso.aspx.vb" Inherits="ML.phdReingreso" %>
<%@ Register src="../Controles/ConPacientes.ascx" tagname="ConPacientes" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:ConPacientes ID="ConPacientes1" runat="server" NomListaTabla="PacInactivos" Habilitar="true" />
    <br/>
    <table border="1" runat="server" id="tblIng" visible="false">
    <tr><td>Fecha Reactivación
    </td><td>
            <uc2:Fecha ID="fecReingreso" runat="server" Requerido="True" 
            ValidationGroup="Reingreso" />    
    </td></tr>
    <tr><td>Motivo</td><td>
        <uc3:DropDownListU ID="ddlMotivoReingreso" runat="server" Requerido="True" 
            ValidationGroup="Reingreso" />
        </td></tr>
    <tr><td>Observaciones</td><td>
        <ml:TextBox ID="txtObs" runat="server" TextMode="MultiLine"></ml:TextBox>
        </td></tr>
    <tr><td colspan="2" style="text-align: center">
        <asp:LinkButton ID="lnkGenRIng" runat="server"             
            onclientclick="if(!confirm('Confirma que desea reactivar el paciente?'))return false;" 
            ValidationGroup="Reingreso">Reactivar</asp:LinkButton>
        </td></tr>
    </table>
</asp:Content>
