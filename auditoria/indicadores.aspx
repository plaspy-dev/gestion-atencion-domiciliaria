<%@ Page Title="Indicadores" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="indicadores.aspx.cs" Inherits="auditoria_indicadores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<script type="text/javascript">
    google.load("visualization", "1", {packages:["corechart"]});
    google.setOnLoadCallback(drawChart);
    function drawChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Tipo');
        data.addColumn('number', 'Servicios programados');
        data.addColumn('number', 'Pacientes atendidos');
        data.addColumn('number', 'Servicios descubiertos');
        data.addRows([
            <asp:Literal runat="server" ID="LChart"></asp:Literal>
        ]);

        var options = {
            width: 600, height: 400,
            title: 'Pacientes'
        };

        var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
        chart.draw(data, options);
        
        
        var data2 = new google.visualization.DataTable();
        data2.addColumn('string', 'Eventos');
        data2.addColumn('number', 'Eventos adversos');
        data2.addColumn('number', 'Farmacológico');
        data2.addColumn('number', 'Epidemiológicos');
        data2.addColumn('number', 'Apoyo terapéutico');
        data2.addColumn('number', 'Lesiones apoyo');
        data2.addColumn('number', 'Autolesión');
        data2.addColumn('number', 'Complicaciones en la atención');

        data2.addRows([
            <asp:Literal runat="server" ID="LChart2"></asp:Literal>
        ]);

        var options2 = {
            width: 600, height: 400,
            title: 'Eventos adversos'
        };

        var chart2 = new google.visualization.ColumnChart(document.getElementById('chart_div2'));
        chart2.draw(data2, options2);            
            
        var data3 = new google.visualization.DataTable();
        data3.addColumn('string', 'CIE10');
        <asp:Repeater runat="server" DataSourceID="SCausas" ID="RCausas">
            <ItemTemplate>data3.addColumn('number', '<%# Eval("causa") %>');</ItemTemplate>
        </asp:Repeater>

        data3.addRows([
            ['CIE10'
            <asp:Repeater runat="server" DataSourceID="SCausas" ID="RCausas2">
                <ItemTemplate>,<%# Eval("c").ToString().Replace(",",".") %></ItemTemplate>
            </asp:Repeater>
            ]
        ]);

        var options3 = {
            width: 600, height: 400,
            title: 'Patologías principales'
        };

        var chart3 = new google.visualization.ColumnChart(document.getElementById('chart_div3'));
        chart3.draw(data3, options3);
    }
