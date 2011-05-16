<%@ Page Title="Directorio Terapeutas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="DirTerapeutas.aspx.vb" Inherits="ML.DirTerapeutas" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<div style="text-align:center">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.Administrativo.Directorio" Campos="perDocumento" Titulos="Digite Nombre o Documento de la persona a buscar" />
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        DataSourceID="ObjectDataSource1" 
        EmptyDataText="No hay Registros a mostrar" AllowPaging="True" 
        AllowSorting="True">
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
            <asp:BoundField DataField="PerBarrio" HeaderText="Barrio" 
                SortExpression="perBarrio" />
            <asp:BoundField DataField="PerCorreoElectronico" 
                HeaderText="Correo Electrónico" SortExpression="perCorreoElectronico" />
            <asp:BoundField DataField="PerFechaIngreso" DataFormatString="{0:yyyy/MM/dd}" 
                HeaderText="Fecha Ingreso" SortExpression="perFechaIngreso" />
            <asp:BoundField DataField="PerDireccion" HeaderText="Direccion" 
                SortExpression="perDireccion" />
            <asp:BoundField DataField="ProgDescripcion" HeaderText="Programa" 
                SortExpression="progDescripcion" />
            <asp:BoundField DataField="perLocalidad" HeaderText="Localidad" 
                SortExpression="perLocalidad" />
        </Columns>
    </asp:GridView>
    </div>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        SelectMethod="Terapeutas" TypeName="ML.Datos.Administrativo.Directorio" 
        SortParameterName="expresionOrden">
    </asp:ObjectDataSource>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
