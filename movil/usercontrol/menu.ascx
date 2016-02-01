<%@ Control Language="C#" AutoEventWireup="true" CodeFile="menu.ascx.cs" Inherits="usercontrol_menu" %>
<asp:Panel runat="server" ID="PMenu" CssClass="hide" data-role="panel" ClientIDMode="Static" data-position-fixed="true" data-display="overlay" data-theme="a" data-position="right">
    <asp:Repeater runat="server" ID="RM">
        <HeaderTemplate><ul data-role="listview">
            <li data-icon="delete"><a href="#" data-rel="close">Cancelar</a></li>
        </HeaderTemplate>
        <FooterTemplate></ul></FooterTemplate>
        <ItemTemplate>
            <li <%# Eval("url")==null ? "data-role='list-divider'" : "" %>><asp:HyperLink runat="server" ID="H" Text='<%# Eval("Titulo") %>' NavigateUrl='<%# GetURL(Eval("url")) %>'></asp:HyperLink></li>
        </ItemTemplate>
    </asp:Repeater>
</asp:Panel>