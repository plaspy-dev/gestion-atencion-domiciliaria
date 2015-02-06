<%@ Page Title="Valoración de heridas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="valoracion.aspx.cs" Inherits="clinicaheridas_valoracion" %>
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
img[usemap], map area{
    outline: none;
}
</style>
<script type="text/javascript" src="<%=ResolveUrl("~/")%>js/tinymce.min.js"></script>
<script type="text/javascript">
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
    
    $inicio(function() {

        $("#<%= DEscalaDolor.ClientID %>").change(function() {
            $("#iEscalaDolor").attr("src", "escalas/e" + $("option:selected", this).text().split(" ")[0] + ".jpg");
        }).change();
        $("#mEscalaDolor area").click(function() { 
            var valor = $(this).attr("title");
            $("#<%= DEscalaDolor.ClientID %> option").each(function() {
                if($(this).text().split(" ")[0]==valor) {
                    $("#<%= DEscalaDolor.ClientID %>").val($(this).val()).change();
                    return false;
                }
            });
            return false; 
        });

        $('.eliminar').each(function(i) {
            if (this.eliminar == undefined) {
                this.eliminar = $(this).attr("onclick");
                $(this).unbind('click').attr("onclick", "").click(function() { if (confirm('¿Esta seguro de eliminar este elemento?')) { if (this.eliminar != undefined) { if (this.eliminar.toString().indexOf("function") == -1) eval(this.eliminar); else this.eliminar(); } return true; } return false; });
            }
        });
        $("#<%= CFuncional.ClientID%>").change(function() {
            var $dfuncional= $("#<%= DFuncional.ClientID%>");
            $dfuncional.prop("disabled", $(this).is(":checked")).val("").change();
        }).change();
    
        $("#<%= COstomias.ClientID %>").change(function() {
            $(".ostomia").toggle($(this).is(':checked'));
        }).change();
        $("#<%= CBolsillo.ClientID %>").change(function() {
            $(".bolsillo").toggle($(this).is(':checked'));
        }).change();
        $("#<%= CFistulas.ClientID %>").change(function() {
            $(".fistula").toggle($(this).is(':checked'));
        }).change();
        $("#<%= CDispositivosMedicos.ClientID %>").change(function() {
            $(".dispositivos").toggle($(this).is(':checked'));
            $("#<%= DFuncional.ClientID %>").change();
        }).change();
        
        $("#<%= DFuncional.ClientID %>").change(function() {
            $(".obstruido").toggle(
                $("#<%= CDispositivosMedicos.ClientID %>").is(':checked') &&
                $(this).find('option:selected').text() == "Obstruido");
        }).change();
        
        $("#<%= TTunelizacion.ClientID %>").change(function() {
            $("#<%= CTunelizacion.ClientID %>").prop("checked", $(this).val() != "");
        }).change();
        $("#<%= TComplicaciones.ClientID %>").change(function() {
            $("#<%= CComplicaciones.ClientID %>").prop("checked", $(this).val() != "");
        }).change();
        $("#<%= DEtiologia.ClientID %>").change(function() {
            $(".etiologia").toggle($(this).val() == "0");
            $(".etiologiam").toggle($(this).find('option:selected').text() == "Por Presión");
        }).change();
        
        $("#<%= RPDistales.ClientID %>_0").change(function() {
            $(".pulsos").toggle($(this).is(':checked'));
        }).change();

        $("#<%= RPDistales.ClientID %>_1").change(function() {
            $(".pulsos").hide();
        });

        var tejidos = new Array();
        $("#<%= DTejidoSospechoso.ClientID %> option").each(function() {
            var texto = $(this).text().split(':');
            tejidos[$(this).val()] = texto[1];
            $(this).text(texto[0]);
        });

        $("#<%= DTejidoSospechoso.ClientID %>").change(function() {
            $("#descripciontejido").html("<b>" + $(this).find('option:selected').text() + ":</b> " + tejidos[$(this).val()]);
        }).change().show();

        $("#<%= DLugarOrigen.ClientID %>").change(function() {
            if ($(this).find('option:selected').text().indexOf("eriátrico") != -1)
                $(".geriatrico").show();
            else $(".geriatrico").hide();
        }).change();

        $("#<%= DEtiologia.ClientID %>").change(function() {
            $("#<%= LTipo.ClientID %>").text($(this).find('option:selected').text());
        }).change();

        $("#<%= DDefina.ClientID %>").change(function() {
            $("#<%= LClasificacion.ClientID %>").text($(this).find('option:selected').text());
        }).change();

        $('.cms:not(.rcms)')
            .autoNumeric('init', { vMin: 0, mDec: 1, aSep: '', aSign: ' cm', pSign: 's', aPad: false })
            .addClass("rcms");
        $('.porcentaje:not(.rporcentaje)').autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' %', pSign: 's' })
            .addClass("rporcentaje")
            .change(function() {
                var total = 0;
                $(".porcentaje").each(function() {
                    if($(this).autoNumeric('get'))
                        total += parseInt($(this).autoNumeric('get'));
                });
                $("#<%= LTotalPorcentaje.ClientID %>").text(total + " %");
                if (total > 100)
                    $("#<%= LTotalPorcentaje.ClientID %>").css("color", "#FF0000");
                else $("#<%= LTotalPorcentaje.ClientID %>").css("color", "#00FF00");
            })
            .change();
        $("#<%= TTA.ClientID %>").mask("999/99 mm/Hg");
        $("#<%= TFC.ClientID %>").autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' Lat/min', pSign: 's' });
        $("#<%= TFR.ClientID %>").autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' Min', pSign: 's' });
        $("#<%= TT.ClientID %>").autoNumeric('init', { vMin: 0, mDec: 1, aSep: '', aSign: ' °', pSign: 's', aPad: false });
        
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
                o.content = o.content.replace(/<\S[^><]*>/g, "");
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
<asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
<ContentTemplate>
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table style="border-collapse: collapse">
            <tr>
                <td colspan="4" class="tda">
                <table>
                    <tr>
                        <td style="text-align: justify"><b>Indicaciones</b><br />
