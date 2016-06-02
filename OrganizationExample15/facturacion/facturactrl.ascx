<%@ Control Language="C#" AutoEventWireup="true" CodeFile="facturactrl.ascx.cs" Inherits="facturacion_facturactrl" %>
    <tr>
        <td>
            <script type="text/javascript">
                addFunctionToStart(function() {
                    $("#<%= TAutorizacion.ClientID %>").autocomplete({
                        source: function(request, response) {
                            $.ajax({
                                url: "../webservices/servicios.asmx/GetAutorizacionesOPaciente",
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
                        search: function() {
                            $("#<%= TAutorizacionID.ClientID %>").val("");
                        },
                        select: function(event, ui) {
                            $("#<%= TAutorizacionID.ClientID %>").val(ui.item.value);
                        }
                    });
                    $("#<%= TDevolucion.ClientID %>,#<%= TPago.ClientID %>").datepicker({
                        onSelect: function () {
                        $("#<%= BD.ClientID %>").click();
                    } 
                    }).change(function() {
                        $("#<%= BD.ClientID %>").click();
                    });
                });
            </script>
            <asp:HiddenField runat="server" ID="HFactura" />
        </td>
    </tr>
    <tr>
        <td class="celdaTitulo" colspan="4"><asp:Label runat="server" ID="LFactura"></asp:Label></td>
    </tr>
    <tr>
        <td class="celdaTitulo" colspan="4">Autorizaciones</td>
    </tr>
    <tr>
        <td class="tdl tdr" colspan="4">
            <asp:UpdatePanel runat="server" ID="UGA" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:HiddenField runat="server" ID="HAutorizaciones" />
                    <asp:GridView ID="GAutorizacion" runat="server" AutoGenerateColumns="False" DataKeyNames="Autorizacion" OnRowDeleting="GAutorizacion_RowDeleting">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
		                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField DataField="Autorizacion" HeaderText="Número" ItemStyle-Wrap="false" />
                            <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                            <asp:BoundField DataField="NombrePaciente" HeaderText="Paciente" ItemStyle-Wrap="false" />
                        </Columns>
                    </asp:GridView>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="BAdd" />
                </Triggers>
            </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td class="tdl tdb">Autorización<asp:RequiredFieldValidator ValidationGroup="autorizacion" ControlToValidate="TAutorizacionID" ErrorMessage="Por favor ingrese un autorización." ID="R5" 
	        runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td colspan="3" class="tdr tdb">
            <asp:UpdatePanel runat="server" ID="UA" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:TextBox runat="server" ID="TAutorizacion"></asp:TextBox>
                    <asp:TextBox runat="server" ID="TAutorizacionID" CssClass="hidet"></asp:TextBox>
                    <asp:Button runat="server" ID="BAdd" Text="+" OnClick="BAdd_Clicked" ValidationGroup="autorizacion" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td class="tdl">Fecha</td>
        <td><div style="width: 103px; text-align: right;" ><asp:Label runat="server" ID="LFecha"></asp:Label></div></td>
        <td>Valor</td>
        <td class="tdr"><div style="width: 103px; text-align: right;" ><asp:Label runat="server" ID="LValor"></asp:Label></div></td>
    </tr>
    <tr>
        <td class="tdl">Radicación<asp:RequiredFieldValidator ControlToValidate="TRadicacion" ErrorMessage="Por favor ingrese una fecha de radicación." ID="R3"
	                runat="server" Display="Dynamic" SetFocusOnError="false">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TRadicacion" CssClass="fecha"></asp:TextBox></td>
        <td>Vencimiento<asp:RequiredFieldValidator ControlToValidate="TVencimientoF" ErrorMessage="Por favor ingrese una fecha de vencimiento." ID="R2"
	                runat="server" Display="Dynamic" SetFocusOnError="false">*</asp:RequiredFieldValidator></td>
        <td class="tdr"><asp:TextBox runat="server" ID="TVencimientoF" CssClass="fecha"></asp:TextBox></td>
    </tr>
    <tr>
        <td class="tdl">Pago</td>
        <td><asp:TextBox runat="server" ID="TPago" CssClass="fecha rfecha"></asp:TextBox></td>
        <td><asp:Label runat="server" ID="LDevolucion" Text="Devolución"></asp:Label></td>
        <td class="tdr"><asp:TextBox runat="server" ID="TDevolucion" CssClass="fecha rfecha"></asp:TextBox><asp:Button runat="server" ID="BD" CssClass="hidet" OnClick="BD_OnClicked" CausesValidation="false" /></td>
    </tr>
    <asp:PlaceHolder runat="server" ID="PDevolucion" Visible="false">
    <tr>
        <td colspan="4" class="celdaTitulo">Devolución</td>
    </tr>
    <tr>
        <td colspan="4" class="tdr tdl">
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
            </Columns>
           </asp:GridView>
           <asp:SqlDataSource ID="SDevolucion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id, varios.nombre 
                        ,factura_causal_devolucion.causal
                        FROM varios 
                        LEFT JOIN factura_causal_devolucion ON (factura_causal_devolucion.factura_devolucion=@factura_devolucion AND factura_causal_devolucion.causal=varios.id)
                        WHERE 
                        varios.tipo=74 AND varios.szReservado IS NULL 
                        ORDER BY varios.nombre">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="GDevoluciones" PropertyName="SelectedValue" Name="factura_devolucion" DefaultValue="-1" />
                      </SelectParameters>
                </asp:SqlDataSource>
        </td>
    </tr>
    <tr>
        <td colspan="4" align="right" class="tdl tdr tdb">
            <asp:Button runat="server" ID="BADevolucion" Text="Agregar" onclick="BADevolucion_Click" ValidationGroup="devolucion" />
            <asp:Button runat="server" ID="BCDevolucion" Text="Cancelar" onclick="BCDevolucion_Click" CausesValidation="false" />
        </td>
    </tr>
    </asp:PlaceHolder>
    <asp:PlaceHolder runat="server" ID="PDevoluciones">
    <tr>
        <td colspan="4" class="celdaTitulo">Devoluciones</td>
    </tr>
    <tr>
        <td colspan="4" class="tdl tdr">
            <asp:GridView ID="GDevoluciones" runat="server" AutoGenerateColumns="False" 
                DataSourceID="SDevoluciones" EmptyDataText="No se encontraron devoluciones" 
                DataKeyNames="id" Width="100%" onselectedindexchanged="GDevoluciones_SelectedIndexChanged">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" CausesValidation="false" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" CausesValidation="false" />
                    <asp:BoundField HeaderText="Radicación" SortExpression="antigua_radicacion" DataField="antigua_radicacion" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField HeaderText="Devolución" SortExpression="devolucion" DataField="devolucion" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField HeaderText="Causal" SortExpression="causal" DataField="causal" ItemStyle-Width="100%" />
            </Columns>
           </asp:GridView>
           <asp:SqlDataSource ID="SDevoluciones" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    DeleteCommand="DELETE FROM factura_devolucion WHERE id=@id"
                    SelectCommand="SELECT 
                                    factura_devolucion.id
                                    ,factura_devolucion.antigua_radicacion
                                    ,factura_devolucion.devolucion
                                    ,GROUP_CONCAT(causal.nombre) AS causal
                                    FROM factura_devolucion 
                                    LEFT JOIN factura_causal_devolucion ON (factura_causal_devolucion.factura_devolucion=factura_devolucion.id)
                                    LEFT JOIN varios AS causal ON (causal.id=factura_causal_devolucion.causal)
                                    WHERE 
                                    factura_devolucion.factura=@factura
                                    GROUP BY factura_devolucion.id
                                    ORDER BY factura_devolucion.antigua_radicacion DESC">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HFactura" PropertyName="Value" Name="factura" DefaultValue="-1" />
                      </SelectParameters>
                </asp:SqlDataSource>
        </td>
    </tr>
    </asp:PlaceHolder>
    <tr>
        <td colspan="4" class="tdl tdr">
            <asp:UpdatePanel runat="server" ID="U" UpdateMode="Conditional">
            <ContentTemplate>
            <asp:GridView ID="GDetalle" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encontraron datos" 
                Width="100%" DataKeyNames="Secuencia,Cantidad,_ValorMovimiento,_CodigoProducto" ShowFooter="true">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="_CodigoProducto" HeaderText="Código producto" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="_DescripcionDelMovimiento" HeaderText="Descripción" ItemStyle-Width="100%" FooterStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" DataFormatString="{0:0}" ItemStyle-HorizontalAlign="Right" FooterStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="_ValorMovimiento" HeaderText="Valor" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" />
                    <asp:TemplateField HeaderText="Procedimiento Autorización">
                        <ItemTemplate>
                            <asp:DropDownList ID="A" runat="server" DataSourceID="SActividad" CssClass="anchomaxcombo" 
                                DataTextField="nombre" DataValueField="id" OnDataBound="A_DataBound">
                            </asp:DropDownList>    
                            <asp:SqlDataSource ID="SActividad" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="(SELECT NULL AS id, '(Ninguno)' AS nombre ) UNION (
                                                SELECT CONCAT(autNumero,';',actId,';',autNumSesiones) AS id
                                                ,CONCAT(autNumero, ': ', medicamentos.codigo, ' - ',medicamentos.nombre, ' (', autNumSesiones, '-', autSesionesDia,')') AS nombre
                                                FROM autorizacion_detalle 
                                                LEFT JOIN medicamentos ON (medicamentos.id= autorizacion_detalle.actId)
                                                WHERE FIND_IN_SET(autorizacion_detalle.autNumero,@autorizacion)!=0 ORDER BY nombre);">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="HAutorizaciones" Name="autorizacion" PropertyName="Value" DefaultValue="-1" />
                                        </SelectParameters>
                            </asp:SqlDataSource>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>                        
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="BAdd" />
                <asp:AsyncPostBackTrigger ControlID="GAutorizacion" EventName="RowDeleting" />
            </Triggers>
        </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td colspan="4">&nbsp;</td>
    </tr>
    <asp:PlaceHolder runat="server" ID="PGlosa" Visible="false">
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
                        ,factura_glosa.causal
                        ,factura_glosa.valor
                        ,factura_glosa.valor_aceptado
                        ,factura_glosa.valor_soportado
                        FROM varios 
                        LEFT JOIN factura_glosa ON (factura_glosa.factura=@factura AND factura_glosa.causal=varios.id)
                        WHERE 
                        varios.tipo=75 AND varios.szReservado IS NULL 
                        ORDER BY varios.nombre">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HFactura" PropertyName="Value" Name="factura" DefaultValue="-1" />
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
    </asp:PlaceHolder>
    <tr>
        <td colspan="4" class="tdl tdr">&nbsp;
            <asp:ValidationSummary runat="server" ID="V" />
            <asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
        </td>
    </tr>
    <tr>
        <td colspan="4" align="right" class="tdl tdr tdb">
            <asp:Button runat="server" ID="BAceptar" Text="Aceptar" OnClick="BAceptar_Clicked" />
            <asp:Button runat="server" ID="BCancelar" CausesValidation="false" Text="Cancelar" OnClick="BCancelar_Clicked" />
        </td>
    </tr>