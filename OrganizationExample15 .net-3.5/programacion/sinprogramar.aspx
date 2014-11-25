<%@ Page Title="Autorizaciones sin programar" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="sinprogramar.aspx.cs" Inherits="programacion_sinprogramar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">.GridHeader th {width: auto !important;}</style>
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
            <td></td>
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
            <td class="nw"><asp:CheckBox runat="server" ID="CCompleta" Text="Iniciados" /></td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" 
        AllowPaging="True" PageSize="50" AllowSorting="True" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="autNumero" HeaderText="Autorización" 
                DataNavigateUrlFields="pacId" 
                DataNavigateUrlFormatString="~/programacion/programacion.aspx?pid={0}" SortExpression="autNumero" />
            <asp:BoundField HeaderText="Fecha" DataField="autFecha" SortExpression="autFecha" DataFormatString="{0:d}" />
            <asp:BoundField HeaderText="Vencimiento" DataField="autFechaVenc" SortExpression="autFechaVenc" DataFormatString="{0:d}" />
            <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Documento" DataNavigateUrlFields="pacId" SortExpression="pacDocumento"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-HorizontalAlign="Right" />
            <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" DataNavigateUrlFields="pacId" SortExpression="pacNombres"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Barrio" DataField="pacBarrio" SortExpression="pacBarrio" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Direccion" DataField="pacDireccion" SortExpression="pacDireccion" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Actividades (Autorizadas-Programadas-Diarias)" DataField="detalles" SortExpression="detalles" ItemStyle-Wrap="false" HtmlEncode="false"/>
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
                            ,GROUP_CONCAT(CONCAT(medicamentos.nombre, ' (', IFNULL(autorizacion_detalle.autNumSesiones,0),'-'
                                ,IFNULL(autorizacion_detalle.sesiones_programadas,0)
                                ,'-',IFNULL(autorizacion_detalle.autSesionesDia,0),')') SEPARATOR '<br/>') AS detalles
                            FROM autorizacion
                            LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                            LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                            LEFT JOIN medicamentos ON (medicamentos.id=autorizacion_detalle.actId)
                            WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND autorizacion.autActivo=1
                            AND paciente.estId=1
                            AND (@asegurador=0 OR paciente.entId=@asegurador)
                            {0} 
                            AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                            AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                            AND (autorizacion_detalle.sesiones_programadas IS NULL OR autorizacion_detalle.sesiones_programadas<autorizacion_detalle.autNumSesiones)
                            AND (@completa=1 OR IFNULL(autorizacion_detalle.sesiones_programadas,0)=0)
                            AND (@completa=0 OR IFNULL(autorizacion_detalle.sesiones_programadas,0)!=0)
                            GROUP BY paciente.pacId,autorizacion.autNumero
                            ORDER BY autorizacion.autFecha
                            ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="CCompleta" PropertyName="Checked" Name="completa" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <br />
    <div align="right">
    <asp:GridView runat="server" ID="GResumen" AutoGenerateColumns="False" OnRowDataBound="GResumen_RowDataBound" ShowHeader="false" DataSourceID="SResumen">
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
                                                    WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                                    AND autorizacion.autActivo=1
                                                    AND paciente.estId=1
                                                    AND (@asegurador=0 OR paciente.entId=@asegurador)                                                    
                                                    {0}
                                                    AND autorizacion_detalle.autNumSesiones>IFNULL(autorizacion_detalle.sesiones_programadas,0)
                                                    AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                                                    AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                                                    AND (@completa=1 OR IFNULL(autorizacion_detalle.sesiones_programadas,0)=0)
                                                    AND (@completa=0 OR IFNULL(autorizacion_detalle.sesiones_programadas,0)!=0)
                        ) UNION ( 
                        SELECT '-1',COUNT(DISTINCT paciente.pacNombres)
                                                    FROM autorizacion
                                                    LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                                                    LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
							                        LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                                                    WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                                    AND autorizacion.autActivo=1
                                                    AND paciente.estId=1
                                                    AND (@asegurador=0 OR paciente.entId=@asegurador)                                                    
                                                    {0}
                                                    AND autorizacion_detalle.autNumSesiones>IFNULL(autorizacion_detalle.sesiones_programadas,0)
                                                    AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                                                    AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                                                    AND (@completa=1 OR IFNULL(autorizacion_detalle.sesiones_programadas,0)=0)
                                                    AND (@completa=0 OR IFNULL(autorizacion_detalle.sesiones_programadas,0)!=0)
                        ) UNION (
                            SELECT CAST(CONCAT('%%', autorizacion_detalle.actId) AS CHAR)
                                    ,SUM(autNumSesiones)
                                                    FROM autorizacion
                                                    LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                                                    LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
							                        LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                                                    WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                                    AND autorizacion.autActivo=1
                                                    AND paciente.estId=1
                                                    AND (@asegurador=0 OR paciente.entId=@asegurador)                                                    
                                                    {0}
                                                    AND autorizacion_detalle.autNumSesiones>IFNULL(autorizacion_detalle.sesiones_programadas,0)
                                                    AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                                                    AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                                                    AND (@completa=1 OR IFNULL(autorizacion_detalle.sesiones_programadas,0)=0)
                                                    AND (@completa=0 OR IFNULL(autorizacion_detalle.sesiones_programadas,0)!=0)
							                        GROUP BY autorizacion_detalle.actId
                        )UNION (
                        SELECT 5000000,SUM(autorizacion_detalle.autNumSesiones)
                                                    FROM autorizacion
                                                    LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                                                    LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
							                        LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                                                    WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                                    AND autorizacion.autActivo=1
                                                    AND paciente.estId=1
                                                    AND (@asegurador=0 OR paciente.entId=@asegurador)                                                    
                                                    {0}
                                                    AND autorizacion_detalle.autNumSesiones>IFNULL(autorizacion_detalle.sesiones_programadas,0)
                                                    AND (@procedimiento=0 OR autorizacion_detalle.actId=@procedimiento)
                                                    AND ('@area'='0' OR autorizacion_detalle.actId IN (@area))
                                                    AND (@completa=1 OR IFNULL(autorizacion_detalle.sesiones_programadas,0)=0)
                                                    AND (@completa=0 OR IFNULL(autorizacion_detalle.sesiones_programadas,0)!=0)
                        ) ORDER BY nombre
                        ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="CCompleta" PropertyName="Checked" Name="completa" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

