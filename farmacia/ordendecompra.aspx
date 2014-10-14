<%@ Page Title="Orden de compra" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ordendecompra.aspx.cs" Inherits="farmacia_ordendecompra" %>
<%@ Register Src="~/paciente/pacienteSimple.ascx" TagName="pacienteSimple" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
    .tlote {width: 100px;}
    .tubicacion {}
</style>
<script type="text/javascript">
    $(function() {
        if (hasStorage) {
          if(<%= (bool)ViewState["clean"] ? "true" : "false" %>) {
                localStorage.ordencompra=null;
            } else {
            $("#<%= HProductos.ClientID %>").val(localStorage.ordencompra);
              if($("#<%= HProductos.ClientID %>").val().length) {
                if(confirm("¿Se ha encontrado una ordencompra sin terminar desea continuarla?")) {
                    $("#<%= BActualizar.ClientID %>").click();
                } else {
                    localStorage.ordencompra=null;
                    $("#<%= HProductos.ClientID %>").val("");
                }
              }
            }
        }
    });
    addFunctionToStart(function() {
        if (hasStorage) 
          localStorage.ordencompra = $("#<%= HProductos.ClientID %>").val();
          
        $("#<%= ROrganizationExample15.ClientID %>").change(function() {
            $("#<%= RPaciente.ClientID %>").attr('checked', !$(this).is(':checked'));
            $("#<%=UCPaciente.ClientID %>_TPaciente").prop('disabled',!$("#<%= RPaciente.ClientID %>").is(':checked'));
        });
        $("#<%= RPaciente.ClientID %>").change(function() {
            $("#<%= ROrganizationExample15.ClientID %>").attr('checked', !$(this).is(':checked'));
            $("#<%=UCPaciente.ClientID %>_TPaciente").prop('disabled',!$("#<%= RPaciente.ClientID %>").is(':checked'));
        }).change();
        
        $("#<%= BAnular.ClientID %>").click(function() { return confirm('¿Esta seguro de anular este documento?. Esta acción no se puede deshacer.'); });
        $("#<%= BAceptar.ClientID %>").click(function() { window.onbeforeunload = null; });
                  
          $(".tubicacion").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetUbicacion",
                    data: "{ 'q': '" + request.term + "', a: '1' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            item.label= item.value;
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

                $("#"+ $(this).attr("id")+ "ID").val(ui.item.item);
                $(this).val(ui.item.value);
                return false;
            },
                search: function(event, ui) { $("#" + $(this).attr("id") + "ID").val("0"); }
        }).change(function() { 
            if ($(this).val().length == 0) 
                $("#" + $(this).attr("id") + "ID").val("0"); 
            else if($("#" + $(this).attr("id") + "ID").val()=="0")
                $("#" + $(this).attr("id") + "ID").val("-1");
        });
        
          $("#<%= TTercero.ClientID %>,#<%= TNombre.ClientID %>").autocomplete({
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
                $("#<%= TTercero.ClientID %>").val(ui.item.Documento);
                $("#<%= TNombre.ClientID %>").val(ui.item.Nombre);
                $("#<%= TDireccion.ClientID %>").val(ui.item.Direccion);
                $("#<%= TTelefono.ClientID %>").val(ui.item.Telefono);
                $("#<%= TEMail.ClientID %>").val(ui.item.Email);
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
                    data: "{ 'q': '" + request.term + "', 'p': '" + $("#<%= TTerceroID.ClientID %>").val() + "' }",
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
                var descripcion= ui.item.Empresa;
                if(ui.item.Empresa!="" && ui.item.descripcion!="")
                    descripcion+=": ";
                descripcion+= " " + ui.item.descripcion;
                $("#tdescripcion").text(descripcion);
                if (ui.item.unidad && ui.item.unidad != "")
                    $("#sunidad").text("(" + ui.item.unidad + ")");
                else $("#sunidad").text("");
                $("#<%= TCosto.ClientID %>").autoNumeric('set', ui.item.Costo);
                $("#tRegulado").toggle(ui.item.PrecioRegulado!=null);
                if(ui.item.PrecioRegulado!=null)
                    $("#sRegulado").text(currencyFormatted(ui.item.PrecioRegulado));

                try { ValidatorEnable($("#<%= REntero.ClientID %>")[0], ui.item.nNumero==1); } catch (e) {}
                try { ValidatorEnable($("#<%= RDecimal.ClientID %>")[0], ui.item.nNumero!=1); } catch (e) {}
                return false;
            }
        });
        $("#<%= TCosto.ClientID %>").attr("readonly", <%= CUsuario.GetInstance().CanAdmin() ? "false" : "true" %>);
        $("#<%= TNumero.ClientID %>").change(function() {
            $.goURL("oci=" + $(this).val());
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PImprimir" Visible="false">
    <div id="dialog-confirm" title="Imprimir" class="hide"> 
        <p><asp:Label runat="server" ID="LImprimir"></asp:Label></p>
    </div>
    <script type="text/javascript">
        $(function() {
            $("#dialog-confirm").dialog({ resizable: false, modal: true, buttons: { "Imprimir": function() { window.open('<%= ViewState["urlprint"] %>', '_blank'); $(this).dialog("close"); }, "Cancelar": function() { $(this).dialog("close"); } } });
        });
    </script>
</asp:Panel>
<asp:UpdatePanel runat="server" ID="UProducto" UpdateMode="Conditional">
<ContentTemplate>
    <asp:Panel runat="server" ID="PAnulado" Visible="false" CssClass="anulado"><asp:Label runat="server" ID="LAnulado"></asp:Label></asp:Panel>
    <asp:HiddenField runat="server" ID="HId" />
    <table class="tablecollapse">
        <tr>
            <td colspan="5" align="right"><asp:HyperLink runat="server" ID="HTraslado"></asp:HyperLink></td>
        </tr>
        <tr>
            <td width=1>Número</td>
            <td width=1><asp:TextBox runat="server" ID="TNumero" CssClass="likenumero"></asp:TextBox></td>
            <td>&nbsp;</td>
            <td><asp:CheckBox runat="server" ID="CPrioridad" Text="Prioritaria"/></td>
        </tr>
        <tr>
            <td width=1>Fecha
            <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator6" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td width=1><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
            <td>Centro de costos<asp:RequiredFieldValidator ControlToValidate="DCCosto" ErrorMessage="Por favor seleccione un centro de costos." ID="R2" 
	            runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:DropDownList ID="DCCosto" runat="server" DataSourceID="SCCosto" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SCCosto" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=83 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <asp:PlaceHolder runat="server" ID="PRevisado" Visible="false">
            <tr>
                <td>Creado</td>
                <td nowrap="nowrap"><asp:Label runat="server" ID="LCreado"></asp:Label></td>
                <td>Revisado</td>
                <td nowrap="nowrap"><asp:Label runat="server" ID="LRevisado"></asp:Label></td>
            </tr>
        </asp:PlaceHolder>
        <tr>
            <td nowrap="nowrap"><asp:RadioButton runat="server" ID="ROrganizationExample15" Text="OrganizationExample15" /></td>
        </tr>
        <tr>
            <td><asp:RadioButton runat="server" Text="Paciente" ID="RPaciente" Checked="true" /></td>
            <td colspan="3"><uc1:pacienteSimple runat="server" ID="UCPaciente" /></td>
        </tr>
        <tr>
            <td colspan="5" class="GridHeader">Proveedor</td>
        </tr>
        <tr>
            <td class="tdl">Nombre
                <asp:RequiredFieldValidator ControlToValidate="TTerceroID" ErrorMessage="Por favor ingrese un proveedor." ID="RTerceroID" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RequiredFieldValidator ControlToValidate="TNombre" ErrorMessage="Por favor ingrese un nombre." ID="RNombre" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td colspan="3"><asp:TextBox runat="server" ID="TNombre"  Width="98%"></asp:TextBox><asp:TextBox runat="server" ID="TTerceroID" CssClass="hide" ontextchanged="TTerceroID_TextChanged"></asp:TextBox></td>
            <td class="tdr"></td>
        </tr>
        <tr>
            <td class="tdl">Documento
                <asp:RequiredFieldValidator ControlToValidate="TTercero" ErrorMessage="Por favor ingrese una identificación." ID="RIdentificacion" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TTercero"></asp:TextBox></td>
            <td>Dirección<asp:RequiredFieldValidator ID="RDireccion" runat="server" ControlToValidate="TDireccion" Display="Dynamic" ErrorMessage="Por favor ingrese una dirección." SetFocusOnError="True">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TDireccion"></asp:TextBox></td>
            <td class="tdr"></td>
        </tr>
        <tr>
            <td class="tdl tdb">Teléfono<asp:RequiredFieldValidator ID="RTelefono" runat="server" ControlToValidate="TTelefono" Display="Dynamic" ErrorMessage="Por favor ingrese un teléfono." SetFocusOnError="True">*</asp:RequiredFieldValidator></td>
            <td class="tdb"><asp:TextBox runat="server" ID="TTelefono"></asp:TextBox></td>
            <td class="tdb">E-Mail</td>
            <td class="tdb"><asp:TextBox runat="server" ID="TEMail"></asp:TextBox></td>
            <td class="tdr tdb"></td>
        </tr>
        <tr>
            <td colspan="5" class="tdb">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="5" class="GridHeader"><asp:HiddenField runat="server" ID="HProductos" EnableViewState="false" /><asp:HiddenField runat="server" ID="HUsado" />Productos</td>
        </tr>
        <tr class="GridAltRow hide" id="tRegulado">
            <td class="tdl"></td>
            <td colspan="4" class="tdr">Precio regulado <span id="sRegulado">$1.500</span></td>
        </tr>
        <tr>
            <td class="tdl"></td>
            <td colspan="4" class="tdr" id="tdescripcion"></td>
        </tr>
        <tr>
            <td class="tdl">Producto<asp:RequiredFieldValidator ControlToValidate="TProductoID" ValidationGroup="producto" ErrorMessage="Por favor ingrese un producto." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><asp:TextBox ID="TProducto" Width="98%" runat="server"></asp:TextBox><asp:TextBox runat="server" ID="TProductoID" CssClass="hide"></asp:TextBox></td>
            <td class="tdr"><span id="sunidad"></span></td>
        </tr>
        <tr>
            <td class="tdl">Cantidad
                <asp:RequiredFieldValidator ControlToValidate="TCantidad" ValidationGroup="producto" ErrorMessage="Por favor ingrese una cantidad." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ValidationExpression="[0-9]+" ID="REntero" runat="server" ValidationGroup="producto" ErrorMessage="Por favor ingrese un numero entero." ControlToValidate="TCantidad" Display="Dynamic" SetFocusOnError="True">*</asp:RegularExpressionValidator>
                <asp:RegularExpressionValidator ValidationExpression="[0-9]*[.]?[0-9]+" ID="RDecimal" runat="server" ValidationGroup="producto" ErrorMessage="Por favor ingrese un numero decimal." ControlToValidate="TCantidad" Display="Dynamic" SetFocusOnError="True">*</asp:RegularExpressionValidator>
            </td>
            <td><asp:TextBox ID="TCantidad" runat="server" CssClass="float"></asp:TextBox></td>
            <td nowrap=nowrap><asp:Label runat="server" ID="LCosto" Text="Costo Unitario"></asp:Label>
            <asp:RequiredFieldValidator ControlToValidate="TCosto" ValidationGroup="producto" ErrorMessage="Por favor ingrese un costo unitario." ID="RCosto" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ValidationExpression="^[$][+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]+)?$" ID="RCostoF" runat="server" ValidationGroup="producto" ErrorMessage="Por favor ingrese un numero decimal." ControlToValidate="TCosto" Display="Dynamic" SetFocusOnError="True">*</asp:RegularExpressionValidator></td>
            <td nowrap=nowrap><asp:TextBox runat="server" ID="TCosto" CssClass="dinero"></asp:TextBox>
                <asp:Button ID="BActualizar" runat="server" Text="Actualizar" CssClass="hide" CausesValidation="false" onclick="BActualizar_Click" />
                <asp:Button ID="BAgregar" runat="server" onclick="BAgregar_Click" Text="Agregar" ValidationGroup="producto" />
            </td>
            <td class="tdr">
                
            </td>
        </tr>
        <tr>
            <td colspan="5" align="center" class="tdl tdb tdr">
                <asp:GridView ID="GProductos" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="IdGrid,id,ubicacion,estado" 
                    onselectedindexchanged="GProductos_SelectedIndexChanged" 
                    EmptyDataText="No hay productos" onrowdeleting="GProductos_RowDeleting" ShowFooter="true" >
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                        <asp:BoundField DataField="codigo" HeaderText="Código" SortExpression="codigo" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="nombre" HeaderText="Producto" SortExpression="nombre" ItemStyle-HorizontalAlign="Left" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
                        <asp:BoundField DataField="cantidad" HeaderText="Cantidad" SortExpression="cantidad" DataFormatString="{0:F2}" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="Costo" HeaderText="Costo U." SortExpression="Costo" DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" HeaderStyle-Wrap="false" FooterStyle-Wrap="false" />
                        <asp:BoundField DataField="CostoTotal" HeaderText="Costo T." SortExpression="CostoTotal" DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" HeaderStyle-Wrap="false" FooterStyle-Wrap="false" />
                        <asp:BoundField DataField="unidad" HeaderText="Un." SortExpression="unidad" ItemStyle-HorizontalAlign="Left" ItemStyle-Wrap="false" />
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td colspan="5" align="right"><asp:Label runat="server" ID="LTotal"></asp:Label></td>
        </tr>
        <tr>
            <td colspan="5">&nbsp;</td>
        </tr>     
        <tr>
            <td>Observaciones</td>
            <td colspan="3"><asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="99%"></asp:TextBox></td>
        </tr>
        <tr>
            <td><asp:CheckBox runat="server" ID="CNotificar" Visible="false" Checked="false" Text="No notificar por correo electrónico" /></td>
        </tr>
        <tr>
            <td colspan="5"><asp:ValidationSummary runat="server" ID="ValidationSumary1" /><asp:ValidationSummary ValidationGroup="producto" runat="server" ID="ValidationSummary2" />
            <asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
            </td>
        </tr>
        <tr>
            <td><asp:Button runat="server" ID="BAnular" Text="Anular" Visible="false" onclick="BAceptar_Click"/></td>
            <td colspan="3" align="right">
                <asp:Button runat="server" ID="BAceptar" Text="Aceptar" onclick="BAceptar_Click" />
                <asp:Button runat="server" ID="BCancelar" Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>

