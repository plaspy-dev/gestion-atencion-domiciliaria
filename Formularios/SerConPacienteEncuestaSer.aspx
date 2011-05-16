<%@ Page Title="Consulta de pacientes vs Encuesta de Servicio" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="SerConPacienteEncuestaSer.aspx.vb" Inherits="ML.SerConPacienteEncuestaSer" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.Censos.Censos" Campos="pacDocumento,pacId" Titulos="Digite Nombre o Documento,Seleccione Asegurador" Referencias=",Asegurador" Expandido="true" />
    <asp:GridView ID="grvPac" runat="server" AutoGenerateColumns="False"  DataKeyNames="pacId"
        AllowSorting="true"
        EmptyDataText="No se encuentran Pacientes" >
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                    <a target="_blank" href="serEncuestaServicio.aspx?o=1&p=<%#Eval("pacId") %>">Encuestar</a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                SortExpression="pacDocumento" />
            <asp:BoundField DataField="pacNombres" HeaderText="Nombre" 
                SortExpression="pacNombres" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" 
                SortExpression="entNombre" />
            <asp:BoundField DataField="pacTelefono" HeaderText="Telefono" 
                SortExpression="pacTelefono" />
                <asp:BoundField DataField="pacFecIngPrograma" HeaderText="Fecha Ingreso a Atención Domiciliaria" 
                SortExpression="pacFecIngPrograma" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:TemplateField>
                <ItemTemplate>
                    <a target="_blank" href="serEncuestaServicio.aspx?o=1&i=<%#Eval("ensId") %>"><%#String.Format("{0:dd/MM/yyyy}", Eval("ensFecha"))%></a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ensFecha" HeaderText="Fecha Última Encuesta" 
                SortExpression="ensFecha" DataFormatString="{0:dd/MM/yyyy}" />
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
