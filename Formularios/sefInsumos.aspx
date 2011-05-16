<%@ Page Title="Insumos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="sefInsumos.aspx.vb" Inherits="ML.sefInsumos" %>
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
            DataKeyNames="insId">
            <InsertItemTemplate>
                <asp:Label ID="Label3" runat="server" Text="Nombre Insumo:"></asp:Label>
                
                <ml:TextBox ID="insDescripcionTextBox" runat="server" 
                    Text='<%# Bind("insDescripcion") %>' />
                <br />
                <asp:Label ID="Label4" runat="server" Text="Valor:"></asp:Label>                
                <ml:TextBox ID="insTarifaTextBox" runat="server" 
                    Text='<%# Bind("insTarifa") %>' TipoTextBox="Entero" />
                <br />
                <br />
                <asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" 
                    CausesValidation="True" Text="Guardar"></asp:LinkButton>
                &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CommandName="Cancel" 
                    CausesValidation="False" Text="Cancelar"></asp:LinkButton>
            </InsertItemTemplate>
            <ItemTemplate>
                <br />
            </ItemTemplate>
        </asp:FormView>
        <asp:GridView ID="grvSel" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="insId" PageSize="30"
            DataSourceID="EntityDataSource1">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" DeleteText="Eliminar" EditText="Editar" CancelText="Cancelar"  UpdateText="Guardar"/>
                <asp:BoundField DataField="insId" HeaderText="Id" ReadOnly="True" 
                    SortExpression="insId"/>
                <asp:BoundField DataField="insDescripcion" HeaderText="Nombre" 
                    SortExpression="insDescripcion" />
                <asp:BoundField DataField="insTarifa" HeaderText="Valor" 
                    SortExpression="insTarifa"   />
            </Columns>
        </asp:GridView>
        <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
            ConnectionString="name=ParametrizacionContainer" 
            DefaultContainerName="ParametrizacionContainer" EnableDelete="True" 
            EnableInsert="True" EnableUpdate="True" EntitySetName="sefInsumos">
        </asp:EntityDataSource>
                        </ContentTemplate>
    </asp:UpdatePanel>

</div>
</asp:Content>
