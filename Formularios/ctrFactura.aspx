<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ctrFactura.aspx.vb" Inherits="ML.ctrFactura" %>
<%@ Register src="../Controles/ConPacientesLightB.ascx" tagname="ConPacientesLightB" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
            border-width:thin;
            
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:ConPacientesLightB ID="ConPacientesLightM1" runat="server"  NomTabla="PacientesTotal"/>
    <asp:Panel runat="server" ID="pnlContenido" Visible="false">
        <asp:LinkButton ID="lnkNvaFac" runat="server">Nueva Factura para este paciente</asp:LinkButton>
&nbsp;<asp:UpdatePanel runat="server">
    <ContentTemplate>
    
    
    <table><tr><td class="celdaTitulo" colspan="4" style="text-align: center">
    
        <asp:Label ID="Label1" runat="server" SkinID="lblTituloPagina" Text="Factura"></asp:Label>
    
    </td></tr><tr><td>
            Número Factura
    </td><td>
                <ml:TextBox ID="txtNumero" runat="server" MaxLength="12" Requerido="True" 
                    TipoTextBox="Float" OrigenDatos="facNumero" ValidationGroup="Guardar"></ml:TextBox>
    </td><td>
                Fecha Factura
    </td><td>
                <uc2:Fecha ID="fchFactura" runat="server" Requerido="True" 
                    OrigenDatos="facFecha"  ValidationGroup="Guardar"/>
    </td></tr><tr><td>
            Fecha Radicación
    </td><td>
                <uc2:Fecha ID="fchRad" runat="server" Requerido="True" 
                    OrigenDatos="facFechaRadicacion"  ValidationGroup="Guardar"/>
    </td><td>
                Fecha Pago
    </td><td>
                <uc2:Fecha ID="fchPago" runat="server" Requerido="True" 
                    OrigenDatos="facFechaAproxPago"  ValidationGroup="Guardar"/>
    </td></tr><tr><td class="celdaTitulo" colspan="4" style="text-align: center">
            <asp:Label ID="Label2" runat="server" SkinID="lblTituloPagina" 
                Text="Periodo Facturado"></asp:Label>
    </td></tr><tr><td>
            Fecha Inicio
    </td><td>
                <uc2:Fecha ID="fchInicio" runat="server" Requerido="True" 
                    OrigenDatos="facInicioPer"  ValidationGroup="Guardar"/>
    </td><td>
                Fecha Fin
    </td><td>
                <uc2:Fecha ID="fchFin" runat="server" Requerido="True" 
                    OrigenDatos="facFinPer"  ValidationGroup="Guardar"/>
    </td></tr><tr><td class="celdaTitulo" colspan="4" style="text-align: center">
            <asp:Label ID="Label11" runat="server" SkinID="lblTituloPagina" Text="Detalle"></asp:Label>
    </td></tr><tr><td colspan="2">
            <asp:Label ID="Label9" runat="server" Text="Servicios:"></asp:Label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:CompareValidator ID="CompareValidator1" runat="server" 
                ControlToValidate="txtValBruto" ErrorMessage="Por favor digite los valores" 
                Operator="GreaterThan" ValidationGroup="Guardar" ValueToCompare="0"></asp:CompareValidator>
    </td><td colspan="2" style="text-align: center">
                <asp:Label ID="Label10" runat="server" Text="Autorizaciones:"></asp:Label>
    </td></tr><tr><td colspan="2">
            <table class="style1" border="1">
            <tr>    
                <th>Concepto</th>
                <th>Cantidad</th>
                <th>Valor</th>
            </tr>
                <tr>
                    <td>
                        Alquiler Equipos
                    </td>
                    <td>
                    </td>
                    <td>
                        <ml:TextBox ID="txtAlquiler" runat="server" OrigenDatos="facValAlquilerEquipos" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Atención Integral
                    </td>
                    <td>
                        <ml:TextBox ID="txtAtencionIntegralCant" runat="server"  Width="40px" MaxLength="3"
                            OrigenDatos="facValAtencionIntegralCant" TipoTextBox="Entero"></ml:TextBox></td>
                    <td>
                        <ml:TextBox ID="txtAtencionIntegral" runat="server" 
                            OrigenDatos="facValAtencionIntegral" TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Auxiliar de enfermería
                    </td>
                    <td>
    
                        <ml:TextBox ID="txtAuxEnfCant" runat="server"  Width="40px" MaxLength="3"
                            OrigenDatos="facValAuxiliarEnfCant" TipoTextBox="Entero"></ml:TextBox></td>
                    <td>
                        <ml:TextBox ID="txtAuxEnf" runat="server" OrigenDatos="facValAuxiliarEnf" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
    
                Cuota Administración Sum. Med.
    
                    </td>
                    <td>
    
                        </td>
                    <td>
                        <ml:TextBox ID="txtCuotaAdm" runat="server" OrigenDatos="facValCuotaAdmSumMed" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
    
                Enfermera Profesional
    
                    </td>
                    <td>
    
                        <ml:TextBox ID="txtEnfProfCant" runat="server"  Width="40px" MaxLength="3"
                            OrigenDatos="facValEnfProfesionalCant" TipoTextBox="Entero"></ml:TextBox></td>
                    <td>
                        <ml:TextBox ID="txtEnfProf" runat="server" OrigenDatos="facValEnfProfesional" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
    
                Evento
    
                    </td>
                    <td>
    
                        &nbsp;</td>
                    <td>
                        <ml:TextBox ID="txtEvento" runat="server" OrigenDatos="facValEvento" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
    
                Laboratorios
    
                    </td>
                    <td>
                    </td>
                    <td>
                        <ml:TextBox ID="txtLabs" runat="server" OrigenDatos="facValLaboratorio" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
    
                Medicamentos
    
                    </td>
                    <td>
    
                        &nbsp;</td>
                    <td>
                        <ml:TextBox ID="txtMedicamentos" runat="server" 
                            OrigenDatos="facValMedicamentos" TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
    
                Oxigenoterapia
    
                    </td>
                    <td>
    
                        &nbsp;</td>
                    <td>
                        <ml:TextBox ID="txtOxigenoterapia" runat="server" 
                            OrigenDatos="facValOxigenoterapia" TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
    
                Oximetría
    
                    </td>
                    <td>
    
                        <ml:TextBox ID="txtOximetriaCant" runat="server"  Width="40px" MaxLength="3"
                            OrigenDatos="facValOximetriaCant" TipoTextBox="Entero"></ml:TextBox></td>
                    <td>
                        <ml:TextBox ID="txtOximetria" runat="server" OrigenDatos="facValOximetria" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
    
                Suministros
    
                    </td>
                    <td>
    
                        &nbsp;</td>
                    <td>
                        <ml:TextBox ID="txtSuministros" runat="server" OrigenDatos="facValSuministros" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
    
                Terapia Respiratoria
    
                    </td>
                    <td>
    
                        <ml:TextBox ID="txtTerRespCant" runat="server"  Width="40px" MaxLength="3"
                            OrigenDatos="facValTerRespiratoriaCant" TipoTextBox="Entero"></ml:TextBox></td>
                    <td>
                        <ml:TextBox ID="txtTerResp" runat="server" OrigenDatos="facValTerRespiratoria" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>
    
                Terapia Física
    
                    </td>
                    <td>
    
                        <ml:TextBox ID="txtTerFisCant" runat="server"  Width="40px" MaxLength="3"
                            OrigenDatos="facValTerFisicaCant" TipoTextBox="Entero"></ml:TextBox></td>
                    <td>
                        <ml:TextBox ID="txtTerFis" runat="server" OrigenDatos="facValTerFisica" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                                <tr>
                    <td>
                        Terapia Ocupacional
                    </td>
                    <td>
                        <ml:TextBox ID="txtTerOcupCant" runat="server"  Width="40px" MaxLength="3"
                            OrigenDatos="facValTerOcupCant" TipoTextBox="Entero"></ml:TextBox></td>
                    <td>
                        <ml:TextBox ID="txtTerOcup" runat="server" OrigenDatos="facValTerOcup" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>
                        Terapia Lenguaje
                    </td>
                    <td>
                        <ml:TextBox ID="txtTerLenCant" runat="server"  Width="40px" MaxLength="3"
                            OrigenDatos="facValTerLenguajeCant" TipoTextBox="Entero"></ml:TextBox></td>
                    <td>
                        <ml:TextBox ID="txtTerLen" runat="server" OrigenDatos="facValTerLenguaje" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Valoración Nutricional
                    </td>
                    <td>
                        <ml:TextBox ID="txtValNutCant" runat="server"  Width="40px" MaxLength="3"
                            OrigenDatos="facValValNutricionalCant" TipoTextBox="Entero"></ml:TextBox></td>
                    <td>
                        <ml:TextBox ID="txtValNut" runat="server" OrigenDatos="facValValNutricional" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Visita Médica
                    </td>
                    <td>
                        <ml:TextBox ID="txtVisitaMedCant" runat="server"  Width="40px" MaxLength="3"
                            OrigenDatos="facValVisitaMedCant" TipoTextBox="Entero"></ml:TextBox></td>
                    <td>
                        <ml:TextBox ID="txtVisitaMed" runat="server" OrigenDatos="facValVisitaMed" 
                            TipoTextBox="Float"></ml:TextBox>
                    </td>
                </tr>
            </table>
            </td><td colspan="2" style="text-align: center" valign="top">
                <asp:GridView ID="grvAut" runat="server" AutoGenerateColumns="false" EmptyDataText="sdsd">
                    <Columns>
                        <asp:TemplateField HeaderText="Número">
                            <ItemTemplate>
                                <ml:TextBox ID="TextBox1" runat="server" text='<%#bind("value")%> ' MaxLength="50"></ml:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </td></tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                Valor Bruto
            </td>
            <td>
                <ml:TextBox ID="txtValBruto" runat="server" Enabled="False" TipoTextBox="Float"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>
            </td>
            <td>
                Copago
            </td>
            <td>
                <ml:TextBox ID="txtCopago" runat="server" Requerido="False" TipoTextBox="Float" OrigenDatos="facValCopago"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                Subtotal
            </td>
            <td>
                <ml:TextBox ID="txtSubtotal" runat="server" Enabled="False" TipoTextBox="Float"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                Retefuente
            </td>
            <td>
                <ml:TextBox ID="txtRetefuente" runat="server" TipoTextBox="Float" OrigenDatos="facValRteFte"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                Reteica
            </td>
            <td>
                <ml:TextBox ID="txtReteica" runat="server" TipoTextBox="Float" OrigenDatos="facValRteIca"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                Total
            </td>
            <td>
                <ml:TextBox ID="txtTotal" runat="server" TipoTextBox="Float" Enabled="False"></ml:TextBox>
            </td>
        </tr>
    </table>
    </ContentTemplate>
    </asp:UpdatePanel>
        <script type="text/javascript">
            function valor(val) {
                val = val.replace(/,/, ".")
                var ret = 0
                ret = (val.length==0 || isNaN(val))?0:parseFloat(val);
                return ret;
            }
            function suma() {
                var suma = 0;
                suma += valor(getEl("<%=txtAlquiler.clientID%>").value)
                suma += valor(getEl("<%=txtAtencionIntegral.clientID%>").value)
                suma += valor(getEl("<%=txtAuxEnf.clientID%>").value)
                suma += valor(getEl("<%=txtCuotaAdm.clientID%>").value)
                suma += valor(getEl("<%=txtEnfProf.clientID%>").value)
                suma += valor(getEl("<%=txtEvento.clientID%>").value)
                suma += valor(getEl("<%=txtLabs.clientID%>").value)
                suma += valor(getEl("<%=txtMedicamentos.clientID%>").value)
                suma += valor(getEl("<%=txtOxigenoterapia.clientID%>").value)
                suma += valor(getEl("<%=txtOximetria.clientID%>").value)
                suma += valor(getEl("<%=txtSuministros.clientID%>").value)
                suma += valor(getEl("<%=txtTerFis.clientID%>").value)
                suma += valor(getEl("<%=txtTerLen.clientID%>").value)
                suma += valor(getEl("<%=txtTerOcup.clientID%>").value)
                suma += valor(getEl("<%=txtTerResp.clientID%>").value)
                suma += valor(getEl("<%=txtValNut.clientID%>").value)
                suma += valor(getEl("<%=txtVisitaMed.clientID%>").value)
                getEl("<%=txtValBruto.clientID%>").value = suma;
                suma -= valor(getEl("<%=txtCopago.clientID%>").value)
                getEl("<%=txtSubtotal.clientID%>").value = suma;
                suma -= valor(getEl("<%=txtRetefuente.clientID%>").value)
                suma -= valor(getEl("<%=txtReteica.clientID%>").value)
                getEl("<%=txtTotal.clientID%>").value = suma;

                getEl("<%=txtValBruto.clientID%>").value = getEl("<%=txtValBruto.clientID%>").value.replace(/\./, ',');
                getEl("<%=txtSubtotal.clientID%>").value = getEl("<%=txtSubtotal.clientID%>").value.replace(/\./, ',');
                getEl("<%=txtTotal.clientID%>").value = getEl("<%=txtTotal.clientID%>").value.replace(/\./, ',');
            }
            suma();
    </script>
    </asp:Panel>
</asp:Content>
