<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Novedad.ascx.vb" Inherits="ML.Novedad_" %>
<%@ Register src="DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc4" %>
<style type="text/css">
    .style1
    {
        width: 100%;
        text-align:left ;
    }
    .style2
    {
        width: 100%;
    }
</style>
<asp:Panel ID="pnlPricipal" runat="server" CssClass="modalPopup" Width="550px">
    <asp:Panel ID="pnlTitulo" runat="server" Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small; height:20px">
                <div>
                    <p class="">Novedad Programación</p>
                </div>
            </asp:Panel>
    <asp:Panel ID="pnlPrg" runat="server" Style="vertical-align:top;">
    <table class="style1">
    <tr>
            <td colspan="2">
                Tipo Novedad
            </td>
     </tr> 
    <tr>
           <td colspan="2">
                <asp:RadioButtonList ID="rblTipo" runat="server" RepeatColumns="3" RepeatDirection="Vertical">
                <asp:ListItem Text="Cancelación Programación" value="1" Selected="True"></asp:ListItem>
                <asp:ListItem Text="Reasignación" value="2"></asp:ListItem>
                <asp:ListItem Text="Cambio en num. sesiones" value="4"></asp:ListItem>
                <asp:ListItem Text="Paciente desprotegido" value="5"></asp:ListItem>
                <asp:ListItem Text="Cambio Servicio" value="6"></asp:ListItem>
                <asp:ListItem Text="Otro" value="3"></asp:ListItem>                
                </asp:RadioButtonList>
                <hr />
            </td>
        </tr>
    <tr id="trCausa">
            <td>
                Causa
            </td>
            <td>
                <uc4:DropDownListU ID="ddlCausa" runat="server"/>
            </td>
        </tr>
    <tr id="trCausa1">
            <td>
                Causa
            </td>
            <td>
                <uc4:DropDownListU ID="ddlCausa1" runat="server"/>
            </td>
        </tr>
        <tr id="trProf">
            <td>
                Profesional
            </td>
            <td>
               <asp:RadioButtonList ID="rblPerInac" runat="server" RepeatDirection="Horizontal" AutoPostBack="true">
                    <asp:ListItem Text="Ver Activos" value="1" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Ver Inactivos" value="2"></asp:ListItem>
                </asp:RadioButtonList>

                <uc4:DropDownListU ID="ddlProf" runat="server" Requerido="True" 
                    ValidationGroup="GuardarNov" />
            </td>
        </tr>
        <tr id="trCambioNS">
            <td>
                Causa
            </td>
            <td>
                <uc4:DropDownListU ID="ddlCausaNS" runat="server"/>
            </td>
            </tr>
       <tr  id="trCambioNS1">
            <td>
                Núm sesiones
            </td>
            <td>
                <ml:TextBox ID="txtNS" runat="server" Width="10px" MaxLength="1" TipoTextBox="Entero"></ml:TextBox>
            </td>
        </tr>
         <tr id="trDesprotegido">
            <td>
                Causa
            </td>
            <td>
                <uc4:DropDownListU ID="ddlCausaDesprot" runat="server"/>
            </td>
        </tr>
        <tr id="trCambioSer">
            <td>
                Causa
            </td>
            <td>
                <uc4:DropDownListU ID="ddlCausaCambioSer" runat="server"/>
            </td>
        </tr>
        <tr id="trCambioSer1">
            <td>
                Nuevo Servicio
            </td>
            <td>
                <uc4:DropDownListU ID="ddlServicio" runat="server"/>
            </td>
        </tr>
        <tr>
            <td>
                Observaciones
            </td>
            <td>
                <ml:TextBox ID="txtObs" runat="server" MaxLength="200" TextMode="MultiLine"></ml:TextBox>
            </td>
        </tr>
     </table>     
        <script type="text/javascript">

            tablas = document.getElementsByName('<%=rblTipo.UniqueID %>').length;
            for (a = 0; a < tablas; a++) {
                document.getElementsByName('<%=rblTipo.UniqueID %>')[a].onclick = valTipo;
            }
            document.getElementById('trProf').style.display = document.getElementsByName('<%=rblTipo.UniqueID %>')[1].checked ? "block" : "none";
            document.getElementById('trCausa').style.display = document.getElementsByName('<%=rblTipo.UniqueID %>')[0].checked ? "block" : "none";
            document.getElementById('trCausa1').style.display = document.getElementsByName('<%=rblTipo.UniqueID %>')[1].checked ? "block" : "none";
            document.getElementById('trCambioNS').style.display = document.getElementsByName('<%=rblTipo.UniqueID %>')[2].checked ? "block" : "none";
            document.getElementById('trCambioNS1').style.display = document.getElementsByName('<%=rblTipo.UniqueID %>')[2].checked ? "block" : "none";
            document.getElementById('trDesprotegido').style.display = document.getElementsByName('<%=rblTipo.UniqueID %>')[3].checked ? "block" : "none";
            document.getElementById('trCambioSer').style.display = document.getElementsByName('<%=rblTipo.UniqueID %>')[4].checked ? "block" : "none";
            document.getElementById('trCambioSer1').style.display = document.getElementsByName('<%=rblTipo.UniqueID %>')[4].checked ? "block" : "none";
            
            function valTipo() {
                document.getElementById('trProf').style.display = this.value == "2" ? "block" : "none";
                document.getElementById('trCausa').style.display = this.value == "1" ? "block" : "none";
                document.getElementById('trCausa1').style.display = this.value == "2" ? "block" : "none";
                document.getElementById('trCambioNS').style.display = this.value == "4" ? "block" : "none";
                document.getElementById('trCambioNS1').style.display = this.value == "4" ? "block" : "none";
                document.getElementById('trDesprotegido').style.display = this.value == "5" ? "block" : "none";
                document.getElementById('trCambioSer').style.display = this.value == "6" ? "block" : "none";
                document.getElementById('trCambioSer1').style.display = this.value == "6" ? "block" : "none";
            }
