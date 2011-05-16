<%@ Page Title="Disponibilidad" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ParAdmDisponib.aspx.vb" Inherits="ML.ParAdmDisponib" %>
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
            DataKeyNames="dispId">   
            <InsertItemTemplate>
                <asp:Label ID="Label1" runat="server" Text="Descripción:"></asp:Label>
                <asp:TextBox ID="cegDescripcionTextBox" runat="server" 
                    Text='<%# Bind("dispDescripcion") %>' />
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
            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="dispId" 
            DataSourceID="EntityDataSource1">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" 
                    DeleteText="Eliminar" EditText="Editar" CancelText="Cancelar    "  UpdateText="Guardar"/>
                <asp:BoundField DataField="dispId" HeaderText="Id" ReadOnly="True" 
                    SortExpression="dispId"/>
                <asp:BoundField DataField="dispDescripcion" HeaderText="Descripción" 
                    SortExpression="dispDescripcion" />
            </Columns>
        </asp:GridView>
        <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
            ConnectionString="name=ParametrizacionContainer" 
            DefaultContainerName="ParametrizacionContainer" EnableDelete="True" 
            EnableInsert="True" EnableUpdate="True" EntitySetName="admDisponibilidad">
        </asp:EntityDataSource>
                </ContentTemplate>
    </asp:UpdatePanel>

</div>
</asp:Content>
