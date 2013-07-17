<%@ Page Title="Directorio" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="directorio_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        $("#<%= TNombres.ClientID %>").autocomplete({
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

                $.goURL("fiid=" + ui.item.value);
                return true;
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
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:DropDownList ID="DEStado" runat="server" AppendDataBoundItems="true" 
                    AutoPostBack="True" DataSourceID="SEstado" DataTextField="nombre" 
                    DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstado" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT eEstId AS id,eEstDesc AS nombre FROM admEstadoEstancia">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:DropDownList ID="DArea" runat="server" AppendDataBoundItems="true" AutoPostBack="true" 
                        DataSourceID="SArea" DataTextField="nombre" DataValueField="id">
                        <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SArea" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT areaId id,areaDesc nombre FROM dbo.admArea ORDER BY 2">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList ID="DCargo" runat="server" AppendDataBoundItems="true" 
                    AutoPostBack="True" DataSourceID="SCargo" DataTextField="nombre" 
                    DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SCargo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT carId AS id,carDescripcion AS nombre FROM admCargo WHERE 1=1 {0} ORDER BY carDescripcion">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList ID="DDisponibilidad" runat="server" 
                    AppendDataBoundItems="true" AutoPostBack="True" DataSourceID="SDisponibilidad" 
                    DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SDisponibilidad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT dispId AS id,dispDescripcion AS nombre FROM admdisponibilidad ORDER BY dispDescripcion">
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
                <td>
                </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados"  DataKeyNames="id"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron recursos humanos" 
            AllowPaging="True" PageSize="50" AllowSorting="True" >
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
                <asp:TemplateField HeaderText="Disponibilidad" InsertVisible="False" SortExpression="dispDescripcion">
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
                <asp:BoundField HeaderText="Próxima programación" DataField="fecha" SortExpression="fecha" DataFormatString="{0:d}">
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
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT per.perId AS id
					,per.perDocumento AS documento, per.perNombre AS nombres,
                    admCargo.carDescripcion AS cargo,admEstadoEstancia.eEstDesc AS estado,per.perCelular AS celular,
                    per.perDireccion, per.perBarrio, admDisponibilidad.dispDescripcion
                    ,loctrabajo.locDescripcion AS loctrabajo,locresidencia.locDescripcion AS locresidencia
                    ,ISNULL(per.perTelefono, '') + ' '+ ISNULL(per.perTelefono1, '') AS telefono,per.perCorreoElectronico
					,futuro.prgFechaProg AS fecha
					,ISNULL(phdPacientef.pacNombres,'') + CASE WHEN manana.actId IN (10001,10009,10012,10013,10015) THEN ' (Descansando)' ELSE '' END AS nombre
					,ISNULL(phdPaciente.pacNombres,'')  + CASE WHEN ayer.perId IN (10001,10009,10012,10013,10015) THEN ' (Descansando)' ELSE '' END AS nombrehoy
                    FROM admPersonalHS per 
                    LEFT JOIN admCargo on per.carId = admCargo.carId 
                    LEFT JOIN admDisponibilidad on admDisponibilidad.dispId = per.dispId 
                    LEFT JOIN admEstadoEstancia ON (admEstadoEstancia.eEstId=per.eEstId)
                    LEFT JOIN admLocalidad AS loctrabajo ON (loctrabajo.locId=per.locId)
                    LEFT JOIN admLocalidad AS locresidencia ON (locresidencia.locId=per.residencialocId)
					LEFT JOIN (SELECT perId,MIN(actId) AS actId FROM programacion WHERE programacion.prgFechaProg=DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()-1)) AND actId IN (10001,10009,10012,10013,10015) GROUP BY perId) AS ayer ON (ayer.perId=per.perId)
					LEFT JOIN (SELECT perId,MIN(actId) AS actId FROM programacion WHERE programacion.prgFechaProg=DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()+1)) AND actId IN (10001,10009,10012,10013,10015) GROUP BY perId) AS manana ON (manana.perId=per.perId)
					LEFT JOIN (SELECT perId,MIN(pacId) AS pacId FROM programacion WHERE programacion.prgFechaProg=DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) GROUP BY perId) AS hoy ON (hoy.perId=per.perId)
					LEFT JOIN (SELECT perId,MIN(prgFechaProg) AS prgFechaProg,MIN(pacId) AS pacId FROM programacion WHERE programacion.prgFechaProg>GETDATE() GROUP BY perId) AS futuro ON (futuro.perId=per.perId)
					LEFT JOIN phdPaciente ON (hoy.pacId=phdPaciente.pacId)
					LEFT JOIN phdPaciente AS phdPacientef ON (hoy.pacId=phdPacientef.pacId)
                    WHERE 
                    (@id=0 OR @id=per.perId)
                    AND (@id!=0 OR @estado=0 OR per.eEstId=@estado) 
                    {0}
                    AND (@id!=0 OR @cargo=0 or per.carId=@cargo) 
                    AND (@id!=0 OR @disponibilidad=0 OR per.dispId=@disponibilidad)
                    AND (@id!=0 OR @area=0 OR @area=per.areaId)
                    AND (@id!=0 OR @nombres=' ' OR per.perNombre LIKE '%' + @nombres + '%' )
                    ORDER BY per.perNombre">
                     <SelectParameters>
                        <asp:ControlParameter ControlID="DEStado" PropertyName="SelectedValue" Name="estado" />
                        <asp:ControlParameter ControlID="DCargo" PropertyName="SelectedValue" Name="cargo" />
                        <asp:ControlParameter ControlID="DDisponibilidad" PropertyName="SelectedValue" Name="disponibilidad" />
                        <asp:ControlParameter ControlID="DArea" PropertyName="SelectedValue" Name="area" />
                        <asp:ControlParameter ControlID="TNombres" Name="nombres" PropertyName="Text" DefaultValue=" " />
                        <asp:SessionParameter SessionField="directorioid" Name="id" DefaultValue="0" />
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
                                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                                SelectCommand="SELECT dispId AS id,dispDescripcion AS nombre FROM admdisponibilidad">
                            </asp:SqlDataSource>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <asp:SqlDataSource ID="SDDisponibilidad" runat="server" ConnectionString="<%$ ConnectionStrings:connBD %>" 
                            SelectCommand="SELECT perId,dispId,perNombre FROM admPersonalHS WHERE perId=@id"
                            UpdateCommand="UPDATE admPersonalHS SET dispId=@dispId WHERE perId=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GResultados" DefaultValue="-1" PropertyName="SelectedValue" Name="id" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:ControlParameter ControlID="GResultados" DefaultValue="-1" PropertyName="SelectedValue" Name="id" />
                            </UpdateParameters>
            </asp:SqlDataSource>
</asp:Content>

