<%@ Page Title="Planilla" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="farmacia_planilla" Codebehind="planilla.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table class="tablecollapse">
        <tr>
            <td>Desde</td>
            <td>Hasta</td>
            <td>Zona</td>
        </tr>
        <tr>
            <td>
                <asp:TextBox ID="TDesde" runat="server" CssClass="fecha" Text=""></asp:TextBox>
                <asp:RangeValidator ID="RangeValidator2" runat="server" Type="Date" ErrorMessage="Por favor ingrese una fecha valida." Text="*" MinimumValue="01/01/1900" MaximumValue="01/01/3000" SetFocusOnError="True" Display="Dynamic" ControlToValidate="TDesde"></asp:RangeValidator>
            </td>
            <td>
                <asp:TextBox ID="THasta" runat="server" CssClass="fecha" Text=""></asp:TextBox>
                <asp:RangeValidator ID="RangeValidator1" runat="server" 
                    ControlToValidate="THasta" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese una fecha valida." MaximumValue="01/01/3000" 
                    MinimumValue="01/01/1900" SetFocusOnError="True" Text="*" Type="Date"></asp:RangeValidator>
            </td>
            <td>
                <asp:DropDownList ID="DZona" runat="server" DataSourceID="SZona" AppendDataBoundItems="true" 
                    DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SZona" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=140 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
            </td>
            <td><asp:Button ID="BBuscar" runat="server" Text="Actualizar" onclick="BBuscar_Click" /></td>
        </tr>
    </table>
    </asp:Panel>
    <asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Visible="false"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron productos" 
        AllowSorting="True" DataKeyNames="id" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:TemplateField HeaderText="Número" SortExpression="id" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="n" Target="_blank" NavigateUrl='<%# "~/farmacia/salida.aspx?si=" + Eval("id").ToString() %>' Text='<%# Eval("id") %>'></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="Fecha" DataField="fecha" SortExpression="fecha" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" DataFormatString="{0:d}" />
            <asp:BoundField HeaderText="Paciente" DataField="paciente" SortExpression="paciente" FooterStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Asegurador" DataField="asegurador" SortExpression="asegurador" FooterStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Zona" DataField="zona" SortExpression="zona" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Dirección" DataField="pacDireccion" SortExpression="pacDireccion" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Teléfono" DataField="pacTelefono" SortExpression="pacTelefono" ItemStyle-Wrap="false" />
        </Columns>
    </asp:GridView>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT salida{0}.id,salida{0}.fecha
                            ,IFNULL(CONCAT(paciente.pacDocumento,' - ',paciente.pacNombres),'OrganizationExample15') AS paciente
                            ,paciente.pacDireccion
                            ,asegurador.entNombre AS asegurador
                            ,paciente.pacTelefono
                            ,salida{0}.paciente AS IdPaciente
                            ,zona.nombre AS zona
                            FROM salida{0}
                            LEFT JOIN paciente ON (paciente.pacId=salida{0}.paciente)
                            LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            LEFT JOIN varios AS centro_costo ON (centro_costo.id=salida{0}.centro_costos)
                            LEFT JOIN varios AS zona ON (zona.id=salida{0}.zona)
                        WHERE 
                        salida{0}.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                        AND (@zona=0 OR @zona=salida{0}.zona)
                        AND salida{0}.estado IS NULL
                        ORDER BY id">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" PropertyName="Text" Name="desde" />
                    <asp:ControlParameter ControlID="THasta" PropertyName="Text" Name="hasta" />
                    <asp:ControlParameter ControlID="DZona" PropertyName="SelectedValue" Name="zona" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

