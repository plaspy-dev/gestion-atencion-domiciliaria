<%@ Page Title="Programación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="programacion.aspx.cs" Inherits="gerencia_programacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript">
    $(function() {
        $("#accordion").accordion({ autoHeight: false, navigation: true, collapsible: true, active: -1, animated: false,
            change: function(event, ui) {
                ui.newContent.children('div:eq(0)').children(':submit').click();
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<script type="text/javascript">
    function drawPieChart(divid, data, titulo) {
        if(data.length==0)
            return;
        data= google.visualization.arrayToDataTable(data);
        var options = {
          title: titulo
        };

        var chart = new google.visualization.PieChart(document.getElementById(divid));
        chart.draw(data, options);
    }
    
    function drawChart() {
        drawPieChart("chart_div", [<%= LServicios.Text %>], "Servicios");
        drawPieChart("chart_div2", [<%= LCostos.Text %>], "Costos");
    }
    
    google.load("visualization", "1", { packages: ["corechart"] });
    google.setOnLoadCallback(drawChart);
</script>
<asp:Literal runat="server" ID="LServicios" Visible="false"></asp:Literal>
<asp:Literal runat="server" ID="LCostos" Visible="false"></asp:Literal>
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
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM dbo.admEntidad WHERE entEPS=1 ORDER BY 2">
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
        <h3><a href="#"><asp:Label runat="server" ID="TTitulo" Text='<%# Eval("nombre") %>'></asp:Label> (<asp:Label runat="server" ID="LC" Text='<%# Eval("c") %>'></asp:Label> <asp:Label runat="server" ID="LCo" Text='<%# Eval("s", "{0:c}") %>'></asp:Label>)</a></h3>
        <div class="hide">
            <asp:UpdatePanel runat="server" ID="UD" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:HiddenField runat="server" ID="HId" Value='<%# Eval("id") %>' />
                    <asp:Image runat="server" ID="IL" ImageUrl="~/css/ajax-loader.gif" />
                    <asp:Button runat="server" ID="BA" OnClick="OnClickBA" CssClass="hide" />
                    <asp:Repeater runat="server" ID="RH" DataSourceID="SEntidades" Visible="false">
                        <HeaderTemplate>
                            <div class="tmpacordeon">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <h3><a href="#"><asp:Label runat="server" ID="TTitulo" Text='<%# Eval("nombre") %>'></asp:Label> (<%# Eval("c") %> servicios<%# Eval("s", ", {0:c}") %>)</a></h3>
                            <div class="hide">
                                <asp:UpdatePanel runat="server" ID="UD" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:HiddenField runat="server" ID="HId2" Value='<%# Eval("id") %>' />
                                    <asp:Image runat="server" ID="IL2" ImageUrl="~/css/ajax-loader.gif" />
                                    <asp:Button runat="server" ID="BA2" OnClick="OnClickBA" CssClass="hide" />
                                    <asp:GridView runat="server" ID="GR" Visible="false" AutoGenerateColumns="False" DataSourceID="SR" AllowSorting="true">
                                        <RowStyle CssClass="GridRow"></RowStyle>
                                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                                        <Columns>
	                                        <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha" SortExpression="prgFechaProg" DataFormatString="{0:d}" />
	                                        <asp:BoundField DataField="autNumero" HeaderText="Autorización" SortExpression="autNumero" />
	                                        <asp:BoundField DataField="nombre" HeaderText="Paciente" SortExpression="nombre" />
	                                        <asp:BoundField DataField="personal" HeaderText="Profesional" SortExpression="personal" />
	                                        <asp:BoundField DataField="costo" HeaderText="Costo" SortExpression="costo" DataFormatString="{0:c}" />
                                        </Columns>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="SR" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                                        SelectCommand="SELECT 
                                                        programacion.prgFechaProg, programacion.autNumero, phdPaciente.pacNombres AS nombre, admPersonalHS.perNombre AS personal, programacion.costo
                                                        FROM programacion
                                                        LEFT JOIN phdPaciente ON (phdPaciente.pacId=programacion.pacId)
                                                        LEFT JOIN admPersonalHS ON (admPersonalHS.perId=programacion.perId)
                                                        WHERE programacion.prgFechaProg BETWEEN @inicio AND @fin 
                                                        AND programacion.actId=@id 
                                                        AND programacion.entId=@id2
                                                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                                                        ORDER BY prgFechaProg DESC">
                                          <SelectParameters>
                                                <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                                                <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                                                <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                                                <asp:ControlParameter ControlID="HId" Name="id" PropertyName="Value" /> 
                                                <asp:ControlParameter ControlID="HId2" Name="id2" PropertyName="Value" /> 
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
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT programacion.entId AS id,admEntidad.entNombre AS nombre, COUNT(*) AS c,SUM(programacion.costo) AS s 
                                    FROM programacion 
                                    LEFT JOIN admEntidad ON (admEntidad.entId=programacion.entId)
                                    WHERE programacion.prgFechaProg BETWEEN @inicio AND @fin AND programacion.actId=@id 
                                    AND (@asegurador=0 OR @asegurador=programacion.entId)
                                    GROUP BY programacion.entId,admEntidad.entNombre ORDER BY c DESC">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                            <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                            <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                            <asp:ControlParameter ControlID="HId" Name="id" PropertyName="Value" /> 
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
    ConnectionString="<%$ ConnectionStrings:connBD %>" 
    SelectCommand="SELECT actId AS id,'' AS nombre, COUNT(*) AS c,SUM(costo) AS s FROM programacion 
                    WHERE prgFechaProg BETWEEN @inicio AND @fin 
                    AND (@asegurador=0 OR @asegurador=programacion.entId)
                    GROUP BY actId 
                    ORDER BY c DESC">
    <SelectParameters>
        <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
        <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
        <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
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
            <asp:BoundField DataField="nombre" HeaderText="Paciente" SortExpression="nombre" />
            <asp:BoundField DataField="actId" HeaderText="Actividad" SortExpression="actId" />
            <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha" SortExpression="prgFechaProg" DataFormatString="{0:d}" />
            <asp:BoundField DataField="autNumero" HeaderText="Autorización" SortExpression="autNumero" />
            <asp:BoundField DataField="personal" HeaderText="Profesional" SortExpression="personal" />
            <asp:BoundField DataField="costo" HeaderText="Costo" SortExpression="costo" DataFormatString="{0:c}" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
        ConnectionString="<%$ ConnectionStrings:connBD %>" 
        SelectCommand="SELECT admEntidad.entNombre AS entidad,programacion.actId,
                        programacion.prgFechaProg, programacion.autNumero, phdPaciente.pacNombres AS nombre, admPersonalHS.perNombre AS personal, programacion.costo
                        FROM programacion
                        LEFT JOIN phdPaciente ON (phdPaciente.pacId=programacion.pacId)
                        LEFT JOIN admPersonalHS ON (admPersonalHS.perId=programacion.perId)
                        LEFT JOIN admEntidad ON (admEntidad.entId=programacion.entId)
                        WHERE programacion.prgFechaProg BETWEEN @inicio AND @fin 
                        AND (@asegurador=0 OR @asegurador=programacion.entId)
                        ORDER BY entNombre,pacNombres DESC">
          <SelectParameters>
                <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
          </SelectParameters>
    </asp:SqlDataSource>
</asp:Panel>
</asp:Content>