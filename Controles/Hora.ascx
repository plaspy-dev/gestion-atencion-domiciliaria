<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Hora.ascx.vb" Inherits="ML.Hora" %>
<div>
        <asp:TextBox ID="txtHora" runat="server" Width="53px" />
        <asp:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
            TargetControlID="txtHora" 
            Mask="99:99"
            MessageValidatorTip="true"
            MaskType="Time"
            ErrorTooltipEnabled="True" />
    <asp:Label ID="lblFormato" runat="server" SkinID="lblFormatoFecha">24h</asp:Label>
        <asp:MaskedEditValidator ID="MaskedEditValidator3" runat="server"
            ControlExtender="MaskedEditExtender3"
            ControlToValidate="txtHora"
            IsValidEmpty="True"
            EmptyValueMessage="Requerido"
            InvalidValueMessage="Hora inválida"
            Display="Dynamic"
            TooltipMessage="Digite la Hora"
            EmptyValueBlurredText="Requerido"
            InvalidValueBlurredMessage="Requerido"
            ValidationGroup="Guardar"/>
</div>
