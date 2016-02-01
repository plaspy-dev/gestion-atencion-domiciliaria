<%@ Control Language="C#" AutoEventWireup="true" CodeFile="paciente.ascx.cs" Inherits="usercontrol_paciente" %>
<asp:TextBox runat="server" data-type="search" ID="P"></asp:TextBox><asp:TextBox runat="server" ID="I" data-role="none" CssClass="hide"></asp:TextBox>
<ul runat="server" id="A" data-role="listview" style="position:absolute; z-index: 5; margin-top: -5px; left: 5px;" data-inset="true" data-filter="true"></ul>
<asp:HyperLink NavigateUrl="#PD" runat="server" ID="HP" Visible="false"></asp:HyperLink>
<asp:Panel runat="server" ID="PD" CssClass="hide" data-role="panel" data-position-fixed="true" data-display="overlay" data-theme="a" data-position="left" Visible="false">
    <a href="#" data-rel="close" id="closep" data-role="button" data-icon="delete" data-iconpos="notext" style="position:absolute; z-index: 5; right: 10px; top:5px;">Cerrar</a>
    <ul data-role="listview">
        <li>
            <h3><asp:Label runat="server" ID="LPaciente" Font-Bold="true"></asp:Label></h3>
            <p>
                <asp:Label runat="server" ID="LDocumento"></asp:Label><br />
                <asp:Label runat="server" ID="LAsegurador"></asp:Label><br />
                <asp:Label runat="server" ID="LPagoD"></asp:Label><br />
                <asp:Label runat="server" ID="LCarne"></asp:Label>
            </p>
        </li>
        <li>
            <p>
                <asp:Label runat="server" ID="LNacimiento"></asp:Label><br />
                <asp:Label runat="server" ID="LSexo"></asp:Label>
            </p>
        </li>
        <li>
            <p>
                <asp:Label runat="server" ID="LDireccion"></asp:Label><br />
                <asp:Label runat="server" ID="LBarrio"></asp:Label><br />
                <asp:Label runat="server" ID="LTelefono"></asp:Label><br />
                <asp:Label runat="server" ID="LCelular"></asp:Label>
            </p>
        </li>
        <li>
            <p>
                <asp:Label runat="server" ID="LFamiliar"></asp:Label><br />
                <asp:Label runat="server" ID="LParentesco"></asp:Label><br />
                <asp:Label runat="server" ID="LEstancia"></asp:Label>
            </p>
        </li>
        <li>
            <p><asp:Label runat="server" ID="LCIE10"></asp:Label></p>
        </li>
    </ul>
</asp:Panel>