<%@ Page Title="Censo General" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="CenGeneral.aspx.vb" Inherits="ML.CenGeneral" %>
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
            <asp:BoundField DataField="pacEdad" HeaderText="Edad" 
                SortExpression="pacEdad" />
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
            <asp:BoundField DataField="pdirDescripcion" HeaderText="Pago Directo" 
                SortExpression="pdirDescripcion" />
            <asp:BoundField DataField="tipEDescripcion" HeaderText="Tipo Evento" 
                SortExpression="tipEDescripcion" />
            <asp:TemplateField HeaderText="Curaciones" SortExpression="pacCuraciones">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkCuraciones" Checked='<%#Bind("pacCuraciones") %>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Adm Puntual" 
                SortExpression="pacAdmPuntual" >
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkAdmPuntual" Checked='<%#Bind("pacAdmPuntual") %>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ter Física" 
                SortExpression="pacTerapiaFisica" >
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkTerapiaFisica" Checked='<%#Bind("pacTerapiaFisica") %>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ter Resp" 
                SortExpression="pacTerapiaResp" >
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkTerapiaResp" Checked='<%#Bind("pacTerapiaResp") %>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ter Ocup" 
                SortExpression="pacTerapiaOcup">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkTerapiaOcup" Checked='<%#Bind("pacTerapiaOcup") %>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ter Lenguaje" SortExpression="pacTerapiaLenguaje" >
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkTerapiaLenguaje" Checked='<%#Bind("pacTerapiaLenguaje") %>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Val Nutricional" 
                SortExpression="pacValNutricional">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkValNutricional" Checked='<%#Bind("pacValNutricional") %>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Val Médica" 
                SortExpression="pacValMedica" >
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkValMedica" Checked='<%#Bind("pacValMedica") %>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Enf 12" 
                SortExpression="pacEnfermeria_12" >
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkEnfermeria_12" Checked='<%#Bind("pacEnfermeria_12") %>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Enf 24" 
                SortExpression="pacEnfermeria_24" >
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkEnfermeria_24" Checked='<%#Bind("pacEnfermeria_24") %>' />
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Entrega Suministros" SortExpression="pacEntregaSuministros" >
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="chkEntregaSuministros" Checked='<%#Bind("pacEntregaSuministros") %>' />
            </ItemTemplate>
            </asp:TemplateField>            
        </Columns>
    </asp:GridView>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        TypeName="ML.Datos.Censos.Censos" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="ConsultarGral" SortParameterName="expresionOrden">
    </asp:ObjectDataSource>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
