<%@ Page Title="Estadísticas Encuestas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serEstadisticaEncuesta.aspx.vb" Inherits="ML.serEstadisticaEncuesta" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
             <script type="text/javascript" src="https://www.google.com/jsapi"></script>  
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table border="1">
        <tr>
            <th>Seleccione Encuesta</th>
            <th>Fecha Inicial</th>
            <th>Fecha Final</th>
        </tr>
        <tr>
            <td>
                <uc1:DropDownListU ID="ddlEnc" runat="server" Requerido="true" />
            </td>
            <td>
                <uc2:Fecha ID="fchIni" runat="server" />
            </td>
            <td>
                <uc2:Fecha ID="fchFin" runat="server" />
            </td>
        </tr>
        <tr><td colspan="3" align="center">
            <asp:ImageButton runat="server" ID="imbBuscar" SkinID="imbBuscar" Width="20px" Height="20px" />
        </td></tr>
    </table>
    <%  If Not dts Is Nothing Then
            Dim dt = dts.Tables(0)
            Dim dt1 = dts.Tables(1)
            Dim dtc = dts.Tables(2)
            %>
                <h3>Total Diligendiamientos: <%=dtc.Rows(0)(0)%></h3>
            <%
            Dim i = 0
            If dt.Rows.Count > 0 Then
                For Each row As Data.DataRow In dt.Rows%>
                        <script type="text/javascript">
                              google.load("visualization", "1", {packages:["corechart"]});  
                          <% if row("preTipo")=1 then%>
                              google.setOnLoadCallback(drawChart<%=i%>);  
                              function drawChart<%=i%>() {
                                var data = new google.visualization.DataTable();  
                                data.addColumn('string', 'Opción');  
                                data.addColumn('number', 'Cantidad');  
                                <%dt1.defaultView.rowfilter="preId="+row("preId").toString()
                                dim dt2=dt1.defaultView.toTable() %>
                                data.addRows(<%=dt2.Rows.Count%>);
                                <%dim j=0
                                    For Each row1 as Data.DataRow In dt2.Rows %>
                                        data.setValue(<%=j%>, 0, '<%=row1("oppTexto")%>');  
                                        data.setValue(<%=j%>, 1, <%=row1("cant")%>);
                                 <%j+=1
                                 Next %>    
                                var chart = new google.visualization.PieChart(document.getElementById('chart_div<%=i%>'));  
                                chart.draw(data, {is3D:true, width: 400, height: 150, title: ''});  
                            }
                            <%End If %>

                          <% if row("preTipo")=2 then%>
                              google.setOnLoadCallback(drawChart<%=i%>);  
                              function drawChart<%=i%>() {
                                var data = new google.visualization.DataTable();  
                                data.addColumn('string', 'Opción');  
                                data.addColumn('number', 'Muy Bajo');
                                data.addColumn('number', 'Bajo');
                                data.addColumn('number', 'Medio');
                                data.addColumn('number', 'Alto');
                                data.addColumn('number', 'Muy alto');
                                <%dt1.defaultView.rowfilter="preId="+row("preId").toString()
                                dim dt2=dt1.defaultView.toTable() %>
                                data.addRows(<%=row("cant")%>);
                                <%dim j=-1
                                    dim oppid=0
                                    For Each row1 as Data.DataRow In dt2.Rows
                                         if oppId<>row1("oppid") then
                                            j+=1
                                            oppid=row1("oppid")
                                         end if%>
                                        <%if row1("id")=1 %>
                                        data.setValue(<%=j%>, 0, '<%=row1("oppTexto")%>');  
                                        <%end if %>
                                        data.setValue(<%=j%>, <%=row1("id")%>, <%=row1("cant")%>);
                                <% Next %>    
                                var chart = new google.visualization.BarChart(document.getElementById('chart_div<%=i%>'));  
                                chart.draw(data, { width: 600, height: 400, title: 'Cantidad', vAxis: { title: 'Opciones'} });
                            }
                            <%End If %>
                        </script>  
                        <h3><%=row("PreTexto")%></h3>
                        <div id="chart_div<%=i %>"></div>
                <%i += 1
                Next
            End If%>
        <%End If%>

</asp:Content>
