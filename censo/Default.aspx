<%@ Page Title="Censo" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="censo_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        addDialog('#<%= PLocalidad.ClientID%>', "#dLocalidad");
    });
    $(function() {
        /*$("#dgrafica").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });*/
        $("#<%= TProcedimiento.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetMedicamentos",
                    data: "{ 'q': '" + request.term + "', 't': '173' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            select: function(event, ui) {
                $("#<%= TProcedimientoID.ClientID %>").val(ui.item.value);
                $("#<%= TProcedimiento.ClientID %>").val(ui.item.label);
                return false;
            },
            search: function(event, ui) {
                $("#<%= TProcedimientoID.ClientID %>").val("");
                // $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
            }
        }).change(function() { if ($(this).val() == "") $("#<%= TProcedimientoID.ClientID %>").val(""); });
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
            <td>Actividad o CUPS</td>
            <td>Área</td>
            <td>Horas</td>
            <td>Categoría</td>
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
            <td>
            <asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hide"></asp:TextBox>
            </td>
            <td><asp:DropDownList ID="DArea" runat="server" DataSourceID="SArea" CssClass="anchomaxcombo" 
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
            <asp:DropDownList ID="DIntensidad" runat="server" DataSourceID="SIntensidad" CssClass="anchomaxcombo"
                DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
            </asp:DropDownList>
            <asp:SqlDataSource ID="SIntensidad" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=21 AND szReservado IS NULL ORDER BY nombre">
            </asp:SqlDataSource>
            </td>
            <td>
            <asp:DropDownList ID="DCategoria" runat="server" DataSourceID="SCategoria" CssClass="anchomaxcombo"
                DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
            </asp:DropDownList>
            <asp:SqlDataSource ID="SCategoria" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT CAST(GROUP_CONCAT(categoria_censo.hora) AS CHAR) AS id, nombre FROM varios LEFT JOIN categoria_censo ON (categoria_censo.categoria=varios.id) WHERE tipo=33 AND szReservado IS NULL GROUP BY varios.id ORDER BY nombre;">
            </asp:SqlDataSource>
            </td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
        </tr>
        </table>
    </asp:Panel>
    Tipo: <asp:DropDownList runat="server" ID="DTipo" AutoPostBack="true">
        <asp:ListItem Text="Diario" Value="0"></asp:ListItem>
        <asp:ListItem Text="Mensual" Value="1"></asp:ListItem>
    </asp:DropDownList>
    <div id="chart_div" style="width: 1000px; height: 300px;"></div>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart"] });
        google.setOnLoadCallback(drawChart);
        function drawChart() {
            var data = google.visualization.arrayToDataTable([
             <asp:Repeater ID="RGrafica" DataSourceID="SDiario" runat="server">
                    <HeaderTemplate>['Día', 'Cantidad']</HeaderTemplate>
                    <ItemTemplate>,['<%# Eval("fecha")%>', <%# Eval("total")%>]</ItemTemplate>
                </asp:Repeater>   
            ]
            );
            var options = { title: 'Pacientes' };
            var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
            chart.draw(data, options);
        }
    </script>
    <br />
    <asp:UpdatePanel runat="server" ID="PResultados">
    <ContentTemplate>
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" 
        AllowPaging="True" PageSize="50" AllowSorting="True" 
            OnRowDataBound="GResultados_RowDataBound" 
            DataKeyNames="pacId">
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Documento" DataNavigateUrlFields="pacId" SortExpression="pacDocumento"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-HorizontalAlign="Right" />
            <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" DataNavigateUrlFields="pacId" SortExpression="pacNombres"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre"/>
            <asp:BoundField HeaderText="Edad" DataField="pacFechaNac" SortExpression="pacFechaNac" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Direccion" DataField="pacDireccion" SortExpression="pacDireccion" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Barrio" DataField="pacBarrio" SortExpression="pacBarrio" ItemStyle-Wrap="false"/>
            <asp:TemplateField HeaderText="Localidad" InsertVisible="False" SortExpression="locDescripcion">
                <ItemTemplate>
                    <asp:LinkButton ID="LLocalidad" runat="server" CausesValidation="False" CommandName='<%# Bind("pacId") %>' CommandArgument='<%# Bind("locId") %>' Text='<%# Bind("locDescripcion") %>' OnClick="LLocalidad_Click" ></asp:LinkButton>
                </ItemTemplate>
                <ItemStyle Wrap="False" />
            </asp:TemplateField>
            <asp:BoundField HeaderText="Teléfono" DataField="pacTelefono" SortExpression="pacTelefono" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Inicio programa" DataField="pacFecIngPrograma" SortExpression="pacFecIngPrograma" DataFormatString="{0:d}" />
            <asp:BoundField HeaderText="CIE10" DataField="cie10" SortExpression="cie10" ItemStyle-Wrap="false" HtmlEncode="false" />
            <asp:BoundField HeaderText="Pago directo" DataField="pdirDescripcion" SortExpression="pdirDescripcion" />
            <asp:BoundField HeaderText="Tipo evento" DataField="tipEDescripcion" SortExpression="tipEDescripcion" />
            <asp:BoundField HeaderText="Actividades (Autorizadas)" DataField="detalles" SortExpression="detalles" ItemStyle-Wrap="false" HtmlEncode="false"/>
        </Columns>
    </asp:GridView>
    </div>
    <div align="right">
        <asp:Label runat="server" ID="LTotal"></asp:Label>
    </div>
    <asp:Panel runat="server" ID="PLocalidad" Visible="false">
        <asp:HiddenField runat="server" ID="HPaciente" />
        <div id="dLocalidad" title="Localidad" class="hide">
        <table>
            <tr>
                <td>Localidad</td>
                <td><asp:DropDownList ID="DLocalidad" runat="server" 
                                DataSourceID="SLocalidad" DataTextField="nombre"
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SLocalidad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT locId id, locDescripcion nombre FROM localidad">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td colspan="2" align="right">
                    <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                        onclick="BAceptar_Click" />
                    <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                        CausesValidation="false" onclick="BCancelar_Click"/>
                </td>
            </tr>
        </table>
        </div>
    </asp:Panel>
    </ContentTemplate>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT paciente.pacDocumento,paciente.pacNombres,paciente.pacBarrio,paciente.pacDireccion,paciente.pacId
		                    ,paciente.pacTelefono,paciente.pacFecIngPrograma,pdirDescripcion,tipo_evento.tipEDescripcion
                            ,asegurador.entNombre,paciente.pacFechaNac
                            ,localidad.locDescripcion
                            ,paciente.locId
                            ,GROUP_CONCAT(CONCAT(medicamentos.nombre, ' (', IFNULL(autorizacion_detalle.autNumSesiones,0),'-',IFNULL(autorizacion_detalle.autSesionesDia,0),')') SEPARATOR '<br/>') AS detalles
							
								,'' AS cie10
                            FROM autorizacion
                            LEFT JOIN paciente ON (autorizacion.pacId=paciente.pacId)
                            LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            LEFT JOIN localidad ON (localidad.locId=paciente.locId) 
							LEFT JOIN paciente_tipo_pago ON (paciente.pdirId = paciente_tipo_pago.pdirId)
							LEFT JOIN tipo_evento ON (paciente.tipECod = tipo_evento.tipECod)
							LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
							LEFT JOIN medicamentos ON (medicamentos.id=autorizacion_detalle.actId)
                            WHERE 
                            (autorizacion.autfecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                OR IFNULL(autorizacion.autFechaVenc,autorizacion.autfecha+INTERVAL 30 DAY) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y'))
                            AND (@asegurador=0 OR paciente.entId=@asegurador)
							AND autorizacion.pacId=paciente.pacId 
							AND ('@area'='0' OR EXISTS (SELECT 1 FROM autorizacion_detalle WHERE autorizacion_detalle.autNumero=autorizacion.autNumero AND autorizacion_detalle.actId IN (@area)))
							AND (@procedimiento=0 OR EXISTS (SELECT 1 FROM autorizacion_detalle WHERE autorizacion_detalle.autNumero=autorizacion.autNumero AND autorizacion_detalle.actId=@procedimiento))
							AND (@intensidad=0 OR autorizacion_detalle.intensidad=@intensidad)
							AND ('@categoria'='0' OR EXISTS (SELECT 1 FROM autorizacion_detalle WHERE autorizacion_detalle.autNumero=autorizacion.autNumero AND autorizacion_detalle.intensidad IN (@categoria)))
					        GROUP BY paciente.pacId
                            ORDER BY paciente.pacNombres">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DIntensidad" PropertyName="SelectedValue" Name="intensidad" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SDiario" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT @curRow:=@curRow+INTERVAL 1 DAY AS fecha
                        ,(SELECT COUNT(DISTINCT autorizacion.pacId) FROM autorizacion 
	                        LEFT JOIN paciente ON (autorizacion.pacId= paciente.pacId)
                           LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                           LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero = autorizacion.autNumero)
	                        WHERE @curRow BETWEEN autFecha AND IFNULL(autFechaVenc,autorizacion.autfecha+INTERVAL 30 DAY)
                             AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                             AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                             AND (@intensidad=0 OR autorizacion_detalle.intensidad=@intensidad)
                             AND ('@categoria'='0' OR autorizacion_detalle.intensidad IN (@categoria))
		                        AND (@asegurador=0 OR paciente.entId=@asegurador)
                        ) AS total
                        FROM varios,(SELECT @curRow:=STR_TO_DATE(@inicio, '%d/%m/%Y')-INTERVAL 1 DAY) r
                        WHERE @curRow<STR_TO_DATE(@fin, '%d/%m/%Y')">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DIntensidad" PropertyName="SelectedValue" Name="intensidad" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SMensual" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT @curRow:=@curRow+INTERVAL 1 MONTH AS fecha
                        ,(SELECT COUNT(DISTINCT autorizacion.pacId) FROM autorizacion 
	                        LEFT JOIN paciente ON (autorizacion.pacId= paciente.pacId)
                           LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                           LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero = autorizacion.autNumero)
	                        WHERE 
	                        (CONCAT(YEAR(@curRow),LPAD(MONTH(@curRow),2,'0'))=CONCAT(YEAR(autFecha),LPAD(MONTH(autFecha),2,'0'))
		                        OR CONCAT(YEAR(@curRow),LPAD(MONTH(@curRow),2,'0'))=CONCAT(YEAR(IFNULL(autFechaVenc,autorizacion.autfecha+INTERVAL 30 DAY)),LPAD(MONTH(IFNULL(autFechaVenc,autorizacion.autfecha+INTERVAL 30 DAY)),2,'0')))
                             AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                             AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                             AND (@intensidad=0 OR autorizacion_detalle.intensidad=@intensidad)
                             AND ('@categoria'='0' OR autorizacion_detalle.intensidad IN (@categoria))
		                        AND (@asegurador=0 OR paciente.entId=@asegurador)
                        ) AS total
                        FROM varios,(SELECT @curRow:=STR_TO_DATE(@inicio, '%d/%m/%Y')-INTERVAL 1 MONTH) r
                        WHERE CONCAT(YEAR(@curRow),LPAD(MONTH(@curRow),2,'0'))<CONCAT(YEAR(STR_TO_DATE(@fin, '%d/%m/%Y')),LPAD(MONTH(STR_TO_DATE(@fin, '%d/%m/%Y')),2,'0'))">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DIntensidad" PropertyName="SelectedValue" Name="intensidad" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>