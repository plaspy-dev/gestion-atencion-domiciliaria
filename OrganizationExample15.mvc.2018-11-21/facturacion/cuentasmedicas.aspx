<%@ Page Title="Cuentas médicas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="facturacion_cuentasmedicas" Codebehind="cuentasmedicas.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
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
            <td>Inicio
                <asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TInicio" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Fin
                <asp:RequiredFieldValidator ControlToValidate="TFin" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFin" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Asegurador</td>
            <td nowrap=nowrap>Actividad o CUPS</td>
            <td>Área</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox></td>
            <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox></td>
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
            <asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hidet"></asp:TextBox>
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
            <asp:HyperLinkField HeaderText="Autorización" SortExpression="autorizacion" DataTextField="autorizacion" DataNavigateUrlFields="factura" Target="_blank" DataNavigateUrlFormatString="~/facturacion/factura.aspx?fid={0}" FooterStyle-HorizontalAlign="Right" />
            <asp:HyperLinkField HeaderText="Factura" SortExpression="factura" DataTextField="factura" DataNavigateUrlFields="factura" Target="_blank" DataNavigateUrlFormatString="~/facturacion/factura.aspx?fid={0}" FooterStyle-HorizontalAlign="Right" />
            <asp:HyperLinkField HeaderText="Fecha" SortExpression="fecha" DataTextField="fecha" DataNavigateUrlFields="factura" Target="_blank" DataNavigateUrlFormatString="~/facturacion/factura.aspx?fid={0}" DataTextFormatString="{0:d}" />
            <asp:BoundField HeaderText="Total facturado" SortExpression="valor" DataField="valor" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Total Valor Glosa" SortExpression="glosa" DataField="glosa" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Total Valor Glosa Aceptada" SortExpression="glosa_aceptada" DataField="glosa_aceptada" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Total Valor Glosa Soportada" SortExpression="glosa_soportado" DataField="glosa_soportado" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Servicios no facturados" SortExpression="nofacturado" DataField="nofacturado" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />
            <asp:BoundField HeaderText="Factura sin seguimiento" SortExpression="sinseguimiento" DataField="sinseguimiento" />
            <asp:BoundField HeaderText="Glosa sin seguimiento" SortExpression="glosa_seg" DataField="glosa_seg" />
            <asp:BoundField HeaderText="Causales de Glosa" SortExpression="causal_glosa" DataField="causal_glosa" HtmlEncode="false" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Valores de las causales de Glosa: desglosada por causal" SortExpression="valor_glosas" DataField="valor_glosas" HtmlEncode="false" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" />

            <asp:BoundField HeaderText="Causales de devoluciones" SortExpression="causal_devolucion" DataField="causal_devolucion" HtmlEncode="false" ItemStyle-Wrap="false" />
        </Columns>
    </asp:GridView>
    <div align=right>
        <asp:Label runat="server" ID="LResultados"></asp:Label>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                            GROUP_CONCAT(facturacion_autorizacion.autorizacion SEPARATOR '<br />') AS autorizacion
                            ,facturacion_autorizacion.factura
                            ,factura.fecha
                            ,factura.radicacion
                            ,factura.valor
                            ,glosa.glosa
                            ,glosa.glosa_aceptada
                            ,glosa.glosa_soportado
                            ,SUM(facturacion_autorizacion_servicio.autorizado)-SUM(facturacion_autorizacion_servicio.cantidad) AS nofacturado
                            ,IF(factura.radicacion IS NULL OR (factura.vencimiento>SYSDATE() AND factura.pago IS NULL),'Si', 'No') AS sinseguimiento
                            ,IF(IFNULL(glosa.glosa, 0)>0 AND facturacion_autorizacion.glosa_conciliacion IS NULL, 'Si', 'No') AS glosa_seg
                            ,glosa.causal_glosa
                            ,glosa.valor_glosas
                            ,devolucion.nombre AS causal_devolucion
                            FROM factura
                            LEFT JOIN facturacion_autorizacion ON (facturacion_autorizacion.factura=factura.factura)
							LEFT JOIN facturacion_autorizacion_servicio ON (facturacion_autorizacion_servicio.autorizacion=facturacion_autorizacion.autorizacion)
                            LEFT JOIN (
                                SELECT 
                                    factura_glosa.factura
                                    ,SUM(factura_glosa.valor) AS glosa
			                        ,SUM(factura_glosa.valor_aceptado) AS glosa_aceptada
			                        ,SUM(factura_glosa.valor_soportado) AS glosa_soportado
			                        ,GROUP_CONCAT(glosa.nombre SEPARATOR '<br />') AS causal_glosa
			                        ,GROUP_CONCAT(CONCAT('$', FORMAT(factura_glosa.valor, 0)) SEPARATOR '<br />') AS valor_glosas
									        FROM factura_glosa
									        LEFT JOIN varios AS glosa ON (glosa.id=factura_glosa.causal)
									        GROUP BY factura_glosa.factura
							) AS glosa ON (glosa.factura=factura.factura)
                            LEFT JOIN (
                                SELECT factura_devolucion.factura,GROUP_CONCAT(devolucion.nombre SEPARATOR '<br />') AS nombre 
                                    FROM factura_devolucion 
                                    LEFT JOIN factura_causal_devolucion ON (factura_causal_devolucion.factura_devolucion=factura_devolucion=id)
                                    LEFT JOIN varios AS devolucion ON (factura_causal_devolucion.causal=devolucion.id)
                                    GROUP BY factura
                            ) AS devolucion ON (devolucion.factura=facturacion_autorizacion.factura)

                            WHERE 
                            DATE(factura.fecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND (@asegurador=0 OR facturacion_autorizacion.entidad=@asegurador)
                            /*AND EXISTS (SELECT 1 FROM facturacion_autorizacion_servicio WHERE facturacion_autorizacion.autorizacion=facturacion_autorizacion_servicio.autorizacion 
                                    AND (@procedimiento=0 OR facturacion_autorizacion_servicio.procedimiento=@procedimiento)
                                    AND ('@area'='0' OR facturacion_autorizacion_servicio.procedimiento IN (@area))
                            )*/
                            GROUP BY factura.factura
                            ORDER BY factura.fecha
                            ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                     <asp:ControlParameter ControlID="DArea" Name="area" PropertyName="SelectedValue" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

