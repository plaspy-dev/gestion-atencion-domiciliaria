<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="equProgramacion_.aspx.vb" Inherits="ML.equProgramacion_" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table class="style1">
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Fecha Programación"></asp:Label>
            </td>
            <td style="margin-left: 120px">
                <uc1:Fecha ID="fchPrg" runat="server" AutoPostBack="True" 
                    OrigenDatos="prgFecha" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Equipo"></asp:Label>
            </td>
            <td style="margin-left: 120px">
                <uc2:DropDownListU ID="ddlEquipo" runat="server" AutoPostBack="True" 
                    NomTabla="Equipos" OrigenDatos="equId" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="Paciente"></asp:Label>
            </td>
            <td style="margin-left: 120px">
                <uc2:DropDownListU ID="ddlPaciente" runat="server" NomTabla="Paciente" 
                    OrigenDatos="pacId" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server" Text="Funcionario responsable"></asp:Label>
            </td>
            <td style="margin-left: 120px">
                <uc2:DropDownListU ID="ddlPer" runat="server" NomTabla="PersonalHS" 
                    OrigenDatos="perId" />
            </td>
        </tr>
    </table>
    <br />
    <asp:Panel ID="pnlHistProg" runat="server" Visible="False">
        <ml:GridView ID="grvProg" runat="server">
        </ml:GridView>
    </asp:Panel>
</asp:Content>
