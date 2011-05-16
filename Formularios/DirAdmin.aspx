<%@ Page Title="Directorio Personal Administrativo" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="DirAdmin.aspx.vb" Inherits="ML.DirAdmin" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <div style="text-align:left">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.Administrativo.Directorio" Campos="perDocumento" Titulos="Digite Nombre o Documento de la persona a buscar" />
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        DataSourceID="ObjectDataSource1" 
        EmptyDataText="No hay Registros a mostrar" AllowSorting="True" 
        AllowPaging="True" PageSize="20">
        <Columns>
            <asp:BoundField DataField="PerDocumento" HeaderText="Documento" 
                SortExpression="perDocumento" />
            <asp:BoundField DataField="PerNombre" HeaderText="Nombre" 
                SortExpression="perNombre" />
            <asp:BoundField DataField="CarDescripcion" HeaderText="Cargo" 
                SortExpression="carDescripcion" />
            <asp:BoundField DataField="PerTelefono" HeaderText="Telefono" 
                SortExpression="perTelefono" />
            <asp:BoundField DataField="PerCelular" HeaderText="Celular" 
                SortExpression="perCelular" />
            <asp:BoundField DataField="PerTelefono1" HeaderText="Telefono1" 
                SortExpression="perTelefono1" />
            <asp:BoundField DataField="PerCorreoElectronico" 
                HeaderText="Correo Electrónico" SortExpression="perCorreoElectronico" />
            <asp:BoundField DataField="PerDireccion" HeaderText="Direccion" 
                SortExpression="perDireccion" />
            <asp:BoundField DataField="PerContacto" HeaderText="Persona Contacto" 
                SortExpression="PerContacto" />
            <asp:BoundField DataField="PerTelContacto" HeaderText="Tel Persona Contacto" 
                SortExpression="PerTelContacto" />
        </Columns>
    </asp:GridView>
    </div>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        SelectMethod="PersonalAdm" TypeName="ML.Datos.Administrativo.Directorio" 
        SortParameterName="expresionOrden">
    </asp:ObjectDataSource>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
