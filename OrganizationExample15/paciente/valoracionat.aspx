<%@ Page Title="Valoración apoyo terapéutico" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="valoracionat.aspx.cs" Inherits="paciente_valoracionat" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        var fechaActual=null;
        function uFechaFinal(e) {
            var final= new Date($(e).datetimepicker("getDate").getTime()+ <%= nMinutosTerapia %>*60000);
            $("#<%= LFinal.ClientID%>").text(
                $.datepicker.formatDate( $(e).datepicker("option", "dateFormat"), final)
                + " " + $.datepicker.formatTime($(e).datepicker("option", "timeFormat"), 
                $.extend({
                    hour: final.getHours(),
                    minute: final.getMinutes(),
                    second: final.getSeconds(),
                }, {}))
                );
            var fecha=$(e).datetimepicker("getDate");
            fecha.setHours(0,0,0,0);
            if(fechaActual==null || +fecha==+fechaActual) {
                fechaActual=fecha;
                return;
            }
            fechaActual=fecha;
            $("#<%= TUF.ClientID %>").click();
        }
        $("#<%= PHistorial.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });
        FullRowSelect("#<%= GHistorial.ClientID %>");

        $("#<%= TInicio.ClientID%>").change(function () {
            uFechaFinal(this);
        });
        setTimeout(function() {
            uFechaFinal($("#<%= TInicio.ClientID%>")[0]);
        }, 1000);
        
        $("#<%= TTA.ClientID %>").mask("999/999");
        // joinTableRows(joinTableRows($("#<%= GOxigeno.ClientID %> tr"), 1), 0);
        // joinTableCells($("#<%= GOxigeno.ClientID %> tr:eq(0) th"));
        $("#<%= GFuerza.ClientID %> tbody tr:eq(0)").before("<tr class=GridHeader><th colspan=2></th><th colspan=2>Derecha</th><th colspan=2>Izquierda</th><th>Grados</th></tr>");
        $("#<%= TObservaciones.ClientID %>").disablePaste();
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
                    <div class="hidet">
                        <asp:GridView ID="GHistorial" runat="server" AutoGenerateColumns="False" Width="100%"
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
                                <asp:BoundField DataField="inicio" HeaderText="Fecha" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="perNombre" HeaderText="Funcionario" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="nombre" HeaderText="Tipo" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="observaciones" HeaderText="Logros" ItemStyle-Width="100%" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SHistorial" runat="server" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT valoracionat.id, valoracionat.inicio
                                        ,recurso_humano.perNombre, CONCAT(medicamentos.codigo, ' - ',medicamentos.nombre) AS nombre
                                        ,valoracionat.observaciones
                                        FROM valoracionat 
           	                            LEFT JOIN medicamentos ON (medicamentos.id=valoracionat.tipo)
                            			LEFT JOIN recurso_humano ON (recurso_humano.perId=valoracionat.funcionario)
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
                <td>Fecha Inicio
                    <asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="R2" ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una hora valida" Display="Dynamic" 
                            SetFocusOnError="true" ValidationExpression="^((?!00:00).)*$" runat="server" >*</asp:RegularExpressionValidator>
                        <sdg:DateTimeValidator runat="server" ID="DTV" ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha valida." 
                    Display="Dynamic" SetFocusOnError="true">*</sdg:DateTimeValidator></td>
                <td><asp:TextBox runat="server" ID="TInicio" CssClass="fechahora"></asp:TextBox>
                    <asp:Button runat="server" ID="TUF" CssClass="hidet" Text="BUF" CausesValidation="false" OnClick="TUF_Click" />
                </td>
                <td>Final</td>
                <td align="right"><asp:Label runat="server" ID="LFinal"></asp:Label></td>
            </tr>
            <tr>
                <td>Tipo<asp:RequiredFieldValidator ControlToValidate="DTipo" ErrorMessage="Por favor seleccione un tipo." ID="RequiredFieldValidator3" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>
                    <asp:DropDownList ID="DTipo" runat="server" DataSourceID="STipo" 
                        DataTextField="nombre" DataValueField="id" CssClass="anchomaxcombo" AutoPostBack="true" OnSelectedIndexChanged="DTipo_SelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="STipo" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT CONCAT(programacion.autNumero, ';',programacion.actId) AS id, CONCAT(programacion.autNumero, ' - ', medicamentos.codigo, ' - ',medicamentos.nombre) AS nombre
                            FROM programacion 
                            LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId)
                            WHERE programacion.pacId=@paciente 
                            AND DATE(programacion.prgFechaProg)=STR_TO_DATE(@fecha, '%d/%m/%Y')
                            AND (@canUpdate=1 OR programacion.perId=@funcionario)
                            GROUP BY programacion.actId 
                            ORDER BY programacion.prgFechaProg DESC">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                            <asp:ControlParameter ControlID="UCFuncionario" PropertyName="IdFuncionario" Name="funcionario" DefaultValue="0" />
                            <asp:ControlParameter ControlID="TInicio" PropertyName="Text" Name="fecha" />
                            <asp:Parameter Name="canUpdate" DefaultValue="0" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </td>
                <td>Número de terapias</td>
                <td align="right"><asp:Label runat="server" ID="LNumeroTerapias"></asp:Label></td>
            </tr>
            <tr>
                <td>Atendido por<asp:RequiredFieldValidator ControlToValidate="UCFuncionario$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="RequiredFieldValidator1" 
	                runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td colspan="3"><uc1:funcionario runat="server" ID="UCFuncionario" /></td>
            </tr>
            <asp:PlaceHolder runat="server" ID="PRespiratoria" Visible="false">
            <tr>
                <td colspan="4" class="celdaTitulo">Terapias respiratorias</td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Oxigeno dependiente</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:GridView ID="GOxigeno" runat="server" AutoGenerateColumns="False" DataSourceID="SOxigeno" DataKeyNames="id" Width="100%">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField DataField="grupo" HeaderText="Flujo en lt/min" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="nombre" HeaderText="Flujo en lt/min" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="descripcion" HeaderText="Flujo en lt/min" ItemStyle-Width="100%"/>
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
                <td nowrap="nowrap"><asp:CheckBox runat="server" ID="CLatrogenia" Text="Iatrogenia por uso de dispositivos" /></td>
                <td colspan="3"><asp:TextBox runat="server" ID="TLatrogenia" Width="99%"></asp:TextBox></td>
            </tr>
            </asp:PlaceHolder>
            <asp:PlaceHolder runat="server" ID="PFisica" Visible="false">
            <tr>
                <td colspan="4" class="celdaTitulo">Terapias físicas</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:GridView ID="GFuerza" runat="server" AutoGenerateColumns="False" DataSourceID="SFuerza" DataKeyNames="id" Width="100%">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField DataField="nombre" HeaderText="" ItemStyle-Width="100%" />
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
            </asp:PlaceHolder>
            <asp:PlaceHolder runat="server" ID="PComun">
            <tr>
                <td>Objetivo terapéutico</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TJustificacion" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Signos vitales</td>
            </tr>
            <tr>
                <td>TA<asp:RequiredFieldValidator ControlToValidate="TTA" ErrorMessage="Por favor ingrese una tension arterial." ID="RequiredFieldValidator6" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><asp:TextBox ID="TTA" runat="server" CssClass="likenumber"></asp:TextBox>mm/Hg</td>
                <td>FC<asp:RequiredFieldValidator ControlToValidate="TFC" ErrorMessage="Por favor ingrese una frecuencia cardiaca." ID="RequiredFieldValidator9" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td class="nw"><asp:TextBox ID="TFC" runat="server" CssClass="entero"></asp:TextBox>Lat/min</td>
            </tr>
            <tr>
                <td>FR<asp:RequiredFieldValidator ControlToValidate="TFR" ErrorMessage="Por favor ingrese una frecuencia respiratoria." ID="RequiredFieldValidator10" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><asp:TextBox ID="TFR" runat="server" CssClass="entero"></asp:TextBox>Min</td>
                <td>Sat 02</td>
                <td><asp:TextBox ID="TSaturacion" runat="server" CssClass="entero"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Revisión del patrón alterado</td>
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
            </asp:PlaceHolder>
            <asp:PlaceHolder runat="server" ID="POcupacional" Visible="false">
            <tr>
                <td colspan="4" class="celdaTitulo"><asp:Label runat="server" ID="LTerapiaOcupacional" Text="Terapias ocupacionales"></asp:Label></td>
            </tr>
            <tr>
                <td><asp:CheckBox runat="server" ID="CPresentoEA" Text="¿Se presento EA?" /></td>
                <td colspan="3"><asp:TextBox runat="server" ID="TPresentoEA" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Que medidas se realizarón</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TMedidas" Width="99%"></asp:TextBox></td>
            </tr>
            </asp:PlaceHolder>
            <tr>
                <td>Observaciones</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td><asp:Button Text="Eliminar" runat="server" ID="BEliminar" Visible="false" OnClientClick="confirm('¿Esta seguro de eliminar esta valoración?')" 
                            CausesValidation="false" onclick="BEliminar_Click" /></td>
                <td colspan="3" align="right">
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                                <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                                <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" /></td>
            </tr>
        </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

