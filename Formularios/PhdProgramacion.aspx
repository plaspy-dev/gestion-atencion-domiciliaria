<%@ Page Title="Programación de Servicios Médicos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdProgramacion.aspx.vb" Inherits="ML.PhdProgramacion"  EnableEventValidation="false"%>
<%@ Register src="../Controles/ConPacientes.ascx" tagname="ConPacientes" tagprefix="uc1" %>
<%@ Register src="../Controles/ManProgramacion.ascx" tagname="ManProgramacion" tagprefix="uc6" %>
<%@ Register src="../Controles/Novedad.ascx" tagname="Novedad" tagprefix="uc2" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .styleTb
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:ConPacientes ID="ConPacientes1" runat="server" VerInactivos="true"/>
    <asp:Panel runat="server" id="pnlContent" Visible="false" >
        <table class="styleTb">
            <tr>
                <td style="text-align: left" width="100%">
                                    <asp:Label ID="Label6" runat="server" Text="Historial de Programaciones" 
                        SkinID="EtiquetaSubT"></asp:Label>
                </td>
                <td style="text-align: left" >
                    <uc3:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="actId" Titulos="Actividad" Referencias="ActividadEnf" Expandido="true" />
                </td>
            </tr>
            <tr>
                <td style="text-align: center" colspan="2">
                    <div class="styleTb" style=" text-align:left;">
                        <asp:LinkButton ID="lnkNuevo" runat="server" CausesValidation="false">Programar nuevo</asp:LinkButton>
                    </div>
                <br />
                            <ml:GridView ID="grvProg" runat="server" AutoGenerateColumns="False" 
                                 AllowPaging="True" TotalPaginas="0" EmptyDataText="El paciente no tiene Programaciones registradas"
                                  DataKeyNames="prgId">
                                <Columns>
                                    <asp:BoundField DataField="prgId" HeaderText="Id" 
                                        SortExpression="prgId" />
                                    <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha(d/m/a)" 
                                        SortExpression="prgFechaProg"   DataFormatString="{0:dd/MM/yyyy}" />
                                    <asp:BoundField DataField="perNombre" HeaderText="Profesional" 
                                        SortExpression="perNombre" />
                                    <asp:BoundField DataField="prgNumSesion" HeaderText="Num Sesiones" 
                                        SortExpression="prgNumSesion" />
                                    <asp:TemplateField HeaderText="Autorización" >
                                    <ItemTemplate>
                                        <%# Eval("autNumero")+iif(Eval("autNumero") is nothing,"","["+Eval("autNumSesiones").toString+"]") %>
                                    </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" 
                                        SortExpression="actDescripcion"/>
                                    <asp:CheckBoxField DataField="prgActivo" HeaderText="Activo?" />
                                    <asp:TemplateField HeaderText="Novedad">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkNovedad" runat="server" CommandName='Novedad' Text='Novedad' CommandArgument='<%#ctype(Container,GridViewRow).rowIndex%>' ></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>                        
                                    <asp:TemplateField HeaderText="Editar">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" CommandName='<%#iif(verBtnEdit(eval("prgFechaProg"),eval("prgActivo")),"Editar","Ver")%>' Text='<%#iif(verBtnEdit(eval("prgFechaProg"),eval("prgActivo")),"Editar","Ver")%>' CommandArgument='<%#bind("prgId")%>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>                        
                                    <asp:TemplateField HeaderText="Elim">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkElim" runat="server" Visible='<%#verBtnElim(eval("prgFechaProg"))%>' OnClientClick="if(!confirm('Confirma la eliminación del registro?'))return false;" CommandName="Elim" CommandArgument='<%#bind("prgId")%>'>Elim</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>   
                                    <asp:TemplateField HeaderText="Sel">
                                    <ItemTemplate>
                                        <asp:CheckBox runat="server" ID="chk" />
                                    </ItemTemplate>
                                    </asp:TemplateField>                     
                                </Columns>
                            </ml:GridView>
                        <br />
                        <div style="width:100%;text-align:left;">
                        <asp:LinkButton ID="lnkNovedad" runat="server" CausesValidation="false">Generar Novedades masivas</asp:LinkButton><br />
                        <br />
                    <asp:LinkButton ID="lnkelimMasivo" runat="server" CausesValidation="false" OnClientClick="return confirm('Confirma que desea realizar la eliminación')">Eliminar masivamente</asp:LinkButton>
                        </div>
                        <uc6:ManProgramacion ID="ManProgramacion1" runat="server"  Visible="false"/>
                        <uc2:Novedad ID="Novedad1" runat="server" TipoServicio="ServiciosMedicos" Visible="false"/>
                        <asp:HiddenField runat="server" ID="hddVerPrg" Value="0" />                        
                        <asp:HiddenField runat="server" ID="hddVerNov" Value="0" />                        
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
            </tr>
            </table>
        </asp:Panel>
        <script type="text/javascript">
            function valVerPrg(ver) {
                document.getElementById('<%=hddVerPrg.clientId %>').value = ver;
            }
            function valVerNov(ver) {
                document.getElementById('<%=hddVerNov.clientId %>').value = ver;
            }   
        </script>        
</asp:Content>
