<%@ Page Title="Consulta Total Programación Apoyo Terapéutico" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AtxConProgramacionTl.aspx.vb" Inherits="ML.AtxConProgramacionTl" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>
<%@ Register src="../Controles/Novedad.ascx" tagname="Novedad" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="pacDocumento,FechaIni,FechaFin,entId,perNombre,actId" Titulos="Digite Nombre o Documento Paciente,Fecha Inicial,Fecha Final,Asegurador,Digite Nombre o Documento Profesional,Actividad" Referencias=",,,Asegurador,,ActividadTer" Expandido="true" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        TotalPaginas="0">
        <Columns>
            <asp:TemplateField HeaderText="Realizada">
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%#iif(Eval("prgActivo"),"SI","NO") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="prgFechaProg" DataFormatString="{0:dd/MM/yyyy}" 
                HeaderText="Fecha" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" />
            <asp:BoundField DataField="pacNombre" HeaderText="Paciente" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" />
            <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
            <asp:BoundField DataField="prgNumSesion" HeaderText="Num Sesiones" />
            <asp:BoundField DataField="perNombre" HeaderText="Profesional" />
            <asp:BoundField DataField="autNumero" HeaderText="Autorización" />
            <asp:BoundField DataField="cnoDescripcion" HeaderText="Motivo Cancelacion" />
            <asp:TemplateField HeaderText="Novedad">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkNovedad" runat="server" CommandName='Novedad' Text='Ver Novedades' CommandArgument='<%#bind("prgId")%>' Visible='<%#Bind("Novedad")%>' ></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </ml:GridView>
         <uc2:Novedad ID="Novedad1" runat="server" TipoServicio="Terapias" Editable="False" />
        <asp:HiddenField runat="server" ID="hddVerNov" Value="0" />

        </ContentTemplate>
    </asp:UpdatePanel>
        <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
        <script type="text/javascript">
            function valVerNov(ver) {
                document.getElementById('<%=hddVerNov.clientId %>').value = ver;
            }   
        </script>
</asp:Content>
