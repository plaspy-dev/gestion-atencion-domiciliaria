<%@ Page Title="Cumpleaños del Día" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="RHCumpleAnios.aspx.vb" Inherits="ML.RHCumpleAnios" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<%@ Register src="../Controles/Correo.ascx" tagname="Correo" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.RRHH.Personal" Expandido="True" Campos="perFechaNac,perFechaIngreso" Titulos="Fecha Inicial,Fecha Final" />
   <%-- <asp:DropDownList ID="ddlMes" runat="server" AutoPostBack="True">
    </asp:DropDownList>--%>
    <ml:GridView ID="grvCumple" runat="server" AutoGenerateColumns="false">
    <Columns>
    <asp:BoundField DataField="perFechaNac" HeaderText="Fecha Nacimiento" DataFormatString="{0:dd} de {0:MMMM}" />
    <asp:BoundField DataField="perNombres" HeaderText="Nombre" />
    <asp:BoundField DataField="perApellidos" HeaderText="Apellidos" />
    <asp:BoundField DataField="carDescripcion" HeaderText="Cargo" />    
    <asp:BoundField DataField="perCorreoElectronico" HeaderText="Correo" />
    <asp:CheckBoxField DataField="enviado" HeaderText="Enviado?" />
    </Columns>
    </ml:GridView>
    <br />
    <asp:LinkButton ID="lnkCorreo" runat="server">Enviar Correo de Felicitación</asp:LinkButton>
    <uc2:Correo ID="Correo1" runat="server" TipoCorreo="Cumpleanios" />
</asp:Content>
