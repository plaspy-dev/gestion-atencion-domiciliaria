<%@ Page Title="Equipos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="equManEquipos.aspx.vb" Inherits="ML.equManEquipos" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
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
                <asp:Label ID="Label1" runat="server" Text="Nombre"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtNombre" runat="server" MaxLength="100" 
                    OrigenDatos="equNombre" Requerido="True" ValidationGroup="Guardar" 
                    Width="236px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Serial"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtSerial" runat="server" MaxLength="100" 
                    OrigenDatos="equSerial" Requerido="True" ValidationGroup="Guardar" 
                    Width="236px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="Placa"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="TextBox1" runat="server" OrigenDatos="equPlaca" MaxLength="50"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label6" runat="server" Text="Modelo"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="TextBox2" runat="server" OrigenDatos="equModelo" MaxLength="50"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label7" runat="server" Text="Marca"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="TextBox3" runat="server" OrigenDatos="equMarca" MaxLength="50"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Propietario</td>
            <td>
                <asp:RadioButtonList ID="rblProp" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Selected="True" Value="1">Gestión de atención domiciliaria</asp:ListItem>
                    <asp:ListItem Value="2">Gestión de atención domiciliaria</asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label8" runat="server" Text="Fecha Ultimo Mantenimiento"></asp:Label>
            </td>
            <td>
                <uc1:Fecha ID="Fecha1" runat="server" OrigenDatos="equFecUltMant" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label9" runat="server" Text="Fecha Próximo Mantenimiento"></asp:Label>
            </td>
            <td>
                <uc1:Fecha ID="Fecha2" runat="server" OrigenDatos="equFecProxMant" 
                    Requerido="True" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server" Text="Observaciones Adicionales"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtObs" runat="server" Height="61px" MaxLength="500" 
                    OrigenDatos="equObs" Requerido="False" TextMode="MultiLine" 
                    ValidationGroup="Guardar" Width="236px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label5" runat="server" Text="Activo?"></asp:Label>
            </td>
            <td>
                <ml:CheckBox ID="chkActivo" runat="server" OrigenDatos="equActivo" />
            </td>
        </tr>
    </table>

</asp:Content>
