<%@ Page Title="Evolución manejo de heridas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evolucion.aspx.cs" Inherits="clinicaheridas_evolucion" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<%@ Register Src="~/rh/funcionarioSimple.ascx" TagName="Funcionario" TagPrefix="uc6" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
.cms {
    width: 75px;
    text-align: right;
}
.porcentaje {
    width: 75px;
    text-align: right;
}
.eliminado 
{
    text-decoration: line-through;
}
</style>
<%= SDG.Componentes.HtmlUtil.RenderScript("~/js/tinymce.min.js") %>
<script type="text/javascript">
    $inicio(function() {

        $('.eliminar').each(function(i) {
            if (this.eliminar == undefined) {
                this.eliminar = $(this).attr("onclick");
                $(this).unbind('click').attr("onclick", "").click(function() { if (confirm('¿Esta seguro de eliminar este elemento?')) { if (this.eliminar != undefined) { if (this.eliminar.toString().indexOf("function") == -1) eval(this.eliminar); else this.eliminar(); } return true; } return false; });
            }
        });

        $("#<%= RPDistales.ClientID %>_0").change(function() {
            $(".pulsos").toggle($(this).is(':checked'));
        }).change();

        $("#<%= RPDistales.ClientID %>_1").change(function() {
            $(".pulsos").hide();
        });
        
        $("#<%= CBolsillo.ClientID %>").change(function() {
            $(".bolsillo").toggle($(this).is(':checked'));
            $("span.bolsillo").enableValidator($(this).is(':checked'));
        }).change();
    
        $('.cms:not(.rcms)')
            .autoNumeric('init', { vMin: 0, mDec: 1, aSep: '', aSign: ' cm', pSign: 's', aPad: false })
            .addClass("rcms");
        $('.porcentaje:not(.rporcentaje)').autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' %', pSign: 's' })
            .addClass("rporcentaje")
            .change(function() {
                var total = 0;
                $(".porcentaje").each(function() {
                    if ($(this).autoNumeric('get'))
                        total += parseInt($(this).autoNumeric('get'));
                });
                $("#<%= LTotalPorcentaje.ClientID %>").text(total + " %");
                if (total > 100)
                    $("#<%= LTotalPorcentaje.ClientID %>").css("color", "#FF0000");
                else $("#<%= LTotalPorcentaje.ClientID %>").css("color", "#00FF00");
            })
            .change();
        $("#<%= TTA.ClientID %>").mask("999/999 mm/Hg");
        $("#<%= TFC.ClientID %>").autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' Lat/min', pSign: 's' });
        $("#<%= TFR.ClientID %>").autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' Min', pSign: 's' });
        $("#<%= TT.ClientID %>").autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' °', pSign: 's' });

        $("#<%= PHistorial.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });
        FullRowSelect("#<%= GHistorial.ClientID %>");
        
        
        
        
        function rel(text) {
            text = text.replace(/\r/gi, '');
            text = text.replace(/&nbsp;/gi, '');
            while (text[0] == '\n') {
                text = text.substring(1);
            }
            text = text.split('\n');
            var szfinal = "";
            for (x = 0; x < text.length; x++) {
                text[x] = text[x].trim();
                if (text[x].match(/[\S]/g) != null) {
                    if (szfinal.length)
                        szfinal += "\n";
                    szfinal += text[x];
                }
            }
            // text = text.join('\n').replace(/\n{2,}/g, '\n');
            return szfinal;
        }

        function lim() {
            var limpio = rel(editor.getContent().replace(/<\S[^><]*>/g, ""));
            $("#<%= TPlanManejo.ClientID %>").val(limpio);
            var completa = "<ol><li>" + limpio.replace(/\n/g, "</li><li>") + "</li></ol>";
            editor.setContent(completa);
        }
        
        var length = tinyMCE.editors.length;
        for (var i=length; i>0; i--) {
            tinyMCE.editors[i-1].remove();
        };
        tinyMCE.init({
            mode: "exact"
            ,selector: '#elm1' 
            ,readonly: <%= TPlanManejo.ReadOnly ? "true" : "false" %>
            ,menubar:false
            ,statusbar: false
            ,toolbar: false
            ,plugins: 'paste'
            ,valid_elements: "ol,li,p,br"
            ,setup: function(ed) {
                editor = ed;
                ed.on('submit', function(e) {
                    lim();
                });
                ed.on('init', function(ed) {
                    var completa = $("#<%= TPlanManejo.ClientID %>").val();
                    completa = "<ol><li>" + completa.replace(/\n/g, "</li><li>") + "</li></ol>";
                    editor.setContent(completa);
                    $("#elm1").remove();
                });
                ed.on('blur', function(e) {
                    tinyMCE.triggerSave();
                    lim();
                });
            }
            ,paste_preprocess: function(pl, o) {
                o.content = "";
                // o.content = o.content.replace(/<\S[^><]*>/g, "");
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
<uc4:detallepaciente ID="CCDetallePaciente" runat="server" Visible="false" />
<asp:Panel ID="PHistorial" runat="server" Visible="false">
    <h3><a href="#"><asp:Label runat="server" ID="LHistorial"></asp:Label></a></h3>
    <div class="hidet">
        <asp:GridView ID="GHistorial" runat="server" AutoGenerateColumns="False"  Width="100%" OnRowDataBound="GHistorial_RowDataBound"
            DataSourceID="SHistorial" EmptyDataText="No se encontraron índices anteriores de este paciente" >
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton CommandArgument='<%# Eval("id") %>' ID="IIr" onclick="IIr_Click" runat="server" CssClass="btn btn-success btn-xs" CausesValidation="False" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:d}" ItemStyle-Wrap="false" />
                <asp:BoundField DataField="funcionario" HeaderText="Funcionario" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SHistorial" runat="server" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            SelectCommand="SELECT evolucion_herida.id,evolucion_herida.funcionario,evolucion_herida.fecha
                        FROM evolucion_herida
                        WHERE evolucion_herida.paciente=@paciente
                        ORDER BY evolucion_herida.fecha DESC;">
            <SelectParameters>
                <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Panel>
<asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
<ContentTemplate>
        <table style="border-collapse: collapse">
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fechahora"></asp:TextBox></td>
                <td>Funcionario<asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="UCFuncionario$TFuncionarioID" runat="server" ErrorMessage="Por favor ingrese un funcionario" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><uc6:Funcionario runat="server" ID="UCFuncionario" /></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Examén físico</td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Datos objetivos</td>
            </tr>
            <tr>
                <td class="tdl">TA<asp:RequiredFieldValidator ControlToValidate="TTA" ErrorMessage="Por favor ingrese una tension arterial." ID="RequiredFieldValidator6" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><asp:TextBox ID="TTA" runat="server" CssClass="likenumber"></asp:TextBox></td>
                <td>FC<asp:RequiredFieldValidator ControlToValidate="TFC" ErrorMessage="Por favor ingrese una frecuencia cardiaca." ID="RequiredFieldValidator9" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td class="tdr"><asp:TextBox ID="TFC" runat="server" CssClass="entero"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl">FR<asp:RequiredFieldValidator ControlToValidate="TFR" ErrorMessage="Por favor ingrese una frecuencia respiratoria." ID="RequiredFieldValidator10" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><asp:TextBox ID="TFR" runat="server" CssClass="entero"></asp:TextBox></td>
                <td>T<asp:RequiredFieldValidator ControlToValidate="TT" ErrorMessage="Por favor ingrese una temperatura." ID="RTT" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td class="tdr"><asp:TextBox ID="TT" runat="server" CssClass="float"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl nw">Pulsos distales<asp:RequiredFieldValidator ControlToValidate="RPDistales" ErrorMessage="Por favor seleccione unos pulsos distales." ID="RRPD" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td nowrap="nw">
                <asp:RadioButtonList runat="server" ID="RPDistales" RepeatColumns="2">
                    <asp:ListItem Text="Presentes" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Ausentes" Value="0"></asp:ListItem>
                </asp:RadioButtonList>
                </td>
                <td><asp:Label ID="Label1" runat="server" Text="Observaciones" CssClass="pulsos hidet"></asp:Label></td>
                <td class="tdr"><asp:TextBox runat="server" ID="TObservacionPulso" CssClass="pulsos hidet"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Diagnóstico - Condición actual</td>
            </tr>
            <tr>
                <td>Valoración inicial</td>
                <td><asp:Label runat="server" ID="LValoracionInicial"></asp:Label></td>
                <td nowrap=nowrap>Días de valoración</td>
                <td class="tdr"><asp:Label runat="server" ID="LDiasEvolucion"></asp:Label></td>
            </tr>
            <tr>
                <td>Última evolución</td>
                <td><asp:Label runat="server" ID="LUltimaEvolucion"></asp:Label></td>
                <td nowrap=nowrap>Días de evolución</td>
                <td class="tdr"><asp:Label runat="server" ID="LDiasEvolucion2"></asp:Label></td>
            </tr>
            <tr>
                <td class="tdr tdl celdaTitulo" colspan="4">Seguimiento de Heridas</td>
            </tr>
            <tr>
                <td colspan="4" class="tdr tdl">
                    <asp:GridView ID="GHeridas" runat="server" AutoGenerateColumns="False" Width="100%" 
                        EmptyDataText="No se encontraron heridas de este paciente" 
                        DataKeyNames="id" onrowdatabound="GHeridas_RowDataBound" 
                        onselectedindexchanged="GHeridas_SelectedIndexChanged">
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
                            <asp:BoundField DataField="Nombre" HeaderText="Localización" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td colspan="4" style="text-align: right;" class="tdr tdl"><asp:Button runat="server" ID="BAgregarHerida" Text="Agregar" CausesValidation="false" OnClick="BAgregarHerida_Click" /></td>
            </tr>
            <asp:PlaceHolder runat="server" ID="PHerida" Visible="false">
            <tr>
                <td class="tdr tdl" colspan="4">
                <table style="border-collapse: collapse;">
                    <tr>
                        <td colspan="4" class="celdaTitulo tdr tdl">Valoración de heridas - Localización</td>
                    </tr>
                    <tr>
                        <td class="tdl">Localización<asp:RequiredFieldValidator ControlToValidate="RLocalizacion2" ErrorMessage="Por favor seleccione una localización." ID="RRL2" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                            <asp:RequiredFieldValidator ControlToValidate="RLocalizacion3" ErrorMessage="Por favor seleccione una localización." ID="RRL3" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        </td>
                        <td colspan="3" class="tdr" nowrap=nowrap>
                        <table cellpadding=0 cellspacing=0 width="100%">
                            <tr>
                                <td>
                                    <asp:DropDownList ID="DLocalizacion" runat="server" DataSourceID="SLocalizacion" 
                                        DataTextField="nombre" DataValueField="id">
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SLocalizacion" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                        SelectCommand="SELECT id, nombre FROM varios WHERE tipo=49 AND szReservado IS NULL ORDER BY nombre">
                                    </asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:RadioButtonList runat="server" ID="RLocalizacion2" RepeatColumns="3" DataSourceID="SLocalizacion2" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                                        <asp:ListItem Text="No aplica" Value="0"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:SqlDataSource ID="SLocalizacion2" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                        SelectCommand="SELECT id, nombre FROM varios WHERE tipo=70 AND szReservado IS NULL ORDER BY nombre">
                                    </asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:RadioButtonList runat="server" ID="RLocalizacion3" RepeatColumns="3" DataSourceID="SLocalizacion3" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                                        <asp:ListItem Text="No aplica" Value="0"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:SqlDataSource ID="SLocalizacion3" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                        SelectCommand="SELECT id, nombre FROM varios WHERE tipo=71 AND szReservado IS NULL ORDER BY nombre">
                                    </asp:SqlDataSource></td>
                            </tr>
                        </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdl">Ubicación especifica<asp:RequiredFieldValidator ValidationGroup="herida" ControlToValidate="TUbicacionEspecifica" ErrorMessage="Por favor ingrese una ubicación especifica." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td><asp:TextBox runat="server" ID="TUbicacionEspecifica"></asp:TextBox></td>
                        <td></td>
                        <td class="tdr"></td>
                    </tr>
                    <tr>
                        <td class="tdl">MI<asp:RequiredFieldValidator ControlToValidate="RMI" ErrorMessage="Por favor seleccione un valor para miembros inferiores." ID="RRMI" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td nowrap="nowrap">
                        <asp:RadioButtonList runat="server" ID="RMI" RepeatColumns="3" DataSourceID="SMI" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                            <asp:ListItem Text="No aplica" Value="0"></asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:SqlDataSource ID="SMI" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=72 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                        <td>Pies<asp:RequiredFieldValidator ControlToValidate="RPies" ErrorMessage="Por favor seleccione un valor para pies." ID="RRP" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td class="tdr" nowrap="nowrap">
                        <asp:RadioButtonList runat="server" ID="RPies" RepeatColumns="3" DataSourceID="SPies" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                            <asp:ListItem Text="No aplica" Value="0"></asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:SqlDataSource ID="SPies" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=73 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaSubTitulo tdl tdr">Categoría</td>
                    </tr>
                    <tr>
                        <td class="tdl">Clasificación</td>
                        <td><asp:DropDownList ID="DClasificacion" runat="server" DataSourceID="SClasificacion" 
                            DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SClasificacion" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=53 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                        <td>Factores de riesgo determinante<asp:RequiredFieldValidator ControlToValidate="TFactoresRiesgo" ErrorMessage="Por favor ingrese un factor de riesgo." ID="RTFR" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TFactoresRiesgo"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaSubTitulo tdr tdl">Tamaño</td>
                    </tr>
                    <tr>
                        <td class="tdl">Longitud<asp:RequiredFieldValidator ControlToValidate="TLongitud" ErrorMessage="Por favor ingrese una longitud." ID="RTL" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td><asp:TextBox runat="server" ID="TLongitud" CssClass="cms"></asp:TextBox></td>
                        <td>Anchura<asp:RequiredFieldValidator ControlToValidate="TAnchura" ErrorMessage="Por favor ingrese una anchura." ID="RTA" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TAnchura" CssClass="cms"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Profundidad<asp:RequiredFieldValidator ControlToValidate="TProfunidad" ErrorMessage="Por favor ingrese una profunidad." ID="RTP" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td><asp:TextBox runat="server" ID="TProfunidad" CssClass="cms"></asp:TextBox></td>
                        <td><asp:CheckBox runat="server" Text="Tunelización" ID="CTunelizacion" /></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TTunelizacion" CssClass="cms"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Cavidad<asp:RequiredFieldValidator ControlToValidate="TCavidad" ErrorMessage="Por favor ingrese una cavidad." ID="RTC" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td><asp:TextBox runat="server" ID="TCavidad" CssClass="cms"></asp:TextBox></td>
                        <td></td>
                        <td class="tdr"></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="tdl tdr celdaSubTitulo"><asp:CheckBox runat="server" ID="CBolsillo" Text="Bolsillo" /></td>
                    </tr>
                    <tr class="bolsillo hidet">
                        <td class="tdl">Profunidad<asp:RequiredFieldValidator ControlToValidate="TBolsilloProfundidad" ErrorMessage="Por favor ingrese una profunidad." ID="RTBP" CssClass="bolsillo" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td><asp:TextBox runat="server" ID="TBolsilloProfundidad" CssClass="cms"></asp:TextBox></td>
                        <td>Ubicación<asp:RequiredFieldValidator ControlToValidate="TBolsilloUbicacion" ErrorMessage="Por favor ingrese una ubicación." ID="RTBU" ValidationGroup="herida" CssClass="bolsillo"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TBolsilloUbicacion" CssClass="entero"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaSubTitulo tdr tdl">Porcentaje de tejido</td>
                    </tr>
                    <tr>
                        <td class="tdl">Compacto<asp:RequiredFieldValidator ControlToValidate="TCompacto" ErrorMessage="Por favor ingrese un porcentaje para compacto." ID="RTCo" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td><asp:TextBox runat="server" ID="TCompacto" CssClass="porcentaje"></asp:TextBox></td>
                        <td>De fibrina<asp:RequiredFieldValidator ControlToValidate="TDeFibrina" ErrorMessage="Por favor ingrese un porcentaje para fibrina." ID="RTDF" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TDeFibrina" CssClass="porcentaje"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Epitelización<asp:RequiredFieldValidator ControlToValidate="TEpitelizacion" ErrorMessage="Por favor ingrese un porcetaje para epitelización." ID="RTE" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td><asp:TextBox runat="server" ID="TEpitelizacion" CssClass="porcentaje"></asp:TextBox></td>
                        <td>Esfacelo<asp:RequiredFieldValidator ControlToValidate="TEscara" ErrorMessage="Por favor ingrese un porcentaje para esfacelo." ID="RTEs" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TEscara" CssClass="porcentaje"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Granulación<asp:RequiredFieldValidator ControlToValidate="TGranulacion" ErrorMessage="Por favor ingrese un porcentaje para granulación." ID="RTG" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td><asp:TextBox runat="server" ID="TGranulacion" CssClass="porcentaje"></asp:TextBox></td>
                        <td>Hipergranulación<asp:RequiredFieldValidator ControlToValidate="THipergranulacion" ErrorMessage="Por favor ingrese un porcentaje para hipergranulacion." ID="RTHG" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="THiperGranulacion" CssClass="porcentaje"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl" nowrap="nowrap">Limpio pero no granulado<asp:RequiredFieldValidator ControlToValidate="TLimpio" ErrorMessage="Por favor ingrese un porcentaje para limpio." ID="RTLi" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td><asp:TextBox runat="server" ID="TLimpio" CssClass="porcentaje"></asp:TextBox></td>
                        <td>Necrosis profunda<asp:RequiredFieldValidator ControlToValidate="TNecrosis" ErrorMessage="Por favor ingrese un porcentaje para necrosis." ID="RTN" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TNecrosis" CssClass="porcentaje"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl"></td>
                        <td></td>
                        <td>Total</td>
                        <td class="tdr"><asp:Label runat="server" ID="LTotalPorcentaje"></asp:Label></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaSubTitulo tdr tdl">Exudado</td>
                    </tr>
                    <tr>
                        <td class="tdl">Exudado</td>
                        <td><asp:DropDownList ID="DExudado" runat="server" DataSourceID="SExudado" 
                            DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SExudado" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=56 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                        <td>Tipo</td>
                        <td class="tdr"><asp:DropDownList ID="DTipoExudado" runat="server" DataSourceID="STipoExudado" 
                            DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="STipoExudado" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=57 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                    </tr>
                    <tr>
                        <td class="tdl">Piel circundante</td>
                        <td><asp:DropDownList ID="DPielCircundante" runat="server" DataSourceID="SPielCircundante" 
                            DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SPielCircundante" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=58 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                        <td nowrap="nowrap">Bordes de la herida</td>
                        <td class="tdr"><asp:DropDownList ID="DBordesHerida" runat="server" DataSourceID="SBordesHerida" 
                            DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SBordesHerida" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=59 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                    </tr>
                    <tr>
                        <td class="tdl">Signos y síntomas</td>
                        <td><asp:DropDownList ID="DSignosSintomas" runat="server" DataSourceID="SSignosSintomas" CssClass="anchomaxcombo" 
                            DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SSignosSintomas" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=61 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource>
                        </td>
                        <td></td>
                        <td class="tdr"></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaSubTitulo tdr tdl">Cambios locales de herida</td>
                    </tr>
                    <tr>
                        <td class="tdl">Tipo</td>
                        <td><asp:DropDownList ID="DTipoCambios" runat="server" DataSourceID="STipoCambios" CssClass="anchomaxcombo" AppendDataBoundItems="true" DataTextField="nombre" DataValueField="id">
                            <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="STipoCambios" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=65 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                        <td>Signos de infección<asp:RequiredFieldValidator ControlToValidate="TSignosInfeccion" ErrorMessage="Por favor ingrese un signo de infección." ID="RTSI" ValidationGroup="herida"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TSignosInfeccion"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="tdr tdl celdaTitulo" id="registrofotografico">Registro fotográfico</td>
                    </tr>
                    <tr>
                        <td colspan="4" class="tdl tdr">
                            <asp:DataList RepeatColumns="3" runat="server" ID="DFotos" 
                                DataKeyField="Archivo" ondeletecommand="DFotos_DeleteCommand" >
                                <ItemTemplate>
                                    <a href="<%# string.Format("../archivo/imagen.ashx?t=e&p={0}&i={1}&n={2}&d={3}&a=1&hi={4}", CCDetallePaciente.IdPaciente,ViewState["id"],Eval("Archivo"), Eval("Temporal"), Eval("Id")) %>">
                                    <img border=0 src="<%# string.Format("../archivo/imagen.ashx?t=e&p={0}&i={1}&n={2}&hi={4}&d={3}&w=150&h=150", CCDetallePaciente.IdPaciente,ViewState["id"],Eval("Archivo"), Eval("Temporal"), Eval("Id")) %>" />
                                    </a>
                                    <br />
                                    <%# Eval("Archivo") %>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CssClass="eliminar" CausesValidation="false" CommandName="delete" Text="Eliminar"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:DataList>
                            <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="foto" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdl">Subir un archivo<asp:RegularExpressionValidator ValidationGroup="foto" ID="RegularExpressionValidator1" SetFocusOnError="true" ValidationExpression="^.+\.((jpg)|(JPG)|(jpeg)|(JPEG))$" Display="Dynamic" ControlToValidate="FFoto" runat="server" ErrorMessage="Por favor seleccione un archivo de imagen JPG.">*</asp:RegularExpressionValidator>
                        <asp:RequiredFieldValidator ControlToValidate="FFoto" ValidationGroup="foto" ErrorMessage="Por favor seleccione una foto." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        </td>
                        <td colspan="3" class="tdr"><asp:FileUpload runat="server" ID="FFoto" Multiple="Multiple" /> 
                            <asp:Button runat="server" ID="BSubir" ValidationGroup="foto" Text="Subir" 
                                onclick="BSubir_Click" /></td>
                    </tr>
                    <tr>
                        <td class="tdr tdl" colspan="4">
                            <asp:Label runat="server" ID="LMensajeHerida" ForeColor="Red"></asp:Label>
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="herida" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdl tdb"><asp:Button runat="server" ID="BEliminar" Text="Eliminar" CausesValidation="false" OnClick="BEliminar_Click" Visible="false"/></td>
                        <td colspan="3" class="tdr tdb" align="right">
                            <asp:Button runat="server" ID="BAgregar" Text="Agregar" ValidationGroup="herida" onclick="BAgregar_Click" Visible="false" />
                            <asp:Button runat="server" ID="BCancelarHerida" Text="Cancelar" CausesValidation="false" onclick="BCancelarHerida_Click" />
                        </td>
                    </tr>
                </table>
                </td>
            </tr>
            </asp:PlaceHolder>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Plan de manejo</td>
            </tr>
            <td class="tdl" valign="top">Manejo<asp:RequiredFieldValidator ControlToValidate="TPlanManejo" ErrorMessage="Por favor ingrese un plan de manejo." ID="RTPM" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td colspan="3"><asp:TextBox ID="TPlanManejo" ReadOnly="true" runat="server" Height="200px" TextMode="MultiLine" Width="99%" CssClass="hidet"></asp:TextBox>
                <textarea id="elm1" name="elm1" style="width: 99%; height: 200px;" rows="2" cols="20"></textarea>
            </td>
            <tr>
                <td colspan="4" class="celdaTitulo">Indicaciones terapeuticas</td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Clínica</td>
            </tr>
            <tr>
                <td colspan="4" class="tdr tdl">
                    <asp:GridView ID="GClinica" runat="server" ShowHeader="false" AutoGenerateColumns="False" DataSourceID="SClinica" EmptyDataText="No se encontraron componentes" Width="100%" DataKeyNames="id">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:TemplateField HeaderText="Si">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="CSi" Text='<%# Eval("nombre") %>' Checked='<%# Eval("valor").ToString()=="1" %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SClinica" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre,valor FROM varios 
                                LEFT JOIN evolucion_herida_clinica ON (evolucion_herida_clinica.evolucion=@evolucion AND varios.id=evolucion_herida_clinica.concepto)
                                WHERE tipo=69 AND szReservado IS NULL ORDER BY nombre">
                            <SelectParameters>
                                <asp:Parameter Name="evolucion" DefaultValue="0" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td class="tdl">Otros</td>
                <td class="tdr" colspan="3"><asp:TextBox runat="server" ID="TOtros" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Componente educativo</td>
            </tr>
            <tr>
                <td colspan="4" class="tdr tdl tdb">
                    <asp:GridView ID="GEducativo" runat="server" ShowHeader="false" AutoGenerateColumns="False" DataSourceID="SEducativo" EmptyDataText="No se encontraron componentes" Width="100%" DataKeyNames="id">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:TemplateField HeaderText="Si">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="CSi" Text='<%# Eval("nombre") %>' Checked='<%# Eval("valor").ToString()=="1" %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SEducativo" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre,valor FROM varios 
                                LEFT JOIN evolucion_herida_educativo ON (evolucion_herida_educativo.evolucion=@evolucion AND varios.id=evolucion_herida_educativo.concepto)
                                WHERE tipo=62 AND szReservado IS NULL ORDER BY nombre">
                            <SelectParameters>
                                <asp:Parameter Name="evolucion" DefaultValue="0" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td colspan="4"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label></td>
            </tr>
            <tr>
                <td colspan="4"><asp:ValidationSummary runat="server" /></td>
            </tr>
            <tr>
                <td colspan="4" align="right">
                    <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                    <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" />
                </td>
            </tr>
        </table>
</ContentTemplate>
<Triggers>
    <asp:PostBackTrigger ControlID="BSubir" />
</Triggers>
</asp:UpdatePanel>
</asp:Content>