<%@ Page Title="Informe de costos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="auditoria_Costos" Codebehind="Costos.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        $("#<%= TProcedimiento.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetMedicamentos",
            data: { t: 173 },
            idField: "<%= TProcedimientoID.ClientID %>"
        });
    });
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
            <td>Área</td>
            <td>Grupo</td>
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
            <td><asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
            <asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hide"></asp:TextBox>
            </td>
            <td><asp:DropDownList ID="DArea" runat="server" DataSourceID="SArea" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SArea" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT CAST(IFNULL(GROUP_CONCAT(medicamentos.id),-1) AS CHAR) AS id, varios.nombre FROM varios LEFT JOIN medicamentos ON (medicamentos.grupo=varios.id) WHERE varios.tipo=22 AND varios.szReservado IS NULL GROUP BY varios.id ORDER BY varios.nombre;">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList runat="server" ID="DGrupo">
                    <asp:ListItem Text="(Todos)"></asp:ListItem>
                    <asp:ListItem Text="Grupo 1"></asp:ListItem>
                    <asp:ListItem Text="Grupo 2"></asp:ListItem>
                    <asp:ListItem Text="Grupo 3"></asp:ListItem>
                    <asp:ListItem Text="Grupo 4"></asp:ListItem>
                    <asp:ListItem Text="Grupo 5"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" onclick="BBuscar_Click" /></td>
        </tr>
        </table>
    </asp:Panel>
    <div id="chart_div" style="width: 1000px; height: 300px;"></div>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart"] });
        google.setOnLoadCallback(drawChart);
        function drawChart() {
            var data = google.visualization.arrayToDataTable([
                <asp:Repeater ID="RGrafica" runat="server">
                    <HeaderTemplate>['Fecha', 'Autorizado', 'Realizado']</HeaderTemplate>
                    <ItemTemplate>,['<%# Eval("fecha")%>', <%# Eval("autorizada")%>, <%# Eval("realizada")%>]</ItemTemplate>
                </asp:Repeater>
            ]
            );
            var options = { title: 'Cantidad' };
            var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
            chart.draw(data, options);
        }
    </script>
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" ShowFooter="true"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" 
        AllowPaging="True" PageSize="50" AllowSorting="True" 
            OnRowDataBound="GResultados_RowDataBound" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="autNumero" HeaderText="Autorización" DataNavigateUrlFields="autNumero" DataNavigateUrlFormatString="~/admisiones/autorizaciones.aspx?aut={0}" SortExpression="autNumero" />
            <asp:BoundField HeaderText="Fecha" DataField="autFecha" SortExpression="autFecha" DataFormatString="{0:d}" />
            <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" DataNavigateUrlFields="pacId" SortExpression="pacNombres" DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Grupo" DataField="grupo" SortExpression="grupo" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Actividad" DataField="actividad" SortExpression="actividad" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Sesiones Autorizadas" DataField="autNumSesiones" SortExpression="autNumSesiones" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Costo autorizadas" DataField="entId" SortExpression="costoestimado" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Sesiones programadas" DataField="realizadas" SortExpression="realizadas" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Costo programadas" DataField="vacio" SortExpression="vacio" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Diferencia sesiones" DataField="vacio" SortExpression="vacio" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Diferencia costo" DataField="vacio" SortExpression="vacio" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false"/>
        </Columns>
    </asp:GridView>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT autorizacion.autNumero
                                    ,autorizacion.autFecha
                                    ,paciente.pacId
	                                ,paciente.pacNombres
	                                ,IFNULL(grupo.grupo,'Grupo 5') AS grupo
	                                ,paciente.entId
	                                ,asegurador.entNombre
	                                ,autorizacion_detalle.actId AS actividad
	                                ,autorizacion_detalle.autNumSesiones
	                                ,SUM(programacion.prgNumSesion) AS realizadas
	                                ,NULL AS vacio
                                FROM autorizacion
                                LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                                LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                                LEFT JOIN programacion ON (programacion.autNumero=autorizacion.autNumero AND autorizacion_detalle.actId=programacion.actId AND programacion.prgActivo=1)
                                LEFT JOIN (SELECT autorizacion_detalle.autNumero,CASE WHEN SUM(autorizacion_detalle.autNumSesiones)<17 THEN 'Grupo 1' 
                                            WHEN SUM(autorizacion_detalle.autNumSesiones)<49 THEN 'Grupo 2'
                                            WHEN SUM(autorizacion_detalle.autNumSesiones)<75 THEN 'Grupo 3'
                                            ELSE 'Grupo 4' END AS grupo
                                            FROM autorizacion_detalle 
                                            WHERE 
                                            autorizacion_detalle.actId IN (5028,5029,5030,5031)
                                            GROUP BY autorizacion_detalle.autNumero) AS grupo ON (grupo.autNumero=autorizacion.autNumero)
                                WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                AND autorizacion.autActivo=1
                                AND (@asegurador=0 OR paciente.entId=@asegurador)
                                AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                                AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                                AND (@grupo='(Todos)' OR grupo.grupo=@grupo OR (@grupo='Grupo 5' AND grupo.grupo IS NULL))
                                GROUP BY autorizacion.autNumero,autorizacion.autFecha,paciente.pacId,paciente.pacNombres,autorizacion_detalle.actId,autorizacion_detalle.autNumSesiones,paciente.entId,asegurador.entNombre,grupo.grupo
                                ORDER BY autorizacion.autFecha">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DGrupo" Name="grupo" PropertyName="SelectedValue" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <br />
    <div align="right">
    <asp:GridView runat="server" ID="GResumen" AutoGenerateColumns="False" OnRowDataBound="GResumen_RowDataBound" ShowHeader="false" DataSourceID="SResumen" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField DataField="nombre" ItemStyle-HorizontalAlign="Left" />
            <asp:BoundField DataField="des" ItemStyle-HorizontalAlign="Right" />
        </Columns>
    </asp:GridView>
    </div>
    <asp:SqlDataSource ID="SResumen" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="( 
                        SELECT '-3' AS nombre,COUNT(DISTINCT autorizacion.autNumero) AS des
                                                    FROM autorizacion
                                                    LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                                                    LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
							                        LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
							                        LEFT JOIN (SELECT autorizacion_detalle.autNumero,CASE WHEN SUM(autorizacion_detalle.autNumSesiones)<17 THEN 'Grupo 1' 
                                                        WHEN SUM(autorizacion_detalle.autNumSesiones)<49 THEN 'Grupo 2'
                                                        WHEN SUM(autorizacion_detalle.autNumSesiones)<75 THEN 'Grupo 3'
                                                        ELSE 'Grupo 4' END AS grupo
                                                        FROM autorizacion_detalle 
                                                        WHERE 
                                                        autorizacion_detalle.actId IN (5028,5029,5030,5031)
                                                        GROUP BY autorizacion_detalle.autNumero) AS grupo ON (grupo.autNumero=autorizacion.autNumero)
                                                    WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                                    AND (@asegurador=0 OR paciente.entId=@asegurador)
                                                    AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                                                    AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                                                    AND (@grupo='(Todos)' OR grupo.grupo=@grupo OR (@grupo='Grupo 5' AND grupo.grupo IS NULL))
                        ) UNION ( 
                        SELECT '-1',COUNT(DISTINCT paciente.pacNombres)
                                                    FROM autorizacion
                                                    LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                                                    LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
							                        LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
							                        LEFT JOIN (SELECT autorizacion_detalle.autNumero,CASE WHEN SUM(autorizacion_detalle.autNumSesiones)<17 THEN 'Grupo 1' 
                                                        WHEN SUM(autorizacion_detalle.autNumSesiones)<49 THEN 'Grupo 2'
                                                        WHEN SUM(autorizacion_detalle.autNumSesiones)<75 THEN 'Grupo 3'
                                                        ELSE 'Grupo 4' END AS grupo
                                                        FROM autorizacion_detalle 
                                                        WHERE 
                                                        autorizacion_detalle.actId IN (5028,5029,5030,5031)
                                                        GROUP BY autorizacion_detalle.autNumero) AS grupo ON (grupo.autNumero=autorizacion.autNumero)
                                                    WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                                    AND (@asegurador=0 OR paciente.entId=@asegurador)
                                                    AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                                                    AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                                                    AND (@grupo='(Todos)' OR grupo.grupo=@grupo OR (@grupo='Grupo 5' AND grupo.grupo IS NULL))
                        ) ORDER BY nombre
                        ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DGrupo" Name="grupo" PropertyName="SelectedValue" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

