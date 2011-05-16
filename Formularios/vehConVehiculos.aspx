<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="vehConVehiculos.aspx.vb" Inherits="ML.vehConVehiculos" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<br />
    <asp:GridView ID="grvVeh" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="vehPlaca" 
        DataSourceID="EntityDataSource1" EmptyDataText="No hay Vehículos Registrados">
        <Columns>
            <asp:CommandField HeaderText="Sel" SelectText="Sel" ShowSelectButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
            <asp:BoundField DataField="vehPlaca" HeaderText="Placa" 
                SortExpression="vehPlaca" />
            <asp:BoundField DataField="vehFabricante" HeaderText="Fabricante" 
                SortExpression="vehFabricante" />
            <asp:BoundField DataField="vehModelo" HeaderText="Modelo" 
                SortExpression="vehModelo" />
                   <asp:CheckBoxField DataField="vehActivo" HeaderText="Activo?" 
                SortExpression="vehActivo" />
        </Columns>
    </asp:GridView>
        <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
        ConnectionString="name=OrganizationExample15_NEntities" 
        DefaultContainerName="OrganizationExample15_NEntities" EnableDelete="True" 
        EntitySetName="vehVehiculo">
    </asp:EntityDataSource>
 </asp:Content>
