<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="CargarArchivo.ascx.vb" Inherits="ML.CargarArchivo" %>
<asp:Panel ID="Panel1" runat="server" CssClass="modalPopup">
    <asp:Panel ID="pnlTitulo" runat="server" 
        Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;" 
        Height="16px">
                <div style="text-align:center">
                    Cargar Archivo</div>
            </asp:Panel>
        <asp:FileUpload ID="fupArchivo" runat="server" />
</asp:Panel>

