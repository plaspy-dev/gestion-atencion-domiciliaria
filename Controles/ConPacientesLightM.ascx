<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConPacientesLightM.ascx.vb" Inherits="ML.ConPacientesLightM" %>
<%@ Register src="Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<%@ Register src="Lista.ascx" tagname="Lista" tagprefix="uc5" %>


<table style="width: 100%;" border="1">
        <tr>
            <td style="text-align: center" class="celdaTitulo">
                <asp:Label ID="Label36" runat="server" SkinID="lblsubTitulo" 
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
    <table border="1"> 
        <tr>
            <td colspan="4" style="text-align: center">
                <asp:Label ID="Label32" runat="server" SkinID="EtiquetaSubT" 
                    Text="Información personal"></asp:Label>
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
            <td style="margin-left: 40px" >
                <uc2:DropDownListU ID="ddlAsegurador" runat="server" GenException="False" 
                    NomTabla="Asegurador" OrigenDatos="entId" />
            </td>
        </tr>
      </table>
</asp:Panel>