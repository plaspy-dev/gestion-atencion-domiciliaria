<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PrgRecurrente.ascx.vb" Inherits="ML.PrgRecurrente" %>
<%@ Register src="Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>

<style type="text/css">
    .style1
    {
        text-align:left ;
    }
    .style2
    {
    }
</style>

    <table class="style2" cellpadding="0" cellspacing="0" border="1" style="vertical-align:top;">
        <tr>
            <td>
                Inicio
            </td>
            <td>
                Fin
            </td>
        </tr>
        <tr>
            <td>
                <uc2:Fecha ID="fchIni" runat="server" Requerido="true" ValidationGroup="GuardarRec" />
            </td>
            <td>
                <uc2:Fecha ID="fchFin" runat="server" Requerido="true" ValidationGroup="GuardarRec" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
            <table>
            <tr>
                <td>
                    <asp:RadioButtonList ID="rblTipoPrg" runat="server" RepeatDirection="Horizontal" >
                        <asp:ListItem Selected="True" Value="1">Diario</asp:ListItem>
                        <asp:ListItem Value="2">Mediante patrón de repetición</asp:ListItem>
                        <asp:ListItem Value="3">Por día de la semana</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td align="left">
                    <div id="dvRep" class="Etiqueta">Cada<ml:TextBox ID="txtRep" runat="server" MaxLength="2" 
                            TipoTextBox="Entero" Width="24px"></ml:TextBox> &nbsp;Días</div>
                    <div id="dvDias" class="Etiqueta">
                        <asp:CheckBoxList ID="chklDiasSemana" runat="server" CssClass="Etiqueta" RepeatColumns="4">
                        <asp:ListItem Value="0">Domingo</asp:ListItem>
                        <asp:ListItem Value="1">Lunes</asp:ListItem>
                        <asp:ListItem Value="2">Martes</asp:ListItem>
                        <asp:ListItem Value="3">Miércoles</asp:ListItem>
                        <asp:ListItem Value="4">Jueves</asp:ListItem>
                        <asp:ListItem Value="5">Viernes</asp:ListItem>
                        <asp:ListItem Value="6">Sábado</asp:ListItem>
                        </asp:CheckBoxList>
                    </div>
                </td>
            </tr>
            </table>
            </td>
        </tr>
        <tr><td colspan="2">
                    <table border="1">
                    <tr><td colspan="2"><asp:Label runat="server" ID="lblEx" SkinId="EtiquetaHand">Excepciones</asp:Label></td></tr>
                    <tr id="trEx1">
                    <td>
                        <uc2:Fecha ID="fchEx1" runat="server" />
                    </td>
                    <td>
                        <uc2:Fecha ID="fchEx2" runat="server" />
                    </td>
                    </tr>
                    <tr id="trEx2">
                    <td>
                        <uc2:Fecha ID="fchEx3" runat="server" />
                    </td>
                    <td>
                        <uc2:Fecha ID="fchEx4" runat="server" />
                    </td>
                    </tr>
                    </table>
            </td></tr>
        <tr><td colspan="2">
            <asp:LinkButton ID="lnkAceptarPrg" runat="server" ValidationGroup="GuardarRec" Visible="false">Guardar Recurrencia</asp:LinkButton>
            <asp:LinkButton ID="lnkCancelarPrg" runat="server" Visible="false">Cancelar Recurrencia</asp:LinkButton></td></tr>
    </table>
    <script type="text/javascript">
        tablas = document.getElementsByName('<%=rblTipoPrg.UniqueID %>').length;
        document.getElementsByName('<%=rblTipoPrg.UniqueID %>').value = "1";
        for (a = 0; a < tablas; a++) {
            document.getElementsByName('<%=rblTipoPrg.UniqueID %>')[a].onclick = valTipoPrgRec;
        }
        document.getElementById('dvRep').style.display = document.getElementsByName('<%=rblTipoPrg.UniqueID %>')[1].checked?"block":"none";
        document.getElementById('dvDias').style.display = document.getElementsByName('<%=rblTipoPrg.UniqueID %>')[2].checked?"block":"none";
        
        function valTipoPrgRec() {
            document.getElementById('dvRep').style.display = this.value == "2" ? "block" : "none";
            document.getElementById('dvDias').style.display = this.value == "3" ? "block" : "none";
        }
        var verEx = 1;
        function verExcep() {
            verEx = verEx == 0 ? 1 : 0;
            document.getElementById('trEx1').style.display = verEx == 1 ? "block" : "none";
            document.getElementById('trEx2').style.display = verEx == 1 ? "block" : "none";
            document.getElementById('<%=lblEx.clientId%>').innerText = (verEx == 1 ? "Ocultar" : "Mostrar") + " Excepciones";
        }
        verExcep();

        function idFecI(){return document.getElementById('<%=fchIni.txtClientId%>').value;}
        function idFecF() { return document.getElementById('<%=fchFin.txtClientId%>').value; }
        function idFecEx1() { return document.getElementById('<%=fchEx1.txtClientId%>').value; }
        function idFecEx2() { return document.getElementById('<%=fchEx2.txtClientId%>').value; }
        function idFecEx3() { return document.getElementById('<%=fchEx3.txtClientId%>').value; }
        function idFecEx4() { return document.getElementById('<%=fchEx4.txtClientId%>').value; }
        function idRep() { return document.getElementById('<%=txtRep.ClientId%>').value; }
 
        function retDias() {
            var ret="";
            for (var i = 0; i < 7; i++) {
                if (document.getElementById("<%=chklDiasSemana.clientId %>").options[i].checked)
                    ret += i.toString()+",";
            }
            return ret;            
        }
        function retTipoSel() {
            var ind = document.getElementById("<%=rblTipoPrg.clientId %>").selectedIndex;
            var tipo = "0";
            if (ind > 0)
                tipo = document.getElementById("<%=rblTipoPrg.clientId %>").options[ind].value;
            return tipo;
        }
    </script>

