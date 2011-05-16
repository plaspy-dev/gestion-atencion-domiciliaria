<%@ Page Title="CIE 10" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ParPHDManCIE10.aspx.vb" Inherits="ML.ParPHDManCIE10" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

    <table class="style1">
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Cod Dx"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtCodDx" runat="server" OrigenDatos="cieCodDx"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Descripción Dx"></asp:Label>
            </td>
            <td>
                <ml:TextBox ID="txtDesc" runat="server" Height="55px" MaxLength="255" 
                    TextMode="MultiLine" Width="272px" OrigenDatos="cirDescripcion"></ml:TextBox>
            </td>
        </tr>
    </table>
                </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
