<%@ Page Title="Programación Apoyo Terapéutico" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdCopagos.aspx.vb" Inherits="ML.phdCopagos" EnableEventValidation="false" %>
<%@ Register src="../Controles/ConPacientes.ascx" tagname="ConPacientes" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .styleTb
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:ConPacientes ID="ConPacientes1" runat="server"  VerInactivos="true"/>
    <asp:Panel runat="server" id="pnlContent" Visible="false" >
        <table class="styleTb">
            <tr>
                <td style="text-align: left" width="100%">
                    <asp:Label ID="Label6" runat="server" SkinID="EtiquetaSubT" 
                        Text="Copagos"></asp:Label>
                    </td>
                <td style="text-align: left">
                </td>
            </tr>
            <tr>
                <td style="text-align: center" colspan="2">
                    <asp:GridView ID="grvCopago" runat="server"
                        AutoGenerateColumns="False" EmptyDataText="El paciente no copagos en el año">
                        <Columns>
                            <asp:BoundField DataField="autFecha" DataFormatString="{0:dd/MM/yyyy}" 
                                HeaderText="Fecha(d/m/a)" SortExpression="autFecha" />
                            <asp:BoundField DataField="autValorCopago" HeaderText="Valor Copago 1" SortExpression="autValorCopago" />
                            <asp:BoundField DataField="autValorCopago2" HeaderText="Valor Copago 2" SortExpression="autValorCopago2" />
                            <asp:BoundField DataField="autValorCopago3" HeaderText="Valor Copago 3" SortExpression="autValorCopago3" />
                            <asp:BoundField DataField="autValorCopago4" HeaderText="Valor Copago 4" SortExpression="autValorCopago4" />
                        </Columns>
                    </asp:GridView>
                    <br />
                     <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
                    </td>
            </tr>
        </table>
    </asp:Panel>
            
</asp:Content>
