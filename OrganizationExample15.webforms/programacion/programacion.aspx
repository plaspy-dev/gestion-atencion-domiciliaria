<%@ Page Title="Programación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="programacion.aspx.cs" Inherits="programacion_programacion" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<%@ Register src="~/programacion/programacionc.ascx" tagname="programacion" tagprefix="uc2" %>
<%@ Register src="~/programacion/novedad.ascx" tagname="novedad" tagprefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">.anchomaxcombo { max-width: 500px; }</style>
<script type="text/javascript">
    addFunctionToStart(function() {
        $("#<%= DProgramaciones.ClientID %>").sortSelect();
    });
    <% if(!string.IsNullOrEmpty(Request.QueryString["modid"])) {%>
    $(function () {
        $("#ctl00_lPropiedades a").click();
    })
    <% } %>
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional" >
        <ContentTemplate>
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table width="100%">
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
                        DataTextField="nombre" DataValueField="id" 
                        ondatabound="DProgramaciones_DataBound">
                        <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SProgramaciones" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT programacion.actId AS id,medicamentos.nombre AS nombre FROM programacion LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId) WHERE programacion.pacId=@paciente {0} GROUP BY programacion.actId,medicamentos.nombre">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td style="text-align: center" colspan="2">
                <br />
                    <asp:GridView ID="GProgramacion" runat="server" AllowPaging="True" Width="100%"
                        AutoGenerateColumns="False" DataSourceID="SProgramacion" 
                        EmptyDataText="No se encontraron programaciones" DataKeyNames="prgId,perId,autNumero" 
                        AllowSorting="true" onrowediting="GProgramacion_RowEditing" 
                        onselectedindexchanged="GProgramacion_SelectedIndexChanged" 
                        onrowdeleted="GProgramacion_RowDeleted">
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
                            <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="S" CssClass="btn btn-success btn-xs" CausesValidation="False" CommandName="Select" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
                            <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="D" CssClass="btn btn-danger btn-xs" CausesValidation="False" CommandName="Delete" ToolTip="Eliminar"><i class="fa fa-trash-o"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
                            <asp:CommandField HeaderText="Novedad" ButtonType="Link" EditText="Novedad" ShowEditButton="true" />
                            <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha" SortExpression="prgFechaProg"   DataFormatString="{0:d}" />
                            <asp:BoundField DataField="perNombre" HeaderText="Profesional" SortExpression="perNombre" ItemStyle-Wrap="false">
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="prgNumSesion" HeaderText="Num Sesiones" SortExpression="prgNumSesion">
                                <ItemStyle HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="autorizacion" HeaderText="Autorización" SortExpression="autorizacion"  ItemStyle-Wrap="false"/>
                            <asp:BoundField DataField="actividad" HeaderText="Actividad" SortExpression="actividad" ItemStyle-Wrap="false" 
                                ItemStyle-Width="100%" ItemStyle-HorizontalAlign="Left"/>
                            <asp:CheckBoxField DataField="prgActivo" HeaderText="Activo?" />
                            <asp:BoundField DataField="actId" HeaderText="ActividadId" SortExpression="actId" ItemStyle-CssClass="hidet" HeaderStyle-CssClass="hidet" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <a class="btn btn-default btn-xs" href="<%# string.Format("{0}?pid={1}&modid={2}&pi={3}", Request.Url.AbsolutePath, Request.QueryString["pid"], Eval("prgId"), GProgramacion.PageIndex) %>"><i class="fa fa-list-alt"></i></a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SProgramacion" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT prgId,prgFechaProg,perNombre,prgNumSesion,programacion.perId
                                    ,medicamentos.nombre AS actividad
                                    ,prgActivo
                                    ,CONCAT(programacion.autNumero,'[',IFNULL(autorizacion_detalle.autNumSesiones,0), ']') AS autorizacion
                                    , programacion.actId
                                    ,programacion.autNumero
                                    FROM programacion 
                                    LEFT JOIN recurso_humano ON (recurso_humano.perId=programacion.perId) 
                                    LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId) 
                                    LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=programacion.autNumero AND autorizacion_detalle.actId=programacion.actId)
                                    WHERE pacId=@paciente AND (@actividad=0 OR programacion.actId=@actividad) {0}
                                    ORDER BY prgFechaProg DESC"
                                    DeleteCommand="DELETE FROM programacion WHERE prgId=@prgId"
                                    >
                          <SelectParameters>
                            <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
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
            <uc2:programacion ID="UCProgramacion" runat="server" Visible="False" OnAceptarClicked="UCProgramacion_AceptarClicked" OnCancelarClicked="UCProgramacion_CancelarClicked" />
            <uc3:novedad ID="UCNovedad" runat="server" OnAceptarClicked="UCNovedad_AceptarClicked" Visible="false" OnCancelarClicked="UCNovedad_CancelarClicked" />
            </ContentTemplate>
        </asp:UpdatePanel>
</asp:Content>

