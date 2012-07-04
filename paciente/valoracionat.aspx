<%@ Page Title="Valoración apoyo terapéutico" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="valoracionat.aspx.cs" Inherits="paciente_valoracionat" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        function joinTableRows(selector, indice) {
            var anterior = null;
            selector.each(function() {
                if (anterior && anterior.children("td:eq(" + indice + ")").text() == $(this).children("td:eq(" + indice + ")").text()) {
                    anterior.children("td:eq(" + indice + ")").attr("rowspan", anterior.children("td:eq(" + indice + ")").attr("rowspan") + 1);
                    $(this).children("td:eq(" + indice + ")").remove();
                } else {
                    anterior = $(this);
                }
            });
            return selector;
        }

        function joinTableCells(selector) {
            var anterior = null;
            selector.each(function() {
                if (anterior && anterior.text() == $(this).text()) {
                    anterior.attr("colspan", anterior.attr("colspan") + 1);
                    $(this).remove();
                } else {
                    anterior = $(this);
                }
            });
            return selector;
        }

        $("#<%= PHistorial.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });
        FullRowSelect("#<%= GHistorial.ClientID %>");
        
        $("#<%= TTA.ClientID %>").mask("999/99");
        joinTableRows(joinTableRows($("#<%= GOxigeno.ClientID %> tr"), 1), 0);
        joinTableCells($("#<%= GOxigeno.ClientID %> tr:eq(0) th"));
        $("#<%= GFuerza.ClientID %> tbody tr:eq(0)").before("<tr class=GridHeader><th colspan=2></th><th colspan=2>Derecha</th><th colspan=2>Izquierda</th><th>Grados</th></tr>");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
        <ContentTemplate>
        <asp:HiddenField runat="server" ID="HIdValoracion" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table>
        <tr>
            <td colspan="4">
                <asp:Panel ID="PHistorial" runat="server">
                    <h3><a href="#"><asp:Label runat="server" ID="LHistorial"></asp:Label></a></h3>
                    <div class="hide">
                        <asp:GridView ID="GHistorial" runat="server" AutoGenerateColumns="False" 
                            DataSourceID="SHistorial" EmptyDataText="No se encontraron índices anteriores de este paciente" >
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton CommandArgument='<%# Eval("id") %>' ID="IIr" runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" onclick="IIr_Click"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="tipo" HeaderText="Tipo" />
                                <asp:BoundField DataField="inicio" HeaderText="Inicio" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="fin" HeaderText="Fin" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="numero_terapias" HeaderText="Numero de sesiones" ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="observaciones" HeaderText="Observaciones"/>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SHistorial" runat="server" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT valoracionat.id,valoracionat.numero_terapias, valoracionat.inicio,valoracionat.fin
                                        ,valoracionat.observaciones
                                        ,CASE valoracionat.tipo 
                                        WHEN 1 THEN 'Terapias respiratorias' 
                                        WHEN 2 THEN 'Terapias físicas' 
                                        WHEN 3 THEN 'Terapias ocupacionales y lenguaje' END
                                        AS tipo
                                        FROM valoracionat 
                                        WHERE valoracionat.paciente=@paciente
                                        ORDER BY valoracionat.inicio DESC
                                        ">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </asp:Panel>
            </td>
            </tr>
            <tr>
                <td>Tipo</td>
                <td><asp:DropDownList ID="DTipo" runat="server" AutoPostBack="True" 
                        onselectedindexchanged="DTipo_SelectedIndexChanged">
                    <asp:ListItem Text="Terapias respiratorias" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Terapias físicas" Value="2"></asp:ListItem>
                    <asp:ListItem Text="Terapias ocupacionales y lenguaje" Value="3"></asp:ListItem>
                </asp:DropDownList></td>
                <td>Número de terapias</td>
                <td><asp:TextBox runat="server" ID="TNumeroTerapias" CssClass="entero"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TNumeroTerapias" ErrorMessage="Por favor ingrese un número de terapias." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>Inicio</td>
                <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha inicial." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TInicio" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
                <td>Fin</td>
                <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFin" ErrorMessage="Por favor ingrese un fecha final." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFin" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
            </tr>
            <asp:Panel runat="server" ID="PRespiratoria">
            <tr>
                <td colspan="4" class="celdaTitulo">Terapias respiratorias</td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Oxigenodependiente</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:GridView ID="GOxigeno" runat="server" AutoGenerateColumns="False" DataSourceID="SOxigeno" DataKeyNames="id">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField DataField="grupo" HeaderText="Flujo en lt/min" />
                        <asp:BoundField DataField="nombre" HeaderText="Flujo en lt/min" />
                        <asp:BoundField DataField="descripcion" HeaderText="Flujo en lt/min" ItemStyle-HorizontalAlign="Center" />
                        <asp:TemplateField HeaderText="FI 02(%)" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TValor" Width="40px" Text='<%# Eval("valor") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SOxigeno" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="(SELECT 'Sistema de bajo flujo' AS grupo,varios.id,varios.nombre,varios.descripcion,valoracionat_oxigeno.valor FROM varios LEFT JOIN valoracionat_oxigeno ON (valoracionat_oxigeno.valoracion=@valoracion AND valoracionat_oxigeno.tipo=varios.id) WHERE varios.tipo=23 AND varios.szReservado IS NULL) 
                                    UNION 
                                    (SELECT 'Sistema de alto flujo' AS grupo,varios.id,varios.nombre,varios.descripcion,valoracionat_oxigeno.valor FROM varios LEFT JOIN valoracionat_oxigeno ON (valoracionat_oxigeno.valoracion=@valoracion AND valoracionat_oxigeno.tipo=varios.id) WHERE varios.tipo=24 AND varios.szReservado IS NULL)
                                    ">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
                      </SelectParameters>
                </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td><asp:CheckBox runat="server" ID="COxigeno" Text="Efectos secundarios del oxigeno" /></td>
                <td colspan="3"><asp:TextBox runat="server" ID="TOxigeno" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td nowrap="nowrap"><asp:CheckBox runat="server" ID="CLatrogenia" Text="Latrogenia por uso de dispositivos" /></td>
                <td colspan="3"><asp:TextBox runat="server" ID="TLatrogenia" Width="99%"></asp:TextBox></td>
            </tr>
            </asp:Panel>
            <asp:Panel runat="server" ID="PFisica">
            <tr>
                <td colspan="4" class="celdaTitulo">Terapias físicas</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:GridView ID="GFuerza" runat="server" AutoGenerateColumns="False" DataSourceID="SFuerza" DataKeyNames="id">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField DataField="nombre" HeaderText="" />
                        <asp:TemplateField HeaderText="Fuerza muscular" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TPuntaje" Width="40px" Text='<%# Eval("puntuacion") %>' CssClass="entero"></asp:TextBox>
                                <asp:RegularExpressionValidator ValidationExpression="^[012345]{1}$" ID="RegularExpressionValidator1" ControlToValidate="TPuntaje" ErrorMessage="Por favor ingrese una calificación valida." Display="Dynamic" SetFocusOnError="true" runat="server">*</asp:RegularExpressionValidator></td>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="descripcion" HeaderText="Grado" ItemStyle-HorizontalAlign="Center" />
                        <asp:TemplateField HeaderText="Movilidad" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TIzquierda" Width="40px" Text='<%# Eval("izquierda") %>' CssClass="entero"></asp:TextBox>
                                <asp:RegularExpressionValidator ValidationExpression="^[012345]{1}$" ID="RegularExpressionValidator2" ControlToValidate="TIzquierda" ErrorMessage="Por favor ingrese una calificación valida." Display="Dynamic" SetFocusOnError="true" runat="server">*</asp:RegularExpressionValidator></td>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="descripcion" HeaderText="Grado" ItemStyle-HorizontalAlign="Center" />
                        <asp:TemplateField HeaderText="Movilidad" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TDerecha" Width="40px" Text='<%# Eval("derecha") %>' CssClass="entero"></asp:TextBox>
                                <asp:RegularExpressionValidator ValidationExpression="^[012345]{1}$" ID="RegularExpressionValidator3" ControlToValidate="TDerecha" ErrorMessage="Por favor ingrese una calificación valida." Display="Dynamic" SetFocusOnError="true" runat="server">*</asp:RegularExpressionValidator></td>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="descripcion" HeaderText="Ideal" ItemStyle-HorizontalAlign="Center" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SFuerza" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,valoracionat_fuerza_muscular.izquierda,valoracionat_fuerza_muscular.derecha,valoracionat_fuerza_muscular.puntuacion
                                    FROM varios 
                                    LEFT JOIN valoracionat_fuerza_muscular ON (valoracionat_fuerza_muscular.valoracion=@valoracion AND valoracionat_fuerza_muscular.tipo=varios.id) 
                                    WHERE varios.tipo=25 AND varios.szReservado IS NULL">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
                      </SelectParameters>
                </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="center">
                    Nota: en la fuerza muscular defina de 0 a 5 según corresponda donde 5 es total y cero nula, se mide la fuerza de un movimiento articular
                </td>
            </tr>
            </asp:Panel>
            <asp:Panel runat="server" ID="PComun">
            <tr>
                <td>Justificación de la terapia</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TJustificacion" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Signos vitales</td>
            </tr>
            <tr>
                <td>TA</td>
                <td><asp:TextBox ID="TTA" runat="server" CssClass="likenumber"></asp:TextBox>mm/Hg</td>
                <td>FC</td>
                <td><asp:TextBox ID="TFC" runat="server" CssClass="entero"></asp:TextBox>Lat/min</td>
            </tr>
            <tr>
                <td>FR</td>
                <td><asp:TextBox ID="TFR" runat="server" CssClass="entero"></asp:TextBox>Min</td>
                <td>Sat 02</td>
                <td><asp:TextBox ID="TSaturacion" runat="server" CssClass="entero"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Revisión del patrón aterado</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TPatron" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Actividades realizadas</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TActividades" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Resultado diagnostico</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TResultados" Width="99%"></asp:TextBox></td>
            </tr>
            </asp:Panel>
            <asp:Panel runat="server" ID="POcupacional">
            <tr>
                <td colspan="4" class="celdaTitulo">Terapias ocupacionales y lenguaje</td>
            </tr>
            <tr>
                <td><asp:CheckBox runat="server" ID="CPresentoEA" Text="¿Se presento EA?" /></td>
                <td colspan="3"><asp:TextBox runat="server" ID="TPresentoEA" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Que medidas se realizarón</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TMedidas" Width="99%"></asp:TextBox></td>
            </tr>
            </asp:Panel>
            <tr>
                <td>Observaciones</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" align="right">
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                                <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                                <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" /></td>
            </tr>
        </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

