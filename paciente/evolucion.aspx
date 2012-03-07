<%@ Page Title="Evolución" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evolucion.aspx.cs" Inherits="paciente_evolucion" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript" src="<%=ResolveUrl("~/")%>js/tiny_mce.js"></script>
<script type="text/javascript">
    $(function() {
        $("#ctl00_cph_TTA").mask("999/99");
        $("#<%= TCIE10.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetCodigoDiagnosticos",
                    data: "{}",
                    data: "{ 'q': '" + request.term + "' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.Name, label: item.Name
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 2,
            select: function(event, ui) {
            },
            search: function(event, ui) {
                // $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
            }
        });
        $("#<%= TFecha.ClientID %>").datepicker({
            onClose: function(dateText, inst) { if ($.getUrlVar('f') != $(this).val()) $("#<%=BFecha.ClientID %>").click(); }
        });
        $("#<%= PEvoluciones.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });

        FullRowSelect("#<%= GEvoluciones.ClientID %>");

        if (!$.browser.msie || $.browser.version > 8)
            $("input[name*=TObservaciones]").width("98%");
        $(window).resize(function() {
            $("input[name*=TObservaciones]").each(function() {
                $(this).width($(this).parent().width() - 15);
            });
        });
    });
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

    var editor = null;

    function lim() {
        var limpio = rel(editor.getContent().replace(/<\S[^><]*>/g, ""));
        $("#<%= TPlanManejo.ClientID %>").val(limpio);
        var completa = "<ol><li>" + limpio.replace(/\n/g, "</li><li>") + "</li></ol>";
        editor.setContent(completa);
    }
    
    function blurevent(ed) {
        tinyMCE.dom.Event.add(ed.getWin(), "blur", function(e) {
            tinyMCE.triggerSave();
            lim();
        });
    }

    tinyMCE.init({
        mode: "exact",
        elements: "elm1",
        theme: "advanced",
        theme_advanced_buttons1: "",
        theme_advanced_buttons2: "",
        theme_advanced_buttons3: "",
        valid_elements: "ol,li,p,br",
        setup: function(ed) {
            editor = ed;
            ed.onSubmit.add(function(ed, e) {
                lim();
            });
            ed.onInit.add(function(ed) {
                var completa = $("#<%= TPlanManejo.ClientID %>").val();
                completa = "<ol><li>" + completa.replace(/\n/g, "</li><li>") + "</li></ol>";
                editor.setContent(completa);
                blurevent(ed);
                $("#elm1").remove();
            });
        },
        paste_preprocess: function(pl, o) {
            o.content = o.content.replace(/<\S[^><]*>/g, "");
        }
    });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:Panel runat="server" id="PDatos" Visible="false">
        <asp:HiddenField ID="HIdEvolucion" runat="server" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table>
            <tr>
                <td colspan="4">
                <asp:Panel ID="PEvoluciones" runat="server">
                    <h3><a href="#"><asp:Label runat="server" ID="LEvoluciones"></asp:Label></a></h3>
                    <div class="hide">
                        <asp:GridView ID="GEvoluciones" runat="server" AutoGenerateColumns="False" 
                            DataSourceID="SEvoluciones" EmptyDataText="No se encontraron evoluciones de este paciente" >
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton CommandArgument='<%# Eval("fecha") %>' ID="IIr" runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" onclick="IIr_Click"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="motivo" HeaderText="Motivo" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SEvoluciones" runat="server" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT evolucion_paciente.fecha,evolucion_paciente.motivo
                                        FROM evolucion_paciente
                                        WHERE evolucion_paciente.paciente=@paciente
                                        ORDER BY fecha DESC;">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </asp:Panel>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Información de atención básica</td>
            </tr>
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox><asp:Button ID="BFecha" CssClass="hide" runat="server" Text="..." onclick="BFecha_Click" /></td>
                <td>Hora</td>
                <td><asp:TextBox ID="THora" runat="server" CssClass="hora"></asp:TextBox></td>
            </tr>
            <tr>
                <td>
                    Medico que atiende</td>
                <td>
                    <asp:DropDownList ID="DMedico" runat="server" DataSourceID="SMedicos" 
                DataTextField="perNombre" DataValueField="perId"> </asp:DropDownList>
            <asp:SqlDataSource ID="SMedicos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="SELECT perId,perNombre FROM admPersonalHS WHERE eEstId=1 and carId=6 ORDER BY perNombre">
            </asp:SqlDataSource></td>
                <td>&nbsp;
                    </td>
                <td>&nbsp;
                </td>
            </tr>
            <tr>
                <td>Motivo consulta</td>
                <td colspan="3"><asp:TextBox ID="TMotivo" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2">Datos subjetivos</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="3">
                    <asp:TextBox ID="TDatosSubjetivos" runat="server" Height="120px" 
                        TextMode="MultiLine" Width="99%"></asp:TextBox>
                </td>
                <td><table>
  <tr>
  <td>TA</td>
    <td>
      <asp:TextBox ID="TTA" runat="server" CssClass="likenumber"></asp:TextBox>
      </td>
    <td>
      mm/Hg</td>
    </tr>
                  <tr>
                    <td>FC</td>
                    <td>
                      <asp:TextBox ID="TFC" runat="server" CssClass="entero"></asp:TextBox>
                      </td>
                    <td>
                      Lat/min</td>
                  </tr>
                  <tr>
                    <td>FR</td>
                    <td>
                      <asp:TextBox ID="TFR" runat="server" CssClass="entero"></asp:TextBox>
                      </td>
                    <td>
                      Min</td>
                  </tr>
                  <tr>
                    <td>T</td>
                    <td>
                      <asp:TextBox ID="TT" runat="server" CssClass="float"></asp:TextBox>
                      </td>
                    <td>
                      °</td>
                  </tr>
                  <tr>
                    <td>Peso</td>
                    <td>
                      <asp:TextBox ID="TPeso" runat="server" CssClass="float"></asp:TextBox>
                      </td>
                    <td>
                      Kg</td>
  </tr>
