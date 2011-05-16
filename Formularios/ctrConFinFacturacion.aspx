<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ctrConFinFacturacion.aspx.vb" Inherits="ML.ctrConFinFacturacion" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Expandido="true" Tipo="ML.ServiciosMedicos.ctrFactura" Campos="anio,mes" Titulos="Año,Mes" Referencias="anio,mes"  />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" AllowPaging="False" AllowSorting="true">
                <Columns>
                    <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                        SortExpression="pacDocumento"/>
                    <asp:BoundField DataField="pacPNombre" HeaderText="Nombre" 
                        SortExpression="pacPNombre" />
                     <asp:CheckBoxField DataField="pacActivoR" HeaderText="Activo?" 
                        SortExpression="pacActivoR" />
                     <asp:BoundField DataField="pacFechaIngEgr" HeaderText="Fecha Egreso"  DataFormatString="{0:dd/MM/yyyy}"
                        SortExpression="pacFechaIngEgr" />
                    <asp:BoundField DataField="pacObsIngEgr" HeaderText="Causa" 
                        SortExpression="pacObsIngEgr" />
                </Columns>
            </ml:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
