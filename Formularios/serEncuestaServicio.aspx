<%@ Page Title="Encuesta de satisfacción del usuario" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serEncuestaServicio.aspx.vb" Inherits="ML.serEncuestaServicio" %>
<%@ Register src="../Controles/ConPacientes.ascx" tagname="ConPacientes" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc3" %>
<%@ Register src="../Controles/Hora.ascx" tagname="Hora" tagprefix="uc4" %>
<%@ Register src="../Controles/UsuarioAudit.ascx" tagname="UsuarioAudit" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    
    <uc1:conpacientes ID="ConPacientes1" runat="server"  VerInactivos="true" OrigenDatos="pacId"/>
    <br />
    <asp:Panel runat="server" ID="pnlQ" Visible="false">
        <div style="border-width: medium; border-color: Blue" />
        <table>
            <tr>
                <td class="celdaTitulo" colspan="2">
                    <asp:Label ID="Label15" runat="server" SkinID="lblsubTitulo" 
                        Text="Paso 1: Datos Generales de la Encuesta"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    Fecha
                </td>
                <td>
                    <uc2:Fecha ID="fecForm" runat="server" OrigenDatos="qrFecha" Requerido="True" ValidationGroup="Guardar" />
                </td>
            </tr>
            <tr>
                <td>
                    Hora de Llamada
                </td>
                <td>
                    <uc4:Hora ID="Hora1" runat="server" Requerido="True" ValidationGroup="Guardar" />
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:LinkButton ID="lnkPendiente" runat="server" OnClientClick="pend();return false;">No fúe posible realizar la encuesta, encuesta pendiente</asp:LinkButton>
                    <ml:Panel runat="server" ID="pnlObsPend" Titulo="Observaciones" Width="300px" Height="250px">
                        <asp:TextBox runat="server" ID="txtPend" TextMode="MultiLine" Width="250px" Height="80px" ></asp:TextBox>
                        <br />
                        <br />
                        <asp:LinkButton runat="server" ID="lnkAceptarPend" CausesValidation="false">Marcar Encuesta como Pendiente</asp:LinkButton>
                        <br />
                        <br />
                        <asp:LinkButton runat="server" ID="lnkCancelar" CausesValidation="false" Visible="false">Cancelar Encuesta</asp:LinkButton>
                    </ml:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    </td>
                <td>
                    &nbsp;</td>
            </tr>
            </table>
            <table runat="server" id="tblPagina1">
            <tr>
                <th colspan="2">
                    Servicios que usted recibe por parte de Gestión de atención domiciliaria y COMPAÑÍA S.A.
                </th>
            </tr>
            <tr>
                <th colspan="2">
                    <ml:GridView ID="grvServicios" runat="server" AutoGenerateColumns="false" DataKeyNames="actId">
                        <Columns>
                            <asp:BoundField HeaderText="Actividad" DataField="actDescripcion" />
                            <asp:TemplateField HeaderText="Sel">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="chkSel" Checked='<%#Eval("existe") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </ml:GridView>
                </th>
            </tr>
            <tr>
                <th colspan="2">
                    &nbsp;</th>
            </tr>
            <tr>
                <th colspan="2">
                    <h3>1. Califique en general el servicio de Gestión de atención domiciliaria y COMPAÑÍA S.A.</h3>
                </th>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:RadioButtonList runat="server" ID="rblCalificacion" RepeatDirection="Horizontal">
                        <asp:ListItem Text="Bueno" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Malo" Value="0"></asp:ListItem>
                    </asp:RadioButtonList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="rblCalificacion" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:LinkButton ID="lnkCont" runat="server">Continuar</asp:LinkButton>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlSer">
    
        <asp:DataList runat="server" ID="dtlSer" DataKeyField="actId">
        <HeaderStyle CssClass="celdaTitulo" />
        <HeaderTemplate><asp:Label ID="Label15" runat="server" SkinID="lblsubTitulo" 
                        Text="Paso 2: Encuesta por Servicio"></asp:Label></HeaderTemplate>
            <ItemTemplate>
                <hr />
                <h3>
                    Por favor Califique el servicio <%#Eval("actDescripcion")%>:</h3>
                <asp:DataList runat="server" ID="dtlSer" DataKeyField="espId">
                    <ItemTemplate>
                        <table>
                            <tr>
                                <td style="width: 400px;">
                                    <%#Eval("espDescripcion")%>:
                                </td>
                                <td style="margin-left: 30px;">
                                    <asp:RadioButtonList runat="server" ID="rblCalificacionSer" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="Bueno" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Malo" Value="0"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </asp:DataList>
                Nombre(s) de los Funcionario(s)
                <asp:TextBox runat="server" ID="txtNoms" Text="" MaxLength="100"></asp:TextBox>
            </ItemTemplate>
        </asp:DataList>
        <br />
        <br />
                    <asp:LinkButton ID="lnkAtras" runat="server">Anterior</asp:LinkButton>
    </asp:Panel>
    <br />
    <asp:Panel runat="server" ID="pnlCom">
    <table>
        <tr>
            <td class="celdaTitulo" colspan="2">
                <asp:Label ID="Label1" runat="server" SkinID="lblsubTitulo" Text="Comentarios y recomendaciones"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td>
                <ml:TextBox ID="txtCom" runat="server" Height="56px" TextMode="MultiLine" Width="314px"></ml:TextBox>
            </td>
        </tr>
    </table>
    </asp:Panel>
    <uc5:UsuarioAudit ID="UsuarioAudit1" runat="server" />
    <script type="text/javascript">
        function pend() { 
            <% =pnlObsPend.fnMostrar()%>;
        }
    </script>
    
</asp:Content>
