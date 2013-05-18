<%@ Page Title="Autorizaciones masivas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="amasivas.aspx.cs" Inherits="admisiones_amasivas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        $.cookie('amasivas_paciente', $("#<%= TPacientes.ClientID %>").val(), { expires: 365 });
    });
    $(function() {
        $("#<%= TPaciente.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPacienteI",
                    data: "{ 'q': '" + request.term + "', 'e': '<%= ViewState["entidades"].ToString() %>' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            select: function(event, ui) {

                $("#<%= TPaciente.ClientID %>").val(ui.item.label);
                $("#<%= TPacienteID.ClientID %>").val(ui.item.value);
                return false;
            }
        });
        $("#<%= TProcedimiento.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetMedicamentos",
                    data: "{ 'q': '" + request.term + "', 't': '173' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            select: function(event, ui) {
                $("#<%= TProcedimientoID.ClientID %>").val(ui.item.value);
                $("#<%= TProcedimiento.ClientID %>").val(ui.item.label);
                $("#<%= BIntensidad.ClientID %>").click();
                return false;
            },
            search: function(event, ui) {
                $("#<%= TProcedimientoID.ClientID %>").val("");
                // $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
            }
        }).change(function() { if ($(this).val() == "") $("#<%= TProcedimientoID.ClientID %>").val(""); });
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
                <asp:TextBox runat="server" ID="TPacientes" CssClass="hide"></asp:TextBox>
                <asp:GridView ID="GPacientes" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="Id" onrowdeleting="GPacientes_RowDeleting" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                        <asp:BoundField DataField="NombreCompleto" HeaderText="Paciente" />
                        <asp:BoundField DataField="NombreEntidad" HeaderText="Entidad" />
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
                <asp:TextBox ID="TPacienteID" CssClass="hide" runat="server"></asp:TextBox>
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
                <asp:GridView ID="GActivades" runat="server" DataSourceID="SActividades" 
                    AutoGenerateColumns="False" DataKeyNames="id" 
                    onselectedindexchanged="GActivades_SelectedIndexChanged" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField DataField="proc_id" HeaderText="idMedicamento" ItemStyle-CssClass="hide" HeaderStyle-CssClass="hide" />
                            <asp:BoundField DataField="procedimiento" HeaderText="Actividad" />
                            <asp:BoundField DataField="numerosesiones" HeaderText="Núm. ses." ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="sesionesdia" HeaderText="Ses./día" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="tint" HeaderText="Horas" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="idint" HeaderText="HorasId" ItemStyle-CssClass="hide" HeaderStyle-CssClass="hide" />
                        </Columns>
                    </asp:GridView>
                    <sdg:CustomDataSource ID="SActividades" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,nombre AS procedimiento,id AS proc_id,id AS sesionesdia,id AS numerosesiones,id AS idint,nombre AS tint FROM varios WHERE id IS NULL"
                            DeleteCommand="DELETE FROM phdDetalleAutorizacion WHERE autNumero=@autorizacion AND actId=@id"
                            InsertCommand="INSERT INTO phdDetalleAutorizacion (autNumero,actId,autNumSesiones,autSesionesDia, intensidad) VALUES (@autorizacion,@proc_id,@numerosesiones,@sesionesdia,@idint)"
                            UpdateCommand="UPDATE phdDetalleAutorizacion SET actId=@proc_id,autNumSesiones=@numerosesiones,autSesionesDia=@sesionesdia, intensidad=@idint WHERE id=@id"
                            >
                    </sdg:CustomDataSource>
            </td>
        </tr>
        <tr>
            <td>Procedimiento<asp:RequiredFieldValidator ValidationGroup="procedimiento" ControlToValidate="TProcedimientoID" ErrorMessage="Por favor ingrese un procedimiento." ID="RProcedimiento" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hide"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Número de sesiones<asp:RequiredFieldValidator ValidationGroup="procedimiento" ControlToValidate="TNumeroSesiones" ErrorMessage="Por favor ingrese un número." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TNumeroSesiones" CssClass="entero"></asp:TextBox></td>
            <td>Sesiones por día</td>
            <td><asp:TextBox runat="server" ID="TSesionesDia" CssClass="entero"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Horas</td>
            <td>
                <asp:UpdatePanel runat="server" ID="UIntensidad" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:DropDownList ID="DIntensidad" runat="server" DataSourceID="SIntensidad" DataTextField="nombre" DataValueField="id">
                            <asp:ListItem Text="(Ninguna)" Value=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SIntensidad" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=21 AND parametro1=@procedimiento AND szReservado IS NULL ORDER BY nombre">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" DefaultValue="0" />
                                </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:RequiredFieldValidator ID="RIntensidad" runat="server" ErrorMessage="Por favor seleccione una intensidad." SetFocusOnError="true" ControlToValidate="DIntensidad" Display="Dynamic">*</asp:RequiredFieldValidator>
                        <asp:Button runat="server" ID="BIntensidad" CausesValidation="false" CssClass="hide" OnClick="BIntensidad_Clicked" />
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="TProcedimientoID" EventName="TextChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </td>
            <td><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label></td>
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

