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
                    data: "{ 'q': '" + request.term + "', 'e': '<%= ViewState["entidades"].ToString() %>' }",
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

        $("#<%= TFecha.ClientID %>,#<%= TFactura.ClientID %>,#<%= TAZ.ClientID %>,#<%= DTipoArchivo.ClientID %>").change(function() {
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
            <td>Tipo<asp:RequiredFieldValidator ControlToValidate="DTipoArchivo" ErrorMessage="Por favor seleccione un tipo." ID="RequiredFieldValidator8" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td>
                <asp:DropDownList ID="DTipoArchivo" runat="server" DataSourceID="STipoArchivo" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="STipoArchivo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=36 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>Paciente<asp:RequiredFieldValidator ControlToValidate="TPacienteID" ErrorMessage="Por favor ingrese un Paciente." ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox ID="TPaciente" runat="server" Width="98%"></asp:TextBox>
            <asp:TextBox runat="server" ID="TPacienteID" CssClass="hidet"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Observaciones</td>
            <td><asp:TextBox runat="server" ID="TObservaciones" Height="80" TextMode="MultiLine" Width="98%"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2" class="celdaTitulo">Solicitudes</td>
        </tr>
        <asp:UpdatePanel runat="server" ID="UMas" UpdateMode="Conditional"><ContentTemplate>
        <tr>
            <td colspan="2">
                <asp:GridView ID="GPrestamos" runat="server" AutoGenerateColumns="False"  Width="100%"
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
                        <asp:BoundField DataField="tipo" HeaderText="Tipo" SortExpression="tipo" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="solicitadopor" HeaderText="Solicitado por" SortExpression="solicitadopor" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="objeto" HeaderText="Objeto" SortExpression="objeto" ItemStyle-Width="100%" />
                        <asp:BoundField DataField="entrega" HeaderText="Entrega" SortExpression="entrega" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="devolucion" HeaderText="Devolución" SortExpression="devolucion" DataFormatString="{0:d}" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SPrestamos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
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
                <div id="dMas" title="Solicitud de prestamo" align="left" class="hidet">
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
                <asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
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
            <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados"  Width="100%"
                AutoGenerateColumns="False" EmptyDataText="No se encontraron archivos" DataKeyNames="arcId"
                AllowPaging="True" PageSize="50" AllowSorting="True" 
                OnRowDataBound="GResultados_RowDataBound" 
                onpageindexchanging="GResultados_PageIndexChanging" >
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
                    <asp:BoundField HeaderText="Paciente" DataField="pacNombres" SortExpression="pacNombres" ItemStyle-Wrap="false" />
                    <asp:BoundField HeaderText="Factura" DataField="arcFactura" SortExpression="arcFactura" />
                    <asp:BoundField HeaderText="A-Z" DataField="arcAZ" SortExpression="arcAZ" ItemStyle-Wrap="false" />
                    <asp:BoundField HeaderText="Tipo" DataField="tipo" SortExpression="tipo" ItemStyle-Wrap="false" />
                    <asp:BoundField HeaderText="Observaciones" DataField="arcObservaciones" SortExpression="arcObservaciones" ItemStyle-Width="100%" />
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
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT paciente_archivo.arcId
                    ,paciente.pacNombres
                    ,CAST(CONCAT(LPAD(paciente_archivo.arcMes,2,'0'),'/', paciente_archivo.arcAnio) AS CHAR) AS fecha
                    ,paciente_archivo.arcFactura
                    ,paciente_archivo.arcAZ
                    ,paciente_archivo.arcObservaciones
                    ,paciente_archivo.tipo
                    FROM paciente_archivo
                    LEFT JOIN paciente ON (paciente.pacId=paciente_archivo.pacId)
                    WHERE 
                    (@fecha='0' OR CONCAT(LPAD(paciente_archivo.arcMes,2,'0'),'/', paciente_archivo.arcAnio)=@fecha)
                    AND (@az='_' OR paciente_archivo.arcAZ LIKE CONCAT('%',@az,'%'))
                    AND (@factura='_' OR paciente_archivo.arcFactura LIKE CONCAT('%',@factura,'%'))
                    AND (@tipo=-1 OR paciente_archivo.tipo=@tipo)
                    AND (@paciente=0 OR paciente_archivo.pacId=@paciente)
                    ">
          <SelectParameters>
            <asp:ControlParameter ControlID="TFecha" PropertyName="Text" Name="fecha" DefaultValue="0" />
            <asp:ControlParameter ControlID="TPacienteID" PropertyName="Text" Name="paciente" DefaultValue="0" />
            <asp:ControlParameter ControlID="TAZ" PropertyName="Text" Name="az" DefaultValue="_" />
            <asp:ControlParameter ControlID="TFactura" PropertyName="Text" Name="factura" DefaultValue="_" />
            <asp:ControlParameter ControlID="DTipoArchivo" PropertyName="SelectedValue" Name="tipo" DefaultValue="-1" />
          </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

