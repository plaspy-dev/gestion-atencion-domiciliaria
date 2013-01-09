<%@ Page Title="Gestión archivo" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="archivo.aspx.cs" Inherits="archivo_archivo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
    .objeto { min-width: 300px; }
</style>
<script type="text/javascript">
    $(function() {
        $("#<%= TPaciente.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPacienteI",
                    data: "{ 'q': '" + request.term + "' }",
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

                $("#<%= TPaciente.ClientID %>").val(ui.item.label);
                $("#<%= TPacienteID.ClientID %>").val(ui.item.value);
                $("#<%= BBuscar.ClientID %>").click();
                return false;
            },
            search: function(event, ui) {
                $("#<%= TPacienteID.ClientID %>").val("");
            }
        });
        $("#<%= TFecha.ClientID %>").val("01/" + $("#<%= TFecha.ClientID %>").val())
        .datepicker($.datepicker.regional["es"])
        .datepicker("option", "dateFormat", "mm/yy")
        .mask("99/9999");

        $("#<%= TFecha.ClientID %>,#<%= TFactura.ClientID %>,#<%= TAZ.ClientID %>").change(function() {
            $("#<%= BBuscar.ClientID %>").click();
        });
    });
    addFunctionToStart(function() {
        addDialog("#<%= PMas.ClientID %>", "#dMas");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table width="100%">
        <tr>
            <td>Fecha
            <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" Display="Dynamic" ControlToValidate="TFecha" ValidationExpression="(0[1-9]|1[012])[- /.](19|20)\d\d" SetFocusOnError="true"  ErrorMessage="Por favor ingrese una fecha valida mm/aaaa"></asp:RegularExpressionValidator>
            </td>
            <td>
                <asp:TextBox ID="TFecha" runat="server" CssClass="likefecha"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Factura No.
            <asp:RequiredFieldValidator ControlToValidate="TFactura" ErrorMessage="Por favor ingrese una factura." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td>
                <asp:TextBox ID="TFactura" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>A-Z
            <asp:RequiredFieldValidator ControlToValidate="TAZ" ErrorMessage="Por favor ingrese una A-Z." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td>
                <asp:TextBox ID="TAZ" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Observaciones</td>
            <td><asp:TextBox runat="server" ID="TObservaciones" Height="80" TextMode="MultiLine" Width="98%"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Paciente</td>
            <td><asp:TextBox ID="TPaciente" runat="server" Width="98%"></asp:TextBox><asp:TextBox runat="server" ID="TPacienteID" CssClass="hide"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="2" class="celdaTitulo">Solicitudes</td>
        </tr>
        <asp:UpdatePanel runat="server" ID="UMas" UpdateMode="Conditional"><ContentTemplate>
        <tr>
            <td colspan="2">
                <asp:GridView ID="GPrestamos" runat="server" AutoGenerateColumns="False" 
                    DataSourceID="SPrestamos" DataKeyNames="id" 
                    onselectedindexchanged="GPrestamos_SelectedIndexChanged">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
		            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                        <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                        <asp:BoundField DataField="solicitud" HeaderText="Solicitud" SortExpression="solicitud" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="tipo" HeaderText="Tipo" SortExpression="tipo" />
                        <asp:BoundField DataField="solicitadopor" HeaderText="Solicitado por" SortExpression="solicitadopor" />
                        <asp:BoundField DataField="objeto" HeaderText="Objeto" SortExpression="objeto" />
                        <asp:BoundField DataField="entrega" HeaderText="Entrega" SortExpression="entrega" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="devolucion" HeaderText="Devolución" SortExpression="devolucion" DataFormatString="{0:d}" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SPrestamos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    DeleteCommand="DELETE FROM prestamo_archivo WHERE id=@id"
                    SelectCommand="SELECT id,tipo,solicitadopor,solicitud,entrega,devolucion,objeto 
                                FROM prestamo_archivo
                                WHERE archivo=@archivo
                            ">
                       <SelectParameters>
                        <asp:QueryStringParameter QueryStringField="aid" Name="archivo" />
                      </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td align="right" colspan="2">
            <asp:Panel runat="server" ID="PMas" Visible="false">
                <div id="dMas" title="Solicitud de prestamo" align="left" class="hide">
                <table>
                    <tr>
                        <td>Solicitud
                        <asp:RequiredFieldValidator ValidationGroup="mas" ControlToValidate="TFechaPrestamos" ErrorMessage="Por favor ingrese un fecha." ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        <asp:RangeValidator ValidationGroup="mas" ControlToValidate="TFechaPrestamos" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                        </td>
                        <td><asp:TextBox runat="server" ID="TFechaPrestamos" CssClass="fecha"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Tipo de solicitud</td>
                        <td>
                            <asp:DropDownList ID="DTipo" runat="server" DataSourceID="STipo" 
                                DataTextField="nombre" DataValueField="id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="STipo" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=29 AND szReservado IS NULL ORDER BY nombre">
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td>Solicitado por<asp:RequiredFieldValidator ValidationGroup="mas" ControlToValidate="TSolicitadoPor" ErrorMessage="Por favor ingrese una persona." ID="RequiredFieldValidator6" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td>
                            <asp:TextBox runat="server" ID="TSolicitadoPor" CssClass="objeto" Width="98%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Objeto<asp:RequiredFieldValidator ValidationGroup="mas" ControlToValidate="TObjeto" ErrorMessage="Por favor ingrese un objeto." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td>
                            <asp:TextBox runat="server" ID="TObjeto" TextMode="MultiLine" CssClass="objeto" Width="98%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Entrega 
                        <asp:RangeValidator ValidationGroup="mas" ControlToValidate="TEntrega" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator2" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                        </td>
                        <td><asp:TextBox runat="server" ID="TEntrega" CssClass="fecha"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Devolución 
                        <asp:RangeValidator ValidationGroup="mas" ControlToValidate="TDevolucion" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                        </td>
                        <td><asp:TextBox runat="server" ID="TDevolucion" CssClass="fecha"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:ValidationSummary ValidationGroup="mas" ID="ValidationSummary2" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right"><asp:Button runat="server" ID="BAceptarMas" Text="Aceptar" 
                                ValidationGroup="mas" onclick="BAceptarMas_Click" />
                            <asp:Button runat="server" ID="BCancelarMas" Text="Cancelar" 
                                CausesValidation="false" onclick="BCancelarMas_Click" /> </td>
                    </tr>
                </table>
                </div>
            </asp:Panel>
            <asp:Button runat="server" ID="BMas" Text="+" onclick="BMas_Click" CausesValidation="false" /></td>
        </tr>
        </ContentTemplate></asp:UpdatePanel>
        <tr>
            <td colspan="2">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
            </td>
        </tr>
        <tr>
            <td colspan="2" align="right"><asp:Button runat="server" ID="BAceptar" Text="Aceptar" onclick="BAceptar_Click" />
                <asp:Button runat="server" ID="BCancelar" CausesValidation="false" Text="Cancelar" onclick="BCancelar_Click" />
                <asp:Button runat="server" ID="BBuscar" Text="Buscar" CausesValidation="false" />
            </td>
        </tr>
        </table>
    <br />
    <asp:UpdatePanel ID="PResultados" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
    <div id="dImprimir">
            <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
                AutoGenerateColumns="False" EmptyDataText="No se encontraron archivos" DataKeyNames="arcId"
                AllowPaging="True" PageSize="50" AllowSorting="True" OnRowDataBound="GResultados_RowDataBound" >
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:HyperLinkField DataTextField="fecha" HeaderText="Fecha" 
                        DataNavigateUrlFields="arcId" SortExpression="fecha"
                        DataNavigateUrlFormatString="~/archivo/archivo.aspx?aid={0}" 
                    ItemStyle-Wrap="false" />
                    <asp:BoundField HeaderText="Paciente" DataField="pacNombres" SortExpression="pacNombres" />
                    <asp:BoundField HeaderText="Factura" DataField="arcFactura" SortExpression="arcFactura" />
                    <asp:BoundField HeaderText="A-Z" DataField="arcAZ" SortExpression="arcAZ" />
                    <asp:BoundField HeaderText="Observaciones" DataField="arcObservaciones" SortExpression="arcObservaciones" />
                </Columns>
            </asp:GridView>
    <div style="text-align: right;">
        <asp:Label runat="server" ID="LTotal"></asp:Label>
    </div>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="BBuscar" EventName="Click" />
    </Triggers>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="SResultados" runat="server" 
        ConnectionString="<%$ ConnectionStrings:connBD %>" 
        SelectCommand="SELECT arcArchivoGestion.arcId
                    ,phdPaciente.pacNombres
                    ,REPLACE(STR(CAST(arcArchivoGestion.arcMes AS varchar), 2), SPACE(1), '0') + '/' + CAST(arcArchivoGestion.arcAnio AS varchar) AS fecha
                    ,arcArchivoGestion.arcFactura
                    ,arcArchivoGestion.arcAZ
                    ,arcArchivoGestion.arcObservaciones
                    FROM arcArchivoGestion
                    LEFT JOIN phdPaciente ON (phdPaciente.pacId=arcArchivoGestion.pacId)
                    WHERE 
                    (@fecha='0' OR REPLACE(STR(CAST(arcArchivoGestion.arcMes AS varchar), 2), SPACE(1), '0') + '/' + CAST(arcArchivoGestion.arcAnio AS varchar)=@fecha)
                    AND (@az='_' OR arcArchivoGestion.arcAZ LIKE '%' + @az + '%')
                    AND (@factura='_' OR arcArchivoGestion.arcFactura LIKE '%' + @factura + '%')
                    AND (@paciente=0 OR arcArchivoGestion.pacId=@paciente)
                    ">
          <SelectParameters>
            <asp:ControlParameter ControlID="TFecha" PropertyName="Text" Name="fecha" DefaultValue="0" />
            <asp:ControlParameter ControlID="TPacienteID" PropertyName="Text" Name="paciente" DefaultValue="0" />
            <asp:ControlParameter ControlID="TAZ" PropertyName="Text" Name="az" DefaultValue="_" />
            <asp:ControlParameter ControlID="TFactura" PropertyName="Text" Name="factura" DefaultValue="_" />
          </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

