<%@ Page Title="Informes" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informes.aspx.cs" Inherits="paciente_informes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    function iniciopagina() {
        // $(function() {
        $("#<%= TNombres.ClientID %>").autocomplete({
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
                $.goURL("i=" + ui.item.value);
                return false;
            }
        });
    }
    // });
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
                    SelectCommand="SELECT estId id,estDesc nombre FROM dbo.phdEstado">
                </asp:SqlDataSource>
            </td>
            <td>
                Nombres o documento</td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:CheckBox ID="CTerapias" runat="server" Text="Terapias" />
            </td>
            <td>
                <asp:CheckBox ID="CEnfermeria" runat="server" Text="Enfermeria" />
            </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados"  DataKeyNames="pacId"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron recursos humanos" 
            AllowPaging="True" PageSize="50" AllowSorting="True" >
            <Columns>
                <asp:BoundField DataField="tdocDescripcion" SortExpression="tdocDescripcion" HeaderText="TD" />
                <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Documento" 
                    DataNavigateUrlFields="pacId" SortExpression="pacDocumento"
                    DataNavigateUrlFormatString="~/paciente/paciente.aspx?id={0}" >
                <ItemStyle HorizontalAlign="Right" />
                </asp:HyperLinkField>
               <asp:HyperLinkField DataTextField="pacPNombre" HeaderText="Nombres" 
                    DataNavigateUrlFields="pacId" 
                    DataNavigateUrlFormatString="~/paciente/paciente.aspx?id={0}" SortExpression="pacPNombre" >
                    <ItemStyle Wrap="False" />
                </asp:HyperLinkField>
                <asp:BoundField HeaderText="Edad" DataField="edad" SortExpression="edad">
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Barrio" DataField="pacBarrio" SortExpression="pacBarrio">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Teléfonos" DataField="telefono" SortExpression="telefono">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Teléfono movil" DataField="pacCelular" SortExpression="pacCelular">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:CheckBoxField HeaderText="Suministros" SortExpression="pacEntregaSuministros" DataField="pacEntregaSuministros" />
                <asp:CheckBoxField HeaderText="Activo" SortExpression="estId" DataField="estId" />
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
                    SelectCommand="SELECT   
                                  pacId,  
                                  tdocDescripcion,  
                                  pacDocumento,  
                                  dbo.fnComNombre(pacPNombre,pacSNombre,pacPApellido,pacSApellido) pacPNombre,  
                                  year(getdate()-pacFechaNac-1)-1900 AS edad,
                                  pacBarrio,
                                  isnull(pacTelefono, '') + ' ' + isnull(pacTelefono1, '') AS telefono,
                                  pacCelular,
                                  pacEntregaSuministros,
                                  CAST(CASE WHEN estId=1 THEN 1 ELSE 0 END AS bit) AS estId
                                 FROM dbo.phdPaciente  
                                 INNER JOIN dbo.phdTipoDocumento ON phdPaciente.tdocId =phdTipoDocumento.tdocId  
                                 where (@id=0 OR @id=pacId) AND 
                                        (@pacPNombre=' ' or (dbo.fnComNombre(pacPNombre,pacSNombre,pacPApellido,pacSApellido) like '%'+REPLACE(@pacPNombre,' ','%')+'%' or pacDocumento = @pacPNombre))
		                                and (@pacTerapias=0 or (pacTerapiaFisica=1 or pacTerapiaResp=1 or pacTerapiaOcup=1 or pacTerapiaLenguaje=1))
		                                and (@pacEnfermeria=0 or (pacEnfermeria_12=1 or pacEnfermeria_24=1))
		                                and(@estado=0 or estId=@estado)
                                 ORDER BY pacPNombre">
                     <SelectParameters>
                        <asp:ControlParameter ControlID="DEStado" PropertyName="SelectedValue" Name="estado" />
                        <asp:ControlParameter ControlID="TNombres" Name="pacPNombre" PropertyName="Text" DefaultValue=" " />
                        <asp:ControlParameter ControlID="CTerapias" Name="pacTerapias" PropertyName="Checked" />
                        <asp:ControlParameter ControlID="CEnfermeria" Name="pacEnfermeria" PropertyName="Checked" />
                        <asp:SessionParameter SessionField="directorioid" Name="id" DefaultValue="0" />
                     </SelectParameters>
        </asp:SqlDataSource>
    </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

