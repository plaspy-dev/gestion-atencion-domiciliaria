<%@ Page Title="Consulta Programación Servicios Médicos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdHistoriaClinicaCon.aspx.vb" Inherits="ML.PhdHistoriaClinicaCon" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>
<%@ Register src="../Controles/Novedad.ascx" tagname="Novedad" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="pacDocumento,FechaIni,FechaFin,entId,perNombre" Titulos="Digite Nombre o Documento Paciente,Fecha Inicial,Fecha Final,Asegurador,Digite Nombre o Documento Profesional" Referencias=",,,Asegurador," Expandido="true" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
    <ContentTemplate>
    <br />
    <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        TotalPaginas="0">
        <Columns>
            <asp:TemplateField HeaderText="Fecha">
                <ItemTemplate>
                    <a href='PhdHistoriaClinica.aspx?id=<%#Eval("hclId")%>'><%#String.Format("{0:dd/MM/yyyy}", Eval("hclFecha"))%></a>
                </ItemTemplate>
            </asp:TemplateField>  
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" />
            <asp:BoundField DataField="pacNombres" HeaderText="Paciente" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" />
            <asp:BoundField DataField="perNombre" HeaderText="Profesional" />
            <asp:BoundField DataField="hclAnalisisActual" HeaderText="Analisis Actual" />
            <asp:BoundField DataField="hclPlanManejo" HeaderText="Plan Manejo" />                      
        </Columns>
    </ml:GridView>
    <br />
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
    
    <a href="javascript:imprimir('<%=UpdatePanel1.clientId %>')" class="link" >Imprimir Resultados</a>
    
</asp:Content>
