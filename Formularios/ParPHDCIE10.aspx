<%@ Page Title="CIE 10" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ParPHDCIE10.aspx.vb" Inherits="ML.ParPhdCIE10" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Parametrizacion.phdCIE10" Campos="cieCodDx,cirDescripcion" Titulos="Código Dx,Descripción Dx" Expandido="true"/>
    <br />
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="cieCodDx" 
        DataSourceID="EntityDataSource1">
        <Columns>
            <asp:CommandField HeaderText="Editar"  SelectText="Editar"
                ShowSelectButton="True" />
            <asp:CommandField DeleteText="Eliminar" HeaderText="Eliminar" 
                ShowDeleteButton="True" />
            <asp:BoundField DataField="cieCodDx" HeaderText="Cod Dx" ReadOnly="True" 
                SortExpression="cieCodDx" />
            <asp:BoundField DataField="cirDescripcion" HeaderText="Descripción" 
                SortExpression="cirDescripcion" />
        </Columns>
    </asp:GridView>
    <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
        ConnectionString="name=ParametrizacionContainer" 
        DefaultContainerName="ParametrizacionContainer" EnableDelete="True" 
        EntitySetName="phdCIE10" EntityTypeFilter="" 
    Where="(@cod is null or it.cieCodDx=@cod) and (@desc is null or it.cirDescripcion like '%'+@desc+'%')">
        <WhereParameters>
            <asp:Parameter Name="cod" Type="String" />
            <asp:Parameter Name="desc"  Type="String"/>
        </WhereParameters>
    </asp:EntityDataSource>
                        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
