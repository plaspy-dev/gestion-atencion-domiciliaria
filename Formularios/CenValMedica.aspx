<%@ Page Title="Censo Valoración Médica" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="CenValMedica.aspx.vb" Inherits="ML.CenValMedica" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.Censos.Censos" Campos="pacDocumento,entNombre" Titulos="Digite Nombre o Documento,Seleccione Asegurador" Referencias=",Asegurador" />
    <asp:GridView ID="grvCenso" runat="server" AutoGenerateColumns="False"  DataKeyNames="pacId"
        DataSourceID="ObjectDataSource1" AllowSorting="True" 
        EmptyDataText="No se encuentran Pacientes para este Censo" AllowPaging="True">
        <Columns>
            <asp:CommandField HeaderText="Ver" SelectText="Ver" ShowSelectButton="True" />
            <asp:BoundField DataField="tdocDescripcion" HeaderText="Tipo Doc" 
                SortExpression="tdocDescripcion" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                SortExpression="pacDocumento" />
            <asp:BoundField DataField="pacPNombre" HeaderText="Nombre" 
                SortExpression="pacPNombre" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" 
                SortExpression="entNombre" />
            <asp:BoundField DataField="pacDireccion" HeaderText="Direccion" 
                SortExpression="pacDireccion" />
            <asp:BoundField DataField="pacBarrio" HeaderText="Barrio" 
                SortExpression="pacBarrio" />
            <asp:BoundField DataField="pacTelefono" HeaderText="Telefono" 
                SortExpression="pacTelefono" />
            <asp:BoundField DataField="pacFecIngPrograma" HeaderText="Fec Ing Programa" 
                SortExpression="pacFecIngPrograma" />
            <asp:BoundField DataField="cirDescripcion" HeaderText="CIE10" 
                SortExpression="cirDescripcion" />
            <asp:BoundField DataField="cirDescripcion_1" HeaderText="CIE10_1" 
                SortExpression="cirDescripcion_1" />
        </Columns>
    </asp:GridView>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        TypeName="ML.Datos.Censos.Censos" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="ConsultarValMedica" SortParameterName="expresionOrden">
    </asp:ObjectDataSource>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
