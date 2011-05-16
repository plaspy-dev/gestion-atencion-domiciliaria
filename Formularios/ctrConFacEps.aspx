<%@ Page Title="Facturación por EPS" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ctrConFacEps.aspx.vb" Inherits="ML.ctrConFacEps" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Expandido="true" Tipo="ML.ServiciosMedicos.ctrFactura" Campos="anio,mes" Titulos="Año,Mes" Referencias="anio,mes"  />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        <br />
            Totales del mes:<br />
            <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" AllowPaging="False" AllowSorting="true">
                <Columns>
                    <asp:BoundField DataField="entNombre" HeaderText="Asegurador" 
                        SortExpression="entNombre"/>
                    <asp:BoundField DataField="totalBruto" HeaderText="Total Bruto" 
                        SortExpression="totalBruto" DataFormatString="$ {0:N}"/>
                    <asp:BoundField DataField="totalNeto" HeaderText="Total Neto" 
                        SortExpression="totalNeto" DataFormatString="$ {0:N}"/>
                </Columns>
            </ml:GridView>
            <asp:Label ID="lblTotales" runat="server" Text="Label"></asp:Label>
            <br />
            <br />
            Acumulado del año:<br />
            <ml:GridView ID="grvAcum" runat="server" AutoGenerateColumns="False" AllowPaging="False" AllowSorting="true">
                <Columns>
                    <asp:BoundField DataField="entNombre" HeaderText="Asegurador" 
                        SortExpression="entNombre"/>
                    <asp:BoundField DataField="totalBruto" HeaderText="Total Bruto" 
                        SortExpression="totalBruto" DataFormatString="$ {0:N}"/>
                    <asp:BoundField DataField="totalNeto" HeaderText="Total Neto" 
                        SortExpression="totalNeto" DataFormatString="$ {0:N}"/>
                </Columns>
            </ml:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
