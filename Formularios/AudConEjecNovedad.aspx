<%@ Page Title="Auditoría Autorizado Vs Realizado" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AudConEjecNovedad.aspx.vb" Inherits="ML.AudConEjecNovedad" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<script runat="server">
    Protected Function GetPorcentaje(ByVal tot As Integer, ByVal dif As Integer) As String
        If tot = 0 Then Return "0"
        Return ((dif) / tot).ToString("P")
    End Function
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="FechaIni,FechaFin" Titulos="Fecha Inicial,Fecha Final" Expandido="true" />
    <table class="style1" cellpadding="2" cellspacing="2">
        <tr>
            <td class="celdaTitulo">
                <asp:Label ID="Label1" runat="server" SkinID="lblsubTitulo" Text="Consolidado Total"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
    <asp:GridView ID="grv1" runat="server" AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="autNumSesiones" HeaderText="Sesiones Autorizadas" />
            <asp:BoundField DataField="prgNumSesion" HeaderText="Sesiones Realizadas" />
            <asp:BoundField DataField="prgNumSesionN" HeaderText="Sesiones Canceladas por Novedad" />
            <asp:TemplateField HeaderText="Sesiones Incumplidas"><ItemTemplate><%#Eval("autNumSesiones") - Eval("prgNumSesion") - Eval("prgNumSesionN")%> </ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="Porcentaje Incumplimiento"><ItemTemplate>
            <%#
GetPorcentaje(Eval("autNumSesiones"), Eval("autNumSesiones") - Eval("prgNumSesion") - Eval("prgNumSesionN"))
            %> 
           </ItemTemplate></asp:TemplateField>
        </Columns>
    </asp:GridView>
            </td>
        </tr>
        <tr>
            <td class="celdaTitulo">
                <asp:Label ID="Label2" runat="server" SkinID="lblsubTitulo" Text="Consolidado por Actividad"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
    <asp:GridView ID="grv2" runat="server" AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
            <asp:BoundField DataField="autNumSesiones" HeaderText="Sesiones Autorizadas" />
            <asp:BoundField DataField="prgNumSesion" HeaderText="Sesiones Realizadas" />
            <asp:BoundField DataField="prgNumSesionN" HeaderText="Sesiones Canceladas por Novedad" />
            <asp:TemplateField HeaderText="Sesiones Incumplidas"><ItemTemplate><%#Eval("autNumSesiones") - Eval("prgNumSesion") - Eval("prgNumSesionN")%> </ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="Porcentaje Incumplimiento"><ItemTemplate>
            <%#
GetPorcentaje(Eval("autNumSesiones"), Eval("autNumSesiones") - Eval("prgNumSesion") - Eval("prgNumSesionN"))
            %> 
           </ItemTemplate></asp:TemplateField>

        </Columns>
    </asp:GridView>
            </td>
        </tr>
        <tr>
            <td class="celdaTitulo">
                <asp:Label ID="Label3" runat="server" SkinID="lblsubTitulo" Text="Consolidado por Asegurador"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
    <asp:GridView ID="grv3" runat="server" AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" />
            <asp:BoundField DataField="autNumSesiones" HeaderText="Sesiones Autorizadas" />
            <asp:BoundField DataField="prgNumSesion" HeaderText="Sesiones Realizadas" />
            <asp:BoundField DataField="prgNumSesionN" HeaderText="Sesiones Canceladas por Novedad" />
            <asp:TemplateField HeaderText="Sesiones Incumplidas"><ItemTemplate><%#Eval("autNumSesiones") - Eval("prgNumSesion") - Eval("prgNumSesionN")%> </ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="Porcentaje Incumplimiento"><ItemTemplate>
            <%#
GetPorcentaje(Eval("autNumSesiones"), Eval("autNumSesiones") - Eval("prgNumSesion") - Eval("prgNumSesionN"))
            %> 
           </ItemTemplate></asp:TemplateField>

        </Columns>
    </asp:GridView>
            </td>
        </tr>
    </table>
</asp:Content>
