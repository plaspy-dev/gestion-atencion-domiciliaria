<%@ Page Title="Censo" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="censo_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        addDialog('#<%= PLocalidad.ClientID%>', "#dLocalidad");
    });
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
        $("#<%= TPaciente.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPaciente",
                    data: "{ 'q': '" + request.term + "'}",
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
                $("#<%= TPacienteID.ClientID %>").val(ui.item.value);
                $("#<%= TPaciente.ClientID %>").val(ui.item.label);
                return false;
            },
            search: function(event, ui) {
            $("#<%= TPacienteID.ClientID %>").val("");
                // $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
            }
        }).change(function() { if ($(this).val() == "") $("#<%= TPacienteID.ClientID %>").val(""); });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Asegurador</td>
            <td>Actividad</td>
            <td>Paciente</td>
            <td>Área</td>
            <td></td>
        </tr>
        <tr>
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
            <td>
                <asp:TextBox Width="99%" runat="server" ID="TPaciente"></asp:TextBox><asp:TextBox runat="server" ID="TPacienteID" CssClass="hide"></asp:TextBox>
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
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <asp:UpdatePanel runat="server" ID="PResultados">
    <ContentTemplate>
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" 
        AllowPaging="True" PageSize="50" AllowSorting="True" 
            OnRowDataBound="GResultados_RowDataBound" 
            DataKeyNames="pacId">
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Documento" DataNavigateUrlFields="pacId" SortExpression="pacDocumento"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-HorizontalAlign="Right" />
            <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" DataNavigateUrlFields="pacId" SortExpression="pacNombres"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre"/>
            <asp:BoundField HeaderText="Edad" DataField="pacFechaNac" SortExpression="pacFechaNac" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Direccion" DataField="pacDireccion" SortExpression="pacDireccion" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Barrio" DataField="pacBarrio" SortExpression="pacBarrio" ItemStyle-Wrap="false"/>
            <asp:TemplateField HeaderText="Localidad" InsertVisible="False" SortExpression="locDescripcion">
                <ItemTemplate>
                    <asp:LinkButton ID="LLocalidad" runat="server" CausesValidation="False" CommandName='<%# Bind("pacId") %>' CommandArgument='<%# Bind("locId") %>' Text='<%# Bind("locDescripcion") %>' OnClick="LLocalidad_Click" ></asp:LinkButton>
                </ItemTemplate>
                <ItemStyle Wrap="False" />
            </asp:TemplateField>
            <asp:BoundField HeaderText="Teléfono" DataField="pacTelefono" SortExpression="pacTelefono" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Inicio programa" DataField="pacFecIngPrograma" SortExpression="pacFecIngPrograma" DataFormatString="{0:d}" />
            <asp:BoundField HeaderText="CIE10" DataField="cie10" SortExpression="cie10" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Pago directo" DataField="pdirDescripcion" SortExpression="pdirDescripcion" />
            <asp:BoundField HeaderText="Tipo evento" DataField="tipEDescripcion" SortExpression="tipEDescripcion" />
            <asp:BoundField HeaderText="Actividades (Autorizadas)" DataField="detalles" SortExpression="detalles" ItemStyle-Wrap="false"/>
        </Columns>
    </asp:GridView>
    </div>
    <div align="right">
        <asp:Label runat="server" ID="LTotal"></asp:Label>
    </div>
    <asp:Panel runat="server" ID="PLocalidad" Visible="false">
        <asp:HiddenField runat="server" ID="HPaciente" />
        <div id="dLocalidad" title="Localidad" class="hide">
        <table>
            <tr>
                <td>Localidad</td>
                <td><asp:DropDownList ID="DLocalidad" runat="server" 
                                DataSourceID="SLocalidad" DataTextField="nombre"
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SLocalidad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT locId id, locDescripcion nombre FROM admLocalidad">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td colspan="2" align="right">
                    <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                        onclick="BAceptar_Click" />
                    <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                        CausesValidation="false" onclick="BCancelar_Click"/>
                </td>
            </tr>
        </table>
        </div>
    </asp:Panel>
    </ContentTemplate>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="SELECT phdPaciente.pacDocumento,phdPaciente.pacNombres,phdPaciente.pacBarrio,phdPaciente.pacDireccion,phdPaciente.pacId
		                    ,phdPaciente.pacTelefono,phdPaciente.pacFecIngPrograma,pdirDescripcion,phdTipoEvento.tipEDescripcion
                            ,admEntidad.entNombre,phdPaciente.pacFechaNac
                            ,admLocalidad.locDescripcion
                            ,phdPaciente.locId
                            ,detalles
							,(SELECT phdCIE10.cieCodDx + '-'  + phdCIE10.cirDescripcion + ',_' FROM phdCIE10 
								WHERE 
								phdCIE10.cieCodDx=phdPaciente.cieCodDx OR phdCIE10.cieCodDx=phdPaciente.cieCodDx_1 OR phdCIE10.cieCodDx=phdPaciente.cieCodDx_2
								FOR XML PATH('')) AS cie10
                            FROM phdPaciente
                            LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)
                            LEFT JOIN admLocalidad ON (admLocalidad.locId=phdPaciente.locId) 
							LEFT JOIN phdPagodirecto ON (phdPaciente.pdirId = phdPagodirecto.pdirId)
							LEFT JOIN phdTipoEvento ON (phdPaciente.tipECod = phdTipoEvento.tipECod)
                            CROSS APPLY
                            (
                                SELECT ISNULL(phdActividad.actDescripcion,'%%'+ CAST(phdDetalleAutorizacion.actId AS VARCHAR(9))) 
                                    + ISNULL(' [$$' + CAST(phdDetalleAutorizacion.intensidad AS VARCHAR(9)) + ']','')
                                    + ' (' + CAST(ISNULL(phdDetalleAutorizacion.autNumSesiones,0) AS VARCHAR(9))
                                    + '),_ '
                                FROM phdAutorizacion
								LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero = phdAutorizacion.autNumero)
                                LEFT JOIN phdActividad ON (phdActividad.actId=phdDetalleAutorizacion.actId)
                                WHERE ISNULL(phdAutorizacion.autFechaVenc,phdAutorizacion.autfecha+30)>=GETDATE()-1
								AND phdAutorizacion.pacId=phdPaciente.pacId 
								AND ('@area'='0' OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.actId IN (@area)))
								AND (@procedimiento=0 OR EXISTS (SELECT 1 FROM phdDetalleAutorizacion WHERE phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero AND phdDetalleAutorizacion.actId=@procedimiento))
                                FOR XML PATH('')
                            ) pre_trimmed (detalles)
                            WHERE 
                            phdPaciente.estId=1 
                            AND (@paciente=0 OR phdPaciente.pacId=@paciente)
                            AND (@asegurador=0 OR phdPaciente.entId=@asegurador)
                            AND detalles IS NOT NULL
                            ORDER BY phdPaciente.pacNombres">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="TPacienteID" Name="paciente" PropertyName="Text" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

