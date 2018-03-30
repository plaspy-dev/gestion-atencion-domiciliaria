<%@ Page Title="Ambulancias" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="listado.aspx.cs" Inherits="ambulancia_listado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    autoComplete({ controlId: "<%= TEmpresa.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Empresa")%>", autoSelect: true, controlDataId: "<%= TEmpresaId.ClientID %>" });
</script>
<style>
    .bdate {
        white-space: nowrap;
    }
    .bdate b {
        float: right;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="P" DefaultButton="BActualizar">
<table class="table table-condensed">
    <tr>
        <td class="px">Empresa</td>
        <td class="px">Documentos</td>
        <td></td>
    </tr>
    <tr>
        <td>
            <asp:TextBox runat="server" ID="TEmpresa"></asp:TextBox>
            <asp:TextBox runat="server" ID="TEmpresaId" CssClass="hide"></asp:TextBox>
        </td>
        <td>
            <asp:DropDownList ID="DDocumento" runat="server" CssClass="amd"
                DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                <asp:ListItem Text="Vencidos" Value="1"></asp:ListItem>
                <asp:ListItem Text="Sin vencer" Value="2"></asp:ListItem>
            </asp:DropDownList>
        </td>
        <td><asp:Button runat="server" ID="BActualizar" Text="Actualizar" CssClass="btn btn-submit" OnClick="BActualizar_Click" /></td>
    </tr>
</table>
</asp:Panel>
<asp:GridView ID="GResultados" runat="server" AutoGenerateColumns="False" DataSourceID="SResultados" EmptyDataText="No se encontraron ambulancias" CssClass="table table-condensed table-bordered table-hover table-striped"
    PageSize="50" AllowPaging="true" AllowSorting="true">
    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
    <Columns>
        <asp:HyperLinkField DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/ambulancia/ambulancia.aspx?eid={0}" Target="_blank" DataTextField="nombre" HeaderText="Empresa" SortExpression="nombre" />
        <asp:BoundField DataField="placa" HeaderText="Placa" SortExpression="placa" />
        <asp:BoundField DataField="propietario" HeaderText="Propietario" SortExpression="propietario" />
        <asp:BoundField DataField="docs" HeaderText="Documentos" SortExpression="docs" HtmlEncode="false" ItemStyle-CssClass="bdate" />
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
        empresa.nombre,
        GROUP_CONCAT(CONCAT(doc.nombre,'<b>', DATE(ambulancia_documento.vencimiento),'</b>') ORDER BY doc.nombre SEPARATOR '<br />') docs
        FROM ambulancia
        LEFT JOIN empresa ON (empresa.id=ambulancia.empresa)
        LEFT JOIN ambulancia_documento ON (ambulancia_documento.ambulancia=ambulancia.id)
        LEFT JOIN varios doc ON (doc.id=ambulancia_documento.documento)
        WHERE
        (@empresa=0 OR ambulancia.empresa=@empresa)
        AND (@documento=0 
            OR (@documento=1 AND ambulancia_documento.vencimiento<NOW()) 
            OR (@documento=2 AND ambulancia_documento.vencimiento>NOW()))
        GROUP BY ambulancia.id
        ORDER BY ambulancia.id DESC
        ">
        <SelectParameters>
            <asp:ControlParameter ControlID="TEmpresaId" PropertyName="Text" Name="empresa" DefaultValue="0" />
            <asp:ControlParameter ControlID="DDocumento" PropertyName="SelectedValue" Name="documento" />
        </SelectParameters>
</asp:SqlDataSource>
</asp:Content>

