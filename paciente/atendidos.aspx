<%@ Page Title="Pacientes atendidos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="atendidos.aspx.cs" Inherits="paciente_atendidos" %>

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
            <td>
                <asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
            <td>
                <asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="THasta" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td>
                <asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM dbo.admEntidad WHERE entEPS=1 ORDER BY 2">
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
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SResultados" onrowdatabound="GResultados_RowDataBound" >
            <Columns>
                <asp:BoundField DataField="fecha" SortExpression="fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                <asp:BoundField DataField="paciente"  HeaderText="Paciente" />
                <asp:BoundField DataField="paciente"  HeaderText="Documento" />
                <asp:BoundField DataField="paciente"  HeaderText="Sexo" />
                <asp:BoundField DataField="paciente"  HeaderText="Edad" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="paciente"  HeaderText="Dirección" />
                <asp:BoundField DataField="paciente"  HeaderText="Barrio" />
                <asp:BoundField DataField="paciente"  HeaderText="Teléfonos" />
                <asp:BoundField DataField="barthel" SortExpression="barthel" HeaderText="Índice de Barthel" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="paciente"  HeaderText="Diagnostico 1" />
                <asp:BoundField DataField="paciente"  HeaderText="Diagnostico 2" />
                <asp:BoundField DataField="paciente"  HeaderText="Diagnostico 3" />
                <asp:BoundField DataField="analisis" SortExpression="analisis" HeaderText="Análisis clínico" />
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
            SelectCommand="(SELECT 
                                ingreso_paciente.fecha
                                ,ingreso_paciente.analisis
                                ,SUM(varios.descripcion) AS barthel
                                ,ingreso_paciente.paciente
                                FROM ingreso_paciente 
                                LEFT JOIN indice_barthel ON (indice_barthel.paciente=ingreso_paciente.paciente)
                                LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id)
                                LEFT JOIN varios ON (varios.id=analisis_barthel.resultado)
                                WHERE 
                                ingreso_paciente.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                                AND (@asegurador=0 OR @asegurador=ingreso_paciente.asegurador)
                                GROUP BY ingreso_paciente.id
                            ) UNION (
                            SELECT 
                                evolucion_paciente.fecha
                                ,evolucion_paciente.analisis
                                ,SUM(varios.descripcion) AS barthel
                                ,evolucion_paciente.paciente
                                FROM evolucion_paciente 
                                LEFT JOIN indice_barthel ON (indice_barthel.paciente=evolucion_paciente.paciente)
                                LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id)
                                LEFT JOIN varios ON (varios.id=analisis_barthel.resultado)
                                WHERE 
                                evolucion_paciente.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                                AND (@asegurador=0 OR @asegurador=evolucion_paciente.asegurador)
                                GROUP BY evolucion_paciente.id
                            ) ORDER BY fecha;
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

