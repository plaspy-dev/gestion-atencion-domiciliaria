<%@ Page Title="Ficha de Ingreso Pacientes" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdConPacientes.aspx.vb" Inherits="ML.phdConPacientes" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

    <uc1:Filtro ID="Filtro1" runat="server" tipo="ML.Datos.PHD.Paciente" Campos="pacPNombre,pacTerapiaFisica,pacEnfermeria,pacActivo" Titulos="Digite Nombre o Identificación,Terapias?,Enfermeria?,Mostrar Inactivos" />
    <asp:GridView ID="grvPac" runat="server" AutoGenerateColumns="False" 
         AllowSorting="True" DataKeyNames="pacId" 
        EmptyDataText="No se encuentran Pacientes" AllowPaging="True" >
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Image ID="Image3" runat="server" Height="57px" Width="65px" ImageUrl='<%#urlImg(eval("pacUrlFoto"))%>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField HeaderText="Editar" SelectText="Editar" ShowSelectButton="True" />
            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
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
            <asp:BoundField DataField="pacTelefono1" HeaderText="Tel2" 
                SortExpression="pacTelefono1" />
            <asp:BoundField DataField="pacCelular" HeaderText="Cel" 
                SortExpression="pacCelular" />
            <asp:CheckBoxField DataField="pacEntregasuministros" HeaderText="Suministros?" 
                SortExpression="pacEntregaSuministros" />
        </Columns>
    </asp:GridView>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        SelectMethod="Consultar" SortParameterName="expresionOrden" 
        TypeName="ML.Datos.PHD.Paciente" DeleteMethod="Eliminar">
        <DeleteParameters>
            <asp:Parameter Name="pacId" Type="Int32" />
        </DeleteParameters>
        <SelectParameters>
            <asp:Parameter Name="expresionOrden" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
                    </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
