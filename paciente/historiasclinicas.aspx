<%@ Page Title="Historias clínicas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="historiasclinicas.aspx.cs" Inherits="paciente_historiasclinicas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
.visitado a:visited 
{
    color: Purple;
}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde
                <asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Hasta
                <asp:RequiredFieldValidator ControlToValidate="THasta" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Entidad</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox>
                </td>
            <td>
                <asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox>
            </td>
            <td>
                <asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
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
            <td>
                <asp:Button ID="BDescargar" runat="server" Text="Descargar" 
                    onclick="BDescargar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" Visible="false" AllowPaging="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowSorting="True" DataSourceID="SResultados" onrowdatabound="GResultados_RowDataBound" >
            <Columns>
                <asp:HyperLinkField DataTextField="fecha" ItemStyle-CssClass="visitado" DataTextFormatString="{0:d}" HeaderText="Fecha" SortExpression="fecha" DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/paciente/evolucion.aspx?aid={0}&pdf=1&npdf=1" />
                <asp:BoundField DataField="paciente"  HeaderText="Documento" ItemStyle-Wrap="false" />
                <asp:BoundField DataField="paciente"  HeaderText="Paciente" ItemStyle-Wrap="false" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
        <asp:SqlDataSource ID="SResultados" runat="server" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            SelectCommand="SELECT 
                        t.paciente
                        ,IFNULL(MAX(evolucion_paciente.id),CONCAT('i',MAX(ingreso_paciente.id))) AS id
                        ,IF(evolucion_paciente.id IS NULL,ingreso_paciente.fecha,evolucion_paciente.fecha) AS fecha
                         FROM ((
                            SELECT paciente FROM evolucion_paciente 
                            WHERE 
                            DATE(evolucion_paciente.fecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                            AND (@asegurador=0 OR @asegurador=evolucion_paciente.asegurador)
                            GROUP BY paciente
                        ) UNION (
                            SELECT paciente FROM ingreso_paciente 
                            WHERE 
                            DATE(ingreso_paciente.fecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                            AND (@asegurador=0 OR @asegurador=ingreso_paciente.asegurador)
                            GROUP BY paciente
                        )) AS t
                        LEFT JOIN evolucion_paciente ON (evolucion_paciente.paciente=t.paciente)
                        LEFT JOIN ingreso_paciente ON (ingreso_paciente.paciente=t.paciente)
                        WHERE 
                        DATE(evolucion_paciente.fecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                        AND (evolucion_paciente.id IS NOT NULL OR DATE(ingreso_paciente.fecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y'))
                        AND (@asegurador=0 OR @asegurador=evolucion_paciente.asegurador)
                        GROUP BY t.paciente
                        ORDER BY IF(evolucion_paciente.id IS NULL,ingreso_paciente.fecha,evolucion_paciente.fecha)
                        ">
            <SelectParameters>
                <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                <asp:ControlParameter ControlID="DAsegurador" Name="asegurador" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

