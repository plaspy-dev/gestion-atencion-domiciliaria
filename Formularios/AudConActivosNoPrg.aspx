<%@ Page Title="Auditoría Pacientes activos sin programación" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AudConActivosNoPrg.aspx.vb" Inherits="ML.AudConActivosNoPrg" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.Paciente" Campos="entId" Titulos="Seleccione Asegurador" Referencias="Asegurador" />
    <asp:GridView ID="grvCenso" runat="server" AutoGenerateColumns="False"  DataKeyNames="pacId"
        EmptyDataText="No se encuentran Pacientes">
        <Columns>
            <asp:TemplateField HeaderText="sel">
            <HeaderTemplate>
                    <ml:CheckBox ID="chkHA" runat="server"/>Sel
                    </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="chkSel" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="tdocDescripcion" HeaderText="Tipo Doc" 
                SortExpression="tdocDescripcion" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                SortExpression="pacDocumento" />
            <asp:BoundField DataField="pacNombre" HeaderText="Nombre" 
                SortExpression="pacNombre" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" 
                SortExpression="entNombre" />
            <asp:BoundField DataField="pacEdad" HeaderText="Edad" 
                SortExpression="pacEdad" />
            <asp:BoundField DataField="pacDireccion" HeaderText="Direccion" 
                SortExpression="pacDireccion" />
            <asp:BoundField DataField="pacBarrio" HeaderText="Barrio" 
                SortExpression="pacBarrio" />
            <asp:BoundField DataField="pacTelefono" HeaderText="Telefono" 
                SortExpression="pacTelefono" />
            <asp:BoundField DataField="pacFecIngPrograma" HeaderText="Fec Ing Programa" 
                SortExpression="pacFecIngPrograma" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="cieCodDx_1" HeaderText="CIE10" 
                SortExpression="cieCodDx_1" />
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
    <br />
    <asp:LinkButton ID="lnkEgr" runat="server" OnClientClick="if(!confirm('Confirma el egreso de los pacientes seleccionados?'))return false;">Generar egreso a pacientes seleccionados</asp:LinkButton>
    <script type="text/javascript">
        function selAll(str, check) {
            var items = document.getElementsByTagName("input");
            for (var i = 0; i < items.length; i++) {
                if (items[i].id.endsWith(str)) {
                    items[i].checked = check;
                }
            }
        }
    </script>
</asp:Content>
