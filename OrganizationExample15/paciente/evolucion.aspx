<%@ Page Title="Evolución" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evolucion.aspx.cs" Inherits="paciente_evolucion" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<%@ Register Src="~/archivo/digitalizacionc.ascx" TagName="Digitalizacion" TagPrefix="uc6" %>
<%@ Register src="~/ctrl/sharehistory.ascx" tagname="ShareHistory" tagprefix="uc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <%= SDG.Componentes.HtmlUtil.RenderScript("~/js/tinymce.min.js") %>
<script type="text/javascript">
    var editor = null;
    addFunctionToStart(function() {
        editor = null;
        $("#ctl00_cph_TTA").mask("999/999");
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
                $("#<%= TIdFuncionario.ClientID %>").val(ui.item.value);
                return false;
            },
            search: function(event, ui) {
                $("#<%= TIdFuncionario.ClientID %>").val("");
            }
        });
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
        $("#<%= PEvoluciones.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });

        FullRowSelect("#<%= GEvoluciones.ClientID %>");

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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc:ShareHistory runat="server" ID="SH" />
    <uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:UpdatePanel runat="server" ID="PDatos" Visible="false" UpdateMode="Conditional">
        <ContentTemplate>
        <asp:HiddenField ID="HIdEvolucion" runat="server" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table style="border-collapse: collapse">
            <tr>
                <td colspan="4">
                <uc6:Digitalizacion ID="DArchivo" runat="server" Tipo="Historia Clínica,Laboratorio Clínico,Concurrencia" />
                <asp:Panel ID="PEvoluciones" runat="server">
                    <h3><a href="#"><asp:Label runat="server" ID="LEvoluciones"></asp:Label></a></h3>
                    <div class="hidet">
                        <asp:GridView ID="GEvoluciones" runat="server" AutoGenerateColumns="False" Width="100%" 
                            DataSourceID="SEvoluciones" 
                            EmptyDataText="No se encontraron evoluciones de este paciente">
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton CommandArgument='<%# Eval("id") %>' ID="IIr" runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" onclick="IIr_Click"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="perNombre" HeaderText="Funcionario" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="carDescripcion" HeaderText="Cargo" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="motivo" HeaderText="Motivo" ItemStyle-Width="100%" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SEvoluciones" runat="server" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT evolucion_paciente.id,evolucion_paciente.fecha,evolucion_paciente.motivo
                                        ,evolucion_paciente.medico,recurso_humano.perNombre,cargo.carDescripcion
                                        FROM evolucion_paciente
                                        LEFT JOIN recurso_humano ON (recurso_humano.perId=evolucion_paciente.medico)
                                        LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)
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
                <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha valida" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))) (0[0-9]|1\d|2[0-3]):([0-5]\d)$" runat="server" >*</asp:RegularExpressionValidator>
                <sdg:DateTimeValidator runat="server" ID="DTV" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha valida." Display="Dynamic" SetFocusOnError="true">*</sdg:DateTimeValidator>
                </td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fechahora"></asp:TextBox></td>
            </tr>
            <tr>
                <td nowrap="nowrap">
                    Funcionario que atiende<asp:RequiredFieldValidator ControlToValidate="TIdFuncionario" ErrorMessage="Por favor ingrese un funcionario." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>
                    <asp:TextBox ID="TFuncionario" runat="server" Width="98%"></asp:TextBox>
                    <asp:TextBox ID="TIdFuncionario" runat="server" CssClass="hidet"></asp:TextBox>
                </td>
                <td nowrap="nowrap">Nivel de atención<asp:RequiredFieldValidator ControlToValidate="DNivelAtencion" ErrorMessage="Por favor seleccione un nivel de atención." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td><asp:DropDownList ID="DNivelAtencion" runat="server" DataSourceID="SNivelAtencion" 
                        DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                        <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SNivelAtencion" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT id, nombre FROM varios WHERE tipo=37 AND szReservado IS NULL">
                    </asp:SqlDataSource>
                </td>
            </tr>
            <asp:PlaceHolder runat="server" ID="PNivelAtencion" Visible="false">
            <tr>
                <td>Área encargada</td>
                <td><asp:DropDownList ID="DArea" runat="server" DataSourceID="SArea" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true" CssClass="amc">
                    <asp:ListItem Text="(Ninguna)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SArea" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id,nombre FROM varios WHERE varios.tipo=22 AND varios.szReservado IS NULL;">
                </asp:SqlDataSource></td>
                <td>Seguimiento<asp:RangeValidator ControlToValidate="TFechaSeguimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                <td><asp:TextBox runat="server" ID="TFechaSeguimiento" CssClass="fecha"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Código</td>
                <td><asp:HyperLink runat="server" ID="HCodigo"></asp:HyperLink></td>
                <td></td>
                <td><asp:Button runat="server" ID="BActualizar" Text="Actualizar" CausesValidation="false" OnClick="BActualizar_Click" /></td>
            </tr>
            </asp:PlaceHolder>
            <tr>
                <td colspan="4" class="celdaTitulo">
                    Signos vitales</td>
            </tr>
            <tr>
                <td>
                    TA<asp:RequiredFieldValidator ControlToValidate="TTA" ErrorMessage="Por favor ingrese una tension arterial." ID="RequiredFieldValidator6" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>
                    <asp:TextBox ID="TTA" runat="server" CssClass="likenumber"></asp:TextBox>mm/Hg</td>
                <td>
                    FC<asp:RequiredFieldValidator ControlToValidate="TFC" ErrorMessage="Por favor ingrese una frecuencia cardiaca." ID="RequiredFieldValidator9" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td nowrap="nowrap">
                    <asp:TextBox ID="TFC" runat="server" CssClass="entero"></asp:TextBox>Lat/min</td>
            </tr>
            <tr>
                <td>
                    FR<asp:RequiredFieldValidator ControlToValidate="TFR" ErrorMessage="Por favor ingrese una frecuencia respiratoria." ID="RequiredFieldValidator10" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td>
                    <asp:TextBox ID="TFR" runat="server" CssClass="entero"></asp:TextBox>
                    Min</td>
                <td>
                    T</td>
                <td>
                    <asp:TextBox ID="TT" runat="server" CssClass="float"></asp:TextBox>°</td>
            </tr>
            <tr>
                <td>
                    Peso</td>
                <td>
                    <asp:TextBox ID="TPeso" runat="server" CssClass="float"></asp:TextBox>
                    Kg</td>
                <td>
                    Saturación</td>
                <td>
                    <asp:TextBox ID="TSaturacion" runat="server" CssClass="float"></asp:TextBox>
                    %</td>
            </tr>
            <tr>
                <td>
                    Glucometría</td>
                <td>
                    <asp:TextBox ID="TGlucometria" runat="server" CssClass="float"></asp:TextBox>
                    mg/dl</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>Motivo consulta<asp:RequiredFieldValidator ID="RequiredFieldValidator7" ControlToValidate="TMotivo" ErrorMessage="Por favor ingrese un motivo." runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td colspan="3"><asp:TextBox ID="TMotivo" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2">Datos subjetivos<asp:RequiredFieldValidator ID="RequiredFieldValidator8" ControlToValidate="TDatosSubjetivos" ErrorMessage="Por favor ingrese unos datos subjetivos." runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:TextBox ID="TDatosSubjetivos" runat="server" Height="120px" 
                        TextMode="MultiLine" Width="99%"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="4" width="100%"><asp:GridView ID="GAntecedentes" runat="server" AutoGenerateColumns="False" Width="100%" 
                DataKeyNames="id, antecedente" DataSourceID="SAntecendentes" EmptyDataText="No se encontraron antecendentes">
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
                            <asp:RequiredFieldValidator ControlToValidate="TObservaciones" ErrorMessage="Por favor ingrese una observación." runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
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
            <asp:SqlDataSource ID="SAntecendentes" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre
                                ,antecedentes_evolucion.id AS antecedente
                                ,IFNULL(antecedentes_evolucion.estado,antecedentes_paciente.estado) AS estado
                                ,IFNULL(antecedentes_evolucion.observaciones,antecedentes_paciente.observaciones) AS observaciones
                                FROM varios 
                                LEFT JOIN antecedentes_evolucion ON (antecedentes_evolucion.evolucion_paciente=@idingreso AND antecedentes_evolucion.motivo=varios.id) 
                                LEFT JOIN antecedentes_paciente ON (antecedentes_paciente.paciente=@paciente AND antecedentes_paciente.motivo=varios.id)
                                WHERE varios.tipo=2 AND varios.szReservado IS NULL
                                ;" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdEvolucion" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                    <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
                </SelectParameters>
            </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td colspan="4" width="100%">
                <asp:GridView ID="GExamenFisico" runat="server" AutoGenerateColumns="False" Width="100%"
                DataKeyNames="id, examen" DataSourceID="SExamenFisico" EmptyDataText="No se realizaron examenes físicos">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Columns>
                <asp:TemplateField HeaderText="Examen físico">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LNombre" Text='<%# Eval("nombre").ToString() %>'></asp:Label>
                        <asp:RequiredFieldValidator ControlToValidate="TObservaciones" ErrorMessage="Por favor ingrese una observación." runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    </ItemTemplate>
                </asp:TemplateField>
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
                <asp:TemplateField HeaderText="Observaciones" ItemStyle-Width="100%">
                    <ItemTemplate>
                        <asp:TextBox runat="server" ID="TObservaciones" Text='<%# Eval("observaciones") %>' Width="99%"></asp:TextBox>
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
                <td colspan="4" width="100%"><asp:GridView ID="GRiesgos" runat="server" AutoGenerateColumns="False" Width="100%" 
                DataKeyNames="id,antecedente" DataSourceID="SRiesgos" EmptyDataText="No se encontraron riesgos">
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
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="TObservaciones" ErrorMessage="Por favor ingrese una observación." runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
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
                                ,evolucion_riesgos.id AS antecedente
                                ,IFNULL(IFNULL(evolucion_riesgos.estado,antigua.estado),ingreso_riesgos.estado) AS estado
                                ,IFNULL(IFNULL(evolucion_riesgos.observaciones,antigua.observaciones),ingreso_riesgos.observaciones) AS observaciones
                                FROM varios 
                                LEFT JOIN evolucion_riesgos ON (evolucion_riesgos.evolucion_paciente=@idingreso AND evolucion_riesgos.motivo=varios.id) 
                                LEFT JOIN ingreso_paciente ON (ingreso_paciente.paciente=@paciente)
                                LEFT JOIN ingreso_riesgos ON (ingreso_riesgos.ingreso_paciente=ingreso_paciente.id AND ingreso_riesgos.motivo=varios.id)
                                LEFT JOIN (
SELECT estado,observaciones,evolucion_riesgos.motivo FROM evolucion_paciente LEFT JOIN evolucion_riesgos ON (evolucion_riesgos.evolucion_paciente=evolucion_paciente.id) WHERE
evolucion_paciente.paciente=@paciente AND evolucion_paciente.id=(SELECT MAX(id) FROM evolucion_paciente WHERE paciente=@paciente)
                                ) AS antigua ON (antigua.motivo=varios.id)
                                WHERE varios.tipo=38 AND varios.szReservado IS NULL
                                ;" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdEvolucion" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                    <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
                </SelectParameters>
            </asp:SqlDataSource></td>
            </tr>
            <asp:PlaceHolder runat="server" ID="PCIE10">
                <tr>
                    <td colspan="4" class="celdaTitulo">Código de diagnóstico</td>
                </tr>
                <tr>
                    <td colspan="4">
                        <asp:GridView ID="GCDiagnostico" runat="server" DataSourceID="SCDiagnostico" Width="100%"
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
                                <asp:BoundField DataField="descripcion" HeaderText="Descripción" ItemStyle-Width="100%" />
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
                  <td colspan="3" nowrap="nowrap"><asp:TextBox runat="server" Width="90%" ID="TCIE10"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="TCIE10" ValidationGroup="cie10" ErrorMessage="Por favor ingrese un CIE10." ID="RequiredFieldValidator14" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    <asp:Button ID="BMasCDiagnostico" runat="server" OnClick="BMasCDiagnostico_Click" Text="+" ValidationGroup="cie10" /></td>
                </tr>
            </asp:PlaceHolder>
            <tr>
                <td colspan="4">Analisis<asp:RequiredFieldValidator ControlToValidate="TAnalisis" ErrorMessage="Por favor ingrese un análisis." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td colspan="4"><asp:TextBox ID="TAnalisis" runat="server" Height="200px" TextMode="MultiLine" Width="99%"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="GridHeader">Plan educativo</td>
            </tr>
            <tr>
                <td colspan="4" width="100%" class="tda">
                <asp:DataList runat="server" ID="RPlanEducativo" RepeatColumns="2" DataKeyField="antecedente" DataSourceID="SPlanEducativo">
                    <ItemStyle CssClass="GridRow" />
                    <AlternatingItemStyle CssClass="GridAltRow" />
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="HId" Value='<%# Eval("id") %>' />
                        <asp:CheckBox ID="CSi" runat="server" Checked='<%# Eval("estado").ToString()=="1" ? true : false %>' Text='<%# Eval("nombre") %>' />
                    </ItemTemplate>
                </asp:DataList>
            <asp:SqlDataSource ID="SPlanEducativo" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre
                                ,evolucion_plan_educativo.id AS antecedente
                                ,evolucion_plan_educativo.estado
                                FROM varios 
                                LEFT JOIN evolucion_plan_educativo ON (evolucion_plan_educativo.evolucion_paciente=@idingreso AND evolucion_plan_educativo.motivo=varios.id) 
                                WHERE varios.tipo=39 AND varios.szReservado IS NULL
                                ;" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdEvolucion" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td colspan="4">Plan de manejo (Tomado de orden médica)</td>
            </tr>
            <tr>
                <td colspan="4"><asp:TextBox ID="TPlanManejo" ReadOnly="true" runat="server" Height="200px" TextMode="MultiLine" Width="99%" CssClass="hide"></asp:TextBox>
                <textarea id="elm1" name="elm1" style="width: 99%; height: 200px;" rows="2" cols="20"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="right">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" />
                <asp:Button Text="Eliminar" runat="server" ID="BEliminar" Visible="false" OnClientClick="confirm('¿Esta seguro de eliminar esta hoja de evolución?')" 
                        CausesValidation="false" onclick="BEliminar_Click" />
                </td>
            </tr>
        </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

