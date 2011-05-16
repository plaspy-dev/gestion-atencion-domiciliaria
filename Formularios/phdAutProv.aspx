<%@ Page Title="Confirmación de autorizaciones provisionales" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdAutProv.aspx.vb" Inherits="ML.phdAutProv" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="pacDocumento,entId" Titulos="Digite Nombre o Documento Paciente,Asegurador" Referencias=",Asegurador" Expandido="true" />
    <br />
    <asp:GridView ID="grvAut" runat="server" AutoGenerateColumns="false" EmptyDataText="No se han registrado autorizaciones provisionales">
    <Columns>
    <asp:BoundField DataField="autNumero" HeaderText="Autorización" />
    <asp:BoundField DataField="autFecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
    <asp:BoundField DataField="autFechaVenc" HeaderText="Fecha Vencimiento" />
    <asp:BoundField DataField="pacDocumento" HeaderText="Documento" />
    <asp:BoundField DataField="PacNombres" HeaderText="Paciente" />
    <asp:BoundField DataField="entNombre" HeaderText="Asegurador" />
    <asp:TemplateField HeaderText="Número Definitivo">
    <ItemTemplate>
        <asp:TextBox ID="txtNumAut" runat="server"></asp:TextBox>
    </ItemTemplate>
    </asp:TemplateField>
    </Columns>
    </asp:GridView>
    <br />
    <asp:LinkButton ID="lnkAct" runat="server" OnClientClick="if(!confirm('Confirma la operación'))return false;">Confirmar Autorizaciones</asp:LinkButton>
</asp:Content>
