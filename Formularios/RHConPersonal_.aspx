<%@ Page Title="Personal OrganizationExample15" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="RHConPersonal_.aspx.vb" Inherits="ML.RHConPersonal_" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">

    <uc1:Filtro ID="Filtro1" runat="server" tipo="ML.Datos.RRHH.Personal" Campos="perNombre,perActivo" Titulos="Digite Nombre o Identificación,Mostrar Inactivos" />

    <asp:GridView ID="grvPer" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="perId">
        <Columns>
            <asp:CommandField ShowSelectButton="True" SelectText="Editar" HeaderText="Editar" />
            <asp:CommandField ShowDeleteButton="True" DeleteText="Eliminar" HeaderText="Eliminar" />
            <asp:BoundField DataField="perId" HeaderText="Id" SortExpression="perId" />
            <asp:BoundField DataField="perDocumento" HeaderText="Documento" 
                SortExpression="perDocumento" />
            <asp:BoundField DataField="perNombre" HeaderText="Nombre" 
                SortExpression="perNombre" />
            <asp:BoundField DataField="perFechaIngreso" HeaderText="FechaIngreso" 
                SortExpression="perFechaIngreso" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="carId" HeaderText="carId" SortExpression="carId" />
            <asp:BoundField DataField="perTelefono" HeaderText="perTelefono" 
                SortExpression="perTelefono" />
            <asp:BoundField DataField="perDireccion" HeaderText="Direccion" 
                SortExpression="perDireccion" />
            <asp:CheckBoxField DataField="perActivo" HeaderText="Activo" 
                SortExpression="perActivo" />
        </Columns>
    </asp:GridView>
    
</asp:Content>
