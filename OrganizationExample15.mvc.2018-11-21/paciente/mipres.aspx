<%@ Page Title="Actas MIPRES" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="paciente_mipres" Codebehind="mipres.aspx.cs" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<%@ Register src="~/ctrl/history.ascx" tagname="History" tagprefix="uc" %>
<%@ Register src="~/paciente/cie10list.ascx" tagname="CIE10" tagprefix="uc6" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#<%= TId.ClientID %>").change(function () {
                $.goURL("pid=" + $.getUrlVar("pid") + "&ampid=" + $(this).val());
            });
            $("#<%= TServicio.ClientID %>")._autoComplete({
            url: "<%= ResolveClientUrl("~/") %>webservices/servicios.asmx/GetVarios",
            data: { t: 164 },
            map: function (item) {
                item.label = item.value;
                item.value = item.item;
                return item;
            },
            idField: "<%= TIdServicio.ClientID %>"
        });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
<uc4:detallepaciente ID="CCDetallePaciente" runat="server" Visible="false" />
<asp:Panel ID="PD" runat="server" Visible="false">
    <uc:History runat="server" ID="UCH" />
    <table class="tableborder">
        <tr>
            <td>Número Acta</td>
            <td><asp:TextBox runat="server" ID="TId" CssClass="entero"></asp:TextBox></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Fecha acta<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="R4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="R2" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una hora valida" Display="Dynamic" 
                            SetFocusOnError="true" ValidationExpression="^((?!00:00).)*$" runat="server" >*</asp:RegularExpressionValidator>
                        <sdg:DateTimeValidator runat="server" ID="DTV" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha valida." 
                    Display="Dynamic" SetFocusOnError="true">*</sdg:DateTimeValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TFecha" CssClass="fechahora"></asp:TextBox></td>
            <td>Elaborado por<asp:RequiredFieldValidator ControlToValidate="UCFuncionario$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="R1" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><uc1:funcionario runat="server" ID="UCFuncionario" /></td>
        </tr>
        <tr>
            <td>Fecha prescripción<asp:RequiredFieldValidator ControlToValidate="TPrescripcion" ErrorMessage="Por favor ingrese una fecha de prescripción." ID="R11" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TPrescripcion" CssClass="fechahora"></asp:TextBox></td>
            <td>Número<asp:RequiredFieldValidator ControlToValidate="TNumero" ErrorMessage="Por favor ingrese un número MIPRES." ID="R10" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TNumero"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Tipo
                <asp:RequiredFieldValidator ControlToValidate="RTipo" ErrorMessage="Por favor seleccione un tipo." ID="R9" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td><asp:RadioButtonList runat="server" ID="RTipo" RepeatColumns="2">
                <asp:ListItem Text="Unica" Value="0"></asp:ListItem>
                <asp:ListItem Text="Sucesiva" Value="1"></asp:ListItem>
                </asp:RadioButtonList></td>
            <td>Estado
                <asp:RequiredFieldValidator ControlToValidate="RAprobada" ErrorMessage="Por favor seleccione un estado." ID="R8" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td>
                <asp:RadioButtonList runat="server" ID="RAprobada" RepeatColumns="2">
                    <asp:ListItem Text="Aprobado" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Negado" Value="0"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">CIE10</td>
        </tr>
        <tr class="tda">
            <td colspan="4"><uc6:CIE10 runat="server" ID="CIE10" /></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Servicio, tecnologia, nutrición o medicamento prescrito</td>
        </tr>
        <tr class="tdb">
            <td colspan="4">

                <asp:GridView ID="GServicios" runat="server" Width="100%"
    AutoGenerateColumns="False" DataKeyNames="Id"
    onselectedindexchanged="GServicios_SelectedIndexChanged" OnRowDeleting="GServicios_RowDeleting" >
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
        <asp:BoundField DataField="Nombre" HeaderText="Descripción" ItemStyle-Width="100%" />
    </Columns>
    <SelectedRowStyle CssClass="selecteditem" />
</asp:GridView>
<asp:Panel runat="server" ID="P" DefaultButton="BMServicio">
<table style="width: 100%">
    <tr>
        <td class="nowrap">Servicio
            <asp:RequiredFieldValidator ControlToValidate="TServicio" ValidationGroup="servicio" ErrorMessage="Por favor ingrese un servicio." ID="R12" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            <asp:RequiredFieldValidator ControlToValidate="TIdServicio" ValidationGroup="servicio" ErrorMessage="Por favor ingrese un servicio." ID="R13" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
        </td>
        <td style="width: 100%">
            <asp:TextBox runat="server" CssClass="hide" ID="TIdServicio"></asp:TextBox>
            <asp:TextBox runat="server" Width="100%" ID="TServicio"></asp:TextBox></td>
        <td><asp:Button ID="BMServicio" runat="server" OnClick="BMServicio_Click" Text="+" ValidationGroup="servicio" /></td>
    </tr>
</table>
</asp:Panel>
            </td>
        </tr>
        <tr>
            <td>Asistentes
                <asp:RequiredFieldValidator ControlToValidate="UCAsistente1$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="R5" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RequiredFieldValidator ControlToValidate="UCAsistente2$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="R6" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RequiredFieldValidator ControlToValidate="UCAsistente3$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="R3" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td><uc1:funcionario runat="server" ID="UCAsistente1" /></td>
            <td><uc1:funcionario runat="server" ID="UCAsistente2" /></td>
            <td><uc1:funcionario runat="server" ID="UCAsistente3" /></td>
        </tr>
        <tr>
            <td>Justificación
                <asp:RequiredFieldValidator ControlToValidate="TJustificacion" ErrorMessage="Por favor ingrese una justificación." ID="R7" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
            <td colspan="3">
                <asp:TextBox runat="server" ID="TJustificacion" TextMode="MultiLine" CssClass="w100"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4"><asp:Label runat="server" ID="LMessage" ForeColor="Red"></asp:Label><asp:ValidationSummary runat="server" ID="V" /></td>
        </tr>
        <tr>
            <td><asp:Button Text="Eliminar" runat="server" ID="BEliminar" Visible="false" OnClientClick="confirm('¿Esta seguro de eliminar esta documento?')" 
                        CausesValidation="false" onclick="BEliminar_Click" /></td>
            <td colspan="3" class="r">
                <asp:Button runat="server" ID="BAceptar" Text="Aceptar" OnClick="BAceptar_Click" />
                <asp:Button runat="server" ID="BCancelar" Text="Cancelar" CausesValidation="false" OnClick="BCancelar_Click" />
            </td>
        </tr>
    </table>
</asp:Panel>
</asp:Content>

