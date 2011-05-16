<%@ Page Title="Paciente" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdConPacientesDet.aspx.vb" Inherits="ML.phdConPacientesDet" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<%@ Register src="../Controles/Lista.ascx" tagname="Lista" tagprefix="uc3" %>
<%@ Register src="../Controles/UsuarioAudit.ascx" tagname="UsuarioAudit" tagprefix="uc4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        .style2
        {
            width: 24px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table class="style1">
        <tr>
            <td colspan="4" style="text-align: center">
                <asp:Label ID="Label32" runat="server" SkinID="EtiquetaSubT" 
                    Text="Información personal"></asp:Label>
            </td>
            <td class="style2">
                &nbsp;</td>
            <td style="text-align: center">
                <asp:Label ID="Label33" runat="server" SkinID="EtiquetaSubT" Text="Servicios"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Tipo Documento"></asp:Label>
            </td>
            <td>
                <uc2:DropDownListU ID="ddlTipDoc" runat="server" OrigenDatos="tdocId" />
            </td>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Documento"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtDocumento" runat="server" MaxLength="50" OrigenDatos="pacDocumento"></ml:TextBox>
            </td>
            <td class="style2">
                &nbsp;</td>
            <td rowspan="12" style="vertical-align:top;">
                <div ID="dvAut" runat="server">
                </div>
            </td>
         </tr>
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server" Text="Primer Nombre"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtPNom" runat="server" MaxLength="50" OrigenDatos="pacPNombre"></ml:TextBox>
            </td>
            <td>
                <asp:Label ID="Label5" runat="server" Text="Segundo Nombre"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtSNom" runat="server" MaxLength="50" OrigenDatos="pacSNombre"></ml:TextBox>
            </td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label6" runat="server" Text="Primer Apellido"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtPApe" runat="server" MaxLength="50" OrigenDatos="pacPApellido"></ml:TextBox>
            </td>
            <td>
                <asp:Label ID="Label7" runat="server" Text="Segundo Apellido"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtSApe" runat="server" MaxLength="50" OrigenDatos="pacSApellido"></ml:TextBox>
            </td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="Sexo"></asp:Label>
            </td>
            <td>
                <uc2:DropDownListU ID="ddlSexo" runat="server" OrigenDatos="sexoId" />
            </td>
            <td>
                <asp:Label ID="Label8" runat="server" Text="Fecha Nacimiento"></asp:Label>
            </td>
            <td>
                <uc1:Fecha ID="fecNacimiento" runat="server" OrigenDatos="pacFechaNac" />
                <asp:Label ID="lblEdad" runat="server"></asp:Label>
            </td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label9" runat="server" Text="Asegurador"></asp:Label>
            </td>
            <td>
                <uc2:DropDownListU ID="ddlAsegurador" runat="server" OrigenDatos="entId"/>
            </td>
            <td>
                <asp:Label ID="Label10" runat="server" Text="Mega"></asp:Label>
            </td>
            <td>
                <uc2:DropDownListU ID="ddlMega" runat="server" OrigenDatos="megId" />
            </td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label11" runat="server" Text="Carné"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtCarne" runat="server" MaxLength="50" OrigenDatos="pacCarne"></ml:TextBox>
            </td>
            <td>
                <asp:Label ID="Label12" runat="server" Text="Numero ETB"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtNumETB" runat="server" MaxLength="50" TipoTextBox="Entero" OrigenDatos="pacNumeroETB"></ml:TextBox>
            </td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label13" runat="server" Text="Dirección"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtDir" runat="server" MaxLength="100" OrigenDatos="pacDireccion"></ml:TextBox>
            </td>
            <td>
                <asp:Label ID="Label14" runat="server" Text="Barrio"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtBarrio" runat="server" MaxLength="50" OrigenDatos="pacBarrio"></ml:TextBox>
            </td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Label ID="Label15" runat="server" Text="Especificaciones de llegada"></asp:Label>
            </td>
            <td colspan="2">
                <ml:TextBox ID="txtEspLlegada" runat="server" MaxLength="500" 
                    TextMode="MultiLine" Width="231px" OrigenDatos="pacEspecLlegada"></ml:TextBox>
            </td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label16" runat="server" Text="Teléfono"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtTelefono" runat="server" MaxLength="50" OrigenDatos="pacTelefono"></ml:TextBox>
            </td>
            <td>
                <asp:Label ID="Label17" runat="server" Text="Teléfono1"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtTelefono1" runat="server" MaxLength="50" OrigenDatos="pacTelefono1"></ml:TextBox>
            </td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label18" runat="server" Text="Celular"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtCelular" runat="server" MaxLength="50" OrigenDatos="pacCelular"></ml:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label19" runat="server" Text="Pago directo"></asp:Label>
            </td>
            <td>
                <uc2:DropDownListU ID="ddlPagoDir" runat="server" OrigenDatos="pdirId" />
            </td>
            <td>
                <asp:Label ID="Label20" runat="server" Text="Estancia"></asp:Label>
            </td>
            <td>
                <uc2:DropDownListU ID="ddlEstancia" runat="server" OrigenDatos="estId" />
            </td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label21" runat="server" Text="Familiar Responsable"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtFamResponsable" runat="server" MaxLength="100" OrigenDatos="pacFamilarResponsable"></ml:TextBox>
            </td>
            <td>
                <asp:Label ID="Label22" runat="server" Text="Parentesco"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtParentesco" runat="server" MaxLength="50" OrigenDatos="pacParentesco"></ml:TextBox>
            </td>
            <td class="style2">
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label23" runat="server" Text="Tipo de Evento"></asp:Label>
            </td>
            <td>
                <uc2:DropDownListU ID="ddlTipEvento" runat="server" OrigenDatos="tipECod" />
            </td>
            <td style="margin-left: 160px">
                <asp:Label ID="Label24" runat="server" Text="Fec Ingreso Programa"></asp:Label>
            </td>
            <td>
                <uc1:Fecha ID="fecIngProg" runat="server" OrigenDatos="pacFecIngPrograma" />
            </td>
            <td class="style2">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label25" runat="server" Text="Intensidad Terapias"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtIntensidad" runat="server" MaxLength="50" OrigenDatos="pacIntensidadTerapias"></ml:TextBox>
            </td>
            <td style="margin-left: 160px">
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td class="style2">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label26" runat="server" Text="CIE 10"></asp:Label>
            </td>
            <td colspan="3">
                <uc3:Lista ID="lstCIE10" runat="server" NomTabla="CIE10" 
                    OrigenDatos="cieCodDx" />
            </td>
            <td class="style2">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label27" runat="server" Text="CIE 10_1"></asp:Label>
            </td>
            <td colspan="3">
                <uc3:Lista ID="lstCIE10_1" runat="server" NomTabla="CIE10" 
                    OrigenDatos="cieCodDx_1" />
            </td>
            <td class="style2">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label28" runat="server" Text="CIE 10_2"></asp:Label>
            </td>
            <td colspan="3">
                <uc3:Lista ID="lstCIE10_2" runat="server" NomTabla="CIE10" 
                    OrigenDatos="cieCodDx_2" />
            </td>
            <td class="style2">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td colspan="6" style="text-align: center">
                <uc4:UsuarioAudit ID="UsuarioAudit1" runat="server" />
            </td>
        </tr>
        </table>
</asp:Content>
