<%@ Page Title="Paciente" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="paciente.aspx.cs" Inherits="seguimiento_paciente" %>
<%@ Register src="autorizaciones.ascx" tagname="autorizaciones" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

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
                    url: "../webservices/servicios.asmx/GetPaciente",
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
                $.goURL("pid=" + ui.item.value);
                return false;
            }
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
    <table class="style1" cellpadding="0" cellspacing="0" border="1">
        <tr>
            <td colspan="4" style="text-align: center" class="celdaTitulo" >
                <asp:Label ID="Label32" runat="server" SkinID="lblsubTitulo" 
                    Text="Información personal"></asp:Label>
            </td>
            <td class="style2" rowspan="24">    
             </td>
            <td class="celdaTitulo" style="width: 150px;">
                <asp:Label ID="Label33" runat="server" SkinID="lblsubTitulo" Text="Autorizaciones vigentes" Width="120px"></asp:Label>
            </td>
        </tr>
        <tr>
            <td rowspan="4">
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
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT [tdocId], [tdocDescripcion] FROM [phdTipoDocumento]">
                </asp:SqlDataSource>
                <br />
                <br />
                Documento
                <asp:TextBox runat="server" ID="TDocumento"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TDocumento" ErrorMessage="Por favor ingrese un documento." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td >
                Primer Apellido
            </td>
            <td>
                <asp:TextBox runat="server" ID="TPApellido"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TPApellido" ErrorMessage="Por favor ingrese un apellido." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td rowspan="27" valign="top" class="style5">
                <uc1:autorizaciones ID="UCAutorizaciones" runat="server" />
                <br />
                <br />
                <hr />
                Observaciones Adicionales
                <br />
                <asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="171px" Height="172px"></asp:TextBox>
            </td>
         </tr>
        <tr>
            <td>
                Segundo Apellido
            </td>
            <td>
                <asp:TextBox runat="server" ID="TSApellido" Width="280px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Primer Nombre
            </td>
            <td>
                <asp:TextBox runat="server" ID="TPNombre" Width="280px"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TPNombre" ErrorMessage="Por favor ingrese un nombre." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Segundo Nombre
            </td>
            <td>
                <asp:TextBox runat="server" ID="TSNombre" Width="280px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Sexo
            </td>
            <td>
                <asp:DropDownList ID="DSexo" runat="server" 
                                DataSourceID="SSexo" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SSexo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT [sexoId] AS id, [sexoDesc] AS nombre FROM [admSexo]">
                </asp:SqlDataSource>
            </td>
            <td>
                Fecha Nacimiento
            </td>
            <td>
                <asp:TextBox runat="server" ID="TNacimiento" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TNacimiento" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator3" runat="server" Display="Dynamic">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TNacimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1910" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                <asp:Label ID="LEdad" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Dirección
            </td>
            <td>
                <asp:TextBox runat="server" ID="TDireccion"></asp:TextBox>
            </td>
            <td>
                Barrio
            </td>
            <td>
                <asp:TextBox runat="server" ID="TBarrio"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Teléfono
            </td>
            <td>
                <asp:TextBox runat="server" ID="TTelefono"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TTelefono" ErrorMessage="Por favor ingrese un teléfono." ID="RequiredFieldValidator8" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td>
                Teléfono1
            </td>
            <td>
                <asp:TextBox runat="server" ID="TTelefono1"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Celular
            </td>
            <td>
                <asp:TextBox runat="server" ID="TMovil"></asp:TextBox>
            </td>
            <td>
                Correo
            </td>
            <td>
                <asp:TextBox runat="server" ID="TEMail"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                                ErrorMessage="Por favor ingrese un correo electrónico valido." 
                                SetFocusOnError="True" ControlToValidate="TEMail" Display="Dynamic" Text="*" 
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                Especificaciones de llegada
            </td>
            <td colspan="2">
                <asp:TextBox runat="server" ID="TLlegada" TextMode="MultiLine" 
                    Width="375px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="1">
                Localidad
            </td>
            <td>
                <asp:DropDownList ID="DLocalidad" runat="server" 
                                DataSourceID="SLocalidad" DataTextField="nombre"
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SLocalidad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT locId id, locDescripcion nombre FROM admLocalidad">
                </asp:SqlDataSource>
            </td>
            <td colspan="1">
                Estrato
            </td>
            <td>
                <asp:TextBox runat="server" ID="TEstrato" MaxLength="1" CssClass="entero" Width="25px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td >
                Familiar Responsable
            </td>
            <td>
                <asp:TextBox runat="server" ID="TFResponsable"></asp:TextBox>
            </td>
            <td>
                Parentesco
            </td>
            <td>
                <asp:TextBox runat="server" ID="TParentesco"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td >
                Pago directo
            </td>
            <td>
                <asp:DropDownList ID="DPago" runat="server" 
                                DataSourceID="SPago" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SPago" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT pdirId id,pdirDescripcion nombre FROM dbo.phdPagoDirecto WHERE pdirActivo=1">
                </asp:SqlDataSource>
            </td>
            <td>
                Carné
            </td>
            <td>
                <asp:TextBox runat="server" ID="TCarnet"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Zona</td>
            <td>
                <asp:TextBox runat="server" ID="TZona"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
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
            <td >
                Asegurador
            </td>
            <td>
                <asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM dbo.admEntidad WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource>
            </td>
            <td style="margin-left: 160px">
                Médico de cabecera
            </td>
            <td>
                <asp:DropDownList ID="DMedico" runat="server" 
                                DataSourceID="SMedico" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SMedico" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT megId id, megNombre nombre FROM dbo.phdMegas ORDER BY nombre">
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr id="trDatosAsegurador">
            <td>
                Fecha de Ingreso al asegurador</td>
            <td>
                <asp:TextBox runat="server" ID="TFechaIngresoAsegurador" CssClass="fecha"></asp:TextBox>
                <asp:RangeValidator ControlToValidate="TFechaIngresoAsegurador" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td style="margin-left: 160px">
                Grado</td>
            <td>
                <asp:TextBox runat="server" ID="TGrado"></asp:TextBox>
            </td>
        </tr>
        <tr ID="trDatosAsegurador">
            <td>
                Tipo de afiliado</td>
            <td>
                <asp:DropDownList ID="DTipoAfiliado" runat="server" AppendDataBoundItems="true">
                    <asp:ListItem Text="" Value=""></asp:ListItem>
                    <asp:ListItem Value="1" Text="Cotizante"></asp:ListItem>
                    <asp:ListItem Value="2" Text="Beneficiario"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td style="margin-left: 160px">
                Categoría</td>
            <td><asp:DropDownList ID="DCategoria" runat="server" 
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
            <td >
                Tipo de Evento
            </td>
            <td>
                <asp:DropDownList ID="DTipoEvento" runat="server" 
                                DataSourceID="STipoEvento" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="STipoEvento" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT tipECod id,tipEDescripcion nombre FROM dbo.phdTipoEvento WHERE tipEActivo=1">
                </asp:SqlDataSource>
            </td>
            <td style="margin-left: 160px">
                Fec Ing Programa
            </td>
            <td>
                <asp:TextBox CssClass="fecha" runat="server" ID="TFechaIngreso"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFechaIngreso" ErrorMessage="Por favor ingrese una fecha de ingreso." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFechaIngreso" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator2" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td >
                Estado
            </td>
            <td>
                <asp:DropDownList ID="DEstado" runat="server" 
                                DataSourceID="SEstado" DataTextField="nombre" 
                                DataValueField="id" Enabled="false">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstado" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT estId id,estDesc nombre FROM dbo.phdEstado">
                </asp:SqlDataSource>
            </td>
            <td style="margin-left: 160px">
                Numero ETB
            </td>
            <td>
                <asp:TextBox runat="server" ID="TNumeroETB" CssClass="entero"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td >
                Intensidad Terapias
            </td>
            <td>
                <asp:TextBox runat="server" ID="TIntensidadTerapias"></asp:TextBox>
            </td>
            <td style="margin-left: 160px">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td >
                CIE 10
            </td>
            <td colspan="3">
                <asp:TextBox runat="server" Width="100%" ID="TCIE1"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td >
                CIE 10_1
            </td>
            <td colspan="3">
                <asp:TextBox runat="server" Width="100%" ID="TCIE2"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td >
                CIE 10_2
            </td>
            <td colspan="3">
                <asp:TextBox runat="server" Width="100%" ID="TCIE3"></asp:TextBox>
            </td>
        </tr>
    </table>
    </div>
    <asp:Panel runat="server" ID="PReactivar">
        <h3><a href="#">Programación próxima</a></h3>
        <div>
            <asp:GridView ID="GProgramacion" runat="server" AutoGenerateColumns="False" DataSourceID="SProgramacion" EmptyDataText="No se encontraron programaciones">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha" SortExpression="prgFechaProg" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="perNombre" HeaderText="Profesional" SortExpression="perNombre" />
                    <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" SortExpression="actDescripcion" />
                    <asp:BoundField DataField="autNumero" HeaderText="Autorización" SortExpression="autNumero" />
                </Columns>
            </asp:GridView>
                <asp:SqlDataSource ID="SProgramacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT  pr.prgFechaProg, 
		                    phdActividad.actDescripcion, 
		                    autNumero,
		                    admPersonalHS.perNombre
                    from dbo.vwphd_ProgramacionTotal pr
		                    INNER JOIN phdPaciente on pr.pacId = phdPaciente.pacId
		                    INNER JOIN phdActividad ON pr.actId = phdActividad.actId
		                    INNER JOIN admPersonalHS ON pr.perId = admPersonalHS.perId
	                    WHERE phdPaciente.pacId=@pacId
                              AND pr.prgFechaProg >= getdate()
                    order by prgFechaProg desc,phdActividad.actDescripcion">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HId" PropertyName="Value" DefaultValue="0" Name="pacId" />
                      </SelectParameters>
                </asp:SqlDataSource>
        </div>
        <h3><a href="#">Ver Auditoría de Servicios</a></h3>
        <div>
            <asp:GridView ID="GAuditoria" runat="server" AutoGenerateColumns="False" DataSourceID="SAuditoria" EmptyDataText="No se encontro auditoría">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="audFecha" HeaderText="Fecha" SortExpression="audFecha" />
                    <asp:BoundField DataField="audUsuario" HeaderText="Usuario" SortExpression="audUsuario" />
                    <asp:CheckBoxField DataField="audIngreso" HeaderText="Ingreso" SortExpression="audIngreso" />
                    <asp:CheckBoxField DataField="audEgreso" HeaderText="Egreso" SortExpression="audEgreso" />
                    <asp:CheckBoxField DataField="pacCuraciones" HeaderText="Curaciones" SortExpression="pacCuraciones" />
                    <asp:CheckBoxField DataField="pacAdmPuntual" HeaderText="Act.Puntual" SortExpression="pacAdmPuntual" />
                    <asp:CheckBoxField DataField="pacTerapiaFisica" HeaderText="Ter.Física" SortExpression="pacTerapiaFisica" />
                    <asp:CheckBoxField DataField="pacTerapiaResp" HeaderText="Ter.Resp" SortExpression="pacTerapiaResp" />
                    <asp:CheckBoxField DataField="pacTerapiaOcup" HeaderText="Ter.Ocup" SortExpression="pacTerapiaOcup" />
                    <asp:CheckBoxField DataField="pacTerapiaLenguaje" HeaderText="Ter.Leng" SortExpression="pacTerapiaLenguaje" />
                    <asp:CheckBoxField DataField="pacValNutricional" HeaderText="Val.Nutri" SortExpression="pacValNutricional" />
                    <asp:CheckBoxField DataField="pacValMedica" HeaderText="Val.Médica" SortExpression="pacValMedica" />
                    <asp:CheckBoxField DataField="pacEnfermeria_12" HeaderText="Enf.12H" SortExpression="pacEnfermeria_12" />
                    <asp:CheckBoxField DataField="pacEnfermeria_24" HeaderText="Enf.24H" SortExpression="pacEnfermeria_24" />
                    <asp:BoundField DataField="cingDescripcion" HeaderText="Causa Ing" SortExpression="cingDescripcion" />
                    <asp:BoundField DataField="cegDescripcion" HeaderText="Causa Egr" SortExpression="cegDescripcion" />
                    <asp:BoundField DataField="audObs" HeaderText="Obs" SortExpression="audObs" />
                </Columns>
            </asp:GridView>
                <asp:SqlDataSource ID="SAuditoria" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT [audIngreso]
	                      ,[audEgreso]
	                      ,CONVERT(BIT,[pacCuraciones]) pacCuraciones
                          ,CONVERT(BIT,[pacAdmPuntual]) pacAdmPuntual
                          ,CONVERT(BIT,[pacTerapiaFisica]) pacTerapiaFisica
                          ,CONVERT(BIT,[pacTerapiaResp]) pacTerapiaResp
                          ,CONVERT(BIT,[pacTerapiaOcup]) pacTerapiaOcup
                          ,CONVERT(BIT,[pacTerapiaLenguaje]) pacTerapiaLenguaje
                          ,CONVERT(BIT,[pacValNutricional]) pacValNutricional
                          ,CONVERT(BIT,[pacValMedica]) pacValMedica
                          ,CONVERT(BIT,[pacEnfermeria_12]) pacEnfermeria_12
                          ,CONVERT(BIT,[pacEnfermeria_24]) pacEnfermeria_24
                          ,CONVERT(BIT,[pacEntregaSuministros]) pacEntregaSuministros
                          ,[audUsuario]
                          ,[audFecha],
                          cingDescripcion,
                          cegDescripcion,
                          audObs
                      FROM [phdAuditServicios]
	                    left join phdCausaReingreso on [phdAuditServicios].cingId = phdCausaReingreso.cingId
	                    left join phdCausaEgreso on [phdAuditServicios].cegId = phdCausaEgreso.cegId
                      where  pacId=@pacId
                      order by [audFecha] desc,segFechaIngreso desc">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HId" PropertyName="Value" DefaultValue="0" Name="pacId" />
                      </SelectParameters>
                </asp:SqlDataSource>
        </div>
        <h3><a href="#"><asp:Label runat="server" ID="LReactivar" Text="Reactivar"></asp:Label></a></h3>
        <div>
            <table border="1">
                <tr><td>Fecha</asp:Label>
                </td><td>
                        <asp:TextBox CssClass="fecha" runat="server" ID="TFechaRetiro"></asp:TextBox>
                        <asp:RangeValidator ValidationGroup="Reingreso" ControlToValidate="TFechaRetiro" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator4" Display="Dynamic" Type="Date"></asp:RangeValidator>
                        <asp:RequiredFieldValidator ValidationGroup="Reingreso" ControlToValidate="TFechaRetiro" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator6" runat="server" Display="Dynamic"></asp:RequiredFieldValidator>
                </td></tr>
                <tr><td>Motivo</td><td>
                    <asp:DropDownList ID="DMotivo" runat="server" 
                                DataSourceID="SMotivo" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                </asp:DropDownList>
                        <asp:SqlDataSource ID="SMotivo" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:connBD %>" 
                            SelectCommand="SELECT cingId id,cingDescripcion nombre FROM dbo.phdCausaReingreso ORDER BY 2">
                        </asp:SqlDataSource>
                    <asp:RequiredFieldValidator ValidationGroup="Reingreso" ControlToValidate="DMotivo" ErrorMessage="Por favor seleccione un motivo." ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </td></tr>
                <tr><td>Observaciones</td><td>
                    <asp:TextBox runat="server" ID="TObservacionesRetiro" Width="100%" TextMode="MultiLine"></asp:TextBox>
                    </td></tr>
                <tr><td colspan="2" style="text-align: right">
                    <asp:Button ValidationGroup="Reingreso" ID="BRetiro" runat="server" 
                        Text="Reactivar" onclick="BRetiro_Click" />
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