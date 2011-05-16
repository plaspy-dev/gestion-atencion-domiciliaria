<%@ Page Title="Autorización" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdAutorizacionMant.aspx.vb" Inherits="ML.PhdAutorizacionMant" %>
<%@ Register src="../Controles/Lista.ascx" tagname="Lista" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/pacProgramacion.ascx" tagname="pacProgramacion" tagprefix="uc3" %>
<%@ Register src="../Controles/ProgramacionesAut.ascx" tagname="ProgramacionesAut" tagprefix="uc4" %>
<%@ Register src="../Controles/UsuarioAudit.ascx" tagname="UsuarioAudit" tagprefix="uc5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table>
            <tr>
                <td>
                    Número
                </td>
                <td colspan="3">
                    <ml:TextBox ID="txtNumAut" runat="server" MaxLength="50" 
                        Width="239px" OrigenDatos="autNumero" Requerido="False" 
                        ValidationGroup="Guardar" ></ml:TextBox>
                        &nbsp;<asp:CheckBox ID="chkAutom" runat="server" Text="Generar número automático" 
                        Visible="False" />
                </td>
            </tr>
            <tr id="trPre" runat="server">
                <td colspan="2">
                    <asp:RadioButtonList ID="rblPreAut" runat="server">
                    <asp:ListItem Text="Es PreAutorización" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Es autorización Definitiva" Value="2"></asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td>
                    Paciente
                </td>
                <td colspan="3">
                    <uc1:lista ID="lstPac" runat="server" AutoPostBack="True" 
                    MostrarAlBuscar="True" NomTabla="PacientesTotal" />

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
            <tr>
                <td>Valor Copago</td>
                <td style="margin-left: 40px">
                    $<ml:TextBox ID="txtValCopago" runat="server" TipoTextBox="Float" ToolTip="Valor cancelado por Copago"></ml:TextBox>
                   
                </td>
                <td style="margin-left: 40px">
                    Número recibo copago</td>
                <td style="margin-left: 40px">
                    <ml:TextBox ID="txtNroReciboCopago" runat="server" TipoTextBox="Entero" ToolTip="Número de recibo de caja donde se registra el pago del copago"></ml:TextBox>
                   
                </td>
            </tr>
            <tr>
                <td>Valor Copago2</td>
                <td style="margin-left: 40px">
                    $<ml:TextBox ID="txtValCopago2" runat="server" TipoTextBox="Float" ToolTip="Valor cancelado por Copago"></ml:TextBox>
                   
                </td>
                <td style="margin-left: 40px">
                    Número recibo copago2</td>
                <td style="margin-left: 40px">
                    <ml:TextBox ID="txtNroReciboCopago2" runat="server" TipoTextBox="Entero" ToolTip="Número de recibo de caja donde se registra el pago del copago"></ml:TextBox>
                   
                </td>
            </tr>
            <tr>
                <td>Valor Copago3</td>
                <td style="margin-left: 40px">
                    $<ml:TextBox ID="txtValCopago3" runat="server" TipoTextBox="Float" ToolTip="Valor cancelado por Copago"></ml:TextBox>
                   
                </td>
                <td style="margin-left: 40px">
                    Número recibo copago3</td>
                <td style="margin-left: 40px">
                    <ml:TextBox ID="txtNroReciboCopago3" runat="server" TipoTextBox="Entero" ToolTip="Número de recibo de caja donde se registra el pago del copago"></ml:TextBox>
                   
                </td>
            </tr>
            <tr>
                <td>Valor Copago4</td>
                <td style="margin-left: 40px">
                    $<ml:TextBox ID="txtValCopago4" runat="server" TipoTextBox="Float" ToolTip="Valor cancelado por Copago"></ml:TextBox>
                   
                </td>
                <td style="margin-left: 40px">
                    Número recibo copago4</td>
                <td style="margin-left: 40px">
                    <ml:TextBox ID="txtNroReciboCopago4" runat="server" TipoTextBox="Entero" ToolTip="Número de recibo de caja donde se registra el pago del copago"></ml:TextBox>
                   
                </td>
            </tr>
            <tr>
                <td colspan="4">Observaciones
                    <ml:TextBox ID="txtObs" runat="server" MaxLength="200" 
                        OrigenDatos="autObservaciones" Width="311px"></ml:TextBox>
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
                 <asp:TemplateField HeaderText="Sesiones/Día">
                     <ItemTemplate>
                         <ml:TextBox ID="TextBox2" runat="server" MaxLength="2" TipoTextBox="Entero" 
                             Width="30px" Text='<%#bind("autSesionesDia")%>'></ml:TextBox>
                     </ItemTemplate>
                 </asp:TemplateField>
             </Columns>
                    </asp:GridView>
            </td>
            <td style="vertical-align:top; border-style:solid;">
            Otras Autorizaciones vigentes:
            <div runat="server" id="dvAut"></div></td>
            </tr>
        </table>
    <br />
    <asp:Panel ID="pnlPrg" runat="server" Visible="false">
        <asp:LinkButton ID="lnkPrg" runat="server">Ver Programaciones autorizadas</asp:LinkButton>
        <asp:LinkButton ID="lnvProgramar" runat="server">Asignar Programaciones</asp:LinkButton>
        <uc4:ProgramacionesAut ID="ProgramacionesAut1" runat="server" />
        
        <ml:Panel runat="server" ID="pnlProgramaciones" Titulo="Servicios Programados" Height="300px" Width="500px">
            <asp:GridView runat="server" ID="grvProg" AutoGenerateColumns="false" EnableViewState="false">
                <Columns>
                    <asp:BoundField HeaderText="Id" DataField="prgId"/>
                    <asp:TemplateField HeaderText="Tipo Servicio">
                        <ItemTemplate>
                            <%#IIf(Eval("prgTipo") = 1, "Servicios Medicos", IIf(Eval("prgTipo") = 2, "Terapias", "Médico Domiciliario"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Fecha" DataField="prgFechaProg" DataFormatString="{0:dd/MM/yyyy}"/>
                    <asp:BoundField HeaderText="Actividad" DataField="actDescripcion"/>
                    <asp:BoundField HeaderText="Profesional" DataField="perNombre"/>
                </Columns>
            </asp:GridView>
        </ml:Panel>
    </asp:Panel>
        <hr />

    <uc5:UsuarioAudit ID="UsuarioAudit2" runat="server" />
    
    <script type="text/javascript">
        var tr = document.getElementById("<%=trPre.ClientID %>")
        if (tr) {
            var ck = document.getElementById("<%=chkAutom.ClientID %>")
            var rbl = document.getElementById("<%=rblPreAut.ClientID %>")
            function valPre() {
                tr.style.display = ck.checked ? "block" : "none";
            }
            ck.onclick = valPre;
            valPre();
        }
    </script>
</asp:Content>
