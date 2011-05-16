<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Autorizacion.ascx.vb" Inherits="ML.Autorizacion" %>
<div class="divMargen" style=" width:150px;">
     <ml:TextBox ID="txtNumAut" runat="server" 
    MaxLength="50"></ml:TextBox>
    <div id="divVal" runat="server"></div>
    <asp:HiddenField ID="hdfTS" runat="server" />
</div>