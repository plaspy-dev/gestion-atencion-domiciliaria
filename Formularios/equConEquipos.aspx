<%@ Page Title="Equipos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="equConEquipos.aspx.vb" Inherits="ML.equConEquipos" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<br />
    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="equId" 
        DataSourceID="EntityDataSource1" EmptyDataText="No hay Equipos Registrados">
        <Columns>
            <asp:CommandField HeaderText="Sel" SelectText="Sel" ShowSelectButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
            <asp:BoundField DataField="equId" HeaderText="Id" 
                SortExpression="equId" />
            <asp:BoundField DataField="equNombre" HeaderText="Nombre" 
                SortExpression="equNombre" />
            <asp:BoundField DataField="equSerial" HeaderText="Serial" 
                SortExpression="equSerial" />
            <asp:BoundField DataField="equPlaca" 
                HeaderText="Placa" SortExpression="equPlaca" />                
            <asp:BoundField DataField="equModelo" 
                HeaderText="Modelo" SortExpression="equModelo" />
            <asp:BoundField DataField="equMarca" 
                HeaderText="Marca" SortExpression="equMarca" />
            <asp:BoundField DataField="equFecUltMant" 
                HeaderText="Fec. Ult Mantenimiento" SortExpression="equFecUltMant" DataFormatString="{0:dd/MM/yyy}" />
            <asp:BoundField DataField="equFecProxMant" 
                HeaderText="Fec. Prox Mantenimiento" SortExpression="equFecProxMant"  DataFormatString="{0:dd/MM/yyy}"/>
            <asp:CheckBoxField DataField="equActivo" HeaderText="Activo?" SortExpression="equActivo"/>
        </Columns>
    </asp:GridView>
    <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
        ConnectionString="name=OrganizationExample15_NEntities" 
        DefaultContainerName="OrganizationExample15_NEntities" EnableDelete="True" 
        EntitySetName="equEquipo" EntityTypeFilter="" OrderBy="it.equNombre" 
        Select="">
    </asp:EntityDataSource>
</asp:Content>
