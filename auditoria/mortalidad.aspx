<%@ Page Title="Mortalidad" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="mortalidad.aspx.cs" Inherits="auditoria_mortalidad" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde</td>
            <td>Hasta</td>
            <td>Entidad</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox></td>
            <td>
                <asp:DropDownList ID="DAsegurador" runat="server" DataSourceID="SAsegurador" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" 
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" Visible="false"
                DataSourceID="SResultados">
            <Columns>
                <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Paciente" DataNavigateUrlFields="pacId" DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" SortExpression="pacDocumento" >
                    <ItemStyle Wrap="False" HorizontalAlign="Right" />
                </asp:HyperLinkField>
                <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" DataNavigateUrlFields="pacId" DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" SortExpression="pacNombres" >
                    <ItemStyle Wrap="False" />
                </asp:HyperLinkField>
                <asp:BoundField DataField="egrFecha" SortExpression="egrFecha" HeaderText="Defunción" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="segFechaIngreso" SortExpression="segFechaIngreso" HeaderText="Registro sistema" ItemStyle-Wrap="false" />
                <asp:BoundField DataField="entNombre" SortExpression="entNombre" HeaderText="Asegurador" ItemStyle-Wrap="false" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT paciente.pacDocumento, paciente.pacNombres, paciente.pacId
                            ,paciente_egreso.egrFecha,MAX(paciente_egreso.segFechaIngreso) AS segFechaIngreso
                            ,asegurador.entNombre
                            FROM paciente_egreso
                            LEFT JOIN paciente ON (paciente.pacId=paciente_egreso.pacId)
                            LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            WHERE paciente_egreso.cegId=1
                            AND DATE(paciente_egreso.egrFecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                            AND (@entidad=0 OR @entidad=paciente.entId)
                            GROUP BY paciente.pacId,pacDocumento,pacNombres,entNombre,egrFecha
                            ORDER BY paciente_egreso.egrFecha">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" Name="entidad" PropertyName="SelectedValue" />
                 </SelectParameters>
    </asp:SqlDataSource>        
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

