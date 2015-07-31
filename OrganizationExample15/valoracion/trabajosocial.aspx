<%@ Page Title="Valoración trabajo social" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="trabajosocial.aspx.cs" Inherits="valoracion_trabajosocial" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .edad, .espacios {
            width: 40px;
        }
        .checkwidth
        ,#<%= CVarios.ClientID %> td
        ,#<%= CServicios.ClientID %> td
        ,#<%= CEstructura.ClientID %> td
        ,#<%= CPiso.ClientID %> td {
            min-width: 80px;
            display: inline-block;
        }
    </style>
    <script type="text/javascript">
        function onChangeCantidad(edit) {
            $(edit).parent().find("input:checkbox").prop("checked", $(edit).val());
        }
        $(function () {
            $("#<%= PEvoluciones.ClientID %>").accordion({
                autoHeight: false,
                collapsible: true,
                active: false
            });
            $("#<%= TBalance.ClientID %>").autoNumeric('init', { vMin: -9999999999, aSign: '$', aPad: false }).addClass("rdinero");
            $(".ingresos,.egresos").change(function () {
                var ingresos = 0, egresos = 0;
                $(".ingresos").each(function () {
                    ingresos+= +$(this).autoNumeric('get');
                });
                $(".egresos").each(function () {
                    egresos += +$(this).autoNumeric('get');
                });
                $("#<%= TIngresoTotal.ClientID %>").autoNumeric("set", ingresos);
                $("#<%= TEgresos.ClientID %>").autoNumeric("set", egresos);
                $("#<%= TBalance.ClientID %>").autoNumeric("set", ingresos-egresos);
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <uc4:detallepaciente ID="CCDetallePaciente" runat="server" Visible="false" />
    <asp:Panel ID="PEvoluciones" runat="server" Visible="false">
        <h3><a href="#"><asp:Label runat="server" ID="LEvoluciones"></asp:Label></a></h3>
        <div class="hide">
            <asp:UpdatePanel runat="server" ID="U" UpdateMode="Conditional">
                <ContentTemplate>
            <asp:GridView ID="GEvoluciones" runat="server" AutoGenerateColumns="False" Width="100%" 
                DataSourceID="SEvoluciones" AllowPaging="true" PageSize="10"
                EmptyDataText="No se encontraron evoluciones de este paciente">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:HyperLink runat="server" ID="L" NavigateUrl='<%# string.Format("~/valoracion/trabajosocial.aspx?pid={0}&etsid={1}", Eval("paciente"), Eval("id")) %>'>
                                <asp:Image runat="server" ID="I" ImageUrl="~/imgs/edit.gif" />
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="fecha" HeaderText="Fecha" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="perNombre" HeaderText="Funcionario" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SEvoluciones" runat="server" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                SelectCommand="SELECT valoracion_trabajo_social.id,valoracion_trabajo_social.fecha
                            ,recurso_humano.perNombre
                            ,valoracion_trabajo_social.paciente
                            FROM valoracion_trabajo_social
                            LEFT JOIN recurso_humano ON (recurso_humano.perId=valoracion_trabajo_social.funcionario)
                            WHERE valoracion_trabajo_social.paciente=@paciente
                            ORDER BY fecha DESC;">
                <SelectParameters>
                    <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                </SelectParameters>
            </asp:SqlDataSource>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </asp:Panel><br />
    <asp:Panel ID="PDatos" runat="server" Visible="false">
    <asp:HiddenField runat="server" ID="HIdValoracion" />
    <table class="tablecollapse tableborder">
        <tr>
            <td style="min-width: 101px;">Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RF" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td style="width: 1px;"><asp:TextBox runat="server" ID="TFecha" CssClass="fechahora"></asp:TextBox></td>
            <td style="width: 1px;">Funcionario<asp:RequiredFieldValidator ControlToValidate="UCFuncionario$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="RRH" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><uc1:funcionario runat="server" ID="UCFuncionario" /></td>
        </tr>
        <tr>
            <td class="celdaTitulo" colspan="4">Estructura Familiar</td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GEstructuraF" runat="server" AutoGenerateColumns="False" DataSourceID="SEstructuraF" EmptyDataText="No se encontraron datos">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Nombre" SortExpression="nombre">
                            <ItemTemplate><asp:TextBox runat="server" ID="N" Text='<%# Eval("nombre") %>'></asp:TextBox></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edad" SortExpression="edad">
                            <ItemTemplate><asp:TextBox runat="server" ID="E" Text='<%# Eval("edad") %>' CssClass="entero edad"></asp:TextBox></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Parentesco" SortExpression="parentesco">
                            <ItemTemplate><asp:TextBox runat="server" ID="P" Text='<%# Eval("parentesco") %>'></asp:TextBox></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Ocupación" SortExpression="ocupacion">
                            <ItemTemplate><asp:TextBox runat="server" ID="O" Text='<%# Eval("ocupacion") %>'></asp:TextBox></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Escolaridad" SortExpression="escolaridad">
                            <ItemTemplate><asp:TextBox runat="server" ID="S" Text='<%# Eval("escolaridad") %>'></asp:TextBox></ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SEstructuraF" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="(SELECT valoracion,numero,nombre,edad,
	                        parentesco,
	                        ocupacion,
	                        escolaridad
                            FROM valoracion_trabajo_social_familia
                            WHERE valoracion=@valoracion
                        ) UNION ALL (
	                        SELECT NULL,NULL,NULL,NULL,NULL,NULL,NULL
	                        FROM varios LIMIT 5
                        ) LIMIT 5">
                      <SelectParameters>
                          <asp:ControlParameter ControlID="HIdValoracion" PropertyName="Value" Name="valoracion" DefaultValue="0" />
                      </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>Tipología Familiar</td>
            <td><asp:DropDownList ID="DTipologiaF" runat="server" DataSourceID="STipologiaF" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguna)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="STipologiaF" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=97 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="4">Al interior de la familia existe algún acontecimiento que considere importante resaltar</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TAcontecimiento" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="3">Como afronta la familia las dificultades?</td>
            <td><asp:DropDownList ID="DAfrontaD" runat="server" DataSourceID="SAfrontaD" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguna)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SAfrontaD" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=98 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="4">En caso de presentarse dificultades acuden a alguien? Explicar.</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TAfrontaD" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Aspecto socioeconómico</td>
        </tr>
        <tr>
            <td colspan="4" class="celdaSubTitulo">Vivienda</td>
        </tr>
        <tr>
            <td>Tenencia</td>
            <td><asp:DropDownList ID="DTenencia" runat="server" DataSourceID="STenencia" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguna)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="STenencia" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=99 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td>Tipo de vivienda</td>
            <td><asp:DropDownList ID="DTipoVivienda" runat="server" DataSourceID="STipoVivienda" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguna)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="STipoVivienda" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=100 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Condiciones de la vivienda</td>
            <td><asp:DropDownList ID="DCondicionesVivienda" runat="server" DataSourceID="SCondicionesVivienda" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true" CssClass="anchomaxcombo">
                    <asp:ListItem Text="(Ninguna)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SCondicionesVivienda" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=101 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td class="nw">Pisos donde habita</td>
            <td><asp:TextBox runat="server" CssClass="entero" ID="TPisosHabita"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaSubTitulo">Material de la vivienda</td>
        </tr>
        <tr>
            <td>Piso</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CPiso" RepeatColumns="6" DataTextField="nombre" DataValueField="id" DataSourceID="SPiso"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SPiso" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=102 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Estructura</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CEstructura" RepeatColumns="6" DataTextField="nombre" DataValueField="id" DataSourceID="SEstructura"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SEstructura" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=103 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Espacios</td>
            <td colspan="3" class="tdb">
                <asp:Repeater runat="server" ID="REspacios" DataSourceID="SEspacios">
                    <ItemTemplate>
                        <span class="checkwidth">
                            <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                            <asp:CheckBox runat="server" ID="C" Text='<%# Eval("nombre") %>' Checked='<%# Eval("posicion").ToString()!="" && Eval("posicion").ToString()!="0" %>' /> <asp:TextBox runat="server" ID="T" CssClass="entero espacios" 
                                Text='<%# Eval("cantidad") %>' onchange="onChangeCantidad(this)"
                                Visible='<%# !string.IsNullOrEmpty(Eval("descripcion").ToString()) %>'></asp:TextBox>
                        </span>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SEspacios" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id, varios.nombre, varios.descripcion, FIND_IN_SET(varios.id, valoracion_trabajo_social.espacios) AS posicion
                        ,REPLACE(SUBSTRING(SUBSTRING_INDEX(valoracion_trabajo_social.espacios_cantidad, ',', FIND_IN_SET(varios.id, valoracion_trabajo_social.espacios)),
       LENGTH(SUBSTRING_INDEX(valoracion_trabajo_social.espacios_cantidad, ',', FIND_IN_SET(varios.id, valoracion_trabajo_social.espacios) -1)) + 1),
       ',', '') AS cantidad
                        FROM varios 
                        LEFT JOIN valoracion_trabajo_social ON (valoracion_trabajo_social.id=@valoracion)
                        WHERE tipo=104 AND szReservado IS NULL 
                        ORDER BY nombre">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HIdValoracion" PropertyName="Value" Name="valoracion" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td></td>
            <td colspan="3" class="tdb"><asp:CheckBoxList runat="server" ID="CVarios" RepeatColumns="6" DataTextField="nombre" DataValueField="id" DataSourceID="SVarios"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SVarios" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=108 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Servicios públicos</td>
            <td colspan="3">
                <asp:CheckBoxList runat="server" ID="CServicios" RepeatColumns="6" DataTextField="nombre" DataValueField="id" DataSourceID="SServicios"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SServicios" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=105 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Ingresos mensuales</td>
        </tr>
        <tr>
            <td>Numero de aportantes</td>
            <td><asp:TextBox runat="server" ID="TAportantes" CssClass="entero"></asp:TextBox></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:DataList ID="DIngresos" CssClass="tablecollapse" runat="server" RepeatColumns="2" DataSourceID="SIngresos" DataKeyField="id">
                    <ItemTemplate>
                        <table class="tablecollapse">
                            <tr>
                                <td style="width: 112px"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label></td>
                                <td style="width: 150px"><asp:TextBox runat="server" ID="T" CssClass="dinero ingresos" Text='<%# Eval("valor")==DBNull.Value ? "" : Convert.ToDecimal(Eval("valor")).ToString(System.Globalization.CultureInfo.InvariantCulture)  %>'></asp:TextBox></td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </asp:DataList>
                <asp:SqlDataSource ID="SIngresos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id, varios.nombre, valoracion_trabajo_social_economia.valor
                            FROM varios 
                            LEFT JOIN valoracion_trabajo_social_economia ON (valoracion_trabajo_social_economia.valoracion=@valoracion AND valoracion_trabajo_social_economia.tipo=varios.id)
                            WHERE varios.tipo=106 AND varios.szReservado IS NULL 
                            ORDER BY nombre">
                      <SelectParameters>
                          <asp:ControlParameter ControlID="HIdValoracion" PropertyName="Value" Name="valoracion" DefaultValue="0" />
                      </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>Ingreso Total</td>
            <td><asp:TextBox runat="server" ID="TIngresoTotal" CssClass="dinero" ReadOnly="true"></asp:TextBox></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Egresos mensuales</td>
        </tr>
        <tr>
            <td colspan="4" class="tdb">
                <asp:DataList runat="server" CssClass="tablecollapse" ID="DEgresos" RepeatColumns="2" DataSourceID="SEgresos" DataKeyField="id">
                    <ItemTemplate>
                        <table class="tablecollapse">
                            <tr>
                                <td style="width: 112px"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label></td>
                                <td style="width: 150px"><asp:TextBox runat="server" ID="T" CssClass="dinero egresos" Text='<%# Eval("valor")==DBNull.Value ? "" : Convert.ToDecimal(Eval("valor")).ToString(System.Globalization.CultureInfo.InvariantCulture)  %>'></asp:TextBox></td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </asp:DataList>
                <asp:SqlDataSource ID="SEgresos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id, varios.nombre, valoracion_trabajo_social_economia.valor
                            FROM varios 
                            LEFT JOIN valoracion_trabajo_social_economia ON (valoracion_trabajo_social_economia.valoracion=@valoracion AND valoracion_trabajo_social_economia.tipo=varios.id)
                            WHERE varios.tipo=107 AND varios.szReservado IS NULL 
                            ORDER BY nombre">
                      <SelectParameters>
                          <asp:ControlParameter ControlID="HIdValoracion" PropertyName="Value" Name="valoracion" DefaultValue="0" />
                      </SelectParameters>
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Egreso Total</td>
            <td><asp:TextBox runat="server" ID="TEgresos" CssClass="dinero" ReadOnly="true"></asp:TextBox></td>
            <td>Balance</td>
            <td><asp:TextBox runat="server" ID="TBalance" CssClass="dinero" ReadOnly="true"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4">Observaciones</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TObservaciones" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4">Diagnósticos</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TDiagnosticos" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4">Conclusiones</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TConclusiones" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="tdb"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label> <asp:ValidationSummary runat="server" ID="V" /></td>
        </tr>
        <tr>
            <td colspan="4" align="right" class="tds">
                <asp:Button runat="server" ID="BAceptar" Text="Aceptar" OnClick="BAceptar_Click" />
                <asp:Button runat="server" ID="BCancelar" Text="Cancelar" CausesValidation="false" OnClick="BCancelar_Click" />
            </td>
        </tr>
    </table>
    </asp:Panel>
</asp:Content>

