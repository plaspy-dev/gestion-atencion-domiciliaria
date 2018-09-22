<%@ Page Title="Autorizaciones masivas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="admisiones_amasivas" Codebehind="amasivas.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        $.cookie('amasivas_paciente', $("#<%= TPacientes.ClientID %>").val(), { expires: 365 });
    });
    $(function () {
        $("#<%= TPaciente.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetPacienteI",
            data: { 'e': '<%= ViewState["entidades"].ToString() %>' },
            idField: "<%= TPacienteID.ClientID %>"
        });
        $("#<%= TProcedimiento.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetMedicamentos",
            data: { t: 173 },
            idField: "<%= TProcedimientoID.ClientID %>"
        });
        $("#<%=BAceptar.ClientID %>").click(function() { return confirm("¿Esta seguro de hacer " + $('#<%= GPacientes.ClientID %> input[src*="eliminar.gif"]').length + " programaciones?"); });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table style="width: 100%;">
        <tr>
            <td colspan="4">
                <asp:Label Text="" runat="server" ID="LError" ForeColor="Red"></asp:Label>
                <asp:ValidationSummary runat="server" ID="ValidationSummary1" />
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:TextBox runat="server" ID="TPacientes" CssClass="hidet"></asp:TextBox>
                <asp:GridView ID="GPacientes" runat="server" AutoGenerateColumns="False"  Width="100%"
                    DataKeyNames="Id" onrowdeleting="GPacientes_RowDeleting" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="D" CssClass="btn btn-danger btn-xs" CausesValidation="False" CommandName="Delete" ToolTip="Eliminar"><i class="fa fa-trash-o"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
                        <asp:BoundField DataField="NombreCompleto" HeaderText="Paciente" ItemStyle-Width="100%" />
                        <asp:BoundField DataField="NombreEntidad" HeaderText="Entidad" ItemStyle-Wrap="false" />
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td>
                Paciente
            </td>
            <td colspan="2">
                <asp:TextBox ID="TPaciente" Width="99%" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ValidationGroup="paciente" ControlToValidate="TPacienteID" ErrorMessage="Por favor seleccione un paciente." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                <asp:TextBox ID="TPacienteID" CssClass="hidet" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:Button ID="BAgregar" runat="server" Text="+" ValidationGroup="paciente" onclick="BAgregar_Click" />
            </td>
        </tr>
        <tr>
            <td>
                Fecha</td>
            <td>
                <asp:TextBox ID="TFecha" CssClass="fecha" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td>
                Vencimiento</td>
            <td>
                <asp:TextBox ID="TVencimiento" CssClass="fecha" runat="server"></asp:TextBox>
                <asp:RangeValidator ControlToValidate="TVencimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                <asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ErrorMessage="Por favor ingrese una fecha mayor." ControlToCompare="TFecha" 
                    ControlToValidate="TVencimiento" Display="Dynamic" Operator="GreaterThan" 
                    SetFocusOnError="True" Type="Date">*</asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td class="celdaTitulo" colspan="4">Servicios</td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GActivades" runat="server" DataSourceID="SActividades"  Width="100%"
                    AutoGenerateColumns="False" DataKeyNames="id" 
                    onselectedindexchanged="GActivades_SelectedIndexChanged" >
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
                            <asp:BoundField DataField="proc_id" HeaderText="idMedicamento" ItemStyle-CssClass="hidet" HeaderStyle-CssClass="hidet" />
                            <asp:BoundField DataField="procedimiento" HeaderText="Actividad" ItemStyle-Width="100%" />
                            <asp:BoundField DataField="numerosesiones" HeaderText="Núm. ses." ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="sesionesdia" HeaderText="Ses./día" ItemStyle-HorizontalAlign="Right" />
                        </Columns>
                    </asp:GridView>
                    <sdg:CustomDataSource ID="SActividades" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,nombre AS procedimiento,id AS proc_id,id AS sesionesdia,id AS numerosesiones FROM varios WHERE id IS NULL"
                            DeleteCommand="DELETE FROM autorizacion_detalle WHERE autNumero=@autorizacion AND actId=@id"
                            InsertCommand="INSERT INTO autorizacion_detalle (autNumero,actId,autNumSesiones,autSesionesDia) VALUES (@autorizacion,@proc_id,@numerosesiones,@sesionesdia)"
                            UpdateCommand="UPDATE autorizacion_detalle SET actId=@proc_id,autNumSesiones=@numerosesiones,autSesionesDia=@sesionesdia WHERE id=@id"
                            >
                    </sdg:CustomDataSource>
            </td>
        </tr>
        <tr>
            <td>Procedimiento<asp:RequiredFieldValidator ValidationGroup="procedimiento" ControlToValidate="TProcedimientoID" ErrorMessage="Por favor ingrese un procedimiento." ID="RProcedimiento" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hidet"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Número de sesiones<asp:RequiredFieldValidator ValidationGroup="procedimiento" ControlToValidate="TNumeroSesiones" ErrorMessage="Por favor ingrese un número." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TNumeroSesiones" CssClass="entero"></asp:TextBox></td>
            <td>Sesiones por día</td>
            <td><asp:TextBox runat="server" ID="TSesionesDia" CssClass="entero"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="3"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label></td>
            <td align="right"><asp:Button runat="server" ID="BProcedimiento" ValidationGroup="procedimiento" onclick="BProcedimiento_Click" Text="Agregar" /></td>
        </tr>
        <tr>
            <td>
                Observaciones</td>
            <td colspan="3">
                <asp:TextBox ID="TObservaciones" runat="server" TextMode="MultiLine" Width="99%"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4" align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                    CausesValidation="false" onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
</asp:Content>

