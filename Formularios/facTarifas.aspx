<%@ Page Title="Tarifas por Asegurador" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="facTarifas.aspx.vb" Inherits="ML.facTarifas" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
            text-align:center;
        }
    .style2
    {
        width: 100%;
    }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <div class="style1">
    <table >
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Seleccione el asegurador"></asp:Label>
            </td>
            <td>
                <uc1:DropDownListU ID="ddlEnt" runat="server" AutoPostBack="true" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <hr />
                <asp:Label ID="Label4" runat="server" Text="Seleccione el periodo"></asp:Label>
                <uc1:DropDownListU ID="ddlPer" runat="server" AutoPostBack="True" />
                <br />
                <asp:LinkButton ID="lnkNuevoPer" runat="server">Generar nuevo Periodo</asp:LinkButton>
                <br />
                <asp:LinkButton ID="lnkElimPer" runat="server">Eliminar Perido</asp:LinkButton>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <table class="style2">
                    <tr>
                        <td>
                <asp:Label ID="Label2" runat="server" Text="Fecha Inicial"></asp:Label>
                        </td>
                        <td>
                            <uc2:Fecha ID="fchIni" runat="server" Requerido="True" 
                                ValidationGroup="Guardar" />
                        </td>
                        <td>
                <asp:Label ID="Label3" runat="server" Text="Fecha Final"></asp:Label>
                        </td>
                        <td>
                            <uc2:Fecha ID="fchFin" runat="server" Requerido="True" 
                                ValidationGroup="Guardar" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <hr />
                <asp:Label ID="lblTar" runat="server" Text="Tarifas" Visible="false"></asp:Label>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <ml:GridView ID="grvTar" runat="server"  Visible="False" 
                    AutoGenerateColumns="False" DataKeyNames="actId,existe" TotalPaginas="0">
                    <Columns>
                        <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
                        <asp:TemplateField HeaderText="Tarifa">
                            <ItemTemplate>
                                <ml:TextBox ID="TextBox1" runat="server" TipoTextBox="Entero" Text='<%#bind("tarTarifa")%>'></ml:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </ml:GridView>
            </td>
        </tr>
    </table>
    </div>
</asp:Content>
