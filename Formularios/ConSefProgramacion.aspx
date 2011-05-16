<%@ Page Title="Consultas Servicio Farmaceútico" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ConSefProgramacion.aspx.vb" Inherits="ML.ConSefProgramacion" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
   <div style=" width:100%; text-align:center">
<table width="100%">
<tr><td><asp:Label ID="Label1" runat="server" 
        Text="Seleccione los criterios de consulta"></asp:Label></td></tr>
<tr><td align="center"><uc1:Filtro ID="Filtro1" runat="server" 
        Tipo="ML.Datos.ServiciosFarmaceuticos.Programacion" 
        Titulos="Digite Identificación o nombre del Paciente,Fecha Inicial de Consulta, Fecha Final de Consulta" 
        Campos="pacNombre,proFecha,proFechaFin"/></td></tr>
</table>  
    <asp:LinkButton ID="lnkReporte" runat="server" Visible="false">Ver Reporte</asp:LinkButton>
    </div>
    <br />
    <asp:GridView ID="grvConsulta" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" 
        PageSize="20">
        <Columns>
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                SortExpression="pacDocumento" />
            <asp:BoundField DataField="PacNombre" HeaderText="Nombre" 
                SortExpression="PacNombre" />
            <asp:BoundField DataField="proFecha" HeaderText="Fecha" 
                SortExpression="proFecha" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="insDescripcion" HeaderText="Insumo" 
                SortExpression="insDescripcion" />
            <asp:BoundField DataField="proCantidad" HeaderText="Cantidad" 
                SortExpression="proCantidad" />
            <asp:BoundField DataField="proObservaciones" HeaderText="Observaciones" 
                SortExpression="proObservaciones" />
        </Columns>
    </asp:GridView>
</asp:Content>
