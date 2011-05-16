<%@ Page Title="Encuestas de satisfacción del usuario" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serConEncuestaSer.aspx.vb" Inherits="ML.serConEncuestaSer" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc2" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            text-align: center;
        }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <div style="width:100%; text-align:center">
        <br />
        <br />        
        <uc3:Filtro ID="Filtro1" runat="server" Expandido="true" tipo="ML.Datos.ServicioCliente.QuejasReclamos" campos="Nombre,perId,qrFecha,qrFechaFin" titulos="Digite Nombre o Identificación Paciente,Asegurador,Fecha Inicial,Fecha Final" referencias=",Asegurador,," />
    <asp:GridView ID="grvEnc" runat="server" AutoGenerateColumns="False"  EmptyDataText="No hay Resultados para Mostrar" 
        style="text-align: center" AllowPaging="true" AllowSorting="false" DataKeyNames="ensId" >
        <Columns>
            <asp:BoundField DataField="ensId" HeaderText="Id Encuesta" />
            <asp:BoundField DataField="ensFecha" HeaderText="Fecha(d/m/a)" 
                SortExpression="ensFecha" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                SortExpression="pacDocumento" />               
            <asp:BoundField DataField="Nombre" HeaderText="Nombre Paciente" 
                SortExpression="Nombre" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" 
                SortExpression="entNombre" />
            <asp:BoundField DataField="segUsuarioIngreso" HeaderText="Usuario" 
                SortExpression="segUsuarioIngreso" />
            <asp:BoundField DataField="segFechaIngreso" HeaderText="Fecha Registro" 
                SortExpression="segFechaIngreso" />
            <asp:CommandField HeaderText="Ver" SelectText="Ver" ShowSelectButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
        </Columns>
    </asp:GridView>
    <br />Encuestas Pendientes:<hr />
     <asp:GridView ID="grvPend" runat="server" AutoGenerateColumns="False"  EmptyDataText="No hay Encuestas pendientes" 
        style="text-align: center" AllowPaging="false" AllowSorting="false" DataKeyNames="ensId" >
        <Columns>
            <asp:BoundField DataField="ensId" HeaderText="Id Encuesta" />
            <asp:BoundField DataField="ensFecha" HeaderText="Fecha(d/m/a)" 
                SortExpression="ensFecha" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                SortExpression="pacDocumento" />               
            <asp:BoundField DataField="Nombre" HeaderText="Nombre Paciente" 
                SortExpression="Nombre" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" 
                SortExpression="entNombre" />
            <asp:BoundField DataField="segUsuarioIngreso" HeaderText="Usuario" 
                SortExpression="segUsuarioIngreso" />
            <asp:BoundField DataField="segFechaIngreso" HeaderText="Fecha Registro" 
                SortExpression="segFechaIngreso" />
                <asp:TemplateField HeaderText="Observaciones">
                    <ItemTemplate>
                        <textarea class="lblEnl" readonly="readonly" ><%#Eval("ensObsPendiente")%></textarea>
                    </ItemTemplate>
                </asp:TemplateField>
            <asp:CommandField HeaderText="Ver" SelectText="Ver" ShowSelectButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
        </Columns>
    </asp:GridView>
    </div>
    </asp:Content>
