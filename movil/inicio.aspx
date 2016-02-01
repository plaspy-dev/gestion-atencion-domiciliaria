<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="inicio.aspx.cs" Inherits="inicio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .atras {
            display: none !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="c" Runat="Server">
    Bienvenido
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="s" Runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#PMenu").panel("open");
        });
    </script>
</asp:Content>