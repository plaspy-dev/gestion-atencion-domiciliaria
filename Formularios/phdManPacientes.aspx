<%@ Page Title="Pacientes" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdManPacientes.aspx.vb" Inherits="ML.PHDManPacientes" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<%@ Register src="../Controles/Lista.ascx" tagname="Lista" tagprefix="uc3" %>
<%@ Register src="../Controles/UsuarioAudit.ascx" tagname="UsuarioAudit" tagprefix="uc4" %>
<%@ Register src="../Controles/AuditServicios.ascx"tagname="AuditServicios" tagprefix="uc5" %>
<%@ Register src="../Controles/pacProgramacion.ascx"tagname="pacProgramacion" tagprefix="uc6" %>
<%@ Register src="../Controles/Correo.ascx" tagname="Correo" tagprefix="uc7" %>

<%@ Register src="../Controles/CargaFoto.ascx" tagname="CargaFoto" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
            border-style:none;
        }
        .style2
        {
            width: 5px;
            border-style:none;
        }
       
        .style5
        {
            width: 200px;
            border-style:none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:Panel runat="server" ID="pnlDatosPac">

    <div id="divImp">
    <table class="style1" cellpadding="0" cellspacing="0" border="1">
        <tr>
            <td colspan="4" style="text-align: center" class="celdaTitulo" >
                <asp:Label ID="Label32" runat="server" SkinID="lblsubTitulo" 
                    Text="Información personal"></asp:Label>
            </td>
            <td class="style2" rowspan="24">    
             </td>
            <td class="celdaTitulo" style="width: 150px;">
                <asp:Label ID="Label33" runat="server" SkinID="lblsubTitulo" Text="Autorizaciones vigentes" Width="120px"></asp:Label>
            </td>
        </tr>
        <tr>
            <td rowspan="4">
                <asp:ImageButton runat="server" BorderWidth="1px" Height="100px" Width="100px" ID="imbFoto"></asp:ImageButton>
                <br />
                <asp:LinkButton runat="server" ID="lnkElimFoto">Eliminar Foto</asp:LinkButton>
            </td>
            <td rowspan="4">
                Tipo Documento
                <br />
                <uc2:DropDownListU ID="ddlTipDoc" runat="server" OrigenDatos="tdocId" />
                <br />
                <br />
                Documento
                                <ml:TextBox ID="txtDocumento" runat="server" MaxLength="50" 
                    OrigenDatos="pacDocumento" Requerido="True" ValidationGroup="Guardar" 
                    Width="280px" AutoPostBack="true"></ml:TextBox>

            </td>
            <td >
                Primer Apellido
            </td>
            <td>
                <ml:TextBox ID="txtPApe" runat="server" MaxLength="50" 
                    OrigenDatos="pacPApellido" Requerido="True" ValidationGroup="Guardar" 
                    Width="280px"></ml:TextBox>
            </td>
            <td rowspan="27" valign="top" class="style5">
                    <div runat="server" id="dvAut"></div>           
                <br />
                <br />
                <hr />
                Observaciones Adicionales
                <br />
                <ml:TextBox ID="txtObs" runat="server" MaxLength="500" 
                    TextMode="MultiLine" Width="171px" OrigenDatos="pacObservaciones" 
                    Height="172px"></ml:TextBox>
            </td>
         </tr>
        <tr>
            <td>
                Segundo Apellido
            </td>
            <td>
                <ml:TextBox ID="txtSApe" runat="server"  MaxLength="50" 
                    OrigenDatos="pacSApellido" Width="280px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Primer Nombre
            </td>
            <td>
                <ml:TextBox ID="txtPNom" runat="server" MaxLength="50" OrigenDatos="pacPNombre" 
                    Requerido="True" ValidationGroup="Guardar" Width="280px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Segundo Nombre
            </td>
            <td>
                <ml:TextBox ID="txtSNom" runat="server" MaxLength="50" OrigenDatos="pacSNombre" 
                    Width="280px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Sexo
            </td>
            <td>
                <uc2:DropDownListU ID="ddlSexo" runat="server" OrigenDatos="sexoId" />
            </td>
            <td>
                Fecha Nacimiento
            </td>
            <td>
                <uc1:Fecha ID="fecNacimiento" runat="server" OrigenDatos="pacFechaNac" 
                    Requerido="True" ValidationGroup="Guardar" />
                <asp:Label ID="lblEdad" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Dirección
            </td>
            <td>
                <ml:TextBox ID="txtDir" runat="server" MaxLength="100" 
                    OrigenDatos="pacDireccion" Width="252px"></ml:TextBox>
            </td>
            <td>
                Barrio
            </td>
            <td>
                <ml:TextBox ID="txtBarrio" runat="server" MaxLength="50" 
                    OrigenDatos="pacBarrio" Width="278px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Teléfono
            </td>
            <td>
                <ml:TextBox ID="txtTelefono" runat="server" MaxLength="50" 
                    OrigenDatos="pacTelefono" Width="172px"></ml:TextBox>
            </td>
            <td>
                Teléfono1
            </td>
            <td>
                <ml:TextBox ID="txtTelefono1" runat="server" MaxLength="50" 
                    OrigenDatos="pacTelefono1" Requerido="False" Width="278px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Celular
            </td>
            <td>
                <ml:TextBox ID="txtCelular" runat="server" MaxLength="50" 
                    OrigenDatos="pacCelular" Width="173px"></ml:TextBox>
            </td>
            <td>
                Correo
            </td>
            <td>
                <ml:TextBox ID="txtCorreo" runat="server" MaxLength="50" 
                    OrigenDatos="pacCorreo" Width="280px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                Especificaciones de llegada
            </td>
            <td colspan="2">
                <ml:TextBox ID="txtEspLlegada" runat="server" MaxLength="500" 
                    OrigenDatos="pacEspecLlegada" Requerido="False" TextMode="MultiLine" 
                    Width="375px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="1">
                Localidad
            </td>
            <td>
                <uc2:DropDownListU ID="ddlLoc" runat="server" OrigenDatos="locId" />
            </td>
            <td colspan="1">
                Estrato
            </td>
            <td>
                <ml:TextBox ID="txtEstrato" runat="server" MaxLength="1" 
                    OrigenDatos="pacEstrato" TipoTextBox="Entero" Width="25px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td >
                Familiar Responsable
            </td>
            <td>
                <ml:TextBox ID="txtFamResponsable" runat="server" MaxLength="100" 
                    OrigenDatos="pacFamilarResponsable" Height="16px" Width="250px"></ml:TextBox>
            </td>
            <td>
                Parentesco
            </td>
            <td>
                <ml:TextBox ID="txtParentesco" runat="server" MaxLength="50" 
                    OrigenDatos="pacParentesco" Width="275px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td >
                Pago directo
            </td>
            <td>
                <uc2:DropDownListU ID="ddlPagoDir" runat="server" OrigenDatos="pdirId" />
            </td>
            <td>
                Carné
            </td>
            <td>
                <ml:TextBox ID="txtCarne" runat="server" MaxLength="50" OrigenDatos="pacCarne"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Zona</td>
            <td>
                <ml:TextBox ID="txtCelular0" runat="server" MaxLength="50" 
                    OrigenDatos="pacZona" Width="173px"></ml:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                <ml:CheckBox ID="chkSuministros" runat="server" 
                    OrigenDatos="pacEntregaSuministros" Text="Entregar Suministros??" />
            </td>
        </tr>
        <tr>
            <td class="celdaTitulo" colspan="4">
                <asp:Label ID="Label35" runat="server" SkinID="lblsubTitulo" 
                    Text="Información Asegurador"></asp:Label>
            </td>
        </tr>
        <tr>
            <td >
                Asegurador
            </td>
            <td>
                <uc2:DropDownListU ID="ddlAsegurador" runat="server" OrigenDatos="entId" 
                    TipoDato="Integer_"/>
            </td>
            <td style="margin-left: 160px">
                Médico de cabecera
            </td>
            <td>
                
                <uc2:DropDownListU ID="ddlMega" runat="server" OrigenDatos="megId" 
                    TipoDato="Integer_" />
            </td>
        </tr>
        <tr id="trDatosAsegurador">
            <td>
                Fecha de Ingreso al asegurador</td>
            <td>
                <uc1:Fecha ID="fecIngAseg" runat="server" OrigenDatos="pacFecIngAsegurador" 
                    Requerido="False" ValidationGroup="Guardar" />
            </td>
            <td style="margin-left: 160px">
                Grado</td>
            <td>
                <ml:TextBox ID="txtGrado" runat="server" MaxLength="50" 
                    OrigenDatos="pacGrado" Width="275px"></ml:TextBox>
            </td>
        </tr>
        <tr ID="trDatosAsegurador">
            <td>
                Tipo de afiliado</td>
            <td>
                <uc2:DropDownListU ID="ddlTipoAfil" runat="server" 
                    OrigenDatos="pacTipoAfiliado" />
            </td>
            <td style="margin-left: 160px">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="celdaTitulo" colspan="4">
                <asp:Label ID="Label36" runat="server" SkinID="lblsubTitulo" 
                    Text="Información Médica"></asp:Label>
            </td>
        </tr>
        <tr>
            <td >
                Tipo de Evento
            </td>
            <td>
                <uc2:DropDownListU ID="ddlTipEvento" runat="server" OrigenDatos="tipECod" />
            </td>
            <td style="margin-left: 160px">
                Fec Ing Programa
            </td>
            <td>
                <uc1:Fecha ID="fecIngProg" runat="server" OrigenDatos="pacFecIngPrograma" 
                    Requerido="True" ValidationGroup="Guardar" />
            </td>
        </tr>
        <tr>
            <td >
                Estado
            </td>
            <td>
                <uc2:DropDownListU ID="ddlEstancia" runat="server" OrigenDatos="estId" Enabled="false" />
            </td>
            <td style="margin-left: 160px">
                Numero ETB
            </td>
            <td>
                <ml:TextBox ID="txtNumETB" runat="server" MaxLength="50" TipoTextBox="Entero" OrigenDatos="pacNumeroETB"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td >
                Intensidad Terapias
            </td>
            <td>
                <ml:TextBox ID="txtIntensidad" runat="server" MaxLength="50" OrigenDatos="pacIntensidadTerapias"></ml:TextBox>
            </td>
            <td style="margin-left: 160px">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td >
                CIE 10
            </td>
            <td colspan="3">
                <uc3:Lista ID="lstCie10" runat="server" NomTabla="CIE10"  OrigenDatos="cieCodDx" WidthTexto="550"/>
            </td>
        </tr>
        <tr>
            <td >
                CIE 10_1
            </td>
            <td colspan="3">
                <uc3:Lista ID="lstCie10_1" runat="server" NomTabla="CIE10" OrigenDatos="cieCodDx_1" WidthTexto="550"/>
            </td>
        </tr>
        <tr>
            <td >
                CIE 10_2
            </td>
            <td colspan="3">
                <uc3:Lista ID="lstCie10_2" runat="server" NomTabla="CIE10" OrigenDatos="cieCodDx_2" WidthTexto="550"/>
            </td>
        </tr>
    </table>
    <br />
                
                <asp:Panel ID="pnlTitulo" runat="server" Width="250px">
        <asp:Label ID="lbltitulo" runat="server" Text="Acciones" SkinId="EtiquetaHand"></asp:Label>
        <asp:ImageButton ID="imbExp" runat="server"   CausesValidation="false" SkinID="imbBajar"/>
    </asp:Panel>

    <asp:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" 
        TargetControlID="pnlContenido" ExpandControlID="pnlTitulo" ExpandedText="(Ocultar)" CollapsedText="(Mostrar)" CollapseControlID="pnlTitulo"
        ImageControlID="imbExp"  AutoCollapse="False"
        AutoExpand="False"
        ExpandDirection="Vertical" Collapsed="True">
    </asp:CollapsiblePanelExtender>
    <asp:Panel ID="pnlContenido" runat="server" Width="250px">
        <hr />
                <asp:LinkButton ID="lnkCorreo" runat="server" SkinID="lnkEnlace">Enviar Correo</asp:LinkButton>
                <uc7:Correo ID="Correo1" runat="server" TipoCorreo="Paciente"/>
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>
                <asp:LinkButton ID="lnkPrg" runat="server" SkinID="lnkEnlace">Ver Programaciones del último mes</asp:LinkButton>
                <uc6:pacProgramacion ID="pacProgramacion1" runat="server" MesesAgregar="-1" />
                </ContentTemplate>
                </asp:UpdatePanel>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:LinkButton ID="lnkAudit" runat="server" SkinID="lnkEnlace">Ver Auditoría de Servicios</asp:LinkButton>
                <uc5:AuditServicios ID="AuditServicios1" runat="server" />
                </ContentTemplate>
                </asp:UpdatePanel>
        <hr />
    </asp:Panel>
    <hr />
    <uc4:UsuarioAudit ID="UsuarioAudit2" runat="server" />
    </div>
    <uc5:CargaFoto ID="CargaFoto1" runat="server" />
            <script type="text/javascript">
                function valAseg() {
                    var id = getEl('<%=ddlAsegurador.controlddl.ClientId %>').options[getEl('<%=ddlAsegurador.controlddl.ClientId %>').selectedIndex].value;
                    getEl('trDatosAsegurador').style.display = (id == '36' ? "block" : "none");
                }
                valAseg();
                getEl('<%=ddlAsegurador.controlddl.ClientId %>').onchange = valAseg;
        </script>
</asp:Panel>
    <asp:Panel runat="server" ID="pnlEgresoIngreso" Visible="false">
        <table>
            <tr>
                <td class="celdaTitulo" colspan="2">
                    <asp:Label ID="Label38" runat="server" SkinID="lblsubTitulo" 
                        Text="Datos de Activacion/Reactivación de servicio(s)"></asp:Label>
                </td>
            </tr>
            <tr runat="server" id="trIng">
                <td>
                    Causa
                </td>
                <td>
                    <uc2:DropDownListU ID="ddlCausaReing" runat="server"   Requerido="true" ValidationGroup="GrdEgr"/>
                </td>
            </tr>
            <tr runat="server" id="trEgr">
                <td>
                    Causa
                </td>
                <td>
                    <uc2:DropDownListU ID="ddlCausaEgr" runat="server"  Requerido="true" ValidationGroup="GrdEgr"/>
                </td>
            </tr>
            <tr>
                <td>
                    Fecha
                </td>
                <td>
                    <uc1:Fecha ID="fchReIngEgr" runat="server"   Requerido="true" ValidationGroup="GrdEgr"/>
                </td>
            </tr>
            <tr>
                <td>
                    Observaciones
                </td>
                <td>
                    <ml:TextBox ID="txtObsIngEgr" runat="server" MaxLength="100" TextMode="MultiLine"></ml:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:LinkButton ID="lnkAceptarEgr" runat="server"  ValidationGroup="GrdEgr">Aceptar</asp:LinkButton>
                    &nbsp;<asp:LinkButton ID="lnkCancelarEgr" runat="server">Cancelar</asp:LinkButton>
                </td>
            </tr>
        </table>

</asp:Panel>
</asp:Content>
