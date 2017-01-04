<%@ Page Title="Paciente atendido" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="atendido.aspx.cs" Inherits="evento_atendido" %>
<%@ Register Src="~/evento/eventoselect.ascx" TagName="Evento" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .remision {
            display: none;
        }
    </style>
    <script>
        $(function () {
            $("#<%= CRemisicion.ClientID %>").change(function () {
                $(".remision").toggle($(this).is(":checked"));
            }).change();
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table class="table table-striped table-condensed">
    <tr>
        <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="R1" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TFecha" CssClass="fechahora"></asp:TextBox></td>
        <td>Evento<asp:RequiredFieldValidator ControlToValidate="UCEvento$I" ErrorMessage="Por favor ingrese un evento." ID="R2" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><uc:Evento runat="server" ID="UCEvento" /></td>
    </tr>
    <tr>
        <td>Nombres<asp:RequiredFieldValidator ControlToValidate="TNombres" ErrorMessage="Por favor ingrese un nombre." ID="R3" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TNombres"></asp:TextBox></td>
        <td>Apellidos<asp:RequiredFieldValidator ControlToValidate="TApellidos" ErrorMessage="Por favor ingrese un apellido." ID="R4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TApellidos"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Edad<asp:RequiredFieldValidator ControlToValidate="TEdad" ErrorMessage="Por favor ingrese una edad." ID="R5" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TEdad" CssClass="entero"></asp:TextBox></td>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <td colspan="4" class="well">Familiar menor de edad</td>
    </tr>
    <tr>
        <td class="tdl">Documento</td>
        <td><asp:TextBox runat="server" ID="TFDocumento"></asp:TextBox></td>
        <td>Nombres</td>
        <td class="tdr"><asp:TextBox runat="server" ID="TFNombres"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Diagnostico</td>
        <td colspan="3"><asp:TextBox runat="server" ID="TDiagnostico" Width="100%"></asp:TextBox></td>
    </tr>
    <tr>
        <td colspan="4" class="well"><asp:CheckBox runat="server" ID="CRemisicion" Text="Remitido" /></td>
    </tr>
    <tr class="remision">
        <td class="tdl">Asegurador</td>
        <td><asp:TextBox runat="server" ID="TAsegurador"></asp:TextBox></td>
        <td>IPS</td>
        <td class="tdr"><asp:TextBox runat="server" ID="TIPS"></asp:TextBox></td>
    </tr>
    <tr class="remision">
        <td class="tdl">Documento</td>
        <td><asp:TextBox runat="server" ID="TDocumento"></asp:TextBox></td>
        <td>Código caso</td>
        <td class="tdr"><asp:TextBox runat="server" ID="TCodigo"></asp:TextBox></td>
    </tr>
    <tr class="remision">
        <td class="tdl">Causa</td>
        <td class="tdr" colspan="3"><asp:TextBox runat="server" ID="TCausa" Width="100%"></asp:TextBox></td>
    </tr>
    <tr class="remision">
        <td class="tdl">Ambulancia</td>
        <td><asp:DropDownList ID="DAmbulancia" runat="server" DataSourceID="SAmbulancia" CssClass="amc" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguna)" Value=""></asp:ListItem>
                </asp:DropDownList>
<asp:SqlDataSource ID="SAmbulancia" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=13 AND eliminado IS NULL ORDER BY nombre">
            </asp:SqlDataSource></td>
        <td><asp:CheckBox runat="server" ID="CSeguimiento" Text="Seguimiento" /></td>
        <td class="tdr"><asp:CheckBox runat="server" ID="CCadena" Text="Cadena de custodia" /></td>
    </tr>
    <tr>
        <td colspan="4"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label> <asp:ValidationSummary runat="server" ID="V" /></td>
    </tr>
    <tr>
        <td colspan="4" class="r">
            <asp:Button runat="server" ID="BEliminar" CssClass="btn btn-danger pull-left" Text="Eliminar" OnClick="BEliminar_Click" Visible="false" CausesValidation="false" />
            <asp:Button runat="server" ID="BAceptar" CssClass="btn btn-submit" Text="Aceptar" OnClick="BAceptar_Click" />
            <asp:Button runat="server" ID="BCancelar" CssClass="btn btn-default" Text="Cancelar" CausesValidation="false" OnClick="BCancelar_Click" />
        </td>
    </tr>
</table>
</asp:Content>