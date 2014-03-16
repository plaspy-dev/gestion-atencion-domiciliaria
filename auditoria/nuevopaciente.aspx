<%@ Page Title="Pacientes nuevos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="nuevopaciente.aspx.cs" Inherits="auditoria_nuevopaciente" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        $('#<%= TDesde.ClientID %>').datepicker({
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            dateFormat: 'mm/yy',
            onClose: function(dateText, inst) {
                var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                $("#<%= TMes.ClientID %>").val(parseInt(month, 10)+1);
                $("#<%= TAno.ClientID %>").val(year);
                $(this).datepicker('setDate', new Date(year, month, 1));
            }
        });

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
<style type="text/css">
    .ancho { min-width: 400px; }
    .ui-datepicker-calendar {display: none;}
    .ui-datepicker-close {display: none;}
    .fechaex 
{
    width: 100px;
    text-align: right;
    background: white url('../imgs/cal.gif') left center no-repeat;
}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Mes</td>
            <td>Entidad</td>
            <td>Actividad o CUPS</td>
            <td>Área</td>
            <td>Horas</td>
            <td>Categoría</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:TextBox runat="server" ID="TDesde" CssClass="fechaex" ></asp:TextBox>
                <asp:TextBox runat="server" ID="TMes" CssClass="hide"></asp:TextBox>
                <asp:TextBox runat="server" ID="TAno" CssClass="hide"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TMes" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
            </td>
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
            <asp:DropDownList ID="DCategoria" runat="server" DataSourceID="SCategoria" 
                DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
            </asp:DropDownList>
            <asp:SqlDataSource ID="SCategoria" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT CAST(GROUP_CONCAT(categoria_censo.hora) AS CHAR) AS id, nombre FROM varios LEFT JOIN categoria_censo ON (categoria_censo.categoria=varios.id) WHERE tipo=33 AND szReservado IS NULL GROUP BY varios.id ORDER BY nombre;">
            </asp:SqlDataSource>
            </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" 
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SResultados" onrowdatabound="GResultados_RowDataBound" >
            <Columns>
                <asp:BoundField DataField="pacFecIngPrograma" SortExpression="pacFecIngPrograma" HeaderText="Fecha ingreso" DataFormatString="{0:d}" />
                <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Paciente" 
                    DataNavigateUrlFields="pacId" 
                    DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" SortExpression="pacDocumento" >
                    <ItemStyle Wrap="False" HorizontalAlign="Right" />
                </asp:HyperLinkField>
                <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" 
                    DataNavigateUrlFields="pacId" 
                    DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" SortExpression="pacNombres" >
                    <ItemStyle Wrap="False" />
                </asp:HyperLinkField>
                <asp:BoundField HeaderText="Edad" DataField="pacFechaNac" SortExpression="pacFechaNac" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Diagnóstico" DataField="cied10" SortExpression="cied10" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="Observaciones" DataField="pacObservaciones" SortExpression="pacObservaciones" HeaderStyle-CssClass="ancho" />
                <asp:BoundField HeaderText="Actividades (Autorizadas)" DataField="detalles" SortExpression="detalles" ItemStyle-Wrap="false" HtmlEncode="false"/>
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT paciente.pacId,paciente.pacNombres,paciente.pacFechaNac,paciente.pacDocumento
                                ,CONCAT(IFNULL(paciente.cieCodDx,''), ',' , IFNULL(paciente.cieCodDx_1,'') , ',', IFNULL(paciente.cieCodDx_2,'')) AS cied10
                                ,paciente.pacFecIngPrograma
                                ,paciente.pacObservaciones
                                ,asegurador.entNombre
                                ,GROUP_CONCAT(CONCAT(medicamentos.nombre, ' (', IFNULL(autorizacion_detalle.autNumSesiones,0),'-',IFNULL(autorizacion_detalle.autSesionesDia,0),')') SEPARATOR '<br/>') AS detalles
                                FROM paciente
                                LEFT JOIN  asegurador ON (asegurador.entId=paciente.entId)
                                LEFT JOIN autorizacion ON (autorizacion.pacId=paciente.pacId)
                                LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero = autorizacion.autNumero)
                                LEFT JOIN medicamentos ON (medicamentos.id=autorizacion_detalle.actId)
                                
                                
                                WHERE 
                                MONTH(paciente.pacFecIngPrograma)=@mes
                                AND YEAR(paciente.pacFecIngPrograma)=@ano
                                AND (@entidad=0 OR paciente.entId=@entidad)
                                
                                -- la autorizacion
                                AND MONTH(autorizacion.autfecha)=@mes
                                AND YEAR(autorizacion.autfecha)=@ano
					            AND ('@area'='0' OR EXISTS (SELECT 1 FROM autorizacion_detalle WHERE autorizacion_detalle.autNumero=autorizacion.autNumero AND autorizacion_detalle.actId IN (@area)))
					            AND (@procedimiento=0 OR EXISTS (SELECT 1 FROM autorizacion_detalle WHERE autorizacion_detalle.autNumero=autorizacion.autNumero AND autorizacion_detalle.actId=@procedimiento))
					            AND (@intensidad=0 OR autorizacion_detalle.intensidad=@intensidad)
					            AND ('@categoria'='0' OR EXISTS (SELECT 1 FROM autorizacion_detalle WHERE autorizacion_detalle.autNumero=autorizacion.autNumero AND autorizacion_detalle.intensidad IN (@categoria)))
							            
                                GROUP BY paciente.pacId
                                ORDER BY paciente.pacFecIngPrograma
                                ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TMes" Name="mes" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TAno" Name="ano" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" Name="entidad" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="DIntensidad" PropertyName="SelectedValue" Name="intensidad" />
                 </SelectParameters>
    </asp:SqlDataSource>        
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

