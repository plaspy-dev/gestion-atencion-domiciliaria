<%@ Page Title="Autorizaciones sin programar" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="sinprogramar.aspx.cs" Inherits="programacion_sinprogramar" %>

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
            <td>Horas</td>
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
                    SelectCommand="SELECT CAST(GROUP_CONCAT(medicamentos.id) AS CHAR) AS id, varios.nombre FROM varios LEFT JOIN medicamentos ON (medicamentos.grupo=varios.id) WHERE varios.tipo=22 AND varios.szReservado IS NULL GROUP BY varios.id ORDER BY varios.nombre;">
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
            <asp:CheckBox runat="server" ID="CCompleta" Text="Iniciados" />
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
            <asp:BoundField HeaderText="Actividades (Autorizadas-Programadas-Diarias)" DataField="detalles" SortExpression="detalles" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Observaciones" DataField="autObservaciones" SortExpression="autObservaciones"/>
        </Columns>
    </asp:GridView>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="SELECT phdAutorizacion.autNumero,phdAutorizacion.autFecha,phdAutorizacion.autFechaVenc,phdAutorizacion.autObservaciones
                            ,phdPaciente.pacDocumento,phdPaciente.pacNombres,phdPaciente.pacBarrio,phdPaciente.pacDireccion,phdPaciente.pacId
                            ,admEntidad.entNombre
                            ,detalles
                            FROM phdAutorizacion
                            LEFT JOIN phdPaciente ON (phdPaciente.pacId=phdAutorizacion.pacId)
                            LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)
                            CROSS APPLY
                            (
                                SELECT ISNULL(phdActividad.actDescripcion,'%%'+ CAST(phdDetalleAutorizacion.actId AS VARCHAR(9))) 
                                    + ISNULL('[$$' + CAST(phdDetalleAutorizacion.intensidad AS VARCHAR(9)) + ']','')
                                    + ' (' + CAST(ISNULL(phdDetalleAutorizacion.autNumSesiones,0) AS VARCHAR(9))
                                    + '-' + CAST((SELECT ISNULL(SUM(programacion.prgNumSesion),0) FROM programacion WHERE programacion.autNumero=phdAutorizacion.autNumero AND programacion.actId=phdDetalleAutorizacion.actId AND (programacion.intensidad=phdDetalleAutorizacion.intensidad OR (programacion.intensidad IS NULL AND phdDetalleAutorizacion.intensidad IS NULL)) ) AS VARCHAR(9)) 
                                    + '-' + CAST(ISNULL(phdDetalleAutorizacion.autSesionesDia,0) AS VARCHAR(9)) 
                                    + '),_ '
                                FROM phdDetalleAutorizacion
                                LEFT JOIN phdActividad ON (phdActividad.actId=phdDetalleAutorizacion.actId)
                                WHERE phdDetalleAutorizacion.autNumero = phdAutorizacion.autNumero
                                AND phdDetalleAutorizacion.autNumSesiones>(SELECT ISNULL(SUM(programacion.prgNumSesion),0) FROM programacion WHERE programacion.autNumero=phdAutorizacion.autNumero AND programacion.actId=phdDetalleAutorizacion.actId AND (programacion.intensidad=phdDetalleAutorizacion.intensidad OR (programacion.intensidad IS NULL AND phdDetalleAutorizacion.intensidad IS NULL)))
                                FOR XML PATH('')
                            ) pre_trimmed (detalles)
                            WHERE phdAutorizacion.autFecha BETWEEN @inicio AND @fin
                            AND phdAutorizacion.autActivo=1
                            AND GETDATE()<=ISNULL(autFechaVenc+30,autFecha+60)
                            AND (@asegurador=0 OR phdPaciente.entId=@asegurador)
                            AND EXISTS (
                                SELECT 1 FROM phdDetalleAutorizacion 
                                LEFT JOIN (
                                    SELECT programacion.autNumero,programacion.actId,programacion.intensidad,SUM(programacion.prgNumSesion) AS sesionesp
                                    FROM programacion 
                                    GROUP BY programacion.autNumero,programacion.actId,programacion.intensidad
                                ) AS programacion ON 
                                (
                                    programacion.autNumero=phdDetalleAutorizacion.autNumero 
                                    AND programacion.actId=phdDetalleAutorizacion.actId 
                                    AND (programacion.intensidad=phdDetalleAutorizacion.intensidad OR 
                                    (programacion.intensidad IS NULL AND phdDetalleAutorizacion.intensidad IS NULL))
                                ) -- end of on join
                                WHERE 
                                phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero 
                                {0} 
                                AND phdDetalleAutorizacion.autNumSesiones>ISNULL(programacion.sesionesp,0)
                                AND (@procedimiento=0 OR phdDetalleAutorizacion.actId=@procedimiento)
                                AND ('@area'='0' OR phdDetalleAutorizacion.actId IN (@area))
                                AND (@intensidad=0 OR phdDetalleAutorizacion.intensidad=@intensidad)
                                AND (@completa=1 OR ISNULL(programacion.sesionesp,0)=0)
                                AND (@completa=0 OR ISNULL(programacion.sesionesp,0)!=0)
                            )
                            ORDER BY phdAutorizacion.autFecha">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DIntensidad" PropertyName="SelectedValue" Name="intensidad" />
                    <asp:ControlParameter ControlID="CCompleta" PropertyName="Checked" Name="completa" />
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
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="( 
                        SELECT '-3' AS nombre,COUNT(DISTINCT phdAutorizacion.autNumero) AS des
                                                    FROM phdAutorizacion
                                                    LEFT JOIN phdPaciente ON (phdPaciente.pacId=phdAutorizacion.pacId)
                                                    LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)
							                        LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero)
							                        LEFT JOIN (
                                                        SELECT programacion.autNumero,programacion.actId,programacion.intensidad,SUM(programacion.prgNumSesion) AS sesionesp
                                                        FROM programacion 
                                                        GROUP BY programacion.autNumero,programacion.actId,programacion.intensidad
                                                    ) AS programacion ON 
                                                    (
                                                        programacion.autNumero=phdDetalleAutorizacion.autNumero 
                                                        AND programacion.actId=phdDetalleAutorizacion.actId 
                                                        AND (programacion.intensidad=phdDetalleAutorizacion.intensidad OR 
                                                        (programacion.intensidad IS NULL AND phdDetalleAutorizacion.intensidad IS NULL))
                                                    ) -- end of on join
                                                    WHERE phdAutorizacion.autFecha BETWEEN @inicio AND @fin
                                                    AND phdAutorizacion.autActivo=1
                                                    AND GETDATE()<=ISNULL(autFechaVenc+30,autFecha+60)
                                                    AND (@asegurador=0 OR phdPaciente.entId=@asegurador)                                                    
                                                    {0}
                                                    AND phdDetalleAutorizacion.autNumSesiones>ISNULL(programacion.sesionesp,0)
                                                    AND (@procedimiento=0 OR phdDetalleAutorizacion.actId=@procedimiento)
                                                    AND ('@area'='0' OR phdDetalleAutorizacion.actId IN (@area))
                                                    AND (@intensidad=0 OR phdDetalleAutorizacion.intensidad=@intensidad)
                                                    AND (@completa=1 OR ISNULL(programacion.sesionesp,0)=0)
                                                    AND (@completa=0 OR ISNULL(programacion.sesionesp,0)!=0)
                        ) UNION ( 
                        SELECT '-1',COUNT(DISTINCT phdPaciente.pacNombres)
                                                    FROM phdAutorizacion
                                                    LEFT JOIN phdPaciente ON (phdPaciente.pacId=phdAutorizacion.pacId)
                                                    LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)
							                        LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero)
							                        LEFT JOIN (
                                                        SELECT programacion.autNumero,programacion.actId,programacion.intensidad,SUM(programacion.prgNumSesion) AS sesionesp
                                                        FROM programacion 
                                                        GROUP BY programacion.autNumero,programacion.actId,programacion.intensidad
                                                    ) AS programacion ON 
                                                    (
                                                        programacion.autNumero=phdDetalleAutorizacion.autNumero 
                                                        AND programacion.actId=phdDetalleAutorizacion.actId 
                                                        AND (programacion.intensidad=phdDetalleAutorizacion.intensidad OR 
                                                        (programacion.intensidad IS NULL AND phdDetalleAutorizacion.intensidad IS NULL))
                                                    ) -- end of on join
                                                    WHERE phdAutorizacion.autFecha BETWEEN @inicio AND @fin
                                                    AND GETDATE()<=ISNULL(autFechaVenc+30,autFecha+60)
                                                    AND (@asegurador=0 OR phdPaciente.entId=@asegurador)                                                    
                                                    {0}
                                                    AND phdDetalleAutorizacion.autNumSesiones>ISNULL(programacion.sesionesp,0)
                                                    AND (@procedimiento=0 OR phdDetalleAutorizacion.actId=@procedimiento)
                                                    AND ('@area'='0' OR phdDetalleAutorizacion.actId IN (@area))
                                                    AND (@intensidad=0 OR phdDetalleAutorizacion.intensidad=@intensidad)
                                                    AND (@completa=1 OR ISNULL(programacion.sesionesp,0)=0)
                                                    AND (@completa=0 OR ISNULL(programacion.sesionesp,0)!=0)
                        ) UNION (
                        SELECT phdDetalleAutorizacion.actId,SUM(autNumSesiones)
                                                    FROM phdAutorizacion
                                                    LEFT JOIN phdPaciente ON (phdPaciente.pacId=phdAutorizacion.pacId)
                                                    LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)
							                        LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero)
							                        LEFT JOIN (
                                                        SELECT programacion.autNumero,programacion.actId,programacion.intensidad,SUM(programacion.prgNumSesion) AS sesionesp
                                                        FROM programacion 
                                                        GROUP BY programacion.autNumero,programacion.actId,programacion.intensidad
                                                    ) AS programacion ON 
                                                    (
                                                        programacion.autNumero=phdDetalleAutorizacion.autNumero 
                                                        AND programacion.actId=phdDetalleAutorizacion.actId 
                                                        AND (programacion.intensidad=phdDetalleAutorizacion.intensidad OR 
                                                        (programacion.intensidad IS NULL AND phdDetalleAutorizacion.intensidad IS NULL))
                                                    ) -- end of on join
                                                    WHERE phdAutorizacion.autFecha BETWEEN @inicio AND @fin
                                                    AND GETDATE()<=ISNULL(autFechaVenc+30,autFecha+60)
                                                    AND (@asegurador=0 OR phdPaciente.entId=@asegurador)                                                    
                                                    {0}
                                                    AND phdDetalleAutorizacion.autNumSesiones>ISNULL(programacion.sesionesp,0)
                                                    AND (@procedimiento=0 OR phdDetalleAutorizacion.actId=@procedimiento)
                                                    AND ('@area'='0' OR phdDetalleAutorizacion.actId IN (@area))
                                                    AND (@intensidad=0 OR phdDetalleAutorizacion.intensidad=@intensidad)
                                                    AND (@completa=1 OR ISNULL(programacion.sesionesp,0)=0)
                                                    AND (@completa=0 OR ISNULL(programacion.sesionesp,0)!=0)
							                        GROUP BY phdDetalleAutorizacion.actId
                        )UNION (
                        SELECT 5000000,SUM(phdDetalleAutorizacion.autNumSesiones)
                                                    FROM phdAutorizacion
                                                    LEFT JOIN phdPaciente ON (phdPaciente.pacId=phdAutorizacion.pacId)
                                                    LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)
							                        LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero)
							                        LEFT JOIN (
                                                        SELECT programacion.autNumero,programacion.actId,programacion.intensidad,SUM(programacion.prgNumSesion) AS sesionesp
                                                        FROM programacion 
                                                        GROUP BY programacion.autNumero,programacion.actId,programacion.intensidad
                                                    ) AS programacion ON 
                                                    (
                                                        programacion.autNumero=phdDetalleAutorizacion.autNumero 
                                                        AND programacion.actId=phdDetalleAutorizacion.actId 
                                                        AND (programacion.intensidad=phdDetalleAutorizacion.intensidad OR 
                                                        (programacion.intensidad IS NULL AND phdDetalleAutorizacion.intensidad IS NULL))
                                                    ) -- end of on join
                                                    WHERE phdAutorizacion.autFecha BETWEEN @inicio AND @fin
                                                    AND GETDATE()<=ISNULL(autFechaVenc+30,autFecha+60)
                                                    AND (@asegurador=0 OR phdPaciente.entId=@asegurador)                                                    
                                                    {0}
                                                    AND phdDetalleAutorizacion.autNumSesiones>ISNULL(programacion.sesionesp,0)
                                                    AND (@procedimiento=0 OR phdDetalleAutorizacion.actId=@procedimiento)
                                                    AND ('@area'='0' OR phdDetalleAutorizacion.actId IN (@area))
                                                    AND (@intensidad=0 OR phdDetalleAutorizacion.intensidad=@intensidad)
                                                    AND (@completa=1 OR ISNULL(programacion.sesionesp,0)=0)
                                                    AND (@completa=0 OR ISNULL(programacion.sesionesp,0)!=0)
                        ) ORDER BY nombre
                        ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DIntensidad" PropertyName="SelectedValue" Name="intensidad" />
                    <asp:ControlParameter ControlID="CCompleta" PropertyName="Checked" Name="completa" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

