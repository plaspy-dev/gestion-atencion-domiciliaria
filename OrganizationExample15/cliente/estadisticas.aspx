<%@ Page Title="Estadísticas encuestas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="estadisticas.aspx.cs" Inherits="cliente_estadisticas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
        <script type="text/javascript">
          google.load("visualization", "1", {packages:["corechart"]});
          google.setOnLoadCallback(drawChart);
          
          function drawChart() {
            
            drawPieChart('chart_div', [<asp:Literal runat="server" ID="LResultado"></asp:Literal>], {
              width: 450, height: 300,
              title: 'Estadisticas'
            });
            
                var options =  {
                  width: 600, height: 400,
                  title: 'Encuestas'
                };

              var chart = new google.visualization.ColumnChart(document.getElementById('chart_div2'));

              chart.draw(google.visualization.arrayToDataTable([['Encuestas','Numero']
            <asp:Repeater runat="server" DataSourceID="SConceptos" ID="RConceptos">
                <ItemTemplate>,['<%# Eval("concepto") %>',<%# Convert.ToDouble(Eval("cal")).ToString(System.Globalization.CultureInfo.InvariantCulture) %>]</ItemTemplate>
            </asp:Repeater>
                ]), options);
          }
        </script>
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde</td>
            <td>Hasta</td>
            <td></td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
            <td><asp:Label ID="LTotal" runat="server" Text=""></asp:Label></td>
        </tr>
    </table>
    <div id="dImprimir">
    <table>
        <tr>
            <td><div id="chart_div"></div></td>
            <td><div id="chart_div2"></div></td>
        </tr>
        <tr>
            <td valign="top"><asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" AutoGenerateColumns="False" AllowPaging="True" PageSize="50" AllowSorting="True" DataKeyNames="cal" onselectedindexchanged="GResultados_SelectedIndexChanged" Width="100%" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Concepto" SortExpression="cal" ItemStyle-Wrap="false" ItemStyle-Width="100%">
                            <ItemTemplate>
                                <asp:LinkButton ID="LC" runat="server" CausesValidation="False" CommandName="Select" Text='<%# Eval("concepto") %>'></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Encuestas" SortExpression="numero" DataField="numero" ItemStyle-HorizontalAlign="Right" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SResultados" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT COUNT(*) numero
                                ,FLOOR(calificacion) AS cal
                                ,CASE 
                                WHEN FLOOR(calificacion)=0 THEN 'Muy insatisfecho' 
                                WHEN FLOOR(calificacion)=1 THEN 'Insatisfecho' 
                                WHEN FLOOR(calificacion)=2 THEN 'Conforme' 
                                WHEN FLOOR(calificacion)=3 THEN 'Satisfecho' 
                                WHEN FLOOR(calificacion)>=4 THEN 'Muy satisfecho' 
                                ELSE '' END AS concepto
                                FROM escliente 
                                WHERE 
                                (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=fecha)
                                AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=fecha)
                                GROUP BY concepto
                                ORDER BY cal;
                                ">
                             <SelectParameters>
                                <asp:ControlParameter ControlID="TDesde" Name="desde" DefaultValue=" " PropertyName="Text" />
                                <asp:ControlParameter ControlID="THasta" Name="hasta" DefaultValue=" " PropertyName="Text" />
                             </SelectParameters>
                </asp:SqlDataSource>
                </td>
            <td valign="top">
                <asp:GridView ID="GConceptos" runat="server" DataSourceID="SConceptos" AutoGenerateColumns="False" AllowPaging="True" PageSize="50" AllowSorting="True" Width="100%" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField HeaderText="Concepto" SortExpression="concepto" DataField="concepto" ItemStyle-Width="100%" />
                        <asp:BoundField HeaderText="Promedio" SortExpression="cal" DataField="cal" DataFormatString="{0:g}" ItemStyle-HorizontalAlign="Right" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SConceptos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.nombre AS concepto,AVG(escliente_calificacion.calificacion) AS cal 
                                FROM escliente
                                LEFT JOIN escliente_calificacion ON (escliente_calificacion.encuesta=escliente.id)
                                LEFT JOIN varios ON (varios.id=escliente_calificacion.concepto)
                                WHERE 
                                (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=escliente.fecha)
                                AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=escliente.fecha)
                                GROUP BY concepto ORDER BY cal DESC;
                                ">
                             <SelectParameters>
                                <asp:ControlParameter ControlID="TDesde" Name="desde" DefaultValue=" " PropertyName="Text" />
                                <asp:ControlParameter ControlID="THasta" Name="hasta" DefaultValue=" " PropertyName="Text" />
                             </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
    </table>
    </div>
    <asp:Panel runat="server" ID="PDetalle" Visible="false">
        <table width="100%">
        <tr>
        <td class="Titulo"><asp:Label runat="server" ID="LCalificacion"></asp:Label></td>
        </tr>
        <tr>
        <td>
        <asp:GridView ID="GDetalle" runat="server" DataSourceID="SDetalle" 
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                onrowdatabound="GDetalle_RowDataBound" Width="100%">
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Columns>
                <asp:TemplateField HeaderText="Paciente" SortExpression="paciente" ItemStyle-Width="100%">
                    <ItemTemplate>
                        <asp:LinkButton ID="LPaciente" runat="server" CausesValidation="False" PostBackUrl='<%# Eval("id", "~/cliente/escliente.aspx?eid={0}") %>' Text='<%# Eval("paciente") %>'></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField HeaderText="Fecha" SortExpression="fecha" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" DataField="fecha" />
                <asp:BoundField HeaderText="Calificación" SortExpression="calificacion" DataField="calificacion" DataFormatString="{0:g}" ItemStyle-HorizontalAlign="Right" />
            </Columns>
        </asp:GridView>
        <div style="text-align: right;">
            <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
        </div>
        <asp:SqlDataSource ID="SDetalle" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id,paciente,fecha,calificacion
                        FROM escliente 
                        WHERE 
                        (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=fecha)
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=fecha)
                        AND @calificacion=FLOOR(calificacion)
                        ORDER BY fecha;
                        ">
                     <SelectParameters>
                        <asp:ControlParameter ControlID="TDesde" Name="desde" DefaultValue=" " PropertyName="Text" />
                        <asp:ControlParameter ControlID="THasta" Name="hasta" DefaultValue=" " PropertyName="Text" />
                        <asp:ControlParameter ControlID="GResultados" Name="calificacion" PropertyName="SelectedValue" />
                     </SelectParameters>
        </asp:SqlDataSource>
        </td>
        </tr>
        </table>
    </asp:Panel>
</asp:Panel>
</asp:Content>