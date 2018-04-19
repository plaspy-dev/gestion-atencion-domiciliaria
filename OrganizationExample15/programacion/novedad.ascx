<%@ Control Language="C#" AutoEventWireup="true" CodeFile="novedad.ascx.cs" Inherits="phd_novedad" %>
<div id="dscriptNovedad" class="hidet">
<script type="text/javascript">
    addFunctionToStart(function() {
        $("#<%= TTipo.ClientID %>").hide();
        $("#tabsnovedad").tabs({
            show: function(event, ui) {
                $("#<%= TTipo.ClientID %>").val($(this).tabs("option", "selected"));
            }
        });
        addDialog("#dParentNovedad", "#dNovedad");
        $("#<%= TProfesional.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetPersonalC",
            data: {'s': '<%= HIdServicio.Value %>'},
            idField: "<%= TProfesionalID.ClientID %>"
        });

        $("#<%= TProcedimiento.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetMedicamentos",
            data: { t: 173 },
            idField: "<%= TProcedimientoID.ClientID %>"
        });
    });
</script>
</div>
<div id="dParentNovedad">
<div id="dNovedad" title="Novedad programación" style="display:none;">
<asp:HiddenField ID="HId" runat="server" />
<asp:HiddenField ID="HIdProgramacion" runat="server" />
<asp:HiddenField ID="HIdProgramaciones" runat="server" />
<asp:HiddenField ID="HIdServicio" runat="server" />
<asp:TextBox runat="server" ID="TTipo"></asp:TextBox>
<asp:ValidationSummary ID="ValidationSummary1" runat="server" />
<asp:Panel runat="server" ID="PEdicion">
<div id="tabsnovedad">
    <ul>
        <li><a href="#tnov-1">Cancelación Programación</a></li>
        <li><a href="#tnov-2">Reasignación</a></li>
        <li><a href="#tnov-3">Cambio en num. sesiones</a></li>
        <li><a href="#tnov-4">Paciente descubierto</a></li>
        <li><a href="#tnov-5">Cambio Servicio</a></li>
        <li><a href="#tnov-6">Otro</a></li>
    </ul>
    <div id="tnov-1">
        <table width="100%">
            <tr>
                <td style="width: 85px; text-align:left;">Causa</td>
                <td><asp:DropDownList ID="DCausa1" runat="server" 
                                DataSourceID="SCausa1" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCausa1" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT cnoId id,cnoDescripcion nombre FROM causa_novedad WHERE cnoTipoNovedad=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
        </table>
    </div>
    <div id="tnov-3" class="hidet">
        <table width="100%">
            <tr>
                <td style="width: 85px; text-align:left;">Causa</td>
                <td><asp:DropDownList ID="DCausa3" runat="server" 
                                DataSourceID="SCausa3" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCausa3" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT cnoId id,cnoDescripcion nombre FROM causa_novedad WHERE cnoTipoNovedad=4 ORDER BY 2">
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
    <div id="tnov-5" class="hidet">
        <table width="100%">
            <tr>
                <td style="width: 85px; text-align:left;">Causa</td>
                <td><asp:DropDownList ID="DCausa5" runat="server" 
                                DataSourceID="SCausa5" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCausa5" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT cnoId id,cnoDescripcion nombre FROM causa_novedad WHERE cnoTipoNovedad=6 ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>Nuevo servicio</td>
                <td>
                <asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hidet"></asp:TextBox>
                </td>
            </tr>
        </table>
    </div>
    <div id="tnov-2" class="hidet">
        <table width="100%">
            <tr>
                <td style="width: 85px; text-align:left;">Causa</td>
                <td><asp:DropDownList ID="DCausa2" runat="server" 
                                DataSourceID="SCausa2" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCausa2" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT cnoId id,cnoDescripcion nombre FROM causa_novedad WHERE cnoTipoNovedad=2 ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td>Profesional</td>
                <td>
                <asp:TextBox Width="99%" runat="server" ID="TProfesional"></asp:TextBox>
                <asp:TextBox runat="server" ID="TProfesionalID" CssClass="hidet"></asp:TextBox>
                </td>
            </tr>
        </table>
    </div>
    <div id="tnov-4" class="hidet">
        <table width="100%">
            <tr>
                <td style="width: 85px; text-align:left;">Causa</td>
                <td><asp:DropDownList ID="DCausa4" runat="server" 
                                DataSourceID="SCausa4" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SCausa4" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT cnoId id,cnoDescripcion nombre FROM causa_novedad WHERE cnoTipoNovedad=5 ORDER BY 2">
                </asp:SqlDataSource></td>
            </tr>
        </table>
    </div>
    <div id="tnov-6" class="hidet">
    </div>
</div>
</asp:Panel>
<div>
<asp:Panel runat="server" ID="PEdicion2">
<table width="100%">
<tr>
    <td style="width: 100px;">Observaciones</td>
    <td><asp:TextBox ID="TObservaciones" TextMode="Multiline" runat="server" Width="99%"></asp:TextBox></td>
</tr>
</table>
<br />
<br />
</asp:Panel>
    <asp:GridView ID="GNovedades" runat="server" AllowPaging="True" 
        AutoGenerateColumns="False" DataSourceID="SNovedades" 
        EmptyDataText="No se encontraron novedades" DataKeyNames="novIden" 
        AllowSorting="true">
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField DataField="cnoDescripcion" HeaderText="Tipo de Novedad" SortExpression="cnoDescripcion" />
            <asp:BoundField DataField="novedad" HeaderText="Causa" SortExpression="novedad" />
            <asp:BoundField DataField="perNombre" HeaderText="Profesional Involucrado" SortExpression="perNombre" />
            <asp:BoundField DataField="personal" HeaderText="Profesional Asignado" SortExpression="personal" />
            <asp:BoundField DataField="novObs" HeaderText="Observaciones" SortExpression="novObs" />
            <asp:BoundField DataField="segUsuarioRegistro" HeaderText="Usuario" SortExpression="segUsuarioRegistro" />
            <asp:BoundField DataField="segFechaRegistro" HeaderText="Fecha" SortExpression="segFechaRegistro" DataFormatString="{0:d}" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SNovedades" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT 
                        programacion_novedad.novIden,causa_novedad.cnoDescripcion,personalAnt.perNombre,recurso_humano.perNombre AS personal
                        ,programacion_novedad.novObs,programacion_novedad.segUsuarioRegistro,programacion_novedad.segFechaRegistro
                        ,programacion_novedad.novTipo
                        ,CASE programacion_novedad.novTipo WHEN 1 THEN 'Cancelación Programación' WHEN 2 THEN 'Reasignación' WHEN 3 THEN 'Cambio en num. sesiones' WHEN 4 THEN 'Otro' WHEN 5 THEN 'Paciente desprotegido' WHEN 6 THEN 'Cambio Servicio' ELSE NULL END AS novedad
                        FROM programacion_novedad
                        LEFT JOIN recurso_humano ON (programacion_novedad.perId = recurso_humano.perId)
                        LEFT JOIN recurso_humano AS personalAnt ON (programacion_novedad.perIdAnt = personalAnt.perId) OR (programacion_novedad.perIdAnt IS NULL AND personalAnt.perId IS NULL)
                        LEFT JOIN causa_novedad ON (programacion_novedad.cnoId = causa_novedad.cnoId)
                        WHERE programacion_novedad.prgId=@programacion ORDER BY programacion_novedad.segFechaRegistro DESC"
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
