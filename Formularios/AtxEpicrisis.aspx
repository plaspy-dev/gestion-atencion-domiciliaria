<%@ Page Title="Registro de Epicrisis" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AtxEpicrisis.aspx.vb" Inherits="ML.AtxEpicrisis" %>
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
                        <uc2:Fecha ID="fchEv" runat="server" Requerido="true" ValidationGroup="Guardar" OrigenDatos="epiFecha"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Terapeuta
                    </td>
                    <td>
                        <uc4:DropDownListU ID="ddlTerapeuta" runat="server" Requerido="true" ValidationGroup="Guardar"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Resultados Valoración Inicial
                    </td>
                    <td>
                        <ml:TextBox ID="txtResulValIni" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" Requerido="true" ValidationGroup="Guardar" OrigenDatos="epiResulValIni"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Resultados Valoración final
                    </td>
                    <td>
                        <ml:TextBox ID="txtResulValFin" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="epiResulValFin"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Plan de Intervención propuesto
                    </td>
                    <td>
                        <ml:TextBox ID="txtPlan" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="epiPlan"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Intervanción realizada
                    </td>
                    <td>
                        <ml:TextBox ID="txtIntervencion" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="epiIntervencion"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Logros Obtenidos
                    </td>
                    <td>
                        <ml:TextBox ID="txtLogros" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="epiLogros"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Observaciones
                    </td>
                    <td>
                        <ml:TextBox ID="txtObservaciones" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="epiObservaciones"></ml:TextBox>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    <hr />
    <asp:Label ID="Label1" runat="server" Text="Epicrisis registradas en esta fecha:"></asp:Label>
        <br />
        <ml:GridView ID="grvEpicrisis" runat="server" AutoGenerateColumns="False" 
            TotalPaginas="0" DataKeyNames="epiId" EmptyDataText="No se ha registrado Epicrisis para este paciente en esta fecha">
            <Columns>
                <asp:CommandField HeaderText="Sel" SelectText="Sel" ShowSelectButton="True" />
                <asp:BoundField DataField="epiFecha" HeaderText="Fecha" />
                <asp:BoundField DataField="epiResulValIni" HeaderText="Res.Val.Inicial" />
                <asp:BoundField DataField="epiResulValFin" HeaderText="Res.Val.final" />
                <asp:BoundField DataField="epiPlan" HeaderText="Plan Intervención" />
                <asp:BoundField DataField="epiIntervencion" HeaderText="Intervención" />
                <asp:BoundField DataField="epiLogros" HeaderText="Logros" />
                <asp:BoundField DataField="epiObservaciones" HeaderText="Obs." />
                <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
            </Columns>
        </ml:GridView>
    </asp:Panel>
    <br />

</asp:Content>
