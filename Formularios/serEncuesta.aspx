<%@ Page Title="Encuestas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serEncuesta.aspx.vb" Inherits="ML.serEncuesta" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table class="style1">
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Nombre Encuesta"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtNombre" runat="server" MaxLength="50" Width="252px" OrigenDatos="encNombre"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Activo?"></asp:Label>
            </td>
            <td>
                <ml:CheckBox ID="chkActivo" runat="server" OrigenDatos="encActivo" />
            </td>
        </tr>
    </table>
    <br />
    <asp:LinkButton ID="lnkNuevaPreg" runat="server" CommandName="Nueva">Agregar Nueva Pregunta</asp:LinkButton>
    <br />
    <asp:Label ID="lblNoData" runat="server" 
        Text="No ha agregado preguntas,<br> haga click en 'Agregar Nueva Pregunta' para insertar preguntas" 
        SkinID="lblFormatoFecha"></asp:Label>
    <asp:DataList ID="dtlPregunta" runat="server" DataKeyField="preId">
        <ItemTemplate>
            <table class="style1" border="1">
                <tr>
                    <td>
                        <asp:Label ID="Label3" runat="server" Text="Número Preg"></asp:Label>
                    </td>
                    <td>
                        <ml:TextBox ID="txtNumeroPreg" runat="server" MaxLength="2" 
                            TipoTextBox="Entero" Width="42px" Text='<%#bind("preNumero")%>'></ml:TextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label4" runat="server" Text="Texto Pregunta"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtTextoPreg" TextMode="MultiLine" runat="server" MaxLength="150" Width="200px" Text='<%#bind("preTexto")%>'></asp:TextBox>
                    </td>
                    <td>
                        <ml:CheckBox ID="chkPregAct" runat="server" Text="Activa?" Checked='<%#bind("preActivo")%>'/>
                    </td>
                    <td>
                        <asp:LinkButton ID="lnkelimPreg" runat="server" CommandName="Delete">Elim</asp:LinkButton>
                    </td>
                    <tr>
                    <td>
                        <asp:Label ID="Label5" runat="server" Text="Tipo Pregunta"></asp:Label>
                    </td>
                    <td colspan="5">
                        <asp:RadioButtonList ID="rblTipoPreg" runat="server" 
                            RepeatDirection="Horizontal">
                        <asp:ListItem Value="1">Selección Múltiple</asp:ListItem>
                            <asp:ListItem Value="2">Puntaje</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    </tr>
                </tr>
                <tr>
                <td colspan="6" style="text-align: left">
                <asp:LinkButton ID="lnkNuevaOp" runat="server" CommandName="nuevaOp">Agregar nueva Opción</asp:LinkButton>
                <asp:GridView ID="grvOpcion" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="oppId"
                        EmptyDataText="No ha agregado opciones a esta pregunta,<br> haga click en 'Agregar nueva Opción' para insertar opciones de pregunta" 
                        onrowdeleting="grvOpcion_RowDeleting" onprerender="grvOpcion_PreRender">
                <Columns>
                    <asp:BoundField DataField="oppId" HeaderText="Id" />
                    <asp:TemplateField HeaderText="Num Opción">
                        <ItemTemplate>
                            <ml:TextBox ID="txtNumOp" runat="server" MaxLength="2" 
                                TipoTextBox="Entero" Width="26px" Text='<%#bind("oppNumero")%>'></ml:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Opción">
                        <ItemTemplate>
                            <ml:TextBox ID="txtTextoOp" runat="server" MaxLength="50" 
                                 Width="200px" Text='<%#bind("oppTexto")%>'></ml:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Num Opción">
                        <ItemTemplate>
                            <ml:CheckBox ID="chkOpAct" runat="server" Text="Activa?" Checked='<%#bind("oppActivo")%>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
                </Columns>
            </asp:GridView>
                </td></tr>
            </table>
            <br />
        </ItemTemplate>
    </asp:DataList>
</asp:Content>