</table></td>
            </tr>
            <tr>
                <td colspan="4"><asp:GridView ID="GAntecedentes" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="id, antecedente" DataSourceID="SAntecendentes">
                <Columns>
                    <asp:TemplateField HeaderText="Antecedentes">
                        <ItemTemplate>
                            <asp:CheckBox ID="CSi" runat="server" Checked='<%# Eval("estado").ToString()=="1" ? true : false %>' Text='<%# Eval("nombre") %>' />
                        </ItemTemplate>
                        <ItemStyle Wrap="false" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Observaciones" HeaderStyle-Width="100%">
                        <ItemTemplate>
                            <asp:TextBox runat="server" ID="TObservaciones" Text='<%# Eval("observaciones") %>'></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SAntecendentes" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre,antecedentes_evolucion.id AS antecedente,antecedentes_evolucion.estado AS estado,antecedentes_evolucion.observaciones FROM varios LEFT JOIN antecedentes_evolucion ON (antecedentes_evolucion.evolucion_paciente=@idingreso AND antecedentes_evolucion.motivo=varios.id) WHERE varios.tipo=2 AND varios.szReservado IS NULL" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdEvolucion" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:GridView ID="GExamenFisico" runat="server" AutoGenerateColumns="False"
                DataKeyNames="id, examen" DataSourceID="SExamenFisico">
            <Columns>
                <asp:BoundField DataField="nombre" HeaderText="Examen físico" />
                <asp:TemplateField HeaderText="Nor">
                    <ItemTemplate>
                        <asp:CheckBox ID="CNor" runat="server" Checked='<%# Eval("nor").ToString()=="1" ? true : false %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Pat">
                    <ItemTemplate>
                        <asp:CheckBox ID="CPat" runat="server" Checked='<%# Eval("pat").ToString()=="1" ? true : false %>'/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Observaciones" HeaderStyle-Width="100%">
                    <ItemTemplate>
                        <asp:TextBox runat="server" ID="TObservaciones" Text='<%# Eval("observaciones") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SExamenFisico" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre, examen_evolucion.id AS examen,examen_evolucion.nor AS nor,examen_evolucion.pat AS pat,examen_evolucion.observaciones FROM varios LEFT JOIN examen_evolucion ON (examen_evolucion.evolucion_paciente=@idingreso AND examen_evolucion.motivo=varios.id) WHERE varios.tipo=4 AND varios.szReservado IS NULL" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdEvolucion" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Código de diagnóstico</td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:GridView ID="GCDiagnostico" runat="server" DataSourceID="SCDiagnostico" 
                        AutoGenerateColumns="False" DataKeyNames="id"
                        onselectedindexchanged="GCDiagnostico_SelectedIndexChanged" >
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField DataField="codigo" HeaderText="Código" />
                            <asp:BoundField DataField="descripcion" HeaderText="Descripción" />
                        </Columns>
                        <SelectedRowStyle CssClass="selecteditem" />
                    </asp:GridView>
                    <sdg:CustomDataSource ID="SCDiagnostico" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        SelectCommand="SELECT id,codigo,descripcion FROM codigos_evolucion WHERE evolucion_paciente=@ingreso"
                                        DeleteCommand="DELETE FROM codigos_evolucion WHERE id=@id"
                                        InsertCommand="INSERT INTO codigos_evolucion(evolucion_paciente,codigo,descripcion) VALUES (@ingreso, @codigo, @descripcion)"
                                        UpdateCommand="UPDATE codigos_evolucion SET codigo=@codigo,descripcion=@descripcion WHERE id=@id" 
                                        >
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="HIdEvolucion" DefaultValue="0" PropertyName="Value" Name="ingreso" />
                                        </SelectParameters>
                    </sdg:CustomDataSource>
                </td>
            </tr>
            <tr>
                <td>CIE10</td>
              <td colspan="3"><asp:TextBox runat="server" Width="90%" ID="TCIE10"></asp:TextBox>
                <asp:Button ID="BMasCDiagnostico" runat="server" OnClick="BMasCDiagnostico_Click" Text="+" /></td>
            </tr>
            <tr>
                <td colspan="4">Analisis</td>
            </tr>
            <tr>
                <td colspan="4"><asp:TextBox ID="TAnalisis" runat="server" Height="200px" TextMode="MultiLine" Width="99%"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="4">Plan de manejo</td>
            </tr>
            <tr>
                <td colspan="4"><asp:TextBox ID="TPlanManejo" runat="server" Height="200px" TextMode="MultiLine" Width="99%" CssClass="hide"></asp:TextBox>
                <textarea id="elm1" name="elm1" style="width: 99%; height: 200px;" rows="2" cols="20"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="right"><asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" 
            Text="Aceptar" />
        <asp:Button ID="BCancelar" runat="server" CausesValidation="False" 
            onclick="BCancelar_Click" Text="Cancelar" /></td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>

