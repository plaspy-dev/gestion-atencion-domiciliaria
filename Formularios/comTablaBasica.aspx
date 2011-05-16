<%@ Page Title="Lugares de eventos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="comTablaBasica.aspx.vb" Inherits="ML.comTablaBasica" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table border="1">
    <tr>
        <th colspan="2" class="celdaTitulo">
            <asp:Label ID="lblTit" runat="server" Text="Nuevo Lugar de eventos" SkinID="lblsubTitulo"></asp:Label>
        </th>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label1" runat="server" Text="Descripción"></asp:Label>
        </td>
        <td>
            <ml:TextBox ID="txtDir" runat="server" MaxLength="50" 
                Width="159px" Requerido="true" ValidationGroup="Guardar"></ml:TextBox>
        </td>
    </tr>
    </table>
    <br />
    <asp:LinkButton ID="lnkNuevo" runat="server" Visible="false">Nuevo<br /></asp:LinkButton>
    <br />
    <ml:GridView ID="grv" runat="server" DataKeyNames="codigo" AutoGenerateColumns="false" EmptyDataText="No se han creado registros"> 
    <Columns>
    <asp:BoundField HeaderText="Descripcion" DataField="descripcion" />
    <asp:CommandField  HeaderText="Editar" SelectText="Editar" ShowSelectButton="true"/>
    <asp:CommandField  HeaderText="Eliminar" DeleteText="Elim" ShowDeleteButton="true"/>

    </Columns>
    </ml:GridView>
</asp:Content>
