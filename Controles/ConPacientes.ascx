<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConPacientes.ascx.vb" Inherits="ML.ConPacientes" %>
<%@ Register src="Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<%@ Register src="Lista.ascx" tagname="Lista" tagprefix="uc5" %>

<table style="width: 100%;" border="1">
        <tr>
            <td style="text-align: center">
                <asp:Label ID="Label36" runat="server" SkinID="EtiquetaSubT" 
                    Text="Paciente"></asp:Label>
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
            <asp:RadioButtonList ID="rblBusPac" runat="server" AutoPostBack="true" Visible="false" RepeatDirection="Horizontal">
                <asp:ListItem Text="Pacientes Activos" Value="1" Selected="True"></asp:ListItem>
                <asp:ListItem Text="Pacientes Inactivos" Value="2"></asp:ListItem>
            </asp:RadioButtonList>
                <uc5:Lista ID="lstPac" runat="server" AutoPostBack="True" 
                    MostrarAlBuscar="True" OrigenDatos="Paciente" />
            </td>
        </tr>
    </table>
<asp:Panel ID="pnlcontenido" runat="server" Visible="false">
    <table style="width: 100%;" border="1">
        <tr>
            <td colspan="4" style="text-align: center">
                <asp:Label ID="Label32" runat="server" SkinID="EtiquetaSubT" 
                    Text="Información personal"></asp:Label>
            </td>
            <td style="text-align: center">
                <asp:Label ID="Label33" runat="server" SkinID="EtiquetaSubT" Text="Servicios"></asp:Label>
            </td>
        </tr>
       <tr>
            <td>
                Fecha Nacimiento
            </td>
            <td colspan="2">
                    <uc1:Fecha ID="fecNacimiento" runat="server" OrigenDatos="pacFechaNac" />
                    <%=Paciente.pacEdad%> Años
            </td>
            <td>
                Sexo
                <uc2:DropDownListU ID="ddlSexo" runat="server" OrigenDatos="sexoId" 
                    NomTabla="Sexo" />
            </td>
            <td rowspan="8" valign="top">
                <div ID="dvAut" runat="server">
                </div>
            </td>
       </tr>
        <tr>
            <td>
                Asegurador
            </td>
            <td>
                <uc5:Lista ID="Lista2" runat="server" NomTabla="Asegurador" OrigenDatos="entId" 
                    VerCodigo="False" WidthTexto="150px" />
            </td>
            <td>
                Carné
            </td>
            <td>
                <ml:TextBox ID="txtCarne" runat="server" MaxLength="50" OrigenDatos="pacCarne"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Dirección
            </td>
            <td>
                <ml:TextBox ID="txtDir" runat="server" MaxLength="100" OrigenDatos="pacDireccion"></ml:TextBox>
            </td>
            <td>
                Barrio
            </td>
            <td style="margin-left: 40px">
                <ml:TextBox ID="txtBarrio" runat="server" MaxLength="50" OrigenDatos="pacBarrio"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Teléfono
            </td>
            <td>
                <ml:TextBox ID="txtTelefono" runat="server" MaxLength="50" OrigenDatos="pacTelefono"></ml:TextBox>
            </td>
            <td>
                Celular
            </td>
            <td>
                <ml:TextBox ID="txtCelular" runat="server" MaxLength="50" OrigenDatos="pacCelular"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Pago Dir
            </td>
            <td>
                <uc2:DropDownListU ID="ddlPagoDir" runat="server" OrigenDatos="pdirId" 
                    NomTabla="PagoDirecto" />
            </td>
            <td>
                Estancia
            </td>
            <td>
                <uc2:DropDownListU ID="ddlEstancia" runat="server" OrigenDatos="eEstId" 
                    NomTabla="Estancia" />
            </td>
        </tr>
        <tr>
            <td>
                Familiar</td>
            <td>
                <ml:TextBox ID="txtFamResponsable" runat="server" MaxLength="100" OrigenDatos="pacFamilarResponsable"></ml:TextBox>
            </td>
            <td>
                Parentesco
            </td>
            <td>
                <ml:TextBox ID="txtParentesco" runat="server" MaxLength="50" OrigenDatos="pacParentesco"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <uc5:Lista ID="Lista1" runat="server" NomTabla="CIE10" OrigenDatos="cieCodDx" />
            </td>
        </tr>
        </table>
</asp:Panel>

    
