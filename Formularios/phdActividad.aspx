<%@ Page Title="Actividades" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdActividad.aspx.vb" Inherits="ML.phdActividad" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
        ConnectionString="name=OrganizationExample15_NEntities" 
        DefaultContainerName="OrganizationExample15_NEntities" EnableDelete="True" 
        EnableInsert="True" EnableUpdate="True" EntitySetName="phdTipoActividad">
    </asp:EntityDataSource>
    <asp:FormView ID="FormView1" runat="server" DataKeyNames="tpaId" 
        DataSourceID="EntityDataSource1">
        <EditItemTemplate>
            <asp:Label ID="Label1" runat="server" Text="Edición Tipo de Actividad:"></asp:Label><br />        
            Descripción:
            <asp:TextBox ID="tpaDescripcionTextBox" runat="server" 
                Text='<%# Bind("tpaDescripcion") %>' MaxLength="50" Width="180px" />
            <br />
            Tipo Servicio:
            <asp:DropDownList runat="server" id="ddlTipoSer">
                <asp:ListItem  Text="Servicio Médico" Value="1"/>
                <asp:ListItem  Text="Terapia" Value="2" />
                <asp:ListItem  Text="Médico Domiciliario" Value="3" />
            </asp:DropDownList>
            <br />
            Valor Unitario:
            <ml:TextBox ID="tpaValorUnitarioTextBox" runat="server" TipoTextBox="Float"
                Text='<%# Bind("tpaValorUnitario") %>' MaxLength="15"/>
            <br />
            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                CommandName="Update" Text="Guardar" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancelar" />
        </EditItemTemplate>
        <InsertItemTemplate>
            <asp:Label ID="Label1" runat="server" Text="Nuevo Tipo de Actividad:"></asp:Label><br />        
            Descripción:
            <asp:TextBox ID="tpaDescripcionTextBox" runat="server" 
                Text='<%# Bind("tpaDescripcion") %>' MaxLength="50" Width="180px" />
            <br />
            Tipo Servicio:
            <asp:DropDownList runat="server" id="ddlTipoSer" >
                <asp:ListItem  Text="Servicio Médico" Value="1"/>
                <asp:ListItem  Text="Terapia" Value="2"/>
                <asp:ListItem  Text="Médico Domiciliario" Value="3" />
            </asp:DropDownList>
            <br />
            Valor Unitario:
            <ml:TextBox ID="tpaValorUnitarioTextBox" runat="server" TipoTextBox="Float"
                Text='<%# Bind("tpaValorUnitario") %>' MaxLength="15"/>
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Guardar" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancelar" />
        </InsertItemTemplate>
        <ItemTemplate>
            <asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" 
                CommandName="New" Text="Nuevo Tipo de Actividad" />
        </ItemTemplate>
    </asp:FormView>
    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" 
        AutoGenerateColumns="False" DataKeyNames="tpaId,tpaTipoServicio" 
        DataSourceID="EntityDataSource1">
        <Columns>
            <asp:CommandField HeaderText="Sel" SelectText="Sel" ShowSelectButton="True" />
            <asp:CommandField EditText="Editar" ShowEditButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
            <asp:BoundField DataField="tpaId" HeaderText="Id" ReadOnly="True" 
                SortExpression="tpaId" />
            <asp:BoundField DataField="tpaDescripcion" HeaderText="Descripcion" 
                SortExpression="tpaDescripcion" >
                    <ControlStyle  CssClass="textoEntrada" Width="100%"/>
                    </asp:BoundField >

            <asp:TemplateField  HeaderText="Tipo Servicio">
            <ItemTemplate>
            <asp:Label runat="server" ID="lblTS" Text='<%#iif(Eval("tpaTipoServicio")=1,"Servicio Médico",iif(Eval("tpaTipoServicio")=2,"Terapia","Médico Domiciliario")) %>'></asp:Label>
            </ItemTemplate>
            </asp:TemplateField>           
            <asp:BoundField DataField="tpaValorUnitario" HeaderText="Valor Unitario" 
                SortExpression="tpaValorUnitario" >
                    <ControlStyle  CssClass="textoEntrada" Width="100%"/>
                    </asp:BoundField >
        </Columns>
    </asp:GridView>
    <asp:EntityDataSource ID="EntityDataSource2" runat="server" 
        ConnectionString="name=OrganizationExample15_NEntities" 
        DefaultContainerName="OrganizationExample15_NEntities" EnableDelete="True" 
        EnableInsert="True" EnableUpdate="True" EntitySetName="phdActividad" 
        EntityTypeFilter="phdActividad" Where="it.phdTipoActividad.tpaId=@Val">
        <WhereParameters>
            <asp:ControlParameter ControlID="GridView1" DefaultValue="0" Name="Val" PropertyName="SelectedValue" Type="Int32" />
        </WhereParameters>
    </asp:EntityDataSource>
    <br />
    <asp:FormView ID="FormView2" runat="server" DataKeyNames="actId" 
        DataSourceID="EntityDataSource2">
        <InsertItemTemplate>
            <asp:Label ID="Label1" runat="server" Text="Nueva Actividad:"></asp:Label><br />        
            Descripción:
            <asp:TextBox ID="actDescripcionTextBox" runat="server"  MaxLength="50"
                Text='<%# Bind("actDescripcion") %>' Width="180px" />
                <br />
            Valor Unitario:
            <ml:TextBox ID="actCantidadTextBox" runat="server" 
                Text='<%# Bind("actCantidad") %>' TipoTextBox="Entero" MaxLength="3" />
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Guardar" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancelar" />
        </InsertItemTemplate>
        <ItemTemplate>
            <asp:Label runat="server" Text="Lista de Actividades:"></asp:Label><br />
           <asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" 
                CommandName="New" Text="Nueva Actividad" />
        </ItemTemplate>
        <EmptyDataTemplate>
            <asp:Label ID="Label2" runat="server" Text="Lista de Actividades:"></asp:Label><br />
           <asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" 
                CommandName="New" Text="Nueva Actividad" />
        </EmptyDataTemplate>
    </asp:FormView>
    <asp:GridView ID="GridView2" runat="server" AllowSorting="True" 
        AutoGenerateColumns="False" DataKeyNames="actId" 
        DataSourceID="EntityDataSource2" EmptyDataText="No hay Actividades asociadas al tipo seleccionado">
        <Columns>
            <asp:CommandField EditText="Editar" ShowEditButton="True" UpdateText="Actualizar" CancelText="Cancelar" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
            <asp:BoundField DataField="actId" HeaderText="Id Act" ReadOnly="True" 
                SortExpression="actId" />
            <asp:BoundField DataField="actDescripcion" HeaderText="Descripcion" 
                SortExpression="actDescripcion" >                
                    <ControlStyle  CssClass="textoEntrada" Width="100%" />
                    </asp:BoundField >
            <asp:BoundField DataField="actCantidad" HeaderText="Val Unitario" 
                SortExpression="actCantidad" >
                    <ControlStyle  CssClass="textoEntrada" Width="100%"/>
                    </asp:BoundField >
        </Columns>
    </asp:GridView>
</asp:Content>
