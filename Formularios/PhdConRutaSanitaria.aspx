<%@ Page Title="Consulta de Programación Ruta Sanitaria" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdConRutaSanitaria.aspx.vb" Inherits="ML.PhdConRutaSanitaria" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>
<%@ Register src="../Controles/Novedad.ascx" tagname="Novedad" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="pacDocumento,FechaIni,FechaFin,entId,perNombre" Titulos="Digite Nombre o Documento Paciente,Fecha Inicial,Fecha Final,Asegurador,Placa" Referencias=",,,Asegurador," Expandido="true" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
    <ContentTemplate>
    
    <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        TotalPaginas="0">
        <Columns>
            <asp:BoundField DataField="rtsFecha" DataFormatString="{0:dd/MM/yyyy}" 
                HeaderText="Fecha" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" />
            <asp:BoundField DataField="pacNombres" HeaderText="Paciente" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" />
            <asp:BoundField DataField="vehPlaca" HeaderText="Placa" />
             <asp:TemplateField HeaderText="Direccion">
                <ItemTemplate>
                <div style="display:none;">
                <asp:Label runat="server" ID="lbld" Text='<%#Eval("pacDireccion")%>'></asp:Label>
                </div>
                    <a title="Haga click acá para ver la dirección en el mapa" target="_blank" href='https://service.example.invalid/mad/buscador.php?direccion=<%#Server.UrlEncode(Eval("pacDireccion"))%>'><%#Eval("pacDireccion")%>'</a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="pacBarrio" HeaderText="Barrio" />
            <asp:BoundField DataField="pacZona" HeaderText="Zona" />
            <asp:BoundField DataField="pacTelefono" HeaderText="Teléfono" />
            <asp:BoundField DataField="rtsObservaciones" HeaderText="Obs" />
            <asp:BoundField DataField="rtsPeso" HeaderText="Peso" />
            <asp:BoundField DataField="segUsuarioIngreso" HeaderText="Usuario" />
        </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
    
    <a href="javascript:imprimir('<%=UpdatePanel1.clientId %>')" class="link" >Imprimir Resultados</a>
</asp:Content>
