<%@ Page Title="Pacientes atendidos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="atendidos.aspx.cs" Inherits="evento_atendidos" %>
<%@ Register Src="~/evento/eventoselect.ascx" TagName="Evento" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="P" DefaultButton="BActualizar">
<table class="table table-condensed">
    <tr>
        <td class="px">Inicio</td>
        <td class="px">Final</td>
        <td class="px">Evento</td>
        <td class="px">Estado</td>
        <td class="px">Seguimiento</td>
        <td></td>
    </tr>
    <tr>
        <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox></td>
        <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox></td>
        <td><uc:Evento runat="server" ID="UCEvento" /></td>
        <td>
            <asp:DropDownList ID="DEstado" runat="server" CssClass="amc">
                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                <asp:ListItem Text="Remitidos" Value="1"></asp:ListItem>
                <asp:ListItem Text="Sin remitir" Value="2"></asp:ListItem>
            </asp:DropDownList>
        </td>
        <td>
            <asp:DropDownList ID="DSeguimiento" runat="server" CssClass="amc">
                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                <asp:ListItem Text="Sin seguimiento" Value="1"></asp:ListItem>
                <asp:ListItem Text="Con seguimiento" Value="2"></asp:ListItem>
                <asp:ListItem Text="Seguimiento sin completar" Value="3"></asp:ListItem>
                <asp:ListItem Text="Seguimiento completo" Value="4"></asp:ListItem>
            </asp:DropDownList>
        </td>
        <td><asp:Button runat="server" ID="BActualizar" Text="Actualizar" CssClass="btn btn-submit" OnClick="BActualizar_Click" /></td>
    </tr>
</table>
</asp:Panel>
<asp:GridView ID="GResultados" runat="server" AutoGenerateColumns="False" DataSourceID="SResultados" EmptyDataText="No se encontraron eventos" CssClass="table table-condensed table-bordered table-hover table-striped"
    PageSize="50" AllowPaging="true" AllowSorting="true">
    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
    <Columns>
        <asp:BoundField DataField="fecha" HeaderText="Fecha" SortExpression="fecha" DataFormatString="{0:d}" />
        <asp:HyperLinkField DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/evento/atendido.aspx?pid={0}" Target="_blank" DataTextField="nombres" HeaderText="Nombres" SortExpression="nombres" />
        <asp:HyperLinkField DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/evento/atendido.aspx?pid={0}" Target="_blank" DataTextField="apellidos" HeaderText="Apellidos" SortExpression="apellidos" />
        <asp:BoundField DataField="documento" HeaderText="Documento" SortExpression="documento" />
        <asp:BoundField DataField="edad" HeaderText="Edad" SortExpression="edad" ItemStyle-HorizontalAlign="Right" />
        <asp:BoundField DataField="evento" HeaderText="Evento" SortExpression="evento" />
        <asp:BoundField DataField="diagnostico" HeaderText="Diagnostico" SortExpression="diagnostico" />
        <asp:BoundField DataField="causa" HeaderText="Causa" SortExpression="causa" />
        <asp:BoundField DataField="ipsremision" HeaderText="IPS" SortExpression="ipsremision" />
        <asp:BoundField DataField="asegurador" HeaderText="Asegurador" SortExpression="asegurador" />
    </Columns>
</asp:GridView>
    <asp:Label runat="server" ID="LTotal" CssClass="pull-right"></asp:Label>
<asp:SqlDataSource ID="SResultados" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
    SelectCommand="SELECT 
        paciente.id,
        paciente.fecha,
        paciente.nombres,
        paciente.apellidos,
        paciente.edad,
        evento.nombre AS evento,
        paciente.diagnostico,
        paciente.causa,
        paciente.ipsremision,
        paciente.asegurador,
        paciente.documento
        FROM paciente
        LEFT JOIN evento ON (evento.id=paciente.evento)
        WHERE
        DATE(paciente.fecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
        AND (@evento=0 OR @evento=paciente.evento)
        AND (@estado=0 OR (@estado=1 AND paciente.ipsremision IS NOT NULL) OR (@estado=2 AND paciente.ipsremision IS NULL))
        AND (@seguimiento=0 
                OR (@seguimiento=1 AND paciente.atributos&1!=1)
                OR (@seguimiento=2 AND paciente.atributos&1=1)
                OR (@seguimiento=2 AND paciente.atributos&1=1 AND paciente.seguimiento IS NULL)
                OR (@seguimiento=2 AND paciente.atributos&1=1 AND paciente.seguimiento IS NOT NULL)
            )
        ORDER BY nombre
        ">
        <SelectParameters>
            <asp:ControlParameter ControlID="TInicio" PropertyName="Text" Name="inicio" />
            <asp:ControlParameter ControlID="TFin" PropertyName="Text" Name="fin" />
            <asp:ControlParameter ControlID="UCEvento" PropertyName="IdEvento" Name="evento" DefaultValue="0" />
            <asp:ControlParameter ControlID="DEstado" PropertyName="SelectedValue" Name="estado" />
            <asp:ControlParameter ControlID="DSeguimiento" PropertyName="SelectedValue" Name="seguimiento" />
        </SelectParameters>
</asp:SqlDataSource>
</asp:Content>