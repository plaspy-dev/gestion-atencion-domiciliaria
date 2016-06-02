<%@ Page Title="Programación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="programacion.aspx.cs" Inherits="eventos_programacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .entero 
        {
            width: 25px;
        }
	.ui-autocomplete {
		max-height: 500px;
		overflow-y: auto;
		/* prevent horizontal scrollbar */
		overflow-x: hidden;
		/* add padding to account for vertical scrollbar */
		padding-right: 20px;
		text-align: left;
	}
	/* IE 6 doesn't support max-height
	 * we use height instead, but this forces the menu to always be this tall
	 */
	* html .ui-autocomplete {
		height: 500px;
	}
</style>
<script type="text/javascript">
    $inicio(function() {
        $("#<%= TNombre.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetEventos",
                    data: "{ 'q': '" + request.term + "' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.item, label: item.value
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
                $.goURL("id=" + ui.item.value);
                return false;
            }
        });
        $("#<%= TPersonal.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPersonalOrganizationExample16",
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
            minLength: 2,
            select: function(event, ui) {
                $('#<%= TPersonal.ClientID %>').val(ui.item.label);
                $('#<%= TIdPersonal.ClientID %>').val(ui.item.value);
                return false;
            },
            search: function(event, ui) {
                $('#<%= TIdPersonal.ClientID %>').val("");
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:UpdatePanel runat="server" ID="PTodo">
        <ContentTemplate>
    <asp:HiddenField runat="server" ID="HIdEvento" />
    <fieldset>
        <legend>Programación</legend>
        <table style="width: 100%;border-collapse: collapse;">
            <tr>
                <td>
                    Nombre</td>
                <td>
                    <asp:TextBox ID="TNombre" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="TNombre" ErrorMessage="Por favor ingrese un nombre." ID="R1" runat="server" SetFocusOnError="true" Display="Dynamic" >*</asp:RequiredFieldValidator>
                </td>
                <td>
                    Contacto</td>
                <td>
                    <asp:DropDownList ID="DResponsable" runat="server" DataSourceID="SResponsable" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true" CssClass="anchomaxcombo">
                        <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SResponsable" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM contacto WHERE estado IS NULL" >
            </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>
                    Inicio</td>
                <td>
                    <asp:TextBox ID="TInicio" CssClass="fecha" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha de inicio." ID="R2" runat="server" SetFocusOnError="true" Display="Dynamic" >*</asp:RequiredFieldValidator>
                </td>
                <td>
                    Fin</td>
                <td>
                    <asp:TextBox ID="TFin" CssClass="fecha" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Lugar</td>
                <td>
                    <asp:DropDownList ID="DLugar" runat="server" DataSourceID="SLugar" AutoPostBack="true" AppendDataBoundItems="true"
                        DataTextField="nombre" DataValueField="id" CssClass="anchomaxcombo">
                        <asp:ListItem Text="(Ninguno)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ControlToValidate="DLugar" ErrorMessage="Por favor seleccione un lugar." InitialValue="0" ID="R4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:SqlDataSource ID="SLugar" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=10020 AND szReservado IS NULL" >
            </asp:SqlDataSource></td>
                <td>
                    Programa</td>
                <td>
                    <asp:DropDownList ID="DPrograma" runat="server" DataSourceID="SPrograma" AutoPostBack="true" AppendDataBoundItems="true"
                        DataTextField="nombre" DataValueField="id"  CssClass="anchomaxcombo">
                        <asp:ListItem Text="(Ninguno)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ControlToValidate="DPrograma" ErrorMessage="Por favor seleccione un programa." InitialValue="0" ID="R3" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:SqlDataSource ID="SPrograma" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=10017 AND szReservado IS NULL" >
            </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>
                    Actividad</td>
                <td>
                    <asp:DropDownList ID="DActividad" runat="server" DataSourceID="SActividad" AutoPostBack="true" AppendDataBoundItems="true"
                        DataTextField="nombre" DataValueField="id"  CssClass="anchomaxcombo">
                        <asp:ListItem Text="(Ninguna)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ControlToValidate="DActividad" ErrorMessage="Por favor seleccione una actividad." InitialValue="0" ID="R5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:SqlDataSource ID="SActividad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=10018 AND szReservado IS NULL" >
            </asp:SqlDataSource></td>
                <td>
                    Plan</td>
                <td>
                    <asp:DropDownList ID="DPlan" runat="server" DataSourceID="SPlan" AutoPostBack="true" AppendDataBoundItems="true"
                        DataTextField="nombre" DataValueField="id"  CssClass="anchomaxcombo">
                        <asp:ListItem Text="(Ninguno)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ControlToValidate="DPlan" ErrorMessage="Por favor seleccione un plan." InitialValue="0" ID="R6" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:SqlDataSource ID="SPlan" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=10019 AND szReservado IS NULL" >
            </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>
                    Hora inicio</td>
                <td>
                    <asp:TextBox ID="THInicio" CssClass="hora" runat="server"></asp:TextBox>
                </td>
                <td>
                    Hora final</td>
                <td>
                    <asp:TextBox ID="THFinal" CssClass="hora" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Número de MEC</td>
            </tr>
            <tr>
                <td class="tdl">Cantidad</td>
                <td class="nw" colspan="2"><asp:TextBox ID="TMECComplejo" CssClass="entero" runat="server"></asp:TextBox> Complejo
                <asp:TextBox ID="TMECMedio" CssClass="entero" runat="server"></asp:TextBox> Medio
                <asp:TextBox ID="TMECBajo" CssClass="entero" runat="server"></asp:TextBox> Bajo</td>
                <td class="tdr"></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Personal</td>
            </tr>
            <tr>
                <td class="tdl tdb">Auxiliares</td>
                <td colspan="3" class="nw tdb tbr">
                Cantidad <asp:TextBox runat="server" ID="TAuxiliares" CssClass="entero"></asp:TextBox>
                Valor hora <asp:TextBox runat="server" ID="TVAuxiliar" CssClass="dinero"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl tdb">Médicos</td>
                <td class="tdr tdb" colspan="3">
                Cantidad <asp:TextBox runat="server" ID="TMedicos" CssClass="entero"></asp:TextBox>
                Valor hora <asp:TextBox runat="server" ID="TVMedicos" CssClass="dinero"></asp:TextBox> 
                </td>
            </tr>
            <tr>
                <td colspan="4" class="tdl tdr">
                    <asp:GridView ID="GPersonal" runat="server" DataSourceID="SPersonal" Width="100%"
                        AutoGenerateColumns="False" DataKeyNames="id,carId"
                        onselectedindexchanged="GPersonal_SelectedIndexChanged" >
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <SelectedRowStyle CssClass="selecteditem" />
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField DataField="idpersonal" HeaderText="idpersonal" ItemStyle-CssClass="hidet" HeaderStyle-CssClass="hidet" />
                            <asp:BoundField DataField="personal" HeaderText="Personal" ItemStyle-Width="100%" />
                            <asp:BoundField DataField="chaqueta" HeaderText="No." ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="cargo" HeaderText="Cargo" ItemStyle-Wrap="false" />
                        </Columns>                        
                    </asp:GridView>
                    <sdg:CustomDataSource ID="SPersonal" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        SelectCommand="SELECT personal_programacion.id AS id,personal_programacion.personal AS idpersonal,recurso_humano.perNombre AS personal
                                            ,cargo.carDescripcion AS cargo,recurso_humano.carId, personal_programacion.chaqueta
                                            FROM personal_programacion 
                                            LEFT JOIN recurso_humano ON (recurso_humano.perId=personal_programacion.personal) 
                                            LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId) 
                                            WHERE personal_programacion.programacion=@programacion 
                                            ORDER BY cargo, personal"
                                        InsertCommand="INSERT INTO personal_programacion(programacion,personal,chaqueta) VALUES (@programacion, @idpersonal, @chaqueta)"
                                        UpdateCommand="UPDATE personal_programacion SET personal=@idpersonal,chaqueta=@chaqueta WHERE id=@id" 
                                        DeleteCommand="DELETE FROM personal_programacion WHERE id=@id"
                                        >
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="HIdEvento" DefaultValue="0" PropertyName="Value" Name="programacion" />
                                        </SelectParameters>
                    </sdg:CustomDataSource>
                </td>
            </tr>
            <tr>
                <td class="tdl">Nombre</td>
                <td class="nw" colspan="2">
                    <asp:TextBox runat="server" ID="TPersonal" Width="100%"></asp:TextBox>
                    <asp:TextBox runat="server" ID="TIdPersonal" CssClass="hidet"></asp:TextBox>
                    No. Chaqueta <asp:TextBox runat="server" ID="TChaqueta" CssClass="entero"></asp:TextBox>
                    <asp:Button ID="BMasPersonal" ValidationGroup="personal" CausesValidation="false" runat="server" onclick="BMasPersonal_Click" Text="+" />
                    <asp:RequiredFieldValidator ValidationGroup="personal" ControlToValidate="TIdPersonal" ErrorMessage="Por favor ingrese un personal." ID="R7" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                </td>
                <td></td>
                <td class="tdr"></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Ambulancias</td>
            </tr>
            <tr>
                <td class="tdl tdb">TAB</td>
                <td class="nw tdr tdb" colspan="3">
                Cantidad <asp:TextBox ID="TAmbulanciasB" CssClass="entero" runat="server"></asp:TextBox>
                Valor hora <asp:TextBox runat="server" ID="TVTAB" CssClass="dinero"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl tdb">TAM</td>
                <td class="tdr tdb nw" colspan="3">
                    Cantidad <asp:TextBox ID="TAmbulanciasM" CssClass="entero" runat="server"></asp:TextBox>
                    Valor hora <asp:TextBox runat="server" ID="TVTAM" CssClass="dinero"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="tdr tdl">
                    <asp:GridView ID="GAmbulancias" runat="server" Width="100%"
                        AutoGenerateColumns="False" DataKeyNames="Codigo" 
                        onselectedindexchanged="GAmbulancias_SelectedIndexChanged">
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <SelectedRowStyle CssClass="selecteditem" />
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/eliminar.gif" />
                            <asp:BoundField DataField="Codigo" HeaderText="Código" ItemStyle-Width="100%" />
                            <asp:BoundField DataField="Empresa" HeaderText="Empresa" ItemStyle-Wrap="false" />
                            <asp:BoundField DataField="Tipo" HeaderText="Tipo" ItemStyle-Wrap="false" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td class="tdl tdb">Código</td>
                <td colspan="3" class="nw tdr tdb"><asp:TextBox runat="server" ID="TCodigo"></asp:TextBox>
                Empresa <asp:TextBox runat="server" ID="TEmpresa"></asp:TextBox>
                <asp:DropDownList runat="server" ID="DTipo">
                    <asp:ListItem Text="TAB" Value="0"></asp:ListItem>
                    <asp:ListItem Text="TAM" Value="1"></asp:ListItem>
                </asp:DropDownList>
                    <asp:Button runat="server" ID="BMasAmbulancia" Text="+" 
                        ValidationGroup="ambulancia" onclick="BMasAmbulancia_Click" />
                    <asp:RequiredFieldValidator ControlToValidate="TCodigo" ErrorMessage="Por favor ingrese un código." ID="R8"  ValidationGroup="ambulancia"
	runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                </td>
            </tr>
            </table>
            <br />
    <div style="text-align: right;">
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true" />
        <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
            onclick="BAceptar_Click" />
        <asp:Button ID="BCancelar" CausesValidation="false" runat="server" 
            Text="Cancelar" onclick="BCancelar_Click" />
    </div>
    <br />
    <asp:GridView ID="GEventos" runat="server" AutoGenerateColumns="False" AllowSorting="true" 
        DataKeyNames="id" DataSourceID="SEventos" AllowPaging="true" PageSize="20"
        onselectedindexchanged="GEventos_SelectedIndexChanged" Width="100%"
        ondatabound="GEventos_DataBound">
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
            <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" ItemStyle-Width="100%" />
            <asp:BoundField DataField="inicio" HeaderText="Inicio" SortExpression="inicio" DataFormatString="{0:d}" />
            <asp:BoundField DataField="fin" HeaderText="Fin" SortExpression="fin" DataFormatString="{0:d}" />
            <asp:BoundField DataField="lugar" HeaderText="Lugar" SortExpression="lugar" />
            <asp:BoundField DataField="programa" HeaderText="Programa" SortExpression="programa" />
        </Columns>
        <SelectedRowStyle CssClass="selecteditem" />
    </asp:GridView>
    <asp:SqlDataSource ID="SEventos" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT programacion_evento.id AS id,programacion_evento.nombre AS nombre,programacion_evento.inicio AS inicio,programacion_evento.fin AS fin,varios.nombre AS lugar,programa.nombre AS programa FROM programacion_evento 
                        LEFT JOIN varios ON (varios.id=programacion_evento.lugar) 
                        LEFT JOIN varios AS programa ON (programa.id=programacion_evento.programa) 
                        WHERE programacion_evento.estado IS NULL 
                        AND (@lugar=0 OR programacion_evento.lugar=@lugar)
                        AND (@programa=0 OR programacion_evento.programa=@programa)
                        AND (@actividad=0 OR programacion_evento.actividad=@actividad)
                        AND (@plan=0 OR programacion_evento.plan=@plan)
                        ORDER BY programacion_evento.inicio ASC" 
        DeleteCommand="UPDATE programacion_evento SET estado=-1 WHERE id=@id" >
        <SelectParameters>
            <asp:ControlParameter ControlID="DLugar" Name="lugar" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DPrograma" Name="programa" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DActividad" Name="actividad" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DPlan" Name="plan" PropertyName="SelectedValue" />
        </SelectParameters>
    </asp:SqlDataSource>
    </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

