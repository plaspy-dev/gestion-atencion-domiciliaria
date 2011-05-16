<%@ Page Title="Consulta de Complicaciones derivadas de la prestación de servicios médicos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AudConComplicacion.aspx.vb" Inherits="ML.AudConComplicacion" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>
<%@ Register src="../Controles/Novedad.ascx" tagname="Novedad" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="pacDocumento,FechaIni,FechaFin,entId" Titulos="Digite Nombre o Documento Paciente,Fecha Inicial,Fecha Final,Asegurador" Referencias=",,,Asegurador" Expandido="true" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
    <ContentTemplate>
    
    <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        TotalPaginas="0">
        <Columns>
            <asp:BoundField DataField="comFecha" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Fecha" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" />
            <asp:BoundField DataField="pacNombres" HeaderText="Paciente" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" />
            <asp:BoundField DataField="comRiesgo" HeaderText="Riesgo" />
            <asp:BoundField DataField="comCausa" HeaderText="Causa" />
            <asp:BoundField DataField="comAccionMejora" HeaderText="Acción de Mejora" />
            <asp:BoundField DataField="segUsuarioIngreso" HeaderText="Usuario" />
            <asp:BoundField DataField="segFechaIngreso" HeaderText="Fecha Sistema" />
        </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
    
    <a href="javascript:imprimir('<%=UpdatePanel1.clientId %>')" class="link" >Imprimir Resultados</a>
</asp:Content>
