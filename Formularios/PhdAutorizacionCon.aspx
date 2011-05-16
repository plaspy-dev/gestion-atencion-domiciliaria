<%@ Page Title="Autorizaciones" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdAutorizacionCon.aspx.vb" Inherits="ML.PhdAutorizacionCon" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>

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
                    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="entId,FechaIni,FechaFin,tpaId" Titulos="Seleccione Asegurador,Fecha Inicial,Fecha Final,Tipo Actividad" Referencias="Asegurador,,,TipoActividad" Expandido="true" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <br />
        <ml:GridView ID="grvAut" runat="server" AutoGenerateColumns="False" 
        AllowPaging="True" PageSize="50" ShowHeader="False" DataKeyNames="autNumero" EmptyDataText="No se encuentran autorizaciones, por favor verifique los criterios de búsqueda">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                    <table class="style1">
                <tr>
                    <td>
                        Número
                    </td>
                    <td>
                        Documento
                    </td>
                    <td>
                        Paciente
                    </td>
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
            <asp:CommandField  ShowEditButton="True" EditText="Editar" HeaderText="Editar" />
            <asp:CommandField DeleteText="Eliminar" ShowDeleteButton="True" />
        </Columns>
    </ml:GridView>
   
</asp:Content>
