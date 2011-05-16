<%@ Page Title="Tareas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="GenAlertasPendientes.aspx.vb" Inherits="ML.GenAlertasPendientes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
            text-align:center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
        <ml:GridView ID="grvTar" runat="server">
        </ml:GridView>
</asp:Content>
