<%@ Page Title="Valoración enfermería" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="enfermeria.aspx.cs" Inherits="valoracion_enfermeria" %>
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
    </style>
    <script type="text/javascript">
        $(function () {
            $("#<%= PEvoluciones.ClientID %>").accordion({
                autoHeight: false,
                collapsible: true,
                active: false
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <uc4:detallepaciente ID="CCDetallePaciente" runat="server" Visible="false" />
    <asp:Panel ID="PEvoluciones" runat="server" Visible="false">
        <h3><a href="#"><asp:Label runat="server" ID="LEvoluciones"></asp:Label></a></h3>
        <div class="hidet">
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
                            <asp:HyperLink runat="server" ID="L" NavigateUrl='<%# string.Format("~/valoracion/enfermeria.aspx?pid={0}&veid={1}", Eval("paciente"), Eval("id")) %>'>
                                <i class="fa fa-edit"></i>
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
                SelectCommand="SELECT valoracion_enfermeria.id,valoracion_enfermeria.fecha
                            ,recurso_humano.perNombre
                            ,valoracion_enfermeria.paciente
                            FROM valoracion_enfermeria
                            LEFT JOIN recurso_humano ON (recurso_humano.perId=valoracion_enfermeria.funcionario)
                            WHERE valoracion_enfermeria.paciente=@paciente
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
            <td colspan="4" class="celdaTitulo">Revisión por sistemas</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TRevision" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Valoración por patrones</td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón de percepción y cuidado de la salud </td>
        </tr>
        <asp:Repeater runat="server" ID="RPercepcion" DataSourceID="SPersepcion">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SPersepcion" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_enfermeria_patron.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    WHERE varios.tipo=85 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Antecedentes</td>
        </tr>
        <asp:Repeater runat="server" ID="RAntecendentes" DataSourceID="SAntecedentes">
            <ItemTemplate>
                <tr>
                    <td><asp:CheckBox runat="server" ID="C" Text='<%# Eval("nombre") %>' Checked='<%# Eval("estado").ToString()=="1" %>' /><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                    <td colspan="3"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SAntecedentes" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre
                    ,IFNULL(valoracion_enfermeria_patron.estado,antecedentes_paciente.estado) AS estado
                    ,IFNULL(valoracion_enfermeria_patron.texto,antecedentes_paciente.observaciones) AS texto
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    LEFT JOIN antecedentes_paciente ON (antecedentes_paciente.paciente=@paciente AND antecedentes_paciente.motivo=varios.id)
                    WHERE varios.tipo=2 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
                <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón nutricional y metabólico</td>
        </tr>
        <asp:Repeater runat="server" ID="RNutricional" DataSourceID="SNutricional">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SNutricional" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_enfermeria_patron.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    WHERE varios.tipo=87 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaSubTitulo">Datos Antropométricos</td>
        </tr>
        <tr>
            <td>Talla</td>
            <td><asp:TextBox runat="server" ID="TTalla"></asp:TextBox></td>
            <td>Peso</td>
            <td><asp:TextBox runat="server" ID="TPeso"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón de eliminación</td>
        </tr>
        <asp:Repeater runat="server" ID="REliminacion" DataSourceID="SEliminacion">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SEliminacion" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_enfermeria_patron.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    WHERE varios.tipo=88 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón actividad y ejercicio</td>
        </tr>
        <asp:Repeater runat="server" ID="RActividad" DataSourceID="SActividad">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SActividad" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_enfermeria_patron.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    WHERE varios.tipo=89 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón sueño y descanso</td>
        </tr>
        <asp:Repeater runat="server" ID="RDescanso" DataSourceID="SDescanso">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SDescanso" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_enfermeria_patron.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    WHERE varios.tipo=90 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón cognitivo perceptual</td>
        </tr>
        <asp:Repeater runat="server" ID="RCognitivo" DataSourceID="SCognitivo">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SCognitivo" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_enfermeria_patron.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    WHERE varios.tipo=91 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón autopercepción y auto concepto</td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:CheckBoxList runat="server" ID="CAutoPersepcion" RepeatColumns="3" DataTextField="nombre" DataValueField="id" DataSourceID="SAutoPer"></asp:CheckBoxList>
                <asp:SqlDataSource ID="SAutoPer" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=96 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
            </td>
        </tr>
        <asp:Repeater runat="server" ID="RAutopercepcion" DataSourceID="SAutopercepcion">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SAutopercepcion" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_enfermeria_patron.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    WHERE varios.tipo=92 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón función y relación</td>
        </tr>
        <asp:Repeater runat="server" ID="RFuncion" DataSourceID="SFuncion">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SFuncion" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_enfermeria_patron.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    WHERE varios.tipo=93 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón sexual y reproductivo</td>
        </tr>
        <tr>
            <td>Hijos</td>
            <td><asp:TextBox runat="server" ID="THijos" CssClass="entero"></asp:TextBox></td>
            <td>Abortos</td>
            <td><asp:TextBox runat="server" ID="TAbortos" CssClass="entero"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Anticonceptivos</td>
            <td><asp:TextBox runat="server" ID="TAnticonceptivos"></asp:TextBox></td>
            <td>Menarquia</td>
            <td><asp:TextBox runat="server" ID="TMenarquia"></asp:TextBox></td>
        </tr>
        <tr>
            <td>FUR</td>
            <td><asp:TextBox runat="server" ID="TFUR"></asp:TextBox></td>
            <td>FUP</td>
            <td><asp:TextBox runat="server" ID="TFUP"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Autoexamen de mama</td>
            <td><asp:TextBox runat="server" ID="TAutoMama"></asp:TextBox></td>
            <td>Problemas de próstata</td>
            <td><asp:TextBox runat="server" ID="TProstata"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón de afrontamiento y tolerancia al stress</td>
        </tr>
        <asp:Repeater runat="server" ID="RTolerancia" DataSourceID="STolerancia">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="STolerancia" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_enfermeria_patron.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    WHERE varios.tipo=94 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Patrón de valores y creencias</td>
        </tr>
        <asp:Repeater runat="server" ID="RCreencias" DataSourceID="SCreencias">
            <ItemTemplate>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="L" Text='<%# Eval("nombre") %>'></asp:Label><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:TextBox runat="server" ID="T" Text='<%# Eval("texto") %>' Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SCreencias" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre,valoracion_enfermeria_patron.texto AS texto 
                    FROM varios 
                    LEFT JOIN valoracion_enfermeria_patron ON (valoracion_enfermeria_patron.valoracion=@valoracion AND valoracion_enfermeria_patron.tipo=varios.id)
                    WHERE varios.tipo=95 AND varios.szReservado IS NULL 
                    ORDER BY nombre">
            <SelectParameters>
                <asp:ControlParameter ControlID="HIdValoracion" Name="valoracion" PropertyName="Value" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="4" class="celdaTitulo">Plan de intervención </td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TPlanIntervencion" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Interconsultas (indicación)</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TInterconsultas" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
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

