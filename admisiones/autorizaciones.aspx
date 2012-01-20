<%@ Page Title="Admisiones" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="autorizaciones.aspx.cs" Inherits="admisiones_autorizaciones" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        
        function currencyFormatted(amount) {
            var i = parseFloat(amount);
            if (isNaN(i)) { i = 0.00; }
            var minus = '';
            if (i < 0) { minus = '-'; }
            i = Math.abs(i);
            i = parseInt((i + .005) * 100);
            i = i / 100;
            s = new String(i);
            if (s.indexOf('.') < 0) { s += '.00'; }
            if (s.indexOf('.') == (s.length - 2)) { s += '0'; }
            s = minus + s;
            return '$' + commaFormatted(s);
        }

        function commaFormatted(amount) {

            var delimiter = ","; // replace comma if desired
            var a = amount.split('.', 2)
            var d = a[1];
            var i = parseInt(a[0]);
            if (isNaN(i)) { return ''; }
            var minus = '';
            if (i < 0) { minus = '-'; }
            i = Math.abs(i);
            var n = new String(i);
            var a = [];
            while (n.length > 3) {
                var nn = n.substr(n.length - 3);
                a.unshift(nn);
                n = n.substr(0, n.length - 3);
            }
            if (n.length > 0) { a.unshift(n); }
            n = a.join(delimiter);
            if (d.length < 1) { amount = n; }
            else { amount = n + '.' + d; }
            amount = minus + amount;
            return amount;
        }

        function Calcular() {

            total = $("#<%= TValor.ClientID %>").numeric('value');
            var abono = $("#<%= TAbono.ClientID %>").numeric('value');
                
            $("#vpagado").each(function() {
                temp= parseFloat($(this).text().replace(/\./g, "").replace(/\$/g, "").replace(/,/g, "."));
                if(isNaN(temp))
                    temp=0;
                abono+=temp;
            });

            $("#<%= LVPagado.ClientID %>").text(currencyFormatted(abono.toString()));
        }
        
        $("#<%= TValor.ClientID %>").change(function() {
            
            var total = $(this).numeric('value');
            $("#vpagado").each(function() {
                temp= parseFloat($(this).text().replace(/\./g, "").replace(/\$/g, "").replace(/,/g, "."));
                if(isNaN(temp))
                    temp=0;
                total-=temp;
            });
            $("#<%= TAbono.ClientID %>").val(total);
            $("#<%= TAbono.ClientID %>").numeric('value', total);
            Calcular();
        });
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
        });
        
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
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table style="width: 100%;">
        <tr>
            <td colspan="4">
                <asp:Label Text="" runat="server" ID="LError" ForeColor="Red"></asp:Label>
                <asp:ValidationSummary runat="server" ID="ValidationSummary1" />
            </td>
        </tr>
        <tr>
            <td>
                Número<asp:HiddenField runat="server" ID="HIdAutorizacion" />
            </td>
            <td>
                <asp:TextBox ID="TNumero" runat="server"></asp:TextBox>
            </td>
            <td colspan="2">
                <asp:CheckBox ID="CGenerar" Text="Generar número automático" runat="server" />
            </td>
        </tr>
        <tr id="tauto" class="hide">
            <td></td>
            <td></td>
            <td colspan="2">
                <asp:RadioButton ID="RPreautorizacion" Text="Es pre-autorización" 
                    runat="server" Checked="True" EnableViewState="False" GroupName="generar" /><br />
                <asp:RadioButton ID="RAutorizacion" Text="Es autorización definitiva" 
                    runat="server" GroupName="generar" />
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
        <tr>
            <td colspan="4">
                <asp:Panel runat="server" ID="PPaciente">
                    <table width="100%" border="1">
                        <tr>
                            <td><b>Entidad</b></td>
                            <td><b>Afiliación</b></td>
                            <td align="right">
                                <b>Porcentaje del servicio</b></td>
                            <td align="right">
                                <b>Máximo por servicio</b></td>
                            <td align="right">
                                <b>Máximo por año</b></td>
                            <td align="right">
                                <b>Acumulado año</b></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="LEntidad" runat="server"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="LCategoria" runat="server"></asp:Label>
                            </td>
                            <td align="right">
                                <asp:Label ID="LPorcentaje" runat="server"></asp:Label>
                            </td>
                            <td align="right">
                                <asp:Label ID="LMaximoServicio" runat="server"></asp:Label>
                            </td>
                            <td align="right">
                                <asp:Label ID="LMaximoano" runat="server"></asp:Label>
                            </td>
                            <td align="right">
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
                        <asp:GridView ID="GAutorizaciones" runat="server" AutoGenerateColumns="False" 
                            DataKeyNames="autNumero" DataSourceID="SAutorizaciones" EmptyDataText="No se encontraron autorizaciones de este usuario" >
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton CommandArgument='<%# Eval("autNumero") %>' ID="IIr" runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" onclick="IIr_Click"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="autNumero" HeaderText="Autorización" />
                                <asp:BoundField DataField="autFecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="detalles" HeaderText="Detalles" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SAutorizaciones" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:connBD %>" 
                            SelectCommand="SELECT phdAutorizacion.autNumero, phdAutorizacion.autFecha
                                        ,CASE LEN(detalles) WHEN 0 THEN detalles ELSE LEFT(detalles, LEN(detalles)-1) END AS detalles
                                        FROM phdAutorizacion
                                        CROSS APPLY
                                        (
                                            SELECT phdActividad.actDescripcion 
                                                + ' (' + CAST(ISNULL(phdDetalleAutorizacion.autNumSesiones,0) AS VARCHAR(9))
                                                + '-' + CAST(ISNULL(phdDetalleAutorizacion.autSesionesDia,0) AS VARCHAR(9)) + '), '
                                            FROM phdDetalleAutorizacion
	                                        LEFT JOIN phdActividad ON (phdActividad.actId=phdDetalleAutorizacion.actId)
                                            WHERE phdDetalleAutorizacion.autNumero = phdAutorizacion.autNumero
                                            FOR XML PATH('')
                                        ) pre_trimmed (detalles)
                                        WHERE phdAutorizacion.pacId=@paciente
                                        GROUP BY phdAutorizacion.autNumero,detalles, phdAutorizacion.autFecha
                                        ORDER BY phdAutorizacion.autFecha DESC;">
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
                Fecha</td>
            <td>
                <asp:TextBox ID="TFecha" CssClass="fecha" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td>
                Vencimiento</td>
            <td>
                <asp:TextBox ID="TVencimiento" CssClass="fecha" runat="server"></asp:TextBox>
                <asp:RangeValidator ControlToValidate="TVencimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                <asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ErrorMessage="Por favor ingrese una fecha mayor." ControlToCompare="TFecha" 
                    ControlToValidate="TVencimiento" Display="Dynamic" Operator="GreaterThan" 
                    SetFocusOnError="True" Type="Date">*</asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td style="white-space: nowrap">
                Valor autorización</td>
            <td>
                <asp:TextBox ID="TValor" CssClass="dinero" runat="server"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="celdaTitulo" colspan="4">
                Copagos
                </td>
        </tr>
        <tr>
            <td colspan="2">
            <asp:GridView ID="GPagos" runat="server" AutoGenerateColumns="False" 
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
                        <asp:BoundField DataField="recibo" HeaderText="Recibo" />
                        <asp:TemplateField HeaderText="Valor">
                            <ItemTemplate>
                                <span id="vpagado"><%# Eval("valor", "{0:c}") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SPagos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT id,valor,recibo FROM pago_autorizacion WHERE autNumero=@autorizacion"
                    DeleteCommand="DELETE FROM pago_autorizacion WHERE id=@id">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HIdAutorizacion" PropertyName="Value" Name="autorizacion" DefaultValue="" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
            <td valign="bottom">
                Valor pagado</td>
            <td valign="bottom">
                <asp:Label runat="server" Text="" ID="LVPagado"></asp:Label></td>
        </tr>
        <tr>
            <td>
                Número recibo</td>
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
                <asp:Button ID="BAgregar" ValidationGroup="abono" runat="server" Text="Agregar" 
                    onclick="BAgregar_Click" />
            </td>
        </tr>
        <tr>
            <td>
                Observaciones</td>
            <td colspan="3">
                <asp:TextBox ID="TObservaciones" runat="server" TextMode="MultiLine" Width="99%"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GActivades" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="actId" DataSourceID="SActividades" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
                        <asp:TemplateField HeaderText="Núm. ses.">
                            <ItemStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:TextBox ID="TNSesiones" Width="40" CssClass="entero" runat="server" Text='<%# Eval("autNumSesiones") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Ses./día">
                            <ItemStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:TextBox ID="TSDia" Width="40" CssClass="entero" runat="server" Text='<%# Eval("autSesionesDia") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SActividades" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT phdActividad.actId,phdActividad.actDescripcion,phdDetalleAutorizacion.autNumSesiones,phdDetalleAutorizacion.autSesionesDia
                                FROM phdActividad
                                LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero=@autorizacion AND phdDetalleAutorizacion.actId=phdActividad.actId)
                                ORDER BY phdActividad.actDescripcion;">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HIdAutorizacion" PropertyName="Value" Name="autorizacion" DefaultValue="-1" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="2">
            <asp:Button ID="BSuspender" runat="server" Text="Suspender" CausesValidation="false" />
            <asp:Button CausesValidation="false" runat="server" Text="Eliminar" ID="BEliminar" 
                    onclick="BEliminar_Click" OnClientClick="return confirm('Esta acción eliminara la autorización, esta acción no se puede deshacer. ¿Esta seguro de continuar?');" />
            </td>
            <td colspan="2" align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                    CausesValidation="false" onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
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

