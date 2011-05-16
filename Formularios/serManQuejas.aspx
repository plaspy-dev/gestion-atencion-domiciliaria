<%@ Page Title="Formulario de Quejas y Reclamos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serManQuejas.aspx.vb" Inherits="ML.serManQuejas" %>
<%@ Register src="../Controles/ConPacientes.ascx" tagname="ConPacientes" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc3" %>
<%@ Register src="../Controles/Hora.ascx" tagname="Hora" tagprefix="uc4" %>
<%@ Register src="../Controles/UsuarioAudit.ascx" tagname="UsuarioAudit" tagprefix="uc5" %>
<%@ Register src="../Controles/pacProgramacion.ascx"tagname="pacProgramacion" tagprefix="uc6" %>
<%@ Register src="../Controles/Correo.ascx" tagname="Correo" tagprefix="uc7" %>
<%@ Register src="../Controles/ListaMulti.ascx" tagname="ListaMulti" tagprefix="uc8" %>
<%@ Register src="../Controles/Lista.ascx" tagname="Lista" tagprefix="uc9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">

    <asp:RadioButtonList ID="rblTipoCliente" runat="server" AutoPostBack="True" RepeatDirection="Horizontal">
        <asp:ListItem Selected="True" Value="1">Cliente Externo</asp:ListItem>
        <asp:ListItem Value="2">Cliente Interno</asp:ListItem>
    </asp:RadioButtonList>
    
        <uc1:conpacientes ID="ConPacientes1" runat="server"  VerInactivos="true" OrigenDatos="pacId"/>
    
    <table runat="server" id="tblPer" visible="false">
    <tr><td colspan="2">
        <asp:RadioButtonList ID="rblTipoClienteInt" runat="server" AutoPostBack="True" RepeatDirection="Horizontal">
        <asp:ListItem Selected="True" Value="1">Cliente Externo Administrativo</asp:ListItem>
        <asp:ListItem Value="2">Cliente Interno Institucional</asp:ListItem>
    </asp:RadioButtonList>

    </td></tr>
        <tr>
            <td>
                Funcionario que se queja
            </td>
            <td>
                <uc3:DropDownListU ID="ddlPer" runat="server" AutoPostBack="True" NomTabla="PersonalAdministrativo" />
                <uc3:DropDownListU ID="ddlPerInst" runat="server" AutoPostBack="True" NomTabla="PersonalInstitucional" />
            </td>
        </tr>
    </table>
       <asp:Panel runat="server" id="pnlQ" Visible="false">
        <div style="border-width: medium ; border-color:Blue"/>
    <table >
    <tr><td class="celdaTitulo" colspan="2">
        <asp:Label ID="Label15" runat="server" SkinID="lblsubTitulo" 
            Text="Diligenciamiento"></asp:Label>
        </td><td class="celdaTitulo">
            <asp:Label ID="Label16" runat="server" SkinID="lblsubTitulo" Text="Opciones"></asp:Label>
        </td></tr>
    <tr><td>Fecha</td><td>
        <uc2:Fecha ID="fecForm" runat="server" OrigenDatos="qrFecha" Requerido="True" 
            ValidationGroup="Guardar" />
        </td>
        <%If ConPacientes1.Visible Then%>
        <td rowspan="8" valign="top">
    
        
                <asp:LinkButton ID="lnkPrg" runat="server">Ver Programaciones del último mes para este paciente</asp:LinkButton>
                <uc6:pacProgramacion ID="pacProgramacion1" runat="server"  
                MesesAgregar="-1"  />
                <hr />
                <asp:LinkButton ID="lnkCorreo" runat="server">Enviar Correo</asp:LinkButton>
            <uc7:Correo ID="Correo1" runat="server" TipoCorreo="ServicioAlCliente" />
                <hr />
                
        </td>
        <%End If%>
        </tr>
      <tr><td>Hora de Llamada</td><td>
          <uc4:Hora ID="Hora1" runat="server" Requerido="True" 
              ValidationGroup="Guardar" />
      </td></tr>
    <tr><td>Tipo</td><td>
        <uc3:DropDownListU ID="ddlTipo" runat="server" OrigenDatos="tqrIdTipo" />
        </td></tr>
    <tr><td colspan="2">
    <hr />
        Persona(s) involucrada(s):<br />
        <asp:RadioButtonList ID="rblTipoInvolucrado" runat="server" AutoPostBack="True" RepeatDirection="Horizontal">
                <asp:ListItem Selected="True" Value="1">Funcionario</asp:ListItem>
                <asp:ListItem Value="2">Paciente</asp:ListItem>
            </asp:RadioButtonList>
        Seleccione:
        <uc8:ListaMulti ID="ListaMultiCoor" runat="server" nomTabla="PersonalHS" MostrarAlBuscar="true" />
        <uc9:Lista ID="lstPac" runat="server" AutoPostBack="True" 
                    MostrarAlBuscar="True" OrigenDatos="Paciente" NomTabla="Paciente" />
    <hr />
        </td></tr>
    <%If ConPacientes1.Visible Then%>
    <tr><td>Persona que Llama</td><td>
        <ml:TextBox ID="txtPerLlama" runat="server" MaxLength="50" 
            OrigenDatos="qrPersonaLlama" Width="272px"></ml:TextBox>
        </td></tr>
        <%End If%>
    <%If ConPacientes1.Visible Then%>
    <tr><td>Parentesco</td><td>
        <ml:TextBox ID="txtParentesco" runat="server" MaxLength="50" 
            OrigenDatos="qrParentesco" Width="272px"></ml:TextBox>
        </td></tr>        
        <%End If%>
    <tr><td>Correo</td><td>
        <ml:TextBox ID="txteMail" runat="server" MaxLength="50" OrigenDatos="qrEmail" 
            Width="272px"></ml:TextBox>
        </td></tr>
    <%If ConPacientes1.Visible Then%>
    <tr><td>Teléfono</td><td>
        <ml:TextBox ID="txtTelefono" runat="server" MaxLength="25" 
            OrigenDatos="qrTelefono" Width="272px"></ml:TextBox>
        </td></tr>
        <%End If%>
    <tr><td>Detalle</td>
        <td colspan="2">
        <ml:TextBox ID="txtDetalle" runat="server" MaxLength="500" 
            OrigenDatos="qrDetalle" TextMode="MultiLine" Width="631px" Height="64px"></ml:TextBox>
        </td></tr>
    <tr><td>Observaciones</td>
        <td colspan="2">
        <ml:TextBox ID="txtObsHS" runat="server" MaxLength="500" OrigenDatos="qrObsHS" 
            TextMode="MultiLine" Width="630px" Height="63px"></ml:TextBox>
        </td></tr>
        <tr><td colspan="3" class="celdaTitulo">
        <asp:Label ID="lblSeg" runat="server" SkinID="lblsubTitulo" Text="Seguimiento"></asp:Label></td>
            </tr>
        <tr><td colspan="3">
            <asp:LinkButton ID="lnkSerg" runat="server">Registrar Seguimiento</asp:LinkButton>
            <ml:GridView ID="grvSeg" runat="server" AutoGenerateColumns="False" 
                TotalPaginas="0" DataKeyNames="sqrId" EmptyDataText="No se ha registrado seguimiento">
                <Columns>
                    <asp:BoundField DataField="sqrDetalles" HeaderText="Detalle" />
                    <asp:BoundField DataField="sqrPendiente" HeaderText="Acciones Pendientes" />
                    <asp:BoundField DataField="segUsuarioIngreso" HeaderText="Usuario" />
                    <asp:BoundField DataField="segFechaIngreso" HeaderText="Fecha" />
                </Columns>
            </ml:GridView>
        </td></tr>
        <tr><td style="text-align: center">
                &nbsp;</td></tr>
    <tr><td colspan="2">
        <uc5:UsuarioAudit ID="UsuarioAudit1" runat="server" />
        </td><td>
            &nbsp;</td></tr>
    </table>
    
    <asp:Panel ID="pnlNuevo" runat="server" Visible="false">
    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="400px">
    <asp:Panel ID="pnlTitulo" runat="server" Style=" height:10%;cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;">
                <div>
                    <p>Nuevo Registro de Seguimiento</p>
                </div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" >
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
    <ContentTemplate>
    <table class="style1" border="1">
    <tr>
            <td>
                <asp:Label ID="Label12" runat="server" Text="Detalles"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtDetSeg" runat="server" MaxLength="1000" Requerido="True" 
                     Width="300px" ValidationGroup="GuardarAut" Height="60px" 
                    TextMode="MultiLine"></ml:TextBox>
            </td>
        </tr>
            <tr>
            <td>
                <asp:Label ID="Label14" runat="server" Text="Acciones Pendientes"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtPendSeg" runat="server" MaxLength="1000" 
                     Width="300px" Height="63px" TextMode="MultiLine" ></ml:TextBox>
            </td>
        </tr>
    <tr>
            <td colspan="2">
                <ml:CheckBox ID="chkCerrar" runat="server" 
                    Text="ESTA ACCION CIERRA LA QUEJA?" />
            </td>
        </tr>
        <tr>
            <td colspan="2"></td>
        </tr>
        <tr id="trRespUs">
            <td colspan="2">
                <ml:CheckBox ID="chkRespUs" runat="server" Text="Se envió respuesta al Usuario?" />
            </td>
        </tr>
        <tr id="trRespTel">
            <td colspan="2">
                <ml:CheckBox ID="chkRespTel" runat="server" Text="Se envió respuesta telefónica?" />    
            </td>
        </tr>
        <tr id="trRespAseg">
            <td colspan="2">
                <ml:CheckBox ID="chkRespAseg" runat="server" Text="Se envió respuesta al Asegurador?" />
            </td>
        </tr>
        <tr id="trRespEntVig">
            <td colspan="2">
                <ml:CheckBox ID="chkRespEntVig" runat="server" Text="Se envió respuesta al ente de vigilania y control?" />
            </td>
        </tr>
    </table>
            <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic"
                ClientValidationFunction="validaCierreQR" ControlToValidate="txtDetSeg" ValidateEmptyText="true" ValidationGroup="GuardarAut"
                >Recuerde que una queja/Reclamo solo puede cerrarse si se ha enviado:<br /> 1.Respuesta al usuario<br />2.Respuesta telefónica<br />3.Respuesta al asegurador o al ente de vigilancia y control </asp:CustomValidator>
            <script type="text/javascript">
                function valChkSeg() {
                    getEl("trRespUs").style.display = getEl("<%=chkCerrar.ClientID%>").checked ? "block" : "none";
                    getEl("trRespTel").style.display = getEl("<%=chkCerrar.ClientID%>").checked ? "block" : "none";
                    getEl("trRespAseg").style.display = getEl("<%=chkCerrar.ClientID%>").checked ? "block" : "none";
                    getEl("trRespEntVig").style.display = getEl("<%=chkCerrar.ClientID%>").checked ? "block" : "none";
                }
                getEl("<%=chkCerrar.ClientID%>").onclick = valChkSeg;
                valChkSeg();
                function validaCierreQR(objSource, objArgs) {
                    if (getEl("<%=chkCerrar.ClientID%>").checked) {
                        var cUs = getEl("<%=chkRespUs.ClientID%>").checked;
                        var cTel = getEl("<%=chkRespTel.ClientID%>").checked;
                        var cAseg = getEl("<%=chkRespAseg.ClientID%>").checked;
                        var cEntVig = getEl("<%=chkRespEntVig.ClientID%>").checked;
                        objArgs.IsValid = cUs && cTel && (cAseg || cEntVig);
                    }
                    else
                        objArgs.IsValid = true;
                }
            </script>
          </ContentTemplate>
</asp:UpdatePanel>
    </asp:Panel> 
    <asp:LinkButton ID="lnkGuardar" runat="server" ValidationGroup="GuardarAut">Aceptar</asp:LinkButton>
        &nbsp;
    <asp:LinkButton ID="lnkCancelar" runat="server">Cancelar</asp:LinkButton>
    <br />
</asp:Panel>
    <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>

<asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
    BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True"  
    TargetControlID="lnkAux" PopupControlID="Panel1" CancelControlID="" OkControlID=""
    DropShadow="true"
    PopupDragHandleControlID="pnlTitulo">
</asp:ModalPopupExtender>
 
    </asp:Panel>
    </asp:Panel>
</asp:Content>
