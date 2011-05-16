<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ManProgramacion.ascx.vb" Inherits="ML.ManProgramacion" %>
<%@ Register src="Autorizacion.ascx" tagname="Autorizacion" tagprefix="uc5" %>
<%@ Register src="DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc4" %>
<%@ Register src="Hora.ascx" tagname="Hora" tagprefix="uc3" %>
<%@ Register src="Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="PrgRecurrente.ascx" tagname="PrgRecurrente" tagprefix="uc6" %>

<style type="text/css">
    .style1
    {
        text-align:left ;        
        width:500px;

    }
    .style2
    {
        
    }
</style>
<asp:Panel ID="pnlPricipal" runat="server" CssClass="modalPopup">
<asp:Panel ID="Panel1" runat="server" Style="width:500px;height:400px;overflow:auto;vertical-align:top;" >
    <asp:Panel ID="pnlTitulo" runat="server" Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small; height:20px; width: 490px;">
                <div>
                    <p class="" style="width:100%">Programación Servicios Médicos</p>
                </div>
            </asp:Panel>

    <div id="DivN">
    
    <asp:Panel ID="Panel2" runat="server">
 
    <table class="style1">
        <tr id="tr1">
            <td colspan="2">
                <asp:RadioButtonList ID="rblTipoPrg" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Text="Fecha Única" value="1" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Recurrente" value="2"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
    <tr id="trFecha">
            <td>
                Fecha
            </td>
            <td>
                <uc2:Fecha ID="Fecha1" runat="server" ValidationGroup="GuardarAut"/>                
                 <asp:Label ID="lblPrgRec" runat="server" Text="" SkinID="lblFormatoFecha"></asp:Label>
            </td>
        </tr>
        <tr id="trRec">
            <td colspan="2">
            <uc6:PrgRecurrente ID="PrgRecurrente1" runat="server"  />
            </td>
        </tr>
   <%-- <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Hora"></asp:Label>
            </td>
            <td>
                <uc3:Hora ID="Hora1" runat="server" Requerido="True" ValidationGroup="GuardarAut"/>
            </td>
        </tr>--%>
        <tr><td colspan="2"><hr /></td></tr>
    <tr>
            <td>
                Actividad
            </td>
            <td>
                <uc4:DropDownListU ID="ddlAct" runat="server" Requerido="True" 
                    ValidationGroup="GuardarAut" AutoPostBack="true"/>                    
                <div id="dvSA" style="display:none;"><asp:LinkButton ID="lnkSubAct" runat="server" ToolTip="Seleccionar subactividades">SubActividades</asp:LinkButton><%=getNumSA()%></div>
            </td>
        </tr>
    <tr>
            <td>
                Profesional
            </td>
            <td>
                 <asp:RadioButtonList ID="rblPerInac" runat="server" RepeatDirection="Horizontal" AutoPostBack="true">
                    <asp:ListItem Text="Ver Activos" value="1" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Ver Inactivos" value="2"></asp:ListItem>
                </asp:RadioButtonList>
                <uc4:DropDownListU ID="ddlProf" runat="server" Requerido="True" ValidationGroup="GuardarAut" />
            </td>
        </tr>
    <tr>
            <td>
                Num Sesiones/Día
            </td>
            <td>
                <ml:TextBox ID="txtNS" runat="server" TipoTextBox="Entero" MaxLength="2" Requerido="true" ValidationGroup="GuardarAut" Width="40px"></ml:TextBox>
                <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="el valor debe ser mayor a cero" ControlToValidate="txtNS" Operator="GreaterThan" ValueToCompare="0" Type="Integer" ValidationGroup="GuardarAut"></asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td valign="top">
                Autorización
            </td>
            <td>
                <asp:UpdatePanel runat="server">
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlAct"/>
                    </Triggers>
                    <ContentTemplate>
                        <uc4:DropDownListU ID="ddlAut" runat="server" Requerido="True" ValidationGroup="GuardarAut"/>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                <div id="divAut"></div>
            </td>
        </tr>
            <tr>
            <td valign="top">
                Observaciones
            </td>
            <td>
                <ml:TextBox ID="txtObs" runat="server" MaxLength="255" TextMode="MultiLine" Width="200px"></ml:TextBox>
            </td>
        </tr>
        
  </table>
  
    </asp:Panel> 
    <asp:Panel runat="server" ID="pnlSubAct" Visible="false" EnableViewState="true">
    <table border="1">
    <tr>
    <th></th>
    <th></th>
    </tr>
    <tr>
    <td>
    Digite un criterio y haga click en "Buscar":<br />  
    <ml:TextBox runat="server" ID="txtBusSA"></ml:TextBox><asp:LinkButton runat="server" ID="lnkBusSA">Buscar</asp:LinkButton>
        <ml:GridView runat="server" ID="grvSubAct" DataKeyNames="sacId" AutoGenerateColumns="false"
            AllowPaging="true">
            <Columns>
                <asp:BoundField DataField="sacDescripcion" HeaderText="Nombre" />
                <asp:TemplateField HeaderText="Sel">
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="chkSA" Checked='<%#GetSelSA(Eval("sacId"))%>' />
                </ItemTemplate>            
                </asp:TemplateField>
            </Columns>
        </ml:GridView>
    </td>
    <td style="text-align:left;vertical-align:top;">
        <div style="text-align:left;vertical-align:top;"><%=getTxtSA()%></div>
    </td>
    </tr>
    </table>
     <asp:LinkButton ID="lnkAceptarSA" runat="server" >Aceptar Selección</asp:LinkButton>
     <asp:LinkButton ID="lnkCancelarSA" runat="server">Cancelar Selección</asp:LinkButton>
