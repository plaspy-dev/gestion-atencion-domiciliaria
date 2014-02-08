<%@ Page Title="Gastos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="gastos.aspx.cs" Inherits="farmacia_gastos" %>
<%@ Register Src="~/paciente/pacienteSimple.ascx" TagName="pacienteSimple" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table>
    <tr>
        <td>Paciente<asp:RequiredFieldValidator ID="RPaciente" ControlToValidate="UCPaciente$TPacienteID" runat="server" ErrorMessage="Por favor ingrese un paciente" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td colspan="3"><uc1:pacienteSimple runat="server" ID="UCPaciente" /></td>
    </tr>
</table>
</asp:Content>

