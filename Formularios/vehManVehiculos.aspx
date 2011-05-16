<%@ Page Title="Vehículos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="vehManVehiculos.aspx.vb" Inherits="ML.vehManVehiculos" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
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
                <asp:Label ID="Label1" runat="server" Text="Placa"></asp:Label>
            </td>
            <td colspan="3">
                <ml:TextBox ID="txtPlaca" runat="server" MaxLength="10" Requerido="True" ValidationGroup="Guardar" 
                    Width="236px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Marca"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtFab" runat="server" MaxLength="50" 
                    OrigenDatos="vehFabricante" Requerido="True" ValidationGroup="Guardar" 
                    Width="130px"></ml:TextBox>
            </td>
            <td>
                <asp:Label ID="Label7" runat="server" Text="Linea"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtLinea" runat="server" MaxLength="50"
                    OrigenDatos="vehLinea" Requerido="True" 
                    ValidationGroup="Guardar" Width="131px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label8" runat="server" Text="Cilindraje"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtCil" runat="server" MaxLength="4"
                    OrigenDatos="vehCilindraje" Requerido="True" 
                    ValidationGroup="Guardar" Width="50px" TipoTextBox="Entero"></ml:TextBox>
            </td>
            <td>
                <asp:Label ID="Label3" runat="server" Text="Modelo"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtModelo" runat="server" MaxLength="4"
                    OrigenDatos="vehModelo" Requerido="True" 
                    ValidationGroup="Guardar" Width="100px" TipoTextBox="Entero"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label9" runat="server" Text="Clase"></asp:Label>
            </td>
            <td colspan="3">
                <uc1:DropDownListU ID="ddlClase" runat="server" OrigenDatos="vclId" Requerido="True"  NomTabla="claseVehiculo"
                    ValidationGroup="Guardar" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label10" runat="server" Text="Nro Motor"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtNroMotor" runat="server" MaxLength="50"
                    OrigenDatos="vehNroMotor" Requerido="True" ValidationGroup="Guardar" Width="214px"></ml:TextBox>
            </td>
            <td>
                <asp:Label ID="Label11" runat="server" Text="Nro Serie"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtNroSerie" runat="server" MaxLength="50"
                    OrigenDatos="vehNroSerie" Requerido="True" 
                    ValidationGroup="Guardar" Width="214px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4" style="text-align: center">
            <hr />
                <asp:Label ID="Label12" runat="server" Text="SOAT"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label14" runat="server" Text="Fecha Expedición"></asp:Label>
            </td>
            <td>
                <uc2:Fecha ID="fchExpSoat" runat="server" OrigenDatos="vehFechaExpSoat" Requerido="True" ValidationGroup="Guardar"/>
            </td>
            <td>
                <asp:Label ID="Label16" runat="server" Text="Fecha Vencimiento"></asp:Label>
            </td>
            <td>
                <uc2:Fecha ID="fchVenSoat" runat="server" OrigenDatos="vehFechaVenSoat" Requerido="True" ValidationGroup="Guardar"/>
            </td>
        </tr>
        <tr>
            <td colspan="4" style="text-align: center">
            <hr />
                <asp:Label ID="Label13" runat="server" Text="OTRO Certificado"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label15" runat="server" Text="Fecha Expedición"></asp:Label>
            </td>
            <td>
                <uc2:Fecha ID="fchExpOtro" runat="server" OrigenDatos="vehFechaExpOtro" Requerido="True" ValidationGroup="Guardar"/>
            </td>
            <td>
                <asp:Label ID="Label17" runat="server" Text="Fecha Vencimiento"></asp:Label>
            </td>
            <td>
                <uc2:Fecha ID="fchVenOtro" runat="server" OrigenDatos="vehFechaVenOtro" Requerido="True" ValidationGroup="Guardar"/>
            </td>
        </tr>
        <tr><td colspan="4"><hr /></td></tr>
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server" Text="Conductor"></asp:Label>
            </td>
            <td colspan="3">                
            
                <uc1:DropDownListU ID="ddlPer" Requerido="true" ValidationGroup="Guardar" NomTabla="PersonalHSConductor" OrigenDatos="perId" runat="server" />
                
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label5" runat="server" Text="Activo?"></asp:Label>
            </td>
            <td colspan="3">
                
                <ml:CheckBox runat="server" ID="chkActivo" OrigenDatos="vehActivo" />
                
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label6" runat="server" Text="Kilometraje"></asp:Label>
            </td>
            <td colspan="3">
                
                <asp:Label ID="lblReg" runat="server" SkinID="lblFormatoFecha"></asp:Label>
                
            </td>
        </tr>
    </table>

</asp:Content>
