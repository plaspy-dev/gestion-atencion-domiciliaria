<%@ Page Title="Personal disponible" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AtxPerDisponible.aspx.vb" Inherits="ML.AtxPerDisponible" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="FechaIni,perId,carId" Titulos="Fecha de Consulta,Funcionario,Cargo" Referencias=",PersonalMed,Cargo" />
    <ml:GridView ID="grvPer" runat="server" AutoGenerateColumns="false">
    <Columns>
    <asp:BoundField HeaderText="Documento" DataField="perDocumento" />
    <asp:BoundField HeaderText="Nombre" DataField="perNombre" />
    <asp:BoundField HeaderText="Cargo" DataField="carDescripcion" />
    <asp:BoundField HeaderText="Disponibilidad" DataField="dispDescripcion" />
    </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
