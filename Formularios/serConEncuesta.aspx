<%@ Page Title="Encuestas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serConEncuesta.aspx.vb" Inherits="ML.serConEncuesta" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:GridView ID="grvEnc" runat="server" AutoGenerateColumns="False" DataKeyNames="encId"
     EmptyDataText="No hay Encuestas Creadas"
       >
        <Columns>
            <asp:CommandField HeaderText="Editar" SelectText="Editar" 
                ShowSelectButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
            <asp:BoundField DataField="encId" HeaderText="Id Encuesta" 
                SortExpression="encId" />
            <asp:BoundField DataField="encNombre" HeaderText="Nombre" 
                SortExpression="encNombre" />
            <asp:CheckBoxField DataField="encActivo" HeaderText="Activo" 
                SortExpression="encActivo" />
        </Columns>
    </asp:GridView>
    
    <br />
</asp:Content>
