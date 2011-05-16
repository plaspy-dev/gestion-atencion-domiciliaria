<%@ Page Title="Auditoria Autorizacion sin Programar" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AudConAutorizacion.aspx.vb" Inherits="ML.AudConAutorizacion" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="autNumero,FechaIni,FechaFin,entId,tpaId,prgActivo" Titulos="Número Autorización,Fecha de Registro Inicial,Fecha de Registro Final,Asegurador,Tipo Actividad,Ver solo las no iniciadas?" Referencias=",,,Asegurador,prgTipo," Expandido="true" />
    <ml:GridView ID="grvAut" runat="server" TotalPaginas="0" AutoGenerateColumns="false" AllowSorting="true">
        <Columns>
            <asp:BoundField DataField="autNumero" HeaderText="Autorizacion" SortExpression="autNumero" />
            <asp:BoundField DataField="FechaIni" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" SortExpression="FechaIni" />
            <asp:BoundField DataField="FechaFin" HeaderText="Vencimiento"  DataFormatString="{0:dd/MM/yyyy}" SortExpression="FechaFin"/>
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" SortExpression="pacDocumento" />
            <asp:BoundField DataField="PacNombre" HeaderText="Paciente" SortExpression="PacNombre" />
            <asp:BoundField DataField="PacBarrio" HeaderText="Barrio" SortExpression="PacBarrio" />
             <asp:TemplateField HeaderText="Direccion">
                <ItemTemplate>
                <div style="display:none;">
                <asp:Label runat="server" ID="lbld" Text='<%#Eval("pacDireccion")%>'></asp:Label>
                </div>
                    <a title="Haga click acá para ver la dirección en el mapa" target="_blank" href='https://service.example.invalid/mad/buscador.php?direccion=<%#Server.UrlEncode(Eval("pacDireccion"))%>'><%#Eval("pacDireccion")%>'</a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="actDescripcion" HeaderText="Actividad"  SortExpression="actDescripcion"/>
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador"  SortExpression="entNombre"/>
            <asp:BoundField DataField="autNumSesiones" HeaderText="SA"  SortExpression="autNumSesiones"/>
            <asp:BoundField DataField="prgNumSesion" HeaderText="SR"  SortExpression="prgNumSesion"/>
            <asp:BoundField DataField="segFechaIngreso" HeaderText="Fecha de Registro"  SortExpression="segFechaIngreso"/>            
        </Columns>        
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
    <br />
    <br />
    <br />
    SA: Sesiones Autorizadas
    <br />
    SR: Sesiones Realizadas
</asp:Content>
