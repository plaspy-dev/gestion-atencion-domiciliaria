<%@ Page Title="Registro de Evolucion Historia Clínica" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdEvolucionHC.aspx.vb" Inherits="ML.phdEvolucionHC" %>
<%@ Register src="../Controles/ConPacientesLightB.ascx" tagname="ConPacientesLightB" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/Lista.ascx" tagname="Lista" tagprefix="uc3" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">

    <uc1:ConPacientesLightB ID="ConPacientesLightB1" runat="server" />
    <asp:Panel ID="pnlEv" runat="server" Visible="False">
        <asp:Panel ID="pnlRegEv" runat="server">
            <table class="style1">
                <tr>
                        <td class="celdaTitulo" colspan="2">
                            <asp:Label ID="lblTituloReg" runat="server" SkinID="lblsubTitulo" 
                                Text="Nuevo registro de Evolucion HC"></asp:Label>
                        </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="Fecha Evolución"></asp:Label>
                    </td>
                    <td>
                        <uc2:Fecha ID="fchEv" runat="server" Requerido="true" ValidationGroup="Guardar" OrigenDatos="hcFecha"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label10" runat="server" Text="Médico"></asp:Label>
                    </td>
                    <td>
                        <uc4:DropDownListU ID="ddlMedico" runat="server" Requerido="true" ValidationGroup="Guardar"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label3" runat="server" Text="Plan de enfermería"></asp:Label>
                    </td>
                    <td>
                        <ml:TextBox ID="txtPlan" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" Requerido="true" ValidationGroup="Guardar" OrigenDatos="hcPlanEnfermeria"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label4" runat="server" Text="Órdenes Médicas"></asp:Label>
                    </td>
                    <td>
                        <ml:TextBox ID="txtOM" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="hcOrdenesMedicas"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label5" runat="server" Text="Codigo CIE10 Diagnóstico"></asp:Label>
                    </td>
                    <td>
                        <uc3:Lista ID="lstCie10" NomTabla="CIE10" runat="server"  Requerido="True" 
                            ValidationGroup="Guardar" OrigenDatos="cieCodDx"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label6" runat="server" Text="Codigo CIE10 Diagnóstico"></asp:Label>
                    </td>
                    <td>
                        <uc3:Lista ID="lstCie10_1" NomTabla="CIE10" runat="server" OrigenDatos="cieCodDx_1"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label7" runat="server" Text="Codigo CIE10 Diagnóstico"></asp:Label>
                    </td>
                    <td>
                        <uc3:Lista ID="lstCie10_2" NomTabla="CIE10" runat="server" OrigenDatos="cieCodDx_2"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label8" runat="server" Text="Otros diagnósticos"></asp:Label>
                    </td>
                    <td>
                        <ml:TextBox ID="txtOtrosDg" runat="server" Height="38px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="hcOtrosDiag"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label9" runat="server" Text="Novedades de Evolución"></asp:Label>
                    </td>
                    <td>
                        <ml:TextBox ID="txtNov" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="hcNovedades"></ml:TextBox>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    <hr />
    <asp:Label ID="Label1" runat="server" Text="Evoluciones registradas en esta fecha:"></asp:Label>
        <br />
        <ml:GridView ID="grvEv" runat="server" AutoGenerateColumns="False" 
            TotalPaginas="0" DataKeyNames="hcId" EmptyDataText="No se ha registrado Evolucion HC para este paciente en esta fecha">
            <Columns>
                <asp:CommandField HeaderText="Sel" SelectText="Sel" ShowSelectButton="True" />
                <asp:BoundField DataField="hcFecha" HeaderText="Fecha" />
                <asp:BoundField DataField="hcPlanEnfermeria" HeaderText="Plan Enfermeria" />
                <asp:BoundField DataField="hcOrdenesMedicas" HeaderText="Ordenes Méd." />
                <asp:BoundField DataField="cieCodDx" HeaderText="CIE10" />
                <asp:BoundField DataField="cieCodDx_1" HeaderText="CIE10_1" />
                <asp:BoundField DataField="cieCodDx_2" HeaderText="CIE10_2" />
                <asp:BoundField DataField="hcOtrosDiag" HeaderText="Otros diag." />
                <asp:BoundField DataField="hcNovedades" HeaderText="Novedades" />
                <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
            </Columns>
        </ml:GridView>
    </asp:Panel>
    <br />

</asp:Content>
