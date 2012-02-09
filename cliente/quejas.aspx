<%@ Page Title="Quejas,reclamos,felicitaciones" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="quejas.aspx.cs" Inherits="cliente_quejas" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<%@ Register Src="~/rh/funcionarioc.ascx" TagName="FuncionarioC" TagPrefix="uc6" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= REmpleado.ClientID %>").change(function() {
            $("#<%= RPaciente.ClientID %>").change();
        });
        $("#<%= RPaciente.ClientID %>").change(function() {

            if ($("#<%= RPaciente.ClientID %>").is(":checked")) {
                $("#tPaciente").show();
                $("#tEmpleado").hide();
            } else {
                $("#tPaciente").hide();
                $("#tEmpleado").show();
            }
        }).change();

        $("#<%= TFuncionario.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPersonal",
                    data: "{ 'q': '" + request.term + "' }",
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
                var nombre = ui.item.label;
                var pos = nombre.indexOf(" - ");
                if (pos != -1) {
                    nombre = nombre.substring(pos + 3);
                }
                $("#<%= TFuncionario.ClientID %>").val(nombre);
                $("#<%= TFuncionarioID.ClientID %>").val(ui.item.value);
                return false;
            }
        });

        // seguimiento
        addDialog('#<%= PISeguimiento.ClientID%>', "#dSeguimiento");

        $("#<%= CCerrar.ClientID %>").change(function() {
            if ($("#<%= CCerrar.ClientID %>").is(":checked")) {
                $("#<%= CRUsuario.ClientID %>").show().next().show();
                $("#<%= CRTelefonica.ClientID %>").show().next().show();
                $("#<%= CRAsegurador.ClientID %>").show().next().show();
                $("#<%= CRVigilancia.ClientID %>").show().next().show();
                $("#<%= FArchivo.ClientID %>").show();
                $("#sError").show();
            } else {
                $("#<%= CRUsuario.ClientID %>").hide().next().hide();
                $("#<%= CRTelefonica.ClientID %>").hide().next().hide();
                $("#<%= CRAsegurador.ClientID %>").hide().next().hide();
                $("#<%= CRVigilancia.ClientID %>").hide().next().hide();
                $("#<%= FArchivo.ClientID %>").hide();
                $("#sError").hide();
            }
        }).change();
    });
    function OnValidateClick(Source, args) {

        args.IsValid = true;
        if ($("#<%= CCerrar.ClientID %>").is(":checked")) {

            args.IsValid =
                $("#<%= CRUsuario.ClientID %>").is(":checked") &&
                $("#<%= CRTelefonica.ClientID %>").is(":checked") &&
                $("#<%= FArchivo.ClientID %>").val().length > 0 &&
                ($("#<%= CRAsegurador.ClientID %>").is(":checked") ||
                $("#<%= CRVigilancia.ClientID %>").is(":checked"));
        }
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table>
        <tr>
            <td><asp:RadioButton GroupName="t" ID="RPaciente" runat="server" Checked="true" Text="Cliente externo"/><asp:RadioButton GroupName="t" ID="REmpleado" runat="server" Checked="false" Text="Cliente interno" /></td>
        </tr>
        <tr id="tPaciente">
            <td><uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" /></td>
        </tr>
        <tr id="tEmpleado">
            <td>Cliente interno: <uc6:FuncionarioC Id="FuncionarioC" runat="server" /></td>
        </tr>
    </table>
    <br />
    <asp:Panel runat="server" id="PDatos" Visible="false">
        <asp:HiddenField runat="server" ID="HIdQuejas" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table>
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>Hora</td>
                <td><asp:TextBox runat="server" ID="THora" CssClass="hora"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="THora" ErrorMessage="Por favor ingrese una hora." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>Tipo</td>
                <td><asp:DropDownList ID="DTipo" runat="server" 
                                DataSourceID="STipo" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="STipo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT tqrIdTipo id,tqrDescripcion nombre FROM serTipoFormulario">
                </asp:SqlDataSource></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Personal involucrado</td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:GridView ID="GPersonal" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="Id" EmptyDataText="" ShowHeader="false" 
                        onselectedindexchanged="GPersonal_SelectedIndexChanged" >
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/eliminar.gif" />
                            <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:TextBox runat="server" ID="TFuncionario" Width="300px"></asp:TextBox>
                    <asp:Button ID="BAgregar" Text="+" ValidationGroup="funcionario" runat="server" 
                        onclick="BAgregar_Click" />
                    <asp:TextBox runat="server" ID="TFuncionarioID" CssClass="hide"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="TFuncionarioID" ValidationGroup="funcionario" ErrorMessage="Por favor ingrese un funcionario." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>Personal que llama</td>
                <td><asp:TextBox runat="server" ID="TPLlama"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="TPLlama" ErrorMessage="Por favor ingrese una persona que llama." ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>Parentesco</td>
                <td><asp:TextBox runat="server" ID="TParentesco"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Correo electrónico</td>
                <td><asp:TextBox runat="server" ID="TEmail"></asp:TextBox><asp:RegularExpressionValidator
                        ID="RegularExpressionValidator1" ControlToValidate="TEmail" runat="server" 
                        Display="Dynamic" SetFocusOnError="true" 
                        ErrorMessage="Por favor ingrese un correo electrónico valido" 
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:RegularExpressionValidator></td>
                <td>Teléfono</td>
                <td><asp:TextBox runat="server" ID="TTelefono"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="TTelefono" ErrorMessage="Por favor ingrese un teléfono." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>Detalle</td>
                <td colspan="3"><asp:TextBox runat="server" TextMode="MultiLine" Width="99%" ID="TDetalle"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="TDetalle" ErrorMessage="Por favor ingrese un detalle." ID="RequiredFieldValidator6" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>Observaciones</td>
                <td colspan="3"><asp:TextBox runat="server" TextMode="MultiLine" Width="99%" ID="TObservaciones"></asp:TextBox></td>
            </tr>
            <asp:Panel runat="server" ID="PSeguimiento" Visible="false">
            <tr>
                <td colspan="4" class="celdaTitulo">Seguimiento</td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:LinkButton runat="server" Text="Registrar seguimiento" ID="LASeguimiento" CausesValidation="false" 
                        onclick="LASeguimiento_Click"></asp:LinkButton>
                    <asp:GridView ID="GSeguimiento" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="GSeguimiento_SelectedIndexChanged" 
                        DataKeyNames="qrId,sqrId" EmptyDataText="No se ha encontrado seguimiento" DataSourceID="SSeguimiento" >
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:BoundField DataField="sqrDetalles" HeaderText="Detalle" />
                            <asp:BoundField DataField="sqrPendiente" HeaderText="Acciones pendientes" />
                            <asp:TemplateField HeaderText="Archivo">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CausesValidation="false" ID="LArchivo" Text='<%# Eval("nombre") %>' CommandName="Select"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="segUsuarioIngreso" HeaderText="Usuario" />
                            <asp:BoundField DataField="segFechaIngreso" HeaderText="Fecha" />
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SSeguimiento" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT qrId,sqrId,sqrDetalles,sqrPendiente,segUsuarioIngreso,segFechaIngreso,nombre FROM serSeguimiento WHERE qrId=@queja">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="HIdQuejas" Name="queja" PropertyName="Value" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:Panel runat="server" ID="PISeguimiento" Visible="false">
                        <div id="dSeguimiento" title="Seguimiento" class="hide">
                            <table>
                                <tr>
                                    <td>Detalles</td>
                                    <td><asp:TextBox TextMode="MultiLine" Width="300" runat="server" ID="TSDetalles"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Acciones pendientes</td>
                                    <td><asp:TextBox runat="server" ID="TAcciones" TextMode="MultiLine" Width="98%"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:CheckBox runat="server" ID="CCerrar" Text="¿Esta acción cierra la queja?" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:CheckBox runat="server" ID="CRUsuario" Text="¿Se envió respuesta al usuario?" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:CheckBox runat="server" ID="CRTelefonica" Text="¿Se envió respuesta telefónica?" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:CheckBox runat="server" ID="CRAsegurador" Text="¿Se envió respuesta al asegurador?" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:CheckBox runat="server" ID="CRVigilancia" Text="¿Se envió respuesta al ente de vigilancia y control?" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:FileUpload runat="server" ID="FArchivo" Width="100%" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                    <asp:RequiredFieldValidator ControlToValidate="TSDetalles" ValidationGroup="seguimiento" ErrorMessage="Por favor ingrese detalles." ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                    <asp:CustomValidator ClientValidationFunction="OnValidateClick" OnServerValidate="OnValidateSeguimiento" runat="server" ValidationGroup="seguimiento" ID="CVSeguimiento" ErrorMessage=""></asp:CustomValidator>
                                    <br />
                                    <span id="sError" style="color: Red">
                                        Recuerde que una queja/Reclamo solo puede cerrarse si se ha enviado:<br />
                                        1.Respuesta al usuario<br />
                                        2.Respuesta telefónica<br />
                                        3.Respuesta al asegurador o al ente de vigilancia y control<br />
                                        4.Adjuntar la respuesta<br />
                                    </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                    <asp:Button runat="server" ID="BAceptarSeguimiento" Text="Aceptar" 
                                            ValidationGroup="seguimiento" onclick="BAceptarSeguimiento_Click" />
                                    <asp:Button runat="server" ID="BCancelarSeguimiento" Text="Cancelar" 
                                            CausesValidation="false" onclick="BCancelarSeguimiento_Click" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </asp:Panel>
                </td>
            </tr>
            </asp:Panel>
            <tr>
                <td colspan="4" align="right">
                    <asp:ValidationSummary runat="server" ID="ValidationSummary1" />
                <asp:Button runat="server" ID="BAceptar" Text="Aceptar" 
                        onclick="BAceptar_Click" /><asp:Button runat="server" ID="BCancelar" 
                        Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" /></td>
            </tr>
        </table>
   </asp:Panel>
</asp:Content>