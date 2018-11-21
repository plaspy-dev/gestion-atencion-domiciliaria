<%@ Page Title="Gestión ambiental" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="rutasanitaria_gestionambiental" Codebehind="gestionambiental.aspx.cs" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
<asp:PlaceHolder runat="server" ID="PDatos" Visible="false">
<uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
<table>
    <tr>
        <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese un fecha." ID="RequiredFieldValidator4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Vehículo<asp:RequiredFieldValidator ControlToValidate="DVehiculo" ErrorMessage="Por favor seleccione un vehiculo." ID="RequiredFieldValidator1" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:DropDownList ID="DVehiculo" runat="server" CssClass="anchomaxcombo"
                                DataSourceID="SVehiculo" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SVehiculo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT vehPlaca AS id, CONCAT(vehPlaca,', ',vehFabricante,', ',vehModelo) AS nombre FROM vehiculo ORDER BY 2">
                </asp:SqlDataSource></td>
    </tr>
    <tr>
        <td>Peso</td>
        <td style="white-space: nowrap"><asp:TextBox runat="server" ID="TPeso" CssClass="entero"></asp:TextBox>Kgs.</td>
    </tr>
    <tr>
        <td>Observaciones</td>
        <td><asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine"></asp:TextBox></td>
    </tr>
    <tr>
        <td colspan="2"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label><asp:ValidationSummary runat="server" /></td>
    </tr>
    <tr>
        <td align="right" colspan="2"><asp:Button runat="server" ID="BAceptar" Text="Aceptar" OnClick="BAceptar_Clicked" />&nbsp;<asp:Button runat="server" ID="BCancelar" Text="Cancelar" CausesValidation="false" OnClick="BCancelar_Clicked" />
        </td>
    </tr>
</table>
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados"
        AutoGenerateColumns="False" EmptyDataText="No se encontró gestión ambiental" 
        AllowPaging="True" PageSize="50" AllowSorting="True" Width="100%" 
        DataKeyNames="rtsId" onselectedindexchanged="GResultados_SelectedIndexChanged" >
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
            <asp:HyperLinkField DataTextField="rtsFecha" HeaderText="Fecha" 
                DataNavigateUrlFields="rtsId" 
                DataNavigateUrlFormatString="~/gestionambiental/gestionambiental.aspx?gaid={0}" SortExpression="rtsFecha" DataTextFormatString="{0:d}" />
            <asp:BoundField HeaderText="Vehículo" DataField="vehPlaca" SortExpression="vehPlaca"/>
            <asp:BoundField HeaderText="Peso" DataField="rtsPeso" SortExpression="rtsPeso" 
                ItemStyle-HorizontalAlign="Right">
<ItemStyle HorizontalAlign="Right"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField HeaderText="Observaciones" DataField="rtsObservaciones" 
                SortExpression="rtsObservaciones" ItemStyle-Width="100%">
<ItemStyle Width="100%"></ItemStyle>
            </asp:BoundField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                DeleteCommand="DELETE FROM ruta_sanitaria WHERE rtsId=@rtsId"
                SelectCommand="SELECT 
                                rtsId,rtsFecha
                                ,vehPlaca
                                ,rtsObservaciones
                                ,rtsPeso
                                FROM ruta_sanitaria
                            WHERE ruta_sanitaria.pacId=@paciente
                            ORDER BY rtsFecha DESC">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:PlaceHolder>
</asp:Content>