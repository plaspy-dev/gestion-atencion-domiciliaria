<%@ Page Title="Consulta autorizaciones" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="consulta.aspx.cs" Inherits="admisiones_consulta" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
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
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" 
        AllowPaging="True" PageSize="50" AllowSorting="True" OnRowDataBound="GResultados_RowDataBound" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="autNumero" HeaderText="Autorización" 
                DataNavigateUrlFields="autNumero" 
                DataNavigateUrlFormatString="~/admisiones/autorizaciones.aspx?aut={0}" SortExpression="autNumero" />
            <asp:BoundField HeaderText="Fecha" DataField="autFecha" SortExpression="autFecha" DataFormatString="{0:d}" />
            <asp:BoundField HeaderText="Vencimiento" DataField="autFechaVenc" SortExpression="autFechaVenc" DataFormatString="{0:d}" />
            <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Documento" DataNavigateUrlFields="pacId" SortExpression="pacDocumento"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-HorizontalAlign="Right" />
            <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" DataNavigateUrlFields="pacId" SortExpression="pacNombres"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Barrio" DataField="pacBarrio" SortExpression="pacBarrio"/>
            <asp:BoundField HeaderText="Direccion" DataField="pacDireccion" SortExpression="pacDireccion"/>
            <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre"/>
            <asp:BoundField HeaderText="Actividades (Autorizadas-Programadas-Diarias)" DataField="detalles" SortExpression="detalles" ItemStyle-Wrap="false" HtmlEncode="false"/>
            <asp:BoundField HeaderText="Grupo" DataField="grupo" SortExpression="grupo"/>
            <asp:BoundField HeaderText="Observaciones" DataField="autObservaciones" SortExpression="autObservaciones"/>
        </Columns>
    </asp:GridView>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT autorizacion.autNumero,autorizacion.autFecha,autorizacion.autFechaVenc,autorizacion.autObservaciones
                            ,paciente.pacDocumento,paciente.pacNombres,paciente.pacBarrio,paciente.pacDireccion,paciente.pacId
                            ,asegurador.entNombre
                            ,IFNULL(grupo.grupo,'Grupo 5') AS grupo
                            ,detalles.detalle AS detalles
                            ,(SELECT IFNULL(SUM(programacion.prgNumSesion),0) FROM programacion WHERE programacion.autNumero=autorizacion.autNumero) AS programadas
                            FROM autorizacion
                            LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                            LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            LEFT JOIN (SELECT autorizacion_detalle.autNumero,CASE WHEN SUM(autorizacion_detalle.autNumSesiones)<17 THEN 'Grupo 1' 
                                            WHEN SUM(autorizacion_detalle.autNumSesiones)<49 THEN 'Grupo 2'
                                            WHEN SUM(autorizacion_detalle.autNumSesiones)<75 THEN 'Grupo 3'
                                            ELSE 'Grupo 4' END AS grupo
                                            FROM autorizacion_detalle 
                                            WHERE 
                                            autorizacion_detalle.actId IN (5028,5029,5030,5031)
                                            GROUP BY autorizacion_detalle.autNumero) AS grupo ON (grupo.autNumero=autorizacion.autNumero)
                            LEFT JOIN (
                                        	SELECT autorizacion_detalle.autNumero
														 ,GROUP_CONCAT(CONCAT(medicamentos.nombre, ' (', IFNULL(autorizacion_detalle.autNumSesiones,0),'-',IFNULL(autorizacion_detalle.autSesionesDia,0),')') SEPARATOR '<br/>') AS detalle
                                            FROM autorizacion_detalle
	                                        LEFT JOIN medicamentos ON (medicamentos.id=autorizacion_detalle.actId)
	                                        GROUP BY autorizacion_detalle.autNumero
									) AS detalles ON (detalles.autNumero = autorizacion.autNumero)
                            WHERE autorizacion.autFecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND autorizacion.autActivo=1
                            AND (@asegurador=0 OR paciente.entId=@asegurador)
                            AND (@procedimiento=0 OR EXISTS (SELECT 1 FROM autorizacion_detalle WHERE  autorizacion_detalle.autNumero=autorizacion.autNumero AND  autorizacion_detalle.actId=@procedimiento))
                            AND ('@area'='0' OR EXISTS (SELECT 1 FROM autorizacion_detalle WHERE  autorizacion_detalle.autNumero=autorizacion.autNumero AND  autorizacion_detalle.actId IN (@area)))
                            AND (@grupo='(Todos)' OR grupo.grupo=@grupo OR (@grupo='Grupo 5' AND grupo.grupo IS NULL))
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
                                                    WHERE autorizacion.autFecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
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
                                                    WHERE autorizacion.autFecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                                    AND (@asegurador=0 OR paciente.entId=@asegurador)
                                                    AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                                                    AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                                                    AND (@grupo='(Todos)' OR grupo.grupo=@grupo OR (@grupo='Grupo 5' AND grupo.grupo IS NULL))
                        ) UNION (
                        SELECT autorizacion_detalle.actId,SUM(autNumSesiones)
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
                                                    WHERE autorizacion.autFecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                                    AND (@asegurador=0 OR paciente.entId=@asegurador)
                                                    AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                                                    AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                                                    AND (@grupo='(Todos)' OR grupo.grupo=@grupo OR (@grupo='Grupo 5' AND grupo.grupo IS NULL))
							                        GROUP BY autorizacion_detalle.actId
                        )UNION (
                        SELECT 5000000,SUM(autorizacion_detalle.autNumSesiones)
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
                                                    WHERE autorizacion.autFecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
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

