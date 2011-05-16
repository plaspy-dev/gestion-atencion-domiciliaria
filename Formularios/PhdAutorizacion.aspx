<%@ Page Title="Autorizaciones" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdAutorizacion.aspx.vb" Inherits="ML.PhdAutorizacion1" %>

<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:Panel ID="pnlBus" runat="server">
        <table class="style1">
            <tr>
                <td>
                    <asp:Label ID="Label6" runat="server" 
                        Text="Para iniciar, puede buscar una autorización por número o por Paciente"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:TextBox ID="txtBusNumAut" runat="server" MaxLength="50" Width="224px"></asp:TextBox>
                    <asp:TextBoxWatermarkExtender ID="txtBusNumAut_TextBoxWatermarkExtender" 
                        runat="server" TargetControlID="txtBusNumAut" WatermarkCssClass="MarcaAgua" 
                        WatermarkText="Digite el número de autorización a buscar">
                    </asp:TextBoxWatermarkExtender>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:TextBox ID="txtBusPac" runat="server" MaxLength="50" Width="224px"></asp:TextBox>
                    <asp:TextBoxWatermarkExtender ID="txtBusPac_TextBoxWatermarkExtender" 
                        runat="server" TargetControlID="txtBusPac" WatermarkCssClass="MarcaAgua" 
                        WatermarkText="Digite el documento o nombre del paciente">
                    </asp:TextBoxWatermarkExtender>
                    <asp:ImageButton ID="imbBuscar" runat="server" Height="16px" SkinID="imbBuscar" 
                        Width="16px" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <br />
    <ml:GridView ID="grvAut" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="5" 
                ShowHeader="False" DataKeyNames="autNumero"
                EmptyDataText="No se encuentran autorizaciones, por favor verifique los criterios de búsqueda">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                    <table class="style1">
                <tr>
                    <td>
                        <asp:Label ID="Label8" runat="server" Text="Número"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label9" runat="server" Text="Doc Paciente"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label10" runat="server" Text="Nombre Paciente"></asp:Label>
                    </td>
                    <th>
                        Estado
                    </th>
                </tr>
                <tr>
                    <td>
                        <%#Eval("autNumero")%>
                    </td>
                    <td>
                        <%#Eval("pacDocumento")%>
                    </td>
                    <td>
                        <%#Eval("pacNombres")%>
                    </td>
                    <td>
                        <%#GetNomEstado(Eval("autActivo"), Eval("autFechaSuspension"))%>
                    </td>
                </tr>
                <tr>
                <td>
                <%#String.Format("de {0:dd/MM/yyyy}", Eval("autFecha"))%><br />
                <%#String.Format("a {0:dd/MM/yyyy}", Eval("autFechaVenc"))%>
                </td>
                    <td colspan="2" style="text-align:right">
                        <asp:GridView ID="grvActs" runat="server" AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField DataField="actDescripcion" 
                                HeaderText="Actividad" SortExpression="actDescripcion" />               
                            <asp:BoundField DataField="autNumSesiones" HeaderText="Num Sesiones" 
                                SortExpression="autNumSesiones" />
                            <asp:BoundField DataField="autSesionesDia" HeaderText="Sesiones/Dia" 
                                SortExpression="autSesionesDia" />
                            <asp:BoundField DataField="prgNumSesion" HeaderText="Realizadas" 
                                SortExpression="prgNumSesion" />
                        </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
            <br />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField  ShowSelectButton="True" SelectText="Editar" HeaderText="Editar"  ItemStyle-CssClass="margin"/>
            <asp:TemplateField>
                <ItemTemplate>                    
                    <a href="javascript:anular('<%#Eval("autNumero")%>');"><%#IIf(Eval("autActivo"), "Anular o Suspender", "")%></a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField DeleteText="Eliminar" ShowDeleteButton="True"  ItemStyle-CssClass="margin"/>
        </Columns>
    </ml:GridView>

    <%
        rblAccion.Items(0).Attributes.Add("onclick", "verFechaSusp(false);")
        rblAccion.Items(1).Attributes.Add("onclick", "verFechaSusp(true);")
     %>
   <ml:Panel runat="server" id="pnlAnular" Titulo="Anular o suspender Autorización" Height="300px">
        <div style="width:100%;text-align:center;">
            <table width="100%">
                <tr>
                    <td colspan="2">
                        <asp:RadioButtonList ID="rblAccion" runat="server" RepeatDirection="Horizontal" Height="100%">
                            <asp:ListItem Text="Anular" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Suspender" Value="2"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr id="trFechaSusp">
                    <td>Suspender hasta el dia:</td>
                    <td>
                        
                        <uc1:Fecha ID="fchSusp" runat="server" />
                        
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <ml:TextBox ID="txtAnulObs" runat="server" TextMode="MultiLine" Width="300px" Height="150px"></ml:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:LinkButton ID="lnkAnul" runat="server" OnClientClick="return confirm('Confirma la acción?');">Aceptar</asp:LinkButton>
                    </td>
                </tr>
            </table>
            <asp:HiddenField runat="server" ID="hdfNumAut" Value="" />
        </div>
        
   </ml:Panel>
       <script type="text/javascript">
        function anular(autNum) { 
            getEl('<%=hdfNumAut.clientId%>').value=autNum;
            <%=pnlAnular.fnMostrar%>;
        }
        function verFechaSusp(ver){
            getEl('trFechaSusp').style.display=ver?"block":"none";
        }
        verFechaSusp(<%=iif(rblAccion.selectedValue="1","false","true") %>);
    </script>
</asp:Content>
