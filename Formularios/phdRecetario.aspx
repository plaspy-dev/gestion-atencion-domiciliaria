<%@ Page Title="Recetario Medicamentos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdRecetario.aspx.vb" Inherits="ML.phdRecetario" %>
<%@ Register src="../Controles/ConPacientesLightB.ascx" tagname="ConPacientesLightB" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/Lista.ascx" tagname="Lista" tagprefix="uc3" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">

    <uc1:ConPacientesLightB ID="ConPacientesLightB1" runat="server" />
    <asp:Panel ID="pnlEv" runat="server" Visible="true">
        <asp:Panel ID="pnlRegEv" runat="server">
            <table class="style1">
                <tr>
                        <td class="celdaTitulo" colspan="2">
                            <asp:Label ID="lblTituloReg" runat="server" SkinID="lblsubTitulo" 
                                Text="Nuevo registro de Evolucion HC"></asp:Label>
                        </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="Fecha"></asp:Label>
                    </td>
                    <td>
                        <uc2:Fecha ID="fchEv" runat="server" Requerido="true" ValidationGroup="Guardar" OrigenDatos="hcFecha"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label10" runat="server" Text="Médico"></asp:Label>
                    </td>
                    <td>
                        <uc4:DropDownListU ID="ddlMedico" runat="server" Requerido="true" ValidationGroup="Guardar"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label3" runat="server" Text="Medicamento"></asp:Label>
                    </td>
                    <td>
                        <uc4:DropDownListU ID="ddlMedicamento" runat="server" Requerido="true" 
                            ValidationGroup="Guardar" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table class="style1">
                            <tr>
                                <td>
                                    <asp:Label ID="Label11" runat="server" Text="Dosis"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label12" runat="server" Text="Frecuencia"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label13" runat="server" Text="Tiempo"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label14" runat="server" Text="Duracíón"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label15" runat="server" Text="Cantidad"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <ml:TextBox ID="txtDosis" runat="server" TipoTextBox="Entero" Width="25px"></ml:TextBox>
                                </td>
                                <td>
                                    <ml:TextBox ID="txtFrecuencia" runat="server" TipoTextBox="Entero" Width="25px"></ml:TextBox>
                                </td>
                                <td>
                                    <uc4:DropDownListU ID="ddlTiempo" runat="server" />
                                </td>
                                <td>
                                    <ml:TextBox ID="txtDuracion" runat="server" TipoTextBox="Entero" Width="25px"></ml:TextBox>
                                </td>
                                <td>
                                    <ml:TextBox ID="txtCantidad" runat="server" TipoTextBox="Entero" Width="25px"></ml:TextBox>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label8" runat="server" Text="Posología"></asp:Label>
                    </td>
                    <td>
                        <ml:TextBox ID="txtPosologia" runat="server" Height="38px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="hcOtrosDiag"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label9" runat="server" Text="Observaciones"></asp:Label>
                    </td>
                    <td>
                        <ml:TextBox ID="txtObs" runat="server" Height="73px" MaxLength="1000" 
                            TextMode="MultiLine" Width="315px" OrigenDatos="hcNovedades"></ml:TextBox>
                    </td>
                </tr>
            </table>
            <script type="text/javascript">
                var txtDosis=document.getElementById('<%=Me.txtDosis.clientId%>');
                var txtFrecuencia=document.getElementById('<%=Me.txtFrecuencia.clientId%>');
                var txtDuracion=document.getElementById('<%=Me.txtDuracion.clientId%>');
                var ddlTiempo=document.getElementById('<%=Me.ddlTiempo.controlDDl.clientId%>');
                var txtCantidad=document.getElementById('<%=Me.txtCantidad.clientId%>');
                var txtPosologia=document.getElementById('<%=Me.txtPosologia.clientId%>');
                var txtObs=document.getElementById('<%=Me.txtObs.clientId%>');
                var med = ""
                if (document.getElementById('<%=Me.ddlMedicamento.controlDDl.clientId%>').options.size > 0)
                    med = document.getElementById('<%=Me.ddlMedicamento.controlDDl.clientId%>').options[document.getElementById('<%=Me.ddlMedicamento.controlDDl.clientId%>').selectedIndex].text;
                function llenarPosologiaCantidad(noLlenarCantidad){        
                    var posologia=""
                    var dosis=txtDosis.value
                    var frecuencia=txtFrecuencia.value
                    var duracion=txtDuracion.value
                    var tiempo = ddlTiempo.options[ddlTiempo.selectedIndex].value
                    var frecTiempo = ddlTiempo.options[ddlTiempo.selectedIndex].text
                    var cantidad=0
                    if(!isNaN(dosis) && !isNaN(frecuencia) && !isNaN(duracion))
                        if(parseInt(dosis)>0 && parseInt(frecuencia)>0 && parseInt(duracion)>0)
                            if(dosis!="" && frecuencia!="" && duracion!=""){
                                posologia= "Tomar " + dosis + " " + med + "(s) cada " + frecuencia + " " + frecTiempo + " durante " + duracion + " dia(s)"
                                cantidad=CalcularTotales(dosis,frecuencia,tiempo,duracion)                    
                            }
                            txtPosologia.value=posologia
                            if(!noLlenarCantidad)
                                txtCantidad.value=cantidad
                }
                
                function CalcularTotales(dosis,frecuencia,tiempo,duracion){
                    var cantidad=0
                    var dosisHora
                    var dosisDiaria
                    if(tiempo == 1){ //Horas
                        dosisDiaria = (24 * dosis) / frecuencia
                        cantidad = parseInt(dosisDiaria * duracion) 
                    }
                    else if(tiempo == 2){ //Minutos
                            dosisHora = (60 * dosis) / frecuencia
                            dosisDiaria = 24 * dosisHora
                            cantidad = parseInt(dosisDiaria * duracion)
                        }        
                    return cantidad
                }
                
                function valDosis(){
                    if(txtFrecuencia.disabled)
                        txtCantidad.value=txtDosis.value
                    else
                        llenarPosologiaCantidad()           
                }
                
                function valFrecuencia(){
                    var tiempo = ddlTiempo.options[ddlTiempo.selectedIndex].value
                    var frecuencia=txtFrecuencia.value
                    if(tiempo==5){
                        if(frecuencia>60){
                            txtFrecuencia.value="0"
                            alert('El Intervalo de Tiempo debe estar entre 0 y 60 Minutos');
                        }
                    }
                    else{ 
                        if(tiempo==4)
                            if(frecuencia>24){
                                txtFrecuencia.value="0";
                                alert('El Intervalo de Tiempo debe estar entre 0 y 24 Horas');
                         }
                    }
                    llenarPosologiaCantidad()
                }
            </script>
        </asp:Panel>
    <hr />
    <asp:Label ID="Label1" runat="server" Text="Evoluciones registradas en esta fecha:"></asp:Label>
        <br />
        <ml:GridView ID="grvEv" runat="server" AutoGenerateColumns="False" 
            TotalPaginas="0" DataKeyNames="hcId" EmptyDataText="No se ha registrado Evolucion HC para este paciente en esta fecha">
            <Columns>
                <asp:CommandField HeaderText="Sel" SelectText="Sel" ShowSelectButton="True" />
                <asp:BoundField DataField="hcFecha" HeaderText="Fecha" />
                <asp:BoundField DataField="hcPlanEnfermeria" HeaderText="Plan Enfermeria" />
                <asp:BoundField DataField="hcOrdenesMedicas" HeaderText="Ordenes Méd." />
                <asp:BoundField DataField="cieCodDx" HeaderText="CIE10" />
                <asp:BoundField DataField="cieCodDx_1" HeaderText="CIE10_1" />
                <asp:BoundField DataField="cieCodDx_2" HeaderText="CIE10_2" />
                <asp:BoundField DataField="hcOtrosDiag" HeaderText="Otros diag." />
                <asp:BoundField DataField="hcNovedades" HeaderText="Novedades" />
                <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
            </Columns>
        </ml:GridView>
    </asp:Panel>
    <br />

</asp:Content>
