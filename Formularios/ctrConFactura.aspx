<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ctrConFactura.aspx.vb" Inherits="ML.ctrConFactura" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Expandido="true" Tipo="ML.ServiciosMedicos.ctrFactura" Campos="Nombre,facInicioPer,facFinPer,NumeroAut" Titulos="Digite Num. de identificación o cédula del pacente,Fecha Iniial,Fecha Final,Número Autorización"  />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        DataKeyNames="facId" AllowPaging="True" TotalPaginas="0">
                <Columns>
                    <asp:BoundField DataField="facFecha" HeaderText="Fecha Fac" 
                        SortExpression="facFecha" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="facNumero" HeaderText="Numero Fac" 
                        SortExpression="facNumero" />
                    <asp:BoundField DataField="facFechaRadicacion" HeaderText="Fecha Radicación" 
                        SortExpression="facFechaRadicacion" DataFormatString="{0:dd/MM/yyyy}"/>
                    <asp:BoundField DataField="facFechaAproxPago" HeaderText="Fecha Pago" 
                        SortExpression="facFechaAproxPago" DataFormatString="{0:dd/MM/yyyy}"/>
                    <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                        SortExpression="pacDocumento" />
                    <asp:BoundField DataField="Nombre" HeaderText="Nombre" 
                        SortExpression="Nombre" />
                    <asp:TemplateField HeaderText="Estado">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# iif(Eval("facEstado")="1","Anulada","") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField HeaderText="Ver" SelectText="Ver" ShowSelectButton="True" />
                    <asp:CommandField HeaderText="Elim" DeleteText="Elim" ShowDeleteButton="True" />
                    <asp:ButtonField CommandName="anular" HeaderText="Anular" Text="Anular"/>
                </Columns>
            </ml:GridView>
            <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
