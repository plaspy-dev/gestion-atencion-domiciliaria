<%@ Page Title="Dotación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="equipo.aspx.cs" Inherits="equipo_equipo" %>
<%@ Register src="~/equipo/prestamo.ascx" tagname="prestamo" tagprefix="uc1" %>
<%@ Register src="~/equipo/devolucion.ascx" tagname="devolucion" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table>
    <tr>
        <td>Nombre<asp:RequiredFieldValidator ControlToValidate="TNombre" ErrorMessage="Por favor ingrese un nombre." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TNombre"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Código</td>
        <td><asp:TextBox runat="server" ID="TCodigo"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Marca<asp:RequiredFieldValidator ControlToValidate="TMarca" ErrorMessage="Por favor ingrese una marca." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TMarca"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Modelo<asp:RequiredFieldValidator ControlToValidate="TModelo" ErrorMessage="Por favor ingrese un modelo." ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TModelo"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Serial<asp:RequiredFieldValidator ControlToValidate="TSerial" ErrorMessage="Por favor ingrese un serial." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TSerial"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Placa</td>
        <td><asp:TextBox runat="server" ID="TPlaca"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Último mantenimiento<asp:RangeValidator ControlToValidate="TUltimoMantenimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
        <td><asp:TextBox runat="server" ID="TUltimoMantenimiento" CssClass="fecha"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Próximo mantenimiento<asp:RangeValidator ControlToValidate="TProximoMantenimiento" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
        <td><asp:TextBox runat="server" ID="TProximoMantenimiento" CssClass="fecha"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Estado</td>
        <td><asp:DropDownList runat="server" ID="DEstado" Enabled="false">
                <asp:ListItem Text="Disponible" Value="1"></asp:ListItem>
                <asp:ListItem Text="Asignado" Value="2"></asp:ListItem>
                <asp:ListItem Text="Liquidado" Value="0"></asp:ListItem>
            </asp:DropDownList></td>
    </tr>
    <tr>
        <td>Observaciones</td>
        <td><asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Height="50"></asp:TextBox></td>
    </tr>
    <asp:PlaceHolder runat="server" ID="PPrestamo" Visible="false">
    <tr>
        <td colspan="2" class="celdaTitulo">Prestamos</td>
    </tr>
    <tr>
        <td colspan="2" class="tdl tdr">
            <asp:GridView ID="GPrestamos" runat="server" DataKeyNames="IdTabla" AutoGenerateColumns="False" 
                onrowdatabound="GPrestamos_RowDataBound" onselectedindexchanged="GPrestamos_SelectedIndexChanged" onrowdeleting="GPrestamos_RowDeleting"
                EmptyDataText="No se encontraron prestamos" AllowPaging="True" PageSize="50" AllowSorting="True" >
                <Columns>
                    <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                    <asp:BoundField HeaderText="Paciente" DataField="NombrePaciente" SortExpression="NombrePaciente" ItemStyle-Wrap="false" />
                    <asp:BoundField HeaderText="Funcionario" DataField="NombreFuncionario" SortExpression="NombreFuncionario" ItemStyle-Wrap="false" />
                    <asp:BoundField HeaderText="Desde" DataField="Fecha" SortExpression="Fecha" DataFormatString="{0:d}" />
                    <asp:BoundField HeaderText="Hasta" DataField="Estimado" SortExpression="Estimado" DataFormatString="{0:d}" />
                    <asp:BoundField HeaderText="Devolución" DataField="Devolucion" SortExpression="Devolucion" DataFormatString="{0:d}" />
                    <asp:BoundField HeaderText="Familiar" DataField="Familiar" SortExpression="Familiar" ItemStyle-Wrap="false" />
                    <asp:BoundField HeaderText="Observaciones" DataField="Observaciones" SortExpression="Observaciones" />
                </Columns>
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            </asp:GridView>
        </td>
    </tr>
    <tr>
        <td colspan="2" class="tdl tdr tdb" align="right">
            <uc1:prestamo ID="UCPrestamo" runat="server" OnBAceptarClicked="BAgregarPrestamo_Click" OnBCancelarClicked="BCancelarPrestamo_Click" /><asp:Button runat="server" ID="BPrestamo" Text="Asignar" CausesValidation="false" onclick="BPrestamo_Click" />
            <uc1:devolucion ID="UCDevolucion" runat="server" OnBAceptarClicked="BAceptarDevolucion_Click" />
        </td>
    </tr>
    </asp:PlaceHolder>
    <tr>
        <td colspan="2"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label><asp:ValidationSummary runat="server" /></td>
    </tr>
    <tr>
        <td colspan="2" align="right"><asp:Button runat="server" ID="BAceptar" Text="Aceptar" onclick="BAceptar_Click" />
        <asp:Button runat="server" ID="BCancelar" Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
        <asp:Button runat="server" ID="BEliminar" CausesValidation="false" Text="Dar de baja" Visible="false" onclick="BEliminar_Click" /></td>
    </tr>
</table>
</asp:Content>

