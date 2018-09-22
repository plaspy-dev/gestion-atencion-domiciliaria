<%@ Page Title="Documentos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="rh_documentos" Codebehind="documentos.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Estado</td>
            <td>
                <asp:DropDownList ID="DEStado" runat="server" AppendDataBoundItems="true" CssClass="anchomaxcombo"
                    DataSourceID="SEstado" DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstado" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT eEstId AS id,eEstDesc AS nombre FROM funcionario_estados">
                </asp:SqlDataSource>
            </td>
            <td>
                Nombres</td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
            </td>
            <td>
                Cargo</td>
            <td>
                <asp:DropDownList ID="DCargo" runat="server" AppendDataBoundItems="true"  CssClass="anchomaxcombo"
                    DataSourceID="SCargo" DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SCargo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT carId AS id,carDescripcion AS nombre FROM cargo ORDER BY nombre">
                </asp:SqlDataSource>
            </td>
            <td class="nw">Estado documento</td>
            <td>
                <asp:DropDownList runat="server" ID="DDocumento" CssClass="amc">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Sin vencer" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Vencidos" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td style="text-align: right">
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Width="100%"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron recursos humanos" 
        AllowPaging="True" PageSize="50" AllowSorting="True" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="documento" HeaderText="Documento" 
                DataNavigateUrlFields="id" SortExpression="documento"
                DataNavigateUrlFormatString="~/rh/Default.aspx?fid={0}" >
            <ItemStyle HorizontalAlign="Right" />
            </asp:HyperLinkField>
           <asp:HyperLinkField DataTextField="nombres" HeaderText="Nombres" 
                DataNavigateUrlFields="id" 
                DataNavigateUrlFormatString="~/rh/Default.aspx?fid={0}" SortExpression="nombres" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Cargo" DataField="cargo" SortExpression="cargo" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Estado" DataField="estado" SortExpression="estado"/>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT 
        recurso_humano.perId AS id,recurso_humano.perDocumento AS documento, recurso_humano.perNombre AS nombres,
        cargo.carDescripcion AS cargo,funcionario_estados.eEstDesc AS estado
        FROM recurso_humano 
        LEFT JOIN cargo on recurso_humano.carId = cargo.carId
        LEFT JOIN funcionario_estados ON (funcionario_estados.eEstId=recurso_humano.eEstId) 
        WHERE (@estado=0 OR recurso_humano.eEstId=@estado)  AND (@cargo=0 or recurso_humano.carId=@cargo OR FIND_IN_SET(@cargo, recurso_humano.cargos)!=0)
        AND (@nombres=' ' OR recurso_humano.perNombre LIKE CONCAT('%', @nombres, '%'))
        AND (@documento=0 
            OR (@documento=1 AND recurso_humano.perId IN (SELECT recurso_humano_documento.perId from recurso_humano_documento where recurso_humano_documento.vencimiento>NOW()))
            OR (@documento=2 AND recurso_humano.perId IN (SELECT recurso_humano_documento.perId from recurso_humano_documento where recurso_humano_documento.vencimiento<NOW()))
        )
        ORDER BY recurso_humano.perNombres DESC">
            <SelectParameters>
            <asp:ControlParameter ControlID="DEStado" PropertyName="SelectedValue" Name="estado" />
            <asp:ControlParameter ControlID="DCargo" PropertyName="SelectedValue" Name="cargo" />
            <asp:ControlParameter ControlID="TNombres" Name="nombres" PropertyName="Text" DefaultValue=" " />
            <asp:ControlParameter ControlID="DDocumento" Name="documento" PropertyName="SelectedValue" />
            </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