Tenga en cuenta  que la evaluación detallada de esta valoración depende  el plan de intervención requerido<br />
En datos subjetivos  para la escala de dolor registre el número según corresponda.<br />
Marque con una (x) según corresponda en la localización, etiología, <br />
para la medición de la herida inserte el aplicador de algodón, mantenga los dedos en la superficie de la piel y mida desde los dedos hasta la punta, registre los cms o mms.<br />
Acerca de la tunelización, cavidad y tracto sinusal tenga en cuenta las manecillas del reloj donde las 12 inicia de forma cefalocaudal, registre 12, 3, 6, 9.</td>
                        <td><img src="casa.jpg" /></td>
                    </tr>
                </table>
                </td>
            </tr>
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
                <td>Funcionario<asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="UCFuncionario$TFuncionarioID" runat="server" ErrorMessage="Por favor ingrese un funcionario" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><uc6:Funcionario runat="server" ID="UCFuncionario" /></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Examén físico</td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Datos objetivos - signos vitales</td>
            </tr>
            <tr>
                <td class="tdl">TA</td>
                <td><asp:TextBox ID="TTA" runat="server" CssClass="likenumber"></asp:TextBox></td>
                <td>FC</td>
                <td class="tdr" nowrap=nowrap><asp:TextBox ID="TFC" runat="server" CssClass="likenumber"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl">FR</td>
                <td><asp:TextBox ID="TFR" runat="server" CssClass="likenumber"></asp:TextBox></td>
                <td>T</td>
                <td class="tdr"><asp:TextBox ID="TT" runat="server" CssClass="likenumber"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl nw">Pulsos distales</td>
                <td class="nw">
                <asp:RadioButtonList runat="server" ID="RPDistales" RepeatColumns="2">
                    <asp:ListItem Text="Presentes" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Ausentes" Value="0"></asp:ListItem>
                </asp:RadioButtonList>
                </td>
                <td><asp:Label runat="server" Text="Observaciones" CssClass="pulsos hide"></asp:Label></td>
                <td class="tdr"><asp:TextBox runat="server" ID="TObservacionPulso" CssClass="pulsos hide"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="tdr tdl">
                <asp:GridView ID="GAntecedentes" runat="server" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="SAntecendentes" Width="100%">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Antecedentes">
                            <ItemTemplate>
                                <asp:CheckBox ID="CSi" runat="server" Checked='<%# Eval("estado").ToString()=="1" ? true : false %>' Text='<%# Eval("nombre") %>' />
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Observaciones" ItemStyle-Width="100%">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TObservaciones" Text='<%# Eval("observaciones") %>' Width="99%"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SAntecendentes" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre
                                    ,IFNULL(IFNULL(valoracion_herida_antecedentes.estado,antigua.estado),antecedentes_ingreso.estado) AS estado
                                    ,IFNULL(IFNULL(valoracion_herida_antecedentes.observaciones,antigua.observaciones),antecedentes_ingreso.observaciones) AS observaciones
                                    FROM varios 
                                    LEFT JOIN valoracion_herida_antecedentes ON (valoracion_herida_antecedentes.valoracion=@valoracion AND valoracion_herida_antecedentes.motivo=varios.id) 

                                    LEFT JOIN ingreso_paciente ON (ingreso_paciente.paciente=@paciente)
                                    LEFT JOIN antecedentes_ingreso ON (antecedentes_ingreso.ingreso_paciente=ingreso_paciente.id AND antecedentes_ingreso.motivo=varios.id)
                                    LEFT JOIN (
                                        SELECT estado,observaciones,antecedentes_evolucion.motivo FROM evolucion_paciente LEFT JOIN antecedentes_evolucion ON (antecedentes_evolucion.evolucion_paciente=evolucion_paciente.id) WHERE
                                        evolucion_paciente.paciente=@paciente AND evolucion_paciente.id=(SELECT MAX(id) FROM evolucion_paciente WHERE paciente=@paciente)
                                    ) AS antigua ON (antigua.motivo=varios.id)

                                    WHERE varios.tipo=2 AND varios.szReservado IS NULL" >
                    <SelectParameters>
                        <asp:Parameter Name="valoracion" DefaultValue="0" />
                        <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
                    </SelectParameters>
                </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="tdl tdr">
                <asp:GridView ID="GRiesgos" runat="server" AutoGenerateColumns="False" Width="100%" 
                    DataKeyNames="id" DataSourceID="SRiesgos">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Riesgo">
                            <ItemTemplate>
                                <asp:CheckBox ID="CSi" runat="server" Checked='<%# Eval("estado").ToString()=="1" ? true : false %>' Text='<%# Eval("nombre") %>' />
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Observaciones" ItemStyle-Width="100%">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TObservaciones" Width="99%" Text='<%# Eval("observaciones") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SRiesgos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre
                                    ,IFNULL(IFNULL(valoracion_herida_riesgos.estado,antigua.estado),ingreso_riesgos.estado) AS estado
                                    ,IFNULL(IFNULL(valoracion_herida_riesgos.observaciones,antigua.observaciones),ingreso_riesgos.observaciones) AS observaciones
                                    FROM varios 
                                    LEFT JOIN valoracion_herida_riesgos ON (valoracion_herida_riesgos.valoracion=@valoracion AND valoracion_herida_riesgos.motivo=varios.id) 

                                    LEFT JOIN ingreso_paciente ON (ingreso_paciente.paciente=@paciente)
                                    LEFT JOIN ingreso_riesgos ON (ingreso_riesgos.ingreso_paciente=ingreso_paciente.id AND ingreso_riesgos.motivo=varios.id)
                                    LEFT JOIN (
                                        SELECT estado,observaciones,evolucion_riesgos.motivo FROM evolucion_paciente LEFT JOIN evolucion_riesgos ON (evolucion_riesgos.evolucion_paciente=evolucion_paciente.id) WHERE
                                        evolucion_paciente.paciente=@paciente AND evolucion_paciente.id=(SELECT MAX(id) FROM evolucion_paciente WHERE paciente=@paciente)
                                    ) AS antigua ON (antigua.motivo=varios.id)
                                    WHERE varios.tipo=38 AND varios.szReservado IS NULL
                                    ;" >
                    <SelectParameters>
                        <asp:Parameter Name="valoracion" DefaultValue="0" />
                        <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
                    </SelectParameters>
                </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="tdl tdr celdaSubTitulo"><asp:CheckBox runat="server" ID="CFistulas" Text="Fístulas" /></td>
            </tr>
            <tr class="hide fistula">
                <td class="tdl">Localización</td>
                <td><asp:TextBox runat="server" ID="TLocalizacionFistula"></asp:TextBox></td>
                <td></td>
                <td class="tdr"></td>
            </tr>
            <tr class="hide fistula">
                <td class="tdl">Cantidad afluente</td>
                <td><asp:TextBox runat="server" ID="TCAfluente" CssClass="cms"></asp:TextBox></td>
                <td class="tdr" colspan="2"><asp:CheckBox runat="server" ID="CSignosInfeccion" Text="Signos de infección" /></td>
            </tr>
            <tr>
                <td colspan="4" class="tdl tdr celdaSubTitulo"><asp:CheckBox runat="server" ID="COstomias" Text="Ostomías" /></td>
            </tr>
            <tr class="hide ostomia">
                <td class="tdl">Tipo</td>
                <td nowrap="nowrap">
                <asp:RadioButtonList runat="server" ID="RTipo" RepeatColumns="2">
                    <asp:ListItem Text="Temporal" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Definitiva" Value="1"></asp:ListItem>
                </asp:RadioButtonList>
                <td>Ubicación del estoma</td>
                <td class="tdr"><asp:TextBox runat="server" ID="TUbicacion"></asp:TextBox></td>
            </tr>
            <tr class="hide ostomia">
                <td class="tdl" nowrap="nowrap">Color del estoma</td>
                <td><asp:DropDownList ID="DColor" runat="server" DataSourceID="SColor" 
                        DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                        <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SColor" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT id, nombre FROM varios WHERE tipo=42 AND szReservado IS NULL ORDER BY nombre">
                    </asp:SqlDataSource></td>
                <td nowrap="nowrap">Estoma a nivel de la piel</td>
                <td class="tdr"><asp:DropDownList ID="DEstoma" runat="server" DataSourceID="SEstoma" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                        <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstoma" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=43 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            </tr>
            <tr class="hide ostomia">
                <td class="tdl">Complicaciones</td>
                <td><asp:DropDownList ID="DComplicacion" runat="server" DataSourceID="SComplicacion" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                        <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SComplicacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=44 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
                <td>Estado de la piel</td>
                <td class="tdr"><asp:DropDownList ID="DEstadoPiel" runat="server" DataSourceID="SEstadoPiel" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                        <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstadoPiel" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=45 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdl tdr"><asp:CheckBox runat="server" Text="Dispositivos médicos insertados" ID="CDispositivosMedicos" /></td>
            </tr>
            <tr class="hide dispositivos">
                <td class="tdl">Tipo</td>
                <td><asp:DropDownList ID="DTipoDispositivo" runat="server" DataSourceID="STipoDispositivo" 
                    DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="STipoDispositivo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=46 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
                <td><asp:CheckBox runat="server" ID="CFuncional" Text="Funcional" Checked="true" /></td>
                <td class="tdr"><asp:DropDownList ID="DFuncional" runat="server" DataSourceID="SFuncional" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Sí)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SFuncional" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=47 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            </tr>
            <tr class="hide obstruido">
                <td class="tdl"></td>
                <td></td>
                <td>Descripción</td>
                <td class="tdr"><asp:TextBox runat="server" ID="TFuncionalDescripcion"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Datos subjetivos</td>
            </tr>
            <tr>
                <td class="tdl">Escala de dolor</td>
                <td><asp:DropDownList ID="DEscalaDolor" runat="server" DataSourceID="SEscalaDolor" 
                    DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEscalaDolor" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, CONCAT(nombre, ' - ', descripcion) AS nombre FROM varios WHERE tipo=48 AND szReservado IS NULL ORDER BY CAST(nombre AS UNSIGNED)">
                </asp:SqlDataSource></td>
                <td colspan="2" class="tdr">
                    <img alt="Escala de dolor" id="iEscalaDolor" src="escaladolor.jpg" usemap="#mEscalaDolor" hidefocus="true" tabindex="-1" />
                    <map id="mEscalaDolor">
                        <area alt='1' title='1' href='#' shape='rect' coords='97,0,147,70' />
                        <area alt='2' title='2' href='#' shape='rect' coords='147,0,172,70' />
                        <area alt='3' title='3' href='#' shape='rect' coords='172,0,197,70' />
                        <area alt='4' title='4' href='#' shape='rect' coords='197,0,222,70' />
                        <area alt='5' title='5' href='#' shape='rect' coords='222,0,247,70' />
                        <area alt='6' title='6' href='#' shape='rect' coords='247,0,272,70' />
                        <area alt='7' title='7' href='#' shape='rect' coords='272,0,297,70' />
                        <area alt='8' title='8' href='#' shape='rect' coords='297,0,322,70' />
                        <area alt='9' title='9' href='#' shape='rect' coords='322,0,347,70' />
                        <area alt='10' title='10' href='#' shape='rect' coords='347,0,372,70' />
                    </map>
                </td>
            </tr>
            
            <tr>
                <td class="tdr tdl celdaTitulo" colspan="4">Heridas</td>
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
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:BoundField DataField="Nombre" HeaderText="Localización" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td class="tdr tdl" colspan="4">
                <table style="border-collapse: collapse;">
                    <tr>
                        <td colspan="4" class="celdaTitulo tdr tdl">Valoración de heridas - Localización</td>
                    </tr>
                    <tr>
                        <td class="tdl">Localización</td>
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
                                        <asp:ListItem Text="No aplica" Value=""></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:SqlDataSource ID="SLocalizacion2" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                        SelectCommand="SELECT id, nombre FROM varios WHERE tipo=70 AND szReservado IS NULL ORDER BY nombre">
                                    </asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:RadioButtonList runat="server" ID="RLocalizacion3" RepeatColumns="3" DataSourceID="SLocalizacion3" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                                        <asp:ListItem Text="No aplica" Value=""></asp:ListItem>
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
                        <td class="tdl">MI</td>
                        <td>
                        <asp:RadioButtonList runat="server" ID="RMI" RepeatColumns="3" DataSourceID="SMI" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                            <asp:ListItem Text="No aplica" Value=""></asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:SqlDataSource ID="SMI" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=72 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                        <td>Pies</td>
                        <td class="tdr" nowrap="nowrap">
                        <asp:RadioButtonList runat="server" ID="RPies" RepeatColumns="3" DataSourceID="SPies" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                            <asp:ListItem Text="No aplica" Value=""></asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:SqlDataSource ID="SPies" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=73 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaTitulo tdl tdr">Etiología</td>
                    </tr>
                    <tr>
                        <td class="tdl">Etiología</td>
                        <td><asp:DropDownList ID="DEtiologia" runat="server" DataSourceID="SEtiologia" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                            <asp:ListItem Text="Otro" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SEtiologia" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=50 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                        <td><asp:Label runat="server" Text="Otro" ID="LOtroEtiologia" CssClass="etiologia hide"></asp:Label></td>
                        <td class="tdr"><asp:TextBox runat="server" CssClass="etiologia hide" ID="TOtroEtiologia"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaTitulo tdl tdr">Categoría</td>
                    </tr>
                    <tr class="etiologiam hide">
                        <td colspan="4" class="celdaSubTitulo tdl tdr">Evolución</td>
                    </tr>
                    <tr class="etiologiam hide">
                        <td class="tdl">Tiempo de evolución de la úlcera</td>
                        <td><asp:TextBox runat="server" ID="TTiempoEvolucion"></asp:TextBox></td>
                        <td>Tejido profundo sospechoso</td>
                        <td class="tdr"><asp:DropDownList CssClass="hide" ID="DTejidoSospechoso" runat="server" DataSourceID="STejidoSospechoso" 
                            DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="STejidoSospechoso" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, CONCAT(nombre,':',descripcion) AS nombre FROM varios WHERE tipo=52 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                    </tr>
                    <tr class="etiologiam hide">
                        <td colspan="2" class="tdl"></td>
                        <td colspan="2" class="tdr" id="descripciontejido"></td>
                    </tr>
                    <tr class="etiologiam hide">
                        <td class="tdl">Lugar donde se originó la úlcera</td>
                        <td><asp:DropDownList ID="DLugarOrigen" runat="server" DataSourceID="SLugarOrigen" 
                            DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SLugarOrigen" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=51 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                        <td><asp:Label Text="Especifique" runat="server" ID="LHogarGeriatrico" CssClass="hide geriatrico"></asp:Label></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="THogarGeriatrico" CssClass="hide geriatrico"></asp:TextBox></td>
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
                        <td>Factores de riesgo determinante</td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TFactoresRiesgo"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaTitulo tdr tdl">Medición</td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaSubTitulo tdr tdl">Tamaño</td>
                    </tr>
                    <tr>
                        <td class="tdl">Longitud</td>
                        <td><asp:TextBox runat="server" ID="TLongitud" CssClass="cms"></asp:TextBox></td>
                        <td>Anchura</td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TAnchura" CssClass="cms"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Profundidad</td>
                        <td><asp:TextBox runat="server" ID="TProfunidad" CssClass="cms"></asp:TextBox></td>
                        <td><asp:CheckBox runat="server" Text="Tunelización" ID="CTunelizacion" /></td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TTunelizacion" CssClass="cms"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Cavidad</td>
                        <td><asp:TextBox runat="server" ID="TCavidad" CssClass="cms"></asp:TextBox></td>
                        <td></td>
                        <td class="tdr"></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="tdl tdr celdaSubTitulo"><asp:CheckBox runat="server" ID="CBolsillo" Text="Bolsillo" /></td>
                    </tr>
                    <tr class="bolsillo hide">
                        <td class="tdl">Profunidad</td>
                        <td><asp:TextBox runat="server" ID="TBolsilloProfundidad" CssClass="cms"></asp:TextBox></td>
                        <td>Ubicación</td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TBolsilloUbicacion" CssClass="entero"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaTitulo tdr tdl">Evaluación</td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaSubTitulo tdr tdl">Lecho de la herida</td>
                    </tr>
                    <tr>
                        <td class="tdl">Tejido necrótico</td>
                        <td colspan="3" class="tdr"><asp:RadioButtonList runat="server" ID="RTipoTejido" RepeatColumns="2">
                            <asp:ListItem Text="menor al 25%" Value="0"></asp:ListItem>
                            <asp:ListItem Text="mayor al 25%" Value="1"></asp:ListItem>
                        </asp:RadioButtonList></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="celdaSubTitulo tdr tdl">Porcentaje de tejido</td>
                    </tr>
                    <tr>
                        <td class="tdl">Compacto</td>
                        <td><asp:TextBox runat="server" ID="TCompacto" CssClass="porcentaje"></asp:TextBox></td>
                        <td>De fibrina</td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TDeFibrina" CssClass="porcentaje"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Epitelización</td>
                        <td><asp:TextBox runat="server" ID="TEpitelizacion" CssClass="porcentaje"></asp:TextBox></td>
                        <td>Esfacelo</td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TEscara" CssClass="porcentaje"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Granulación</td>
                        <td><asp:TextBox runat="server" ID="TGranulacion" CssClass="porcentaje"></asp:TextBox></td>
                        <td>Hipergranulación</td>
                        <td class="tdr"><asp:TextBox runat="server" ID="THiperGranulacion" CssClass="porcentaje"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Limpio pero no granulado</td>
                        <td><asp:TextBox runat="server" ID="TLimpio" CssClass="porcentaje"></asp:TextBox></td>
                        <td>Necrosis profunda</td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TNecrosis" CssClass="porcentaje"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Seleccione</td>
                        <td><asp:DropDownList ID="DSeleccione" runat="server" DataSourceID="SSeleccione" 
                            DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SSeleccione" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=55 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
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
                        <td>Bordes de la herida</td>
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
                        <td class="tdl">Olor</td>
                        <td><asp:DropDownList ID="DOlor" runat="server" DataSourceID="SOlor" DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SOlor" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=60 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource></td>
                        <td>Descripción</td>
                        <td class="tdr"><asp:TextBox runat="server" ID="TOlorDescripcion"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="tdl">Signos y síntomas</td>
                        <td><asp:DropDownList ID="DSignosSintomas" runat="server" DataSourceID="SSignosSintomas" 
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
                        <td class="tdl" nowrap="nowrap"><asp:CheckBox runat="server" Text="Complicaciones" ID="CComplicaciones" /></td>
                        <td><asp:TextBox runat="server" ID="TComplicaciones"></asp:TextBox></td>
                        <td>Clasificación</td>
                        <td class="tdr"><asp:DropDownList ID="DDefina" runat="server" DataSourceID="SDefina" 
                            DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SDefina" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM varios WHERE tipo=68 AND szReservado IS NULL ORDER BY nombre">
                        </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" class="tdr tdl celdaTitulo" id="registrofotografico">Registro fotográfico</td>
                    </tr>
                    <tr>
                        <td colspan="4" class="tdl tdr">
                            <asp:DataList RepeatColumns="3" runat="server" ID="DFotos" 
                                DataKeyField="Archivo" ondeletecommand="DFotos_DeleteCommand" >
                                <ItemTemplate>
                                    <a href="<%# string.Format("../archivo/imagen.ashx?t=v&p={0}&i={1}&n={2}&d={3}&a=1&hi={4}", CCDetallePaciente.IdPaciente,ViewState["id"],Eval("Archivo"), Eval("Temporal"), Eval("Id")) %>">
                                    <img border=0 src="<%# string.Format("../archivo/imagen.ashx?t=v&p={0}&i={1}&n={2}&hi={4}&d={3}&w=150&h=150", CCDetallePaciente.IdPaciente,ViewState["id"],Eval("Archivo"), Eval("Temporal"), Eval("Id")) %>" />
                                    </a>
                                    <br />
                                    <%# Eval("Archivo") %>
                                    <asp:LinkButton runat="server" CssClass="eliminar" CausesValidation="false" CommandName="delete" Text="Eliminar"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:DataList>
                            <asp:ValidationSummary runat="server" ValidationGroup="foto" />
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
                    </table>
                </td>
            </tr>
            <tr>
                <td class="tdr tdl" colspan="4">
                    <asp:Label runat="server" ID="LMensajeHerida" ForeColor="Red"></asp:Label>
                    <asp:ValidationSummary runat="server" ValidationGroup="herida" />
                </td>
            </tr>
            <tr>
                <td class="tdl"><asp:Button runat="server" ID="BEliminar" Text="Eliminar" CausesValidation="false" OnClick="BEliminar_Click" Visible="false"/></td>
                <td colspan="3" class="tdr" align="right">
                    <asp:Button runat="server" ID="BAgregar" Text="Agregar" ValidationGroup="herida" onclick="BAgregar_Click" />
                    <asp:Button runat="server" ID="BCancelarHerida" Text="Cancelar" CausesValidation="false" onclick="BCancelarHerida_Click" />
                </td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo tdr tdl">Plan de intervención</td>
            </tr>
            <tr>
                <td class="tdl">Clasificación</td>
                <td colspan="3" class="tdr"><asp:Label runat="server" ID="LClasificacion"></asp:Label></td>
            </tr>
            <tr>
                <td class="tdl">Tipo</td>
                <td colspan="3" class="tdr"><asp:Label runat="server" ID="LTipo"></asp:Label></td>
            </tr>
            <tr>
                <td class="tdl">Periodicidad</td>
                <td colspan="3" class="tdr"><asp:TextBox runat="server" Width="99%" ID="TPeriodicidad"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl" valign="top">Manejo</td>
                <td colspan="3"><asp:TextBox ID="TPlanManejo" ReadOnly="true" runat="server" Height="200px" TextMode="MultiLine" Width="99%" CssClass="hide"></asp:TextBox>
                <textarea id="elm1" name="elm1" style="width: 99%; height: 200px;" rows="2" cols="20"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo tdr tdl">Componente educativo</td>
            </tr>
            <tr>
                <td colspan="4"><asp:CheckBox runat="server" ID="CConsentimiento" Text="Consentimiento informado" /></td>
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
                                LEFT JOIN valoracion_herida_educativo ON (valoracion_herida_educativo.valoracion=@valoracion AND varios.id=valoracion_herida_educativo.concepto)
                                WHERE tipo=62 AND szReservado IS NULL ORDER BY nombre">
                            <SelectParameters>
                                <asp:Parameter Name="valoracion" DefaultValue="0" />
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