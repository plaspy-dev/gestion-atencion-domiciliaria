<%@ Page Title="Archivo Gestión" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="arcConsultaArchivo.aspx.vb" Inherits="ML.arcConsultaArchivo" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc2" %>
<%@ Register src="../Controles/ConPacientesLightM.ascx" tagname="ConPacientesLightM" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style type="text/css">
    .style1
    {
        width: 100%;
        text-align:left ;
    }
    .style2
    {
        width: 100%;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc2:Filtro ID="Filtro1" runat="server" Tipo="ML.ServiciosMedicos.arcArchivoGestion" Campos="segUsuarioIngreso,arcFactura,arcAnio,arcMes" Titulos="Digite Nombre o Documento Paciente,Nro Factura,Año,Mes" Expandido="true" />
    <asp:Panel ID="pnlContenido" runat="server">
    <table class="style2">
        <tr>
            <td>
                <ml:GridView ID="grvArchivo" runat="server" AutoGenerateColumns="False" 
                             EmptyDataText="No se encuentran registros" TotalPaginas="0" DataKeyNames="arcId">
                    <Columns>
                        <asp:TemplateField HeaderText="Documento" >
                        <ItemTemplate>
                            <%#Eval("pacDocumento")%>
                        </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Paciente">
                        <ItemTemplate>
                            <%#Eval("pacNombres")%>
                        </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="arcFactura" HeaderText="Factura Nro." >
                        <ControlStyle CssClass="textoEntrada" />
                        </asp:BoundField>
                        <asp:BoundField DataField="arcAZ" HeaderText="A-Z." >
                        <ControlStyle CssClass="textoEntrada" />
                        </asp:BoundField>
                        <asp:BoundField DataField="arcAnio" HeaderText="Año" >
                        <ControlStyle CssClass="textoEntrada" />
                        </asp:BoundField>
                        <asp:BoundField DataField="arcMes" HeaderText="Mes" >
                        <ControlStyle CssClass="textoEntrada" />
                        </asp:BoundField>
                        <asp:CommandField ShowEditButton="true" EditText="Editar" />
                    </Columns>
                </ml:GridView>
            </td>
        </tr>
    </table>
    </asp:Panel>
</asp:Content>
