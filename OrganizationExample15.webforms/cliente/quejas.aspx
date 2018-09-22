<%@ Page Title="Registro PQR" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="quejas.aspx.cs" Inherits="cliente_quejas" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<%@ Register Src="~/rh/funcionarioc.ascx" TagName="FuncionarioC" TagPrefix="uc6" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
    .detalle 
    {
        min-width: 300px;
    }
</style>
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

        // seguimiento
        addDialog('#<%= PISeguimiento.ClientID%>', "#dSeguimiento");

        $("#<%= CCerrar.ClientID %>").change(function() {
            var tr = $("#<%= CCerrar.ClientID %>").parent().parent().next();
            var mostrar=$("#<%= CCerrar.ClientID %>").is(":checked");
            do {
                mostrar ? tr.show() : tr.hide();
                tr = tr.next();
            } while (tr.next().length);
        }).change();
    });
    function OnValidateClick(Source, args) {

        args.IsValid = true;
        if ($("#<%= CCerrar.ClientID %>").is(":checked")) {
            args.IsValid = $("#<%= CRUsuario.ClientID %>").is(":checked") &&
                $("#<%= FArchivo.ClientID %>").val().length > 0;
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
        <table width="100%">
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>Hora</td>
                <td><asp:TextBox runat="server" ID="THora" CssClass="hora"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="THora" ErrorMessage="Por favor ingrese una hora." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>Tipo</td>
                <td><asp:DropDownList ID="DTipo" runat="server" AutoPostBack="true"
                                DataSourceID="STipo" DataTextField="nombre" 
                                DataValueField="id" 
                        onselectedindexchanged="DTipo_SelectedIndexChanged">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="STipo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT tqrIdTipo id,tqrDescripcion nombre FROM tipo_queja_reclamo ORDER BY nombre">
                </asp:SqlDataSource></td>
                <td>Clasificación</td>
                <td><asp:DropDownList ID="DClasificacion" runat="server" 
                                DataSourceID="SClasificacion" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SClasificacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=26 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>Quien notifica</td>
                <td><asp:TextBox runat="server" ID="TPLlama"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="TPLlama" ErrorMessage="Por favor ingrese una persona que llama." ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>Parentesco</td>
                <td><asp:TextBox runat="server" ID="TParentesco"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Teléfono</td>
                <td><asp:TextBox runat="server" ID="TTelefono"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="TTelefono" ErrorMessage="Por favor ingrese un teléfono." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>Descripción</td>
                <td colspan="3"><asp:TextBox runat="server" TextMode="MultiLine" Height="100" Width="99%" ID="TDetalle"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="TDetalle" ErrorMessage="Por favor ingrese un detalle." ID="RequiredFieldValidator6" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            </tr>
            <asp:PlaceHolder runat="server" ID="PConductaAbusiva">
                <tr>
                    <td colspan="4" class="celdaTitulo">Hecho</td>
                </tr>
                <tr>
                    <td>Lugar<asp:RequiredFieldValidator ControlToValidate="TLugar" ErrorMessage="Por favor ingrese un lugar." ID="RequiredFieldValidator8" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    <td colspan="3"><asp:TextBox runat="server" TextMode="MultiLine" Width="99%" ID="TLugar"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Circunstancias relacionadas<asp:RequiredFieldValidator ControlToValidate="TCircunstanacias" ErrorMessage="Por favor ingrese unas circunstanacias." ID="RequiredFieldValidator9" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    <td colspan="3"><asp:TextBox runat="server" TextMode="MultiLine" Width="99%" ID="TCircunstanacias"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Antecedentes que desataron la conducta del usuario<asp:RequiredFieldValidator ControlToValidate="TAntecedentes" ErrorMessage="Por favor ingrese un atencedente." ID="RequiredFieldValidator10" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    <td colspan="3"><asp:TextBox runat="server" TextMode="MultiLine" Width="99%" ID="TAntecedentes"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4" class="celdaTitulo">Fuente de información reportante</td>
                </tr>
                <tr>
                    <td colspan="4"><asp:CheckBox runat="server" ID="CPresentaDano" Text="Presenta daño" /></td>
                </tr>
                <tr>
                    <td colspan="4"><hr /></td>
                </tr>
                <tr>
                    <td colspan="4">
                    <asp:CheckBoxList runat="server" ID="CTipoDano" DataSourceID="STipoDano" 
                        DataTextField="nombre" DataValueField="id" RepeatColumns="2" ondatabound="CTipoDano_DataBound">
                    </asp:CheckBoxList>
                    <asp:SqlDataSource ID="STipoDano" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT id, nombre FROM varios WHERE tipo=30 AND szReservado IS NULL ORDER BY nombre">
                    </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td>Otro?</td>
                    <td colspan="3"><asp:TextBox runat="server" ID="TTipoDano" Width="98%"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Fecha del evento<asp:RequiredFieldValidator ControlToValidate="TFechaEvento" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator11" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ControlToValidate="TFechaEvento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                    </td>
                    <td><asp:TextBox runat="server" ID="TFechaEvento" CssClass="fecha"></asp:TextBox></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td colspan="4" class="celdaTitulo">Identificación del riesgo</td>
                </tr>
                <tr>
                    <td>Riesgo presentado</td>
                    <td>
                    <asp:DropDownList ID="DTipoRiesgo" runat="server" DataSourceID="STipoRiesgo" 
                        DataTextField="nombre" DataValueField="id">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="STipoRiesgo" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT id, nombre FROM varios WHERE tipo=31 AND szReservado IS NULL ORDER BY nombre">
                    </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <asp:GridView ID="GMedidas" runat="server" AutoGenerateColumns="False" Width="100%"
                            DataSourceID="SMedidas" EmptyDataText="No se encontraron medidas" 
                            DataKeyNames="id" ondatabound="GMedidas_DataBound">
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:BoundField HeaderText="" DataField="nombre" />
	                            <asp:BoundField HeaderText="Medida" DataField="descripcion" ItemStyle-Width="100%" />
	                            <asp:TemplateField HeaderText="Fecha">
	                                <ItemTemplate>
	                                    <asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox>
	                                    <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
	                                </ItemTemplate>
	                            </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SMedidas" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre,descripcion FROM varios WHERE tipo=32 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource>
                    </td>
                </tr>
            </asp:PlaceHolder>
            <asp:PlaceHolder runat="server" ID="PSeguimiento" Visible="false">
            <tr>
                <td colspan="4" class="celdaTitulo">Seguimiento</td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:GridView ID="GSeguimiento" runat="server" AutoGenerateColumns="False" 
                        OnRowEditing="GSeguimiento_Editing" Width="100%" OnRowDataBound="GSeguimiento_RowDataBound"
                        DataKeyNames="qrId,sqrId" EmptyDataText="No se ha encontrado seguimiento" DataSourceID="SSeguimiento" >
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
                            <asp:TemplateField HeaderText="Acciones pendientes" ItemStyle-Width="100%">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ID="LDetalle" CommandName="Edit" Text='<%# Eval("sqrPendiente") %>'></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Archivo">
                                <ItemTemplate>
                                    <asp:HyperLink runat="server" CausesValidation="false" ID="LArchivo" Text=""></asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="segUsuarioIngreso" HeaderText="Usuario" ItemStyle-Wrap="false" />
                            <asp:BoundField DataField="segFechaIngreso" HeaderText="Fecha" ItemStyle-Wrap="false" />
                        </Columns>
                    </asp:GridView>
                    <div align="right">
                    <asp:LinkButton runat="server" Text="Registrar seguimiento" ID="LASeguimiento" CausesValidation="false" 
                        onclick="LASeguimiento_Click"></asp:LinkButton></div>
                    <asp:SqlDataSource ID="SSeguimiento" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT qrId,sqrId,sqrPendiente,segUsuarioIngreso,segFechaIngreso FROM queja_reclamo_seguimiento WHERE qrId=@queja">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="HIdQuejas" Name="queja" PropertyName="Value" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:Panel runat="server" ID="PISeguimiento" Visible="false">
                        <div id="dSeguimiento" title="Seguimiento" class="hidet">
                            <table>
                                <tr>
                                    <td>Acciones pendientes</td>
                                    <td><asp:TextBox runat="server" ID="TAcciones" TextMode="MultiLine" Width="98%"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Avances</td>
                                    <td><asp:TextBox runat="server" ID="TAvances" TextMode="MultiLine" Width="98%"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:CheckBox runat="server" ID="CCerrar" Text="¿Esta acción cierra la queja?" /></td>
                                </tr>
                                <tr>
                                    <td>Acción de mejora</td>
                                    <td><asp:TextBox runat="server" ID="TAccionMejora" TextMode="MultiLine" Width="98%"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:CheckBox runat="server" ID="CRUsuario" Text="¿Se entrega una respuesta a quien interpuso la incorformidad?" /></td>
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
                                    <td>Se envió oficio ante quien interpuso la queja</td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:FileUpload runat="server" ID="FArchivo" Width="100%" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asp:CustomValidator ClientValidationFunction="OnValidateClick" Visible="false" OnServerValidate="OnValidateSeguimiento" runat="server" ValidationGroup="seguimiento" ID="CVSeguimiento" Display="Dynamic" ErrorMessage="Por favor seleccione se entrega una respuesta a quien interpuso la inconformidad y seleccione un archivo con la respuesta."></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" colspan="2">
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
            </asp:PlaceHolder>
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