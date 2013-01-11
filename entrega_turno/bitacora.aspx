<%@ Page Title="Bitácora" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="bitacora.aspx.cs" Inherits="entrega_turno_bitacora" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
    .objeto { min-width: 300px; }
</style>
<script type="text/javascript">
    addFunctionToStart(function() {
        addDialog("#<%= PMas.ClientID %>", "#dMas");
    });
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
        $("#<%= TFecha.ClientID %>").change(function() {
            $("#<%= BBuscar.ClientID %>").click();
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table width="100%">
        <tr>
            <td>Fecha
            <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td>
                <asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Tipo<asp:RequiredFieldValidator ControlToValidate="DTipo" InitialValue="0" ErrorMessage="Por favor seleccione un tipo." ID="RequiredFieldValidator3" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator></td>
            <td>
            <asp:DropDownList ID="DTipo" runat="server" AutoPostBack="true"
                                DataSourceID="STipo" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                    <asp:ListItem Text="(Ninguno)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="STipo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT tpaId AS id,tpaDescripcion AS nombre FROM phdTipoActividad ORDER BY 2">
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>Observaciones<asp:RequiredFieldValidator ControlToValidate="TObservaciones" ErrorMessage="Por favor ingrese unas observaciones." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TObservaciones" Height="80" TextMode="MultiLine" Width="98%"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Novedad administrativa<asp:RequiredFieldValidator ControlToValidate="DNAdministrativa" InitialValue="0" ErrorMessage="Por favor seleccione una novedad administrativa." ID="RequiredFieldValidator6" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator></td>
            <td>
                <asp:DropDownList ID="DNAdministrativa" runat="server" AutoPostBack="true" 
                    DataSourceID="SNAdministrativa" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                                    <asp:ListItem Text="(Ninguna)" Value="0"></asp:ListItem>
                </asp:DropDownList>
            <asp:SqlDataSource ID="SNAdministrativa" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=27 AND szReservado IS NULL ORDER BY nombre">
            </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Novedad del servicio prestado<asp:RequiredFieldValidator ControlToValidate="DNServicio" InitialValue="0" ErrorMessage="Por favor seleccione una novedad del servicio." ID="RequiredFieldValidator7" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator></td>
            <td>
                <asp:DropDownList ID="DNServicio" runat="server" AutoPostBack="true" 
                    DataSourceID="SNServicio" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                                    <asp:ListItem Text="(Ninguna)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SNServicio" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=28 AND szReservado IS NULL ORDER BY nombre">
            </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>Paciente</td>
            <td><asp:TextBox ID="TPaciente" runat="server" Width="98%"></asp:TextBox><asp:TextBox runat="server" ID="TPacienteID" CssClass="hide"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="2" class="celdaTitulo">Seguimiento</td>
        </tr>
        <asp:UpdatePanel runat="server" ID="UMas" UpdateMode="Conditional"><ContentTemplate>
        <tr>
            <td colspan="2">
                <asp:HiddenField runat="server" ID="HBitacora" />
                <asp:GridView ID="GSeguimiento" runat="server" AutoGenerateColumns="False" 
                    DataSourceID="SSeguimiento" DataKeyNames="id" 
                    onselectedindexchanged="GSeguimiento_SelectedIndexChanged">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
		            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                        <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                        <asp:BoundField DataField="fecha" HeaderText="Fecha" SortExpression="fecha" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="tpaDescripcion" HeaderText="Área" SortExpression="tpaDescripcion" />
                        <asp:BoundField DataField="objeto" HeaderText="Objeto" SortExpression="objeto" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SSeguimiento" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    DeleteCommand="DELETE FROM bitacora_seguimiento WHERE id=@id"
                    SelectCommand="SELECT 
                                bitacora_seguimiento.id
                                ,bitacora_seguimiento.fecha
                                ,phdTipoActividad.tpaDescripcion
                                ,bitacora_seguimiento.objeto
                                FROM bitacora_seguimiento
                                LEFT JOIN phdTipoActividad ON (phdTipoActividad.tpaId=bitacora_seguimiento.area)
                                WHERE bitacora_seguimiento.bitacora=@bitacora
                                ORDER BY bitacora_seguimiento.fecha DESC
                            ">
                       <SelectParameters>
                        <asp:ControlParameter ControlID="HBitacora" Name="bitacora" PropertyName="Value" />
                      </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td align="right" colspan="2">
            <asp:Panel runat="server" ID="PMas" Visible="false">
                <asp:HiddenField runat="server" ID="HMasId" />
                <div id="dMas" title="Seguimiento" align="left" class="hide">
                <table>
                    <tr>
                        <td colspan="2">
                            <uc4:detallepaciente ID="CCDetallePaciente" runat="server" ShowServicios="false" />
                        </td>
                    </tr>
                    <tr>
                        <td>Fecha
                        <asp:RequiredFieldValidator ValidationGroup="mas" ControlToValidate="TFechaSeguimiento" ErrorMessage="Por favor ingrese un fecha." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator ValidationGroup="mas" ControlToValidate="THoraSeguimiento" ErrorMessage="Por favor ingrese un hora." ID="RequiredFieldValidator8" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                        <asp:RangeValidator ValidationGroup="mas" ControlToValidate="TFechaSeguimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                        </td>
                        <td><asp:TextBox runat="server" ID="TFechaSeguimiento" CssClass="fecha"></asp:TextBox>
                        <asp:TextBox runat="server" ID="THoraSeguimiento" CssClass="hora"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Área encargada</td>
                        <td>
                            <asp:DropDownList ID="DArea" runat="server"
                                DataSourceID="SArea" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                            <asp:SqlDataSource ID="SArea" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                                SelectCommand="SELECT tpaId AS id,tpaDescripcion AS nombre FROM phdTipoActividad ORDER BY 2">
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td>Objeto<asp:RequiredFieldValidator ValidationGroup="mas" ControlToValidate="TObjeto" ErrorMessage="Por favor ingrese un objeto." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator></td>
                        <td>
                            <asp:TextBox runat="server" ID="TObjeto" TextMode="MultiLine" CssClass="objeto" Width="98%"></asp:TextBox>
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
                AutoGenerateColumns="False" EmptyDataText="No se encontraron bitácoras" DataKeyNames="bitId"
                AllowPaging="True" PageSize="50" AllowSorting="True" OnRowDataBound="GResultados_RowDataBound" >
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:HyperLinkField DataTextField="bitFecha" HeaderText="Fecha" 
                        DataTextFormatString="{0:d}"
                        DataNavigateUrlFields="bitId" SortExpression="bitFecha"
                        DataNavigateUrlFormatString="~/entrega_turno/bitacora.aspx?bid={0}" 
                    ItemStyle-Wrap="false" />
                    <asp:BoundField HeaderText="Actividad" DataField="tpaDescripcion" SortExpression="tpaDescripcion" />
                    <asp:BoundField HeaderText="Novedad administrativa" DataField="NAdministrativa" SortExpression="NAdministrativa" />
                    <asp:BoundField HeaderText="Novedad de servicio" DataField="NServicio" SortExpression="NServicio" />
                    <asp:BoundField HeaderText="Paciente" DataField="pacNombres" SortExpression="pacNombres" />
                    <asp:BoundField HeaderText="Observaciones" DataField="bitObservaciones" SortExpression="bitObservaciones" />
                </Columns>
            </asp:GridView>
    <div style="text-align: right;">
        <asp:Label runat="server" ID="LTotal"></asp:Label>
    </div>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="DTipo" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="DNAdministrativa" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="DNServicio" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="BBuscar" EventName="Click" />
    </Triggers>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="SResultados" runat="server" 
        ConnectionString="<%$ ConnectionStrings:connBD %>" 
        SelectCommand="SELECT 
                    turBitacora.bitId,turBitacora.bitFecha,turBitacora.bitObservaciones
                    ,phdTipoActividad.tpaDescripcion,turBitacora.NServicio,turBitacora.NAdministrativa
                    ,phdPaciente.pacNombres
                    FROM turBitacora
                    LEFT JOIN phdTipoActividad ON (phdTipoActividad.tpaId=turBitacora.tpaId)
                    LEFT JOIN phdPaciente ON (phdPaciente.pacId=turBitacora.pacId)
                    WHERE 
                    (@fecha='01/01/1900' OR turBitacora.bitFecha=@fecha)
                    AND (@tipo='0' OR turBitacora.tpaId=@tipo)
                    AND (@administrativa=0 OR turBitacora.NAdministrativa=@administrativa)
                    AND (@servicio=0 OR turBitacora.NServicio=@servicio)
                    AND (@paciente=0 OR turBitacora.pacId=@paciente)
                    ORDER BY turBitacora.bitFecha DESC
                    ">
          <SelectParameters>
            <asp:ControlParameter ControlID="TFecha" PropertyName="Text" Name="fecha" DefaultValue="01/01/1900" />
            <asp:ControlParameter ControlID="DTipo" PropertyName="SelectedValue" Name="tipo" />
            <asp:ControlParameter ControlID="DNAdministrativa" PropertyName="SelectedValue" Name="administrativa" />
            <asp:ControlParameter ControlID="DNServicio" PropertyName="SelectedValue" Name="servicio" />
            <asp:ControlParameter ControlID="TPacienteID" PropertyName="Text" Name="paciente" DefaultValue="0" />
          </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
