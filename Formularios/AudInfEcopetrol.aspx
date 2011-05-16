<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AudInfEcopetrol.aspx.vb" Inherits="ML.AudInfEcopetrol" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table border="1">
    <tr>
        <td colspan="2" class="celdaTitulo">
            <asp:Label ID="Label1" runat="server" Text="Rango de Fechas" SkinID="lblsubTitulo"></asp:Label>
        </td>
        
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label2" runat="server" Text="Fecha inicial"></asp:Label>
        </td>
        <td>
            <asp:Label ID="Label3" runat="server" Text="Fecha Final"></asp:Label>
        </td>
    </tr>
        <tr>
        <td>
            <uc1:Fecha ID="fchIni" runat="server" ValidationGroup="BuscarPrg" Requerido="true"/>
        </td>
        <td>
            <uc1:Fecha ID="fchFin" runat="server" ValidationGroup="BuscarPrg" Requerido="true"/>
        </td>
    </tr>
     <tr>
        <td colspan="2" style="text-align: center">
            <asp:ImageButton ID="imbBuscar" runat="server" SkinID="imbBuscar" 
                ValidationGroup="BuscarPrg" Height="16px" Width="18px" />
        </td>
    </tr>
</table>
    <asp:GridView ID="grvInf" runat="server" AutoGenerateColumns="false">
    <Columns>
    <asp:TemplateField HeaderText="Prestador">
    <ItemTemplate>
    Gestión de atención domiciliaria
    </ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Fecha">
    <ItemTemplate>
    <asp:Label runat="server" ID="lblfec" Text='<%# CType(fchIni.Valor, Date).ToString("MMMM")%>'></asp:Label>
        </ItemTemplate>
    </asp:TemplateField>
        <asp:BoundField DataField="pacCarne" headerText="Carnet" />
        <asp:BoundField DataField="pacdocumento" headerText="Identificación" />
        <asp:BoundField DataField="pacnombres" headerText="Beneficiario" />
        <asp:TemplateField HeaderText="Edad">
        <ItemTemplate>
        <asp:Label runat="server" ID="lblEdad" Text='        <%#getEdad(Eval("pacFechaNac"))%>'></asp:Label>
        </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField DataField="megNombre" headerText="Mega" />
        <asp:BoundField DataField="actividades" headerText="Servicios" />
        <asp:BoundField DataField="cirDescripcion" headerText="Diagnóstico 1" />
        <asp:BoundField DataField="cieCodDx" headerText="CIE-10 (1)" />
        <asp:BoundField DataField="cirDescripcion_1" headerText="Diagnóstico 2" />
        <asp:BoundField DataField="cieCodDx_1" headerText="CIE-10 (2)" />
        <asp:BoundField DataField="cirDescripcion_2" headerText="Diagnóstico 3" />
        <asp:BoundField DataField="cieCodDx_2" headerText="CIE-10 (3)" />
        <asp:BoundField DataField ="pacObservaciones" headerText="Observaciones" />
    </Columns>
    
    </asp:GridView>
</asp:Content>
