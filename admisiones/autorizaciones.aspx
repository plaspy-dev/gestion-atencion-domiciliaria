<%@ Page Title="Admisiones" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="autorizaciones.aspx.cs" Inherits="admisiones_autorizaciones" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    function Calcular() {
    
        try {
            total = $("#<%= TValor.ClientID %>").autoNumeric('get');
        }  catch (ex) {return;}
        var abono = $("#<%= TAbono.ClientID %>").autoNumeric('get');

        $("#vpagado").each(function() {
            temp = parseFloat($(this).text().replace(/\./g, "").replace(/\$/g, "").replace(/,/g, "."));
            if (isNaN(temp))
                temp = 0;
            abono += temp;
        });

        $("#<%= LVPagado.ClientID %>").text(currencyFormatted(abono.toString()));
    }
    
    addFunctionToStart(function() {
        
        /*$("#<%= TValor.ClientID %>").change(function() {

            var total = $(this).autoNumeric('get');
            $("#vpagado").each(function() {
                temp = parseFloat($(this).text().replace(/\./g, "").replace(/\$/g, "").replace(/,/g, "."));
                if (isNaN(temp))
                    temp = 0;
                total -= temp;
            });
            $("#<%= TAbono.ClientID %>").val(total);
            $("#<%= TAbono.ClientID %>").autoNumeric('set', total);
            Calcular();
        });*/
        $("#<%= TAbono.ClientID %>").change(Calcular);
        Calcular();

        $("#<%= CGenerar.ClientID %>").change(function() {
            if ($(this).is(":checked")) {
                $("#tauto").show();
                $("#<%= TNumero.ClientID %>").attr("readonly", true);
            } else {
                $("#tauto").hide();
                $("#<%= TNumero.ClientID %>").attr("readonly", false);
            }
        }).change();

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

                $("#<%= TPaciente.ClientID %>").val(ui.item.value);
                $("#<%= BIr.ClientID %>").click();
                return false;
            }
        });
        $("#<%= TNumero.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetAutorizaciones",
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

                $.goURL("aut=" + ui.item.value);
                return false;
            }
        });
        $("#<%= PAutorizaciones.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });

        FullRowSelect("#<%= GAutorizaciones.ClientID %>");

        // suspender
        $("#<%= BSuspender.ClientID %>").click(function() {
            addDialog('#<%= PSuspender.ClientID%>', "#dSuspender", true);
            return false;
        });
        $("#<%= RAnular.ClientID %>").change(function() {
            if ($(this).is(":checked")) {
                $("#tsuspender").hide();
            } else {
                $("#tsuspender").show();
            }
        }).change();
        $("#<%= RSuspender.ClientID %>").change(function() {
            if ($(this).is(":checked")) {
                $("#tsuspender").show();
            } else {
                $("#tsuspender").hide();
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
            }
        }).change(function() { if ($(this).val() == "") $("#<%= TProcedimientoID.ClientID %>").val(""); });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:UpdatePanel runat="server" ID="PTodo" UpdateMode="Conditional">
    <ContentTemplate>
    <table style="width: 100%;">
        <tr>
            <td colspan="4">
                <asp:Label Text="" runat="server" ID="LError" ForeColor="Red"></asp:Label>
                <asp:ValidationSummary runat="server" ID="ValidationSummary1" />
            </td>
        </tr>
        <tr>
            <td width=1>
                Número<asp:HiddenField runat="server" ID="HIdAutorizacion" /><asp:HiddenField runat="server" ID="HId" />
            </td>
            <td width=1>
                <asp:TextBox ID="TNumero" runat="server"></asp:TextBox>
            </td>
            <td colspan="2">
                <asp:Label runat="server" ID="LEstado"></asp:Label>
                <asp:CheckBox ID="CGenerar" Text="Generar número automático" runat="server" />
                <asp:HyperLink runat="server" ID="HFormula" Target="_blank"></asp:HyperLink>
            </td>
        </tr>
        <tr id="tauto" class="hide">
            <td></td>
            <td></td>
            <td colspan="2">
                <asp:RadioButton ID="RPreautorizacion" Text="Es pre-autorización" runat="server" Checked="True" EnableViewState="False" GroupName="generar" /><br />
                <asp:RadioButton ID="RAutorizacion" Text="Es autorización definitiva" runat="server" GroupName="generar" />
            </td>
        </tr>
        <tr>
            <td>
                Paciente<asp:HiddenField runat="server" ID="HIdPaciente" /><asp:HiddenField runat="server" ID="HIdEntidad" />
            </td>
            <td>
                <asp:TextBox ID="TPaciente" CssClass="likenumber" runat="server"></asp:TextBox><asp:Button ID="BIr" runat="server" Text="Ir" CausesValidation="false" CssClass="hide" onclick="BIr_Click" />
            </td>
            <td colspan="2">
                <asp:Label ID="LInactivo" Text="Inactivo - " Font-Bold="true" runat="server" Visible="false"></asp:Label><asp:Label ID="LNombrePaciente" runat="server"></asp:Label>
            </td>
        </tr>
        <asp:PlaceHolder runat="server" ID="PDatos" Visible="false">
        <tr>
            <td colspan="4">
                <asp:Panel runat="server" ID="PPaciente">
                    <table width="100%" style="border-collapse: collapse">
                        <tr>
                            <td class=tda><b>Entidad</b></td>
                            <td class=tda><b>Afiliación</b></td>
                            <td align="right" class=tda>
                                <b>Porcentaje del servicio</b></td>
                            <td align="right" class=tda>
                                <b>Máximo por servicio</b></td>
                            <td align="right" class=tda>
                                <b>Máximo por año</b></td>
                            <td align="right" class=tda>
                                <b>Acumulado año</b></td>
                        </tr>
                        <tr>
                            <td class=tda nowrap="nowrap">
                                <asp:Label ID="LEntidad" runat="server"></asp:Label>
                            </td>
                            <td class=tda>
                                <asp:Label ID="LCategoria" runat="server"></asp:Label>
                            </td>
                            <td align="right" class=tda>
                                <asp:Label ID="LPorcentaje" runat="server"></asp:Label>
                            </td>
                            <td align="right" class=tda>
                                <asp:Label ID="LMaximoServicio" runat="server"></asp:Label>
                            </td>
                            <td align="right" class=tda>
                                <asp:Label ID="LMaximoano" runat="server"></asp:Label>
                            </td>
                            <td align="right" class=tda>
                                <asp:Label runat="server" ID="LAcumulado"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Panel ID="PAutorizaciones" runat="server">
                    <h3><a href="#"><asp:Label runat="server" ID="LAutorizaciones"></asp:Label></a></h3>
                    <div class="hide">
                        <asp:GridView ID="GAutorizaciones" runat="server" AutoGenerateColumns="False"  Width="100%"
                            DataKeyNames="autNumero" DataSourceID="SAutorizaciones"
                            EmptyDataText="No se encontraron autorizaciones de este usuario" >
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton CommandArgument='<%# Eval("autNumero") %>' ID="IIr" 
                                            runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" 
                                            onclick="IIr_Click"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="autNumero" HeaderText="Autorización" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="autFecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="detalles" HeaderText="Detalles" ItemStyle-Width="100%" HtmlEncode="false" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SAutorizaciones" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT autorizacion.autNumero, autorizacion.autFecha
                                        ,detalles.detalle AS detalles
                                        FROM autorizacion
                                        LEFT JOIN 
                                        (
                                        	SELECT autorizacion_detalle.autNumero
														 ,GROUP_CONCAT(CONCAT(medicamentos.nombre, ' (', IFNULL(autorizacion_detalle.autNumSesiones,0),'-',IFNULL(autorizacion_detalle.autSesionesDia,0),')') SEPARATOR '<br/>') AS detalle
                                            FROM autorizacion_detalle
	                                        LEFT JOIN medicamentos ON (medicamentos.id=autorizacion_detalle.actId)
	                                        GROUP BY autorizacion_detalle.autNumero
										) AS detalles ON (detalles.autNumero = autorizacion.autNumero)
                                        WHERE autorizacion.pacId=@paciente
                                        GROUP BY autorizacion.autNumero,detalles, autorizacion.autFecha
                                        ORDER BY autorizacion.autFecha DESC;">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdPaciente" PropertyName="Value" Name="paciente" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                Fecha
                <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>
                <asp:TextBox ID="TFecha" CssClass="fecha" runat="server"></asp:TextBox>
            </td>
            <td>
                Vencimiento<asp:RequiredFieldValidator ControlToValidate="TVencimiento" ErrorMessage="Por favor ingrese una fecha de vencimiento." ID="RequiredFieldValidator3" 
	                runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator><asp:RangeValidator ControlToValidate="TVencimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                <asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ErrorMessage="Por favor ingrese una fecha mayor." ControlToCompare="TFecha" 
                    ControlToValidate="TVencimiento" Display="Dynamic" Operator="GreaterThan" 
                    SetFocusOnError="True" Type="Date">*</asp:CompareValidator>
                </td>
            <td>
                <asp:TextBox ID="TVencimiento" CssClass="fecha" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td style="white-space: nowrap">
                Valor autorización</td>
            <td>
                <asp:TextBox ID="TValor" CssClass="dinero" runat="server"></asp:TextBox>
            </td>
            <td>
                </td>
            <td>
                </td>
        </tr>
        <tr>
            <td class="celdaTitulo" colspan="4">
                Copagos
                </td>
        </tr>
        <tr>
            <td colspan="2">
            <asp:GridView ID="GPagos" runat="server" AutoGenerateColumns="False"  Width="100%"
                DataKeyNames="id" DataSourceID="SPagos" EmptyDataText="No hay pagos" 
                    onselectedindexchanged="GPagos_SelectedIndexChanged" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                        <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                        <asp:BoundField DataField="recibo" HeaderText="Recibo" ItemStyle-Width="100%" />
                        <asp:TemplateField HeaderText="Valor">
                            <ItemTemplate>
                                <span id="vpagado"><%# Eval("valor", "{0:c}") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SPagos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id,valor,recibo FROM pago_autorizacion WHERE autNumero=@autorizacion"
                    DeleteCommand="DELETE FROM pago_autorizacion WHERE id=@id">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HIdAutorizacion" PropertyName="Value" Name="autorizacion" DefaultValue="" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
            <td valign="bottom" nowrap="nowrap">
                Valor pagado</td>
            <td valign="bottom">
                <asp:Label runat="server" Text="" ID="LVPagado"></asp:Label></td>
        </tr>
        <tr>
            <td>Número recibo</td>
            <td>
                <asp:TextBox ID="TRecibo" ValidationGroup="abono" runat="server"></asp:TextBox>
            </td>
            <td>
                Valor recibo</td>
            <td>
                <asp:TextBox ID="TAbono" ValidationGroup="abono" CssClass="dinero" runat="server"></asp:TextBox>Max: <asp:Label runat="server" ID="LMaximo"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" colspan="4">
                <asp:Button ID="BAgregar" ValidationGroup="abono" runat="server" Text="Agregar" onclick="BAgregar_Click" />
            </td>
        </tr>
        <tr>
            <td class="celdaTitulo" colspan="4">Servicios</td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GActivades" runat="server" DataSourceID="SActividades"  Width="100%"
                    AutoGenerateColumns="False" DataKeyNames="id" 
                    onselectedindexchanged="GActivades_SelectedIndexChanged" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField DataField="proc_id" HeaderText="idMedicamento" ItemStyle-CssClass="hide" HeaderStyle-CssClass="hide" />
                            <asp:BoundField DataField="procedimiento" HeaderText="Actividad" ItemStyle-Width="100%" />
                            <asp:BoundField DataField="numerosesiones" HeaderText="Núm. ses." ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="sesionesdia" HeaderText="Ses./día" ItemStyle-HorizontalAlign="Right" />
                        </Columns>
                    </asp:GridView>
                    <sdg:CustomDataSource ID="SActividades" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,nombre AS procedimiento,id AS proc_id,id AS sesionesdia,id AS numerosesiones,nombre AS verificacion FROM varios WHERE id IS NULL"
                            DeleteCommand="DELETE FROM autorizacion_detalle WHERE autNumero=@autorizacion AND actId=@id"
                            InsertCommand="INSERT INTO autorizacion_detalle (autNumero,actId,autNumSesiones,autSesionesDia, verificacion) VALUES (@autorizacion,@proc_id,@numerosesiones,@sesionesdia, @verificacion)"
                            UpdateCommand="UPDATE autorizacion_detalle SET actId=@proc_id,autNumSesiones=@numerosesiones,autSesionesDia=@sesionesdia WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdAutorizacion" PropertyName="Value" Name="autorizacion" DefaultValue="-1" />
                            </SelectParameters>
                    </sdg:CustomDataSource>
            </td>
        </tr>
        <tr>
            <td>Procedimiento<asp:RequiredFieldValidator ValidationGroup="procedimiento" ControlToValidate="TProcedimientoID" ErrorMessage="Por favor ingrese un procedimiento." ID="RProcedimiento" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hide"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Número de sesiones<asp:RequiredFieldValidator ValidationGroup="procedimiento" ControlToValidate="TNumeroSesiones" ErrorMessage="Por favor ingrese un número." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TNumeroSesiones" CssClass="entero"></asp:TextBox></td>
            <td>Sesiones por día</td>
            <td><asp:TextBox runat="server" ID="TSesionesDia" CssClass="entero"></asp:TextBox></td>
        </tr>
        <tr>
            <td align="right" colspan="4"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label><asp:Button runat="server" ID="BProcedimiento" ValidationGroup="procedimiento" onclick="BProcedimiento_Click" Text="Agregar" /></td>
        </tr>
        <tr>
            <td>
                Observaciones</td>
            <td colspan="3">
                <asp:TextBox ID="TObservaciones" runat="server" TextMode="MultiLine" Width="99%"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="4"><hr /></td>
        </tr>
        <tr>
            <td colspan="2">
            <asp:Button ID="BSuspender" runat="server" Text="Suspender" CausesValidation="false" />
            <asp:Button CausesValidation="false" runat="server" Text="Eliminar" ID="BEliminar" 
                    onclick="BEliminar_Click" OnClientClick="confirm('Esta acción eliminara la autorización, esta acción no se puede deshacer. ¿Esta seguro de continuar?');" />
            </td>
            <td colspan="2" align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                    CausesValidation="false" onclick="BCancelar_Click" />
            </td>
        </tr>
        </asp:PlaceHolder>
    </table>
    </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Panel runat="server" ID="PSuspender">
    <div id="dSuspender" title="Anular o suspender" class="hide">
        <table style="width: 100%;">
            <tr>
                <td>
                    <asp:RadioButton ID="RAnular" GroupName="anular" Checked="true" runat="server" Text="Anular"/>
                </td>
                <td>
                    <asp:RadioButton ID="RSuspender" GroupName="anular" runat="server" Text="Suspender"/>
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr id="tsuspender">
                <td>
                    Hasta
                </td>
                <td>
                    <asp:TextBox ID="TFSuspender" runat="server" CssClass="fecha"></asp:TextBox>
                    <asp:RangeValidator ValidationGroup="suspender" ControlToValidate="TFSuspender" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator2" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                    <asp:RequiredFieldValidator ValidationGroup="suspender" ControlToValidate="TFSuspender" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <asp:TextBox ID="TMotivo" TextMode="MultiLine" Height="100px" Width="99%" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="3" align="right">
                    <asp:ValidationSummary runat="server" ID="ValidationSummary" ValidationGroup="suspender" />
                    <asp:Button runat="server" ValidationGroup="suspender" ID="BASuspencion" Text="Aceptar" onclick="BASuspencion_Click" />
                </td>
            </tr>
        </table>
    </div>
    </asp:Panel>
</asp:Content>

