<%@ Page Title="Tipos de Evento" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ParPHDTipoEvento.aspx.vb" Inherits="ML.ParPHDTipoEvento" %>
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
            DataKeyNames="tipECod">
            <InsertItemTemplate>
                <asp:Label ID="Label1" runat="server" Text="tipEDescripcion:"></asp:Label>
                
                <asp:TextBox ID="tipEDescripcionTextBox" runat="server" 
                    Text='<%# Bind("tipEDescripcion") %>' />
                <br />
                
                <asp:Label ID="Label2" runat="server" Text="tipEActivo:"></asp:Label>
                <asp:CheckBox ID="tipEActivoCheckBox" runat="server" 
                    Checked='<%# Bind("tipEActivo") %>' />
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
            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="tipECod" 
            DataSourceID="EntityDataSource1">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" EditText="Editar" DeleteText="Eliminar" UpdateText="Guardar"  CancelText="Cancelar"/>
                <asp:BoundField DataField="tipECod" HeaderText="Código" ReadOnly="True" 
                    SortExpression="tipECod"/>
                <asp:BoundField DataField="tipEDescripcion" HeaderText="Descripción" 
                    SortExpression="tipEDescripcion" />
                <asp:CheckBoxField DataField="tipEActivo" HeaderText="Activo?" 
                    SortExpression="tipEActivo" />
            </Columns>
        </asp:GridView>
        <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
            ConnectionString="name=ParametrizacionContainer" 
            DefaultContainerName="ParametrizacionContainer" EnableDelete="True" 
            EnableInsert="True" EnableUpdate="True" EntitySetName="phdTipoEvento">
        </asp:EntityDataSource>
                        </ContentTemplate>
    </asp:UpdatePanel>

</div>
</asp:Content>
