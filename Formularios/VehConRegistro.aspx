<%@ Page Title="Consulta Kilometraje" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="VehConRegistro.aspx.vb" Inherits="ML.VehConRegistro" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="autNumero,FechaIni,FechaFin" Titulos="Placa,Fecha Inicial,Fecha Final" Referencias="Vehiculos,," Expandido="true" />
    <ml:GridView ID="grvReg" runat="server" AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="vehPlaca" HeaderText="Placa" />
            <asp:BoundField DataField="perNombre" HeaderText="Funcionario" />
            <asp:BoundField DataField="regValorFinal" HeaderText="Kilometros Recorrido" />
            <asp:BoundField DataField="regGasolina" HeaderText="Valor Gasolina tanqueada" />
        </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
</asp:Content>
