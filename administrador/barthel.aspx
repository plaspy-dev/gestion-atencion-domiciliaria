<%@ Page Title="Indice de Barthel" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="barthel.aspx.cs" Inherits="administrador_barthel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $('.entero').numeric({ format: "0", buttons: false, minValue: 0, emptyValue: '-' });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel ID="Panel1" runat="server" DefaultButton="BAceptar">
    <table style="width: 100%;">
        <tr>
            <td>
                <table style="width: 100%;">
        <tr>
            <td>
                Grupo</td>
            <td>
                <asp:DropDownList ID="DGrupo" runat="server" DataSourceID="SGrupo" 
                    DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
            </td>
            <td>
            <asp:SqlDataSource ID="SGrupo" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=7 AND szReservado IS NULL">
            </asp:SqlDataSource>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="DGrupo" Display="Dynamic" 
                    ErrorMessage="Por favor seleccione un grupo." SetFocusOnError="True"></asp:RequiredFieldValidator>
                <asp:HiddenField ID="HId" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                Concepto</td>
            <td>
                <asp:TextBox ID="TConcepto" runat="server" TextMode="MultiLine" Height="100px" 
                    Width="100%"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="TConcepto" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un concepto." SetFocusOnError="True"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Calificación</td>
            <td>
                <asp:TextBox ID="TCalificacion" CssClass="entero" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                    ControlToValidate="TCalificacion" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese una calificación." SetFocusOnError="True"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" 
                    Text="Aceptar" />
                <asp:Button ID="BCancelar" runat="server" onclick="BCancelar_Click" 
                    Text="Cancelar" CausesValidation="False" />
            </td>
            <td>
                &nbsp;</td>
        </tr>
    </table>
            </td>
        </tr>
        <tr>
            <td>
                <asp:GridView ID="GResultado" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="id" DataSourceID="SqlDataSource2" 
                    onselectedindexchanged="GResultado_SelectedIndexChanged">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                    <asp:BoundField DataField="grupo" HeaderText="Grupo" SortExpression="grupo" />
                    <asp:BoundField DataField="nombre" HeaderText="Concepto" 
                        SortExpression="nombre" >
                        <ItemStyle Width="400px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="calificacion" HeaderText="Calificación" SortExpression="calificacion" />
                </Columns>
                <SelectedRowStyle CssClass="selecteditem" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre,varios.descripcion AS calificacion,grupo.nombre AS grupo FROM varios LEFT JOIN varios AS grupo ON (grupo.id=varios.parametro1) WHERE varios.tipo=8 AND varios.szReservado IS NULL ORDER BY grupo" 
                DeleteCommand="UPDATE varios SET szReservado=-1 WHERE id=@id" >
            </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
        </tr>
    </table>
    </asp:Panel>
</asp:Content>

