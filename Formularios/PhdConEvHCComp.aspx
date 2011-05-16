<%@ Page Title="Consulta Evolución HC" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdConEvHCComp.aspx.vb" Inherits="ML.PhdConEvHCComp" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="pacDocumento,FechaIni,FechaFin,entId" Titulos="Digite Nombre o Documento Paciente,Fecha Inicial,Fecha Final,Asegurador" Referencias=",,,Asegurador" Expandido="true" />    
    <asp:GridView ID="grvEv" runat="server" AutoGenerateColumns="false">
    <Columns >
    <asp:BoundField HeaderText="Fecha HC" DataField="hcFecha" DataFormatString="{0:dd/MM/yyyy}" />
    <asp:BoundField HeaderText="Documento" DataField="pacDocumento" />
    <asp:BoundField HeaderText="Paciente" DataField="pacNombres" />
    <asp:BoundField HeaderText="Fecha Nac" DataField="pacFechaNac"  DataFormatString="{0:dd/MM/yyyy}"/>
    <asp:BoundField HeaderText="Asegurador" DataField="entNombre" />
    <asp:BoundField HeaderText="Direccion" DataField="pacDireccion" />
    <asp:BoundField HeaderText="Telefono" DataField="pacTelefono" />
    <asp:BoundField HeaderText="CIE10" DataField="cieCodDx" />
    <asp:BoundField HeaderText="Grado" DataField="pacGrado" />
    <asp:TemplateField HeaderText="Novedades" >
        <ItemTemplate>
            <%#Eval("hcNovedades")%> 
            <%#IIf(Eval("hcObsPsicologia") Is Nothing, "", vbCr + vbCr + Eval("hcObsPsicologia"))%>
            <%#IIf(Eval("hcObsTrSocial") Is Nothing, "", vbCr + vbCr + Eval("hcObsTrSocial"))%>
            <%#IIf(Eval("hcObsNutricion") Is Nothing, "", vbCr + vbCr + Eval("hcObsNutricion"))%>
        </ItemTemplate>
    </asp:TemplateField>
    </Columns>
    </asp:GridView>


</asp:Content>
