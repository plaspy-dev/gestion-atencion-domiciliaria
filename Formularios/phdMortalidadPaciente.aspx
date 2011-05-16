<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdMortalidadPaciente.aspx.vb" Inherits="ML.phdMortalidadPaciente" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="pacDocumento,FechaIni,FechaFin" Titulos="Digite Nombre o Documento Paciente,Fecha Inicial,Fecha Final" Expandido="true" />

    <ml:GridView runat="server" ID="grvPac" EmptyDataText="No se encuentran registros" AutoGenerateColumns="false" DataKeyNames="pacId">
        <Columns>
            <asp:BoundField HeaderText="Documento" DataField="pacDocumento" />
            <asp:BoundField HeaderText="Paciente" DataField="pacNombre" />
            <asp:BoundField HeaderText="Fecha de defunción" DataFormatString="{0:dd/MM/yyyy}" DataField="FechaIni" />
            <asp:BoundField HeaderText="Fecha registro en sistema" DataField="FechaFin" />
            <asp:CommandField ShowSelectButton="true" SelectText="Ver Indicador(es)" />
            <asp:TemplateField HeaderText="Sel">
                <ItemTemplate>
                    <a href="phdImpIndMortalidad.aspx?i=<%#Eval("pacId") %>" target="_blank">Reporte</a>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </ml:GridView>
    <ml:GridView runat="server" ID="grvInd" EmptyDataText="No se encuentran registros" AutoGenerateColumns="false" DataKeyNames="actId">
        <Columns>
            <asp:BoundField HeaderText="Indicador" DataField="actDescripcion" />
            <asp:TemplateField HeaderText="Sel">
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="chkSel" Checked='<%#Eval("prgActivo") %>'/>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </ml:GridView>
    <br />
    <asp:LinkButton ID="lnkAceptar" runat="server" Visible="false">Aceptar</asp:LinkButton>
    <asp:LinkButton ID="lnkCancelar" runat="server" Visible="false">Cancelar</asp:LinkButton>
</asp:Content>
