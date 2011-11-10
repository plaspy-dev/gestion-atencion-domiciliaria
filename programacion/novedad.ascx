<%@ Control Language="C#" AutoEventWireup="true" CodeFile="novedad.ascx.cs" Inherits="phd_novedad" %>
<script type="text/javascript">
    $(function() {

        $("#<%= TTipo.ClientID %>").hide();
        $("#tabsnovedad").tabs({
            show: function(event, ui) {
                $("#<%= TTipo.ClientID %>").val($(this).tabs("option", "selected"));
            }
        });
        addDialog("#dParentNovedad", "#dNovedad");
        $("#<%=DProfesional.ClientID %>").combobox();
    });
</script>
<div id="dParentNovedad">
<div id="dNovedad" title="Novedad programación" style="display:none;">
<asp:HiddenField ID="HId" runat="server" />
<asp:HiddenField ID="HIdProgramacion" runat="server" />
<asp:HiddenField ID="HIdProgramaciones" runat="server" />
<asp:TextBox runat="server" ID="TTipo"></asp:TextBox>
<asp:ValidationSummary ID="ValidationSummary1" runat="server" />
<div id="tabsnovedad">
    <ul>
        <li><a href="#tnov-1">Cancelación Programación</a></li>
        <li><a href="#tnov-2">Reasignación</a></li>
        <li><a href="#tnov-3">Cambio en num. sesiones</a></li>
        <li><a href="#tnov-4">Paciente desprotegido</a></li>
        <li><a href="#tnov-5">Cambio Servicio</a></li>
        <li><a href="#tnov-6">Otro</a></li>
    </ul>
    <div id="tnov-1">
        <table>
            <tr>
                <td style="min-width:100px; text-align:left;">Causa</td>
                <td><asp:DropDownList ID="DCausa1" runat="server" 
                                DataSourceID="SCausa1" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCausa1" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT cnoId id,cnoDescripcion nombre FROM dbo.phdCausaNovedad WHERE cnoTipoNovedad=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
        </table>
    </div>
    <div id="tnov-3">
        <table>
            <tr>
                <td style="min-width:100px; text-align:left;">Causa</td>
                <td><asp:DropDownList ID="DCausa3" runat="server" 
                                DataSourceID="SCausa3" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCausa3" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT cnoId id,cnoDescripcion nombre FROM dbo.phdCausaNovedad WHERE cnoTipoNovedad=4 ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>Núm. sesiones</td>
                <td><asp:TextBox runat="server" Text="1" ID="TNumero" Width="10px" MaxLength="1" CssClass="entero"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TNumero" ErrorMessage="Por favor ingrese un número de sesiones." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
            </tr>
        </table>
    </div>
    <div id="tnov-5">
        <table>
            <tr>
                <td style="min-width:100px; text-align:left;">Causa</td>
                <td><asp:DropDownList ID="DCausa5" runat="server" 
                                DataSourceID="SCausa5" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCausa5" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT cnoId id,cnoDescripcion nombre FROM dbo.phdCausaNovedad WHERE cnoTipoNovedad=6 ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>Nuevo servicio</td>
                <td><asp:DropDownList ID="DNuevoServicio" runat="server" 
                                DataSourceID="SNuevoServicio" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SNuevoServicio" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT actId id,actDescripcion nombre FROM dbo.phdActividad INNER JOIN dbo.phdTipoActividad ON phdActividad.tpaId = phdTipoActividad.tpaId WHERE tpaTipoServicio=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
        </table>
    </div>
    <div id="tnov-2">
        <table>
            <tr>
                <td style="min-width:100px; text-align:left;">Causa</td>
                <td><asp:DropDownList ID="DCausa2" runat="server" 
                                DataSourceID="SCausa2" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCausa2" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT cnoId id,cnoDescripcion nombre FROM dbo.phdCausaNovedad WHERE cnoTipoNovedad=2 ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>Profesional</td>
                <td><asp:DropDownList ID="DProfesional" runat="server" Width="200px"
                                DataSourceID="SProfesional" DataTextField="nombre" 
                                DataValueField="id" ondatabinding="DProfesional_DataBinding">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SProfesional" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="(SELECT '' AS id,'' AS nombre) UNION (SELECT perId id,perNombre nombre FROM dbo.admPersonalHS where eEstId=1 and (areaid=2 or carId in (8,11,25,27))) ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
        </table>
    </div>
    <div id="tnov-4">
        <table>
            <tr>
                <td style="min-width:100px; text-align:left;">Causa</td>
                <td><asp:DropDownList ID="DCausa4" runat="server" 
                                DataSourceID="SCausa4" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCausa4" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT cnoId id,cnoDescripcion nombre FROM dbo.phdCausaNovedad WHERE cnoTipoNovedad=5 ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
        </table>
    </div>
    <div id="tnov-6">
    </div>
