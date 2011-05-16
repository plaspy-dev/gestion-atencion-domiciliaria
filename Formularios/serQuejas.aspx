<%@ Page Title="Quejas, Reclamos y Felicitaciones" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="serQuejas.aspx.vb" Inherits="ML.serQuejas" %>
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
<script runat="server">
    Private Function GetDetalle(ByVal det As String) As String
        If det.Length > 100 Then
            Return det.Substring(0, 100) + "..."
        End If
        Return det
    End Function
</script>
    <div style="width:100%; text-align:center">
        <asp:LinkButton ID="lnkNuevo" runat="server">Crear Nuevo Formulario de Queja y Reclamo</asp:LinkButton>
        <br />
        <br />        
        <uc3:Filtro ID="Filtro1" runat="server" tipo="ML.Datos.ServicioCliente.QuejasReclamos" campos="Nombre,perId,qrFecha,qrFechaFin,segUsuarioIngreso,qrCerrado" titulos="Digite Nombre o Identificación Paciente,Asegurador,Fecha Inicial,Fecha Final,Usuario Atiende,Mostrar Sólo los no cerrados" referencias=",Asegurador,,,," />
    <asp:GridView ID="grvQuejas" runat="server" AutoGenerateColumns="False"  EmptyDataText="No hay Resultados para Mostrar" 
        style="text-align: center" AllowSorting="true" AllowPaging="true" >
        <Columns>
            <asp:BoundField DataField="qrId" HeaderText="Id Formulario" />
            <asp:BoundField DataField="qrFecha" HeaderText="Fecha(d/m/a)" 
                SortExpression="qrFecha" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:TemplateField HeaderText="Tipo Cliente">
                <ItemTemplate >
                    <%#IIf(Eval("qrTipoCliente") = 1, "Externo", "Interno")%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento Persona que genera la queja" 
                SortExpression="pacDocumento" />               
            <asp:BoundField DataField="Nombre" HeaderText="Nombre Persona que genera la queja" 
                SortExpression="Nombre" />
            <asp:BoundField DataField="tqrDescripcion" HeaderText="Tipo" 
                SortExpression="tqrDescripcion" />
             <asp:BoundField DataField="perNombre" HeaderText="Persona(s) involucrada(s)" 
                SortExpression="perNombre" />
            <asp:BoundField DataField="qrPersonaLlama" HeaderText="Persona Llama" 
                SortExpression="qrPersonaLlama" />
            <asp:TemplateField HeaderText="Detalle" >
            <ItemStyle Width="300px" />
                <ItemTemplate>
                    <span title="<%#Eval("qrDetalle")%>"><%#GetDetalle(Eval("qrDetalle"))%></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" 
                SortExpression="entNombre" />
            <asp:BoundField DataField="segUsuarioIngreso" HeaderText="Usuario" 
                SortExpression="segUsuarioIngreso" />
            <asp:BoundField DataField="Atendido" HeaderText="Atendido" 
                SortExpression="Cerrado" />
            <asp:BoundField DataField="Cerrado" HeaderText="Cerrado" 
                SortExpression="Cerrado" />
            <asp:CommandField HeaderText="Ver" SelectText="Ver" ShowSelectButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
        </Columns>
    </asp:GridView>
    </div>
    </asp:Content>
