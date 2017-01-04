<%@ Page Title="Ambulancias" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="listado.aspx.cs" Inherits="ambulancia_listado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    autoComplete({ controlId: "<%= TEmpresa.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Empresa")%>", autoSelect: true, controlDataId: "<%= TEmpresaId.ClientID %>" });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="P" DefaultButton="BActualizar">
<table class="table table-condensed">
    <tr>
        <td class="px">Empresa</td>
        <td></td>
    </tr>
    <tr>
        <td>
            <asp:TextBox runat="server" ID="TEmpresa"></asp:TextBox>
            <asp:TextBox runat="server" ID="TEmpresaId" CssClass="hide"></asp:TextBox>
        </td>
        <td><asp:Button runat="server" ID="BActualizar" Text="Actualizar" CssClass="btn btn-submit" OnClick="BActualizar_Click" /></td>
    </tr>
</table>
</asp:Panel>
<asp:GridView ID="GResultados" runat="server" AutoGenerateColumns="False" DataSourceID="SResultados" EmptyDataText="No se encontraron eventos" CssClass="table table-condensed table-bordered table-hover table-striped"
    PageSize="50" AllowPaging="true" AllowSorting="true">
    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
    <Columns>
        <asp:HyperLinkField DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/ambulancia/ambulancia.aspx?eid={0}" Target="_blank" DataTextField="nombre" HeaderText="Empresa" SortExpression="nombre" />
        <asp:BoundField DataField="placa" HeaderText="Placa" SortExpression="placa" />
        <asp:BoundField DataField="propietario" HeaderText="Propietario" SortExpression="propietario" />
    </Columns>
</asp:GridView>
    <asp:Label runat="server" ID="LTotal" CssClass="pull-right"></asp:Label>
<asp:SqlDataSource ID="SResultados" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
    SelectCommand="SELECT 
        ambulancia.placa,
        ambulancia.propietario,
        empresa.id,
        empresa.nombre
        FROM ambulancia
        LEFT JOIN empresa ON (empresa.id=ambulancia.empresa)
        WHERE
        (@empresa=0 OR ambulancia.empresa=@empresa)
        ORDER BY ambulancia.id DESC
        ">
        <SelectParameters>
            <asp:ControlParameter ControlID="TEmpresaId" PropertyName="Text" Name="empresa" DefaultValue="0" />
        </SelectParameters>
</asp:SqlDataSource>
</asp:Content>

