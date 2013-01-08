<%@ Page Title="Estadísticas PQR" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="estadisticas2.aspx.cs" Inherits="cliente_estadisticas2" %>

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
            
            
            // el tercero
            drawPieChart('chart_div3', [['Entidad','PQR']
                <asp:Repeater runat="server" ID="REntidades" DataSourceID="SEntidades">
                    <ItemTemplate>,['<%# Eval("entidad") %>',<%# Eval("numero") %>]</ItemTemplate>
                </asp:Repeater>
                ], {
              width: 400, height: 300,
              title: 'PQR por Entidad'
            });
          }
        </script>
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde</td>
            <td>Hasta</td>
            <td>Tipo</td>
            <td>Clasificación</td>
            <td>Cliente</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td><asp:DropDownList ID="DTipo" runat="server" 
                                DataSourceID="STipo" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="STipo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT tqrIdTipo id,tqrDescripcion nombre FROM serTipoFormulario ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td><asp:DropDownList ID="DClasificacion" runat="server" 
                                DataSourceID="SClasificacion" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SClasificacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=26 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td>
                <asp:DropDownList runat="server" ID="DCliente">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Externo" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Interno" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </td>
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
                        <asp:LinkButton ID="L1" runat="server" CommandName="quejas" OnClick="LEstadisticas_Click" Text="PQR" ></asp:LinkButton>
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
                        <asp:LinkButton ID="L1" runat="server" CommandName="dias3" OnClick="LEstadisticas_Click" Text="Respuesta oportuna (Entre 72 horas)" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("dias3")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L2" runat="server" CommandName="masdias" OnClick="LEstadisticas_Click" Text="Respuesta inoportuna (Mayor a 72 horas)" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("masdias")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
            </Fields>
        </asp:DetailsView></td>
            </tr>
            <tr>
                <td><div id="chart_div3"></div></td>
                <td align="center">
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="center">
                <asp:GridView ID="G" runat="server" AutoGenerateColumns="False" DataSourceID="SEntidades" EmptyDataText="No se encontraron PQR" ShowHeader="false">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField DataField="entidad" HeaderText="Entidad" SortExpression="entidad" ItemStyle-HorizontalAlign="Left"  />
                        <asp:BoundField DataField="numero" HeaderText="PQR" SortExpression="numero" />
                    </Columns>
                </asp:GridView>
                </td>
                <td align="center">
                    &nbsp;</td>
            </tr>
        </table>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ConnBD %>" 
                SelectCommand="SELECT 
                            (SELECT COUNT(*) FROM serQuejasReclamos WHERE qrFecha BETWEEN @desde AND @hasta AND (@tipo=0  OR @tipo=tqrIdTipo) AND (@clasificacion=0 OR @clasificacion=clasificacion) AND (@cliente=0 OR @cliente=qrTipoCliente)) AS quejas
                            ,(SELECT COUNT(*) FROM serQuejasReclamos WHERE qrFecha BETWEEN @desde AND @hasta AND qrCerrado=1 AND (@tipo=0  OR @tipo=tqrIdTipo) AND (@clasificacion=0 OR @clasificacion=clasificacion) AND (@cliente=0 OR @cliente=qrTipoCliente)) AS cerradas
                            ,(SELECT COUNT(*) FROM serQuejasReclamos WHERE qrFecha BETWEEN @desde AND @hasta AND qrAtendido=1 AND qrCerrado=0 AND (@tipo=0  OR @tipo=tqrIdTipo) AND (@clasificacion=0 OR @clasificacion=clasificacion) AND (@cliente=0 OR @cliente=qrTipoCliente)) AS atendidas
                            ,(SELECT COUNT(*) FROM serQuejasReclamos WHERE qrFecha BETWEEN @desde AND @hasta AND qrAtendido=0 AND qrCerrado=0 AND (@tipo=0  OR @tipo=tqrIdTipo) AND (@clasificacion=0 OR @clasificacion=clasificacion) AND (@cliente=0 OR @cliente=qrTipoCliente)) AS sintramitar
                            ,(SELECT COUNT(*) FROM serQuejasReclamos LEFT JOIN serSeguimiento ON (serSeguimiento.qrId=serQuejasReclamos.qrId) WHERE qrFecha BETWEEN @desde AND @hasta AND qrCerrado=1 AND serSeguimiento.sqrCerrar=1 AND DATEDIFF(day,serSeguimiento.segFechaIngreso,qrFecha)<4 AND (@tipo=0  OR @tipo=tqrIdTipo) AND (@clasificacion=0 OR @clasificacion=clasificacion) AND (@cliente=0 OR @cliente=qrTipoCliente)) AS dias3
                            ,(SELECT COUNT(*) FROM serQuejasReclamos LEFT JOIN serSeguimiento ON (serSeguimiento.qrId=serQuejasReclamos.qrId) WHERE qrFecha BETWEEN @desde AND @hasta AND qrCerrado=1 AND serSeguimiento.sqrCerrar=1 AND DATEDIFF(day,serSeguimiento.segFechaIngreso,qrFecha)>3 AND (@tipo=0  OR @tipo=tqrIdTipo) AND (@clasificacion=0 OR @clasificacion=clasificacion) AND (@cliente=0 OR @cliente=qrTipoCliente)) AS masdias
                            ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DTipo" Name="tipo" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="DClasificacion" Name="clasificacion" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="DCliente" Name="cliente" PropertyName="SelectedValue" />
                 </SelectParameters>
    </asp:SqlDataSource>    
    <asp:SqlDataSource ID="SEntidades" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ConnBD %>" 
                SelectCommand="SELECT admEntidad.entNombre AS entidad,COUNT(*) AS numero FROM serQuejasReclamos 
                            LEFT JOIN admEntidad ON (admEntidad.entId=serQuejasReclamos.entId) 
                            WHERE qrFecha BETWEEN @desde AND @hasta
                            AND (@tipo=0  OR @tipo=tqrIdTipo) AND (@clasificacion=0 OR @clasificacion=clasificacion) AND (@cliente=0 OR @cliente=qrTipoCliente)
                            GROUP BY entNombre ORDER BY numero DESC;">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DTipo" Name="tipo" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="DClasificacion" Name="clasificacion" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="DCliente" Name="cliente" PropertyName="SelectedValue" />
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

