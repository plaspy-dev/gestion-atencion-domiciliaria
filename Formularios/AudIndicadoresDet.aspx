<%@ Page Title="Detalle Indicadores" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AudIndicadoresDet.aspx.vb" Inherits="ML.AudIndicadoresDet" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>  
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:Label ID="lblTitulo" runat="server" Text=""></asp:Label>
    <br />
    <br />
     <script type="text/javascript">              
                      google.load("visualization", "1", {packages:["corechart"]});  
                      google.setOnLoadCallback(drawChart);  
                      function drawChart() {
                        var data = new google.visualization.DataTable();  
                        data.addColumn('string', 'Asegurador');  
                        data.addColumn('number', 'Cantidad');  
                        data.addRows(2);           
                        data.setValue(0, 0, 'Indicador');  
                        data.setValue(0, 1, <%=request.querystring("nu")%>);
                        data.setValue(1, 0, 'Diferencia');  
                        data.setValue(1, 1, <%=integer.parse(request.querystring("de"))-integer.parse(request.querystring("nu"))%>);
                        var chart = new google.visualization.PieChart(document.getElementById('Div1'));  
                        chart.draw(data, {is3D:true, width: 500, height: 300, title: 'Total Muestra: <%=request.querystring("de")%> <%=muestra %>'});  
                      }
                      
            </script> 
            <div id="Div1"></div>  
    <%If Not tblAseg Is Nothing Then%>
        <%If tblAseg.Rows.Count > 0 Then%>
         <script type="text/javascript">              
                      google.load("visualization", "1", {packages:["corechart"]});  
                      google.setOnLoadCallback(drawChart);  
                      function drawChart() {
                        var data = new google.visualization.DataTable();  
                        data.addColumn('string', 'Asegurador');  
                        data.addColumn('number', 'Cantidad');  
                        data.addRows(<%=tblAseg.rows.Count%>);           
                        <% dim i=0
                         For Each row As System.data.DataRow In tblAseg.Rows %>
                            data.setValue(<%=i %>, 0, '<%=row("entNombre") %>');  
                            data.setValue(<%=i %>, 1, <%=row("cant") %>);
                        <%i+=1
                        Next %>
                        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));  
                        chart.draw(data, {is3D:true, width: 500, height: 300, title: 'Indicador por asegurador'});  
                      }
                      
            </script> 
            <div id="chart_div"></div>    
    <%End If%>
    <%End If%>
    <%If Not tblAd Is Nothing Then%>
        <%If tblAd.Rows.Count > 0 Then%>
         <script type="text/javascript">              
                      google.load("visualization", "1", {packages:["corechart"]});  
                      google.setOnLoadCallback(drawChart);
                      function drawChart() {
                        var data = new google.visualization.DataTable();  
                        data.addColumn('string', 'Asegurador');  
                        data.addColumn('number', 'Cantidad');  
                        data.addRows(<%=tblAd.rows.Count%>);           
                        <% dim i=0
                         For Each row As System.data.DataRow In tblAd.Rows %>
                            data.setValue(<%=i %>, 0, '<%=row("entNombre")%>');  
                            data.setValue(<%=i %>, 1, <%=row("cant")%>);
                        <%i+=1
                        Next %>
                        var chart = new google.visualization.PieChart(document.getElementById('chart_divQR'));  
                        chart.draw(data, {is3D:true, width: 500, height: 300, title: 'Gestión de quejas'});
                      }
                      
            </script> 
            <div id="chart_divQR"></div>    
    <%End If%>
    <%End If%>
    <ml:GridView ID="grvInd" runat="server" EmptyDataText="No hay datos para mostrar">
    </ml:GridView>
</asp:Content>
