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
            <td><asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM dbo.admEntidad WHERE entEPS=1 ORDER BY 2">
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
            <asp:DropDownList ID="DIntensidad" runat="server" DataSourceID="SIntensidad" 
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
            <asp:DropDownList ID="DCategoria" runat="server" DataSourceID="SCategoria" 
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
            <asp:BoundField HeaderText="CIE10" DataField="cie10" SortExpression="cie10" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Pago directo" DataField="pdirDescripcion" SortExpression="pdirDescripcion" />
            <asp:BoundField HeaderText="Tipo evento" DataField="tipEDescripcion" SortExpression="tipEDescripcion" />
            <asp:BoundField HeaderText="Actividades (Autorizadas)" DataField="detalles" SortExpression="detalles" ItemStyle-Wrap="false"/>
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
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT locId id, locDescripcion nombre FROM admLocalidad">
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
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="SELECT phdPaciente.pacDocumento,phdPaciente.pacNombres,phdPaciente.pacBarrio,phdPaciente.pacDireccion,phdPaciente.pacId
		                    ,phdPaciente.pacTelefono,phdPaciente.pacFecIngPrograma,pdirDescripcion,phdTipoEvento.tipEDescripcion
                            ,admEntidad.entNombre,phdPaciente.pacFechaNac
                            ,admLocalidad.locDescripcion
                            ,phdPaciente.locId
                            ,detalles
							,(SELECT phdCIE10.cieCodDx + '-'  + phdCIE10.cirDescripcion + ',_' FROM phdCIE10 
								WHERE 
								phdCIE10.cieCodDx=phdPaciente.cieCodDx OR phdCIE10.cieCodDx=phdPaciente.cieCodDx_1 OR phdCIE10.cieCodDx=phdPaciente.cieCodDx_2
								FOR XML PATH('')) AS cie10
                            FROM phdPaciente
                            LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)
                            LEFT JOIN admLocalidad ON (admLocalidad.locId=phdPaciente.locId) 
							LEFT JOIN phdPagodirecto ON (phdPaciente.pdirId = phdPagodirecto.pdirId)
							LEFT JOIN phdTipoEvento ON (phdPaciente.tipECod = phdTipoEvento.tipECod)
                            CROSS APPLY
                            (
                                SELECT ISNULL(phdActividad.actDescripcion,'%%'+ CAST(phdDetalleAutorizacion.actId AS VARCHAR(9))) 
                                    + ISNULL(' [$$' + CAST(phdDetalleAutorizacion.intensidad AS VARCHAR(9)) + ']','')
                                    + ' (' + CAST(ISNULL(phdDetalleAutorizacion.autNumSesiones,0) AS VARCHAR(9))
                                    + '),_ '
                                FROM phdAutorizacion
								LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero = phdAutorizacion.autNumero)
                                LEFT JOIN phdActividad ON (phdActividad.actId=phdDetalleAutorizacion.actId)
                                WHERE 
                                (phdAutorizacion.autfecha BETWEEN @inicio AND @fin
                                OR ISNULL(phdAutorizacion.autFechaVenc,phdAutorizacion.autfecha+30) BETWEEN @inicio AND @fin)
                                -- ISNULL(phdAutorizacion.autFechaVenc,phdAutorizacion.autfecha+30)>=GETDATE()-1
								AND phdAutorizacion.pacId=phdPaciente.pacId 
								AND ('@area'='0' OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.actId IN (@area)))
								AND (@procedimiento=0 OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.actId=@procedimiento))
								AND (@intensidad=0 OR phdDetalleAutorizacion.intensidad=@intensidad)
								AND ('@categoria'='0' OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.intensidad IN (@categoria)))
                                FOR XML PATH('')
                            ) pre_trimmed (detalles)
                            WHERE 
                            -- phdPaciente.estId=1 
                            -- AND 
                            (@asegurador=0 OR phdPaciente.entId=@asegurador)
                            AND detalles IS NOT NULL
                            ORDER BY phdPaciente.pacNombres">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DIntensidad" PropertyName="SelectedValue" Name="intensidad" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SDiario" runat="server" 
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="
                WITH nums (i)
                        AS
                        (
                        SELECT i = 0
                        UNION all
                        SELECT i + 1 FROM nums WHERE i < 1000
                        )
                        SELECT CONVERT(char(10), a.dte,103) AS fecha,COUNT(DISTINCT p.pacId) AS total
                        FROM (SELECT dte = dateadd(dd,nums.i,@inicio) FROM nums) a
                        LEFT JOIN (
                        SELECT phdPaciente.pacId,phdAutorizacion.autFecha,ISNULL(phdAutorizacion.autFechaVenc,phdAutorizacion.autfecha+30) AS autFechaVenc
                                                    FROM phdAutorizacion
							                        LEFT JOIN phdPaciente ON (phdAutorizacion.pacId= phdPaciente.pacId)
							                        LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)
							                        LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero = phdAutorizacion.autNumero)
                                                    LEFT JOIN phdActividad ON (phdActividad.actId=phdDetalleAutorizacion.actId)
                                                    WHERE 
							                        (phdAutorizacion.autfecha BETWEEN @inicio AND @fin
                                                        OR ISNULL(phdAutorizacion.autFechaVenc,phdAutorizacion.autfecha+30) BETWEEN @inicio AND @fin)
								                    AND ('@area'='0' OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.actId IN (@area)))
								                    AND (@procedimiento=0 OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.actId=@procedimiento))
								                    AND (@intensidad=0 OR phdDetalleAutorizacion.intensidad=@intensidad)
            								        AND ('@categoria'='0' OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.intensidad IN (@categoria)))

                                                    AND (@asegurador=0 OR phdPaciente.entId=@asegurador)
                        ) AS p ON (a.dte BETWEEN P.autFecha AND p.autFechaVenc)
                        WHERE a.dte <= @fin
                        GROUP BY a.dte
                        ORDER BY a.dte
                        OPTION(MAXRECURSION 1000)">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DIntensidad" PropertyName="SelectedValue" Name="intensidad" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SMensual" runat="server" 
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="
                WITH nums (i)
                        AS
                        (
                        SELECT i = 0
                        UNION all
                        SELECT i + 1 FROM nums WHERE i < 1000
                        )
                        SELECT CAST(DATEPART(MM,a.dte) AS VARCHAR) + '/' + CAST(DATEPART(YY,a.dte) AS VARCHAR) AS fecha,COUNT(DISTINCT p.pacId) AS total
                        FROM (SELECT dte = dateadd(dd,nums.i,@inicio) FROM nums) a
                        LEFT JOIN (
                        SELECT phdPaciente.pacId,phdAutorizacion.autFecha,ISNULL(phdAutorizacion.autFechaVenc,phdAutorizacion.autfecha+30) AS autFechaVenc
                                                    FROM phdAutorizacion
							                        LEFT JOIN phdPaciente ON (phdAutorizacion.pacId= phdPaciente.pacId)
							                        LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)
							                        LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero = phdAutorizacion.autNumero)
                                                    LEFT JOIN phdActividad ON (phdActividad.actId=phdDetalleAutorizacion.actId)
                                                    WHERE 
							                        (phdAutorizacion.autfecha BETWEEN @inicio AND @fin
                                                        OR ISNULL(phdAutorizacion.autFechaVenc,phdAutorizacion.autfecha+30) BETWEEN @inicio AND @fin)
								                    AND ('@area'='0' OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.actId IN (@area)))
								                    AND (@procedimiento=0 OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.actId=@procedimiento))
								                    AND (@intensidad=0 OR phdDetalleAutorizacion.intensidad=@intensidad)
            								        AND ('@categoria'='0' OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.intensidad IN (@categoria)))

                                                    AND (@asegurador=0 OR phdPaciente.entId=@asegurador)
                        ) AS p ON (CAST(DATEPART(MM,a.dte) AS VARCHAR) + '/' + CAST(DATEPART(YY,a.dte) AS VARCHAR)=CAST(DATEPART(MM,p.autFecha) AS VARCHAR) + '/' + CAST(DATEPART(YY,p.autFecha) AS VARCHAR) OR 
                            CAST(DATEPART(MM,a.dte) AS VARCHAR) + '/' + CAST(DATEPART(YY,a.dte) AS VARCHAR)=CAST(DATEPART(MM,p.autFechaVenc) AS VARCHAR) + '/' + CAST(DATEPART(YY,p.autFechaVenc) AS VARCHAR))
                        WHERE a.dte <= @fin
                        GROUP BY CAST(DATEPART(MM,a.dte) AS VARCHAR) + '/' + CAST(DATEPART(YY,a.dte) AS VARCHAR)
                        ORDER BY fecha
                        OPTION(MAXRECURSION 1000)">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DIntensidad" PropertyName="SelectedValue" Name="intensidad" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>