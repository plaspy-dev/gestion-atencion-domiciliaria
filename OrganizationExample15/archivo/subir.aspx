<%@ Page Title="Subir" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="subir.aspx.cs" Inherits="archivo_subir" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $inicio(function () {
            
            $(".likefecha").mask("99/99/9999").
                datepicker({ onSelect: function () { $(this).change(); } }).addClass("rfecha");
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
<uc4:detallepaciente ID="CCDetallePaciente" runat="server" Visible="false" /><br />
<asp:UpdatePanel runat="server" ID="PDatos" UpdateMode="Conditional" Visible="false">
    <ContentTemplate>
    <table class="tablecollapse tableborder">
        <tr>
            <td>Factura<asp:RequiredFieldValidator Enabled="false" ControlToValidate="TFactura" ErrorMessage="Por favor ingrese una factura." ID="RequiredFieldValidator4" 
	            runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox AutoPostBack="true" OnTextChanged="TFactura_TextChanged" runat="server" CssClass="likenumber" ID="TFactura"></asp:TextBox></td>
            <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha de la factura." ID="RequiredFieldValidator1" 
	            runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TFecha" AutoPostBack="true" OnTextChanged="TFecha_TextChanged" CssClass="likefecha"></asp:TextBox></td>
            <td></td>
        </tr>
        <asp:PlaceHolder runat="server" ID="PFactura" Visible="false">
        <tr>
            <td>Factura<asp:RequiredFieldValidator ControlToValidate="FFactura" ErrorMessage="Por favor selecione un archivo." ID="RFactura" 
	            runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><asp:FileUpload runat="server" ID="FFactura" /></td>
            <td><asp:HyperLink runat="server" ID="HFactura" Visible="false"></asp:HyperLink></td>
        </tr>
        </asp:PlaceHolder>
        <asp:Repeater runat="server" ID="RArchivo" DataSourceID="SArchivo">
            <ItemTemplate>
                <tr>
                    <td class="nw"><%# Eval("nombre") %><asp:HiddenField runat="server" ID="HI" Value='<%# Eval("id") %>' /></td>
                    <td colspan="3"><asp:FileUpload runat="server" ID="FHistoria" Enabled='<%# string.IsNullOrEmpty(Eval("archivo").ToString()) || CUsuario.GetInstance().CanUpdate() %>' /></td>
                    <td style="width: 100%">
                        <asp:LinkButton runat="server" ID="D" CssClass="btn btn-danger btn-xs" CausesValidation="False" OnClick="D_Click" CommandArgument='<%# Eval("archivo") %>' CommandName='<%# Eval("id") %>' ToolTip="Eliminar" Visible='<%# CUsuario.GetInstance().CanDelete() && Eval("archivo")!=DBNull.Value %>'><i class="fa fa-trash-o"></i></asp:LinkButton>
                        <asp:HyperLink runat="server" ID="HHistoria" NavigateUrl='<%# string.Format("~/archivo/archivo.ashx?n={0}&t=d", Eval("archivo")) %>' Text='<%# Eval("archivo") %>' Visible='<%# !string.IsNullOrEmpty(Eval("archivo").ToString()) %>'></asp:HyperLink></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SArchivo" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            SelectCommand="SELECT varios.id, varios.nombre, digitalizacion.archivo
                FROM varios 
                LEFT JOIN digitalizacion ON (digitalizacion.paciente=@paciente 
                AND digitalizacion.tipo=varios.id
                AND ((@factura=0 AND digitalizacion.factura=0 AND digitalizacion.fecha=STR_TO_DATE(@fecha, '%d/%m/%Y')) 
                    OR (@factura!=0 AND digitalizacion.factura=@factura))
                )
                WHERE varios.tipo=138 AND varios.szReservado IS NULL ORDER BY nombre;">
            <SelectParameters>
                <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                <asp:ControlParameter ControlID="TFactura" PropertyName="Text" Name="factura" DefaultValue="0" />
                <asp:ControlParameter ControlID="TFecha" PropertyName="Text" Name="fecha" />
            </SelectParameters>
        </asp:SqlDataSource>
        <tr>
            <td colspan="5" class="tdb"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label><br /><asp:ValidationSummary runat="server" ID="V" /></td>
        </tr>
        <tr>
            <td class="tds"><asp:Button runat="server" ID="BEliminar" CausesValidation="false" Text="Eliminar" OnClick="BEliminar_Click" Visible="false" /></td>
            <td colspan="3" align="right" class="tds">
                <asp:Button runat="server" ID="BAceptar" Text="Aceptar" OnClick="BAceptar_Click" />
                <asp:Button runat="server" ID="BCancelar" Text="Cancelar" OnClick="BCancelar_Click" CausesValidation="false" />
            </td>
        </tr>
    </table>
    </ContentTemplate>
    <Triggers>
        <asp:PostBackTrigger ControlID="BAceptar" />
    </Triggers>
</asp:UpdatePanel>
</asp:Content>