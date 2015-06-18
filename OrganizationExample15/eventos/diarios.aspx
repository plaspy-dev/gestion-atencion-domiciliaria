<%@ Page Title="Diarios" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="diarios.aspx.cs" Inherits="eventos_diarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel ID="Panel1" runat="server" DefaultButton="BBuscar">
    <asp:TextBox runat="server" CssClass="fecha" ID="TFecha"></asp:TextBox><asp:Button ID="BBuscar" runat="server" Text="Buscar" />
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron recursos humanos" 
        AllowPaging="True" PageSize="50" AllowSorting="True">
        <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="nombre" HeaderText="Nombre" SortExpression="nombre"
                DataNavigateUrlFields="id" 
                DataNavigateUrlFormatString="~/eventos/programacion.aspx?id={0}">
                <ItemStyle Wrap="false"/>
            </asp:HyperLinkField>
            <asp:BoundField HeaderText="Inicio" DataField="inicio" SortExpression="inicio" DataFormatString="{0:d}" />
            <asp:BoundField HeaderText="Fin" DataField="fin" SortExpression="fin" DataFormatString="{0:d}" />
        </Columns>
    </asp:GridView>
    <div style="text-align: right"><asp:Label runat="server" ID="LTotal"></asp:Label></div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id,nombre,inicio,fin FROM programacion_evento WHERE inicio<=STR_TO_DATE(@fecha, '%d/%m/%Y') AND fin>=STR_TO_DATE(@fecha, '%d/%m/%Y') ORDER BY inicio">
        <SelectParameters>
            <asp:ControlParameter ControlID="TFecha" Name="fecha" PropertyName="Text" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Panel>
</asp:Content>

