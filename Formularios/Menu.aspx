<%@ Page Title="Menús" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="Menu.aspx.vb" Inherits="ML.Menu" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<div style="text-align:center">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:GridView ID="grvUsuarios" runat="server" AutoGenerateColumns="False" 
            EmptyDataText="No hay Menús" DataKeyNames="idMenu">
                <Columns>
                    <asp:BoundField DataField="descMenu" HeaderText="Menú" >
                    <ControlStyle  CssClass="textoEntrada" Width="100%"/>
                    </asp:BoundField >
                    <asp:CommandField EditText="Editar" HeaderText="Editar" ShowEditButton="True" 
                    CancelText="Cancelar" UpdateText="Guardar"/>
                    <asp:ButtonField AccessibleHeaderText="Per..." CommandName="PERMISOS" 
                    HeaderText="Permisos" Text="Permisos" />
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
</asp:Content>
