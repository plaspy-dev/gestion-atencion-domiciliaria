<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="RHConPerInactivo.aspx.vb" Inherits="ML.RHConPerInactivo" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="carId,areaId,FechaIni,FechaFin" Titulos="Cargo,Causa Retiro,Fec ini Retiro,Fec fin Retiro" Referencias="Cargo,MotivoTerminacion,," Expandido="true" />
    <ml:GridView ID="grvPer" runat="server" AutoGenerateColumns="false" AllowSorting="true">
    <Columns>
    <asp:BoundField HeaderText="Documento" DataField="perDocumento" SortExpression="perDocumento" />
    <asp:BoundField HeaderText="Nombre" DataField="perNombre" SortExpression="perNombre" />
    <asp:BoundField HeaderText="Fecha Ing." DataField="perFechaIngreso" DataFormatString="{0:dd/MM/yyyy}" SortExpression="perFechaIngreso" />
    <asp:BoundField HeaderText="Fecha Ret." DataField="perFechaTermContrato" DataFormatString="{0:dd/MM/yyyy}" SortExpression="perFechaTermContrato" />
    <asp:BoundField HeaderText="Motivo" DataField="mteDescripcion" SortExpression="mteDescripcion" />
    <asp:BoundField HeaderText="Cargo" DataField="carDescripcion" SortExpression="carDescripcion" />
    </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
