<%@ Page Title="Informe EPS" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informeeps.aspx.cs" Inherits="clinicaheridas_informeeps" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">.GridHeader th {width: auto !important;}</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Desde<asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
            <td>
                Hasta<asp:RequiredFieldValidator ControlToValidate="THasta" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Entidad</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox></td>
            <td>
                <asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" DataKeyNames="id"
                DataSourceID="SResultados" onrowdatabound="GResultados_RowDataBound" >
            <Columns>
                <asp:HyperLinkField DataTextField="fecha" Target="_blank" SortExpression="Fecha" HeaderText="Fecha" DataTextFormatString="{0:d}" DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/clinicaheridas/evolucion.aspx?hveid={0}" />
                <asp:BoundField DataField="paciente" HeaderText="Paciente" ItemStyle-Wrap="false" />
                <asp:BoundField DataField="tipo" HeaderText="Tipo de lesión" />
                <asp:BoundField DataField="tamano" HeaderText="Medidas (ancho X largo X profundidad) cms" />
                <asp:BoundField DataField="ubicacion_especifica" HeaderText="Localización anatómica" />
                <asp:BoundField DataField="bolsillo" HeaderText="Bolsillos (Ubicación segun manecillas del reloj)" />
                <asp:BoundField DataField="bolsillo_tamano" HeaderText="Profundidad del bolsillo (cm)" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="piel_circundante" HeaderText="Estado del tejido circundante" />
                <asp:BoundField DataField="estoma" HeaderText="Caracteristicas del estoma" />
                <asp:BoundField DataField="fistula" HeaderText="Fistulas de drenaje" />
                <asp:BoundField DataField="cantidad_afluente" HeaderText="Cantidad afluente 24h" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="predominante" HeaderText="Tejido predominante" />
                <asp:BoundField DataField="signoinfeccion" HeaderText="Signos de infección" />
                <asp:BoundField DataField="tipo_exudado" HeaderText="Exudado" />
                <asp:BoundField DataField="cantidad_exudado" HeaderText="Cantidad exudado" />
                <asp:BoundField DataField="formulada" HeaderText="Cantidad insumos" HtmlEncode="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="medicamento" HeaderText="Insumos" ItemStyle-Wrap="false" HtmlEncode="false" />
                <asp:TemplateField HeaderText="Foto">
                    <ItemTemplate>
                        <img src='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t={4}", ResolveUrl("~/archivo/imagen.ashx")
                                                        ,Eval("paciente"),Eval("id").ToString().Replace("v","")
                                                        ,Eval("idherida"),Eval("id").ToString()[0]=='v' ? "v" : "e") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
        <asp:SqlDataSource ID="SResultados" runat="server" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            SelectCommand="(SELECT 
                                CONCAT('v',valoracion_herida.id) AS id
                                ,valoracion_herida_herida.id AS idherida
                                ,valoracion_herida.paciente
                                ,valoracion_herida.fecha
                                ,'' AS tipo
                                ,CONCAT(valoracion_herida_herida.longitud, ' X '
                                ,valoracion_herida_herida.anchura, ' X '
                                ,valoracion_herida_herida.profundidad) AS tamano
                                ,valoracion_herida_herida.ubicacion_especifica
                                ,IFNULL(valoracion_herida_herida.bolsillo_ubicacion,'NO') AS bolsillo
                                ,valoracion_herida_herida.bolsillo_tamano
                                ,piel_circundante.nombre AS piel_circundante
                                ,valoracion_herida.ubicacion AS estoma
                                ,IF(valoracion_herida.fistula=1, 'Si', 'No') AS fistula
                                ,valoracion_herida.cantidad_afluente
                                ,valoracion_herida_herida.compacto
                                ,SUBSTRING_INDEX(GREATEST(
	                                CONCAT(IFNULL(compacto,0),'_compacto')
	                                ,CONCAT(IFNULL(fibrina,0),'_fibrina')
	                                ,CONCAT(IFNULL(epitelizacion,0),'_epitelizacion')
	                                ,CONCAT(IFNULL(escara,0),'_escara')
	                                ,CONCAT(IFNULL(granulacion,0),'_granulacion')
	                                ,CONCAT(IFNULL(hipergranulacion,0),'_hipergranulacion')
	                                ,CONCAT(IFNULL(limpio,0),'_limpio')
	                                ,CONCAT(IFNULL(necrosis,0),'_necrosis')
	                                ),'_',-1) AS predominante
                                ,IF(valoracion_herida.signos_infeccion=1, 'Si', 'No') AS signoinfeccion
                                ,tipo_exudado.nombre AS tipo_exudado
                                ,exudado.nombre AS cantidad_exudado
                                ,GROUP_CONCAT(medicamentos.nombre ORDER BY medicamento_formulacion.id SEPARATOR '<br/>') AS medicamento
                                ,GROUP_CONCAT(medicamento_formulacion.formulada ORDER BY medicamento_formulacion.id SEPARATOR '<br/>') AS formulada
                                FROM valoracion_herida
                                LEFT JOIN valoracion_herida_herida ON (valoracion_herida_herida.valoracion=valoracion_herida.id)
                                LEFT JOIN varios AS exudado ON (valoracion_herida_herida.exudado=exudado.id)
                                LEFT JOIN varios AS tipo_exudado ON (valoracion_herida_herida.tipo_exudado=tipo_exudado.id)
                                LEFT JOIN varios AS piel_circundante ON (piel_circundante.id=valoracion_herida_herida.piel_circundante)
                                LEFT JOIN formulacion ON (formulacion.paciente=valoracion_herida.paciente AND formulacion.fecha=valoracion_herida.fecha)
                                LEFT JOIN medicamento_formulacion ON (formulacion.id=medicamento_formulacion.formulacion)
                                LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento)
                                WHERE 
                                DATE(valoracion_herida.fecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                                AND (@asegurador=0 OR @asegurador=valoracion_herida.asegurador)
                                GROUP BY idherida
                            ) UNION ALL (
                                SELECT 
                                evolucion_herida.id
                                ,evolucion_herida_herida.id AS idherida
                                ,evolucion_herida.paciente
                                ,evolucion_herida.fecha
                                ,'' AS tipo
                                ,CONCAT(evolucion_herida_herida.longitud, ' X '
                                ,evolucion_herida_herida.anchura, ' X '
                                ,evolucion_herida_herida.profundidad) AS tamano
                                ,evolucion_herida_herida.ubicacion_especifica
                                ,IFNULL(evolucion_herida_herida.bolsillo_ubicacion,'NO') AS bolsillo
                                ,evolucion_herida_herida.bolsillo_tamano
                                ,piel_circundante.nombre AS piel_circundante
                                ,NULL AS estoma
                                ,NULL AS fistula
                                ,NULL AS cantidad_afluente
                                ,evolucion_herida_herida.compacto
                                ,SUBSTRING_INDEX(GREATEST(
	                                CONCAT(IFNULL(compacto,0),'_compacto')
	                                ,CONCAT(IFNULL(fibrina,0),'_fibrina')
	                                ,CONCAT(IFNULL(epitelizacion,0),'_epitelizacion')
	                                ,CONCAT(IFNULL(escara,0),'_escara')
	                                ,CONCAT(IFNULL(granulacion,0),'_granulacion')
	                                ,CONCAT(IFNULL(hipergranulacion,0),'_hipergranulacion')
	                                ,CONCAT(IFNULL(limpio,0),'_limpio')
	                                ,CONCAT(IFNULL(necrosis,0),'_necrosis')
	                                ),'_',-1) AS predominante
                                ,IF(evolucion_herida_herida.signo_infeccion IS NOT NULL, 'Si', 'No') AS signoinfeccion
                                ,tipo_exudado.nombre AS tipo_exudado
                                ,exudado.nombre AS cantidad_exudado
                                ,GROUP_CONCAT(medicamentos.nombre ORDER BY medicamento_formulacion.id SEPARATOR '<br/>') AS medicamento
                                ,GROUP_CONCAT(medicamento_formulacion.formulada ORDER BY medicamento_formulacion.id SEPARATOR '<br/>') AS formulada
                                FROM evolucion_herida
                                LEFT JOIN evolucion_herida_herida ON (evolucion_herida_herida.evolucion=evolucion_herida.id)
                                LEFT JOIN varios AS exudado ON (evolucion_herida_herida.exudado=exudado.id)
                                LEFT JOIN varios AS tipo_exudado ON (evolucion_herida_herida.tipo_exudado=tipo_exudado.id)
                                LEFT JOIN varios AS piel_circundante ON (piel_circundante.id=evolucion_herida_herida.piel_circundante)                                
                                LEFT JOIN formulacion ON (formulacion.paciente=evolucion_herida.paciente AND formulacion.fecha=evolucion_herida.fecha)
                                LEFT JOIN medicamento_formulacion ON (formulacion.id=medicamento_formulacion.formulacion)
                                LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento)
                                WHERE 
                                DATE(evolucion_herida.fecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                                AND (@asegurador=0 OR @asegurador=evolucion_herida.asegurador)
                                GROUP BY idherida
                            )
                            ORDER BY paciente,fecha
                            ">
            <SelectParameters>
                <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                <asp:ControlParameter ControlID="DAsegurador" Name="asegurador" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

