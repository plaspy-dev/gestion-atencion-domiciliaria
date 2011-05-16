<%@ Page Title="Autorización" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdAutorizacionMasiva.aspx.vb" Inherits="ML.PhdAutorizacionMasiva" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/pacProgramacion.ascx" tagname="pacProgramacion" tagprefix="uc3" %>
<%@ Register src="../Controles/ProgramacionesAut.ascx" tagname="ProgramacionesAut" tagprefix="uc4" %>
<%@ Register src="../Controles/ListaMulti.ascx" tagname="ListaMulti" tagprefix="uc5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:Panel runat="server" ID="pnlAut">
    <table class="style1">
            <tr>
                <td>
                    Paciente
                </td>
                <td colspan="3">
                    <uc5:ListaMulti ID="ListaMulti1" runat="server" MostrarAlBuscar="True" 
                        NomTabla="PacientesTotalDisan" />

                </td>
            </tr>
            <tr>
                <td>
                    Fecha
                </td>
                <td style="margin-left: 40px" >
                    <uc2:Fecha ID="fecAut" runat="server"  OrigenDatos="autFecha" Requerido="True" 
                        ValidationGroup="Guardar" />
                   
                </td>
                <td>
                    Fecha Vencimiento
                </td>
                <td style="margin-left: 40px" >
                    <uc2:Fecha ID="fecVenc" runat="server"  OrigenDatos="autFechaVenc" Requerido="true" ValidationGroup="Guardar" />
                </td>
            </tr>
            </table>
         <asp:GridView ID="grvActs" runat="server" AutoGenerateColumns="False" DataKeyNames="actId,existe">
             <Columns>
                 <asp:BoundField HeaderText="Actividad" DataField="actDescripcion"/>
                 <asp:TemplateField HeaderText="Número Sesiones">
                     <ItemTemplate>
                         <ml:TextBox ID="TextBox1" runat="server" MaxLength="2" TipoTextBox="Entero" 
                             Width="30px" Text='<%#bind("autNumSesiones")%>'></ml:TextBox>
                     </ItemTemplate>
                 </asp:TemplateField>
                 <asp:TemplateField HeaderText="Sesiones/Día">
                     <ItemTemplate>
                         <ml:TextBox ID="TextBox2" runat="server" MaxLength="2" TipoTextBox="Entero" 
                             Width="30px" Text='<%#bind("autSesionesDia")%>'></ml:TextBox>
                     </ItemTemplate>
                 </asp:TemplateField>
             </Columns>
                    </asp:GridView>
    <br />
    </asp:Panel>
    <asp:Panel ID="pnlPrg" runat="server" Visible="false">
        <asp:Literal ID="Literal1" runat="server"></asp:Literal>
    </asp:Panel>
</asp:Content>
