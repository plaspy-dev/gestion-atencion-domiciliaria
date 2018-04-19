<%@ Page Title="Directorio" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="directorio_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function () {
        $("#<%= TNombres.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetPersonal",
            idField: "<%= TNombreID.ClientID %>",
            onSelect: function () {
                $("#<%= BBuscar.ClientID %>").click();
            }
        });
        $("#dResultados").attr("title", $("#ctl00_cph_DeDisponibilidad_LNombres").html());
        $("#ctl00_cph_DeDisponibilidad_LNombres").hide();
        addDialog('#<%= PBuscar.ClientID%>', "#dResultados");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Estado</td>
            <td>
                Nombres o documento</td>
            <td>
                Área</td>
            <td>
                Cargo</td>
            <td>
                Disponibilidad</td>
            <td>
                Complejidad</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:DropDownList ID="DEStado" runat="server" AppendDataBoundItems="true" CssClass="anchomaxcombo"
                    AutoPostBack="True" DataSourceID="SEstado" DataTextField="nombre" 
                    DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstado" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT eEstId AS id,eEstDesc AS nombre FROM funcionario_estados">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
                <asp:TextBox ID="TNombreID" CssClass="hidet" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:DropDownList ID="DArea" runat="server" AppendDataBoundItems="true" AutoPostBack="true" CssClass="anchomaxcombo" 
                        DataSourceID="SArea" DataTextField="nombre" DataValueField="id">
                        <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SArea" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT areaId id,areaDesc nombre FROM area ORDER BY 2">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList ID="DCargo" runat="server" AppendDataBoundItems="true" CssClass="anchomaxcombo"
                    AutoPostBack="True" DataSourceID="SCargo" DataTextField="nombre" 
                    DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SCargo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT carId AS id,carDescripcion AS nombre FROM cargo WHERE 1=1 {0} ORDER BY carDescripcion">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList ID="DDisponibilidad" runat="server" 
                    AppendDataBoundItems="true" AutoPostBack="True" DataSourceID="SDisponibilidad" CssClass="anchomaxcombo" 
                    DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SDisponibilidad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT dispId AS id,dispDescripcion AS nombre FROM disponibilidad ORDER BY dispDescripcion">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList ID="DNivelComplejidad" runat="server" AppendDataBoundItems="true" DataSourceID="SNivelComplejidad" DataTextField="nombre" DataValueField="id" CssClass="anchomaxcombo">
                        <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SNivelComplejidad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT nivCompId id,nivCompDesc nombre FROM nivel_complejidad ORDER BY 2">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" />
            </td>
            <td>
                </td>
                <td>
                </td>
                <td>
                </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados"  DataKeyNames="id"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron recursos humanos" 
            AllowPaging="True" PageSize="50" AllowSorting="True">
            <Columns>
                <asp:HyperLinkField DataTextField="documento" HeaderText="Documento" 
                    DataNavigateUrlFields="id" SortExpression="documento"
                    DataNavigateUrlFormatString="~/directorio/Default.aspx?fiid={0}" >
                <ItemStyle HorizontalAlign="Right" />
                </asp:HyperLinkField>
               <asp:HyperLinkField DataTextField="nombres" HeaderText="Nombres" 
                    DataNavigateUrlFields="id" 
                    DataNavigateUrlFormatString="~/directorio/Default.aspx?fiid={0}" SortExpression="nombres" >
                    <ItemStyle Wrap="False" />
                </asp:HyperLinkField>
                <asp:BoundField HeaderText="Cargo" DataField="cargo" SortExpression="cargo">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Disponibilidad" DataField="dispDescripcion" SortExpression="dispDescripcion"><ItemStyle Wrap="False" /></asp:BoundField>
                <asp:TemplateField HeaderText="Disponibilidad " InsertVisible="False" SortExpression="dispDescripcion">
                    <ItemTemplate>
                        <asp:LinkButton ID="LDisponibilidad" runat="server" CausesValidation="False" CommandName="Select" Text='<%# Bind("dispDescripcion") %>'></asp:LinkButton>
                    </ItemTemplate>
                    <ItemStyle Wrap="False" />
                </asp:TemplateField>
                <asp:BoundField HeaderText="Teléfonos" DataField="telefono" SortExpression="telefono">
                    <ItemStyle Wrap="false" HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Teléfono movil" DataField="celular" SortExpression="celular">
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Dirección" DataField="perDireccion" SortExpression="perDireccion">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Barrio" DataField="perBarrio" SortExpression="perBarrio">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Nivel complejidad" DataField="nivCompDesc" SortExpression="nivCompDesc" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="L. Trabajo" DataField="loctrabajo" SortExpression="loctrabajo">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="L. Residencia" DataField="locresidencia" SortExpression="locresidencia">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Paciente actual" DataField="nombrehoy" SortExpression="nombrehoy">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Próximo paciente" DataField="nombre" SortExpression="nombre">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Próxima programación" DataField="fecha" SortExpression="fecha" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="E-Mail" DataField="perCorreoElectronico" SortExpression="perCorreoElectronico"/>
                <asp:BoundField HeaderText="Estado" DataField="estado" SortExpression="estado"/>
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
        <asp:SqlDataSource ID="SResultados" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT per.perId AS id
					,per.perDocumento AS documento, per.perNombre AS nombres,
                    cargo.carDescripcion AS cargo,funcionario_estados.eEstDesc AS estado,per.perCelular AS celular,
                    per.perDireccion, per.perBarrio, disponibilidad.dispDescripcion
                    ,loctrabajo.locDescripcion AS loctrabajo,locresidencia.locDescripcion AS locresidencia
                    ,CONCAT(IFNULL(per.perTelefono, ''), ' ', IFNULL(per.perTelefono1, '')) AS telefono,per.perCorreoElectronico
					,directorio.fechaf AS fecha
					,CONCAT(IFNULL(pacientef.pacNombres,''),CASE WHEN directorio.actm IN (10001,10009,10012,10013,10015) THEN ' (Descansando)' ELSE '' END) AS nombre
					,CONCAT(IFNULL(paciente.pacNombres,''), CASE WHEN directorio.acta IN (10001,10009,10012,10013,10015) THEN ' (Descansando)' ELSE '' END) AS nombrehoy
					,nivel_complejidad.nivCompDesc
                    FROM recurso_humano per 
                    LEFT JOIN cargo on per.carId = cargo.carId 
                    LEFT JOIN disponibilidad on disponibilidad.dispId = per.dispId 
                    LEFT JOIN funcionario_estados ON (funcionario_estados.eEstId=per.eEstId)
                    LEFT JOIN localidad AS loctrabajo ON (loctrabajo.locId=per.locId)
                    LEFT JOIN localidad AS locresidencia ON (locresidencia.locId=per.residencialocId)
                    LEFT JOIN nivel_complejidad ON (nivel_complejidad.nivCompId=per.nivCompId)
                    LEFT JOIN directorio ON (directorio.perId=per.perId)
                    LEFT JOIN paciente ON (directorio.pacienteh=paciente.pacId)
                    LEFT JOIN paciente AS pacientef ON (directorio.pacientef=pacientef.pacId)
                    WHERE 
                    (@personalID!=0 AND per.perId=@personalID) OR (
                    @personalID=0
                    AND (@id!=0 OR @estado=0 OR per.eEstId=@estado) 
                    AND (@id!=0 OR @cargo=0 OR @cargo=per.carId OR FIND_IN_SET(@cargo, per.cargos)!=0) 
                    AND (@id!=0 OR @complejidad=0 OR per.nivCompId=@complejidad)
                    AND (@id!=0 OR @disponibilidad=0 OR per.dispId=@disponibilidad)
                    AND (@id!=0 OR @area=0 OR @area=per.areaId)
                    AND (@id!=0 OR @nombres=' ' OR per.perNombre LIKE CONCAT('%',@nombres,'%') )
                    {0})
                    GROUP BY per.perId
                    ORDER BY per.perNombre">
                     <SelectParameters>
                        <asp:ControlParameter ControlID="DEStado" PropertyName="SelectedValue" Name="estado" />
                        <asp:ControlParameter ControlID="DCargo" PropertyName="SelectedValue" Name="cargo" />
                        <asp:ControlParameter ControlID="DDisponibilidad" PropertyName="SelectedValue" Name="disponibilidad" />
                        <asp:ControlParameter ControlID="DArea" PropertyName="SelectedValue" Name="area" />
                        <asp:ControlParameter ControlID="DNivelComplejidad" PropertyName="SelectedValue" Name="complejidad" />
                        <asp:ControlParameter ControlID="TNombres" Name="nombres" PropertyName="Text" DefaultValue=" " />
                        <asp:ControlParameter ControlID="TNombreID" Name="personalID" DefaultValue="0" />
                     </SelectParameters>
        </asp:SqlDataSource>        
        <div id="dResultados" title="Disponiblidad">
            <asp:DetailsView ID="DeDisponibilidad" runat="server" Width="100%" 
                DataSourceID="SDDisponibilidad" DataKeyNames="perId" 
                AutoGenerateRows="False" DefaultMode="Edit" 
                onitemcommand="DeDisponibilidad_ItemCommand" 
                onitemupdated="DeDisponibilidad_ItemUpdated" >
                <Fields>
                    <asp:TemplateField HeaderText="Disponibilidad">
                        <EditItemTemplate>
                            <asp:Label runat="server" ID="LNombres" Text='<%# Bind("perNombre") %>'></asp:Label>
                            <asp:DropDownList ID="DDisponibilidadD" runat="server" DataSourceID="SDisponibilidadD" SelectedValue='<%# Bind("dispId") %>'
                                DataTextField="nombre" DataValueField="id">
                                </asp:DropDownList>
                            <asp:SqlDataSource ID="SDisponibilidadD" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT dispId AS id,dispDescripcion AS nombre FROM disponibilidad">
                            </asp:SqlDataSource>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <asp:SqlDataSource ID="SDDisponibilidad" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT perId,dispId,perNombre FROM recurso_humano WHERE perId=@id"
                            UpdateCommand="UPDATE recurso_humano SET dispId=@dispId WHERE perId=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GResultados" DefaultValue="-1" PropertyName="SelectedValue" Name="id" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:ControlParameter ControlID="GResultados" DefaultValue="-1" PropertyName="SelectedValue" Name="id" />
                            </UpdateParameters>
            </asp:SqlDataSource>
</asp:Content>

