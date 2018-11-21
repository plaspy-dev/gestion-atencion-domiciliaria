<%@ Page Title="Costos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="gerencia_costos" Codebehind="costos.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <%= SDG.Componentes.HtmlUtil.RenderStyle("~/css/jquery.multiselect.css") %>
<%= SDG.Componentes.HtmlUtil.RenderScript("~/js/jquery.multiselect.min.js") %>
    <style type="text/css">
        #<%= GResultados.ClientID %> td b {
            float: right;
            position: relative;
            right: -50px;
        }
        .tdv {
            padding-right: 50px;
            white-space: nowrap;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            $("#<%= LTipo.ClientID %>").multiselect({
                noneSelectedText: "(Ninguno)",
                checkAllText: "Todos",
                uncheckAllText: "Ninguno",
                selectedText: "# seleccionados"
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
            <td>Formulación</td>
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
                <asp:ListBox runat="server" ID="LTipo" DataSourceID="STipo" DataTextField="nombre" DataValueField="id" SelectionMode="Multiple" AppendDataBoundItems="true" Height="1">
                </asp:ListBox>
                <asp:SqlDataSource ID="STipo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=19 AND (szReservado IS NULL OR szReservado!='-1') ORDER BY nombre">
                </asp:SqlDataSource>
            </td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" onclick="BBuscar_Click" /></td>
        </tr>
        </table>
    </asp:Panel>

    <asp:GridView runat="server" ID="GResultados" AutoGenerateColumns="False" DataSourceID="SResultados" AllowSorting="true" Visible="false" AllowPaging="true" PageSize="50">
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" SortExpression="pacDocumento" />
            <asp:BoundField DataField="nombre" HeaderText="Paciente" SortExpression="nombre" ItemStyle-Wrap="false" />
            <asp:BoundField DataField="entidad" HeaderText="Entidad" SortExpression="entidad" ItemStyle-Wrap="false" />
            <asp:BoundField DataField="grupo" HeaderText="Grupo DMGEM" SortExpression="grupo" ItemStyle-Wrap="false" />
            <asp:BoundField DataField="autNumero" HeaderText="Autorización" SortExpression="autNumero" />
            <asp:BoundField DataField="servicios" HeaderText="Servicios (Autorizado-Programado-Cancelado)" SortExpression="servicios" ItemStyle-CssClass="tdv" HtmlEncode="false" />
            <asp:BoundField DataField="costo" HeaderText="Costo Servicios" SortExpression="costo" DataFormatString="{0:c}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
            <asp:BoundField DataField="formulado" HeaderText="Formulado" SortExpression="formulado"  ItemStyle-CssClass="tdv" HtmlEncode="false" />
            <asp:BoundField DataField="costof" HeaderText="Costo Formulado" SortExpression="costof" DataFormatString="{0:c}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
            <asp:TemplateField HeaderText="Costo Total" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false">
                <ItemTemplate><%# string.Format("{0:C}", Totalizar(Eval("costo"),Eval("costof"))) %></ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT 
                        asegurador.entNombre AS entidad,paciente.pacDocumento,
                        paciente.pacNombres AS nombre, 
                        autorizacion.autNumero,
                        GROUP_CONCAT(DISTINCT CONCAT(
                        '<b>$',IFNULL(medicamento_valor.costo,0),'</b>'
                        ,medicamentos.codigo, '-', medicamentos.nombre
                        , ' (', IFNULL(autorizacion_detalle.autSesionesDia,1)*autorizacion_detalle.autNumSesiones
                        , '-',IFNULL(autorizacion_detalle.sesiones_programadas,0)
                        ,'-',IFNULL(autorizacion_detalle.sesiones_canceladas,0), ')'
                        ) SEPARATOR '<br/>') AS servicios
                        ,(SELECT CASE WHEN IFNULL(SUM(IFNULL(autorizacion_detalle.autSesionesDia,1)*autorizacion_detalle.autNumSesiones),0)<1 THEN 'Grupo 1' 
                                            WHEN SUM(IFNULL(autorizacion_detalle.autSesionesDia,1)*autorizacion_detalle.autNumSesiones)<20 THEN 'Grupo 2'
                                            WHEN SUM(IFNULL(autorizacion_detalle.autSesionesDia,1)*autorizacion_detalle.autNumSesiones)<50 THEN 'Grupo 3'
                                            WHEN SUM(IFNULL(autorizacion_detalle.autSesionesDia,1)*autorizacion_detalle.autNumSesiones)<90 THEN 'Grupo 4'
                                            ELSE 'Grupo 5' END AS grupo
                                            FROM autorizacion_detalle 
                                            WHERE 
                                            autorizacion_detalle.autNumero=autorizacion.autNumero
                                            AND autorizacion_detalle.actId IN (5028,5029,5030,5031))
                        AS grupo,
                        SUM(IFNULL(medicamento_valor.costo,0)) AS costo
                        ,(SELECT GROUP_CONCAT(CONCAT('<b>$',IFNULL(medicamento_valor.costo,0),'</b>'
                            ,medicamentos.codigo, '-', medicamentos.nombre, ' (' , medicamento_formulacion.formulada, ')') SEPARATOR '<br/>') 
                            FROM formulacion 
                            LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id)
                            LEFT JOIN paciente AS pac ON (pac.pacId=formulacion.paciente)
                            LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento)
                            LEFT JOIN medicamento_valor ON (medicamento_valor.medicamento=medicamentos.id AND medicamento_valor.entidad=pac.entId)
                            WHERE DATE(formulacion.fecha) 
                            BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                            AND formulacion.paciente=paciente.pacId 
                            AND medicamentos.tipo IN (@formulacion)
                            ORDER BY medicamento_formulacion.id) AS formulado
                            ,(SELECT SUM(IFNULL(medicamento_formulacion.formulada*medicamento_valor.costo,0))
                            FROM formulacion 
                            LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id)
                            LEFT JOIN paciente AS pac ON (pac.pacId=formulacion.paciente)
                            LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento)
                            LEFT JOIN medicamento_valor ON (medicamento_valor.medicamento=medicamentos.id AND medicamento_valor.entidad=pac.entId)
                            WHERE DATE(formulacion.fecha) 
                            BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                            AND formulacion.paciente=paciente.pacId 
                            AND medicamentos.tipo IN (@formulacion)
                            ORDER BY medicamento_formulacion.id) AS costof
                        FROM autorizacion
                        LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                        LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                        LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                        LEFT JOIN programacion ON (autorizacion.autNumero=programacion.autNumero AND autorizacion_detalle.actId=programacion.actId)
                        LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId)
                        LEFT JOIN medicamento_valor ON (medicamento_valor.medicamento=medicamentos.id AND medicamento_valor.entidad=paciente.entId)
                        JOIN (SELECT @servicios:=0) r
                        WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                        AND (@asegurador=0 OR @asegurador=paciente.entId)
                        GROUP BY paciente.pacId,autorizacion.autNumero
                        ORDER BY entNombre,pacNombres DESC">
          <SelectParameters>
                <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
          </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