</div>
<div>
<table>
<tr>
    <td style="min-width:120px">Observaciones</td>
    <td><asp:TextBox ID="TObservaciones" TextMode="Multiline" runat="server"></asp:TextBox></td>
</tr>
</table>
<br />
<br />
    <asp:GridView ID="GNovedades" runat="server" AllowPaging="True" 
        AutoGenerateColumns="False" DataSourceID="SNovedades" 
        EmptyDataText="No se encontraron novedades" DataKeyNames="novIden" 
        AllowSorting="true" onrowdatabound="GNovedades_RowDataBound">
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField DataField="cnoDescripcion" HeaderText="Tipo de Novedad" SortExpression="cnoDescripcion" />
            <asp:BoundField DataField="novTipo" HeaderText="Causa" SortExpression="novTipo" />
            <asp:BoundField DataField="perNombre" HeaderText="Profesional Involucrado" SortExpression="perNombre" />
            <asp:BoundField DataField="personal" HeaderText="Profesional Asignado" SortExpression="personal" />
            <asp:BoundField DataField="novObs" HeaderText="Observaciones" SortExpression="novObs" />
            <asp:BoundField DataField="segUsuarioRegistro" HeaderText="Usuario" SortExpression="segUsuarioRegistro" />
            <asp:BoundField DataField="segFechaRegistro" HeaderText="Fecha" SortExpression="segFechaRegistro" DataFormatString="{0:d}" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SNovedades" runat="server" 
        ConnectionString="<%$ ConnectionStrings:connBD %>" 
        SelectCommand="SELECT 
                        phdNovedad.novIden,phdCausaNovedad.cnoDescripcion,personalAnt.perNombre,admPersonalHS.perNombre AS personal
                        ,phdNovedad.novObs,phdNovedad.segUsuarioRegistro,phdNovedad.segFechaRegistro
                        ,phdNovedad.novTipo
                        FROM phdNovedad
                        LEFT JOIN admPersonalHS ON (phdNovedad.perId = admPersonalHS.perId)
                        LEFT JOIN admPersonalHS AS personalAnt ON (phdNovedad.perIdAnt = personalAnt.perId) OR (phdNovedad.perIdAnt IS NULL AND personalAnt.perId IS NULL)
                        LEFT JOIN phdCausaNovedad ON (phdNovedad.cnoId = phdCausaNovedad.cnoId)
                        WHERE phdNovedad.prgId=@programacion AND phdNovedad.prgTipo = 1 ORDER BY phdNovedad.segFechaRegistro DESC"
                    >
          <SelectParameters>
            <asp:ControlParameter ControlID="HIdProgramacion" Name="programacion" PropertyName="Value" Type="Int32" />
          </SelectParameters>
    </asp:SqlDataSource>
    <br />
</div>
<div style="text-align:right">
    <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
        onclick="BAceptar_Click" /><asp:Button ID="BCancelar" runat="server" 
        Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click"/></div>
</div>
</div>
