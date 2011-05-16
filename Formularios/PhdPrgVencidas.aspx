<%@ Page Title="Consulta Programaciones Vencidas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdPrgVencidas.aspx.vb" Inherits="ML.PhdPrgVencidas" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="FechaIni" Titulos="Fecha de Consulta" Referencias="" />
    <ml:GridView ID="grvPer" runat="server" AutoGenerateColumns="false">
    <Columns>
    <asp:BoundField HeaderText="Documento" DataField="pacDocumento" />
    <asp:BoundField HeaderText="Nombre" DataField="PacNombre" />
    <asp:BoundField HeaderText="Asegurador" DataField="entNombre" />
    <asp:BoundField HeaderText="Actividad" DataField="actDescripcion" />
    </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
