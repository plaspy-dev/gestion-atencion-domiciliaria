<%@ Page Title="Registro Kilometraje" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="vehRegistro.aspx.vb" Inherits="ML.vehRegistro" %>
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
                <asp:Label ID="Label1" runat="server" Text="Vehiculo"></asp:Label>
            </td>
            <td>
                <uc2:DropDownListU ID="ddlVehiculo" runat="server" NomTabla="Vehiculos" AutoPostBack="true"/>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Fecha Registro"></asp:Label>
            </td>
            <td>
                <uc1:Fecha ID="fchReg" runat="server" AutoPostBack="true" />
            </td>
        </tr>
    </table>
    
    <table class="style1" runat="server" id="tblReg" visible="false">
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="Kilometraje Inicial"></asp:Label>
            </td>
            <td>
                <ml:TextBox runat="server" ID="txtIni" TipoTextBox="Float"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server" Text="Kilometraje Final"></asp:Label>
            </td>
            <td>
                <ml:TextBox runat="server" ID="txtFin" TipoTextBox="Float" Requerido="true" ValidationGroup="Guardar"></ml:TextBox>
                
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label5" runat="server" Text="Valor Combustible"></asp:Label>
            </td>
            <td>
                <ml:TextBox runat="server" ID="txtCombustible" TipoTextBox="Float" Requerido="true" ValidationGroup="Guardar"></ml:TextBox>
                
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label11" runat="server" Text="Valor Mantenimiento"></asp:Label>
            </td>
            <td>
                <ml:TextBox runat="server" ID="txtValorMant" TipoTextBox="Float" 
                    Requerido="true" ValidationGroup="Guardar"></ml:TextBox>
                
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label6" runat="server" Text="Medida Gasolina Tanqueada"></asp:Label>
            </td>
            <td>
                <ml:TextBox runat="server" ID="txtGasolina" TipoTextBox="Float" Requerido="true" ValidationGroup="Guardar"></ml:TextBox>
                
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label10" runat="server" Text="Actividades"></asp:Label>
            </td>
            <td>
                <ml:TextBox runat="server" ID="txtActs" TipoTextBox="Entero" Requerido="true" 
                    ValidationGroup="Guardar" MaxLength="2" Width="34px" ReadOnly="True"></ml:TextBox>
                
            </td>
        </tr>
                <tr>
            <td>
                <asp:Label ID="Label7" runat="server" Text="Observaciones y/o servicios"></asp:Label>
            </td>
            <td>
                <ml:TextBox runat="server" ID="txtObs" TextMode="MultiLine" Height="48px" 
                    Width="201px"></ml:TextBox>
                
            </td>
        </tr>
                        <tr>
            <td>
                <asp:Label ID="Label9" runat="server" Text="Repuestos"></asp:Label>
            </td>
            <td>
                <ml:TextBox runat="server" ID="txtRep" TextMode="MultiLine" Height="48px" 
                    Width="201px"></ml:TextBox>
                
            </td>
        </tr>

                <tr>
            <td colspan="2">
            <asp:Label ID="Label8" runat="server" Text="Mantenimientos del día:"></asp:Label>
                <asp:CheckBoxList ID="chkMant" runat="server">
                </asp:CheckBoxList>
            </td>
        </tr>
    </table>
</asp:Content>
