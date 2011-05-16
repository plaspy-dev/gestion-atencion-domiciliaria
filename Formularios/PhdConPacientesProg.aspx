<%@ Page Title="Consulta de Pacientes Programados" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdConPacientesProg.aspx.vb" Inherits="ML.PhdConPacientesProg" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>
<%@ Register src="../Controles/Novedad.ascx" tagname="Novedad" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="prgTipo,FechaIni,FechaFin,entId" Titulos="Tipo de Servicio,Fecha Inicial,Fecha Final,Asegurador" Referencias="prgTipo,,,Asegurador" Expandido="true" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
    <ContentTemplate>    
    <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        TotalPaginas="0">
        <Columns>
            <asp:BoundField DataField="pacNombre" HeaderText="Paciente" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" />
            <asp:BoundField DataField="pacBarrio" HeaderText="Barrio" />
            <asp:BoundField DataField="pacZona" HeaderText="Zona" />
            <asp:BoundField DataField="pacTelefono" HeaderText="Teléfono" />
            <asp:BoundField DataField="prgObservaciones" HeaderText="Tipo evento" />
        </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
