<%@ Page Title="Cuentas médicas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="cuentasmedicas.aspx.cs" Inherits="facturacion_cuentasmedicas" %>

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
            <td nowrap=nowrap>Actividad o CUPS</td>
            <td>Área</td>
            <td>Intensidad</td>
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
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" onclick="BBuscar_Click" /></td>
        </tr>
        </table>
    </asp:Panel>
<asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Visible="false"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" 
        AllowSorting="True" OnRowDataBound="GResultados_RowDataBound" ShowFooter="true">
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField HeaderText="Autorización" SortExpression="autorizacion" DataTextField="autorizacion" DataNavigateUrlFields="autorizacion" Target="_blank" DataNavigateUrlFormatString="~/facturacion/facturacion.aspx?aut={0}" />
            <asp:HyperLinkField HeaderText="Factura" SortExpression="factura" DataTextField="factura" DataNavigateUrlFields="autorizacion" Target="_blank" DataNavigateUrlFormatString="~/facturacion/facturacion.aspx?aut={0}" />
            <asp:HyperLinkField HeaderText="Fecha" SortExpression="fecha" DataTextField="fecha" DataNavigateUrlFields="autorizacion" Target="_blank" DataNavigateUrlFormatString="~/facturacion/facturacion.aspx?aut={0}" DataTextFormatString="{0:d}" />
            <asp:BoundField HeaderText="Radicación" SortExpression="radicacion" DataField="radicacion" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Valor facturado" SortExpression="facturado" DataField="facturado" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Glosa" SortExpression="glosa" DataField="glosa" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Glosa aceptada" SortExpression="glosa_aceptada" DataField="glosa_aceptada" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Glosa soportada" SortExpression="glosa_soportado" DataField="glosa_soportado" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Servicios no facturados" SortExpression="nofacturado" DataField="nofacturado" />
            <asp:BoundField HeaderText="Sin seguimiento" SortExpression="" DataField="" />
            <asp:BoundField HeaderText="Glosa sin seguimiento" SortExpression="glosa_seg" DataField="glosa_seg" />
            <asp:BoundField HeaderText="Glosas" SortExpression="causal_glosa" DataField="causal_glosa" HtmlEncode="false" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Devolución" SortExpression="causal_devolucion" DataField="causal_devolucion" HtmlEncode="false" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Valor devolución" SortExpression="devolucion" DataField="devolucion" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
        </Columns>
    </asp:GridView>
    <div align=right>
        <asp:Label runat="server" ID="LResultados"></asp:Label>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                            facturacion_autorizacion.autorizacion
                            ,facturacion_autorizacion.factura
                            ,factura.fecha
                            ,factura.radicacion
                            ,servicios.valor AS facturado
                            ,SUM(facturacion_autorizacion_glosa.valor) AS glosa
                            ,SUM(facturacion_autorizacion_glosa.valor_aceptado) AS glosa_aceptada
                            ,SUM(facturacion_autorizacion_glosa.valor_soportado) AS glosa_soportado
                            ,servicios.autorizado-servicios.cantidad AS nofacturado
                            ,IF(SUM(facturacion_autorizacion_glosa.valor)>0 AND facturacion_autorizacion.glosa_conciliacion IS NULL, 'Si', 'No') AS glosa_seg
                            ,GROUP_CONCAT(CONCAT(glosa.nombre,' ($',CAST(FORMAT(facturacion_autorizacion_glosa.valor,0) AS CHAR),')') SEPARATOR '<br />') AS causal_glosa
                            ,devolucion.nombre AS causal_devolucion
                            ,devolucion.valor AS devolucion
                            FROM facturacion_autorizacion
                            LEFT JOIN factura ON (facturacion_autorizacion.factura=factura.factura)
                            LEFT JOIN (SELECT autorizacion,SUM(valor) AS valor,SUM(cantidad) AS cantidad,SUM(autorizado) AS autorizado 
                                        FROM facturacion_autorizacion_servicio 
                                        GROUP BY autorizacion) AS servicios 
                                            ON (servicios.autorizacion=facturacion_autorizacion.autorizacion)
                            LEFT JOIN facturacion_autorizacion_glosa ON (facturacion_autorizacion.autorizacion=facturacion_autorizacion_glosa.autorizacion)
                            LEFT JOIN (
                                SELECT factura_devolucion.factura,SUM(factura_devolucion.valor) AS valor,GROUP_CONCAT(CONCAT(devolucion.nombre,' ($',CAST(FORMAT(factura_devolucion.valor,0) AS CHAR),')') SEPARATOR '<br />') AS nombre 
                                    FROM factura_devolucion 
                                    LEFT JOIN varios AS devolucion ON (factura_devolucion.causal=devolucion.id)
                                    GROUP BY factura
                            ) AS devolucion ON (devolucion.factura=facturacion_autorizacion.factura)
                            -- factura_devolucion ON (facturacion_autorizacion.factura=factura_devolucion.factura)
                            LEFT JOIN varios AS glosa ON (facturacion_autorizacion_glosa.causal=glosa.id)
                            WHERE 
                            fecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND (@asegurador=0 OR facturacion_autorizacion.entidad=@asegurador)
                            AND EXISTS (SELECT 1 FROM facturacion_autorizacion_servicio WHERE facturacion_autorizacion.autorizacion=facturacion_autorizacion_servicio.autorizacion 
                                    AND (@procedimiento=0 OR facturacion_autorizacion_servicio.procedimiento=@procedimiento)
                                    AND (@intensidad=0 OR facturacion_autorizacion_servicio.intensidad=@intensidad)
                                    AND ('@area'='0' OR facturacion_autorizacion_servicio.procedimiento IN (@area))
                            )
                            GROUP BY facturacion_autorizacion.autorizacion
                            ORDER BY factura.fecha
                            ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DIntensidad" PropertyName="SelectedValue" Name="intensidad" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

