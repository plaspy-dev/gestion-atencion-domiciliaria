<%@ Page Title="Programaciones sin Autorización" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AudProgNoAut.aspx.vb" Inherits="ML.AudProgNoAut" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro id="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="FechaIni,FechaFin,prgTipo,entId" Titulos="Fecha Inicial,Fecha Final,Tipo Programación,Asegurador" Referencias=",,prgTipo,Asegurador" Expandido="true" />
    <ml:GridView id="grvPrg" runat="server" AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="PrgTipoNom" HeaderText="Tipo Prog" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" />
            <asp:BoundField DataField="PacNombre" HeaderText="Paciente" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" />
            <asp:BoundField DataField="prgFechaProg" HeaderText="Fecha Prog" DataFormatString="{0:dd/MM/yyyy}" /> 
            <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
            <asp:BoundField DataField="prgNumSesion" HeaderText="Número Sesiones" />
            <asp:BoundField DataField="perNombre" HeaderText="Personal Asignado" />
        </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
