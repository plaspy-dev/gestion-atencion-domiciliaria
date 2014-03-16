<%@ Page Title="Paciente" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="paciente.aspx.cs" Inherits="seguimiento_paciente" %>
<%@ Register src="autorizaciones.ascx" tagname="autorizaciones" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript" src="../webcam/jquery.webcam.js"></script>
    <script type="text/javascript">
        $(function() {
            $("#<%= TObservaciones.ClientID %>").attr("tabindex", "-1");
            $("#<%= PReactivar.ClientID %>").accordion({
                autoHeight: false,
                collapsible: true,
                active: false
            });

            $("#<%= TPApellido.ClientID %>,#<%= TPNombre.ClientID %>,#<%= TDocumento.ClientID %>").autocomplete({
                source: function(request, response) {
                    $.ajax({
                        url: "../webservices/servicios.asmx/GetPacienteI",
                        data: "{ 'q': '" + request.term + "', 'e': '<%= ViewState["entidades"].ToString() %>' }",
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
                    $.goURL("pid=" + ui.item.value);
                    return false;
                }
            });
            $("#<%= TDocumento.ClientID %>").change(function() {
                if($("#<%= HId.ClientID %>").val().length!=0)
                    $.goURL("doc=" + $(this).val() + "&tdoc=" + $("#<%= DDocumento.ClientID %>").val());
            });

            $("#<%= TCIE1.ClientID %>,#<%= TCIE2.ClientID %>,#<%= TCIE3.ClientID %>").autocomplete({
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

            function calcularEdad() {
                var fecha = $("#<%= TNacimiento.ClientID %>").datepicker("getDate");
                if (fecha) {
                    var currentTime = new Date();
                    var diff_date = currentTime - fecha;
                    var num_years = diff_date / 31536000000;
                    $("#<%= LEdad.ClientID %>").html(Math.floor(num_years) + " años");
                } else {
                    $("#<%= LEdad.ClientID %>").html("");
                }
            }

            $('#<%= TNacimiento.ClientID %>').change(calcularEdad).datepicker({
                onClose: function(dateText, inst) {
                    calcularEdad();
                },
                changeMonth: true,
                changeYear: true
            });
            calcularEdad();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <div id="imprimir">
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" DisplayMode="List" />
    <table style="border-collapse: collapse;">
        <tr>
            <td colspan="4" style="text-align: center" class="celdaTitulo" >
                <asp:Label ID="Label32" runat="server" SkinID="lblsubTitulo" 
                    Text="Información personal"></asp:Label>
            </td>
            <td rowspan="25">    
             </td>
            <td class="celdaTitulo" style="width: 150px;">
                <asp:Label ID="Label33" runat="server" SkinID="lblsubTitulo" Text="Autorizaciones vigentes" Width="120px"></asp:Label>
            </td>
        </tr>
        <tr>
            <td rowspan="4" class="tdl">
                <asp:ImageButton runat="server" ID="IFoto" CausesValidation="false" />
                <br />
                <asp:FileUpload runat="server" ID="FFoto" Width="100px" />
                <asp:ImageButton runat="server" ID="IEliminar" ImageUrl="~/imgs/eliminar.gif" 
                    onclick="IEliminar_Click" />
                    <asp:CustomValidator Display="Dynamic" ControlToValidate="FFoto" ID="CustomValidator1" runat="server" ClientValidationFunction="ValidateFileUploadJPG" ErrorMessage="Por favor seleccione una imagen en formato jpg" onservervalidate="OnValidaFileJPG">*</asp:CustomValidator>
            </td>
            <td rowspan="4">
                Tipo Documento
                <br />
                <asp:DropDownList ID="DDocumento" runat="server" 
                                DataSourceID="SDocumento" DataTextField="tdocDescripcion" 
                                DataValueField="tdocId">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SDocumento" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT tdocId, tdocDescripcion FROM tipo_documento">
                </asp:SqlDataSource>
                <br />
                <br />
                Documento
                <asp:TextBox runat="server" ID="TDocumento"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TDocumento" ErrorMessage="Por favor ingrese un documento." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td>Primer Apellido</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TPApellido"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TPApellido" ErrorMessage="Por favor ingrese un apellido." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td rowspan="28" valign="top" class="tda">
                <uc1:autorizaciones ID="UCAutorizaciones" runat="server" />
                <br />
                <br />
                <hr />
                Observaciones Adicionales
                <br />
                <asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="98%" Height="172px"></asp:TextBox>
            </td>
         </tr>
        <tr>
            <td>Segundo Apellido</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TSApellido" Width="280px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Primer Nombre</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TPNombre" Width="280px"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TPNombre" ErrorMessage="Por favor ingrese un nombre." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>Segundo Nombre</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TSNombre" Width="280px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tdl">Sexo</td>
            <td>
                <asp:DropDownList ID="DSexo" runat="server">
                    <asp:ListItem Text="F" Value="1"></asp:ListItem>
                    <asp:ListItem Text="M" Value="2"></asp:ListItem>
                    </asp:DropDownList>
            </td>
            <td>Fecha Nacimiento</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TNacimiento" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TNacimiento" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator3" runat="server" Display="Dynamic">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TNacimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1900" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                <asp:Label ID="LEdad" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="tdl">Dirección</td>
            <td><asp:TextBox runat="server" ID="TDireccion"></asp:TextBox></td>
            <td>Barrio</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TBarrio"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tdl">Teléfono</td>
            <td>
                <asp:TextBox runat="server" ID="TTelefono"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TTelefono" ErrorMessage="Por favor ingrese un teléfono." ID="RequiredFieldValidator8" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td>Teléfono1</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TTelefono1"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tdl">Celular</td>
            <td><asp:TextBox runat="server" ID="TMovil"></asp:TextBox></td>
            <td>Correo</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TEMail"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                                ErrorMessage="Por favor ingrese un correo electrónico valido." 
                                SetFocusOnError="True" ControlToValidate="TEMail" Display="Dynamic" Text="*" 
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="tdl">Especificaciones de llegada</td>
            <td colspan="3" class="tdr">
                <asp:TextBox runat="server" ID="TLlegada" TextMode="MultiLine" Width="98%"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tdl">Localidad</td>
            <td>
                <asp:DropDownList ID="DLocalidad" runat="server" 
                                DataSourceID="SLocalidad" DataTextField="nombre"
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SLocalidad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT locId id, locDescripcion nombre FROM localidad">
                </asp:SqlDataSource>
            </td>
            <td>Estrato</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TEstrato" MaxLength="1" CssClass="entero" Width="25px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td  class="tdl">Familiar Responsable</td>
            <td>
                <asp:TextBox runat="server" ID="TFResponsable"></asp:TextBox>
            </td>
            <td>Parentesco</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TParentesco"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td  class="tdl">Pago directo</td>
            <td>
                <asp:DropDownList ID="DPago" runat="server" 
                                DataSourceID="SPago" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SPago" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT pdirId id,pdirDescripcion nombre FROM paciente_tipo_pago WHERE pdirActivo=1">
                </asp:SqlDataSource>
            </td>
            <td>Carné</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TCarnet"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tdl">Zona</td>
            <td>
                <asp:TextBox runat="server" ID="TZona"></asp:TextBox>
            </td>
            <td>&nbsp;</td>
            <td class="tdr">
                <asp:CheckBox runat="server" ID="CSuministros" Text="Entregar Suministros" />
            </td>
        </tr>
        <tr>
            <td class="celdaTitulo" colspan="4">
                <asp:Label ID="Label35" runat="server" SkinID="lblsubTitulo" 
                    Text="Información Asegurador"></asp:Label>
            </td>
        </tr>
        <tr>
            <td  class="tdl">Asegurador</td>
            <td>
                <asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource>
            </td>
            <td>Médico de cabecera</td>
            <td class="tdr">
                <asp:DropDownList ID="DMedico" runat="server" 
                                DataSourceID="SMedico" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SMedico" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT perId id,perNombre nombre FROM recurso_humano WHERE eEstId=1 and carId=6 ORDER BY perNombre">
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr id="trDatosAsegurador">
            <td class="tdl">Fecha de Ingreso al asegurador</td>
            <td>
                <asp:TextBox runat="server" ID="TFechaIngresoAsegurador" CssClass="fecha"></asp:TextBox>
                <asp:RangeValidator ControlToValidate="TFechaIngresoAsegurador" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td>Grado</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TGrado"></asp:TextBox>
            </td>
        </tr>
        <tr ID="trDatosAsegurador">
            <td class="tdl">Tipo de afiliado</td>
            <td>
                <asp:DropDownList ID="DTipoAfiliado" runat="server" AppendDataBoundItems="true">
                    <asp:ListItem Text="" Value=""></asp:ListItem>
                    <asp:ListItem Value="1" Text="Cotizante"></asp:ListItem>
                    <asp:ListItem Value="2" Text="Beneficiario"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>Categoría</td>
            <td class="tdr"><asp:DropDownList ID="DCategoria" runat="server" 
                                DataSourceID="SCategoria" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCategoria" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id,nombre FROM varios WHERE tipo=13 AND szReservado IS NULL">
                </asp:SqlDataSource>
                </td>
        </tr>
        <tr>
            <td class="celdaTitulo" colspan="4">
                <asp:Label ID="Label36" runat="server" SkinID="lblsubTitulo" 
                    Text="Información Médica"></asp:Label>
            </td>
        </tr>
        <tr>
            <td  class="tdl">Tipo de Evento</td>
            <td>
                <asp:DropDownList ID="DTipoEvento" runat="server" 
                                DataSourceID="STipoEvento" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="STipoEvento" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT tipECod id,tipEDescripcion nombre FROM tipo_evento WHERE tipEActivo=1">
                </asp:SqlDataSource>
            </td>
            <td>Ingreso al Programa</td>
            <td class="tdr">
                <asp:TextBox CssClass="fecha" runat="server" ID="TFechaIngreso"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFechaIngreso" ErrorMessage="Por favor ingrese una fecha de ingreso." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFechaIngreso" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator2" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="tdl">Estado</td>
            <td>
                <asp:DropDownList ID="DEstado" runat="server" 
                                DataSourceID="SEstado" DataTextField="nombre" 
                                DataValueField="id" Enabled="false">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstado" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT estId id,estDesc nombre FROM paciente_estado">
                </asp:SqlDataSource>
            </td>
            <td>Numero ETB</td>
            <td class="tdr">
                <asp:TextBox runat="server" ID="TNumeroETB" CssClass="entero"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tdl">Intensidad Terapias</td>
            <td>
                <asp:TextBox runat="server" ID="TIntensidadTerapias"></asp:TextBox>
            </td>
            <td>&nbsp;</td>
            <td class="tdr">&nbsp;</td>
        </tr>
        <tr>
            <td class="tdl">&nbsp;</td>
            <td>
                <asp:CheckBox ID="CDiabetico" runat="server" Text="Diabético" />
            </td>
            <td>&nbsp;</td>
            <td class="tdr">&nbsp;</td>
        </tr>
        <tr>
            <td class="tdl">CIE 10</td>
            <td colspan="3" class="tdr">
                <asp:TextBox runat="server" Width="98%" ID="TCIE1"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tdl">CIE 10_1</td>
            <td colspan="3" class="tdr">
                <asp:TextBox runat="server" Width="98%" ID="TCIE2"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tdl tdb">CIE 10_2</td>
            <td colspan="3" class="tdb tdr">
                <asp:TextBox runat="server" Width="98%" ID="TCIE3"></asp:TextBox>
            </td>
        </tr>
    </table>
    </div>
    <asp:Panel runat="server" ID="PReactivar">
        <h3><a href="#">Programación próxima</a></h3>
        <div>
            <asp:GridView ID="GProgramacion" runat="server" AutoGenerateColumns="False" DataSourceID="SProgramacion" EmptyDataText="No se encontraron programaciones" onrowdatabound="GProgramacion_RowDataBound" Width="100%">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha" SortExpression="prgFechaProg" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="perNombre" HeaderText="Profesional" SortExpression="perNombre" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="nombre" HeaderText="Actividad" SortExpression="nombre" ItemStyle-Width="100%" />
                    <asp:BoundField DataField="autNumero" HeaderText="Autorización" SortExpression="autNumero" />
                    <asp:BoundField DataField="actId" HeaderText="ActividadId" SortExpression="actId" ItemStyle-CssClass="hide" HeaderStyle-CssClass="hide" />
                </Columns>
            </asp:GridView>
                <asp:SqlDataSource ID="SProgramacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT  pr.prgFechaProg, 
		                    medicamentos.nombre, 
		                    autNumero,
		                    recurso_humano.perNombre,
		                    pr.actId
                            FROM programacion pr
		                    LEFT JOIN paciente on pr.pacId = paciente.pacId
		                    LEFT JOIN medicamentos ON pr.actId = medicamentos.id
		                    LEFT JOIN recurso_humano ON pr.perId = recurso_humano.perId
	                    WHERE pr.pacId=@pacId
	                          AND pr.prgActivo=1
                              AND pr.prgFechaProg >= SYSDATE()
                    order by prgFechaProg desc,medicamentos.nombre">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HId" PropertyName="Value" DefaultValue="0" Name="pacId" />
                      </SelectParameters>
                </asp:SqlDataSource>
        </div>
        <h3><a href="#">Ver Auditoría de Servicios</a></h3>
        <div>
            <asp:GridView ID="GAuditoria" runat="server" AutoGenerateColumns="False" DataSourceID="SAuditoria" EmptyDataText="No se encontro auditoría" Width="100%">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="audFecha" HeaderText="Fecha" SortExpression="audFecha" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="audUsuario" HeaderText="Usuario" SortExpression="audUsuario" />
                    <asp:CheckBoxField DataField="audIngreso" HeaderText="Ingreso" SortExpression="audIngreso" />
                    <asp:CheckBoxField DataField="audEgreso" HeaderText="Egreso" SortExpression="audEgreso" />
                    <asp:BoundField DataField="cingDescripcion" HeaderText="Causa Ing" SortExpression="cingDescripcion" />
                    <asp:BoundField DataField="cegDescripcion" HeaderText="Causa Egr" SortExpression="cegDescripcion" />
                    <asp:BoundField DataField="audObs" HeaderText="Obs" SortExpression="audObs" ItemStyle-Width="100%" />
                </Columns>
            </asp:GridView>
                <asp:SqlDataSource ID="SAuditoria" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT audIngreso
	                      ,audEgreso
                          ,audUsuario
                          ,audFecha
                          ,cingDescripcion,
                          cegDescripcion,
                          audObs
                      FROM paciente_auditoria_servicios
	                    left join causa_reingreso on paciente_auditoria_servicios.cingId = causa_reingreso.cingId
	                    left join causa_egreso on paciente_auditoria_servicios.cegId = causa_egreso.cegId
                      where  pacId=@pacId
                      order by audFecha desc,segFechaIngreso desc">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HId" PropertyName="Value" DefaultValue="0" Name="pacId" />
                      </SelectParameters>
                </asp:SqlDataSource>
        </div>
        <h3><a href="#"><asp:Label runat="server" ID="LReactivar" Text="Reactivar"></asp:Label></a></h3>
        <div>
            <table width="100%">
                <tr>
                    <td>Fecha</td>
                    <td>Motivo</td>
                    <td>Observaciones</td>
                </tr>
                <tr>
                <td width="1" nowrap="nowrap" valign="top"><asp:TextBox CssClass="fecha" runat="server" ID="TFechaRetiro"></asp:TextBox></td>
                <td width="1" nowrap="nowrap" valign="top"><asp:DropDownList ID="DMotivo" runat="server" 
                                DataSourceID="SMotivo" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                        <asp:SqlDataSource ID="SMotivo" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT cingId id,cingDescripcion nombre FROM causa_reingreso ORDER BY 2">
                        </asp:SqlDataSource>
                    </td>
                <td><asp:TextBox runat="server" ID="TObservacionesRetiro" Width="100%" TextMode="MultiLine"></asp:TextBox></td>
                <tr><td colspan="3" style="text-align: right">
                    <asp:RequiredFieldValidator ValidationGroup="Reingreso" ControlToValidate="DMotivo" ErrorMessage="Por favor seleccione un motivo." ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    <asp:RangeValidator ValidationGroup="Reingreso" ControlToValidate="TFechaRetiro" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator4" Display="Dynamic" Type="Date"></asp:RangeValidator>
                    <asp:RequiredFieldValidator ValidationGroup="Reingreso" ControlToValidate="TFechaRetiro" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator6" runat="server" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:Button ValidationGroup="Reingreso" ID="BRetiro" runat="server" 
                        Text="Reactivar" onclick="BRetiro_Click" />
                    </td></tr>
                </table>
        </div>
        <h3><a href="#">Defunción</a></h3>
        <div>
            <table width="100%">
                <tr>
                    <td></td>
                    <td>Fecha</td>
                    <td>Observaciones</td>
                </tr>
                <tr>
                    <td width="1" nowrap="nowrap" valign="top"><asp:CheckBox ID="CExpedidaOrganizationExample15" runat="server" Text="Expedida por OrganizationExample15" /></td>
                    <td width="1" nowrap="nowrap" valign="top"><asp:TextBox CssClass="fecha" runat="server" ID="TFechaDefuncion"></asp:TextBox></td>
                    <td><asp:TextBox runat="server" ID="TObservacionesDefuncion" TextMode="MultiLine" Width="98%"></asp:TextBox></td>
                </tr>
                <tr><td colspan="3" style="text-align: right">
                    <asp:RangeValidator ValidationGroup="defuncion" ControlToValidate="TFechaDefuncion" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator5" Display="Dynamic" Type="Date"></asp:RangeValidator>
                    <asp:RequiredFieldValidator ValidationGroup="defuncion" ControlToValidate="TFechaDefuncion" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator9" runat="server" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:Button ValidationGroup="defuncion" ID="BAceptarDefuncion" runat="server" Text="Aceptar" onclick="BAceptarDefuncion_Click" />
                    </td></tr>
                </table>
        </div>
    </asp:Panel>
    <br />
    <div style="text-align: right">
        <asp:HiddenField ID="HId" runat="server" />
        <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
            onclick="BAceptar_Click" /><asp:Button ID="BCancelar"
            runat="server" Text="Cancelar" CausesValidation="false" 
            onclick="BCancelar_Click" /></div>
</asp:Content>