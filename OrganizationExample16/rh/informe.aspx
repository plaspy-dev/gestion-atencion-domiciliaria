<%@ Page Title="Informe" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informe.aspx.cs" Inherits="rh_informe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="P" DefaultButton="BActualizar">
<table class="table table-condensed">
    <tr>
        <td class="px">Estado</td>
        <td></td>
    </tr>
    <tr>
        <td><asp:DropDownList ID="DEstado" runat="server" CssClass="amd" AppendDataBoundItems="true">
            <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>            
            <asp:ListItem Text="Activo" Value="1" Selected="True"></asp:ListItem>
            <asp:ListItem Text="Inactivo" Value="2"></asp:ListItem>
                </asp:DropDownList></td>
        <td><asp:Button runat="server" ID="BActualizar" Text="Actualizar" CssClass="btn btn-submit" OnClick="BActualizar_Click" /></td>
    </tr>
</table>
</asp:Panel>
<asp:GridView ID="GResultados" runat="server" AutoGenerateColumns="False" DataSourceID="SResultados" EmptyDataText="No se encontraron " CssClass="table table-condensed table-bordered table-hover table-striped"
    PageSize="50" AllowPaging="true" AllowSorting="true">
    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
    <Columns>
        <asp:HyperLinkField DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/rh/funcionario.aspx?fid={0}" Target="_blank" DataTextField="documento" HeaderText="Documento" SortExpression="documento" ItemStyle-HorizontalAlign="Right" />
        <asp:BoundField DataField="apellidos" HeaderText="Apellidos" SortExpression="apellidos" />
        <asp:BoundField DataField="nombres" HeaderText="Nombres" SortExpression="nombres" />
        <asp:BoundField DataField="telefonos" HeaderText="Teléfonos" SortExpression="telefonos" />
        <asp:BoundField DataField="celular" HeaderText="Celular" SortExpression="celular" />
        <asp:BoundField DataField="ingreso" HeaderText="Ingreso" SortExpression="ingreso" DataFormatString="{0:d}" />
    </Columns>
</asp:GridView>
    <asp:Label runat="server" ID="LTotal" CssClass="pull-right"></asp:Label>
<asp:SqlDataSource ID="SResultados" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
    SelectCommand="SELECT 
        id, documento, apellidos, nombres, ingreso, telefonos, celular
        FROM rh
        WHERE
        (@estado=0 
            OR (@estado=1 AND rh.terminacion IS NULL)
            OR (@estado=2 AND rh.terminacion IS NOT NULL)
        )
        ORDER BY apellidos,nombres
    ">
        <SelectParameters>
            <asp:ControlParameter ControlID="DEstado" PropertyName="SelectedValue" Name="estado" />
        </SelectParameters>
</asp:SqlDataSource>
</asp:Content>

