<%@ Page Title="Programación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="rh_programacion" Codebehind="programacion.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= TProcedimiento.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetMedicamentos",
            data: { t: 173 },
            idField: "<%= TProcedimientoID.ClientID %>"
        });

        $("#<%= TPersonal.ClientID %>")._autoComplete({
            url: "../webservices/servicios.asmx/GetPersonal",
            idField: "<%= TPersonalID.ClientID %>"
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Inicio</td>
            <td>Fin</td>
            <td>Asegurador</td>
            <td style="white-space: nowrap">Actividad o CUPS</td>
            <td>Profesional</td>
            <td><asp:Label runat="server" ID="LArea">Área</asp:Label></td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TInicio" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFin" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFin" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:DropDownList ID="DAsegurador" runat="server" CssClass="anchomaxcombo"
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
            <asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hidet"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox Width="99%" runat="server" ID="TPersonal"></asp:TextBox><asp:TextBox runat="server" ID="TPersonalID" CssClass="hidet"></asp:TextBox>
            </td>
            <td><asp:DropDownList ID="DArea" runat="server" DataSourceID="SArea"  CssClass="anchomaxcombo"
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SArea" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT CAST(IFNULL(GROUP_CONCAT(medicamentos.id),-1) AS CHAR) AS id, varios.nombre FROM varios LEFT JOIN medicamentos ON (medicamentos.grupo=varios.id) WHERE varios.tipo=22 AND varios.szReservado IS NULL GROUP BY varios.id ORDER BY varios.nombre;">
                </asp:SqlDataSource>
            </td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" OnClick="BBuscar_Click" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <asp:UpdatePanel ID="PResultados" runat="server">
        <ContentTemplate>
            <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
                AutoGenerateColumns="False" EmptyDataText="No se encontraron resultados"
                AllowPaging="True" PageSize="50" AllowSorting="True">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:HyperLinkField HeaderText="Profesional" DataNavigateUrlFields="perId" DataTextField="perNombre" ItemStyle-Wrap="false" DataNavigateUrlFormatString="~/rh/funcionario.aspx?fid={0}" Target="_blank" />
                    <asp:TemplateField HeaderText="Documento" SortExpression="pacDocumento" ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:HyperLink Enabled='<%# CUsuario.GetInstance().CanInsert() %>' runat="server" ID="H" Text='<%# Eval("pacDocumento") %>' NavigateUrl='<%# string.Format("~/programacion/programacion.aspx?pid={0}", Eval("pacId")) %>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paciente" SortExpression="pacNombres" ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <asp:HyperLink Enabled='<%# CUsuario.GetInstance().CanInsert() %>' runat="server" ID="D" Text='<%# Eval("pacNombres") %>' NavigateUrl='<%# string.Format("~/programacion/programacion.aspx?pid={0}", Eval("pacId")) %>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-Wrap="false"/>
                    <asp:BoundField HeaderText="Actividad" DataField="actividad" SortExpression="actividad" ItemStyle-Wrap="false" HtmlEncode="false" />
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT paciente.pacDocumento,paciente.pacNombres,paciente.pacId
                                ,asegurador.entNombre
                                ,recurso_humano.perNombre
                                ,programacion.perId
                                ,GROUP_CONCAT(DISTINCT medicamentos.nombre SEPARATOR '<br/>') AS actividad
                                FROM programacion
                                LEFT JOIN paciente ON (paciente.pacId=programacion.pacId)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                                LEFT JOIN recurso_humano ON (recurso_humano.perId=programacion.perId)
                                LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId)
                            WHERE DATE(programacion.prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND programacion.prgActivo=1
                            AND (@asegurador=0 OR programacion.entId=@asegurador)
                            AND (@personal=0 OR programacion.perId=@personal)
                            AND (@procedimiento=0 OR programacion.actId=@procedimiento)
                            AND ('@area'='0' OR programacion.actId IN (@area))
                            {0}
                            GROUP BY programacion.perId,programacion.pacId
                            ORDER BY recurso_humano.perNombre">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="TPersonalID" Name="personal" PropertyName="Text" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

