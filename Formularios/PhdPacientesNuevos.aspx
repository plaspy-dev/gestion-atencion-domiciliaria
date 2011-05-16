<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdPacientesNuevos.aspx.vb" Inherits="ML.PhdPacientesNuevos" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table border="1" style="width:300px;" >
    <tr>
        <td>
            Año
        </td>
        <td>
            
            <uc1:DropDownListU ID="ddlAnio" runat="server"  />
            
        </td>
    </tr>
    <tr>
        <td>
            Mes
        </td>
        <td>
            <uc1:DropDownListU ID="ddlMes" runat="server" />        
        </td>
    </tr>
        <tr>
        <td>
            Asegurador
        </td>
        <td>
            <uc1:DropDownListU ID="ddlAseg" runat="server" />        
        </td>
    </tr>
        <tr>
        <td>
            Tipo Actividad
        </td>
        <td>
            <uc1:DropDownListU ID="ddlTA" runat="server" />        
        </td>
    </tr>
    <tr><td colspan="2"><asp:ImageButton runat="server" ID="imbBuscar" 
            SkinID="imbBuscar" Height="19px" Width="16px" /></td></tr>
    </table>
     <asp:GridView ID="grvPac" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encuentran Pacientes">
        <Columns>
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" 
                SortExpression="pacDocumento" />
            <asp:BoundField DataField="pacNombres" HeaderText="Nombre" 
                SortExpression="pacNombres" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" 
                SortExpression="entNombre" />
            <asp:BoundField DataField="pacFecIngPrograma" HeaderText="Fec Ing Programa" 
                SortExpression="pacFecIngPrograma" />
            <asp:BoundField DataField="cirDescripcion" HeaderText="CIE10" 
                SortExpression="cirDescripcion" />
            <asp:CheckBoxField HeaderText="Curaciones" SortExpression="pacCuraciones" DataField="pacCuraciones"/>
            <asp:CheckBoxField HeaderText="Adm Puntual" DataField="pacAdmPuntual"/>
            <asp:CheckBoxField HeaderText="Ter Física" DataField="pacTerapiaFisica"/>
            <asp:CheckBoxField HeaderText="Ter Resp" DataField="pacTerapiaResp"/>
            <asp:CheckBoxField HeaderText="Ter Ocup" DataField="pacTerapiaOcup"/>
            <asp:CheckBoxField HeaderText="Ter Lenguaje" DataField="pacTerapiaLenguaje"/>
            <asp:CheckBoxField HeaderText="Val Nutricional" DataField="pacValNutricional"/>
            <asp:CheckBoxField HeaderText="Val Médica" DataField="pacValMedica"/>
            <asp:CheckBoxField HeaderText="Enf 12" DataField="pacEnfermeria_12"/>
            <asp:CheckBoxField HeaderText="Enf 24" DataField="pacEnfermeria_24"/>
            <asp:CheckBoxField HeaderText="Entrega Suministros" DataField="pacEntregaSuministros"/>
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
