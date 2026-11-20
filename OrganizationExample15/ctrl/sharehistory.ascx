<%@ Control Language="C#" AutoEventWireup="true" Inherits="ctrl_sharehistory" Codebehind="sharehistory.ascx.cs" %>
<asp:PlaceHolder runat="server" ID="P" Visible="false">
<script type="text/javascript">
    $(function () {
        addDialog("#sharedlgp", "#sharedlg", true, {
            buttons: {
                "Cerrar": function () {
                    $(this).dialog("close");
                }
            }
        }, true);
    });
</script>
<div id="sharedlgp">
<div id="sharedlg" class="hidet" title="Compartir Acceso">
    Código generado <b><%: Request.QueryString["code"] %></b><br/>
    <a href='<%: SDG.Componentes.Utilidades.GetURLFullPath(Page, "~/archivo/Historia/") + Request.QueryString["code"] %>'><%: SDG.Componentes.Utilidades.GetURLFullPath(Page, "~/archivo/Historia/") + Request.QueryString["code"] %></a><br />
    <br /><br />
    <asp:UpdatePanel runat="server" ID="U" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Panel runat="server" ID="PM" DefaultButton="BEnviar">
            <table>
                <tr>
                    <td colspan="2">

                    </td>
                </tr>
                <tr>
                    <td colspan="2">Enviar por correo electrónico<asp:RequiredFieldValidator ControlToValidate="TEmail" ErrorMessage="Por favor ingrese una dirección de correo." ID="RE" ValidationGroup="email"
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="R1" ControlToValidate="TEmail" ErrorMessage="Por favor ingrese una dirección de correo valida" Display="Dynamic" 
                            SetFocusOnError="true" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" runat="server" ValidationGroup="email">*</asp:RegularExpressionValidator></td>
                </tr>
                <tr>
                    <td><asp:TextBox runat="server" ID="TEmail"></asp:TextBox></td>
                    <td><asp:Button runat="server" ID="BEnviar" Text="Enviar" OnClick="BEnviar_Click" ValidationGroup="email" /></td>
                </tr>
            </table>
            </asp:Panel>
            <asp:Label runat="server" ID="LMessage" ForeColor="Red"></asp:Label>
            <asp:ValidationSummary runat="server" ID="V" ValidationGroup="email" />
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
</div>
</asp:PlaceHolder>