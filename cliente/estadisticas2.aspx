<%@ Page Title="Estadísticas quejas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="estadisticas2.aspx.cs" Inherits="cliente_estadisticas2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
        <script type="text/javascript">
          google.load("visualization", "1", {packages:["corechart"]});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Concepto');
            data.addColumn('number', 'Quejas');
            data.addRows([
                <asp:Literal runat="server" ID="LResultado"></asp:Literal>
            ]);

            var options = {
              width: 400, height: 300,
              title: 'Quejas'
            };

            var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
            chart.draw(data, options);
            
            
            var data2 = new google.visualization.DataTable();
            data2.addColumn('string', 'Concepto');
            data2.addColumn('number', 'Quejas');
            data2.addRows([
                <asp:Literal runat="server" ID="LResultado2"></asp:Literal>
            ]);

            var options2 = {
              width: 400, height: 300,
              title: 'Tiempos de solución'
            };

            var chart2 = new google.visualization.PieChart(document.getElementById('chart_div2'));
            chart2.draw(data2, options2);
          }
        </script>
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde</td>
            <td>Hasta</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" onclick="BBuscar_Click" /></td>
        </tr>
    </table>
    <div id="dImprimir">
        <table>
            <tr>
                <td><div id="chart_div"></div></td>
                <td><div id="chart_div2"></div></td>
            </tr>
            <tr>
                <td align="center"><asp:DetailsView ID="DResultados" runat="server" 
                        DataSourceID="SResultados" AutoGenerateRows="False">
            <Fields>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L1" runat="server" CommandName="quejas" OnClick="LEstadisticas_Click" Text="Quejas" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("quejas")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L2" runat="server" CommandName="cerradas" OnClick="LEstadisticas_Click" Text="Cerradas" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("cerradas")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L3" runat="server" CommandName="atendidas" OnClick="LEstadisticas_Click" Text="Atendidas" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("atendidas")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                    <HeaderTemplate>
                        <asp:LinkButton ID="L4" runat="server" CommandName="sintramitar" OnClick="LEstadisticas_Click" Text="Sin tramitar" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("sintramitar") %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Fields>
        </asp:DetailsView></td>
                <td align="center"><asp:DetailsView ID="DSolucion" runat="server" DataSourceID="SResultados" AutoGenerateRows="false">
            <Fields>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L1" runat="server" CommandName="dias3" OnClick="LEstadisticas_Click" Text="Resueltas en 3 días o menos" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("dias3")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L2" runat="server" CommandName="dias7" OnClick="LEstadisticas_Click" Text="Resueltas de 4 a 7 días" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("dias7")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L3" runat="server" CommandName="dias15" OnClick="LEstadisticas_Click" Text="Resueltas de 8 a 15 días" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("dias15")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L4" runat="server" CommandName="muchosdias" OnClick="LEstadisticas_Click" Text="Resueltas en 16 o más" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("muchosdias")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L5" runat="server" CommandName="sincerrar" OnClick="LEstadisticas_Click" Text="Sin cerrar" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("sincerrar")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
            </Fields>
        </asp:DetailsView></td>
            </tr>
        </table>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ConnBD %>" 
                SelectCommand="SELECT 
                            (SELECT COUNT(*) FROM serQuejasReclamos WHERE qrFecha BETWEEN @desde AND @hasta) AS quejas
                            ,(SELECT COUNT(*) FROM serQuejasReclamos WHERE qrFecha BETWEEN @desde AND @hasta AND qrCerrado=1) AS cerradas
                            ,(SELECT COUNT(*) FROM serQuejasReclamos WHERE qrFecha BETWEEN @desde AND @hasta AND qrAtendido=1 AND qrCerrado=0) AS atendidas
                            ,(SELECT COUNT(*) FROM serQuejasReclamos WHERE qrFecha BETWEEN @desde AND @hasta AND qrAtendido=0 AND qrCerrado=0) AS sintramitar
                            ,(SELECT COUNT(*) FROM serQuejasReclamos LEFT JOIN serSeguimiento ON (serSeguimiento.qrId=serQuejasReclamos.qrId) WHERE qrFecha BETWEEN @desde AND @hasta AND qrCerrado=1 AND serSeguimiento.sqrCerrar=1 AND DATEDIFF(day,serSeguimiento.segFechaIngreso,qrFecha)<4) AS dias3
                            ,(SELECT COUNT(*) FROM serQuejasReclamos LEFT JOIN serSeguimiento ON (serSeguimiento.qrId=serQuejasReclamos.qrId) WHERE qrFecha BETWEEN @desde AND @hasta AND qrCerrado=1 AND serSeguimiento.sqrCerrar=1 AND DATEDIFF(day,serSeguimiento.segFechaIngreso,qrFecha)<8) AS dias7
                            ,(SELECT COUNT(*) FROM serQuejasReclamos LEFT JOIN serSeguimiento ON (serSeguimiento.qrId=serQuejasReclamos.qrId) WHERE qrFecha BETWEEN @desde AND @hasta AND qrCerrado=1 AND serSeguimiento.sqrCerrar=1 AND DATEDIFF(day,serSeguimiento.segFechaIngreso,qrFecha)<16) AS dias15
                            ,(SELECT COUNT(*) FROM serQuejasReclamos LEFT JOIN serSeguimiento ON (serSeguimiento.qrId=serQuejasReclamos.qrId) WHERE qrFecha BETWEEN @desde AND @hasta AND qrCerrado=1 AND serSeguimiento.sqrCerrar=1 AND DATEDIFF(day,serSeguimiento.segFechaIngreso,qrFecha)>15) AS muchosdias
                            ,(SELECT COUNT(*) FROM serQuejasReclamos WHERE qrFecha BETWEEN @desde AND @hasta AND qrCerrado=0) AS sincerrar">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                 </SelectParameters>
    </asp:SqlDataSource>    
        <asp:Panel runat="server" ID="PDetalle" Visible="false">
            <table width="100%">
            <tr>
            <td class="Titulo"><asp:Label runat="server" ID="LDetalle"></asp:Label></td>
            </tr>
            <tr>
            <td>
            <asp:GridView ID="GDetalle" runat="server" DataSourceID="SDetalle" 
                AutoGenerateColumns="False" EmptyDataText="No se encontraron quejas" 
                AllowPaging="True" PageSize="50" AllowSorting="True">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:TemplateField HeaderText="Paciente" SortExpression="paciente">
                        <ItemTemplate>
                            <asp:LinkButton ID="LPaciente" runat="server" CausesValidation="False" PostBackUrl='<%# Eval("qrId", "~/cliente/quejas.aspx?qid={0}") %>' Text='<%# Eval("pacNombres") %>'></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Fecha" SortExpression="qrFecha" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" DataField="qrFecha" />
                    <asp:BoundField HeaderText="Detalle" SortExpression="qrDetalle" DataField="qrDetalle" />
                    <asp:BoundField HeaderText="Observaciones" SortExpression="qrObsHS" DataField="qrObsHS" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SDetalle" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ConnBD %>" 
                        SelectCommand="">
            </asp:SqlDataSource>
            </td>
            </tr>
            </table>
        </asp:Panel>
    </asp:Panel>
</asp:Content>

