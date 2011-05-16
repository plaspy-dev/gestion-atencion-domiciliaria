<%@ Page Title="Historia Clínica" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdHistoriaClinica.aspx.vb" Inherits="ML.PhdHistoriaClinica" %>
<%@ Register src="../Controles/Lista.ascx" tagname="Lista" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/UsuarioAudit.ascx" tagname="UsuarioAudit" tagprefix="uc5" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc6" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:Panel ID="pnlHC" runat="server">
    <table align="center" border="1">
            <tr>
                <td colspan="3" class="celdaTitulo">
                    <div class="etiqTitNoticia">
                        Registro de Historia Clínica</div>
                </td>
            </tr>
            <tr>
                <td>
                    Fecha
                </td>
                <td colspan="2">
                    <uc2:Fecha ID="fecAut" runat="server"  Requerido="True" 
                        ValidationGroup="Guardar" OrigenDatos="hclFecha" />
                   
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Médico</td>
                <td colspan="2">
                    <uc6:DropDownListU ID="ddlMedicos" runat="server" OrigenDatos="perId" />
                </td>
            </tr>
            <tr>
                <td>
                    Paciente
                </td>
                <td colspan="2">
                    <uc1:lista ID="lstPac" runat="server" AutoPostBack="True" 
                    MostrarAlBuscar="True" NomTabla="PacientesTotal" />

                </td>
            </tr>
            <tr>
                <td>
                    Análisis Actual</td>
                <td colspan="2">
                    <ml:TextBox ID="txtAnalisis" runat="server" MaxLength="200" 
                         Width="389px" Height="85px" 
                        TextMode="MultiLine" OrigenDatos="hclAnalisisActual"></ml:TextBox>

                </td>
            </tr>
            <tr>
                <td>
                    Plan de Manejo</td>
                <td colspan="2">
                    <ml:TextBox ID="txtPlan" runat="server" MaxLength="200" 
                        Width="389px" Height="85px" 
                        TextMode="MultiLine" OrigenDatos="hclPlanManejo"></ml:TextBox>

                </td>
            </tr>
            <tr>
                <td colspan="3">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="3" class="celdaTitulo">
                    <div class="etiqTitNoticia">
                        Actividades</div>
                </td>
            </tr>
            <tr>
            <td colspan="3">
                     <asp:GridView ID="grvActs" runat="server" AutoGenerateColumns="False" DataKeyNames="actId,existe">
                         <Columns>
                             <asp:BoundField HeaderText="Actividad" DataField="actDescripcion"/>
                             <asp:TemplateField HeaderText="Número Sesiones">
                                 <ItemTemplate>
                                     <ml:TextBox ID="TextBox1" runat="server" MaxLength="2" TipoTextBox="Entero" 
                                         Width="30px" Text='<%#bind("autNumSesiones")%>'></ml:TextBox>
                                 </ItemTemplate>
                             </asp:TemplateField>
                         </Columns>
                    </asp:GridView>
            </td>
            
            </tr>
        </table>
        </asp:Panel>
        <br />
        <hr />

    <uc5:UsuarioAudit ID="UsuarioAudit2" runat="server" />
    
</asp:Content>
