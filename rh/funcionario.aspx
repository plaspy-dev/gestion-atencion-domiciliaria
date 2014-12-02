<%@ Page Title="Personal" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="funcionario.aspx.cs" Inherits="rh_funcionario" %>
<%@ Register src="~/webcam/webcam.ascx" tagname="webcam" tagprefix="webcam" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        var webfoto = "#<%= IFoto.ClientID %>";
        $(function() {
            var dates = $("#<%= TDesde.ClientID %>, #<%= THasta.ClientID %>").datepicker({
                onSelect: function(selectedDate) {
                    var option = this.id == "<%= TDesde.ClientID %>" ? "minDate" : "maxDate",
					    instance = $(this).data("datepicker"),
					    date = $.datepicker.parseDate(
						    instance.settings.dateFormat ||
						    $.datepicker._defaults.dateFormat,
						    selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
            $("#tabpersonal").tabs({
                cookie: {
                    name: 'tabpersonal',
                    expires: 1
                }
            });
            $("#<%= TApellidos.ClientID %>,#<%= TNombres.ClientID %>,#<%= TDocumento.ClientID %>").autocomplete({
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
                    $.goURL("fid=" + ui.item.value);
                    return false;
                }
            });
            $("#<%= DTipoContrato.ClientID %>").change(function() {
                var texto;
                if ($("#<%= DTipoContrato.ClientID %>").val() == "1")
                    texto = "VACACIONES";
                else texto = "LICENCIA TEMPORAL";

                $("#<%= DEstado.ClientID %> option").each(function() {
                    if ($(this).text() == "VACACIONES" || $(this).text() == "LICENCIA TEMPORAL") {
                        $(this).text(texto);
                    }
                });
            }).change();
            var estadoiniciado = false;

            $("#<%= DEstado.ClientID %>").change(function() {

                if ($(this).children("option:selected").text() == "VACACIONES" || $(this).children("option:selected").text() == "LICENCIA TEMPORAL") {
                    $("#tdDescanso").show().text($(this).children("option:selected").text());
                    $(".descanso").show();
                } else {
                    $("#tdDescanso").hide();
                    $(".descanso").hide();
                    if (estadoiniciado) {
                        if (confirm('Se ha modificado el estado, ¿desea guardar?'))
                            $("#<%= BAceptar.ClientID %>").click();
                    }
                }
                estadoiniciado = true;
            }).change();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
        <asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" DisplayMode="List" />
        <div id="tabpersonal" style="min-width: 750px">
            <ul>
                <li><a href="#tabs1">Datos Personales</a></li>
                <li><a href="#tabs2">Detalles de Contrato</a></li>
                <li><a href="#tabs3">Info Profesional</a></li>
                <li><a href="#tabs4">Info Laboral</a></li>
                <li><a href="#tabs5">Sesiones programadas</a></li>
            </ul>
            <div id="tabs1" class="hide">
                <table>
                    <tr>
                        <td>
                            Apellidos</td>
                        <td>
                            <asp:TextBox ID="TApellidos" runat="server" ></asp:TextBox>
                            <asp:RequiredFieldValidator ControlToValidate="TApellidos" ErrorMessage="Por favor ingrese un apellido." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        </td>
                        <td>
                            Nombres</td>
                        <td>
                            <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ControlToValidate="TNombres" ErrorMessage="Por favor ingrese un nombre." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        </td>
                        <td rowspan="15" valign="top">
                            <asp:ImageButton runat="server" ID="IFoto" CausesValidation="false" />
                            <br />
                            <webcam:webcam runat="server" ID="WebCam" />
                            <br />
                            <asp:FileUpload runat="server" ID="FFoto" Width="100px" />
                            <asp:ImageButton runat="server" ID="IEliminar" ImageUrl="~/imgs/eliminar.gif" 
                                onclick="IEliminar_Click" />
                                <asp:CustomValidator Display="Dynamic" ControlToValidate="FFoto" ID="CustomValidator1" runat="server" ClientValidationFunction="ValidateFileUploadJPG" ErrorMessage="Por favor seleccione una imagen en formato jpg" onservervalidate="OnValidaFileJPG">*</asp:CustomValidator>
                            <br />
                            <asp:Label ID="Label40" runat="server" Text="Observaciones"></asp:Label>
                            <br />
                            <asp:TextBox ID="TObservaciones" TextMode="MultiLine" runat="server" Width="100px" Height="100px"></asp:TextBox>
                        </td>                        
                    </tr>
                    <tr><td>
                    Fecha de Ingreso</td>
                    <td>
                        <asp:TextBox ID="TFIngreso" CssClass="fecha" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="TFIngreso" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        <asp:RangeValidator MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" runat="server" ErrorMessage="Por favor ingrese una fecha valida." Display="Dynamic" ControlToValidate="TFIngreso" Type="Date">*</asp:RangeValidator>
                    </td>
                    </tr>
                    <tr>
                        <td>
                            Documento</td>
                        <td>
                            <asp:TextBox ID="TDocumento" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ControlToValidate="TDocumento" ErrorMessage="Por favor ingrese un documento." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                                ErrorMessage="Por favor ingrese un numero valido." Display="Dynamic" 
                                SetFocusOnError="true" ControlToValidate="TDocumento" 
                                ValidationExpression="[0-9]{0,20}">*</asp:RegularExpressionValidator>
                        </td>
                        <td>
                           Lugar Expedición</td>
                        <td>
                            <asp:TextBox ID="TLExpedicion" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Libreta Militar</td>
                        <td>
                            <asp:TextBox ID="TLMilitar" runat="server" CssClass="entero"></asp:TextBox>
                        </td>
                        <td>
                            Distrito</td>
                        <td>
                            <asp:TextBox ID="TDMilitar" runat="server" CssClass="entero" Width="44px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            Pasado Judicial Num.
                        </td>
                        <td>
                            <asp:TextBox ID="TPasadoJudicial" runat="server"></asp:TextBox>
                        </td>
                        <td>
                            Pasado Judicial</td>
                        <td>
                            <asp:TextBox ID="TFPasadoJudicial" runat="server" CssClass="fecha"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:CheckBox ID="CTarjetaProfesional" runat="server" Text="Tarjeta profesional" />
                        </td>
                        <td>
                            Num Tarjeta Prof.</td>
                        <td>
                            <asp:TextBox ID="TTarjetaNumero" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Grupo Sanguíneo</td>
                        <td>
                            <asp:TextBox ID="TGrupoSanguineo" runat="server" Width="38px"></asp:TextBox>
                        </td>
                        <td>
                            RH</td>
                        <td>
                            <asp:TextBox ID="TRH" runat="server" Width="38px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Género</td>
                        <td>
                            <asp:DropDownList ID="DSexo" runat="server">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                                <asp:ListItem Text="F" Value="1"></asp:ListItem>
                                <asp:ListItem Text="M" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            Fecha Nacimiento</td>
                        <td>
                            <asp:TextBox ID="TFechaNacimiento" CssClass="fecha" runat="server"></asp:TextBox>
                            <asp:RangeValidator MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" runat="server" ErrorMessage="Por favor ingrese una fecha valida." Display="Dynamic" ControlToValidate="TFechaNacimiento" Type="Date">*</asp:RangeValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Dirección</td>
                        <td>
                            <asp:TextBox ID="TDireccion" runat="server"></asp:TextBox>
                        </td>
                        <td>
                            Barrio</td>
                        <td colspan="2">
                            <asp:TextBox ID="TBarrio" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                        <td>
                            Localidad</td>
                        <td colspan="2">
                            <asp:DropDownList ID="DLocalidadVivienda" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SLocalidad" DataTextField="nombre" DataValueField="id">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>
                            Teléfono</td>
                        <td>
                            <asp:TextBox runat="server" ID="TTelefono"></asp:TextBox>
                        </td>
                        <td>
                            Teléfono1</td>
                        <td>
                            <asp:TextBox runat="server" ID="TTelefono2"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Celular</td>
                        <td>
                            <asp:TextBox runat="server" ID="TMovil" ></asp:TextBox>
                            <asp:RequiredFieldValidator ControlToValidate="TMovil" ErrorMessage="Por favor ingrese un teléfono movil." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        </td>
                        <td>
                            Correo electrónico</td>
                        <td>
                            <asp:TextBox runat="server" ID="TEMail"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                                ErrorMessage="Por favor ingrese un correo electrónico valido." 
                                SetFocusOnError="True" ControlToValidate="TEMail" Display="Dynamic" Text="*" 
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Estado Civil</td>
                        <td>
                            <asp:DropDownList ID="DEstadoCivil" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SEstadoCivil" DataTextField="nombre" DataValueField="id">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SEstadoCivil" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT estCivilId id, estCivDescripcion nombre,estCivCompanero companero FROM estado_civil">
                            </asp:SqlDataSource>
                            <asp:Label ID="Label21" runat="server" Text="Num. Hijos"></asp:Label>
                            <asp:TextBox runat="server" ID="THijos" CssClass="entero" Width="30px" MaxLength="2"></asp:TextBox>
                            <script type="text/javascript">
                                $(function () {
                                    var com = new Array();
                                    <asp:Repeater ID="RCompañero" runat="server" DataSourceID="SEstadoCivil">
                                        <ItemTemplate>com[<%# Eval("id") %>]='<%# Eval("companero") %>';</ItemTemplate>
                                    </asp:Repeater>
                                    $("#<%= DEstadoCivil.ClientID %>").change(function() {
                                        var temp= com[$(this).val()];
                                        if(temp==null || temp.length==0)
                                            temp="Cónyugue";
                                        $("#<%= LConyugue.ClientID %>").text(temp);
                                    }).keypress(function() { $(this).change(); }).change();
                                });
                            </script>
                        </td>
                        <td>
                            Nombre <asp:Label ID="LConyugue" runat="server" Text=""></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="TConyuge"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Persona Contacto</td>
                        <td>
                            <asp:TextBox runat="server" ID="TContacto"></asp:TextBox>
                        </td>
                        <td nowrap="nowrap">
                            Tel Persona Contacto
                        </td>
                        <td colspan="2">
                            <asp:TextBox runat="server" ID="TTelefonoContacto"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Parentesco contacto</td>
                        <td>
                            <asp:TextBox ID="TParentesco" runat="server"></asp:TextBox>
                        </td>
                        <td>
                            &nbsp;</td>
                        <td colspan="2">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            EPS</td>
                        <td>
                            <asp:DropDownList ID="DEPS" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SEPS" DataTextField="nombre" DataValueField="id">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SEPS" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                            </asp:SqlDataSource>
                        </td>
                        <td>
                            FOP
                        </td>
                        <td>
                            <asp:DropDownList ID="DFOP" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SFOP" DataTextField="nombre" DataValueField="id">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SFOP" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entAFP=1 ORDER BY 2">
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            ARP</td>
                        <td>
                            <asp:DropDownList ID="DARP" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SARP" DataTextField="nombre" DataValueField="id">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SARP" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entARP=1 ORDER BY 2">
                            </asp:SqlDataSource>
                            </td>
                        <td>Localidad Trabajo
                            </td>
                        <td>
                            <asp:DropDownList ID="DLocalidad" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SLocalidad" DataTextField="nombre" DataValueField="id">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SLocalidad" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT locId id, locDescripcion nombre FROM localidad">
                            </asp:SqlDataSource>
                            </td>
                    </tr>
                </table>
            </div>
            <div id="tabs2" class="hide">
                <table>
                    <tr><td colspan="4">
                        <asp:CheckBox runat="server" ID="CPazySalvo" Text="Paz y Salvo?" />
                    </td></tr>
                    <tr><td>Estado</td><td>
                            <asp:DropDownList ID="DEstado" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SEstado" DataTextField="nombre" DataValueField="id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SEstado" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT eEstId id,eEstDesc nombre FROM funcionario_estados">
                            </asp:SqlDataSource>
                        </td><td>Cargo</td><td>
                            <asp:DropDownList ID="DCargo" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SCargo" DataTextField="nombre" DataValueField="id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SCargo" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT carId id,carDescripcion nombre FROM cargo ORDER BY 2">
                            </asp:SqlDataSource>
                        </td></tr>
                        <tr class="descanso">
                            <td colspan="4" class="celdaTitulo" id="tdDescanso">Descanso</td>
                        </tr>
                        <tr class="descanso">
                            <td>Inicio<asp:RangeValidator MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator5" runat="server" ErrorMessage="Por favor ingrese una fecha valida." Display="Dynamic" ControlToValidate="TInicioDescanso" Type="Date">*</asp:RangeValidator></td>
                            <td><asp:TextBox runat="server" ID="TInicioDescanso" CssClass="fecha"></asp:TextBox></td>
                            <td>Fin<asp:RangeValidator MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator6" runat="server" ErrorMessage="Por favor ingrese una fecha valida." Display="Dynamic" ControlToValidate="TFinDescanso" Type="Date">*</asp:RangeValidator></td>
                            <td><asp:TextBox runat="server" ID="TFinDescanso" CssClass="fecha"></asp:TextBox></td>
                        </tr>
                    <tr><td>Tipo Contrato</td><td>
                        <asp:DropDownList ID="DTipoContrato" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="STipoContrato" DataTextField="nombre" DataValueField="id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="STipoContrato" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT tipContId id,tipContDesc nombre FROM tipo_contrato ORDER BY 2">
                            </asp:SqlDataSource>
                        </td><td>Fecha Contrato</td><td>
                        <asp:TextBox ID="TFechaContrato" runat="server" CssClass="fecha"></asp:TextBox>
                        </td></tr>
                    <tr><td></td><td>
                        </td><td></td><td>
                        </td></tr>
                    <tr><td nowrap="nowrap">Área</td><td>
                        <asp:DropDownList ID="DArea" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SArea" DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SArea" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT areaId id,areaDesc nombre FROM area ORDER BY 2">
                        </asp:SqlDataSource>
                        </td><td>Disponibilidad</td><td>
                        <asp:DropDownList ID="DDisponibilidad" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SDisponibilidad" DataTextField="nombre" DataValueField="id">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SDisponibilidad" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT dispId id,dispDescripcion nombre FROM disponibilidad ORDER BY 2">
                        </asp:SqlDataSource>
                        </td></tr>
                    <tr><td>Nro Cuenta</td>
                    <td>
                    <asp:TextBox runat="server" ID="TCuenta"></asp:TextBox>
                                        </td>
                    <td>Banco</td><td>
                        <asp:DropDownList ID="DBanco" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SBanco" DataTextField="nombre" DataValueField="id">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SBanco" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT banId id,banDesc nombre FROM banco ORDER BY 2">
                        </asp:SqlDataSource>
                        </td></tr>
                    <tr><td nowrap="nowrap">Motivo Term. Contrato</td><td>
                        <asp:DropDownList ID="DTerminacion" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="STerminacion" DataTextField="nombre" DataValueField="id">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="STerminacion" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="select mteId id,mteDescripcion nombre from motivo_retiro ORDER BY 2">
                        </asp:SqlDataSource>
                        </td><td nowrap="nowrap">Terminación contrato</td><td>
                        <asp:TextBox runat="server" ID="TFechaTerminacion" CssClass="fecha"></asp:TextBox>
                        </td></tr>
                        <tr>
                            <td colspan="2">
                            <fieldset>
                                <legend>Documentos Entregados a Atención Domiciliaria</legend>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:DataList ID="DDocumentos" runat="server" RepeatColumns="2" DataSourceID="SDocumentos"
                                                ShowFooter="False" ShowHeader="False" DataKeyField="docId">                
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="CDocumentos" runat="server" Text='<%#bind("docDesc") %>' Checked='<%# Eval("sel").ToString()=="1" %>' />
                                                </ItemTemplate>
                                            </asp:DataList>
                                             <asp:SqlDataSource ID="SDocumentos" runat="server" 
                                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                                SelectCommand="SELECT funcionario_documentos.docId,
		                                            docDesc,
		                                            CASE WHEN recurso_humano_documento.docId IS NULL THEN 0 ELSE 1 END AS Sel		
		                                            FROM funcionario_documentos
			                                        LEFT JOIN  recurso_humano_documento ON recurso_humano_documento.docId = funcionario_documentos.docId AND perId = @perId
			                                        WHERE docTipoEntrega=1
	                                            ORDER BY 2">
	                                                <SelectParameters>
	                                                    <asp:ControlParameter ControlID="HId" PropertyName="Value" Name="perId" DefaultValue="0" />
	                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                </table>
                                </fieldset>
                            </td>
                            <td colspan="2" style="vertical-align:top;">
                                <fieldset>
                                <legend>Documentos Entregados al Contratista</legend>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:DataList ID="DDocumentosContratista" runat="server" RepeatColumns="2" DataSourceID="SDocumentosContratista"
                                                ShowFooter="False" ShowHeader="False" DataKeyField="docId">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="CDocumentos" runat="server" Text='<%#bind("docDesc") %>' Checked='<%# Eval("sel").ToString()=="1" %>' />
                                                </ItemTemplate>
                                            </asp:DataList>
                                            <asp:SqlDataSource ID="SDocumentosContratista" runat="server" 
                                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                                SelectCommand="SELECT funcionario_documentos.docId,
		                                            docDesc,
		                                            CASE WHEN recurso_humano_documento.docId IS NULL THEN 0 ELSE 1 END AS Sel
		                                            FROM funcionario_documentos
			                                        LEFT JOIN  recurso_humano_documento ON recurso_humano_documento.docId = funcionario_documentos.docId AND perId = @perId
			                                        WHERE docTipoEntrega=2
	                                            ORDER BY 2">
	                                                <SelectParameters>
	                                                    <asp:ControlParameter ControlID="HId" PropertyName="Value" Name="perId" DefaultValue="0" />
	                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                </table>
                                </fieldset>
                            </td>
                        </tr>
                    </table>
            </div>
            <div id="tabs3" class="hide">
                <table>
                    <tr>
                        <td width=1>Profesión</td>
                        <td width=1><asp:DropDownList ID="DProfesion" runat="server" AppendDataBoundItems="true" 
                                DataSourceID="SProfesion" DataTextField="nombre" DataValueField="id">
                                <asp:ListItem Selected="True" Text="" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SProfesion" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT profId id, profNombre nombre FROM profesion ORDER BY 2">
                            </asp:SqlDataSource></td>
                        <td width=1 nowrap="nowrap">Verificación de títulos<asp:RangeValidator ControlToValidate="TVerificacionTitulos" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator7" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
                        <td><asp:TextBox runat="server" ID="TVerificacionTitulos" CssClass="fecha"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:GridView ID="GInformacionProfesional" runat="server" AutoGenerateColumns="False" DataSourceID="SInformacionProfesional"
                                DataKeyNames="ipId">
                                <Columns>
                                    <asp:TemplateField HeaderText="Sel">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CEntregado" runat="server" Checked='<%#Eval("sel").ToString()=="1" %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ipDescripcion" HeaderText="Nivel Educativo" />
                                    <asp:TemplateField HeaderText="Profesión">
                                        <ItemTemplate>
                                           
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Año">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TAno" runat="server" MaxLength="4" CssClass="entero" Text='<%#bind("infAno")%>' Width="51px"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Institución">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TInstitucion" runat="server" MaxLength="100" Width="214px" Text='<%#bind("infInstitucion")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Nro Acta Grado">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TActa" runat="server" MaxLength="100" Width="214px" Text='<%#bind("infNroActa")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="SInformacionProfesional" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT funcionario_formacion.ipId,
		                            ipDescripcion,
		                            infAno,
		                            infInstitucion,
		                            profId,
		                            infNroActa,
		                            CASE WHEN recurso_humano_formacion.ipId IS NULL THEN 0 ELSE 1 END AS Sel
		                            FROM funcionario_formacion
			                        LEFT JOIN recurso_humano_formacion ON recurso_humano_formacion.ipId = funcionario_formacion.ipId AND perId = @perId">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="HId" PropertyName="Value" Name="perId" DefaultValue="0" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
                <fieldset>
                    <legend>Cursos realizados</legend>
                    <asp:GridView ID="GCursos" runat="server" AutoGenerateColumns="False" DataSourceID="SCursos" EmptyDataText="No se encontraron cursos" DataKeyNames="id">
                                    <RowStyle CssClass="GridRow"></RowStyle>
                                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                                    <Columns>
                                        <asp:BoundField DataField="nombre" HeaderText="Curso" ItemStyle-Width="100%" />
                                        <asp:TemplateField HeaderText="Vencimiento">
                                            <ItemTemplate>
                                                <asp:TextBox runat="server" ID="F" CssClass="fecha" Text='<%# string.Format("{0:d}", Eval("vencimiento")) %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                    <asp:SqlDataSource ID="SCursos" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                        SelectCommand="SELECT id, nombre, vencimiento
                                                    FROM varios 
                                                    LEFT JOIN recurso_humano_curso ON (recurso_humano_curso.funcionario=@perId AND recurso_humano_curso.curso=varios.id)
                                                    WHERE tipo=81 AND szReservado IS NULL 
                                                    ORDER BY nombre">
                                          <SelectParameters>
                                            <asp:ControlParameter ControlID="HId" PropertyName="Value" Name="perId" DefaultValue="0" />
                                          </SelectParameters>
                                    </asp:SqlDataSource>
                </fieldset>
            </div>
            <div id="tabs4" class="hide">
            <table>
                    <tr>
                        <td>
                            <asp:UpdatePanel ID="UEmpresa" runat="server">
                                <ContentTemplate>
                                    <asp:LinkButton ID="lnkAgInfoLab" CausesValidation="false" runat="server" onclick="lnkAgInfoLab_Click">Agregar Empresa</asp:LinkButton>
                                    <asp:GridView ID="GEmpresas" runat="server" 
                                        AutoGenerateColumns="False" 
                                        
                                        EmptyDataText="No hay información Laboral registrada, haga click en 'Agregar Empresa' para registrar una nueva empresa de la historia laboral" 
                                        onrowdeleting="GEmpresas_RowDeleting" >
                                        <Columns>
                                            <asp:TemplateField HeaderText="Empresa" ItemStyle-Wrap="false">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="TEmpresa" runat="server" MaxLength="25" Text='<%#bind("ilabEmpresa")%>' Width="240px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ControlToValidate="TEmpresa" ErrorMessage="Por favor ingrese un empresa." ID="RE" 
	                                                        runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Teléfono">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="TTelefono" runat="server" MaxLength="25" 
                                                        Text='<%#bind("ilabTelefono")%>' Width="120px"></asp:TextBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Jefe Inmediato">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="TJefe" runat="server" MaxLength="30" 
                                                        Text='<%#bind("ilabJefeInmediato")%>' Width="100px"></asp:TextBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Año">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="TAno" runat="server" MaxLength="4" CssClass="entero"
                                                        Text='<%#bind("ilabAno")%>' Width="45px"></asp:TextBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:CommandField DeleteText="Quitar" ShowDeleteButton="True" />
                                        </Columns>
                                    </asp:GridView>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                </table>
                <fieldset>
                    <legend>Empresas en las que labora actualmente</legend>
                    <asp:CheckBoxList runat="server" ID="CLaboraActualmente" DataTextField="nombre" DataValueField="id" DataSourceID="SLaboraActualemente" RepeatColumns="4">
                    </asp:CheckBoxList>
                    <asp:SqlDataSource ID="SLaboraActualemente" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT id,nombre FROM varios 
                            WHERE tipo=80 AND szReservado IS NULL ORDER BY nombre">
                    </asp:SqlDataSource>
                </fieldset>
            </div>
            <div id="tabs5" class="hide">
                <fieldset>
                    <legend>Fechas</legend>
                    <table>
                        <tr>
                            <td>Desde</td>
                            <td><asp:TextBox runat="server" CssClass="fecha" ID="TDesde"></asp:TextBox></td>
                            <td>Hasta</td>
                            <td><asp:TextBox runat="server" CssClass="fecha" ID="THasta"></asp:TextBox></td>
                            <td>
                                <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator2" Display="Dynamic" Type="Date" ValidationGroup="fechas">*</asp:RangeValidator>
                                <asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator4" Display="Dynamic" Type="Date" ValidationGroup="fechas">*</asp:RangeValidator>
                                <asp:Button ID="BFiltrar" runat="server" Text="Filtrar" ValidationGroup="fechas" />
                            </td>
                         </tr>
                    </table>
                </fieldset>
                <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Width="100%"
                    AutoGenerateColumns="False" EmptyDataText="No se encontraron sesiones" 
                    AllowPaging="True" PageSize="20" AllowSorting="True">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:BoundField HeaderText="Fecha" DataField="fecha" SortExpression="fecha" DataFormatString="{0:d}"/>
                        <asp:BoundField HeaderText="Paciente" DataField="nombre" SortExpression="nombre" ItemStyle-Wrap="false"/>
                        <asp:BoundField HeaderText="Actividad" DataField="act" SortExpression="act" ItemStyle-Width="100%"/>
                    </Columns>
                </asp:GridView>
                <div style="text-align: right;">
                    <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
                </div>
                <asp:SqlDataSource ID="SResultados" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT programacion.prgFechaProg fecha,
                            paciente.pacNombres AS nombre, 
                            medicamentos.nombre AS act,
                            programacion.actId
                            FROM programacion 
                            LEFT JOIN paciente ON (paciente.pacId=programacion.pacId) 
                            LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId)
                            WHERE programacion.perId=@perId 
                            AND (@desde=' ' OR programacion.prgFechaProg>=STR_TO_DATE(@desde, '%d/%m/%Y'))
                            AND (@hasta=' ' OR programacion.prgFechaProg<=STR_TO_DATE(@hasta, '%d/%m/%Y'))
                            ORDER BY programacion.prgFechaProg DESC">
                         <SelectParameters>
                            <asp:ControlParameter ControlID="HId" PropertyName="Value" Name="perId" DefaultValue="-1" />
                            <asp:ControlParameter ControlID="TDesde" PropertyName="Text" Name="desde" DefaultValue=" " />
                            <asp:ControlParameter ControlID="THasta" PropertyName="Text" Name="hasta" DefaultValue=" " />
                         </SelectParameters>
            </asp:SqlDataSource>
            </div>
        </div>
        <div style="text-align: right">
            <asp:HiddenField ID="HId" runat="server" />
            <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                onclick="BAceptar_Click" /><asp:Button ID="BCancelar" 
                CausesValidation="false" runat="server" Text="Cancelar" 
                onclick="BCancelar_Click" /></div>
</asp:Content>
