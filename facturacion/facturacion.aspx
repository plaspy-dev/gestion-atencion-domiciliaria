<%@ Page Title="Facturación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="facturacion.aspx.cs" Inherits="facturacion_facturacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
addFunctionToStart(function() {
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
        $("#<%= TDevolucion.ClientID %>").datepicker({ onSelect: function() {
            $("#<%= BD.ClientID %>").click();
        } }).change(function() {
            $("#<%= BD.ClientID %>").click();
        });

        FullRowSelect("#<%= GAutorizaciones.ClientID %>");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:UpdatePanel runat="server" ID="PTodo" UpdateMode="Conditional">
    <ContentTemplate>
    <table style="width: 100%;border-collapse: collapse;">
        <tr>
            <td width=1>
                Número<asp:HiddenField runat="server" ID="HIdAutorizacion" /><asp:HiddenField runat="server" ID="HId" />
            </td>
            <td width=1>
                <asp:TextBox ID="TNumero" runat="server"></asp:TextBox>
            </td>
            <td colspan="2">
                <asp:Label runat="server" ID="LEstado"></asp:Label>
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
                            DataKeyNames="autNumero" DataSourceID="SAutorizaciones" OnRowDataBound="GAutorizaciones_RowDataBound"
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
                                        GROUP BY autorizacion.autNumero,autorizacion.autFecha
                                        ORDER BY autorizacion.autFecha DESC;">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdPaciente" PropertyName="Value" Name="paciente" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </asp:Panel>
            </td>
        </tr>
        <asp:PlaceHolder runat="server" ID="PAutorizacion" Visible="false">
        <tr>
            <td>
                Fecha</td>
            <td>
                <asp:TextBox ID="TFecha" CssClass="fecha" runat="server" ReadOnly="true"></asp:TextBox>
            </td>
            <td>
                Vencimiento</td>
            <td>
                <asp:TextBox ID="TVencimiento" CssClass="fecha" runat="server" ReadOnly="true"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td style="white-space: nowrap">
                Valor autorización</td>
            <td>
                <asp:TextBox ID="TValor" CssClass="dinero" runat="server" ReadOnly="true"></asp:TextBox>
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
            <td colspan="4">
            <asp:GridView ID="GPagos" runat="server" AutoGenerateColumns="False"  Width="100%"
                DataKeyNames="id" DataSourceID="SPagos" EmptyDataText="No hay pagos">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
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
        </tr>
        <tr>
            <td class="celdaTitulo" colspan="4">Servicios</td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GActivades" runat="server" DataSourceID="SActividades"  Width="100%"
                    AutoGenerateColumns="False" DataKeyNames="actId,intensidad,autNumSesiones" OnRowDataBound="GActividades_RowDataBound">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:BoundField DataField="actId" HeaderText="Actividad" ItemStyle-Width="100%" />
                            <asp:BoundField DataField="autNumSesiones" HeaderText="Núm. ses." ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="autSesionesDia" HeaderText="Ses./día" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="intensidad" HeaderText="Intensidad" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
                            <asp:TemplateField HeaderText="Cantidad facturada" ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:TextBox runat="server" ID="TC" CssClass="entero" Width="20px" Text='<%# Eval("autNumSesiones") %>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Valor facturado" ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:TextBox runat="server" ID="TV" CssClass="dinero"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SActividades" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT autorizacion_detalle.actId,autorizacion_detalle.autNumSesiones
                            ,autorizacion_detalle.autSesionesDia, IFNULL(autorizacion_detalle.intensidad,0) AS intensidad
                            FROM autorizacion_detalle
                            WHERE autorizacion_detalle.autNumero=@autorizacion;">
                          <SelectParameters>
                            <asp:ControlParameter ControlID="HIdAutorizacion" PropertyName="Value" Name="autorizacion" DefaultValue="-1" />
                          </SelectParameters>
                    </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>
                Observaciones</td>
            <td colspan="3">
                <asp:TextBox ID="TObservaciones" runat="server" TextMode="MultiLine" Width="99%" ReadOnly="true"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Factura</td>
        </tr>
        <tr>
            <td class="tdl">Numero de factura<asp:RequiredFieldValidator ControlToValidate="TFactura" ErrorMessage="Por favor ingrese una factura." ID="RequiredFieldValidator4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TFactura" CssClass="entero" AutoPostBack="true" OnTextChanged="TFactura_TextChanged"></asp:TextBox></td>
            <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFFactura" ErrorMessage="Por favor ingrese una fecha de facturación." ID="RequiredFieldValidator1" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td class="tdr"><asp:TextBox runat="server" ID="TFFactura" CssClass="fecha"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="tdl">Radicación</td>
            <td><asp:TextBox runat="server" ID="TRadicacion" CssClass="fecha"></asp:TextBox></td>
            <td>Vencimiento</td>
            <td class="tdr"><asp:TextBox runat="server" ID="TVencimientoF" CssClass="fecha"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="tdl">Pago</td>
            <td><asp:TextBox runat="server" ID="TPago" CssClass="fecha"></asp:TextBox></td>
            <td>Devolución</td>
            <td class="tdr"><asp:TextBox runat="server" ID="TDevolucion" CssClass="fecha rfecha"></asp:TextBox>
            <asp:Button runat="server" ID="BD" CssClass="hide" OnClick="BD_OnClicked" CausesValidation="false" />
            </td>
        </tr>
        <asp:PlaceHolder runat="server" ID="PDevolucion" Visible="false">
        <tr>
            <td colspan="4" class="celdaTitulo">Devolución</td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GDevolucion" runat="server" AutoGenerateColumns="False" DataSourceID="SDevolucion" EmptyDataText="" DataKeyNames="id" Width="100%">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Causal" ItemStyle-Wrap="false" ItemStyle-Width="100%">
                            <ItemTemplate>
                                <asp:CheckBox runat="server" ID="CC" Text='<%# Eval("nombre") %>' Checked='<%# Eval("causal").ToString()!="" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Valor">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TV" CssClass="dinero" Text='<%# Eval("valor").ToString()=="" ? "" : Convert.ToDecimal(Eval("valor")).ToString(System.Globalization.CultureInfo.InvariantCulture) %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                </Columns>
               </asp:GridView>
               <asp:SqlDataSource ID="SDevolucion" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT varios.id, varios.nombre 
                            ,factura_devolucion.causal
                            ,factura_devolucion.valor
                            FROM varios 
                            LEFT JOIN factura_devolucion ON (factura_devolucion.factura=@factura AND factura_devolucion.causal=varios.id)
                            WHERE 
                            varios.tipo=74 AND varios.szReservado IS NULL 
                            ORDER BY varios.nombre">
                          <SelectParameters>
                            <asp:ControlParameter ControlID="TFactura" PropertyName="Text" Name="factura" DefaultValue="-1" />
                          </SelectParameters>
                    </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Segunda factura</td>
        </tr>
        <tr>
            <td class="tdl">Numero de factura</td>
            <td><asp:TextBox runat="server" ID="TFactura2" CssClass="entero" AutoPostBack="true" OnTextChanged="TFactura2_TextChanged"></asp:TextBox></td>
            <td>Fecha</td>
            <td class="tdr"><asp:TextBox runat="server" ID="TFFactura2" CssClass="fecha"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="tdl">Radicación</td>
            <td><asp:TextBox runat="server" ID="TRadicacion2" CssClass="fecha"></asp:TextBox></td>
            <td>Vencimiento</td>
            <td class="tdr"><asp:TextBox runat="server" ID="TVencimientoF2" CssClass="fecha"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="tdl">Pago</td>
            <td><asp:TextBox runat="server" ID="TPago2" CssClass="fecha"></asp:TextBox></td>
            <td></td>
            <td class="tdr"></td>
        </tr>
        </asp:PlaceHolder>
        <tr>
            <td colspan="4" class="celdaTitulo">Glosa</td>
        </tr>
        <tr>
            <td colspan="4" class="tdl tdr">
                <asp:GridView ID="GGlosa" runat="server" AutoGenerateColumns="False" DataSourceID="SGlosa" EmptyDataText="" DataKeyNames="id" Width="100%">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Causal" ItemStyle-Wrap="false" ItemStyle-Width="100%">
                            <ItemTemplate>
                                <asp:CheckBox runat="server" ID="CC" Text='<%# Eval("nombre") %>' Checked='<%# Eval("causal").ToString()!="" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Valor">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TV" CssClass="dinero" Text='<%# Eval("valor").ToString()=="" ? "" : Convert.ToDecimal(Eval("valor")).ToString(System.Globalization.CultureInfo.InvariantCulture) %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Aceptado">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TA" CssClass="dinero" Text='<%# Eval("valor_aceptado").ToString()=="" ? "" : Convert.ToDecimal(Eval("valor_aceptado")).ToString(System.Globalization.CultureInfo.InvariantCulture) %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Soportado">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TS" CssClass="dinero" Text='<%# Eval("valor_soportado").ToString()=="" ? "" : Convert.ToDecimal(Eval("valor_soportado")).ToString(System.Globalization.CultureInfo.InvariantCulture) %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                    <asp:SqlDataSource ID="SGlosa" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT varios.id, varios.nombre 
                            ,facturacion_autorizacion_glosa.causal
                            ,facturacion_autorizacion_glosa.valor
                            ,facturacion_autorizacion_glosa.valor_aceptado
                            ,facturacion_autorizacion_glosa.valor_soportado
                            FROM varios 
                            LEFT JOIN facturacion_autorizacion_glosa ON (facturacion_autorizacion_glosa.autorizacion=@autorizacion AND facturacion_autorizacion_glosa.causal=varios.id)
                            WHERE 
                            varios.tipo=75 AND varios.szReservado IS NULL 
                            ORDER BY varios.nombre">
                          <SelectParameters>
                            <asp:ControlParameter ControlID="HIdAutorizacion" PropertyName="Value" Name="autorizacion" DefaultValue="-1" />
                          </SelectParameters>
                    </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td class="tdl tdb"></td>
            <td class="tdb"></td>
            <td class="tdb">Conciliación</td>
            <td class="tdr tdb" align="right"><asp:TextBox runat="server" ID="TConciliacion" CssClass="fecha"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Label Text="" runat="server" ID="LError" ForeColor="Red"></asp:Label>
                <asp:ValidationSummary runat="server" ID="ValidationSummary1" />
            </td>
        </tr>
        <tr>
            <td colspan="2"></td>
            <td colspan="2" align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" onclick="BAceptar_Click" /> <asp:Button ID="BCancelar" runat="server" Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
            </td>
        </tr>
        </asp:PlaceHolder>
        </asp:PlaceHolder>
    </table>
    </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>