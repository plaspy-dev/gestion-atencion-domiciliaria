<%@ Page Title="Evaluación y evolución servicio terapeutico" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evolucion.aspx.cs" Inherits="terapeutico_evolucion" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
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
        $(function () {
            $("#<%= PEvoluciones.ClientID %>").accordion({
                autoHeight: false,
                collapsible: true,
                active: false
            });
            $("#<%= TTA.ClientID %>").mask("999/999");
            $("#<%= TFecha.ClientID%>").change(function () {
                uFechaFinal(this);
            });
            setTimeout(function() {
                uFechaFinal($("#<%= TFecha.ClientID%>")[0]);
            }, 1000);
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
                            <asp:HyperLink runat="server" ID="L" NavigateUrl='<%# string.Format("~/terapeutico/evolucion.aspx?pid={0}&evtid={1}", Eval("paciente"), Eval("id")) %>'>
                                <asp:Image runat="server" ID="I" ImageUrl="~/imgs/edit.gif" />
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="fecha" HeaderText="Fecha" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="perNombre" HeaderText="Funcionario" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="nombre" HeaderText="Tipo" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="sesion" HeaderText="Sesión" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="logros" HeaderText="Logros" ItemStyle-Width="100%" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SEvoluciones" runat="server" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                SelectCommand="SELECT evolucion_terapeutivo.id,evolucion_terapeutivo.fecha
                            ,recurso_humano.perNombre, CONCAT(medicamentos.codigo, ' - ',medicamentos.nombre) AS nombre
                            ,evolucion_terapeutivo.sesion
                            ,evolucion_terapeutivo.paciente
                            ,evolucion_terapeutivo.logros
                            FROM evolucion_terapeutivo
                            LEFT JOIN medicamentos ON (medicamentos.id=evolucion_terapeutivo.tipo)
                            LEFT JOIN recurso_humano ON (recurso_humano.perId=evolucion_terapeutivo.funcionario)
                            WHERE evolucion_terapeutivo.paciente=@paciente
                            ORDER BY fecha DESC;">
                <SelectParameters>
                    <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                </SelectParameters>
            </asp:SqlDataSource>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </asp:Panel><br />
    <asp:Panel runat="server" ID="PDatos" Visible="false">
            <table style="border-collapse: collapse">
                <tr>
                    <td>Fecha Inicio<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="R2" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una hora valida" Display="Dynamic" 
                            SetFocusOnError="true" ValidationExpression="^((?!00:00).)*$" runat="server" >*</asp:RegularExpressionValidator>
                        <sdg:DateTimeValidator runat="server" ID="DTV" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha valida." 
                    Display="Dynamic" SetFocusOnError="true">*</sdg:DateTimeValidator></td>
                    <td><asp:TextBox runat="server" ID="TFecha" CssClass="fechahora"></asp:TextBox>
                        <asp:Button runat="server" ID="TUF" CssClass="hide" Text="BUF" CausesValidation="false" OnClick="TUF_Click" />
                    </td>
                    <td>Final</td>
                    <td align="right"><asp:Label runat="server" ID="LFinal"></asp:Label></td>
                </tr>
                <tr>
                    <td>Atendido por<asp:RequiredFieldValidator ControlToValidate="UCFuncionario$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="RequiredFieldValidator1" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    <td colspan="3"><uc1:funcionario runat="server" ID="UCFuncionario" /></td>
                </tr>
                <tr>
                    <td>Tipo<asp:RequiredFieldValidator ControlToValidate="DTipo" ErrorMessage="Por favor seleccione un tipo." ID="RequiredFieldValidator2" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    <td><asp:DropDownList ID="DTipo" runat="server" DataSourceID="STipo" AutoPostBack="true" 
                            OnSelectedIndexChanged="DTipo_SelectedIndexChanged"
                            DataTextField="nombre" DataValueField="id" CssClass="anchomaxcombo">
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
                                ORDER BY nombre DESC">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                                <asp:ControlParameter ControlID="UCFuncionario" PropertyName="IdFuncionario" Name="funcionario" DefaultValue="0" />
                                <asp:ControlParameter ControlID="TFecha" PropertyName="Text" Name="fecha" />
                                <asp:Parameter Name="canUpdate" DefaultValue="0" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                    <td>Sesión No.<asp:RequiredFieldValidator ControlToValidate="TNumero" ErrorMessage="Por favor ingrese un número de sesion." ID="RequiredFieldValidator3" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    <td>
                        <asp:UpdatePanel runat="server" ID="US" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:TextBox runat="server" ID="TNumero" CssClass="entero"></asp:TextBox>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="DTipo" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="celdaTitulo">Signos vitales</td>
                </tr>
                <tr>
                    <td class="tdl">
                    FC<asp:RequiredFieldValidator ControlToValidate="TFC" ErrorMessage="Por favor ingrese una frecuencia cardiaca." ID="RequiredFieldValidator9" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td nowrap="nowrap">
                    <asp:TextBox ID="TFC" runat="server" CssClass="entero"></asp:TextBox>Lat/min</td>
                    <td>FR<asp:RequiredFieldValidator ControlToValidate="TFR" ErrorMessage="Por favor ingrese una frecuencia respiratoria." ID="RequiredFieldValidator10" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td class="tdr">
                    <asp:TextBox ID="TFR" runat="server" CssClass="entero"></asp:TextBox>
                    Min</td>
                </tr>
                <tr>
                    <td class="tdl tdb">TA</td>
                    <td class="tdb"><asp:TextBox ID="TTA" runat="server" CssClass="likenumber"></asp:TextBox>mm/Hg</td>
                    <td class="tdb"></td>
                    <td class="tdb tdr"></td>
                </tr>
                <tr>
                    <td>Logros obtenidos<asp:RequiredFieldValidator ControlToValidate="TLogros" ErrorMessage="Por favor ingrese unos logros." ID="RequiredFieldValidator5" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    <td colspan="3">
                        <asp:TextBox runat="server" Width="99%" ID="TLogros" TextMode="MultiLine"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>Plan de intervención<asp:RequiredFieldValidator ControlToValidate="TPlan" ErrorMessage="Por favor ingrese un plan de intervención." ID="RequiredFieldValidator6" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    <td colspan="3">
                        <asp:TextBox runat="server" Width="99%" ID="TPlan" TextMode="MultiLine"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:HyperLink runat="server" ID="HFoto" Text="Formato físico"></asp:HyperLink>
                        <asp:RegularExpressionValidator ID="R1" SetFocusOnError="true" ValidationExpression="^.+\.((jpg)|(JPG)|(jpeg)|(JPEG)|(PDF)|(pdf))$" Display="Dynamic" ControlToValidate="FArchivo" runat="server" ErrorMessage="Por favor seleccione un archivo de imagen JPG o un archivo PDF.">*</asp:RegularExpressionValidator>
                    </td>
                    <td colspan="3"><asp:FileUpload runat="server" ID="FArchivo" /></td>
                </tr>
                <tr>
                    <td colspan="4"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
                        <asp:ValidationSummary runat="server" ID="V" /></td>
                </tr>
                <tr>
                    <td><asp:Button Text="Eliminar" runat="server" ID="BEliminar" Visible="false" OnClientClick="confirm('¿Esta seguro de eliminar esta evolución?')" 
                                CausesValidation="false" onclick="BEliminar_Click" /></td>
                    <td colspan="3" align="right">
                        <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                        <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" />
                    </td>
                </tr>
            </table>
    </asp:Panel>
</asp:Content>

