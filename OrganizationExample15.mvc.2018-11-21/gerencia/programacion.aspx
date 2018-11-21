<%@ Page Title="Informe servicios prestados" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="gerencia_programacion" Codebehind="programacion.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript">
    $(function() {
        $("#accordion").accordion({ autoHeight: false, navigation: true, collapsible: true, active: false, animated: false,
            change: function(event, ui) {
                ui.newContent.children('div:eq(0)').children(':submit').click();
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<script type="text/javascript">
    
    function drawChart() {
        drawPieChart("chart_div", [<%= ViewState["servicios"].ToString() %>], "<%= ViewState["titulo"].ToString() %>");
        drawPieChart("chart_div2", [<%= ViewState["costos"].ToString() %>], "Costos");
    }
    
    google.load("visualization", "1", { packages: ["corechart"] });
    google.setOnLoadCallback(drawChart);
</script>
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Inicio</td>
            <td>Fin</td>
            <td>Asegurador</td>
            <td>Agrupar por</td>
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
                <asp:DropDownList ID="DGrupo" runat="server">
                    <asp:ListItem Text="Servicio-Asegurador" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Asegurador-Servicio" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Asegurador-Paciente" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" onclick="BBuscar_Click" /></td>
        </tr>
        </table>
    </asp:Panel>
    <table>
        <tr>
            <td><div id="chart_div"></div></td>
            <td><div id="chart_div2"></div></td>
        </tr>
    </table>
<asp:Repeater runat="server" ID="RServicios" DataSourceID="SServicios" 
        onitemdatabound="RServicios_ItemDataBound">
    <HeaderTemplate>
        <div id="accordion">
    </HeaderTemplate>
    <ItemTemplate>
        <h3><a href="#"><asp:Label runat="server" ID="LT" Text='<%# Eval("nombre") %>'></asp:Label> (<asp:Label runat="server" ID="LC" Text='<%# Eval("c") %>'></asp:Label><asp:Label runat="server" ID="LCo" Text='<%# Eval("s", "{0:c}") %>'></asp:Label>)</a></h3>
        <div class="hidet">
            <asp:UpdatePanel runat="server" ID="UD" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:HiddenField runat="server" ID="HId" Value='<%# Eval("id") %>' />
                    <asp:Image runat="server" ID="IL" ImageUrl="~/css/ajax-loader.gif" />
                    <asp:Button runat="server" ID="BA" OnClick="OnClickBA" CssClass="hidet" />
                    <asp:Repeater runat="server" ID="RH" DataSourceID="" Visible="false" onitemdatabound="RServicios_ItemDataBound">
                        <HeaderTemplate>
                            <div class="tmpacordeon">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <h3><a href="#"><asp:Label runat="server" ID="LT" Text='<%# Eval("nombre") %>'></asp:Label> (<asp:Label runat="server" ID="LC" Text='<%# Eval("c") %>'></asp:Label><asp:Label runat="server" ID="LCo" Text='<%# Eval("s", "{0:c}") %>'></asp:Label>)</a></h3>
                            <div class="hidet">
                                <asp:UpdatePanel runat="server" ID="UD" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:HiddenField runat="server" ID="HId2" Value='<%# Eval("id") %>' />
                                    <asp:Image runat="server" ID="IL2" ImageUrl="~/css/ajax-loader.gif" />
                                    <asp:Button runat="server" ID="BA2" OnClick="OnClickBA" CssClass="hidet" />
                                    <asp:GridView runat="server" ID="GR" Visible="false" AutoGenerateColumns="False" DataSourceID="" AllowSorting="true" OnRowDataBound="GResultados_RowDataBound" Width="100%">
                                        <RowStyle CssClass="GridRow"></RowStyle>
                                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                                        <Columns>
	                                        <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha" SortExpression="prgFechaProg" DataFormatString="{0:d}" />
	                                        <asp:BoundField DataField="autNumero" HeaderText="Autorización" SortExpression="autNumero" />
	                                        <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
	                                        <asp:BoundField DataField="sesiones" HeaderText="Sesiones" SortExpression="sesiones" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
	                                        <asp:BoundField DataField="costo" HeaderText="Costo" SortExpression="costo" DataFormatString="{0:c}" ItemStyle-Wrap="false" />
                                        </Columns>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="SR" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                        SelectCommand="(
                                                    SELECT 
                                                        autorizacion.autFecha AS prgFechaProg, autorizacion.autNumero, CONCAT(paciente.pacDocumento, ' - ', paciente.pacNombres) AS nombre, SUM(programacion.costo) AS costo
                                                        ,COUNT(*) AS sesiones
                                                        FROM programacion
                                                        LEFT JOIN paciente ON (paciente.pacId=programacion.pacId)
                                                        LEFT JOIN autorizacion ON (autorizacion.autNumero=programacion.autNumero)
                                                        WHERE 
                                                        @grupo=0
                                                        AND DATE(programacion.prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                                                        AND programacion.actId=@id 
                                                        AND programacion.entId=@id2
                                                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                                                        GROUP BY autorizacion.autFecha,autorizacion.autNumero,paciente.pacNombres,paciente.pacDocumento
                                                    ) UNION (
                                                    SELECT 
                                                        autorizacion.autFecha AS prgFechaProg, autorizacion.autNumero, CONCAT(paciente.pacDocumento, ' - ', paciente.pacNombres) AS nombre, SUM(programacion.costo) AS costo
                                                        ,COUNT(*) AS sesiones
                                                        FROM programacion
                                                        LEFT JOIN paciente ON (paciente.pacId=programacion.pacId)
                                                        LEFT JOIN autorizacion ON (autorizacion.autNumero=programacion.autNumero)
                                                        WHERE 
                                                        @grupo=1
                                                        AND DATE(programacion.prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                                                        AND programacion.entId=@id 
                                                        AND programacion.actId=@id2
                                                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                                                        GROUP BY autorizacion.autFecha,autorizacion.autNumero,paciente.pacNombres,paciente.pacDocumento
                                                    ) UNION (
                                                    SELECT 
                                                        autorizacion.autFecha AS prgFechaProg, autorizacion.autNumero
                                                        , programacion.actId AS nombre
                                                        , SUM(programacion.costo) AS costo
                                                        ,COUNT(*) AS sesiones
                                                        FROM programacion
                                                        LEFT JOIN autorizacion ON (autorizacion.autNumero=programacion.autNumero)
                                                        WHERE 
                                                        @grupo=2
                                                        AND DATE(programacion.prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                                                        AND programacion.entId=@id 
                                                        AND programacion.pacId=@id2
                                                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                                                        GROUP BY autorizacion.autFecha,autorizacion.autNumero,programacion.actId
                                                    )
                                                    ORDER BY prgFechaProg DESC">
                                          <SelectParameters>
                                                <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                                                <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                                                <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                                                <asp:ControlParameter ControlID="HId" Name="id" PropertyName="Value" /> 
                                                <asp:ControlParameter ControlID="HId2" Name="id2" PropertyName="Value" /> 
                                                <asp:ControlParameter ControlID="DGrupo" PropertyName="SelectedValue" Name="grupo" />
                                          </SelectParameters>
                                    </asp:SqlDataSource>
                                </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource ID="SEntidades" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="(
                                        SELECT programacion.entId AS id,asegurador.entNombre AS nombre, COUNT(*) AS c,SUM(programacion.costo) AS s 
                                        FROM programacion 
                                        LEFT JOIN asegurador ON (asegurador.entId=programacion.entId)
                                        WHERE 
                                        @grupo=0
                                        AND DATE(programacion.prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                                        AND programacion.actId=@id 
                                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                                        GROUP BY programacion.entId,asegurador.entNombre
                                    ) UNION (
                                        SELECT actId AS id,'' AS nombre, COUNT(*) AS c,SUM(programacion.costo) AS s 
                                        FROM programacion 
                                        WHERE 
                                        @grupo=1
                                        AND DATE(programacion.prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                                        AND programacion.entId=@id 
                                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                                        GROUP BY actId
                                    ) UNION (
                                        SELECT paciente.pacId AS id,paciente.pacDocumento + ' - ' + paciente.pacNombres AS nombre, COUNT(*) AS c,SUM(programacion.costo) AS s 
                                        FROM programacion 
										LEFT JOIN paciente ON (paciente.pacId=programacion.pacId)
                                        WHERE 
                                        @grupo=2
                                        AND DATE(programacion.prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                                        AND programacion.entId=@id 
                                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                                        GROUP BY paciente.pacId,paciente.pacDocumento,paciente.pacNombres
                                    )
                                    ORDER BY c,id DESC">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                            <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                            <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                            <asp:ControlParameter ControlID="HId" Name="id" PropertyName="Value" /> 
                            <asp:ControlParameter ControlID="DGrupo" PropertyName="SelectedValue" Name="grupo" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="BA" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </ItemTemplate>
    <FooterTemplate>
        </div>
    </FooterTemplate>
</asp:Repeater>
<asp:SqlDataSource ID="SServicios" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
    SelectCommand="(
                        SELECT actId AS id,'' AS nombre, COUNT(*) AS c,SUM(costo) AS s FROM programacion 
                        WHERE 
                        @grupo=0
                        AND DATE(prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                        GROUP BY actId
                    ) UNION (
                        SELECT asegurador.entId AS id,asegurador.entNombre AS nombre, COUNT(*) AS c,SUM(costo) AS s FROM programacion 
					    LEFT JOIN asegurador ON (asegurador.entId=programacion.entId)
					    WHERE 
					    @grupo=1
                        AND DATE(prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                        GROUP BY asegurador.entId, asegurador.entNombre
                    ) UNION (
                        SELECT asegurador.entId AS id,asegurador.entNombre AS nombre, COUNT(DISTINCT programacion.pacId) AS c,SUM(costo) AS s FROM programacion 
					    LEFT JOIN asegurador ON (asegurador.entId=programacion.entId)
					    WHERE 
					    @grupo=2
                        AND DATE(prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                        GROUP BY asegurador.entId, asegurador.entNombre
                    ) ORDER BY nombre,id DESC">
    <SelectParameters>
        <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
        <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
        <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
        <asp:ControlParameter ControlID="DGrupo" PropertyName="SelectedValue" Name="grupo" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:Panel runat="server" ID="PGrilla" Visible="false">
    <asp:GridView runat="server" ID="GResultados" AutoGenerateColumns="False" DataSourceID="SResultados" AllowSorting="true"
        OnRowDataBound="GResultados_RowDataBound" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField DataField="entidad" HeaderText="Entidad" SortExpression="entidad" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" SortExpression="pacDocumento" />
            <asp:BoundField DataField="nombre" HeaderText="Paciente" SortExpression="nombre" />
            <asp:BoundField DataField="prgFechaProg" HeaderText="Inicio vigencia autorización" SortExpression="prgFechaProg" DataFormatString="{0:d}" />
            <asp:BoundField DataField="autNumero" HeaderText="Autorización" SortExpression="autNumero" />
            <asp:BoundField DataField="actId" HeaderText="Actividad" SortExpression="actId" ItemStyle-Wrap="false" />
            <asp:BoundField DataField="sesiones" HeaderText="Sesiones" SortExpression="sesiones" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField DataField="costo" HeaderText="Costo" SortExpression="costo" DataFormatString="{0:c}" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT 
                        asegurador.entNombre AS entidad,programacion.actId,
                        paciente.pacDocumento,
                        autorizacion.autFecha AS prgFechaProg, autorizacion.autNumero,
                        paciente.pacNombres AS nombre, SUM(programacion.costo) AS costo
                        ,COUNT(*) AS sesiones
                        FROM programacion
                        LEFT JOIN autorizacion ON (autorizacion.autNumero=programacion.autNumero)
                        LEFT JOIN paciente ON (paciente.pacId=programacion.pacId)
                        LEFT JOIN asegurador ON (asegurador.entId=programacion.entId)
                        WHERE DATE(programacion.prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y') 
                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                        GROUP BY asegurador.entNombre,autorizacion.autFecha,autorizacion.autNumero,programacion.actId,paciente.pacDocumento,paciente.pacNombres
                        ORDER BY entNombre,pacNombres DESC">
          <SelectParameters>
                <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
          </SelectParameters>
    </asp:SqlDataSource>
</asp:Panel>
</asp:Content>