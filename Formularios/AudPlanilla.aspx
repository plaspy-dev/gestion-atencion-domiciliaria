<%@ Page Title="Planilla Famisanar" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AudPlanilla.aspx.vb" Inherits="ML.AudPlanilla" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="entId,prgNumSesion,areaId" Titulos="Asegurador,Año,Mes" Referencias="Asegurador,anio,mes" Expandido="true" />
    <ml:GridView ID="grvNov" runat="server" >
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
