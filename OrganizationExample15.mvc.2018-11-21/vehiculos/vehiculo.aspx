<%@ Page Title="Vehículos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="vehiculos_vehiculo" Codebehind="vehiculo.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table style="border-collapse: collapse;">
    <tr>
        <td>Placa<asp:RequiredFieldValidator ControlToValidate="TPlaca" ErrorMessage="Por favor ingrese una placa." ID="RequiredFieldValidator4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TPlaca"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Fabricante<asp:RequiredFieldValidator ControlToValidate="TFabricante" ErrorMessage="Por favor ingrese un fabricante." ID="RequiredFieldValidator1" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TFabricante"></asp:TextBox></td>
        <td>Línea<asp:RequiredFieldValidator ControlToValidate="TLinea" ErrorMessage="Por favor ingrese una línea." ID="RequiredFieldValidator2" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TLinea"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Modelo<asp:RequiredFieldValidator ControlToValidate="TModelo" ErrorMessage="Por favor ingrese un modelo." ID="RequiredFieldValidator3" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TModelo" CssClass="entero"></asp:TextBox></td>
        <td>Cilindraje</td>
        <td><asp:TextBox runat="server" ID="TCilindraje" CssClass="entero"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Clase</td>
        <td><asp:TextBox runat="server" ID="TClase"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Número motor</td>
        <td><asp:TextBox runat="server" ID="TMotor"></asp:TextBox></td>
        <td>Serie</td>
        <td><asp:TextBox runat="server" ID="TSerie"></asp:TextBox></td>
    </tr>
    <tr>
        <td colspan="4" class="celdaTitulo">SOAT</td>
    </tr>
    <tr>
        <td class="tdl">Expedición</td>
        <td><asp:TextBox runat="server" ID="TExpedicionSOAT" CssClass="fecha"></asp:TextBox></td>
        <td>Vencimiento</td>
        <td class="tdr"><asp:TextBox runat="server" ID="TVencimientoSOAT" CssClass="fecha"></asp:TextBox></td>
    </tr>
    <tr>
        <td colspan="4" class="celdaTitulo">Revisión tecnomecánica</td>
    </tr>
    <tr>
        <td class="tdl tdb">Expedición</td>
        <td class="tdb"><asp:TextBox runat="server" ID="TExpedicionCertificado" CssClass="fecha"></asp:TextBox></td>
        <td class="tdb">Vencimiento</td>
        <td class="tdr tdb"><asp:TextBox runat="server" ID="TVencimientoCertificado" CssClass="fecha"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Conductor</td>
        <td><asp:DropDownList ID="DConductor" runat="server" CssClass="anchomaxcombo"
                                DataSourceID="SConductor" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SConductor" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT perId id,perNombre nombre 
                            FROM recurso_humano 
                            LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)
                            WHERE recurso_humano.eEstId=1 
                            AND cargo.carDescripcion like '%conductor%'
                            ORDER BY nombre;">
                </asp:SqlDataSource></td>
    </tr>
    <tr>
        <td></td>
        <td><asp:CheckBox runat="server" ID="CActivo" Text="Activo" /></td>
    </tr>
    <tr>
        <td colspan="4"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label><asp:ValidationSummary runat="server" /></td>
    </tr>
    <tr>
        <td colspan="4" align="right"><asp:Button runat="server" ID="BAceptar" 
                Text="Aceptar" onclick="BAceptar_Click" /> <asp:Button runat="server" 
                ID="BCancelar" CausesValidation="false" Text="Cancelar" 
                onclick="BCancelar_Click" /></td>
    </tr>
</table>
<br />
<asp:GridView ID="GVehiculos" runat="server" AutoGenerateColumns="False" 
        DataSourceID="SVehiculos" EmptyDataText="No se encontraron vehiculos" 
        AllowSorting="true" onselectedindexchanged="GVehiculos_SelectedIndexChanged" DataKeyNames="vehPlaca" Width="100%">
    <RowStyle CssClass="GridRow"></RowStyle>
    <FooterStyle CssClass="GridFooter"></FooterStyle>
    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
    <Columns>
    <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="S" CssClass="btn btn-success btn-xs" CausesValidation="False" CommandName="Select" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
        <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="D" CssClass="btn btn-danger btn-xs" CausesValidation="False" CommandName="Delete" ToolTip="Eliminar"><i class="fa fa-trash-o"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
        <asp:BoundField DataField="vehPlaca" HeaderText="Placa" SortExpression="vehPlaca" />
        <asp:BoundField DataField="vehFabricante" HeaderText="Fabricante" SortExpression="vehFabricante" ItemStyle-Width="100%" />
        <asp:BoundField DataField="vehModelo" HeaderText="Modelo" SortExpression="vehModelo" ItemStyle-HorizontalAlign="Right" />
        <asp:BoundField DataField="vehFechaVenSoat" HeaderText="Vencimiento SOAT" SortExpression="vehFechaVenSoat" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
        <asp:BoundField DataField="vehFechaVenOtro" HeaderText="Vencimiento Certificado" SortExpression="vehFechaVenOtro" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
        <asp:TemplateField HeaderText="Activo" SortExpression="vehActivo" ItemStyle-HorizontalAlign="Right">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="A" Checked='<%# Eval("vehActivo") %>' Enabled="false" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
<asp:SqlDataSource ID="SVehiculos" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
    SelectCommand="SELECT 
            vehPlaca, vehFabricante,vehModelo,vehFechaVenSoat,vehFechaVenOtro,vehActivo
            FROM vehiculo ORDER BY vehActivo=0,vehPlaca;"
            DeleteCommand="DELETE FROM vehiculo WHERE vehPlaca=@vehPlaca;">
      <SelectParameters>
      </SelectParameters>
</asp:SqlDataSource>
</asp:Content>

