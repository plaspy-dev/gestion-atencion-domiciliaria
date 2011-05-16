<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serInfQuejas.aspx.vb" Inherits="ML.serInfQuejas" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>  
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
        <uc3:Filtro ID="Filtro1" runat="server" tipo="ML.Datos.ServicioCliente.QuejasReclamos" campos="qrFecha,qrFechaFin" titulos="Fecha Inicial,Fecha Final" Expandido="true"/>
        <%If Not dt Is Nothing Then%>
           <script type="text/javascript">              
                      google.load("visualization", "1", {packages:["corechart"]});  
                      google.setOnLoadCallback(drawChart);  
                      function drawChart() {
                        var data = new google.visualization.DataTable();  
                        data.addColumn('string', 'Asegurador');  
                        data.addColumn('number', 'Cantidad');  
                        data.addRows(<%=dt.rows.Count%>);           
                        <% dim i=0
                         For Each row As System.data.DataRow In dt.Rows %>
                            data.setValue(<%=i %>, 0, '<%=row("entNombre") %>');  
                            data.setValue(<%=i %>, 1, <%=row("cant") %>);
                        <%i+=1
                        Next %>
                        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));  
                        chart.draw(data, {is3D:true, width: 500, height: 300, title: 'Quejas por asegurador'});  
                      }
                      
            </script> 
                    <div id="chart_div"></div>    
        <%End If%>

</asp:Content>
