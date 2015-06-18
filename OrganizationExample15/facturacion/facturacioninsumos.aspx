<%@ Page Title="Facturación insumos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="facturacioninsumos.aspx.cs" Inherits="facturacion_facturacioninsumos" %>
<%@ Register Src="~/paciente/pacienteSimple.ascx" TagName="pacienteSimple" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde<asp:RangeValidator ID="RangeValidator2" runat="server" Type="Date" ErrorMessage="Por favor ingrese una fecha valida." Text="*" MinimumValue="01/01/1900" MaximumValue="01/01/3000" SetFocusOnError="True" Display="Dynamic" ControlToValidate="TDesde">*</asp:RangeValidator></td>
            <td>Hasta<asp:RangeValidator ID="RangeValidator1" runat="server" 
                    ControlToValidate="THasta" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese una fecha valida." MaximumValue="01/01/3000" 
                    MinimumValue="01/01/1900" SetFocusOnError="True" Text="*" Type="Date">*</asp:RangeValidator></td>
            <td>Paciente<asp:RequiredFieldValidator ID="RPaciente" ControlToValidate="UCPaciente$TPacienteID" runat="server" ErrorMessage="Por favor ingrese un paciente" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox ID="TDesde" runat="server" CssClass="fecha" Text=""></asp:TextBox></td>
            <td><asp:TextBox ID="THasta" runat="server" CssClass="fecha" Text=""></asp:TextBox></td>
            <td><uc1:pacienteSimple runat="server" ID="UCPaciente" /></td>
            <td><asp:Button ID="BBuscar" runat="server" Text="Actualizar" onclick="BBuscar_Click" /></td>
        </tr>
    </table>
</asp:Panel>
<asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Visible="false"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron productos" 
        AllowSorting="True" ShowFooter="true"
        onrowdatabound="GResultados_RowDataBound" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:TemplateField HeaderText="Productos" FooterText="Total" SortExpression="producto" ItemStyle-Wrap="false">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="H" Text='<%# Eval("producto") %>' Target="_blank" NavigateUrl='<%# string.Format("~/farmacia/informes.aspx?f={0}&d={1}&m={2}&p={3}&r=1"
                        , HttpUtility.UrlEncode(TDesde.Text), HttpUtility.UrlEncode(THasta.Text), Eval("id"), UCPaciente.IdPaciente) %>'></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="Cantidad" DataField="total" SortExpression="total" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Costo" DataField="costo" SortExpression="costo" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" DataFormatString="{0:C0}" />
            <asp:BoundField HeaderText="Precio" DataField="valor" SortExpression="valor" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" DataFormatString="{0:C0}" />
            <asp:BoundField HeaderText="Utilidad" DataField="utilidad" SortExpression="utilidad" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" DataFormatString="{0:C0}" />
        </Columns>
    </asp:GridView>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id,consulta,producto,fecha,SUM(total) AS total,SUM(costo) AS costo,SUM(valor) AS valor,SUM(valor)-SUM(costo) AS utilidad FROM (
                    (
                        SELECT 2 AS consulta, salida_items{0}.producto AS id,salida{0}.fecha
                            ,medicamentos.nombre AS producto, salida_items{0}.cantidad AS total
                            ,salida_items{0}.cantidad*salida_items{0}.costo AS costo
                            ,salida_items{0}.cantidad*salida_items{0}.valor AS valor
                            FROM salida{0}
                            LEFT JOIN salida_items{0} ON (salida{0}.id=salida_items{0}.salida)
                            LEFT JOIN medicamentos ON (medicamentos.id=salida_items{0}.producto)
                        WHERE 
                        (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=salida{0}.fecha)
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=salida{0}.fecha)
                        AND (@paciente=0 OR salida{0}.paciente=@paciente)
                        ORDER BY id
                   ) UNION ALL (
                        SELECT 3 AS consulta, orden_compra_items{0}.producto AS id,orden_compra{0}.fecha
                            ,medicamentos.nombre AS producto, orden_compra_items{0}.cantidad AS total
                            ,orden_compra_items{0}.cantidad*orden_compra_items{0}.costo AS costo
                            ,orden_compra_items{0}.cantidad*orden_compra_items{0}.valor AS valor
                            FROM orden_compra{0}
                            LEFT JOIN orden_compra_items{0} ON (orden_compra{0}.id=orden_compra_items{0}.orden_compra)
                            LEFT JOIN medicamentos ON (medicamentos.id=orden_compra_items{0}.producto)
                        WHERE 
                        (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=orden_compra{0}.fecha)
                        AND orden_compra{0}.estado IS NULL
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=orden_compra{0}.fecha)
                        AND (@paciente=0 OR orden_compra{0}.paciente=@paciente)
                        ORDER BY id
                   ) UNION ALL (
                        SELECT 4 AS consulta, devolucion_items{0}.producto AS id,devolucion{0}.fecha
                            ,medicamentos.nombre AS producto, -devolucion_items{0}.cantidad AS total
                            ,-devolucion_items{0}.cantidad*devolucion_items{0}.costo AS costo
                            ,-devolucion_items{0}.cantidad*devolucion_items{0}.valor AS valor
                            FROM devolucion{0}
                            LEFT JOIN devolucion_items{0} ON (devolucion{0}.id=devolucion_items{0}.devolucion)
                            LEFT JOIN medicamentos ON (medicamentos.id=devolucion_items{0}.producto)
                        WHERE 
                        (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=devolucion{0}.fecha)
                        AND devolucion{0}.estado IS NULL
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=devolucion{0}.fecha)
                        AND (@paciente=0 OR devolucion{0}.paciente=@paciente)
                        ORDER BY id
                   )) AS t GROUP BY id ORDER BY producto
                        ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" PropertyName="Text" Name="desde" DefaultValue=" " />
                    <asp:ControlParameter ControlID="THasta" PropertyName="Text" Name="hasta" DefaultValue=" " />
                    <asp:ControlParameter ControlID="UCPaciente" PropertyName="IdPaciente" Name="paciente" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
