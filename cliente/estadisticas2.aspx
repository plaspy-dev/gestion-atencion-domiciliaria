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
                <td align="center"><asp:DetailsView ID="DResultados" runat="server" DataSourceID="SResultados" AutoGenerateRows="false">
            <Fields>
                <asp:BoundField HeaderText="Quejas" DataField="quejas" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Cerradas" DataField="cerradas" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Atendidas" DataField="atendidas" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Sin tramitar" DataField="sintramitar" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
            </Fields>
        </asp:DetailsView></td>
                <td align="center"><asp:DetailsView ID="DSolucion" runat="server" DataSourceID="SResultados" AutoGenerateRows="false">
            <Fields>
                <asp:BoundField HeaderText="Resueltas en 3 días o menos" DataField="dias3" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Resueltas de 4 a 7 días" DataField="dias7" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Resueltas de 8 a 15 días" DataField="dias15" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Resueltas en 16 o más" DataField="muchosdias" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Sin cerrar" DataField="sincerrar" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Left" />
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
    </asp:Panel>
</asp:Content>

