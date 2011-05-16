<%@ Page Title="Consulta Programación Apoyo Terapéutico" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AtxConfirmaPrg.aspx.vb" Inherits="ML.AtxConfirmaPrg" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>
<%@ Register src="../Controles/Novedad.ascx" tagname="Novedad" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="pacDocumento,FechaIni,FechaFin,perNombre,actId" Titulos="Digite Nombre o Documento Paciente,Fecha Inicial,Fecha Final,Digite Nombre o Documento Profesional,Actividad" Referencias=",,,,ActividadTer" Expandido="true" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        TotalPaginas="0" DataKeyNames="prgId,prgActivo">
        <Columns>
            <asp:TemplateField HeaderText="Conf">
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%#bind("prgActivo")%>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="prgFechaProg" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Fecha" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" />
            <asp:BoundField DataField="pacNombre" HeaderText="Paciente" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" />
            <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
            <asp:BoundField DataField="perNombre" HeaderText="Profesional" />
            <asp:BoundField DataField="autNumero" HeaderText="Autorización" />
            </Columns>
    </ml:GridView>
        <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
