<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="consulta.aspx.cs" Inherits="programacion_consulta" %>
<%@ Register src="~/programacion/novedad.ascx" tagname="novedad" tagprefix="uc3" %>

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
                // $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
            }
        }).change(function() { if ($(this).val() == "") $("#<%= TProcedimientoID.ClientID %>").val(""); });

        $("#<%= TPersonal.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPersonal",
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
            $("#<%= TPersonalID.ClientID %>").val(ui.item.value);
            $("#<%= TPersonal.ClientID %>").val(ui.item.label);
                return false;
            },
            search: function(event, ui) {
            $("#<%= TPersonalID.ClientID %>").val("");
                // $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
            }
        }).change(function() { if ($(this).val() == "") $("#<%= TPersonalID.ClientID %>").val(""); });
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
            <td>Profesional</td>
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
            <td>
                <asp:TextBox Width="99%" runat="server" ID="TPersonal"></asp:TextBox><asp:TextBox runat="server" ID="TPersonalID" CssClass="hide"></asp:TextBox>
            </td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" DataKeyNames="prgId"
        AllowPaging="True" PageSize="50" AllowSorting="True" 
            OnRowDataBound="GResultados_RowDataBound" 
            onselectedindexchanged="GResultados_SelectedIndexChanged" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField HeaderText="Fecha" DataField="prgFechaProg" SortExpression="prgFechaProg" DataFormatString="{0:d}" />
            <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Documento" 
                DataNavigateUrlFields="pacId" SortExpression="pacDocumento"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" 
                ItemStyle-HorizontalAlign="Right" >
<ItemStyle HorizontalAlign="Right"></ItemStyle>
            </asp:HyperLinkField>
            <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" DataNavigateUrlFields="pacId" SortExpression="pacNombres"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" />
            <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre"/>
            <asp:BoundField HeaderText="Actividad" DataField="actDescripcion" SortExpression="actDescripcion"/>
            <asp:BoundField HeaderText="Actividad" DataField="actId" SortExpression="actId" ItemStyle-CssClass="hide" HeaderStyle-CssClass="hide">
                <HeaderStyle CssClass="hide"></HeaderStyle>
                <ItemStyle CssClass="hide"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField HeaderText="Profesional" DataField="perNombre" SortExpression="perNombre"/>
            <asp:BoundField HeaderText="Barrio" DataField="pacBarrio" SortExpression="pacBarrio"/>
            <asp:BoundField HeaderText="Direccion" DataField="pacDireccion" SortExpression="pacDireccion"/>
            <asp:BoundField HeaderText="Teléfono" DataField="pacTelefono" SortExpression="pacTelefono"/>
            <asp:HyperLinkField DataTextField="autNumero" HeaderText="Autorización" DataNavigateUrlFields="autNumero" 
                DataNavigateUrlFormatString="~/admisiones/autorizaciones.aspx?aut={0}" SortExpression="autNumero" />
            <asp:TemplateField HeaderText="Novedades" SortExpression="novedad">
                <ItemTemplate>
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" Visible='<%# Eval("novIden").ToString()=="" ? false : true %>' CommandName="Select" Text='<%# Eval("novedad").ToString() %>'></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="SELECT programacion.prgFechaProg,programacion.autNumero
                                ,phdPaciente.pacDocumento,phdPaciente.pacNombres,phdPaciente.pacBarrio,phdPaciente.pacDireccion,phdPaciente.pacId
                                ,phdPaciente.pacTelefono
                                ,admEntidad.entNombre
                                ,admPersonalHS.perNombre
                                ,programacion.actId,phdActividad.actDescripcion
                                ,phdNovedad.novIden
                                ,programacion.prgId
                                ,CASE phdNovedad.novTipo WHEN 1 THEN 'Cancelación Programación' WHEN 2 THEN 'Reasignación' WHEN 3 THEN 'Cambio en num. sesiones' WHEN 4 THEN 'Otro' WHEN 5 THEN 'Paciente desprotegido' WHEN 6 THEN 'Cambio Servicio' ELSE NULL END AS novedad
                                FROM programacion
                                LEFT JOIN phdPaciente ON (phdPaciente.pacId=programacion.pacId)
                                LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)
                                LEFT JOIN admPersonalHS ON (admPersonalHS.perId=programacion.perId)
                                LEFT JOIN phdActividad ON (phdActividad.actId=programacion.actId)
                                LEFT JOIN phdNovedad ON (phdNovedad.prgId=programacion.prgId)
                            WHERE programacion.prgFechaProg BETWEEN @inicio AND @fin
                            AND (@asegurador=0 OR programacion.entId=@asegurador)
                            AND (@personal=0 OR programacion.perId=@personal)
                            AND (@procedimiento=0 OR programacion.actId=@procedimiento)
                            ORDER BY programacion.prgFechaProg,phdPaciente.pacNombres">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="TPersonalID" Name="personal" PropertyName="Text" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <uc3:novedad ID="UCNovedad" runat="server" OnAceptarClicked="UCNovedad_AceptarClicked" Visible="false" OnCancelarClicked="UCNovedad_CancelarClicked" />
</asp:Content>