<%@ Page Title="Directorio" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="directorio_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
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
    function iniciopagina() {
        
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

                    location.href = location.href + "?id=" + ui.item.value;
                    return true;
                }
            });
    }
    $(function() {
        $('#<%= UResultados.ClientID %>').panelUpdated(function() {
            $("#dResultados").attr("title", $("#ctl00_cph_DeDisponibilidad_LNombres").html());
            $("#ctl00_cph_DeDisponibilidad_LNombres").hide();
            addDialog('#<%= UResultados.ClientID%>', "#dResultados");
        });
    }
    );
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:UpdatePanel ID="UResultados" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Estado</td>
            <td>
                <asp:DropDownList ID="DEStado" runat="server" AppendDataBoundItems="true" 
                    DataSourceID="SEstado" DataTextField="nombre" DataValueField="id" 
                    AutoPostBack="True">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstado" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT eEstId AS id,eEstDesc AS nombre FROM admEstadoEstancia">
                </asp:SqlDataSource>
            </td>
            <td>
                Nombres o documento</td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
            </td>
            <td>
                Cargo</td>
            <td>
                <asp:DropDownList ID="DCargo" runat="server" AppendDataBoundItems="true" 
                    DataSourceID="SCargo" DataTextField="nombre" DataValueField="id" 
                    AutoPostBack="True">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SCargo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT carId AS id,carDescripcion AS nombre FROM admCargo">
                </asp:SqlDataSource>
            </td>
            <td>
                Disponibilidad</td>
            <td>
                <asp:DropDownList ID="DDisponibilidad" runat="server" AppendDataBoundItems="true" 
                    DataSourceID="SDisponibilidad" DataTextField="nombre" DataValueField="id" 
                    AutoPostBack="True">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SDisponibilidad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT dispId AS id,dispDescripcion AS nombre FROM admdisponibilidad">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" />
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
                    DataNavigateUrlFormatString="~/directorio/Default.aspx?id={0}" >
                <ItemStyle HorizontalAlign="Right" />
                </asp:HyperLinkField>
               <asp:HyperLinkField DataTextField="nombres" HeaderText="Nombres" 
                    DataNavigateUrlFields="id" 
                    DataNavigateUrlFormatString="~/directorio/Default.aspx?id={0}" SortExpression="nombres" >
                    <ItemStyle Wrap="False" />
                </asp:HyperLinkField>
                <asp:BoundField HeaderText="Cargo" DataField="cargo" SortExpression="cargo">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Disponibilidad" DataField="dispDescripcion" SortExpression="dispDescripcion">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
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
                <asp:BoundField HeaderText="Próxima programación" DataField="fecha" SortExpression="fecha" DataFormatString="{0:d}">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Próximo paciente" DataField="nombre" SortExpression="nombre">
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
                    SelectCommand="SELECT per.perId AS id,per.perDocumento AS documento, per.perNombre AS nombres,
                    admCargo.carDescripcion AS cargo,admEstadoEstancia.eEstDesc AS estado,per.perCelular AS celular,
                    per.perDireccion, per.perBarrio, admDisponibilidad.dispDescripcion,
                    prog.fecha,
                    ISNULL(per.perTelefono, '') + ' '+ ISNULL(per.perTelefono1, '') AS telefono,per.perCorreoElectronico,
                    prog.nombre
                    FROM admPersonalHS per 
                    LEFT JOIN admCargo on per.carId = admCargo.carId 
                    LEFT JOIN admDisponibilidad on admDisponibilidad.dispId = per.dispId 
                    LEFT JOIN admEstadoEstancia ON (admEstadoEstancia.eEstId=per.eEstId) 
                    OUTER APPLY (
                        SELECT TOP 1 atxProgramacion.prgFechaProg AS fecha, (phdPaciente.pacPNombre + ' ' + phdPaciente.pacPApellido) AS nombre FROM atxProgramacion LEFT JOIN phdPaciente ON (phdPaciente.pacId=atxProgramacion.pacId) WHERE atxProgramacion.perId=per.perId AND atxProgramacion.prgFechaProg>getdate() ORDER BY atxProgramacion.prgFechaProg
                    ) AS prog
                    WHERE 
                    (@id=0 OR @id=per.perId) 
                    AND (@estado=0 OR per.eEstId=@estado) 
                    AND (@cargo=0 or per.carId=@cargo) 
                    AND (@disponibilidad=0 OR per.dispId=@disponibilidad)
                    AND (@nombres=' ' OR per.perNombre LIKE '%' + @nombres + '%' )
                    ORDER BY per.perNombre">
                     <SelectParameters>
                        <asp:ControlParameter ControlID="DEStado" PropertyName="SelectedValue" Name="estado" />
                        <asp:ControlParameter ControlID="DCargo" PropertyName="SelectedValue" Name="cargo" />
                        <asp:ControlParameter ControlID="DDisponibilidad" PropertyName="SelectedValue" Name="disponibilidad" />
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
    </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

