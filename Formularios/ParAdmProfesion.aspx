<%@ Page Title="Profesión" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ParAdmProfesion.aspx.vb" Inherits="ML.ParAdmProfesion" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<div >
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

<br />
        <asp:FormView ID="fvwInsertar" runat="server" Visible="False"
            DataSourceID="EntityDataSource1" GridLines="Both" Width="100%"
            DataKeyNames="profId">
            <InsertItemTemplate>
                <asp:Label ID="Label1" runat="server" Text="Nombre:"></asp:Label>
                <asp:TextBox ID="cegDescripcionTextBox" runat="server" 
                    Text='<%# Bind("profNombre") %>' />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="cegDescripcionTextBox" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                <br />
                <asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" 
                    CausesValidation="True" Text="Guardar"></asp:LinkButton>
                &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CommandName="Cancel" 
                    CausesValidation="False" Text="Cancelar"></asp:LinkButton>
            </InsertItemTemplate>
            <ItemTemplate>
                &nbsp;
            </ItemTemplate>
        </asp:FormView>
        <asp:GridView ID="grvSel" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="profId" 
            DataSourceID="EntityDataSource1">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" 
                    DeleteText="Eliminar" EditText="Editar" CancelText="Cancelar"  UpdateText="Guardar"/>
                <asp:BoundField DataField="profId" HeaderText="Id" ReadOnly="True" 
                    SortExpression="profId"/>
                <asp:BoundField DataField="profNombre" HeaderText="Nombre" 
                    SortExpression="profNombre" />
            </Columns>
        </asp:GridView>
        <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
            ConnectionString="name=ParametrizacionContainer" 
            DefaultContainerName="ParametrizacionContainer" EnableDelete="True" 
            EnableInsert="True" EnableUpdate="True" EntitySetName="admProfesion">
        </asp:EntityDataSource>
                </ContentTemplate>
    </asp:UpdatePanel>

</div>
</asp:Content>
