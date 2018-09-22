<%@ Page Title="Orden de producción" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ordenproducccion.aspx.cs" Inherits="farmacia_ordenproducccion" %>
<%@ Register Src="~/paciente/pacienteSimple.ascx" TagName="pacienteSimple" TagPrefix="uc1" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $inicio(function () {
        $("#<%= TNumero.ClientID %>").change(function() {
            $.goURL("opid=" + $(this).val());
        });
        addDialog("#P", "#dlgMedicamento");
        $("#<%= TProveedor.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetTercero",
                    data: "{ 'q': '" + request.term + "', tipo: 0 }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            item.label= item.Documento + " " + item.Nombre;
                            return item;
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus + ":" + errorThrown);
                    }
                });
            },
            autoFocus: true,
            minLength: 3,
            search: function() {
                $("#<%= TTerceroID.ClientID %>").val("");
            },
            select: function(event, ui) {

                $("#<%= TTerceroID.ClientID %>").val(ui.item.Id);
                $("#<%= TProveedor.ClientID %>").val(ui.item.Nombre);
                return false;
            }
        }).change(function() { 
            if($(this).val().length==0)
                $("#<%= TTerceroID.ClientID %>").val("");
        });
        $("#<%= TProducto.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetProducto",
                    data: "{ 'q': '" + request.term + "', 'p': null }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            item.label= item.ProductoCompleto;
                            return item;
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus + ":" + errorThrown);
                    }
                });
            },
            autoFocus: true,
            minLength: 3,
            select: function(event, ui) {

                $("#<%= TProductoID.ClientID %>").val(ui.item.id);
                $("#<%= TProducto.ClientID %>").val(ui.item.label);
                /*var descripcion= ui.item.Empresa;
                if(ui.item.Empresa!="" && ui.item.descripcion!="")
                    descripcion+=": ";
                descripcion+= " " + ui.item.descripcion;
                $("#tdescripcion").text(descripcion);
                if (ui.item.unidad && ui.item.unidad != "")
                    $("#sunidad").text("(" + ui.item.unidad + ")");
                else $("#sunidad").text("");
                $("#< %= TCosto.ClientID %>").autoNumeric('set', ui.item.Costo);
                $("#tRegulado").toggle(ui.item.PrecioRegulado!=null);
                if(ui.item.PrecioRegulado!=null)
                    $("#sRegulado").text(currencyFormatted(ui.item.PrecioRegulado));

                try { ValidatorEnable($("#< %= REntero.ClientID %>")[0], ui.item.nNumero==1); } catch (e) {}
                try { ValidatorEnable($("#< %= RDecimal.ClientID %>")[0], ui.item.nNumero!=1); } catch (e) {}*/
                return false;
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:UpdatePanel runat="server" ID="U" UpdateMode="Conditional">
        <ContentTemplate>
    <asp:Panel runat="server" ID="P" ClientIDMode="Static">
    <table>
        <tr>
            <td>Número<asp:RequiredFieldValidator ControlToValidate="TNumero" ErrorMessage="Por favor ingrese un número." ID="R1" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TNumero" CssClass="likenumber"></asp:TextBox></td>
            <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="R2" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="R15" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha valida" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$" runat="server" >*</asp:RegularExpressionValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Paciente<asp:RequiredFieldValidator ControlToValidate="UCPaciente$TPacienteID" ErrorMessage="Por favor seleccione un paciente." ID="R3" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><uc1:pacienteSimple runat="server" ID="UCPaciente" /></td>
        </tr>
        <tr>
            <td>Proveedor<asp:RequiredFieldValidator ControlToValidate="TTerceroID" ErrorMessage="Por favor ingrese un proveedor." ID="R11" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><asp:TextBox runat="server" ID="TProveedor"  Width="100%"></asp:TextBox><asp:TextBox runat="server" ID="TTerceroID" CssClass="hide"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Referencia de la bomba<asp:RequiredFieldValidator ControlToValidate="TBomba" ErrorMessage="Por favor ingrese una bomca." ID="R12" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TBomba"></asp:TextBox></td>
            <td>Realizado por<asp:RequiredFieldValidator ControlToValidate="UCFuncionario$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="R13" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><uc1:funcionario runat="server" ID="UCFuncionario" /></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Medicamentos</td>
        </tr>
        <tr>
            <td colspan="4" class="tdl tdr">
                <asp:GridView runat="server" ID="GM" AutoGenerateColumns="false" OnRowDeleting="GM_RowDeleting" OnSelectedIndexChanged="GM_SelectedIndexChanged" DataKeyNames="Index" CssClass="table table-condensed table-bordered table-hover table-striped">
                    <Columns>
                        <asp:TemplateField ItemStyle-Width="1px">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="S" CssClass="btn btn-success btn-xs" CausesValidation="False" CommandName="Select" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="1px">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="D" CssClass="btn btn-danger btn-xs" CausesValidation="False" CommandName="Delete" ToolTip="Eliminar"><i class="fa fa-trash-o"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="MedicamentoN" HeaderText="Medicamento" ItemStyle-CssClass="w100" />
                        <asp:BoundField DataField="Concentracion" HeaderText="Concentración" />
                        <asp:BoundField DataField="Lote" HeaderText="Lote" />
                        <asp:BoundField DataField="Vencimiento" HeaderText="Vencimiento" ItemStyle-CssClass="r" />
                        <asp:BoundField DataField="Dosis" HeaderText="Dosis(mg/g)" ItemStyle-CssClass="r" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad ampollas" ItemStyle-CssClass="r" />
                        <asp:BoundField DataField="Dias" HeaderText="Días tratamiento" ItemStyle-CssClass="r" />
                        <asp:BoundField DataField="Volumen" HeaderText="Volumen total(ml)" ItemStyle-CssClass="r" />
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="r tdb tdl tdr"><asp:LinkButton runat="server" ID="BAdd" OnClick="BAdd_Click" CausesValidation="false" CssClass="btn btn-default"><i class="fa fa-plus"></i></asp:LinkButton></td>
        </tr>
        <tr>
            <td>Observaciones</td>
            <td colspan="3"><asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="100%"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Label runat="server" ID="LMessage" ForeColor="Red"></asp:Label>
                <asp:ValidationSummary runat="server" ID="V" />
            </td>
        </tr>
        <tr>
            <td class="r" colspan="4">
                <asp:Button runat="server" ID="BAceptar" Text="Aceptar" CssClass="btn btn-submit" OnClick="BAceptar_Click" />
                <asp:Button runat="server" ID="BCancelar" Text="Cancelar" CssClass="btn btn-default" CausesValidation="false" OnClick="BCancelar_Click" />
            </td>
        </tr>
    </table>
    <asp:PlaceHolder runat="server" ID="PAM" Visible="false">
    <div title="Medicamento" id="dlgMedicamento" class="hidet">
        <table>
            <tr>
                <td>Medicamento<asp:RequiredFieldValidator ControlToValidate="TProductoID" ValidationGroup="m" ErrorMessage="Por favor seleccione un medicamento." ID="R5" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td colspan="3"><asp:TextBox ID="TProducto" Width="100%" runat="server"></asp:TextBox><asp:TextBox runat="server" ID="TProductoID" CssClass="hidet"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Concentración</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TConcentracion" Width="100%"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Lote<asp:RequiredFieldValidator ValidationGroup="m" ControlToValidate="TLote" ErrorMessage="Por favor ingrese un lote." ID="R9" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><asp:TextBox runat="server" ID="TLote"></asp:TextBox></td>
                <td>Vencimiento<asp:RequiredFieldValidator ValidationGroup="m" ControlToValidate="TVence" ErrorMessage="Por favor ingrese una fecha." ID="R10" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ValidationGroup="m" ID="R14" ControlToValidate="TVence" ErrorMessage="Por favor ingrese una fecha valida" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$" runat="server" >*</asp:RegularExpressionValidator>
                </td>
                <td><asp:TextBox runat="server" ID="TVence" CssClass="fecha"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Dosis(mg/g)<asp:RequiredFieldValidator ControlToValidate="TDosis" ValidationGroup="m" ErrorMessage="Por favor ingrese una dosis." ID="R6" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
                <td><asp:TextBox runat="server" ID="TDosis"></asp:TextBox></td>
                <td>Cantidad ampollas<asp:RequiredFieldValidator ControlToValidate="TCantidad" ValidationGroup="m" ErrorMessage="Por favor ingrese una cantidad." ID="R7" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ValidationGroup="m" ControlToValidate="TCantidad" ValidationExpression="^[0-9]+$" ID="R16" runat="server" 
	                                    ErrorMessage="Por favor ingrese un numero entero." Display="Dynamic" SetFocusOnError="True">*</asp:RegularExpressionValidator>
                </td>
                <td><asp:TextBox runat="server" ID="TCantidad" CssClass="entero"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Días de tratamiento<asp:RequiredFieldValidator ControlToValidate="TDias" ValidationGroup="m" ErrorMessage="Por favor ingrese unos días." ID="R8" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ValidationGroup="m" ControlToValidate="TDias" ValidationExpression="^[0-9]+$" ID="R17" runat="server" 
	                                    ErrorMessage="Por favor ingrese un numero entero." Display="Dynamic" SetFocusOnError="True">*</asp:RegularExpressionValidator>
                </td>
                <td><asp:TextBox runat="server" ID="TDias" CssClass="entero"></asp:TextBox></td>
                <td>Volumen  total (ml).<asp:RequiredFieldValidator ValidationGroup="m" ControlToValidate="TVolumen" ErrorMessage="Por favor ingrese un volumen." ID="R21" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ValidationGroup="m" ControlToValidate="TVolumen" ValidationExpression="^[1-9]\d*(\.\d+)?$" ID="R20" runat="server" 
	                                    ErrorMessage="Por favor ingrese un numero decimal." Display="Dynamic" SetFocusOnError="True">*</asp:RegularExpressionValidator></td>
                <td><asp:TextBox runat="server" ID="TVolumen" CssClass="float"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4">                
                    <ul>
                        <li><b>Dosis(mg/g):</b> Dosis a adecuar(mg/g) Corresponde a la dosis de medicamento por infusor</li>
                        <li><b>Cantidad ampollas:</b> Cantidad de ampollas entregadas</li>
                        <li><b>Volumen total(ml)</b> Volumen total (ml). Volumen final después de reconstituido el medicamento</li>
                    </ul>
                    <asp:ValidationSummary runat="server" ValidationGroup="m" />
                </td>
            </tr>
            <tr>
                <td colspan="4" class="r">
                    <asp:Button runat="server" ID="BAM" Text="Aceptar" ValidationGroup="m" OnClick="BAM_Click" />
                    <asp:Button runat="server" ID="BCM" Text="Cancelar" CausesValidation="false" OnClick="BCM_Click" />
                </td>
            </tr>
        </table>
    </div>
    </asp:PlaceHolder>
    </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

