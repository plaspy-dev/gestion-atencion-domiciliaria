<%@ Control Language="C#" AutoEventWireup="true" CodeFile="eventoselect.ascx.cs" Inherits="evento_eventoselect" %>
<script>autoComplete({ controlId: "<%= T.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Evento")%>", controlDataId: "<%= I.ClientID %>", autoSelect: true });</script>
<asp:TextBox runat="server" ID="T"></asp:TextBox>
<asp:TextBox runat="server" ID="I" CssClass="hide"></asp:TextBox>