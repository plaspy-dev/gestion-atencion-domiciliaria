<%@ Page Title="Cumplimiento" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="admisiones_cumplimiento" Codebehind="cumplimiento.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript">
    $(function() {
        $("#<%= TProcedimiento.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetMedicamentos",
            data: { t: 173 },
            idField: "<%= TProcedimientoID.ClientID %>"
        });
    });
    google.load("visualization", "1", { packages: ["corechart"] });
    google.setOnLoadCallback(function () {
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Cumplimiento');
        data.addColumn('number', 'Cantidad');
        data.addRows([
            <asp:Literal runat="server" ID="LChart"></asp:Literal>
        ]);

        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
        chart.draw(data, {
            width: 400, height: 300,
            title: 'Cumplimiento por servicio'
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
            <td>Actividad</td>
            <td>Área</td>
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
            <td><asp:DropDownList ID="DAsegurador" runat="server" CssClass="amc"
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
            <td><asp:DropDownList ID="DArea" runat="server" DataSourceID="SArea" CssClass="amc" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SArea" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT CAST(IFNULL(GROUP_CONCAT(medicamentos.id),-1) AS CHAR) AS id, varios.nombre FROM varios LEFT JOIN medicamentos ON (medicamentos.grupo=varios.id) WHERE varios.tipo=22 AND varios.szReservado IS NULL GROUP BY varios.id ORDER BY varios.nombre;">
                </asp:SqlDataSource>
            </td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" OnClick="BBuscar_Click" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="chart_div"></div>
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" 
        AllowPaging="False" PageSize="50" AllowSorting="True" >
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
            <asp:BoundField HeaderText="Autorizadas" DataField="autorizadas" SortExpression="autorizadas" ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Realizadas" DataField="realizadas" SortExpression="realizadas" ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="% de cumplimiento" DataField="porcentaje" SortExpression="porcentaje" ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:P0}" />
            <asp:BoundField HeaderText="Observaciones" DataField="autObservaciones" SortExpression="autObservaciones"/>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT autorizacion.autNumero,autorizacion.autFecha,autorizacion.autFechaVenc,autorizacion.autObservaciones
                            ,paciente.pacDocumento,paciente.pacNombres,paciente.pacBarrio,paciente.pacDireccion,paciente.pacId
                            ,asegurador.entNombre
                            ,medicamentos.nombre AS detalles
                            ,autorizacion_detalle.autNumSesiones AS autorizadas
                            ,IFNULL(COUNT(evolucion_terapeutivo.id),0)+IFNULL(COUNT(valoracionat.id),0) AS realizadas
                            ,(IFNULL(COUNT(evolucion_terapeutivo.id),0)+IFNULL(COUNT(valoracionat.id),0))/autorizacion_detalle.autNumSesiones AS porcentaje
                            FROM autorizacion
                            LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                            LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            LEFT JOIN autorizacion_detalle ON (autorizacion.autNumero=autorizacion_detalle.autNumero)
                            LEFT JOIN medicamentos ON (medicamentos.id=autorizacion_detalle.actId)
                            LEFT JOIN evolucion_terapeutivo ON (autorizacion.autNumero=evolucion_terapeutivo.autorizacion AND evolucion_terapeutivo.tipo=autorizacion_detalle.actId)
                            LEFT JOIN valoracionat ON (autorizacion.autNumero=valoracionat.autorizacion AND valoracionat.tipo=autorizacion_detalle.actId)
                            WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND autorizacion.autActivo=1
                            AND (@asegurador=0 OR paciente.entId=@asegurador)
                            AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                            AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                            GROUP BY autorizacion.autNumero,autorizacion_detalle.actId
                            ORDER BY autorizacion.autFecha">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <br />
    <div align="right">
        <asp:Label runat="server" ID="LTotal"></asp:Label>
    </div>
</asp:Content>

