<%@ Page Title="Informe de cumplimiento" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="autorizadovsrealizado.aspx.cs" Inherits="auditoria_autorizadovsrealizado" %>
<%@ Register Src="~/control/actividad.ascx" TagName="actividad" TagPrefix="uc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript">
    $(function() {
        $("#<%= GResultados.ClientID %>> tbody tr:first").after("<tr><td colspan=7 class='celdaTitulo'>CONSOLIDADO TOTAL</td></tr>");
        $("#<%= GResultados.ClientID %> b").filter(".h1:last").parent().parent().after("<tr><td colspan=7 class='celdaTitulo'>CONSOLIDADO POR ACTIVIDAD</td></tr>");
        $("#<%= GResultados.ClientID %> b").filter(".h2:last").parent().parent().after("<tr class=''><td colspan=7 class='celdaTitulo'>CONSOLIDADO POR ASEGURADOR</td></tr>");
    });

    google.load("visualization", "1", { packages: ["corechart"] });
    google.setOnLoadCallback(drawChart);
    function drawChart() {
        if (typeof (gdata) == "undefined")
            return;
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Concepto');
        data.addColumn('number', 'Cumplimiento');
        data.addRows(gdata);

        var options = {
            width: 400, height: 300,
            title: 'Cumplimiento'
        };

        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
        chart.draw(data, options);
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Inicio</td>
            <td>Fin</td>
            <td>Asegurador</td>
            <td>Actividad</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TInicio" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFin" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFin" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:DropDownList ID="DAsegurador" runat="server"  CssClass="anchomaxcombo"
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td><uc:actividad runat="server" ID="UCActividad" /></td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="dImprimir">
    <div id="chart_div"></div>
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Width="100%" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron actividades" AllowSorting="True" OnRowDataBound="GResultados_RowDataBound" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField HeaderText="Actividad" DataField="nombre" SortExpression="i,nombre" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
            <asp:BoundField HeaderText="Sesiones autorizadas" DataField="ses" SortExpression="i,ses" ItemStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Sesiones realizadas" DataField="a" SortExpression="i,a" ItemStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Sesiones canceladas por novedad" DataField="b" SortExpression="i,b" ItemStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Sesiones incumplidas" DataField="c" SortExpression="i,c" ItemStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Inclumplimiento" DataField="d" SortExpression="i,d" DataFormatString="{0:p}" ItemStyle-HorizontalAlign="Right"/>
            <asp:TemplateField ItemStyle-CssClass="hidet" HeaderStyle-CssClass="hidet">  
                <ItemTemplate><b class="h<%# Eval("i") %>"></b></ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="(
                                SELECT 1 AS i,CAST('Consolidad total' AS CHAR) AS nombre, SUM(autNumSesiones) AS ses,SUM(a) AS a,SUM(b) AS b
                                ,SUM(autNumSesiones)-SUM(a)-SUM(b) AS c 
                                ,CASE SUM(autNumSesiones) WHEN 0 THEN 0 ELSE ((SUM(autNumSesiones)-SUM(a)-SUM(b))/SUM(autNumSesiones)) END AS d
                                FROM 
                                (
                                SELECT autorizacion.autNumero, autorizacion_detalle.autNumSesiones
                                ,SUM(CASE prgActivo WHEN 1 THEN programacion.prgNumSesion ELSE 0 END) AS a
                                ,SUM(CASE prgActivo WHEN 0 THEN programacion.prgNumSesion ELSE 0 END) AS b
                                FROM autorizacion
                                LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                                LEFT JOIN programacion ON (programacion.autNumero=autorizacion.autNumero AND programacion.actId=autorizacion_detalle.actId)
                                WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                AND (@asegurador=0 OR @asegurador=autorizacion.entId)
                                AND (@actividad=0 OR @actividad=autorizacion_detalle.actId)
                                GROUP BY autorizacion.autNumero, autorizacion_detalle.actId,autorizacion_detalle.autNumSesiones
                                ) AS a
                            ) UNION (
                                SELECT 2 AS i,CAST(a.actId AS CHAR) AS nombre,SUM(autNumSesiones) AS ses,SUM(a) AS a,SUM(b) AS b
                                ,SUM(autNumSesiones)-SUM(a)-SUM(b) AS c 
                                ,CASE SUM(autNumSesiones) WHEN 0 THEN 0 ELSE ((SUM(autNumSesiones)-SUM(a)-SUM(b))/SUM(autNumSesiones)) END AS d
                                FROM 
                                (
                                    SELECT autorizacion.autNumero, autorizacion_detalle.actId,autorizacion_detalle.autNumSesiones
                                    ,SUM(CASE prgActivo WHEN 1 THEN programacion.prgNumSesion ELSE 0 END) AS a
                                    ,SUM(CASE prgActivo WHEN 0 THEN programacion.prgNumSesion ELSE 0 END) AS b
                                    FROM autorizacion
                                    LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                                    LEFT JOIN programacion ON (programacion.autNumero=autorizacion.autNumero AND programacion.actId=autorizacion_detalle.actId)
                                    WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                    AND autorizacion_detalle.actId IS NOT NULL
                                    AND (@asegurador=0 OR @asegurador=autorizacion.entId)
                                    AND (@actividad=0 OR @actividad=autorizacion_detalle.actId)
                                    GROUP BY autorizacion.autNumero, autorizacion_detalle.actId,autorizacion_detalle.autNumSesiones
                                ) AS a GROUP BY a.actId
                            ) UNION (
                                
                                SELECT 3 AS i,CAST(IFNULL(a.entNombre,'(Ninguno)') AS CHAR),SUM(autNumSesiones),SUM(a),SUM(b)
                                ,SUM(autNumSesiones)-SUM(a)-SUM(b) AS c 
                                ,CASE SUM(autNumSesiones) WHEN 0 THEN 0 ELSE ((SUM(autNumSesiones)-SUM(a)-SUM(b))/SUM(autNumSesiones)) END AS d
                                FROM 
                                (
                                SELECT autorizacion.autNumero, asegurador.entNombre, autorizacion_detalle.autNumSesiones
                                ,SUM(CASE prgActivo WHEN 1 THEN programacion.prgNumSesion ELSE 0 END) AS a
                                ,SUM(CASE prgActivo WHEN 0 THEN programacion.prgNumSesion ELSE 0 END) AS b
                                FROM autorizacion
                                LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                                LEFT JOIN programacion ON (programacion.autNumero=autorizacion.autNumero AND programacion.actId=autorizacion_detalle.actId)
                                LEFT JOIN asegurador ON (asegurador.entId=autorizacion.entId)
                                WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                AND (@asegurador=0 OR @asegurador=autorizacion.entId)
                                AND (@actividad=0 OR @actividad=autorizacion_detalle.actId)
                                GROUP BY autorizacion.autNumero, autorizacion_detalle.actId,asegurador.entNombre,autorizacion_detalle.autNumSesiones
                                ) AS a
                                GROUP BY a.entNombre
                            ) ORDER BY i,nombre
                            ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" Name="asegurador" PropertyName="SelectedValue" />
                     <asp:ControlParameter ControlID="UCActividad" Name="actividad" PropertyName="IdActividad" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
