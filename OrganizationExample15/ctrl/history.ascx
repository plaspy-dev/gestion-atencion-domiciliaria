<%@ Control Language="C#" AutoEventWireup="true" CodeFile="history.ascx.cs" Inherits="ctrl_history" %>
<script type="text/javascript">
$(function () {
    $("#<%= PH.ClientID %>").accordion({
        autoHeight: false,
        collapsible: true,
        active: false
    });
});
</script>
<asp:Panel ID="PH" runat="server" Visible="false">
    <h3><a href="#"><asp:Label runat="server" ID="LH"></asp:Label></a></h3>
    <div class="hidet">
        <asp:UpdatePanel runat="server" ID="U" UpdateMode="Conditional">
            <ContentTemplate>
        <asp:GridView ID="GH" runat="server" AutoGenerateColumns="False" Width="100%" 
            DataSourceID="SH" AllowPaging="true" PageSize="10"
            EmptyDataText="No se encontraron resultados">
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Columns>
                <asp:TemplateField ItemStyle-Width="1px">
                    <ItemTemplate>
                        <asp:HyperLink runat="server" ID="L" CssClass="btn btn-success btn-xs" NavigateUrl='<%# string.Format(GetURL(), Eval("paciente"), Eval("id")) %>'>
                            <i class="fa fa-edit"></i>
                        </asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="fecha" HeaderText="Fecha" ItemStyle-Wrap="false" />
                <asp:BoundField DataField="funcionario" HeaderText="Funcionario" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SH" runat="server" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            SelectCommand="SELECT evolucion_terapeutivo.id,evolucion_terapeutivo.fecha
                        ,recurso_humano.perNombre, CONCAT(medicamentos.codigo, ' - ',medicamentos.nombre) AS nombre
                        ,evolucion_terapeutivo.sesion
                        ,evolucion_terapeutivo.paciente
                        ,evolucion_terapeutivo.logros
                        FROM evolucion_terapeutivo
                        LEFT JOIN medicamentos ON (medicamentos.id=evolucion_terapeutivo.tipo)
                        LEFT JOIN recurso_humano ON (recurso_humano.perId=evolucion_terapeutivo.funcionario)
                        WHERE evolucion_terapeutivo.paciente=@paciente
                        ORDER BY fecha DESC;">
            <SelectParameters>
                <asp:Parameter Name="paciente" />
            </SelectParameters>
        </asp:SqlDataSource>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Panel><br />