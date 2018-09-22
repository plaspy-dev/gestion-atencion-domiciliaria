<%@ Page Title="Consulta Historia" Language="C#" MasterPageFile="~/nologin.master" AutoEventWireup="true" CodeFile="consultahistoria.aspx.cs" Inherits="archivo_consultahistoria" %>

<asp:Content ID="Content1" ContentPlaceHolderID="h" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="c" Runat="Server">
    <asp:Panel runat="server" ID="PD" DefaultButton="BB" style="text-align: center;">
        Numero de historia <asp:TextBox runat="server" CssClass="entero" ID="TKey"></asp:TextBox>
        <asp:Button runat="server" ID="BB" Text="Buscar" OnClick="BB_Click" />
        <br /><asp:Label runat="server" ForeColor="Red" ID="LMessage"></asp:Label>
    </asp:Panel>
</asp:Content>