</asp:Panel>
    </div>
<div id="dvRec">

</div>
    <br />
</asp:Panel>


  <asp:HiddenField runat="server" ID="hdfPacId" />
  <asp:HiddenField runat="server" ID="hdfModo" />
    <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>
  <asp:LinkButton ID="lnkGuardar" runat="server" ValidationGroup="GuardarAut">Aceptar</asp:LinkButton>
    <asp:LinkButton ID="lnkCancelar" runat="server" OnClientClick="valVerPrg('0');">Cancelar</asp:LinkButton>

</asp:Panel>

<asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
    BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True"  
    TargetControlID="lnkAux" PopupControlID="pnlPricipal" CancelControlID="lnkCancelar" OkControlID=""
    DropShadow="false"
    PopupDragHandleControlID="pnlTitulo">
</asp:ModalPopupExtender>
<asp:HiddenField runat="server" ID="hddConf" Value="0"/>
<script type="text/javascript">
    tablas = document.getElementsByName('<%=rblTipoPrg.UniqueID %>').length;
    for (a = 0; a < tablas; a++) {
        document.getElementsByName('<%=rblTipoPrg.UniqueID %>')[a].onclick = valTipo;
    }
    if (document.getElementById('trRec')) {
        document.getElementById('trRec').style.display = document.getElementsByName('<%=rblTipoPrg.UniqueID %>')[1].checked ? "block" : "none";
        document.getElementById('trFecha').style.display = document.getElementsByName('<%=rblTipoPrg.UniqueID %>')[0].checked ? "block" : "none";
    }
    function valTipo(aa) {
        document.getElementById('trRec').style.display = this.value == "2" ? "block" : "none";
        document.getElementById('trFecha').style.display = this.value == "1" ? "block" : "none";
    }
    function validarAuto() {        
        var pacId = "<%=PacId%>";
        var numAut = document.getElementById("<%=ddlAut.ControlDdl.ClientId%>").value;
        var ind = document.getElementById("<%=ddlAct.ControlDdl.clientId %>").selectedIndex;
        var actId = 0;
        if (ind > 0)
            actId = document.getElementById("<%=ddlAct.ControlDdl.clientId %>").options[ind].value;           
        var tipo = "1"
        valSubAct(actId);
        PageMethods.ValidarAuto(pacId, numAut, actId, tipo, retVal, enErrorVal);
    }
    document.getElementById("<%=ddlAut.ControlDdl.ClientId%>").onchange = validarAuto;
    if (document.getElementById("<%=ddlAct.ControlDdl.clientId%>")) {
        var ind = document.getElementById("<%=ddlAct.ControlDdl.clientId%>").selectedIndex;
        var actId = 0;
        if (ind > 0)
            actId = document.getElementById("<%=ddlAct.ControlDdl.clientId %>").options[ind].value;
        valSubAct(actId);
    }
    function valSubAct(actId) {
        if (document.getElementById('dvSA')) document.getElementById('dvSA').style.display = actId == 44 ? "block" : "none";
    }
    function retVal(oretVal) {
        document.getElementById("divAut").innerHTML = oretVal;
    }
    function enErrorVal(mensaje) {
        alert(mensaje.get_message())
    }
</script>