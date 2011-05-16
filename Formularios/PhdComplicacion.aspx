<%@ Page Title="Complicaciones derivadas de la prestación de servicios" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdComplicacion.aspx.vb" Inherits="ML.PhdComplicacion" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<%@ Register src="../Controles/ConPacientesLightM.ascx" tagname="ConPacientesLightM" tagprefix="uc3" %>
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
                <table class="style1">
                    <tr>
                        <td>
                            <asp:Label ID="Label1" runat="server" Text="Fecha"></asp:Label>
                        </td>
                        <td>
                            <uc1:Fecha ID="Fecha1" runat="server" AutoPostBack="True" Requerido="True" ValidationGroup="Guardar" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br />
    
    
    <table class="style1">
                    <tr>
                        <td class="celdaTitulo" colspan="2">
                            <asp:Label ID="lblTituloReg" runat="server" SkinID="lblsubTitulo" 
                                Text="Nuevo registro de Complicación"></asp:Label>
                        </td>
                </tr>

        <tr>
            <td colspan="2">
                <uc3:ConPacientesLightM ID="ConPacientesLightM1" runat="server" VerInactivos="true" />
                <br />
                <br />
                        </td>
        </tr>
        
        <tr>
            <td>
                <asp:Label ID="Label5" runat="server" Text="Tipo de Complicación"></asp:Label>
            </td>
            <td>
                <uc2:DropDownListU ID="ddlTipo" runat="server" Requerido="True" ValidationGroup="Guardar" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server" Text="Riesgo Potencial"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtRiesgo" runat="server" Height="43px" MaxLength="1000" 
                    TextMode="MultiLine" Width="274px" Requerido="True" ValidationGroup="Guardar"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                            <asp:Label ID="Label3" runat="server" Text="Causa"></asp:Label>
                        </td>
            <td>
                <ml:TextBox ID="txtCausa" runat="server" Height="43px" MaxLength="1000" 
                    TextMode="MultiLine" Width="274px" Requerido="True" ValidationGroup="Guardar"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                            <asp:Label ID="Label2" runat="server" Text="Acción de mejora"></asp:Label>
                        </td>
            <td>
                <ml:TextBox ID="txtAccion" runat="server" Height="43px" MaxLength="1000" 
                    TextMode="MultiLine" Width="274px" Requerido="True" ValidationGroup="Guardar"></ml:TextBox>
            </td>
        </tr>
    </table>
    <hr />
    
<br />
<asp:Label ID="Label8" runat="server" Text="Complicaciones registradas en esta fecha:"></asp:Label>
<br />
<ml:GridView ID="grvComp" runat="server" AutoGenerateColumns="False" 
        TotalPaginas="0" DataKeyNames="comId" 
        EmptyDataText="No se ha registrado complicaciones para esta fecha">
    <Columns>
        <asp:BoundField DataField="comFecha" DataFormatString="{0:dd/MM/yyyy}" 
            HeaderText="Fecha" SortExpression="comFecha" />
        <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
            SortExpression="pacDocumento" />
        <asp:TemplateField HeaderText="Nombre">
            <ItemTemplate>
                <asp:Label ID="Label7" runat="server" Text='<%# Eval("pacPApellido")+" " +Eval("pacSApellido")+" " +Eval("pacPNombre")+" " +Eval("pacSNombre") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField DataField="comRiesgo" HeaderText="Riesgo" 
            SortExpression="comRiesgo" />
        <asp:BoundField DataField="comCausa" HeaderText="Causa" 
            SortExpression="comCausa" />
        <asp:BoundField DataField="comAccionMejora" HeaderText="Accion Mejora"
            SortExpression="comAccionMejora" />
        <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
    </Columns>
</ml:GridView>
    
    
</asp:Content>
