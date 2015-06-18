<%@ Page Title="Stock mínimo" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="estado.aspx.cs" Inherits="farmacia_estado" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">.GridHeader th {width: auto;} .anchomax { width: 150px; }</style>
    <script type="text/javascript">

        addFunctionToStart(function() {

            $("#<%= TProducto.ClientID %>").autocomplete({
                source: function(request, response) {
                    $.ajax({
                        url: "../webservices/servicios.asmx/GetProducto",
                        data: "{ 'q': '" + request.term + "', 'p': '' }",
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataFilter: function(data) { return data; },
                        success: function(data) {
                            response($.map(data.d, function(item) {
                                item.label = item.ProductoCompleto;
                                return item;
                            }))
                        },
                        error: function(XMLHttpRequest, textStatus, errorThrown) {
                            alert(textStatus + ":" + errorThrown);
                        }
                    });
                },
                autoFocus: true,
                minLength: 3,
                search: function() { $("#<%= TProductoID.ClientID %>").val(""); },
                select: function(event, ui) {

                    $("#<%= TProductoID.ClientID %>").val(ui.item.id);
                    $("#<%= TProducto.ClientID %>").val(ui.item.value);
                    return false;
                }
            }).change(function() {
                if ($(this).val() == "")
                    $("#<%= TProductoID.ClientID %>").val("");
            });
        });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td><asp:Label runat="server" ID="LVence" Text="Vence"></asp:Label></td>
            <td>Producto</td>
            <td><asp:Label runat="server" ID="LUbicacion" Text="Ubicación"></asp:Label></td>
        </tr>
        <tr>
            <td>
                <asp:TextBox ID="TVence" runat="server" CssClass="fecha" Text=""></asp:TextBox>
                <asp:RangeValidator ID="RangeValidator1" runat="server" Type="Date" ErrorMessage="Por favor ingrese una fecha valida." Text="*" MinimumValue="01/01/1900" MaximumValue="01/01/3000" SetFocusOnError="True" Display="Dynamic" ControlToValidate="TVence"></asp:RangeValidator>
            </td>
            <td>
                <asp:TextBox runat="server" ID="TProducto"></asp:TextBox><asp:TextBox runat="server" ID="TProductoID" CssClass="hide"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox runat="server" ID="TUbicacion" CssClass="tlote tubicacion"></asp:TextBox>
                <asp:TextBox runat="server" ID="TUbicacionID" CssClass="hide"></asp:TextBox>
            </td>
            <td nowrap=nowrap>
                <asp:CheckBox ID="CDetallado" runat="server" Text="Detallado" />
            </td>
            <td>
                <asp:CheckBox ID="CTodos" runat="server" Text="Productos sin existencias" />
            </td>
            <td><asp:Button ID="BBuscar" runat="server" Text="Actualizar" onclick="BBuscar_Click" /></td>
        </tr>
        </table>
    <br />
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron productos" 
        AllowPaging="True" PageSize="50" AllowSorting="True" 
        DataKeyNames="producto,lote,vence,ubicacion,estado" 
        onselectedindexchanged="GResultados_SelectedIndexChanged">
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField HeaderText="Código" DataNavigateUrlFormatString="~/farmacia/estado.aspx?pid={0}" DataNavigateUrlFields="producto" DataTextField="codigo" SortExpression="codigo" ItemStyle-HorizontalAlign="Right" />
            <asp:HyperLinkField HeaderText="Producto" DataNavigateUrlFormatString="~/farmacia/estado.aspx?pid={0}" DataNavigateUrlFields="producto" DataTextField="nombre" SortExpression="nombre" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
            <asp:BoundField HeaderText="Lote" DataField="lote" SortExpression="lote" />
            <asp:BoundField HeaderText="Vence" DataField="vence" SortExpression="vence" DataFormatString="{0:d}" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Cantidad" DataField="cantidad" SortExpression="cantidad" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Costo" DataField="costo" SortExpression="costo" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:C}" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Un." DataField="concentracion" SortExpression="concentracion" ItemStyle-Wrap="false" />
        </Columns>
    </asp:GridView>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT estado{0}.producto,SUM(estado{0}.cantidad) AS cantidad,medicamentos.nombre
                        ,medicamentos.concentracion,medicamentos.codigo
                        ,IFNULL(almacen.nombre,'(Ajustes)') AS almacen
                        ,'' AS lote,'' AS vence,'' AS szSerial,estado{0}.costo AS costo
                        ,IF(COUNT(DISTINCT estado{0}.ubicacion)=1,IFNULL(ubicacion.nombre,'(Ninguna)'), '(Multiple)') AS ubicacion
                        ,IF(COUNT(DISTINCT estado{0}.estado)=1,IFNULL(estado.nombre,'(Ninguno)'), '(Multiple)') AS estado
                        FROM estado{0} 
                        LEFT JOIN medicamentos ON (medicamentos.id=estado{0}.producto) 
                        LEFT JOIN ubicacion ON (ubicacion.id=estado{0}.ubicacion)
                        LEFT JOIN varios AS estado ON (estado.id=estado{0}.estado)
                        LEFT JOIN almacen ON (almacen.id={1})
                        WHERE 
                        (@vence=' ' OR STR_TO_DATE(@vence, '%d/%m/%Y')>=estado{0}.vence)
                        AND (@todos=1 OR estado{0}.cantidad>0)
                        AND (@ubicacion=-1 OR estado{0}.ubicacion=@ubicacion)
                        AND (@producto=0 OR medicamentos.id=@producto)
                        AND (@producto!=0 OR @nombre='_' OR medicamentos.codigo LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.nombre LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.forma LIKE CONCAT('%', @nombre, '%'))
                        GROUP BY medicamentos.id HAVING (@todos=1 OR SUM(estado{0}.cantidad)>0)
                        ORDER BY medicamentos.codigo,medicamentos.nombre">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TVence" PropertyName="Text" Name="vence" DefaultValue=" " />
                    <asp:ControlParameter ControlID="TProducto" PropertyName="Text" Name="nombre" DefaultValue="_" />
                    <asp:ControlParameter ControlID="TProductoID" PropertyName="Text" Name="producto" DefaultValue="0" />
                    <asp:ControlParameter ControlID="CTodos" PropertyName="Checked" Name="todos" />
                    <asp:ControlParameter ControlID="TUbicacionID" PropertyName="Text" Name="ubicacion" DefaultValue="-1" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SResultados1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT estado{0}.producto,estado{0}.lote
                        ,IF(estado{0}.vence='0000-00-00',NULL,estado{0}.vence) AS vence
                        ,SUM(estado{0}.cantidad) AS cantidad,medicamentos.nombre,estado{0}.szSerial,estado{0}.costo AS costo
                        ,medicamentos.concentracion,medicamentos.codigo
                        ,IFNULL(almacen.nombre,'(Ajustes)') AS almacen
                        ,IF(COUNT(DISTINCT estado{0}.ubicacion)=1,IFNULL(ubicacion.nombre,'(Ninguna)'), '(Multiple)') AS ubicacion
                        ,IF(COUNT(DISTINCT estado{0}.estado)=1,IFNULL(estado.nombre,'(Ninguno)'), '(Multiple)') AS estado
                        FROM estado{0} 
                        LEFT JOIN medicamentos ON (medicamentos.id=estado{0}.producto) 
                        LEFT JOIN ubicacion ON (ubicacion.id=estado{0}.ubicacion)
                        LEFT JOIN varios AS estado ON (estado.id=estado{0}.estado)
                        LEFT JOIN almacen ON (almacen.id={1})
                        WHERE 
                        (@todos=1 OR estado{0}.cantidad>0)
                        AND (@vence=' ' OR STR_TO_DATE(@vence, '%d/%m/%Y')>=estado{0}.vence)
                        AND (@ubicacion=-1 OR estado{0}.ubicacion=@ubicacion)
                        AND (@producto=0 OR medicamentos.id=@producto)
                        AND (@producto!=0 OR @nombre='_' OR medicamentos.codigo LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.nombre LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.forma LIKE CONCAT('%', @nombre, '%'))
                        GROUP BY estado{0}.producto,estado{0}.lote,estado{0}.vence,estado{0}.ubicacion,estado{0}.estado
                        ORDER BY medicamentos.codigo,medicamentos.nombre,estado{0}.lote,estado{0}.vence">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TVence" PropertyName="Text" Name="vence" DefaultValue=" " />
                    <asp:ControlParameter ControlID="TProducto" PropertyName="Text" Name="nombre" DefaultValue="_" />
                    <asp:ControlParameter ControlID="TProductoID" PropertyName="Text" Name="producto" DefaultValue="0" />
                    <asp:ControlParameter ControlID="CTodos" PropertyName="Checked" Name="todos" />
                    <asp:ControlParameter ControlID="TUbicacionID" PropertyName="Text" Name="ubicacion" DefaultValue="-1" />
                 </SelectParameters>
    </asp:SqlDataSource>
    </asp:Panel>
