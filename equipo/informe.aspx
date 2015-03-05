<%@ Page Title="Inventario mantenimiento" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informe.aspx.cs" Inherits="equipo_informe" %>
<%@ Register src="~/equipo/prestamo.ascx" tagname="prestamo" tagprefix="uc1" %>
<%@ Register src="~/equipo/devolucion.ascx" tagname="devolucion" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Estado</td>
            <td><asp:DropDownList runat="server" ID="DEstado">
                <asp:ListItem Text="Disponible" Value="1"></asp:ListItem>
                <asp:ListItem Text="Todos" Value="-1"></asp:ListItem>
                <asp:ListItem Text="Asignado" Value="2"></asp:ListItem>
                <asp:ListItem Text="Liquidado" Value="0"></asp:ListItem>
            </asp:DropDownList></td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Actualizar" onclick="BBuscar_Click" /></td>
        </tr>
    </table>
</asp:Panel>
<asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" DataKeyNames="id" AutoGenerateColumns="False" 
    onrowdatabound="GResultados_RowDataBound"
    EmptyDataText="No se encontraron equipos" AllowPaging="True" PageSize="50" AllowSorting="True" >
    <Columns>
        <asp:HyperLinkField HeaderText="Nombre" SortExpression="nombre" DataTextField="nombre" DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/equipo/equipo.aspx?eid={0}" />
        <asp:HyperLinkField HeaderText="Código" SortExpression="codigo" DataTextField="codigo" DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/equipo/equipo.aspx?eid={0}" />
        <asp:BoundField HeaderText="Marca" DataField="marca" SortExpression="marca" />
        <asp:BoundField HeaderText="Modelo" DataField="modelo" SortExpression="modelo" />
        <asp:BoundField HeaderText="Placa" DataField="placa" SortExpression="placa" />
        <asp:BoundField HeaderText="Serial" DataField="serial" SortExpression="serial" />
        <asp:BoundField HeaderText="Último mantenimiento" DataField="ultimo_mantenimiento" SortExpression="ultimo_mantenimiento" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
        <asp:BoundField HeaderText="Próximo mantenimiento" DataField="proximo_mantenimiento" SortExpression="proximo_mantenimiento" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
        <asp:TemplateField HeaderText="Paciente" SortExpression="paciente">
            <ItemTemplate>
                <asp:LinkButton ID="LP" OnClick="LAccion_Clicked" runat="server" Text='<%# Eval("paciente") %>' CommandName='<%# Eval("id") %>' CommandArgument='<%# Eval("prestamo") %>'></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField HeaderText="Funcionario" DataField="funcionario" SortExpression="funcionario" />
        <asp:BoundField HeaderText="Desde" DataField="fecha" SortExpression="fecha" DataFormatString="{0:d}" />
        <asp:BoundField HeaderText="Hasta" DataField="estimado" SortExpression="estimado" DataFormatString="{0:d}" />
        <asp:BoundField HeaderText="Observaciones" DataField="observaciones" SortExpression="observaciones" />
        <asp:BoundField HeaderText="Estado" DataField="estado" SortExpression="estado" />
        <asp:TemplateField HeaderText="Acción">
            <ItemTemplate>
                <asp:LinkButton OnClick="LAccion_Clicked" Visible='<%# Eval("estado").ToString()!="Liquidado" %>' runat="server" Text='<%# Eval("estado").ToString()=="Asignado" ? "Devolver" : "Asignar" %>' CommandName='<%# Eval("id") %>' CommandArgument='<%# Eval("prestamo") %>'></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <RowStyle CssClass="GridRow"></RowStyle>
    <FooterStyle CssClass="GridFooter"></FooterStyle>
    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
</asp:GridView>
<div style="text-align: right;">
    <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
</div>
<uc1:prestamo ID="UCPrestamo" runat="server" OnBAceptarClicked="BAgregarPrestamo_Click" />
<uc1:devolucion ID="UCDevolucion" runat="server" OnBAceptarClicked="BAceptarDevolucion_Click" />
<asp:SqlDataSource ID="SResultados" runat="server" 
    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
    SelectCommand="SELECT 
            equipo.id,equipo.nombre,equipo.serial,equipo.placa,equipo.marca,equipo.modelo,equipo.ultimo_mantenimiento,equipo.proximo_mantenimiento,equipo.observaciones
            ,CASE equipo.estado WHEN 1 THEN 'Disponible' WHEN 0 THEN 'Liquidado' WHEN 2 THEN 'Asignado' ELSE '' END AS estado
            ,equipo_prestamo.paciente,equipo_prestamo.fecha,equipo_prestamo.estimado,equipo_prestamo.id AS prestamo
            ,equipo_prestamo.funcionario,equipo.codigo
            FROM equipo
            LEFT JOIN equipo_prestamo ON (equipo_prestamo.equipo=equipo.id AND equipo_prestamo.devolucion IS NULL)
            WHERE 
            (@estado=-1 OR equipo.estado=@estado)
            ;">
     <SelectParameters>
        <asp:ControlParameter ControlID="DEstado" Name="estado" PropertyName="SelectedValue" />
     </SelectParameters>
</asp:SqlDataSource>
</asp:Content>