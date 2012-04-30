<%@ Page Title="Pacientes atendidos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="atendidos.aspx.cs" Inherits="paciente_atendidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
                Entidad</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
            <td>
                <asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="THasta" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td>
                <asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM dbo.admEntidad WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" 
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" DataSourceID="SResultados" >
            <Columns>
                <asp:BoundField DataField="Fecha" SortExpression="Fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                <asp:BoundField DataField="Paciente" SortExpression="Paciente" HeaderText="Paciente" />
                <asp:BoundField DataField="Documento" SortExpression="Documento" HeaderText="Documento" />
                <asp:BoundField DataField="Edad" SortExpression="Edad" HeaderText="Edad" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="Direccion" SortExpression="Direccion" HeaderText="Dirección" />
                <asp:BoundField DataField="Barrio" SortExpression="Barrio" HeaderText="Barrio" />
                <asp:BoundField DataField="Telefonos" SortExpression="Telefonos" HeaderText="Teléfonos" />
                <asp:BoundField DataField="Barthel" SortExpression="Barthel" HeaderText="Índice de Barthel" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="Diagnostico1" SortExpression="Diagnostico1" HeaderText="Diagnostico 1" />
                <asp:BoundField DataField="Diagnostico2" SortExpression="Diagnostico2" HeaderText="Diagnostico 2" />
                <asp:BoundField DataField="Diagnostico3" SortExpression="Diagnostico3" HeaderText="Diagnostico 3" />
                <asp:BoundField DataField="Conducta" SortExpression="Conducta" HeaderText="Conducta clínica" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
        <asp:ObjectDataSource runat="server" ID="SResultados" TypeName="TablaPaciente" SelectMethod="GetDataTable">
        </asp:ObjectDataSource>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

