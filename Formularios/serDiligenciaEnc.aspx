<%@ Page Title="Diligenciar Encuesta" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serDiligenciaEnc.aspx.vb" Inherits="ML.serDiligenciaEnc" %>
<%@ Register src="../Controles/ConPacientesLight.ascx" tagname="ConPacientesLight" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:Label ID="lblini" runat="server" Text="Para inciar Seleccione la encuesta a diligenciar y el paciente a quien se llama" SkinID="lblFormatoFecha"></asp:Label>
    <table><tr><td>
    <asp:Label ID="Label10" runat="server" Text="Seleccione Encuesta:"></asp:Label>
    </td>
    <td><uc3:DropDownListU ID="ddlEncuesta" runat="server" AutoPostBack="True" /></td></tr>
        <tr><td colspan="2">
            <asp:RadioButtonList ID="rblTipoCliente" runat="server" AutoPostBack="True">
                <asp:ListItem Selected="True" Value="1">Cliente Externo</asp:ListItem>
                <asp:ListItem Value="2">Cliente Interno</asp:ListItem>
            </asp:RadioButtonList>
    </td>
        </tr>
    </table>
    
    <uc1:ConPacientesLight ID="ConPacientesLight1" runat="server" Visible="True" />
    <table runat="server" id="tblPer" visible="false">
    <tr><td><asp:Label ID="Label11" runat="server" Text="Funcionario" SkinID="lblFormatoFecha"></asp:Label></td>
    <td>
        <uc3:DropDownListU ID="ddlPer" runat="server" AutoPostBack="True" 
            NomTabla="PersonalHS" />
        </td></tr>
    </table>
    <asp:Panel ID="pnlEnc" runat="server" Visible="false">
    <br />
        <table class="style1" border="1">
            <tr>
                <td colspan="3" style="text-align: center" class="celdaTitulo">
                    <asp:Label ID="Label9" runat="server" SkinID="lblsubTitulo" 
                        Text="Diligenciamiento de Encuesta"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label6" runat="server" Text="Fecha"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="Label7" runat="server" Text="Teléfono"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="Label8" runat="server" Text="Teléfono1"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Fecha ID="fecEncuesta" runat="server" />
                </td>
                <td>
                    <asp:TextBox ID="txtTel" runat="server" MaxLength="50"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtTel1" runat="server" MaxLength="50"></asp:TextBox>
                </td>
            </tr>
        </table>
    <br />
        <table>
            <tr>
                <td style="width:100px;"></td>
                <td>
        <table class="style1">
            <tr>
                <td style="text-align: center">
                    <asp:Label ID="Label5" runat="server" SkinID="EtiquetaSubT" 
                        Text="Listado de preguntas:"></asp:Label>
                        <br />
                    <asp:Label ID="Label3" runat="server" Text="A continuación encontrará el listado de preguntas de la encuesta, por favor diligencie cada una"></asp:Label>
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:DataList ID="dtlPregunta" runat="server" DataKeyField="preId">
                        <ItemTemplate>
                         <asp:Label ID="Label2" runat="server" Visible="false"
                                            Text='<%#bind("preNumero")%>'></asp:Label>
                            <table border="1">
                                <tr>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" 
                                            Text='<%#"PREGUNTA: "+eval("preNumero").tostring()+". "+eval("preTexto")%>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBoxList ID="chklOpciones" runat="server">
                                        </asp:CheckBoxList>
                                        <asp:CheckBox ID="chkotro" runat="server" Text="Otro(s)? Cual(es)?" />
                                        <asp:TextBox ID="txtOtro" runat="server" MaxLength="50"></asp:TextBox>
                                        <asp:GridView ID="grvOpciones" runat="server" AutoGenerateColumns="false" 
                                            DataKeyNames="oppId" onprerender="grvOpciones_PreRender">
                                            <Columns>
                                                <asp:BoundField DataField="oppId" HeaderText="Número" />
                                                <asp:BoundField DataField="oppNumero" HeaderText="Número" />
                                                <asp:BoundField DataField="oppTexto" HeaderText="Opción" 
                                                    ItemStyle-Width="200px" />
                                                <asp:TemplateField HeaderText="Valor" ItemStyle-HorizontalAlign="Right" 
                                                    ItemStyle-Width="300px">
                                                    <ItemTemplate>
                                                        <asp:DropDownList ID="ddlrOp" runat="server">
                                                            <asp:ListItem Text="" Value="0" Selected="True" />
                                                            <asp:ListItem Text="Muy bajo" Value="1" />
                                                            <asp:ListItem Text="Bajo" Value="2" />
                                                            <asp:ListItem Text="Medio" Value="3" />
                                                            <asp:ListItem Text="Alto" Value="4" />
                                                            <asp:ListItem Text="Muy alto" Value="5" />
                                                        </asp:DropDownList>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" Text="Observaciones"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtComentarioPreg" runat="server" Height="45px" 
                                            MaxLength="250" TextMode="MultiLine" Width="260px"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                            <hr />
                            <br />
                        </ItemTemplate>
                    </asp:DataList>
                </td>
            </tr>
        </table>
        </td>
            <tr>
                <td colspan="2">
                    <asp:Label ID="Label4" runat="server" Text="Comentarios"></asp:Label>
                </td>
            </tr>

            </tr>
                        <tr>
                <td colspan="2">
                    <asp:TextBox ID="txtComentario" runat="server" Height="45px" MaxLength="250" 
                        TextMode="MultiLine" Width="500px"></asp:TextBox>
                </td>
            </tr>
        </table>
            <br />
        
    </asp:Panel>
</asp:Content>
