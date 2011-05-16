<%@ Page Title="Auditoria Novedades" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AtxNovedad.aspx.vb" Inherits="ML.AtxNovedad" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="pacDocumento,FechaIni,FechaFin,novTipo" Titulos="Digite Número de Documento o nombre,Fecha Inicial,Fecha Final,Tipo Novedad" Referencias=",,,novTipo" Expandido="true" />
    <ml:GridView ID="grvNov" runat="server" AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" />
            <asp:BoundField DataField="PacNombre" HeaderText="Paciente" />
            <asp:BoundField DataField="autNumero" HeaderText="Autorizacion" />
            <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha Prog" DataFormatString="{0:dd/MM/yyyy}" /> 
            <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
            <asp:BoundField DataField="FechaIni" HeaderText="Fecha Nov" />
            <asp:BoundField DataField="tpaDescripcion" HeaderText="Tipo novedad" />
            <asp:BoundField DataField="cnoDescripcion" HeaderText="Causa Novedad" />
            <asp:BoundField DataField="perNombreAnt" HeaderText="Personal Involucrado" />
            <asp:BoundField DataField="perNombre" HeaderText="Personal Asignado" />
            <asp:BoundField DataField="perNombre" HeaderText="Observaciones" />
        </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
