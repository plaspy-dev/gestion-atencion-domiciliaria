<%@ Page Title="Paciente" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="pacientes.aspx.cs" Inherits="eventos_pacientes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
.diagnostico 
{
    max-width: 300px;
    width: 99%;
}
</style>
<script type="text/javascript">
    var fecha_actual = null;
    $(function() {
        $("#<%= TDocumento.ClientID %>").blur(function() { if ($.getUrlVar('id') != $(this).val()) $("#<%= BBuscar.ClientID %>").click(); });
        $('#<%= UAtencion.ClientID %>').panelUpdated(function() {
            addDialog("#<%= UAtencion.ClientID %>", "#<%= DAtencion.ClientID %>");
            $("#<%= TFecha.ClientID %>").focusout(function() {
                var fecha = $(this).val();
                fecha= fecha.split(' ')[0];
                if (fecha != fecha_actual) {
                    fecha_actual = fecha;
                    $("#<%= BActualizar.ClientID %>").click();
                }
            });
            $("#<%= TCIE10.ClientID %>")._autoComplete({
                url: "../webservices/servicios.asmx/GetCodigoDiagnosticos",
                idField: "<%= TCIE10Id.ClientID %>"
            });
        });
    });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <fieldset>
    <legend>Datos Personales</legend>
    <table style="width: 100%;">
        <tr>
            <td>
                Documento</td>
            <td>
                <asp:TextBox CssClass="entero" ID="TDocumento" runat="server"></asp:TextBox>
                <asp:Button ID="BBuscar" CssClass="hidet" runat="server" Text="..." onclick="BBuscar_Click" CausesValidation="false" />
                <asp:RequiredFieldValidator ID="R4" runat="server" 
                    ControlToValidate="TDocumento" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un documento." SetFocusOnError="True">*</asp:RequiredFieldValidator>
            </td>
            <td>
                &nbsp;
                <asp:HiddenField ID="HDocumento" runat="server" />
            </td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Nombres</td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="R5" runat="server" 
                    ControlToValidate="TNombres" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un ." SetFocusOnError="True">*</asp:RequiredFieldValidator>
            </td>
            <td>
                Apellidos</td>
            <td>
                <asp:TextBox ID="TApellidos" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="R6" runat="server" 
                    ControlToValidate="TApellidos" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un Apellido." SetFocusOnError="True">*</asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Edad</td>
            <td>
                <asp:TextBox ID="TEdad" runat="server" CssClass="entero"></asp:TextBox>
                <asp:RequiredFieldValidator ID="R7" runat="server" 
                    ControlToValidate="TEdad" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese una edad." SetFocusOnError="True">*</asp:RequiredFieldValidator>
                    </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
    </table>
    </fieldset>
    <fieldset>
        <legend>Atención</legend>
        <asp:UpdatePanel ID="UAtencion" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table width="100%">
                <tr>
                    <td>
                        <asp:GridView ID="GAtencion" runat="server" 
                            AutoGenerateColumns="False" DataKeyNames="id" Width="100%" 
                            onselectedindexchanged="GAtencion_SelectedIndexChanged" 
                            onrowdeleting="GAtencion_RowDeleting">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Columns>
                <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="S" CssClass="btn btn-success btn-xs" CausesValidation="False" CommandName="Select" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
                <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="D" CssClass="btn btn-danger btn-xs" CausesValidation="False" CommandName="Delete" ToolTip="Eliminar"><i class="fa fa-trash-o"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
                <asp:BoundField DataField="Fecha" HeaderText="Fecha" ItemStyle-Wrap="false" />
                <asp:BoundField DataField="NombreEvento" HeaderText="Evento" ItemStyle-Wrap="false" />
                <asp:BoundField DataField="CIE10" HeaderText="CIE10" />
                <asp:BoundField DataField="diagnostico" HeaderText="Diagnostico" ItemStyle-Width="100%" />
            </Columns>
            <SelectedRowStyle CssClass="selecteditem" />
        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Button ID="BMasAtencion" CausesValidation="false" runat="server" onclick="BMasAtencion_Click" Text="+" />
                    </td>
                </tr>
            </table>
            <asp:Panel runat="server" ID="DAtencion" title="Atención" Visible="false">
            <table>
                <tr>
                    <td>Fecha<asp:RequiredFieldValidator ID="R1" runat="server" ErrorMessage="Por favor ingrese una fecha." ControlToValidate="TFecha" SetFocusOnError="True" Display="Dynamic">*</asp:RequiredFieldValidator></td>
                    <td class="nw"><asp:TextBox ID="TFecha" runat="server" CssClass="fechahora"></asp:TextBox>
                    <asp:Button runat="server" ID="BActualizar" CausesValidation="false" Text="U" onclick="BActualizar_Click" CssClass="hidet" />
                    </td>
                </tr>
                <tr>
                    <td>Evento<asp:RequiredFieldValidator ControlToValidate="DEvento" ErrorMessage="Por favor seleccione un evento." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    <td><asp:DropDownList ID="DEvento" runat="server" DataSourceID="SEvento" CssClass="diagnostico"
                        DataTextField="nombre" DataValueField="id">
                        <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SEvento" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT programacion_evento.id AS id, CONCAT(programacion_evento.nombre,'-',varios.nombre) AS nombre 
                                FROM programacion_evento 
                                LEFT JOIN varios ON (varios.id=programacion_evento.lugar)
                                WHERE 
                                (@fecha=-1 AND DATE(NOW()) BETWEEN inicio AND fin)
                                OR (@fecha!=-1 AND STR_TO_DATE(@fecha, '%d/%m/%Y') BETWEEN inicio AND fin)
                                ORDER BY nombre" >
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="TFecha" Name="fecha" PropertyName="Text" DefaultValue="-1" />
                                </SelectParameters>
                </asp:SqlDataSource></td>
                </tr>
                <tr>
                    <td>CIE10<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese un CIE10." ControlToValidate="TCIE10Id" Display="Dynamic">*</asp:RequiredFieldValidator></td>
                    <td><asp:TextBox ID="TCIE10" runat="server" CssClass="diagnostico"  Width="99%"></asp:TextBox>
                            <asp:TextBox ID="TCIE10Id" runat="server" CssClass="hidet"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Diagnostico
                            <asp:RequiredFieldValidator ID="R3" runat="server" ErrorMessage="Por favor ingrese un diagnostico." ControlToValidate="TDiagnostico" SetFocusOnError="True" Display="Dynamic">*</asp:RequiredFieldValidator></td>
                    <td><asp:TextBox ID="TDiagnostico" CssClass="diagnostico" runat="server" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Tipo paciente</td>
                    <td><asp:DropDownList ID="DTipoPaciente" runat="server" DataSourceID="STipoPaciente" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true" CssClass="anchomaxcombo">
                    <asp:ListItem Text="Público" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="STipoPaciente" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=82 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td>Ambulancia</td>
                    <td class="nw">
                    <table>
                        <tr>
                            <td>
                            <asp:RadioButtonList ID="RAmbulancia" runat="server" RepeatColumns="3">
                                <asp:ListItem Text="(Ninguna)" Value=""></asp:ListItem>
                                <asp:ListItem Text="TAB" Value="1" ></asp:ListItem>
                                <asp:ListItem Text="TAM" Value="2"></asp:ListItem>
                            </asp:RadioButtonList>
                            </td>
                            <td>
                                <asp:DropDownList ID="DAmbulancia" runat="server" DataSourceID="SAmbulancia" CssClass="anchomaxcombo" 
                                    DataTextField="nombre" DataValueField="id">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SAmbulancia" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                    SelectCommand="(SELECT '' AS id,'(Ninguna)' AS nombre) UNION (SELECT codigo AS id,CONCAT(codigo,' (',IF(tipo=1, 'TAM', 'TAB'),')') AS nombre FROM programacion_evento_ambulancia WHERE evento=@evento ORDER BY nombre)">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="DEvento" DefaultValue="0" PropertyName="SelectedValue" Name="evento" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </td>
                        </tr>
                    </table>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td><asp:CheckBox runat="server" ID="CRemitido" Text="Remitido" /></td>
                </tr>
                <tr>
                    <td>Acompañante</td>
                    <td><asp:TextBox runat="server" ID="TAcompanante"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>IPS remisión</td>
                    <td><asp:TextBox ID="TIPS" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="2" align="right">
                        <asp:Button runat="server" ID="BAgregarA" Text="Aceptar" onclick="BAgregarA_Click" />
                        <asp:Button runat="server" ID="BCancelarA" CausesValidation="false" Text="Cancelar" OnClick="BCancelarA_Click" />
                    </td>
                </tr>
            </table>
            </asp:Panel>
        </ContentTemplate>
        </asp:UpdatePanel>
    </fieldset>
    <div style="text-align: right">
        <asp:ValidationSummary ID="V1" runat="server" ShowMessageBox="True" />
        <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
            onclick="BAceptar_Click" /><asp:Button ID="BCancelar" runat="server" 
            Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
    </div>
</asp:Content>