</script>
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde</td>
            <td>Hasta</td>
            <td>Entidad</td>
            <td>
            </td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox><asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
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
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" onclick="BBuscar_Click" Text="Buscar" />
            </td>
        </tr>
    </table>
    <div id="dImprimir">
        <table>
        <tr>
            <td><div id="chart_div"></div></td>
            <td><div id="chart_div2"></div></td>
        </tr>
        <tr>
            <td align="center">
        <asp:DetailsView ID="DResultados" runat="server" DataSourceID="SResultados" AutoGenerateRows="false">
            <Fields>
                <asp:BoundField HeaderText="Pacientes atendidos" DataField="atendidos" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Mortalidad" DataField="muertos" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Egresos" DataField="egresos" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
            </Fields>
        </asp:DetailsView>
            <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                        (SELECT COUNT(*) FROM paciente_egreso 
                        LEFT JOIN causa_egreso ON (causa_egreso.cegId=paciente_egreso.cegId)
                        LEFT JOIN paciente ON (paciente.pacId=paciente_egreso.pacId)
                        WHERE (@eps=0 OR paciente.entId=@eps) AND paciente_egreso.egrFecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND causa_egreso.cegDescripcion='MUERTE') AS muertos
                        ,(SELECT COUNT(DISTINCT autNumero) FROM autorizacion WHERE 
                        (@eps=0 OR autorizacion.entId=@eps) AND 
                        autNumero IN (SELECT programacion.autNumero FROM programacion WHERE prgFechaProg BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y'))) AS atendidos
                        ,
                        (SELECT COUNT(*) FROM paciente_egreso
                        LEFT JOIN causa_egreso ON (causa_egreso.cegId=paciente_egreso.cegId)
                        LEFT JOIN paciente ON (paciente.pacId=paciente_egreso.pacId) 
                        WHERE 
                        (@eps=0 OR paciente.entId=@eps) AND 
						paciente_egreso.egrFecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') 
                        AND 
						(causa_egreso.cegDescripcion LIKE 'REINGRESO POR AGUDIZACION' OR causa_egreso.cegDescripcion='REINGRESO POR PATOLOGIA ANEXA' OR causa_egreso.cegDescripcion='REINGRESO POR CANALIZACIÓN FALLIDA')
                        ) AS egresos
                        ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" Name="eps" PropertyName="SelectedValue" />
                 </SelectParameters>
    </asp:SqlDataSource>
        </td>
        <td align="center">
            <asp:DetailsView ID="DEventos" runat="server" DataSourceID="SEventos" 
                AutoGenerateRows="False">
            <Fields>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L1" runat="server" CommandName="eventos" OnClick="LEventos_Click" Text="Eventos adversos" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("eventos")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L2" runat="server" CommandName="farmacologico" OnClick="LEventos_Click" Text="Farmacológico" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("farmacologico")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L3" runat="server" CommandName="epidemologicos" OnClick="LEventos_Click" Text="Epidemiológicos" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("epidemologicos")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L4" runat="server" CommandName="apoyoterapeutico" OnClick="LEventos_Click" Text="Apoyo terapéutico" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("apoyoterapeutico")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L5" runat="server" CommandName="lesionesapoyo" OnClick="LEventos_Click" Text="Lesiones apoyo" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("lesionesapoyo")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L6" runat="server" CommandName="autolesion" OnClick="LEventos_Click" Text="Autolesión" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("autolesion")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:LinkButton ID="L7" runat="server" CommandName="atencion" OnClick="LEventos_Click" Text="Complicaciones en la atención" ></asp:LinkButton>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("atencion")%>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
            </Fields>
        </asp:DetailsView>
        <asp:SqlDataSource ID="SEventos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                                (SELECT COUNT(*) FROM evento_adverso WHERE (@eps=0 OR evento_adverso.entidad=@eps) AND evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')) AS eventos
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE (@eps=0 OR evento_adverso.entidad=@eps) AND evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161 OR tipo=150 OR tipo=154 OR tipo=160 OR tipo=153)) AS farmacologico
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE (@eps=0 OR evento_adverso.entidad=@eps) AND evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161 OR tipo=147 OR tipo=149)) AS epidemologicos
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE (@eps=0 OR evento_adverso.entidad=@eps) AND evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161 OR tipo=147 OR tipo=149 OR tipo=157 OR tipo=158)) AS apoyoterapeutico
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE (@eps=0 OR evento_adverso.entidad=@eps) AND evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161 OR tipo=157 OR tipo=158 OR tipo=156 )) AS lesionesapoyo
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE (@eps=0 OR evento_adverso.entidad=@eps) AND evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161 OR tipo=156 OR tipo=158 OR tipo=157)) AS autolesion
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE (@eps=0 OR evento_adverso.entidad=@eps) AND evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161 OR tipo=160 OR tipo=151 OR tipo=155 )) AS atencion
                                ;">
                     <SelectParameters>
                        <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                        <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                        <asp:ControlParameter ControlID="DAsegurador" Name="eps" PropertyName="SelectedValue" />
                     </SelectParameters>
        </asp:SqlDataSource>
        </td>
    </tr>
            <tr>
                <td align="center"><div id="chart_div3"></div></td>
                <td align="center">&nbsp;</td>
            </tr>
            <tr>
                <td align="center"><asp:GridView ID="GCausas" runat="server" DataSourceID="SCausas" AutoGenerateColumns="False" AllowPaging="True" PageSize="50" AllowSorting="True" Width="100%">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField HeaderText="CIE10" SortExpression="causa" DataField="causa" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="100%" />
                        <asp:BoundField HeaderText="Incidencias" SortExpression="c" DataField="c" ItemStyle-HorizontalAlign="Right" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SCausas" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT CONCAT(cie10.cieCodDx,' - ', cie10.cirDescripcion) AS causa,COUNT(*) AS c FROM autorizacion
                                LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                                LEFT JOIN cie10 ON (cie10.cieCodDx=paciente.cieCodDx)
                                WHERE 
                                paciente.cieCodDx IS NOT NULL
                                AND (@eps=0 OR paciente.entId=@eps)
                                AND autorizacion.autNumero IN 
                                (SELECT autNumero FROM programacion WHERE prgFechaProg BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y'))
                                GROUP BY cie10.cieCodDx,cie10.cirDescripcion ORDER BY c DESC LIMIT 10">
                             <SelectParameters>
                                <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                                <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                                <asp:ControlParameter ControlID="DAsegurador" Name="eps" PropertyName="SelectedValue" />
                             </SelectParameters>
                </asp:SqlDataSource></td>
                <td align="center">&nbsp;</td>
            </tr>
    </table>
    </div>
    <asp:Panel runat="server" ID="PDetalle" Visible="false">
        <table width="100%">
        <tr>
        <td class="Titulo"><asp:Label runat="server" ID="LDetalle"></asp:Label></td>
        </tr>
        <tr>
        <td>
        <asp:GridView ID="GDetalle" runat="server" DataSourceID="SDetalle" 
            AutoGenerateColumns="False" EmptyDataText="No se encontraron eventos" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataKeyNames="id,pacienteid" onrowdatabound="GDetalle_RowDataBound">
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Columns>
                <asp:TemplateField HeaderText="Paciente" SortExpression="paciente">
                    <ItemTemplate>
                        <asp:LinkButton ID="LPaciente" runat="server" CausesValidation="False" PostBackUrl='<%# Eval("id", "~/auditoria/eventoa.aspx?eaid={0}") %>' Text='<%# Eval("paciente") %>'></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField HeaderText="Fecha" SortExpression="fecha" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" DataField="fecha" />
                <asp:BoundField HeaderText="Descripción" SortExpression="descripcion" DataField="descripcion" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SDetalle" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="DAsegurador" Name="eps" PropertyName="SelectedValue" />
                   </SelectParameters>
        </asp:SqlDataSource>
        </td>
        </tr>
        </table>
    </asp:Panel>
</asp:Panel>
</asp:Content>