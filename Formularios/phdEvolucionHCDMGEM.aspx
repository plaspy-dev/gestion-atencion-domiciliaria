<%@ Page Title="Registro de Evolucion Historia Clínica DISAN" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdEvolucionHCDMGEM.aspx.vb" Inherits="ML.phdEvolucionHCDMGEM" %>
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
                        Fecha Evolución
                    </td>
                    <td>
                        <uc2:Fecha ID="fchEv" runat="server" Requerido="true" ValidationGroup="Guardar" OrigenDatos="hcFecha"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Médico
                    </td>
                    <td>
                        <uc4:DropDownListU ID="ddlMedico" runat="server" Requerido="true" ValidationGroup="Guardar"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Trabajadora social
                    </td>
                    <td>
                        <uc4:DropDownListU ID="ddlTrSocial" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Psicólogo
                    </td>
                    <td>
                        <uc4:DropDownListU ID="ddlPsi" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Enfermera
                    </td>
                    <td>
                        <uc4:DropDownListU ID="ddlEnf" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Plan de enfermería
                    </td>
                    <td>
                        <ml:TextBox ID="txtPlan" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" Requerido="true" ValidationGroup="Guardar" OrigenDatos="hcPlanEnfermeria"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Órdenes Médicas
                    </td>
                    <td>
                        <ml:TextBox ID="txtOM" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="hcOrdenesMedicas"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Codigo CIE10 Diagnóstico
                    </td>
                    <td>
                        <uc3:Lista ID="lstCie10" NomTabla="CIE10" runat="server"  Requerido="True" 
                            ValidationGroup="Guardar" OrigenDatos="cieCodDx"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Codigo CIE10 Diagnóstico
                    </td>
                    <td>
                        <uc3:Lista ID="lstCie10_1" NomTabla="CIE10" runat="server" OrigenDatos="cieCodDx_1"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Codigo CIE10 Diagnóstico
                    </td>
                    <td>
                        <uc3:Lista ID="lstCie10_2" NomTabla="CIE10" runat="server" OrigenDatos="cieCodDx_2"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Otros diagnósticos
                    </td>
                    <td>
                        <ml:TextBox ID="txtOtrosDg" runat="server" Height="38px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="hcOtrosDiag"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Novedades de Evolución
                    </td>
                    <td>
                        <ml:TextBox ID="txtNov" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="hcNovedades"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Observaciones Psicología
                    </td>
                    <td>
                        <ml:TextBox ID="txtObsPsi" runat="server" Height="73px" MaxLength="1000" 
                            OrigenDatos="hcObsPsicologia" TextMode="MultiLine" Width="315px"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Observaciones Trabajo social
                    </td>
                    <td>
                        <ml:TextBox ID="txtObsTrS" runat="server" Height="73px" MaxLength="1000" 
                            OrigenDatos="hcObsTrSocial" TextMode="MultiLine" Width="315px"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Observaciones Enfermería
                    </td>
                    <td>
                        <ml:TextBox ID="txtObsEnf" runat="server" Height="73px" MaxLength="1000" 
                            OrigenDatos="hcObsEnfermeria" TextMode="MultiLine" Width="315px"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Observaciones Nutrición
                    </td>
                    <td>
                        <ml:TextBox ID="txtObsNut" runat="server" Height="73px" MaxLength="1000" 
                            OrigenDatos="hcObsNutricion" TextMode="MultiLine" Width="315px"></ml:TextBox>
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
