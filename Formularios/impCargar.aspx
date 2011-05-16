<%@ Page Title="Carque facturas por archivo" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="impCargar.aspx.vb" Inherits="ML.impCargar" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <div id="dvInicio" runat="server">
        <asp:Label runat="server" ID="Label1" Text="Estructura del archivo:"></asp:Label>
        <div runat="server" id="dvEstr"></div>    
        <br />
        <br />
        <asp:Label runat="server" ID="lblCar" Text="Por favor seleccione el archivo a cargar"></asp:Label>
        <asp:FileUpload ID="fupArc" runat="server" />
        <br />
        <asp:LinkButton ID="lnkCar" runat="server">Cargar</asp:LinkButton>
    </div>
        <asp:Label runat="server" ID="lblMsj" Text=""></asp:Label>
        <br />
        <div runat="server" id="dvDatos"></div>
    <div id="dvFin" runat="server" visible="false" style="margin-left: 20px;">
        <br />
        <asp:LinkButton ID="lnkAceptar" runat="server" >Finalizar Carga</asp:LinkButton>&nbsp;&nbsp;
        <asp:LinkButton ID="lnkCancelar" runat="server" >Cancelar</asp:LinkButton>
    </div>
</asp:Content>
