<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Fecha.ascx.vb" Inherits="ML.Fecha" %>
<div>
    <asp:TextBox ID="txtFecha" runat="server" Width="70px"></asp:TextBox>
    <asp:MaskedEditExtender ID="txtFecha_MaskedEditExtender" runat="server" 
        MaskType="Date" TargetControlID="txtFecha">
    </asp:MaskedEditExtender>
    <asp:ImageButton ID="imbCalendario" runat="server" SkinID="imbCalendario" ToolTip="Mostrar Calendario" />
    <asp:CalendarExtender ID="TextBox1_CalendarExtender" runat="server" 
        TargetControlID="txtFecha" PopupButtonID="imbCalendario" >
    </asp:CalendarExtender>
    <asp:Label ID="lblFormato" runat="server" SkinID="lblFormatoFecha"></asp:Label>
    <asp:MaskedEditValidator ID="MaskedEditValidator1" runat="server" 
        ControlExtender="txtFecha_MaskedEditExtender" ControlToValidate="txtFecha" 
        Display="Dynamic" EmptyValueMessage="Requerido" Text="Requerido"
        InvalidValueMessage="Fecha Inválida" TooltipMessage="Fecha Inválida"></asp:MaskedEditValidator>
</div>
