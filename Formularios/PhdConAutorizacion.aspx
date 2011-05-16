<%@ Page Title="Consulta de Autorizaciones" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdConAutorizacion.aspx.vb" Inherits="ML.PhdConAutorizacion" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="autNumero,FechaIni,FechaFin,entId,tpaId" Titulos="Número Autorización,Fecha de Registro Inicial,Fecha de Registro Final,Asegurador,Tipo Actividad" Referencias=",,,Asegurador,prgTipo" Expandido="true" />
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
            <asp:TemplateField HeaderText="Inc"><ItemTemplate><%#Eval("autNumSesiones") - Eval("prgNumSesion")%></ItemTemplate></asp:TemplateField>
            <asp:BoundField DataField="autObservaciones" HeaderText="Obs"  SortExpression="autObservaciones"/>
            <asp:BoundField DataField="autValorCopago" HeaderText="Copago"  SortExpression="autValorCopago"/>
            <asp:BoundField DataField="autNroReciboCopago" HeaderText="Nro Recibo"  SortExpression="autNroReciboCopago"/>            
            <asp:BoundField DataField="segUsuarioIngreso" HeaderText="Usuario Registro"  SortExpression="segUsuarioIngreso"/>
            <asp:BoundField DataField="segFechaIngreso" HeaderText="Fecha Registro"  SortExpression="segFechaIngreso"/>
        </Columns>        
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
    <br />
    <br />
    <br />
    SA: Sesiones Autorizadas: <asp:Label ID="lblSA" runat="server" SkinID="lblFormatoFecha"></asp:Label>
    <br />
    SR: Sesiones Realizadas: <asp:Label ID="lblSR" runat="server" SkinID="lblFormatoFecha"></asp:Label>
    <br />
    INC: Sesiones Incumplidas: <asp:Label ID="lblInc" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
