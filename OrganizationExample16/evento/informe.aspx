<%@ Page Title="Eventos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informe.aspx.cs" Inherits="evento_informe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="P" DefaultButton="BActualizar">
<table class="table table-condensed">
    <tr>
        <td class="px">Inicio</td>
        <td class="px">Final</td>
        <td class="px">Tipo</td>
        <td class="px">Complejidad</td>
        <td></td>
    </tr>
    <tr>
        <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox></td>
        <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox></td>
        <td><asp:DropDownList ID="DTipo" runat="server" DataSourceID="STipo" CssClass="amd"
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="STipo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=9 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        <td><asp:DropDownList ID="DComplejidad" runat="server" DataSourceID="SComplejidad" CssClass="amd"
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SComplejidad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=10 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        <td><asp:Button runat="server" ID="BActualizar" Text="Actualizar" CssClass="btn btn-submit" OnClick="BActualizar_Click" /></td>
    </tr>
</table>
</asp:Panel>
<asp:GridView ID="GResultados" runat="server" AutoGenerateColumns="False" DataSourceID="SResultados" EmptyDataText="No se encontraron eventos" CssClass="table table-condensed table-bordered table-hover table-striped"
    PageSize="50" AllowPaging="true" AllowSorting="true">
    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
    <Columns>
        <asp:HyperLinkField DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/evento/evento.aspx?eid={0}" Target="_blank" DataTextField="nombre" HeaderText="Evento" SortExpression="nombre" />
        <asp:BoundField DataField="inicio" HeaderText="Inicio" SortExpression="inicio" DataFormatString="{0:d}" />
        <asp:BoundField DataField="fin" HeaderText="Final" SortExpression="fin" DataFormatString="{0:d}" />
        <asp:BoundField DataField="Tipo" HeaderText="tipo" SortExpression="tipo" />
        <asp:BoundField DataField="Complejidad" HeaderText="complejidad" SortExpression="complejidad" />
    </Columns>
</asp:GridView>
    <asp:Label runat="server" ID="LTotal" CssClass="pull-right"></asp:Label>
<asp:SqlDataSource ID="SResultados" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
    SelectCommand="SELECT 
        evento.id,
        evento.nombre,evento.inicio,evento.fin
        ,tipo.nombre AS tipo
        ,complejidad.nombre AS complejidad
        FROM evento
        LEFT JOIN varios AS tipo ON (tipo.id=evento.tipo)
        LEFT JOIN varios AS complejidad ON (complejidad.id=evento.complejidad)
        WHERE
        STR_TO_DATE(@inicio, '%d/%m/%Y')<=DATE(evento.inicio) 
        AND STR_TO_DATE(@fin, '%d/%m/%Y')>=DATE(evento.fin)
        AND (@tipo=0 OR @tipo=evento.tipo)
        AND (@complejidad=0 OR @complejidad=evento.complejidad)
        ORDER BY nombre
        ">
        <SelectParameters>
            <asp:ControlParameter ControlID="TInicio" PropertyName="Text" Name="inicio" />
            <asp:ControlParameter ControlID="TFin" PropertyName="Text" Name="fin" />
            <asp:ControlParameter ControlID="DTipo" PropertyName="SelectedValue" Name="tipo" />
            <asp:ControlParameter ControlID="DComplejidad" PropertyName="SelectedValue" Name="complejidad" />
        </SelectParameters>
</asp:SqlDataSource>
</asp:Content>