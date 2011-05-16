<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdConValor.aspx.vb" Inherits="ML.phdConValor" %>
<%@ Register src="../Controles/VerAvance.ascx" tagname="VerAvance" tagprefix="uc3" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="tpaId,actId" Titulos="Año,Mes" Referencias="anio,mes" Expandido="true" />
    <br />
    <asp:Repeater ID="rtrSeguimientoRestriccion" runat="server">
    <HeaderTemplate>
<hr/>
        <asp:Label runat="server" ID="Label1" Text='Seguimiento a restricciones de costos por Asegurador en el mes' SkinID="EtiquetaSubT"></asp:Label>
    </HeaderTemplate>
    <ItemTemplate>
        <br />
        <asp:Label runat="server" ID="lvlEnt" Text='<%#"Avance en costos para "+Eval("entNombre")+", Valor total: $"+String.Format("{0:N}",Eval("val"))%>'></asp:Label>
        <br />
        <br />
        <uc3:VerAvance ID="VerAvance1" runat="server" Avance='<%#Bind("por")%>' Url='<%# String.Format("audCostosEnt.aspx?a={0}&m={1}&e={2}",me.anio,me.mes,eval("entId"))%>'/>
    </ItemTemplate>
    <FooterTemplate>
<hr/>
    </FooterTemplate>
    </asp:Repeater>
</asp:Content>
