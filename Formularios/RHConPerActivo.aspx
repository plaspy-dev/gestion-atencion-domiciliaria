<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="RHConPerActivo.aspx.vb" Inherits="ML.RHConPerActivo" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="carId,areaId,FechaIni,FechaFin" Titulos="Cargo,Area,Fec ini Ingreso,Fec fin Ingreso" Referencias="Cargo,area,," />
    <ml:GridView ID="grvPer" runat="server" AutoGenerateColumns="false" AllowSorting="true">
    <Columns>
    <asp:BoundField HeaderText="Documento" DataField="perDocumento" SortExpression="perDocumento" />
    <asp:BoundField HeaderText="Nombre" DataField="perNombre" SortExpression="perNombre" />
    <asp:BoundField HeaderText="Fecha Ing." DataField="perFechaIngreso" DataFormatString="{0:dd/MM/yyyy}" SortExpression="perFechaIngreso" />
    <asp:BoundField HeaderText="Cargo" DataField="carDescripcion" SortExpression="carDescripcion" />
    <asp:BoundField HeaderText="Disponibilidad" DataField="dispDescripcion" SortExpression="dispDescripcion" />
    <asp:BoundField HeaderText="Paciente" DataField="PacNombre" SortExpression="PacNombre" />
    </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
