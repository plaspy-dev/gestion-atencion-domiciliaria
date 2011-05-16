<%@ Page Title="Consulta Mantenimiento" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="VehConMant.aspx.vb" Inherits="ML.VehConMant" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="autNumero,FechaIni,FechaFin" Titulos="Placa,Fecha Inicial,Fecha Final" Referencias="Vehiculos,," Expandido="true" />
    <ml:GridView ID="grvReg" runat="server" AutoGenerateColumns="False" 
        TotalPaginas="0">
        <Columns>
            <asp:BoundField DataField="regFecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="vehPlaca" HeaderText="Placa" />
            <asp:BoundField DataField="regKm" HeaderText="Km Recorridos" />
            <asp:BoundField DataField="regActividades" HeaderText="Actividades" />
            <asp:BoundField DataField="regObservaciones" HeaderText="Observaciones y/o servicios" />
            <asp:BoundField DataField="regRepuestos" HeaderText="Repuestos" />
            <asp:TemplateField HeaderText="Cambio aceite?">
                <ItemTemplate>
                    <ml:CheckBox ID="CheckBox1" runat="server" Checked='<% #Eval("cambioAceite")=1%>' Enabled="false" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