<asp:Panel runat="server" ID="PKardex" DefaultButton="BActualizar">
    <a href="estado.aspx"><< Estado</a><br /><br />
    <table>
        <tr>
            <td>Desde
            <asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator6" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha"></asp:TextBox></td>
            <td>Hasta
            <asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator2" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox></td>
            <td><asp:Button runat="server" ID="BActualizar" Text="Actualizar" 
                    onclick="BActualizar_Click" /></td>
        </tr>
    </table>
    <asp:Label runat="server" ID="LRotacion"></asp:Label><asp:Label runat="server" ID="LDias"></asp:Label>
    <div id="accordion">
        <h3><a href="#">Gráficas</a></h3>
        <div>
            <div id="chart_entradas" style="width: 1000px; height: 300px;"></div>
            <div id="chart_salidas" style="width: 1000px; height: 300px;"></div>
            <div id="chart_saldos" style="width: 1000px; height: 300px;"></div>
            <div runat="server" id="chart_costos" style="width: 1000px; height: 300px;"></div>
        </div>
    </div>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart"] });
        google.setOnLoadCallback(drawChart);
        function drawChart() {
            var data = google.visualization.arrayToDataTable([['Fecha', 'Costo']<asp:Literal runat="server" ID="LCostos"></asp:Literal>]);
            var options = { title: 'Costos' };
            var chart;
            try {
                chart = new google.visualization.AreaChart(document.getElementById('<%= chart_costos.ClientID %>'));
                chart.draw(data, options);
            } catch (e) {}
            
            data = google.visualization.arrayToDataTable([['Fecha', 'Cantidad']<asp:Literal runat="server" ID="LEntradas"></asp:Literal>]);
            options = { title: 'Entradas' };
            chart = new google.visualization.AreaChart(document.getElementById('chart_entradas'));
            chart.draw(data, options);
            
            data = google.visualization.arrayToDataTable([['Fecha', 'Cantidad']<asp:Literal runat="server" ID="LSalidas"></asp:Literal>]);
            options = { title: 'Salidas' };
            chart = new google.visualization.AreaChart(document.getElementById('chart_salidas'));
            chart.draw(data, options);
            
            data = google.visualization.arrayToDataTable([['Fecha', 'Cantidad']<asp:Literal runat="server" ID="LSaldos"></asp:Literal>]);
            options = { title: 'Saldos' };
            chart = new google.visualization.AreaChart(document.getElementById('chart_saldos'));
            chart.draw(data, options);
            $("#accordion").accordion({
                autoHeight: false,
                navigation: true,
                collapsible: true,
                active: false
            });
        }
    </script>
    <asp:GridView ID="GKardex" runat="server" DataSourceID="SKardex" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron productos" 
        AllowPaging="True" PageSize="50" AllowSorting="False" ShowFooter="true"
        onrowdatabound="GKardex_RowDataBound" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField HeaderText="Fecha" DataField="fecha" SortExpression="fecha" DataFormatString="{0:d}" />
            <asp:BoundField HeaderText="Concepto" DataField="concepto" SortExpression="concepto" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Entrada" DataField="entrada" SortExpression="entrada" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Costo U.E." DataField="costo" SortExpression="costo" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:C}" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Costo T.E." DataField="costot" SortExpression="costot" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:C}" FooterStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Salida" DataField="salida" SortExpression="salida" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Costo U.S." DataField="valor" SortExpression="valor" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Costo T.S." DataField="valor" SortExpression="valor" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Saldo" DataField="saldo" SortExpression="saldo" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-Wrap="false"  />
            <asp:BoundField HeaderText="Costo U." DataField="valor" SortExpression="valor" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Costo T." DataField="valor" SortExpression="valor" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false"/>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SKardex" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="(
                    SELECT 1 AS tipo,entrada{0}.fecha,entrada_items{0}.cantidad AS entrada,NULL AS salida,NULL AS saldo,entrada{0}.id AS concepto 
                    ,entrada_items{0}.ingreso
                    ,entrada_items{0}.costo AS costo
                    ,entrada_items{0}.costo*entrada_items{0}.cantidad AS costot
                    ,NULL AS valor
                    FROM entrada_items{0}
                    LEFT JOIN entrada{0} ON (entrada{0}.id=entrada_items{0}.entrada)
                    WHERE producto=@producto
                    AND DATE(ingreso) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                ) UNION ALL (
                    SELECT 2 AS tipo,traslado{0}.envio AS fecha,NULL AS entrada,traslado_items{0}.cantidad AS salida,NULL AS saldo,traslado{0}.id AS concepto  
                    ,traslado_items{0}.ingreso
                    ,NULL AS costo
                    ,NULL AS costot
                    ,NULL AS valor
                    FROM traslado_items{0}
                    LEFT JOIN traslado{0} ON (traslado{0}.id=traslado_items{0}.traslado)
                    WHERE 
                    producto=@producto
                    AND DATE(ingreso) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                ) UNION ALL (
                    SELECT 3 AS tipo,salida{0}.fecha AS fecha,NULL AS entrada,salida_items{0}.cantidad AS salida,NULL AS saldo,salida{0}.id AS concepto  
                    ,salida_items{0}.ingreso
                    ,NULL AS costo
                    ,NULL AS costot
                    ,NULL AS valor
                    FROM salida_items{0}
                    LEFT JOIN salida{0} ON (salida{0}.id=salida_items{0}.salida)
                    WHERE 
                    producto=@producto
                    AND DATE(ingreso) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                ) UNION ALL (
                    SELECT 6 AS tipo,devolucion{0}.fecha,devolucion_items{0}.cantidad AS entrada,NULL AS salida,NULL AS saldo,devolucion{0}.id AS concepto 
                    ,devolucion_items{0}.ingreso
                    ,devolucion_items{0}.costo AS costo
                    ,devolucion_items{0}.costo*devolucion_items{0}.cantidad AS costot
                    ,NULL AS valor
                    FROM devolucion_items{0}
                    LEFT JOIN devolucion{0} ON (devolucion{0}.id=devolucion_items{0}.devolucion)
                    WHERE producto=@producto
                    AND DATE(ingreso) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                ) UNION ALL (
                    SELECT -1 AS tipo, NULL AS fecha, NULL AS cantidad, NULL AS salida, NULL AS saldo, NULL AS concepto
                    ,'0000-00-00 00:00:00' AS ingreso
                    ,NULL AS costo
                    ,NULL AS costot
                    ,NULL AS valor
                )
                ORDER BY ingreso DESC;">
         <SelectParameters>
            <asp:QueryStringParameter Name="producto" QueryStringField="pid" />
            <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
            <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
         </SelectParameters>
    </asp:SqlDataSource>
</asp:Panel>
</asp:Content>