<%@ Page Title="Hoja de ingreso" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ingreso.aspx.cs" Inherits="paciente_ingreso" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript" src="<%=ResolveUrl("~/")%>js/tiny_mce.js"></script>
<script type="text/javascript">
    var editor = null;
    addFunctionToStart(function() {

    
    
        editor = null;
        $("#<%= TTA.ClientID %>").mask("999/99");
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
        if ($("#<%= PMujer.ClientID %>").length == 0) {
            $("#tmujer").remove();
            $("#tfisico").attr("colspan", "4").attr("width", "100%");
        }
        if (!$.browser.msie || $.browser.version > 8)
            $("input[name*=TObservaciones]").width("98%");

        tinyMCE.init({
            mode: "exact",
            elements: "elm1",
            theme: "advanced",
            readonly : true,
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
    });
    $(function() {
        $(window).resize(function() {
            $("input[name*=TObservaciones]").each(function() {
                $(this).width($(this).parent().width() - 15);
            });
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
        <ContentTemplate>
        <asp:HiddenField ID="HIdIngreso" runat="server" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table width="100%">
        	<tr>
                <td colspan="4" class="celdaTitulo">Información de atención básica</td>
            </tr>
            <tr>
                <td width="20%">Fecha</td>
                <td width="30%"><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
                <td width="20%">Hora</td>
                <td width="30%"><asp:TextBox ID="THora" runat="server" CssClass="hora"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="THora" ErrorMessage="Por favor ingrese una hora." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
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
                <td>Según</td>
                <td><asp:DropDownList ID="DMotivo" runat="server" DataSourceID="SMotivos" 
                        DataTextField="nombre" DataValueField="id">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SMotivos" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT id, nombre FROM varios WHERE tipo=1 AND szReservado IS NULL">
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td>Motivo consulta</td>
                <td colspan="3"><asp:TextBox ID="TMotivo" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TMotivo" ErrorMessage="Por favor ingrese un motivo." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>Enfermedad actual</td>
                <td colspan="3">
                    <asp:TextBox ID="TEnfermedadActual" runat="server" Height="120px" 
                        TextMode="MultiLine" Width="99%">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="TEnfermedadActual" ErrorMessage="Por favor ingrese una enfermedad." ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top" width="50%">
                <asp:GridView ID="GRevision" runat="server" AutoGenerateColumns="False" Width="100%"
                DataKeyNames="id,revision" DataSourceID="SRevision">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
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
                <td colspan="2" valign="top" width="50%">
                <asp:GridView ID="GAntecedentes" runat="server" AutoGenerateColumns="False" DataKeyNames="id, antecedente" DataSourceID="SAntecendentes" Width="100%">
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
            </tr>
            <tr>
                <td colspan="2" valign="top" id="tmujer" width="50%">
                    <asp:Panel runat="server" ID="PMujer">
                        <asp:GridView ID="GGinecologico" runat="server" AutoGenerateColumns="False" Width="100%"
                        DataKeyNames="id, varios" DataSourceID="SGinecologico">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
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
                <td colspan="2" valign="top" id="tfisico" width="50%">
                <asp:GridView ID="GExamenFisico" runat="server" AutoGenerateColumns="False" DataKeyNames="id, examen" DataSourceID="SExamenFisico" Width="100%">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
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
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Código de diagnóstico</td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:GridView ID="GCDiagnostico" runat="server" DataSourceID="SCDiagnostico" 
                        AutoGenerateColumns="False" DataKeyNames="id"
                        onselectedindexchanged="GCDiagnostico_SelectedIndexChanged" >
                        <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField DataField="codigo" HeaderText="Código" />
                            <asp:BoundField DataField="descripcion" HeaderText="Descripción" />
                            <asp:BoundField DataField="observaciones" HeaderText="Observaciones" />
                        </Columns>
                        <SelectedRowStyle CssClass="selecteditem" />
                    </asp:GridView>
                    <sdg:CustomDataSource ID="SCDiagnostico" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        SelectCommand="SELECT id,codigo,descripcion,observaciones FROM codigos_ingreso WHERE ingreso_paciente=@ingreso"
                                        DeleteCommand="DELETE FROM codigos_ingreso WHERE id=@id"
                                        InsertCommand="INSERT INTO codigos_ingreso(ingreso_paciente,codigo,descripcion,observaciones) VALUES (@ingreso, @codigo, @descripcion, @observaciones)"
                                        UpdateCommand="UPDATE codigos_ingreso SET codigo=@codigo,descripcion=@descripcion,observaciones=@observaciones WHERE id=@id" 
                                        >
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="HIdIngreso" DefaultValue="0" PropertyName="Value" Name="ingreso" />
                                        </SelectParameters>
                    </sdg:CustomDataSource>
                </td>
            </tr>
            <tr>
                <td colspan="2">CIE10</td>
                <td colspan="2">Observaciones</td>
            </tr>
            <tr>
                <td colspan="2"><asp:TextBox runat="server" Width="98%" ID="TCIE10"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TCIE10" ValidationGroup="cie10" ErrorMessage="Por favor ingrese un CIE10." ID="RequiredFieldValidator14" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
                <td colspan="2"><asp:TextBox runat="server" Width="98%" ID="TObservacionesCIE10"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Tipo diagnóstico</td>
                <td colspan="2">
                <asp:DropDownList ID="DTipoDiagnostico" runat="server" DataSourceID="STipoDiagnostico" 
                        DataTextField="nombre" DataValueField="id">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="STipoDiagnostico" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT id, nombre FROM varios WHERE tipo=20 AND szReservado IS NULL">
                    </asp:SqlDataSource>
                </td>
                <td align="right">
                <asp:Button ID="BMasCDiagnostico" runat="server" OnClick="BMasCDiagnostico_Click" Text="+" ValidationGroup="cie10" /></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">
                    Signos vitales</td>
            </tr>
            <tr>
                <td>
                    TA</td>
                <td>
                    <asp:TextBox ID="TTA" runat="server" CssClass="likenumber"></asp:TextBox>mm/Hg
                    <asp:RequiredFieldValidator ControlToValidate="TTA" ErrorMessage="Por favor ingrese una tensión arterial." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>
                    FC</td>
                <td>
                    <asp:TextBox ID="TFC" runat="server" CssClass="entero"></asp:TextBox>Lat/min
                    <asp:RequiredFieldValidator ControlToValidate="TFC" ErrorMessage="Por favor ingrese una frecuencia cardiaca." ID="RequiredFieldValidator6" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>
                    FR</td>
                <td>
                    <asp:TextBox ID="TFR" runat="server" CssClass="entero"></asp:TextBox>Min
                    <asp:RequiredFieldValidator ControlToValidate="TFR" ErrorMessage="Por favor ingrese una frecuencia respiratoria." ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>
                    T</td>
                <td>
                    <asp:TextBox ID="TT" runat="server" CssClass="float"></asp:TextBox>°
                    <asp:RequiredFieldValidator ControlToValidate="TT" ErrorMessage="Por favor ingrese una temperatura." ID="RequiredFieldValidator8" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>
                    Peso</td>
                <td>
                    <asp:TextBox ID="TPeso" runat="server" CssClass="float"></asp:TextBox>Kg</td>
                <td>
                    Saturación</td>
                <td>
                    <asp:TextBox ID="TSaturacion" runat="server" CssClass="float"></asp:TextBox>%
                    <asp:RequiredFieldValidator ControlToValidate="TSaturacion" ErrorMessage="Por favor ingrese una saturación." ID="RequiredFieldValidator10" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>
                    Glucometría</td>
                <td>
                    <asp:TextBox ID="TGlucometria" runat="server" CssClass="float"></asp:TextBox>mg/dl</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>Análisis clínico</td>
                <td colspan="3">
                    <asp:TextBox ID="TAnalisis" runat="server" Height="120px" TextMode="MultiLine" Width="99%"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="TAnalisis" ErrorMessage="Por favor ingrese un análisis." ID="RequiredFieldValidator12" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    Conducta inicial (Tomada de orden médica)</td>
            </tr>
            <tr>
                <td colspan="4"><asp:TextBox ID="TConductaInicial" ReadOnly="true" runat="server" Height="200px" TextMode="MultiLine" Width="99%" CssClass="hide"></asp:TextBox>
                <textarea id="elm1" name="elm1" style="width: 99%; height: 200px;" rows="2" cols="20"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="right">
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" 
            Text="Aceptar" />
        <asp:Button ID="BCancelar" runat="server" CausesValidation="False" 
            onclick="BCancelar_Click" Text="Cancelar" /></td>
            </tr>
        </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

