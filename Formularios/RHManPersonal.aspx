<%@ Page Title="Personal OrganizationExample15" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="RHManPersonal.aspx.vb" Inherits="ML.RHManPersonal" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="../Controles/UsuarioAudit.ascx" tagname="UsuarioAudit" tagprefix="uc2" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc3" %>
<%@ Register src="../Controles/CargaFoto.ascx" tagname="CargaFoto" tagprefix="uc5" %>
<%@ Register src="../Controles/Correo.ascx" tagname="Correo" tagprefix="uc4" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
            
            border-style: solid;
            border-width: 1px;
        }
    </style>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
        ValidationGroup="Guardar" DisplayMode="List" />
    <asp:TabContainer ID="TabContainer1" runat="server">
        <asp:TabPanel runat="server" HeaderText="TabPanel1" ID="TabPanel1">
            <HeaderTemplate>
                Datos Personales
            </HeaderTemplate>
            <ContentTemplate>
                <table class="style1">
                    <tr>
                        <td>
                            Apellidos
                        </td>
                        <td>
                             <ml:TextBox ID="txtApe" runat="server" MaxLength="255" 
                                OrigenDatos="perApellidos" Width="150px" Requerido="True" ValidationGroup="Guardar" ErrorMessage="Los Apellidos son Obligatorios"></ml:TextBox>
                        </td>
                        <td>
                            Nombres
                        </td>
                        <td>
                            <ml:TextBox ID="txtNombre" runat="server" MaxLength="255" 
                                OrigenDatos="perNombres" Width="150px" Requerido="True" ValidationGroup="Guardar" ErrorMessage="Los Nombres son Obligatorios"></ml:TextBox>
                        </td>
                        <td rowspan="14" valign="top">
                            <asp:ImageButton ID="imbFoto" runat="server" Height="130" Width="130" BorderWidth="1"/>
                        <br />
                            <asp:LinkButton ID="lnkElimFoto" runat="server">Eliminar Foto</asp:LinkButton>
                            <br />
                            <asp:Label ID="Label40" runat="server" Text="Observaciones"></asp:Label>
                            <br />
                            <ml:TextBox ID="txtObs" runat="server" MaxLength="300" TextMode="MultiLine" 
                                OrigenDatos="perObservaciones" Width="100px" Height="100px"></ml:TextBox>
                        </td>                        
                    </tr>
                    <tr>
                    <tr><td>
                    Fecha de Ingreso
                    </td>
                    <td>
                    <uc1:Fecha ID="fecIngreso" runat="server" OrigenDatos="perFechaIngreso" Requerido="true" ValidationGroup="Guardar" EmptyValueMessage="Por favor digite la fecha de ingreso" InvalidValueMessage="La fecha de ingreso es inválida"/>
                    </td>
                    </tr>
                    </tr>
                    <tr>
                        <td>
                            Documento
                        </td>
                        <td>
                            <ml:TextBox ID="txtDocumento" runat="server" MaxLength="50" 
                                OrigenDatos="perDocumento" Width="161px" Requerido="true" ValidationGroup="Guardar" ErrorMessage="Por favor digite el documento"></ml:TextBox>
                        </td>
                        <td>
                           Lugar Expedición
                        </td>
                        <td>
                            <ml:TextBox ID="txtLugarExp" runat="server" MaxLength="50" 
                                OrigenDatos="perLugarExpedicion" Width="120px"></ml:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Libreta Militar
                        </td>
                        <td>
                            <ml:TextBox ID="txtLibretaMil" runat="server" MaxLength="18" 
                                OrigenDatos="perNumLibretaMil" TipoTextBox="Entero"></ml:TextBox>
                        </td>
                        <td>
                            Distrito
                        </td>
                        <td>
                            <ml:TextBox ID="txtDistritoMil" runat="server" MaxLength="5" 
                                OrigenDatos="perDistritoMil" TipoTextBox="Entero" Width="44px" > </ml:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Pasado Judicial Num.
                        </td>
                        <td>
                            <ml:TextBox ID="txtNumPasJud" runat="server" MaxLength="15" 
                                OrigenDatos="perNumPasadoJudicial" ></ml:TextBox>
                        </td>
                        <td>
                            Fec. Pasado Judicial
                        </td>
                        <td>
                            <uc1:Fecha ID="fecPasJud" runat="server" OrigenDatos="perFechaPasadoJudicial" 
                                 />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <ml:CheckBox ID="chkTarProf" runat="server" OrigenDatos="perTarjetaProfesional" 
                                Text="Tarjeta Profesional?" />
                        </td>
                        <td>
                            Num Tarjeta Prof.
                        </td>
                        <td>
                            <ml:TextBox ID="txtNumTP" runat="server" MaxLength="50" 
                                OrigenDatos="perNumeroTP"></ml:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Grupo Sanguíneo
                        </td>
                        <td>
                            <ml:TextBox ID="txtGrupoSang" runat="server" MaxLength="3" 
                                OrigenDatos="perGrupoSanguineo" Width="38px"></ml:TextBox>
                        </td>
                        <td>
                            RH
                        </td>
                        <td>
                            <ml:TextBox ID="txtRH" runat="server" MaxLength="3" 
                                OrigenDatos="perRH" Width="38px"></ml:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Género
                        </td>
                        <td>
                            <uc3:DropDownListU ID="ddlGenero" runat="server" OrigenDatos="sexoId" />
                        </td>
                        <td>
                            Fecha Nacimiento
                        </td>
                        <td>
                            <uc1:Fecha ID="fecNac" runat="server" OrigenDatos="perFechaNac" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Dirección
                        </td>
                        <td>
                            <ml:TextBox ID="txtDireccion" runat="server" MaxLength="50" 
                                OrigenDatos="perDireccion" Width="169px"></ml:TextBox>
                        </td>
                        <td>
                            Barrio
                        </td>
                        <td colspan="2">
                            <ml:TextBox ID="txtBarrio" runat="server" MaxLength="255" 
                                OrigenDatos="perBarrio" Width="150px"></ml:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td>Localidad</td>
                        <td><uc2:DropDownListU ID="ddlLoc" runat="server" OrigenDatos="locId" /></td>
                    </tr>
                    <tr>
                        <td>
                            Teléfono
                        </td>
                        <td>
                            <ml:TextBox ID="txtTelefono" runat="server" MaxLength="20" 
                                OrigenDatos="perTelefono" Requerido="true" ValidationGroup="Guardar" ErrorMessage="Por favor digite el Teléfono"></ml:TextBox>
                        </td>
                        <td>
                            Teléfono1
                        </td>
                        <td>
                            <ml:TextBox ID="txtTelefono1" runat="server" MaxLength="20" 
                                OrigenDatos="perTelefono1"></ml:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Celular
                        </td>
                        <td>
                            <ml:TextBox ID="txtCelular" runat="server" MaxLength="20" 
                                OrigenDatos="perCelular" Requerido="true" ValidationGroup="Guardar"></ml:TextBox>
                        </td>
                        <td>
                            Correo electrónico
                        </td>
                        <td>
                            <ml:TextBox ID="txtCorreoE" runat="server" MaxLength="50" 
                                OrigenDatos="perCorreoElectronico"></ml:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Estado Civil<br />Num. Hijos
                        </td>
                        <td>
                            <uc3:DropDownListU ID="ddlEstCivil" runat="server" OrigenDatos="estCivilId" />
                            <br /><ml:TextBox ID="TextBox1" runat="server" MaxLength="2" 
                                OrigenDatos="perNumHijos" TipoTextBox="Entero" Width="30px"></ml:TextBox>
                        </td>
                        <td>
                            <div id="dvCony">Nombre Cónyuge</div>
                        </td>
                        <td>
                            <ml:TextBox ID="txtNomCony" runat="server" MaxLength="50" 
                                OrigenDatos="perNomConyugue"></ml:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Persona Contato
                        </td>
                        <td>
                            <ml:TextBox ID="TextBox2" runat="server" MaxLength="50" 
                                OrigenDatos="perContacto" Width="169px"></ml:TextBox>
                        </td>
                        <td>
                            Tel Persona Contato
                        </td>
                        <td colspan="2">
                            <ml:TextBox ID="TextBox3" runat="server" MaxLength="25" 
                                OrigenDatos="perTelContacto" Width="150px"></ml:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Parentesco
                        </td>
                        <td>
                            <ml:TextBox ID="txtParentesco" runat="server" MaxLength="50" 
                                OrigenDatos="perParentesco" Width="169px"></ml:TextBox>
                        </td>
                        <td>
                        </td>
                        <td colspan="2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            EPS
                        </td>
                        <td>
                            <uc3:DropDownListU ID="ddlEPS" runat="server" OrigenDatos="entIdEPS" />
                        </td>
                        <td>
                            FOP
                        </td>
                        <td>
                            <uc3:DropDownListU ID="ddlFOP" runat="server" OrigenDatos="entIdAFP" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            ARP
                        </td>
                        <td>
                            <uc3:DropDownListU ID="ddlARP" runat="server" OrigenDatos="entIdARP" />
                            </td>
                        <td>
                            </td>
                        <td>
                            
                            </td>
                    </tr>
                    <tr><td colspan="5"><uc2:UsuarioAudit ID="UsuarioAudit2" runat="server" /></td></tr>
                </table>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel ID="TabPanel2" runat="server" HeaderText="TabPanel2">
                    <HeaderTemplate>
                Detalles de Contrato
            </HeaderTemplate>
            <ContentTemplate >
            <table>
            <tr><td colspan="4">
                <ml:CheckBox ID="chkPazySalvo" OrigenDatos="perPazySalvo" Text="Paz y Salvo?" runat="server" /></td></tr>
            <tr><td>Estado</td><td>
                <uc3:DropDownListU ID="ddlEstado" runat="server" OrigenDatos="eEstId" 
                    Requerido="True" ValidationGroup="Guardar" ValidarCambios="True" />
                </td><td>Cargo</td><td>
                <uc3:DropDownListU ID="ddlCargo" runat="server" OrigenDatos="carId" 
                    Requerido="True" ValidationGroup="Guardar" />
                </td></tr>
            <tr><td>Tipo Contrato</td><td>
                <uc3:DropDownListU ID="ddlTC" runat="server" OrigenDatos="tipContId" />
                </td><td>Fecha Contrato</td><td>
                <uc1:Fecha ID="fecCont" runat="server" OrigenDatos="perFechaContrato" />
                </td></tr>
            <tr><td>Programa</td><td>
                <uc3:DropDownListU ID="ddlPrograma" runat="server" OrigenDatos="progId" Requerido="true" ValidationGroup="Guardar" ErrorMessage="Por favor seleccione el programa"/>
                </td><td>Área</td><td>
                <uc3:DropDownListU ID="ddlArea" runat="server" OrigenDatos="areaId" 
                    Requerido="True" ValidationGroup="Guardar" />
                </td></tr>
            <tr><td>Nivel complejidad</td><td>
                <uc3:DropDownListU ID="ddlNivCom" runat="server" OrigenDatos="nivCompId" />
                </td><td>Disponibilidad</td><td>
                <uc3:DropDownListU ID="ddlDisp" runat="server" OrigenDatos="dispId" />
                </td></tr>
            <tr><td>Nro Cuenta</td>
            <td><ml:TextBox ID="txtNroCta" runat="server" MaxLength="50" 
                                OrigenDatos="perNroCuenta" Requerido="False"></ml:TextBox>
                                </td>
            <td>Banco</td><td>
                <uc3:DropDownListU ID="ddlBanco" runat="server" OrigenDatos="banId" />
                </td></tr>
            <tr><td>Motivo Term. Contrato</td><td>
                <uc3:DropDownListU ID="ddlMotivoTer" runat="server" OrigenDatos="mteId" />
                </td><td>Fec Term. Contrato</td><td>
                <uc1:Fecha ID="fecTermCont" runat="server" OrigenDatos="perFechaTermContrato" />
                </td></tr>
                <tr>
                    <td colspan="2">
                        <asp:Label ID="Label38" runat="server" SkinID="EtiquetaSubT" 
                            Text="documentos Entregados a Atención Domiciliaria"></asp:Label>
                    </td>
                    <td colspan="2">
                        <asp:Label ID="Label39" runat="server" SkinID="EtiquetaSubT" 
                            Text="Documentos Entregados al Contratista"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table class="style1">
                            <tr>
                                <td>
                                    <asp:DataList ID="dtlDocsHS" runat="server" RepeatColumns="2" 
                                        ShowFooter="False" ShowHeader="False" DataKeyField="docId">                                        
                                        <ItemTemplate>
                                            <ml:CheckBox ID="CheckBox1" runat="server" Text='<%#bind("docDesc") %>' Checked='<%#bind("sel") %>' />
                                        </ItemTemplate>
                                    </asp:DataList>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td colspan="2" style="vertical-align:top;">
                        <table class="style1">
                            <tr>
                                <td>
                                    <asp:DataList ID="dtldocsCont" runat="server" RepeatColumns="2" 
                                        ShowFooter="False" ShowHeader="False" DataKeyField="docId">
                                        <ItemTemplate>
                                            <ml:CheckBox ID="CheckBox1" runat="server" Text='<%#bind("docDesc") %>' Checked='<%#bind("sel") %>' />
                                        </ItemTemplate>
                                    </asp:DataList>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel runat="server" HeaderText="TabPanel1" ID="TabPanel3">
            <HeaderTemplate>
                Info Profesional
            </HeaderTemplate>
            <ContentTemplate>
                 <table class="style1">
                    <tr>
                        <td>
                            <asp:Label runat="server" Text="Profesión:"></asp:Label><uc3:DropDownListU ID="ddlProf" runat="server" OrigenDatos="profId"/>
                            <asp:GridView ID="grvInfoProf" runat="server" AutoGenerateColumns="False" 
                                DataKeyNames="ipId,sel">
                                <Columns>
                                    <asp:TemplateField HeaderText="Sel">
                                        <ItemTemplate>
                                            <ml:CheckBox ID="CheckBox1" runat="server" Checked='<%#bind("sel") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ipDescripcion" HeaderText="Nivel Educativo" />
                                    <asp:TemplateField HeaderText="Profesión">
                                        <ItemTemplate>
                                           
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Año">
                                        <ItemTemplate>
                                            <ml:TextBox ID="txtAño" runat="server" MaxLength="4" TipoTextBox="Entero" Text='<%#bind("infAño")%>'
                                                Width="51px"></ml:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Institución">
                                        <ItemTemplate>
                                            <ml:TextBox ID="txtInst" runat="server" MaxLength="100" Width="214px" Text='<%#bind("infInstitucion")%>'></ml:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Nro Acta Grado">
                                        <ItemTemplate>
                                            <ml:TextBox ID="txtNroActa" runat="server" MaxLength="100" Width="214px" Text='<%#bind("infNroActa")%>'></ml:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:TabPanel>
                <asp:TabPanel runat="server" HeaderText="TabPanel1" ID="TabPanel4">
            <HeaderTemplate>
                Info Laboral
            </HeaderTemplate>
            <ContentTemplate>
                 <table class="style1">
                    <tr>
                        <td>
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <asp:LinkButton ID="lnkAgInfoLab" runat="server">Agregar Empresa</asp:LinkButton>
                                    <asp:GridView ID="grvInfoLab" runat="server" AutoGenerateColumns="False" EmptyDataText="No hay información Laboral registrada, haga click en 'Agregar Empresa' para registrar una nueva empresa de la historia laboral">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Empresa">
                                                <ItemTemplate>
                                                    <ml:TextBox ID="txtEmp" runat="server" MaxLength="25" 
                                                        Text='<%#bind("ilabEmpresa")%>' Width="240px"></ml:TextBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Teléfono">
                                                <ItemTemplate>
                                                    <ml:TextBox ID="txtTel" runat="server" MaxLength="25" 
                                                        Text='<%#bind("ilabTelefono")%>' Width="120px"></ml:TextBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Jefe Inmediato">
                                                <ItemTemplate>
                                                    <ml:TextBox ID="txtJefe" runat="server" MaxLength="30" 
                                                        Text='<%#bind("ilabJefeInmediato")%>' Width="100px"></ml:TextBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Año">
                                                <ItemTemplate>
                                                    <ml:TextBox ID="txtAño" runat="server" MaxLength="4" 
                                                        Text='<%#bind("ilabAño")%>' TipoTextBox="Entero" Width="45px"></ml:TextBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField Visible="False">
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="imbSubir" runat="server" CommandName="Subir" 
                                                        SkinID="imbSubir" />
                                                    <br />
                                                    <asp:ImageButton ID="imbBajar" runat="server" CommandName="Bajar" 
                                                        SkinID="imbBajar" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:CommandField DeleteText="Quitar" ShowDeleteButton="True" />
                                        </Columns>
                                    </asp:GridView>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:TabPanel>
    </asp:TabContainer>

    <uc5:CargaFoto ID="CargaFoto1" runat="server" />
    <hr />
     <asp:Panel ID="pnlTitulo" runat="server" Width="250px">
        <asp:Label ID="lbltitulo" runat="server" Text="Acciones" SkinId="EtiquetaSubT"></asp:Label>
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
                <uc4:Correo ID="Correo1" runat="server" TipoCorreo="Personal"/>
        <hr />
    </asp:Panel>
                                <script type="text/javascript">
                                    function valEstCivil() {
                                        var val = getEl("<%=ddlEstCivil.ControlDdl.ClientID%>").value;
                                        if (val == "6") { //Soltero
                                            getEl('<%=txtNomCony.ClientID%>').style.display = "none";
                                            getEl('<%=txtNomCony.ClientID%>').value = "";
                                            getEl('dvCony').style.display = "none";
                                        }
                                        else {
                                            getEl('<%=txtNomCony.ClientID%>').style.display = "block";
                                            getEl('dvCony').style.display = "block";
                                            getEl('dvCony').innerText = "Nombre Cónyuge";
                                            if (val == "4")
                                                getEl('dvCony').innerText = "Nombre Compañero";
                                        }
                                    }
                                    getEl("<%=ddlEstCivil.ControlDdl.ClientID%>").onchange = valEstCivil;
                                    valEstCivil();
                            </script>
</asp:Content>
