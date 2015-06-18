<%@ Control Language="C#" AutoEventWireup="true" CodeFile="digitalizacionc.ascx.cs" Inherits="archivo_digitalizacionc" %>
<asp:UpdatePanel runat="server" ID="UA" UpdateMode="Conditional" Visible="false">
    <ContentTemplate>
        <h3><a href="#"><asp:Label runat="server" ID="LArchivo"></asp:Label></a></h3>
        <div class="hide">
            <asp:GridView ID="GArchivo" runat="server" AutoGenerateColumns="False" DataSourceID="SArchivo" 
                EmptyDataText="No se encontraron archivos" AllowPaging="false" Width="100%">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="fecha" HeaderText="Fecha" SortExpression="fecha" DataFormatString="{0:d}" />
                    <asp:HyperLinkField HeaderText="Archivo" SortExpression="archivo" DataNavigateUrlFields="archivo" DataNavigateUrlFormatString="~/archivo/archivo.ashx?n={0}.tif&t=d" DataTextField="archivo" ItemStyle-Width="100%" />
                </Columns>
            </asp:GridView>
                <asp:SqlDataSource ID="SArchivo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT fecha,archivo
                                FROM digitalizacion
                                WHERE @paciente=digitalizacion.paciente
                                ORDER BY fecha DESC
                                ">
                      <SelectParameters>
                        <asp:Parameter Name="paciente" />
                      </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>