</script>

</asp:Panel>
<div style="width:500px;height:200px;overflow:auto;">
<asp:GridView ID="grvNov" runat="server" EmptyDataText="No se han registrado novedades" AutoGenerateColumns="false">
  <Columns>
  <asp:BoundField DataField="novId" HeaderText="Cons" />
  <asp:TemplateField HeaderText="Tipo de Novedad">
  <ItemTemplate>
  <asp:Label runat="server" id="lblTipo" SkinID="lblFormatoFecha" Text='<%#GetTN(Eval("novTipo"))%>'></asp:Label>
  </ItemTemplate>
  </asp:TemplateField>
  <asp:BoundField DataField="Causa" HeaderText="Causa" />
  <asp:BoundField DataField="ProfesionalAnt"  HeaderText="Profesional Involucrado"/>
  <asp:BoundField DataField="Profesional"  HeaderText="Profesional Asignado"/>
  <asp:BoundField DataField="novObs"  HeaderText="Obs"/>
  <asp:BoundField DataField="segUsuarioRegistro"  HeaderText="Usuario"/>
  <asp:BoundField DataField="segFechaRegistro"  HeaderText="Fecha"/>
  
  </Columns>
</asp:GridView>
</div>
      <br />
    <br />
    <br />
    <br />
    <br />

 <asp:LinkButton ID="lnkGuardar" runat="server" ValidationGroup="GuardarNov">Aceptar</asp:LinkButton>
    <asp:LinkButton ID="lnkCancelar" runat="server" OnClientClick="valVerNov('0');">Cancelar</asp:LinkButton>
    <br />
</asp:Panel>
  <asp:HiddenField runat="server" ID="hdfPacId" />
    <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>

<asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
    BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True"  
    TargetControlID="lnkAux" PopupControlID="pnlPricipal" CancelControlID="lnkCancelar" OkControlID=""
    DropShadow="false"
    PopupDragHandleControlID="pnlTitulo">
</asp:ModalPopupExtender>
