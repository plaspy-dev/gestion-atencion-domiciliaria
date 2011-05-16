<%@ Page Title="Pago Directo" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ParPHDPagoDir.aspx.vb" Inherits="ML.ParPHDPagoDir" %>
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
            DataKeyNames="pdirId">
            <InsertItemTemplate>
                <asp:Label ID="Label1" runat="server" Text="tipEDescripcion:"></asp:Label>
                
                <asp:TextBox ID="tipEDescripcionTextBox" runat="server" 
                    Text='<%# Bind("pdirDescripcion") %>' />
                <br />
                
                <asp:Label ID="Label2" runat="server" Text="tipEActivo:"></asp:Label>
                <asp:CheckBox ID="tipEActivoCheckBox" runat="server" 
                    Checked='<%# Bind("pdirActivo") %>' />
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
            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="pdirId" 
            DataSourceID="EntityDataSource1">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" EditText="Editar" DeleteText="Eliminar" UpdateText="Guardar"  CancelText="Cancelar"/>
                <asp:BoundField DataField="pdirId" HeaderText="Código" ReadOnly="True" 
                    SortExpression="pdirId"/>
                <asp:BoundField DataField="pdirDescripcion" HeaderText="Descripción" 
                    SortExpression="pdirDescripcion" />
                <asp:CheckBoxField DataField="pdirActivo" HeaderText="Activo?" 
                    SortExpression="pdirActivo" />
            </Columns>
        </asp:GridView>
        <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
            ConnectionString="name=ParametrizacionContainer" 
            DefaultContainerName="ParametrizacionContainer" EnableDelete="True" 
            EnableInsert="True" EnableUpdate="True" EntitySetName="phdPagoDirecto">
        </asp:EntityDataSource>
                        </ContentTemplate>
    </asp:UpdatePanel>

</div>
</asp:Content>
