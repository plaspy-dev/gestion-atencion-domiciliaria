<%@ Page Title="Evoluciones" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="terapeutico_evoluciones" Codebehind="evoluciones.aspx.cs" %>
<%@ Register src="~/paciente/pacienteSimple.ascx" tagname="PacienteSimple" tagprefix="uc5" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#<%= TProcedimiento.ClientID %>")._autoComplete({
                url: "../webservices/servicios.asmx/GetMedicamentos",
                data: { t: 173 },
                idField: "<%= TProcedimientoID.ClientID %>"
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Inicio</td>
            <td>Fin</td>
            <td>Asegurador</td>
            <td>Paciente</td>
            <td>Funcionario</td>
            <td>Servicio</td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TInicio" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFin" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFin" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:DropDownList ID="DAsegurador" runat="server"  CssClass="anchomaxcombo"
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
                <uc5:PacienteSimple runat="server" ID="UCPaciente" />
            </td>
            <td>
                <uc1:funcionario runat="server" ID="UCFuncionario" />
            </td>
            <td>
                <asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hidet"></asp:TextBox>
            </td>
            <td>
                <asp:Button runat="server" ID="BBuscar" Text="Actualizar" OnClick="BBuscar_Click" />
            </td>
        </tr>
    </table>
        </asp:Panel>
    <br />
    <div id="dImprimir">
        <asp:UpdatePanel ID="PResultados" runat="server">
            <ContentTemplate>
                <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
                    AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones"
                    AllowPaging="True" PageSize="50" AllowSorting="True" DataKeyNames="id,paciente,evolucion" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Fecha" SortExpression="fecha" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <asp:HyperLink runat="server" ID="H" NavigateUrl='<%# string.Format(Eval("evolucion").ToString()=="1" 
                                        ? "~/terapeutico/evolucion.aspx?pid={0}&evtid={1}" 
                                        : "~/paciente/valoracionat.aspx?pid={0}&vatid={1}", Eval("paciente"), Eval("id")) %>' Text='<%# Eval("Fecha") %>' Target="_blank"></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-Wrap="false"/>
                        <asp:BoundField HeaderText="Paciente" DataField="pacNombres" SortExpression="pacNombres" ItemStyle-Wrap="false"/>
                        <asp:BoundField HeaderText="Funcionario" DataField="perNombre" SortExpression="perNombre" ItemStyle-Wrap="false"/>
                        <asp:BoundField HeaderText="Servicio" DataField="nombre" SortExpression="nombre" ItemStyle-Wrap="false" />
                        <asp:BoundField HeaderText="Sesión" DataField="sesion" SortExpression="sesion" ItemStyle-HorizontalAlign="Right"/>
                        <asp:BoundField HeaderText="Logros" DataField="logros" SortExpression="logros"/>
                        <asp:BoundField HeaderText="Plan" DataField="plan" SortExpression="plan"/>
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="(SELECT evolucion_terapeutivo.id,evolucion_terapeutivo.paciente
                                ,paciente.pacNombres,recurso_humano.perNombre,asegurador.entNombre
                                ,evolucion_terapeutivo.fecha
                                ,evolucion_terapeutivo.sesion
                                ,evolucion_terapeutivo.logros
                                ,evolucion_terapeutivo.plan
                                , CONCAT(medicamentos.codigo, ' - ',medicamentos.nombre) AS nombre
                                ,1 AS evolucion
                                FROM evolucion_terapeutivo
                                LEFT JOIN paciente ON (paciente.pacId=evolucion_terapeutivo.paciente)
                                LEFT JOIN recurso_humano ON (recurso_humano.perId=evolucion_terapeutivo.funcionario)
                                LEFT JOIN medicamentos ON (medicamentos.id=evolucion_terapeutivo.tipo)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            WHERE DATE(evolucion_terapeutivo.fecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND (@paciente=0 OR evolucion_terapeutivo.paciente=@paciente)
                            AND (@personal=0 OR evolucion_terapeutivo.funcionario=@personal)
                            AND (@procedimiento=0 OR evolucion_terapeutivo.tipo=@procedimiento)
                            AND (@asegurador=0 OR paciente.entId=@asegurador)
                            ) UNION (
                            SELECT valoracionat.id,valoracionat.paciente
                                ,paciente.pacNombres,recurso_humano.perNombre,asegurador.entNombre
                                ,valoracionat.inicio AS fecha
                                ,1 AS sesion
                                ,valoracionat.observaciones AS logros
                                ,NULL AS plan
                                , CONCAT(medicamentos.codigo, ' - ',medicamentos.nombre) AS nombre
                                ,0 AS evolucion
                                FROM valoracionat
                                LEFT JOIN paciente ON (paciente.pacId=valoracionat.paciente)
                                LEFT JOIN recurso_humano ON (recurso_humano.perId=valoracionat.funcionario)
                                LEFT JOIN medicamentos ON (medicamentos.id=valoracionat.tipo)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                                    WHERE DATE(valoracionat.inicio) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                    AND (@paciente=0 OR valoracionat.paciente=@paciente)
                                    AND (@personal=0 OR valoracionat.funcionario=@personal)
                                    AND (@procedimiento=0 OR valoracionat.tipo=@procedimiento)
                                    AND (@asegurador=0 OR paciente.entId=@asegurador)
                            )
                            ORDER BY fecha">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="UCFuncionario" Name="personal" PropertyName="IdFuncionario" DefaultValue="0" />
                     <asp:ControlParameter ControlID="UCPaciente$TPacienteID" Name="paciente" PropertyName="Text" DefaultValue="0" />
                     <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>

    <asp:Panel runat="server" ID="PP" Visible="false">
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <asp:Label runat="server" ID="TPaciente"></asp:Label>
        <asp:Label runat="server" ID="LPaciente"></asp:Label>

        <!-- esto espara la evolucion-->
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
                    <asp:Parameter Name="valoracion" DefaultValue="" />
                </SelectParameters>
        </asp:SqlDataSource>

    </asp:Panel>
</asp:Content>

