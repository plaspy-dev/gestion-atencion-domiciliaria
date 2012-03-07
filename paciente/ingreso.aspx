<%@ Page Title="Hoja de ingreso" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ingreso.aspx.cs" Inherits="paciente_ingreso" %>
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
        if (!$.browser.msie || $.browser.version>8)
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
            text[x]=text[x].trim();
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
        $("#<%= TConductaInicial.ClientID %>").val(limpio);
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
                var completa = $("#<%= TConductaInicial.ClientID %>").val();
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
        <asp:HiddenField ID="HIdIngreso" runat="server" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table width="100%">
        	<tr>
                <td colspan="4" class="celdaTitulo">Información de atención básica</td>
            </tr>
            <tr>
                <td width="20%">Fecha</td>
                <td width="30%"><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
                <td width="20%">Hora</td>
                <td width="30%"><asp:TextBox ID="THora" runat="server" CssClass="hora"></asp:TextBox></td>
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
                <td>Según</td>
                <td><asp:DropDownList ID="DMotivo" runat="server" DataSourceID="SMotivos" 
                DataTextField="nombre" DataValueField="id"></asp:DropDownList>
            <asp:SqlDataSource ID="SMotivos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=1 AND szReservado IS NULL" >
            </asp:SqlDataSource></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="2">Enfermedad actual</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="3">
                    <asp:TextBox ID="TEnfermedadActual" runat="server" Height="120px" TextMode="MultiLine" Width="99%"></asp:TextBox>
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
                <td colspan="2"><asp:GridView ID="GAntecedentes" runat="server" AutoGenerateColumns="False" DataKeyNames="id, antecedente" DataSourceID="SAntecendentes">
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
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre,antecedentes_ingreso.id AS antecedente,antecedentes_ingreso.estado AS estado,antecedentes_ingreso.observaciones FROM varios LEFT JOIN antecedentes_ingreso ON (antecedentes_ingreso.ingreso_paciente=@idingreso AND antecedentes_ingreso.motivo=varios.id) WHERE varios.tipo=2 AND varios.szReservado IS NULL" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdIngreso" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource></td>
                <td colspan="2">
                <asp:GridView ID="GRevision" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="id,revision" DataSourceID="SRevision">
                <Columns>
                    <asp:BoundField DataField="nombre" HeaderText="Revisión sistemas" />
                    <asp:TemplateField HeaderText="Nor">
                        <ItemTemplate>
                            <asp:CheckBox ID="CNor" runat="server" Checked='<%# Eval("nor").ToString()=="1" ? true : false %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Pat">
                        <ItemTemplate>
                            <asp:CheckBox ID="CPat" runat="server" Checked='<%# Eval("pat").ToString()=="1" ? true : false %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Observaciones" HeaderStyle-Width="100%">
                        <ItemTemplate>
                            <asp:TextBox runat="server" ID="TObservaciones" Text='<%# Eval("observaciones") %>'></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SRevision" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre,revision_ingreso.id AS revision,revision_ingreso.nor AS nor, revision_ingreso.pat AS pat,revision_ingreso.observaciones FROM varios LEFT JOIN revision_ingreso ON (revision_ingreso.ingreso_paciente=@idingreso AND revision_ingreso.motivo=varios.id) WHERE varios.tipo=3 AND varios.szReservado IS NULL" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdIngreso" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                <asp:GridView ID="GExamenFisico" runat="server" AutoGenerateColumns="False" DataKeyNames="id, examen" DataSourceID="SExamenFisico">
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
                <asp:TemplateField HeaderText="Observaciones" HeaderStyle-Width="100%" ItemStyle-Width="100%">
                    <ItemTemplate>
                        <asp:TextBox runat="server" ID="TObservaciones" Text='<%# Eval("observaciones") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SExamenFisico" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre, examen_ingreso.id AS examen,examen_ingreso.nor AS nor,examen_ingreso.pat AS pat,examen_ingreso.observaciones FROM varios LEFT JOIN examen_ingreso ON (examen_ingreso.ingreso_paciente=@idingreso AND examen_ingreso.motivo=varios.id) WHERE varios.tipo=4 AND varios.szReservado IS NULL" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdIngreso" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
                </td>
                <td colspan="2">
                    <asp:Panel runat="server" ID="PMujer">
                        <asp:GridView ID="GGinecologico" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="id, varios" DataSourceID="SGinecologico">
                        <Columns>
                            <asp:TemplateField HeaderText="Datos ginecológicos">
                                <ItemTemplate>
                                    <asp:CheckBox ID="CSi" runat="server" Checked='<%# Eval("estado").ToString()=="1" ? true : false %>' Text='<%# Eval("nombre") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Observaciones">
                                <ItemTemplate>
                                    <asp:TextBox runat="server" ID="TObservaciones" Text='<%# Eval("observaciones") %>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SGinecologico" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre,varios_ingreso.id AS varios, varios_ingreso.estado AS estado,varios_ingreso.observaciones FROM varios LEFT JOIN varios_ingreso ON (varios_ingreso.ingreso_paciente=@idingreso AND varios_ingreso.motivo=varios.id) WHERE varios.tipo=5 AND varios.szReservado IS NULL" >
                        <SelectParameters>
                            <asp:ControlParameter ControlID="HIdIngreso" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    </asp:Panel>
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
                                        SelectCommand="SELECT id,codigo,descripcion FROM codigos_ingreso WHERE ingreso_paciente=@ingreso"
                                        DeleteCommand="DELETE FROM codigos_ingreso WHERE id=@id"
                                        InsertCommand="INSERT INTO codigos_ingreso(ingreso_paciente,codigo,descripcion) VALUES (@ingreso, @codigo, @descripcion)"
                                        UpdateCommand="UPDATE codigos_ingreso SET codigo=@codigo,descripcion=@descripcion WHERE id=@id" 
                                        >
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="HIdIngreso" DefaultValue="0" PropertyName="Value" Name="ingreso" />
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
                <td colspan="4">Conducta inicial</td>
            </tr>
            <tr>
                <td colspan="4"><asp:TextBox ID="TConductaInicial" runat="server" Height="200px" TextMode="MultiLine" Width="99%" CssClass="hide"></asp:TextBox>
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

