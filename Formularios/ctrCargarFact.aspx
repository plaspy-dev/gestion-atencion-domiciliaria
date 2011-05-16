<%@ Page Title="Carque facturas por archivo" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ctrCargarFact.aspx.vb" Inherits="ML.ctrCargarFact" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <div>
        <asp:Label runat="server" ID="lblCar" Text="Por favor seleccione el archivo a cargar"></asp:Label>
        <asp:FileUpload ID="fupArc" runat="server" />
        <br />
        <asp:LinkButton ID="lnkEstr" runat="server">Ver Estructura</asp:LinkButton>
        <asp:LinkButton ID="lnkCar" runat="server">Cargar</asp:LinkButton>
    </div>
    <asp:Label runat="server" ID="lblMsj" Text="" Visible="false"></asp:Label>
    <asp:GridView ID="grvCar" runat="server">
    </asp:GridView>
    <asp:LinkButton ID="lnkAceptar" runat="server" Visible="false">Finalizar Carga</asp:LinkButton>
    <asp:LinkButton ID="lnkCancelar" runat="server" Visible="false">Cancelar</asp:LinkButton>
</asp:Content>
