<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConPacientesLightB.ascx.vb" Inherits="ML.ConPacientesLightB" %>
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
                <uc2:DropDownListU ID="ddlPaciente" runat="server" AutoPostBack="true" 
                    TipoControl="Combinado" widthTextBox="100px" />
            </td>
        </tr>
    </table>
<asp:Panel ID="pnlcontenido" runat="server" Visible="false">
    <table border="1"> 
        <tr>
            <td colspan="4" style="text-align: center">
                <asp:Label ID="Label32" runat="server" SkinID="EtiquetaSubT" 
                    Text="Información personal"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Asegurador
            </td>
            <td>
                <uc2:DropDownListU ID="ddlAsegurador" runat="server" NomTabla="Asegurador" 
                    OrigenDatos="entId" GenException="False" />
            </td>
            <td>
                Fecha Nac
            </td>
            <td>
                <uc1:Fecha ID="fecNacimiento" runat="server" OrigenDatos="pacFechaNac" />
                <asp:Label ID="lblEdad" runat="server"></asp:Label>
            </td>
         </tr>
        <tr>
            <td>
                Teléfono
            </td>
            <td>
                <ml:TextBox ID="txtTelefono" runat="server" MaxLength="50" 
                    OrigenDatos="pacTelefono"></ml:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
          <tr>
            <td colspan="4">
               <uc5:Lista ID="Lista1" runat="server" NomTabla="CIE10" OrigenDatos="cieCodDx" />
            </td>
        </tr>
        </table>
</asp:Panel>