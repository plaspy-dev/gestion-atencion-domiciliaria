<%@ Page Title="Motivos Novedad" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ParPhdMotivoNovedad.aspx.vb" Inherits="ML.ParPhdMotivoNovedad" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
        ConnectionString="name=OrganizationExample15_NEntities" 
        DefaultContainerName="OrganizationExample15_NEntities" EnableDelete="True" 
        EnableInsert="True" EnableUpdate="True" EntitySetName="phdCausaNovedad">
    </asp:EntityDataSource>
    <asp:FormView ID="FormView1" runat="server" DataKeyNames="cnoId" 
        DataSourceID="EntityDataSource1">
        <EditItemTemplate>
            <asp:Label ID="Label1" runat="server" Text="Edición Motivo de Novedad:"></asp:Label><br />        
            Descripción:
            <asp:TextBox ID="tpaDescripcionTextBox" runat="server" 
                Text='<%# Bind("cnoDescripcion") %>' MaxLength="50" Width="180px" />
            <br />
            Tipo Novedad:
            <asp:DropDownList runat="server" id="ddlTipoNov">
                <asp:ListItem  Text="Cancelación" Value="1"/>
                <asp:ListItem  Text="Reasignación" Value="2"/>
            </asp:DropDownList>
            <br />
            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                CommandName="Update" Text="Guardar" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancelar" />
        </EditItemTemplate>
        <InsertItemTemplate>
            <asp:Label ID="Label1" runat="server" Text="Nuevo Motivo de Novedad:"></asp:Label><br />        
            Descripción:
            <asp:TextBox ID="tpaDescripcionTextBox" runat="server" 
                Text='<%# Bind("cnoDescripcion") %>' MaxLength="50" Width="180px" />
            <br />
            Tipo Novedad:
            <asp:DropDownList runat="server" id="ddlTipoNov">
                <asp:ListItem  Text="Cancelación" Value="1"/>
                <asp:ListItem  Text="Reasignación" Value="2"/>
            </asp:DropDownList>
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Guardar" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancelar" />
        </InsertItemTemplate>
        <ItemTemplate>
            <asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" 
                CommandName="New" Text="Nuevo Motivo de Novedad" />
        </ItemTemplate>
    </asp:FormView>
    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" 
        AutoGenerateColumns="False" DataKeyNames="cnoId,cnoTipoNovedad" 
        DataSourceID="EntityDataSource1">
        <Columns>
            <asp:CommandField EditText="Editar" ShowEditButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
            <asp:BoundField DataField="cnoId" HeaderText="Id" ReadOnly="True" 
                SortExpression="cnoId" />
            <asp:BoundField DataField="cnoDescripcion" HeaderText="Descripcion" 
                SortExpression="cnoDescripcion" >
                    <ControlStyle  CssClass="textoEntrada" Width="100%"/>
                    </asp:BoundField >
            <asp:TemplateField  HeaderText="">
            <ItemTemplate>
            <asp:Label runat="server" ID="lblTN" Text='<%#iif(Eval("cnoTipoNovedad")=1,"Cancelación","Reasignación") %>'></asp:Label>
            </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    
</asp:Content>
