<%@ Page Title="Programación de Equipos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="equProgramacion.aspx.vb" Inherits="ML.equProgramacion" %>
<%@ Register src="../Controles/ConPacientes.ascx" tagname="ConPacientes" tagprefix="uc1" %>
<%@ Register src="../Controles/ManProgramacion.ascx" tagname="ManProgramacion" tagprefix="uc6" %>
<%@ Register src="../Controles/Novedad.ascx" tagname="Novedad" tagprefix="uc2" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc3" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc4" %>
<%@ Register src="../Controles/PrgRecurrente.ascx" tagname="PrgRecurrente" tagprefix="uc5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table><tr><td><asp:Label runat="server" ID="lblTit" SkinID="lblFormatoFecha" Text="Para iniciar por favor seleccione el equipo"></asp:Label></td>
<td><uc3:DropDownListU ID="ddlEquipo" runat="server" NomTabla="Equipos" AutoPostBack="true" /></td></tr></table>
    
    <br />
    <asp:Panel runat="server" id="pnlContent" Visible="false" >
        <table class="style1">
            <tr>
                <td style="text-align: left">
                    <asp:LinkButton ID="lnkNuevo" runat="server" CausesValidation="false">Programar nuevo</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td style="text-align: center">
                    <asp:Label ID="Label6" runat="server" Text="Historial de Programaciones" 
                        SkinID="EtiquetaSubT"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                            <ml:GridView ID="grvProg" runat="server" AutoGenerateColumns="False" 
                                 AllowPaging="True" TotalPaginas="0" EmptyDataText="El equipo no tiene Programaciones registradas"
                                  DataKeyNames="prgId">
                                <Columns>
                                    <asp:BoundField DataField="prgId" HeaderText="Id" 
                                        SortExpression="prgId" />
                                    <asp:BoundField DataField="prgFecha" HeaderText="Fecha(d/m/a)" 
                                        SortExpression="prgFecha" DataFormatString="{0:dd/MM/yyyy}" />
                                        <asp:BoundField DataField="prgFamiliarResp" HeaderText="Familiar Responsable" 
                                        SortExpression="prgFamiliarResp" />                                        
                                    <asp:TemplateField HeaderText="Paciente">
                                        <ItemTemplate>
                                            <asp:label ID="lbl" runat="server" Text='<%#Eval("pacPNombre")+" "+Eval("pacSNombre")+" "+Eval("pacPApellido")+" "+Eval("pacSApellido")%>'></asp:label>
                                        </ItemTemplate>
                                    </asp:TemplateField>                        
                                    <asp:BoundField DataField="perNombre" HeaderText="Funcionario Responsable" 
                                        SortExpression="perNombre" />
                                    <asp:TemplateField HeaderText="Editar">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" CommandName='<%#iif(verBtnElim(eval("prgFecha")),"Editar","Ver")%>' Text='<%#iif(verBtnElim(eval("prgFecha")),"Editar","Ver")%>' CommandArgument='<%#ctype(Container,GridViewRow).rowIndex%>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>                        
                                    <asp:TemplateField HeaderText="Elim">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkElim" runat="server" Visible='<%#verBtnElim(eval("prgFecha"))%>' OnClientClick="if(!confirm('Confirma la eliminación del registro?'))return false;" CommandName="Elim" CommandArgument='<%#bind("prgId")%>'>Elim</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>                        
                                </Columns>
                            </ml:GridView>
                    </td>
                </tr>
                <tr>
                    <td>
                    
                    </td>
            </tr>
            </table>
            
<asp:Panel ID="pnlNuevo" runat="server" Visible="false">
    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="400px">
    <asp:Panel ID="pnlTitulo" runat="server" Style=" height:10%;cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;">
                <div>
                    <p>Programar Equipos</p>
                </div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" >
    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
    <asp:Panel runat="server" id="pnlPrincipal">
    <table class="style1">
    <tr>
            <td colspan="2">
                 <asp:RadioButtonList ID="rblTipoPrg" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Text="Fecha Única" value="1" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Recurrente" value="2"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
            <tr id="trFecha">
                <td>
                    <asp:Label ID="Label12" runat="server" Text="Fecha"></asp:Label>
                </td>
                <td>
                    <uc4:Fecha ID="fchProg" runat="server" />
                </td>
        </tr>
        <tr id="trRec">
        <td colspan="2">
        <uc5:PrgRecurrente ID="PrgRecurrente1" runat="server" />
        </td>
        </tr>
            <tr>
            <td>
                <asp:Label ID="Label14" runat="server" Text="Paciente"></asp:Label>
            </td>
            <td>
                <uc3:DropDownListU ID="ddlPaciente" runat="server"  NomTabla="PacientePorId" Requerido="true" ValidationGroup="GuardarAut"/>
            </td>
        </tr>
    <tr>
            <td>
                <asp:Label ID="Label13" runat="server" Text="Funcionario Asignado"></asp:Label>
            </td>
            <td style="text-align: left">
                <uc3:DropDownListU ID="ddlPer" runat="server" NomTabla="PersonalHS"/>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label15" runat="server" Text="Familiar Responsable "></asp:Label>
            </td>
            <td style="text-align: left">
                <asp:TextBox ID="txtFam" runat="server" MaxLength="50" Width="255px"></asp:TextBox>
            </td>
        </tr>

  </table>
  </asp:Panel>
                
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
    PopupDragHandleControlID="pnlTitulo">
</asp:ModalPopupExtender>
 <script type="text/javascript">
     tablas = document.getElementsByName('<%=rblTipoPrg.UniqueID %>').length;
     for (a = 0; a < tablas; a++) {
         document.getElementsByName('<%=rblTipoPrg.UniqueID %>')[a].onclick = valTipo;
     }

     document.getElementById('trRec').style.display = document.getElementsByName('<%=rblTipoPrg.UniqueID %>')[1].checked ? "block" : "none";
     document.getElementById('trFecha').style.display = document.getElementsByName('<%=rblTipoPrg.UniqueID %>')[0].checked ? "block" : "none";
     function valTipo(aa) {
         document.getElementById('trRec').style.display = this.value == "2" ? "block" : "none";
         document.getElementById('trFecha').style.display = this.value == "1" ? "block" : "none";
     }
</script>
    </asp:Panel>
        </asp:Panel>
        
        
</asp:Content>
