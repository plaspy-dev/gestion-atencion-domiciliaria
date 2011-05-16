<%@ Page Title="Entidades" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ParAdmEntidad.aspx.vb" Inherits="ML.ParAdmEntidad" %>
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
            DataKeyNames="entId">
            <InsertItemTemplate>
                <asp:Label ID="Label1" runat="server" Text="Descripción:"></asp:Label>
                <asp:TextBox ID="cegDescripcionTextBox" runat="server" MaxLength="50" Width="180px"
                    Text='<%# Bind("entNombre") %>' />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="cegDescripcionTextBox" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                    <br />
                <asp:CheckBox ID="TextBox1" runat="server" 
                     Checked='<%# Bind("entEPS") %>'  Text="EPS?"/>
                <asp:CheckBox ID="TextBox2" runat="server" 
                    Checked='<%# Bind("entAFP") %>' Text="AFP?"/>
                <asp:CheckBox ID="TextBox3" runat="server" 
                    Checked='<%# Bind("entARP") %>' Text="ARP?"/>
                    <br />
                    
                <asp:CheckBox ID="CheckBox1" runat="server" 
                    Checked='<%# Bind("entPrgNoAut") %>' Text="Permite Programar sin autorización?"/>
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
            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="entId" 
            DataSourceID="EntityDataSource1">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" 
                    DeleteText="Eliminar" EditText="Editar" CancelText="Cancelar"  UpdateText="Guardar"/>
                <asp:BoundField DataField="entId" HeaderText="Id" ReadOnly="True" 
                    SortExpression="entId"/>
                <asp:BoundField DataField="entNombre" HeaderText="Descripción" 
                    SortExpression="entNombre">
                <ControlStyle CssClass="textoEntrada"  Width="100%"/>
                </asp:BoundField>                    
                <asp:CheckBoxField DataField="entEPS" HeaderText="EPS?" SortExpression="entEPS"/>
                <asp:CheckBoxField DataField="entAFP" HeaderText="AFP?" SortExpression="entAFP"/>
                <asp:CheckBoxField DataField="entARP" HeaderText="ARP?" SortExpression="entARP"/>
                <asp:CheckBoxField DataField="entPrgNoAut" HeaderText="Permite Programar sin Autorización?" SortExpression="entPrgNoAut"/>
            </Columns>
        </asp:GridView>
        <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
            ConnectionString="name=ParametrizacionContainer" 
            DefaultContainerName="ParametrizacionContainer" EnableDelete="True" 
            EnableInsert="True" EnableUpdate="True" EntitySetName="admEntidad">
        </asp:EntityDataSource>
                </ContentTemplate>
    </asp:UpdatePanel>

</div>
</asp:Content>