<asp:UpdatePanel runat="server" ID="PTodo" UpdateMode="Conditional">
    <ContentTemplate>
    <table style="border-collapse: collapse;">
        <tr>
            <td colspan="4" class="celdaTitulo">Factura</td>
        </tr>
        <tr>
            <td class="tdl">Numero de factura<asp:RequiredFieldValidator ControlToValidate="TFactura" ErrorMessage="Por favor ingrese una factura." ID="RequiredFieldValidator4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TFactura" CssClass="entero" AutoPostBack="true" OnTextChanged="TFactura_TextChanged"></asp:TextBox></td>
            <td>Valor</td>
            <td class="tdr"><asp:Label runat="server" ID="LVFactura"></asp:Label></td>
        </tr>
        <tr>
            <td class="tdl">Fecha<asp:RequiredFieldValidator ControlToValidate="TFFactura" ErrorMessage="Por favor ingrese una fecha de facturación." ID="RequiredFieldValidator1" 
	                        runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TFFactura" CssClass="fecha"></asp:TextBox></td>
            <td>Vencimiento</td>
            <td class="tdr"><asp:TextBox runat="server" ID="TVencimientoF" CssClass="fecha"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="tdl">Radicación<asp:RequiredFieldValidator ControlToValidate="TRadicacion" ErrorMessage="Por favor ingrese una fecha de radicación." ID="RequiredFieldValidator3"  ValidationGroup="devolucion"
	                runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
	            </td>
            <td><asp:TextBox runat="server" ID="TRadicacion" CssClass="fecha"></asp:TextBox></td>
            <td>Devolución<asp:RequiredFieldValidator ControlToValidate="TDevolucion" ErrorMessage="Por favor ingrese un fecha de devolución." ID="RequiredFieldValidator5" 
	runat="server" Display="Dynamic" SetFocusOnError="true" ValidationGroup="devolucion">*</asp:RequiredFieldValidator></td>
            <td class="tdr"><asp:TextBox runat="server" ID="TDevolucion" CssClass="fecha rfecha"></asp:TextBox>
            <asp:Button runat="server" ID="BD" CssClass="hide" OnClick="BD_OnClicked" CausesValidation="false" />
            </td>
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
                            ,factura_causal_devolucion.causal
                            ,factura_causal_devolucion.valor
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
                        <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                        <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                        <asp:BoundField HeaderText="Radicación" SortExpression="antigua_radicacion" DataField="antigua_radicacion" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField HeaderText="Devolución" SortExpression="devolucion" DataField="devolucion" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField HeaderText="Valor" SortExpression="valor" DataField="valor" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" />
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
                                        ,SUM(factura_causal_devolucion.valor) AS valor
                                        FROM factura_devolucion 
                                        LEFT JOIN factura_causal_devolucion ON (factura_causal_devolucion.factura_devolucion=factura_devolucion.id)
                                        LEFT JOIN varios AS causal ON (causal.id=factura_causal_devolucion.causal)
                                        WHERE 
                                        factura_devolucion.factura=@factura
                                        GROUP BY factura_devolucion.id
                                        ORDER BY factura_devolucion.antigua_radicacion DESC">
                          <SelectParameters>
                            <asp:ControlParameter ControlID="TFactura" PropertyName="Text" Name="factura" DefaultValue="-1" />
                          </SelectParameters>
                    </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td class="tdl tdb">Pago</td>
            <td class="tdb"><asp:TextBox runat="server" ID="TPago" CssClass="fecha"></asp:TextBox></td>
            <td class="tdb"></td>
            <td class="tdr tdb"></td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
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
                    <asp:HiddenField runat="server" ID="HIdAutorizacion" /><!-- esto no se usa aqui -->
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
    </table>
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>