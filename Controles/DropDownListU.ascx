<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DropDownListU.ascx.vb" Inherits="ML.DropDownListU" %>
<asp:TextBox ID="txt" runat="server" Width="36px" Visible="false"></asp:TextBox>
<asp:DropDownList ID="ddl" runat="server">
</asp:DropDownList>
<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic"
    ControlToValidate="ddl" Enabled="False" ErrorMessage="Requerido" Text="Requerido">Requerido</asp:RequiredFieldValidator>

