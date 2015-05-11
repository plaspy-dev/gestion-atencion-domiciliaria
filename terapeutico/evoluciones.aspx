<%@ Page Title="Evoluciones" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evoluciones.aspx.cs" Inherits="terapeutico_evoluciones" %>
<%@ Register src="~/paciente/pacienteSimple.ascx" tagname="PacienteSimple" tagprefix="uc5" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
                    AllowPaging="True" PageSize="50" AllowSorting="True" DataKeyNames="id,paciente" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:HyperLinkField HeaderText="Fecha" DataNavigateUrlFields="id,paciente" DataNavigateUrlFormatString="~/terapeutico/evolucion.aspx?pid={1}&evtid={0}" SortExpression="fecha" DataTextField="fecha" ItemStyle-Wrap="false" />
                        <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-Wrap="false"/>
                        <asp:BoundField HeaderText="Paciente" DataField="pacNombres" SortExpression="pacNombres" ItemStyle-Wrap="false"/>
                        <asp:BoundField HeaderText="Funcionario" DataField="perNombre" SortExpression="perNombre" ItemStyle-Wrap="false"/>
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
                SelectCommand="SELECT evolucion_terapeutivo.id,evolucion_terapeutivo.paciente
                                ,paciente.pacNombres,recurso_humano.perNombre,asegurador.entNombre
                                ,evolucion_terapeutivo.fecha
                                ,evolucion_terapeutivo.sesion
                                ,evolucion_terapeutivo.logros
                                ,evolucion_terapeutivo.plan
                                FROM evolucion_terapeutivo
                                LEFT JOIN paciente ON (paciente.pacId=evolucion_terapeutivo.paciente)
                                LEFT JOIN recurso_humano ON (recurso_humano.perId=evolucion_terapeutivo.funcionario)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            WHERE DATE(evolucion_terapeutivo.fecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND (@paciente=0 OR evolucion_terapeutivo.paciente=@paciente)
                            -- AND (@procedimiento=0 OR programacion.actId=@procedimiento)
                            AND (@personal=0 OR evolucion_terapeutivo.funcionario=@personal)
                            AND (@asegurador=0 OR paciente.entId=@asegurador)
                            ORDER BY fecha">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="UCFuncionario" Name="personal" PropertyName="IdFuncionario" DefaultValue="0" />
                     <asp:ControlParameter ControlID="UCPaciente$TPacienteID" Name="paciente" PropertyName="Text" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>

    <asp:Panel runat="server" ID="PP" Visible="false">
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <asp:Label runat="server" ID="TPaciente"></asp:Label>
        <asp:Label runat="server" ID="LPaciente"></asp:Label>
    </asp:Panel>
</asp:Content>

