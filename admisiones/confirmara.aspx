<%@ Page Title="Confirmar autorizaciones" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="confirmara.aspx.cs" Inherits="admisiones_confirmara" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Asegurador</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:DropDownList ID="DAsegurador" runat="server" AutoPostBack="true" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true" 
                    onselectedindexchanged="DAsegurador_SelectedIndexChanged">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM dbo.admEntidad WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" 
        PageSize="50" AllowSorting="True" DataKeyNames="autNumero">
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="autNumero" HeaderText="Autorización" 
                DataNavigateUrlFields="autNumero" 
                DataNavigateUrlFormatString="~/admisiones/autorizaciones.aspx?aut={0}" SortExpression="autNumero" />
            <asp:BoundField HeaderText="Fecha" DataField="autFecha" SortExpression="autFecha" DataFormatString="{0:d}" />
            <asp:BoundField HeaderText="Vencimiento" DataField="autFechaVenc" SortExpression="autFechaVenc" DataFormatString="{0:d}" />
            <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Documento" DataNavigateUrlFields="pacId" SortExpression="pacDocumento"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-HorizontalAlign="Right" />
            <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" DataNavigateUrlFields="pacId" SortExpression="pacNombres"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre"/>
            <asp:TemplateField HeaderText="Número definitivo">
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="TAutorizacion"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    </div>
    <div align="right">
        <asp:Button runat="server" ID="BAceptar" Text="Confirmar autorizaciones" 
            onclick="BAceptar_Click" />
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
        ConnectionString="<%$ ConnectionStrings:connBD %>" 
        SelectCommand="SELECT phdAutorizacion.autNumero,phdAutorizacion.autFecha,phdAutorizacion.autFechaVenc 
                    ,phdPaciente.pacDocumento,phdPaciente.pacNombres,admEntidad.entNombre,phdPaciente.pacId
                    FROM phdAutorizacion 
                    LEFT JOIN admEntidad ON (phdAutorizacion.entId=admEntidad.entId)
                    LEFT JOIN phdPaciente ON (phdPaciente.pacId=phdAutorizacion.pacId)
                    WHERE autProvisional=1 AND autActivo=1
                    AND (@asegurador=0 OR @asegurador=phdAutorizacion.entId)
                    ORDER BY phdAutorizacion.autNumero">
         <SelectParameters>
            <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
         </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

