<%@ Page Title="Tarifas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="CnvTarifas.aspx.vb" Inherits="ML.CnvTarifas" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
        ConnectionString="name=ConveniosEspeciales" 
        DefaultContainerName="ConveniosEspeciales" 
        EnableUpdate="True" EntitySetName="cnvTarifas">
    </asp:EntityDataSource>
            <br />
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="tarId" 
        DataSourceID="EntityDataSource1">
                <Columns>
                    <asp:CommandField ShowEditButton="True" EditText="Editar" />
                    <asp:BoundField DataField="tarId" HeaderText="Id" ReadOnly="True" 
                SortExpression="tarId" />
                    <asp:BoundField DataField="tarCodigo" HeaderText="tarCodigo" 
                SortExpression="tarCodigo" Visible="False" />
                    <asp:BoundField DataField="tarNombreServicio" HeaderText="Nombre Servicio" 
                SortExpression="tarNombreServicio" >
                    <ControlStyle CssClass="textoEntrada"  Width="100%"/>
                    </asp:BoundField>
                    <asp:BoundField DataField="tarTarifa" HeaderText="Tarifa" 
                SortExpression="tarTarifa" >
                    <ControlStyle CssClass="textoEntrada"  Width="100%"/>
                    </asp:BoundField>
                    <asp:BoundField DataField="tarTarifaEmermedica" 
                HeaderText="Tarifa Emermedica" SortExpression="tarTarifaEmermedica" >
                    <ControlStyle CssClass="textoEntrada"  Width="100%"/>
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
</asp:Content>
