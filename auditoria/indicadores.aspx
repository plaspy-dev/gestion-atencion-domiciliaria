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
        data.addColumn('number', 'Servicios descubiertos');
        data.addColumn('number', 'Pacientes atendidos');
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
            <td align="center">
        <asp:DetailsView ID="DResultados" runat="server" DataSourceID="SResultados" AutoGenerateRows="false">
            <Fields>
                <asp:BoundField HeaderText="Pacientes atendidos" DataField="atendidos" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Mortalidad" DataField="muertos" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Egresos" DataField="egresos" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Servicios PHD" DataField="phdProgramadas" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Servicios descubiertos PHD" DataField="descubiertoenfermeria" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />                
                <asp:BoundField HeaderText="Pacientes atendidos PHD" DataField="atendidosphd" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Servicios apoyo terapeutico" DataField="atxProgramadas" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Servicios descubiertos apoyo terapeutico" DataField="descubiertoapoyo" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />                
                <asp:BoundField HeaderText="Pacientes atendidos apoyo terapeutico" DataField="atendidosatx" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
            </Fields>
        </asp:DetailsView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ConnBD %>" 
                SelectCommand="SELECT 
                        (SELECT COUNT(*) FROM phdEgresos 
                        LEFT JOIN phdCausaEgreso ON (phdCausaEgreso.cegId=phdEgresos.cegId)
                        WHERE phdEgresos.egrFecha BETWEEN @desde AND @hasta AND phdCausaEgreso.cegDescripcion='MUERTE') AS muertos
                        ,
                        (SELECT COUNT(DISTINCT pacId) FROM phdProgramacion WHERE prgFechaProg BETWEEN @desde AND @hasta)+ 
                        (SELECT COUNT(DISTINCT pacId) FROM phdProgramacionMD WHERE prgFechaProg BETWEEN @desde AND @hasta)+ 
                        (SELECT COUNT(DISTINCT pacId) FROM atxProgramacion WHERE prgFechaProg BETWEEN @desde AND @hasta) AS atendidos
                        ,
                        (SELECT COUNT(*) FROM phdEgresos
                        LEFT JOIN phdCausaEgreso ON (phdCausaEgreso.cegId=phdEgresos.cegId)
                        WHERE 
						phdEgresos.egrFecha BETWEEN @desde AND @hasta 
                        AND 
						(phdCausaEgreso.cegDescripcion LIKE 'REINGRESO POR AGUDIZACION' OR phdCausaEgreso.cegDescripcion='REINGRESO POR PATOLOGIA ANEXA' OR phdCausaEgreso.cegDescripcion='REINGRESO POR CANALIZACIÓN FALLIDA')
                        ) AS egresos
                        ,(SELECT COUNT(DISTINCT pacId) FROM phdProgramacion WHERE prgFechaProg BETWEEN @desde AND @hasta) AS atendidosphd
                        ,(SELECT COUNT(*) FROM phdNovedad WHERE phdNovedad.novTipo=5 AND phdNovedad.prgTipo=1 AND phdNovedad.segFechaRegistro BETWEEN @desde AND @hasta) AS descubiertoenfermeria
                        ,(SELECT COUNT(*) FROM phdProgramacion WHERE prgFechaProg BETWEEN @desde AND @hasta) AS phdProgramadas
                        ,(SELECT COUNT(DISTINCT pacId) FROM atxProgramacion WHERE prgFechaProg BETWEEN @desde AND @hasta) AS atendidosatx
                        ,(SELECT COUNT(*) FROM phdNovedad WHERE phdNovedad.novTipo=5 AND phdNovedad.prgTipo=2 AND phdNovedad.segFechaRegistro BETWEEN @desde AND @hasta) AS descubiertoapoyo
                        ,(SELECT COUNT(*) FROM atxProgramacion WHERE prgFechaProg BETWEEN @desde AND @hasta) AS atxProgramadas
                        ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                    <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                 </SelectParameters>
    </asp:SqlDataSource>
        </td>
        <td align="center">
            <asp:DetailsView ID="DEventos" runat="server" DataSourceID="SEventos" 
                AutoGenerateRows="False">
            <Fields>
                <asp:BoundField DataField="eventos" HeaderStyle-HorizontalAlign="Left" 
                    HeaderText="Eventos adversos" ItemStyle-HorizontalAlign="Right">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:BoundField DataField="farmacologico" HeaderStyle-HorizontalAlign="Left" 
                    HeaderText="Farmacológico" ItemStyle-HorizontalAlign="Right">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:BoundField DataField="epidemologicos" HeaderStyle-HorizontalAlign="Left" 
                    HeaderText="Epidemiológicos" ItemStyle-HorizontalAlign="Right">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:BoundField DataField="apoyoterapeutico" HeaderStyle-HorizontalAlign="Left" 
                    HeaderText="Apoyo terapéutico" ItemStyle-HorizontalAlign="Right">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:BoundField DataField="lesionesapoyo" HeaderStyle-HorizontalAlign="Left" 
                    HeaderText="Lesiones apoyo" ItemStyle-HorizontalAlign="Right">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:BoundField DataField="autolesion" HeaderStyle-HorizontalAlign="Left" 
                    HeaderText="Autolesión" ItemStyle-HorizontalAlign="Right">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:BoundField DataField="atencion" HeaderStyle-HorizontalAlign="Left" 
                    HeaderText="Complicaciones en la atención" ItemStyle-HorizontalAlign="Right">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
            </Fields>
        </asp:DetailsView>
        <asp:SqlDataSource ID="SEventos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                                (SELECT COUNT(*) FROM evento_adverso WHERE evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')) AS eventos
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161
                                OR tipo=150
                                OR tipo=154
                                OR tipo=160
                                OR tipo=153)) AS farmacologico
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161
                                OR tipo=147 OR tipo=149)) AS epidemologicos
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161
                                OR tipo=147
                                OR tipo=149
                                OR tipo=157
                                OR tipo=158)) AS apoyoterapeutico
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161
                                OR tipo=157
                                OR tipo=158
                                OR tipo=156
                                )) AS lesionesapoyo
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161
                                OR tipo=156
                                OR tipo=158
                                OR tipo=157)) AS autolesion
                                ,(SELECT COUNT(DISTINCT evento_adverso.id) FROM evento_adverso LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=evento_adverso.id) WHERE evento_adverso.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (tipo=148 OR tipo=146 OR tipo=161
                                OR tipo=160
                                OR tipo=151
                                OR tipo=155
                                )) AS atencion
                                ;">
                     <SelectParameters>
                        <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                        <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                     </SelectParameters>
        </asp:SqlDataSource>
        </td>
    </tr>
    </table>
    </div>
</asp:Panel>
</asp:Content>