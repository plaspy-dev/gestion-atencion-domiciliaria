<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConPacientesLight.ascx.vb" Inherits="ML.ConPacientesLight" %>
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
            <td style="text-align: center; width: 400px;" width="200px">
                <asp:Label ID="Label33" runat="server" SkinID="EtiquetaSubT" Text="Servicios"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Sexo
            </td>
            <td>
                <uc2:DropDownListU ID="ddlSexo" runat="server" NomTabla="Sexo" 
                    OrigenDatos="sexoId" />
            </td>
            <td>
                Fecha Nac
            </td>
            <td>
                <uc1:Fecha ID="fecNacimiento" runat="server" OrigenDatos="pacFechaNac" />
                <asp:Label ID="lblEdad" runat="server"></asp:Label>
            </td>
            <td rowspan="5" style="vertical-align: top"  width="200px" colspan="2">
                <div ID="dvAut" runat="server">
                </div>
            </td>
         </tr>
        <tr>
            <td>
                Dirección
            </td>
            <td>
                <ml:TextBox ID="txtDir" runat="server" MaxLength="100" 
                    OrigenDatos="pacDireccion"></ml:TextBox>
            </td>
            <td>
                Barrio
            </td>
            <td>
                <ml:TextBox ID="txtBarrio" runat="server" MaxLength="50" 
                    OrigenDatos="pacBarrio"></ml:TextBox>
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
                Asegurador
            </td>
            <td >
                <uc2:DropDownListU ID="ddlAsegurador" runat="server" GenException="False" 
                    NomTabla="Asegurador" OrigenDatos="entId" />
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
                Familiar
            </td>
            <td>
                <ml:TextBox ID="txtFamResponsable" runat="server" MaxLength="100" 
                    OrigenDatos="pacFamilarResponsable" ToolTip="Familiar Responsable"></ml:TextBox>
            </td>
            <td>
                Parentesco
            </td>
            <td>
                <ml:TextBox ID="txtParentesco" runat="server" MaxLength="50" OrigenDatos="pacParentesco"></ml:TextBox>
            </td>
        </tr>
        </table>
</asp:Panel>