<%@ Page Title="Listado pacientes" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="paciente_informes" Codebehind="informes.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        $("#<%= TNombres.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetPacienteI",
            data: { 'e': '<%= ViewState["entidades"].ToString() %>' },
			redirectURL: "<%= Request.Url.AbsolutePath + "?i=" %>"
        });
    });
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
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT estId id,estDesc nombre FROM paciente_estado">
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
                    DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" >
                <ItemStyle HorizontalAlign="Right" />
                </asp:HyperLinkField>
               <asp:HyperLinkField DataTextField="pacPNombre" HeaderText="Nombres" 
                    DataNavigateUrlFields="pacId" 
                    DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" SortExpression="pacPNombre" >
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
                <asp:TemplateField HeaderText="Activo" SortExpression="estId">
                    <ItemTemplate>
                        <asp:CheckBox runat="server" ID="C" Enabled="false" Checked='<%# Eval("estId").ToString()=="1" %>' />
                    </ItemTemplate>
                </asp:TemplateField>
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
                    SelectCommand="SELECT   
                                  pacId,  
                                  tdocDescripcion,  
                                  pacDocumento,  
                                  pacNombres AS pacPNombre,  
                                  year(NOW()-pacFechaNac-1)-1900 AS edad,
                                  pacBarrio,
                                  IFNULL(pacTelefono, '') + ' ' + IFNULL(pacTelefono1, '') AS telefono,
                                  pacCelular,
                                  pacEntregaSuministros,
                                  estId
                                 FROM paciente  
                                 INNER JOIN tipo_documento ON paciente.tdocId =tipo_documento.tdocId  
                                 where (@id=0 OR @id=pacId) AND 
                                        (@pacPNombre=' ' or (pacNombres like CONCAT('%',REPLACE(@pacPNombre,' ','%'),'%') or pacDocumento = @pacPNombre))
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

