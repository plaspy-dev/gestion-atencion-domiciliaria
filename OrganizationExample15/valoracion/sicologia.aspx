<%@ Page Title="Valoración psicología" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="sicologia.aspx.cs" Inherits="valoracion_sicologia" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .tableborder td input[type="text"] {
	        -webkit-box-sizing: border-box;
	        -moz-box-sizing: border-box;
	        box-sizing: border-box;
        }
        .checkwidth
        ,.checkboxList td {
            min-width: 105px;
            /*display: inline-block;*/
        }
        .otro {
            display: inline-block;
            min-width: 90px;
            padding-left: 20px;
            font-style: normal;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            $("#<%= PEvoluciones.ClientID %>").accordion({
                autoHeight: false,
                collapsible: true,
                active: false
            });
            $("input:text[id^=<%= RMotivoC.ClientID %>]").change(function () {
                $(this).closest("tr").find("input:checkbox").prop("checked", $(this).val());
            }).change();
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
                            <asp:HyperLink runat="server" ID="L" NavigateUrl='<%# string.Format("~/valoracion/sicologia.aspx?pid={0}&vsid={1}", Eval("paciente"), Eval("id")) %>'>
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
                SelectCommand="SELECT valoracion_sicologia.id,valoracion_sicologia.fecha
                            ,recurso_humano.perNombre
                            ,valoracion_sicologia.paciente
                            FROM valoracion_sicologia
                            LEFT JOIN recurso_humano ON (recurso_humano.perId=valoracion_sicologia.funcionario)
                            WHERE valoracion_sicologia.paciente=@paciente
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
            <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RF" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TFecha" CssClass="fechahora"></asp:TextBox></td>
            <td>Funcionario<asp:RequiredFieldValidator ControlToValidate="UCFuncionario$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="RRH" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><uc1:funcionario runat="server" ID="UCFuncionario" /></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Motivo de consulta</td>
        </tr>
        <asp:Repeater runat="server" ID="RMotivoC" DataSourceID="SMotivoC">
            <ItemTemplate>
                <tr>
                    <td colspan="2"><asp:CheckBox runat="server" ID="C" Text='<%# Eval("nombre") %>' Checked="false" /><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                    <td colspan="2"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SMotivoC" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_sicologia_varios.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_sicologia_varios ON (valoracion_sicologia_varios.valoracion=@valoracion AND valoracion_sicologia_varios.tipo=varios.id)
                    WHERE varios.tipo=109 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:Repeater runat="server" ID="RMotivoT" DataSourceID="SMotivoT">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SMotivoT" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_sicologia_varios.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_sicologia_varios ON (valoracion_sicologia_varios.valoracion=@valoracion AND valoracion_sicologia_varios.tipo=varios.id)
                    WHERE varios.tipo=110 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>        
        <tr>
            <td colspan="4"><b>ENFERMEDAD ACTUAL</b> (descripción del tipo de síntomas, evolución y condición actual. Motivo que el paciente argumenta para esta consulta. Explicación que el paciente le da a su condición. Intentos de solución previos y resultados. Conductas de búsqueda de ayuda. Consecuencias sobre vida de relación, laboral, tiempo libre, vida amorosa y sexual. Factores precipitantes. Historia de la enfermedad en caso de haberla)</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TEnfermedadActual" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4">Revisión por sistemas</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TRevisionSistemas" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Antecedentes</td>
        </tr>
        <asp:Repeater runat="server" ID="RAntecedentes" DataSourceID="SAntecedentes">
            <ItemTemplate>
                <tr>
                    <td class="nw"><asp:CheckBox runat="server" ID="C" Text='<%# Eval("nombre") %>' Checked='<%# Eval("estado").ToString()=="1" %>' /><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                    <td colspan="3"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SAntecedentes" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre
                    ,IFNULL(valoracion_sicologia_varios.estado,antecedentes_paciente.estado) AS estado
                    ,IFNULL(valoracion_sicologia_varios.texto,antecedentes_paciente.observaciones) AS texto
                    FROM varios 
                    LEFT JOIN valoracion_sicologia_varios ON (valoracion_sicologia_varios.valoracion=@valoracion AND valoracion_sicologia_varios.tipo=varios.id)
                    LEFT JOIN antecedentes_paciente ON (antecedentes_paciente.paciente=@paciente AND antecedentes_paciente.motivo=varios.id)
                    WHERE varios.tipo=2 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
                <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Perfil histórico de desarrollo y funcionamiento</td>
        </tr>
        <asp:Repeater runat="server" ID="RPerfil" DataSourceID="SPerfil">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SPerfil" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_sicologia_varios.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_sicologia_varios ON (valoracion_sicologia_varios.valoracion=@valoracion AND valoracion_sicologia_varios.tipo=varios.id)
                    WHERE varios.tipo=112 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4">Examen físico</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TExamenF" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Examen mental</td>
        </tr>
        <tr>
            <td>Porte</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CPorte" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SPorte"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SPorte" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=113 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Actitud</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CActitud" CssClass="checkboxList" RepeatColumns="5" DataTextField="nombre" DataValueField="id" DataSourceID="SActitud"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SActitud" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=114 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
                <i class="otro">Otra</i><asp:TextBox runat="server" ID="TActitud"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Conciencia</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CConciencia" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SConciencia"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SConciencia" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=115 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Orientación</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="COrientacion" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SOrientacion"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SOrientacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=116 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
                <i class="otro">¿En que?</i><asp:TextBox runat="server" ID="TOrientacion"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Memoria</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CMemoria" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SMemoria"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SMemoria" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=117 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
                <i class="otro">Otro</i><asp:TextBox runat="server" ID="TMemoria"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Atención</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CAtencion" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SAtencion"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SAtencion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=118 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Pensamiento</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CPensamiento" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SPensamiento"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SPensamiento" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=119 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
                <i class="otro">¿Cuáles?</i><asp:TextBox runat="server" ID="TPensamiento"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>(Curso)</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CCurso" RepeatColumns="5" CssClass="checkboxList nw" DataTextField="nombre" DataValueField="id" DataSourceID="SCurso"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SCurso" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=120 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Contenido</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CContenido" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SContenido"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SContenido" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=121 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Afecto</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CAfecto" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SAfecto"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SAfecto" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=122 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Tono</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CTono" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="STono"></asp:CheckBoxList>
                <asp:SqlDataSource ID="STono" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=123 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Sensopercepción</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CSensopercepcion" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SSensopercepcion"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SSensopercepcion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=124 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
                <i class="otro">¿Cuáles?</i><asp:TextBox runat="server" ID="TSensoPersepcion"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Conducta Motora</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CConductaMotora" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SConductaMotora"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SConductaMotora" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=125 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Inteligencia</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CInteligencia" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SInteligencia"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SInteligencia" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=126 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Lenguaje verbal</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CLenguajeVerbal" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SLenguajeVerbal"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SLenguajeVerbal" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=127 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Lenguaje escrito</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CLenguajeEscrito" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SLenguajeEscrito"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SLenguajeEscrito" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=128 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Lenguaje mímico</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CLenguajeMimico" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SLenguajeMimico"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SLenguajeMimico" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=129 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Sueño</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CSueno" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SSueno"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SSueno" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=130 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
                <i class="otro">Otros</i><asp:TextBox runat="server" ID="TSueno"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Conducta Alimentaria</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CConductaAlimentaria" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SConductaAlimentaria"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SConductaAlimentaria" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=131 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
                <i class="otro">Habitos extraños</i><asp:TextBox runat="server" ID="TConductaAlimentaria"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Conducta Sexual</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CConductaSexual" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SConductaSexual"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SConductaSexual" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=132 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Introspección</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CIntrospeccion" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SIntrospeccion"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SIntrospeccion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=133 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Prospección</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CProspeccion" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SProspeccion"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SProspeccion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=134 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Juicio</td>
            <td colspan="3" class="tdb">
                <asp:CheckBoxList runat="server" ID="CJuicio" RepeatColumns="5" CssClass="checkboxList" DataTextField="nombre" DataValueField="id" DataSourceID="SJuicio"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SJuicio" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=135 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td colspan="4">Resultados de paraclínicos</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TParaclinicos" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4">Análisis</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TAnalisis" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Impresión diagnóstica</td>
        </tr>
        <asp:Repeater runat="server" ID="RImpresionD" DataSourceID="SImpresionD">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SImpresionD" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_sicologia_varios.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_sicologia_varios ON (valoracion_sicologia_varios.valoracion=@valoracion AND valoracion_sicologia_varios.tipo=varios.id)
                    WHERE varios.tipo=136 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4">Pronostico</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TPronostico" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Plan de tratamiento</td>
        </tr>
        <asp:Repeater runat="server" ID="RPlanTratamiento" DataSourceID="SPlanTratamiento">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SPlanTratamiento" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_sicologia_varios.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_sicologia_varios ON (valoracion_sicologia_varios.valoracion=@valoracion AND valoracion_sicologia_varios.tipo=varios.id)
                    WHERE varios.tipo=137 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
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

