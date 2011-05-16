<%@ Page Title="Lugares de eventos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="evmLugar.aspx.vb" Inherits="ML.evmLugar" %>
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
            <asp:Label ID="Label1" runat="server" Text="Nombre"></asp:Label>
        </td>
        <td>
            <asp:Label ID="Label2" runat="server" Text="Dirección"></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <ml:TextBox ID="txtNom" runat="server" MaxLength="50" OrigenDatos="eluNombre" 
                Width="169px" Requerido="true" ValidationGroup="Guardar"></ml:TextBox>
        </td>
        <td>
            <ml:TextBox ID="txtDir" runat="server" MaxLength="50" 
                OrigenDatos="eluDireccion" Width="159px"></ml:TextBox>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label3" runat="server" Text="Encargado"></asp:Label>
        </td>
        <td>
            <asp:Label ID="Label4" runat="server" Text="Teléfono contacto"></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <ml:TextBox ID="txtEnc" runat="server" MaxLength="50" 
                OrigenDatos="eluEncargado" Height="16px" Width="169px"></ml:TextBox>
        </td>
        <td>
            <ml:TextBox ID="txtTel" runat="server" MaxLength="50" OrigenDatos="eluTelContacto"></ml:TextBox>
        </td>
    </tr>
    </table>
    <br />
    <asp:LinkButton ID="lnkNuevo" runat="server" Visible="false">Nuevo<br /></asp:LinkButton>
    <br />
    <ml:GridView ID="grv" runat="server" DataKeyNames="eluId" AutoGenerateColumns="false"> 
    <Columns>
    <asp:BoundField HeaderText="Nombre" DataField="eluNombre" />
    <asp:BoundField HeaderText="Dirección" DataField="eluDireccion" />
    <asp:BoundField HeaderText="Encargado" DataField="eluEncargado" />
    <asp:BoundField HeaderText="Teléfono contacto" DataField="eluTelContacto" />
    <asp:CommandField  HeaderText="Editar" SelectText="Editar" ShowSelectButton="true"/>
    <asp:CommandField  HeaderText="Eliminar" DeleteText="Elim" ShowDeleteButton="true"/>
    </Columns>
    </ml:GridView>
</asp:Content>
