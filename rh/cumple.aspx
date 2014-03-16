<%@ Page Title="Cumpleaños" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="cumple.aspx.cs" Inherits="rh_cumple" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <script type="text/javascript">
    $(function() {
        addDialog('#<%= PEnviar.ClientID%>', "#dEnviar");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Desde</td>
            <td>
                Hasta</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:TextBox ID="TInicio" runat="server" CssClass="fecha" Text=""></asp:TextBox>
                <asp:RangeValidator ID="RangeValidator1" runat="server" 
                    ControlToValidate="TInicio" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese una fecha valida." MaximumValue="01/01/3000" 
                    MinimumValue="01/01/1900" SetFocusOnError="True" Text="*" Type="Date"></asp:RangeValidator>
            </td>
            <td>
                <asp:TextBox ID="TFin" runat="server" CssClass="fecha" Text=""></asp:TextBox>
                <asp:RangeValidator ID="RangeValidator2" runat="server" 
                    ControlToValidate="TFin" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese una fecha valida." MaximumValue="01/01/3000" 
                    MinimumValue="01/01/1900" SetFocusOnError="True" Text="*" Type="Date"></asp:RangeValidator>
            </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" OnClick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Width="100%"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron cumpleañeros" DataKeyNames="id"
        AllowPaging="True" PageSize="50" AllowSorting="True" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
           <asp:HyperLinkField DataTextField="nombres" HeaderText="Nombres" 
                DataNavigateUrlFields="id" 
                DataNavigateUrlFormatString="~/rh/Default.aspx?fid={0}" SortExpression="nombres" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Cargo" DataField="cargo" SortExpression="cargo" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Fecha Nacimiento" DataField="perFechaNac" SortExpression="perFechaNac" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Correo electrónico" SortExpression="perCorreoElectronico" DataField="perCorreoElectronico" />
            <asp:BoundField HeaderText="Teléfono movil" DataField="celular" SortExpression="celular">
                <ItemStyle HorizontalAlign="Right" />
            </asp:BoundField>
            <asp:TemplateField HeaderText="Enviada" ItemStyle-HorizontalAlign="Right">
                <ItemTemplate>
                    <asp:CheckBox runat="server" Enabled="false" ID="CEnviado" Checked='<%# Eval("actual").ToString()==Eval("felicitacion").ToString() %>'  />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    </div>
    <br />
    <asp:LinkButton Text="Enviar correo de felicitación" runat="server" ID="LEnviar" onclick="LEnviar_Click"></asp:LinkButton>
    <asp:Panel runat="server" ID="PEnviar" Visible="false">
        <div id="dEnviar" title="Enviar correo" class="hide">
            <table>
                <tr><td>Plantilla</td><td>
                    <asp:DropDownList ID="DPlantilla" runat="server" DataSourceID="SPlantilla" 
                        DataTextField="nombre" DataValueField="id" AutoPostBack="True" 
                        onselectedindexchanged="DPlantilla_SelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SPlantilla" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT plantId AS id,plantAsunto AS nombre FROM plantilla_correo WHERE plantTipo=1">
                    </asp:SqlDataSource>
                </td></tr>
                <tr><td colspan=2><asp:TextBox runat="server" ID="TMensaje" Width="500" Height="200" TextMode="MultiLine"></asp:TextBox></td></tr>
                <tr><td colspan=2 align="right">
                <asp:Button runat="server" Text="Aceptar" ID="BAceptar" onclick="BAceptar_Click" />
                    <asp:Button runat="server" ID="BCancelar" Text="Cancelar" onclick="BCancelar_Click" />
                </td></tr>
            </table>
        </div>
    </asp:Panel>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT per.perId AS id,per.perNombre AS nombres,  per.perFechaNac,cargo.carDescripcion AS cargo,perCorreoElectronico,per.perCelular AS celular,YEAR(SYSDATE()) AS actual, per.felicitacion
                ,MONTH(perFechaNac)*100+DAY(perFechaNac) AS ordenardias
                FROM recurso_humano per  
                LEFT JOIN cargo on per.carId = cargo.carId    
				WHERE per.eEstId=1 
				AND perFechaNac+INTERVAL (YEAR(SYSDATE())-YEAR(per.perFechaNac)) YEAR BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
				ORDER BY ordenardias">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

