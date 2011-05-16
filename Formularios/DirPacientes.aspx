<%@ Page Title="Directorio Pacientes" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="DirPacientes.aspx.vb" Inherits="ML.DirPacientes" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.Administrativo.Directorio" Campos="perDocumento" Titulos="Digite Nombre o Documento de la persona a buscar" />
    <asp:GridView ID="grvPac" runat="server" AutoGenerateColumns="False" 
        DataSourceID="ObjectDataSource1" AllowSorting="True" DataKeyNames="pacId" 
        EmptyDataText="No se encuentran Pacientes" AllowPaging="True">
        <Columns>
            <asp:CommandField HeaderText="Ver" SelectText="Ver" ShowSelectButton="True" />
            <asp:BoundField DataField="tdocDescripcion" HeaderText="Tipo Doc" 
                SortExpression="tdocDescripcion" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                SortExpression="pacDocumento" />
            <asp:BoundField DataField="pacPNombre" HeaderText="Nombre" 
                SortExpression="pacPNombre" />
            <asp:BoundField DataField="pacEdad" HeaderText="Edad" 
                SortExpression="pacEdad" />
            <asp:BoundField DataField="pacBarrio" HeaderText="Barrio" 
                SortExpression="pacBarrio" />
            <asp:BoundField DataField="pacTelefono" HeaderText="Tel" 
                SortExpression="pacTelefono" />
            <asp:CheckBoxField DataField="pacCuraciones" HeaderText="Curaciones" 
                SortExpression="pacCuraciones" />
            <asp:CheckBoxField DataField="pacAdmPuntual" HeaderText="Adm Puntual" 
                SortExpression="pacAdmPuntual" />
            <asp:CheckBoxField DataField="pacTerapiaFisica" HeaderText="Ter. Fisica" 
                SortExpression="pacTerapiaFisica" />
            <asp:CheckBoxField DataField="pacTerapiaResp" HeaderText="Ter. Resp" 
                SortExpression="pacTerapiaResp" />
            <asp:CheckBoxField DataField="pacTerapiaOcup" HeaderText="Ter. Ocup" 
                SortExpression="pacTerapiaOcup" />
            <asp:CheckBoxField DataField="pacTerapiaLenguaje" HeaderText="Ter. Lenguaje" 
                SortExpression="pacTerapiaLenguaje" />
            <asp:CheckBoxField DataField="pacValNutricional" 
                HeaderText="Val Nutricional" SortExpression="pacValNutricional" />
            <asp:CheckBoxField DataField="pacValMedica" HeaderText="Val Médica" 
                SortExpression="pacValMedica" />
            <asp:CheckBoxField DataField="pacEnfermeria_12" HeaderText="Enfer 12H" 
                SortExpression="pacEnfermeria_12" />
            <asp:CheckBoxField DataField="pacEnfermeria_24" HeaderText="Enfer 24h" 
                SortExpression="pacEnfermeria_24" />
        </Columns>
    </asp:GridView>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        SelectMethod="ConsultarDir" SortParameterName="expresionOrden" 
        TypeName="ML.Datos.PHD.Paciente">
        <SelectParameters>
            <asp:Parameter Name="expresionOrden" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>
