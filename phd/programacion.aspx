<%@ Page Title="Programación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="programacion.aspx.cs" Inherits="phd_programacion" %>
<%@ Register src="~/paciente/autorizaciones.ascx" tagname="autorizaciones" tagprefix="uc1" %>
<%@ Register src="programacionc.ascx" tagname="programacion" tagprefix="uc2" %>
<%@ Register src="novedad.ascx" tagname="novedad" tagprefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= TPaciente.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPacienteI",
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
                $.goURL("id=" + ui.item.value);
                return false;
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    Paciente: <asp:TextBox runat="server" ID="TPaciente"></asp:TextBox><asp:Label runat="server" Font-Bold="true" ID="LPaciente"></asp:Label>
    <asp:Panel runat="server" id="PDatos" Visible="false" >
    <asp:HiddenField runat="server" ID="HId" />
    <table style="width: 100%;" border="1">
        <tr>
            <td colspan="4" style="text-align: center" class="celdaTitulo">Información personal
            </td>
            <td style="text-align: center" class="celdaTitulo">
                Servicios
            </td>
        </tr>
       <tr>
            <td>
                Fecha Nacimiento
            </td>
            <td colspan="2">
                    <asp:Label ID="LFechaNacimiento" Font-Bold="true" runat="server" Text=""></asp:Label> - <asp:Label Font-Bold="true" ID="LEdad" runat="server" Text=""></asp:Label>
            </td>
            <td>
                Sexo
                <asp:Label ID="LSexo" Font-Bold="true" runat="server" Text=""></asp:Label>
            </td>
            <td rowspan="8" valign="top">
                <uc1:autorizaciones ID="UCAutorizaciones" runat="server" />
            </td>
       </tr>
        <tr>
            <td>
                Asegurador
            </td>
            <td>
                <asp:Label ID="LAsegurador" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            <td>
                Carné
            </td>
            <td>
                <asp:Label ID="LCarnet" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Dirección
            </td>
            <td>
                <asp:Label ID="LDireccion" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            <td>
                Barrio
            </td>
            <td style="margin-left: 40px">
                <asp:Label ID="LBarrio" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Teléfono
            </td>
            <td>
                <asp:Label ID="LTelefono" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            <td>
                Celular
            </td>
            <td>
                <asp:Label ID="LMovil" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Pago Dir
            </td>
            <td>
                <asp:Label ID="LTipoPago" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            <td>
                Estancia
            </td>
            <td>
                <asp:Label ID="LEstancia" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Familiar</td>
            <td>
                <asp:Label ID="LFamiliar" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
            <td>
                Parentesco
            </td>
            <td>
                <asp:Label ID="LParentesco" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Label ID="LCIE10" runat="server" Font-Bold="true" Text=""></asp:Label>
            </td>
        </tr>
        </table>
        <table class="styleTb" width="100%">
            <tr>
                <td style="text-align: left" width="100%" colspan="2" class="celdaTitulo">
                    Historial de Programaciones
                </td>
            </tr>
            <tr>
                <td style="text-align: left">
                    <asp:LinkButton ID="LNuevo" runat="server" CausesValidation="false" 
                        onclick="LNuevo_Click">Programar nuevo</asp:LinkButton>
                </td>
                <td style="text-align: right">
                    Actividad
                    <asp:DropDownList ID="DProgramaciones" runat="server" 
                        AppendDataBoundItems="true" AutoPostBack="true" DataSourceID="SProgramaciones" 
                        DataTextField="nombre" DataValueField="id">
                        <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SProgramaciones" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT actId id,actDescripcion nombre FROM dbo.phdActividad INNER JOIN dbo.phdTipoActividad ON phdActividad.tpaId = phdTipoActividad.tpaId where tpaTipoServicio=1 order by 2">
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td style="text-align: center" colspan="2">
                    <div class="styleTb" style=" text-align:left;">
                    </div>
                <br />
                    <asp:GridView ID="GProgramacion" runat="server" AllowPaging="True" 
                        AutoGenerateColumns="False" DataSourceID="SProgramacion" 
                        EmptyDataText="No se encontraron programaciones" DataKeyNames="prgId" 
                        AllowSorting="true" onrowediting="GProgramacion_RowEditing" 
                        onselectedindexchanged="GProgramacion_SelectedIndexChanged">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:TemplateField HeaderText="Sel">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="CSeleccionar" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:CommandField HeaderText="Edit" ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField HeaderText="Elim" ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:CommandField HeaderText="Novedad" ButtonType="Link" EditText="Novedad" ShowEditButton="true" />
                            <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha" SortExpression="prgFechaProg"   DataFormatString="{0:d}" />
                            <asp:BoundField DataField="perNombre" HeaderText="Profesional" SortExpression="perNombre">
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="prgNumSesion" HeaderText="Num Sesiones" SortExpression="prgNumSesion">
                                <ItemStyle HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="autorizacion" HeaderText="Autorización" SortExpression="autorizacion" />
                            <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" SortExpression="actDescripcion"/>
                            <asp:CheckBoxField DataField="prgActivo" HeaderText="Activo?" />
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SProgramacion" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT prgId,prgFechaProg,perNombre,prgNumSesion,actDescripcion,prgActivo,
                                    phdProgramacion.autNumero + '[' + CONVERT(VARCHAR, ISNULL(phdDetalleAutorizacion.autNumSesiones,0)) + ']' AS autorizacion
                                    FROM phdProgramacion 
                                    LEFT JOIN admPersonalHS ON (admPersonalHS.perId=phdProgramacion.perId) 
                                    LEFT JOIN phdActividad ON (phdActividad.actId=phdProgramacion.actId) 
                                    LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero=phdProgramacion.autNumero AND phdDetalleAutorizacion.actId=phdProgramacion.actId)
                                    WHERE pacId=@paciente AND (@actividad=0 OR phdProgramacion.actId=@actividad)
                                    ORDER BY prgFechaProg DESC"
                                    DeleteCommand="DELETE phdProgramacion where prgId=@prgId"
                                    >
                          <SelectParameters>
                            <asp:ControlParameter ControlID="HId" Name="paciente" PropertyName="Value" />
                            <asp:ControlParameter ControlID="DProgramaciones" PropertyName="SelectedValue" Name="actividad" />
                          </SelectParameters>
                    </asp:SqlDataSource>
                        <br />
                        <div style="width:100%;text-align:left;">
                        <asp:LinkButton ID="lnkNovedad" runat="server" CausesValidation="false" 
                                onclick="lnkNovedad_Click">Generar Novedades masivas</asp:LinkButton><br />
                    <asp:LinkButton ID="lnkelimMasivo" runat="server" CausesValidation="false" 
                                OnClientClick="return confirm('Confirma que desea realizar la eliminación')" 
                                onclick="lnkelimMasivo_Click">Eliminar masivamente</asp:LinkButton>
                        </div>
                        <asp:HiddenField runat="server" ID="hddVerPrg" Value="0" />                        
                        <asp:HiddenField runat="server" ID="hddVerNov" Value="0" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <uc2:programacion ID="UCProgramacion" runat="server" Visible="False" OnAceptarClicked="UCProgramacion_AceptarClicked" OnCancelarClicked="UCProgramacion_CancelarClicked" />
        <uc3:novedad ID="UCNovedad" runat="server" OnAceptarClicked="UCNovedad_AceptarClicked" Visible="false" OnCancelarClicked="UCNovedad_CancelarClicked" />
</asp:Content>

