<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdRutaSanitaria.aspx.vb" Inherits="ML.phdRutaSanitaria" %>
<%@ Register src="../Controles/ConPacientes.ascx" tagname="ConPacientes" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:ConPacientes ID="ConPacientes1" runat="server" VerInactivos="true"/>
    <asp:Panel runat="server" ID="pnlPrg">
    <ml:GridView ID="grvProg" runat="server" AutoGenerateColumns="False" 
             AllowPaging="True" TotalPaginas="0" EmptyDataText="El paciente no tiene Programaciones registradas"
              DataKeyNames="rtsId">
            <Columns>
                <asp:TemplateField HeaderText="Id">
                <ItemTemplate>
                    <%#IIf(Eval("rtsId") = 0, "(Nuevo)", Eval("rtsId"))%>
                </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Fecha(ddmmyyyy)">
                <ItemTemplate>
                    <ml:TextBox runat="server" ID="txtf" MaxLength="8" Width="70px" Text='<%#iif(Eval("rtsFecha")=nothing,"",String.Format("{0:ddMMyyyy}",Eval("rtsFecha")))%>'></ml:TextBox>
                </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Placa">
                <ItemTemplate>
                    <uc2:DropDownListU ID="ddlPlaca" runat="server"/>
                </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Observaciones">
                <ItemTemplate>
                    <ml:TextBox runat="server" ID="txtObservaciones" MaxLength="100" 
                        TextMode="MultiLine" Text='<%#Bind("rtsObservaciones")%>' Height="43px" 
                        Width="214px"></ml:TextBox>
                </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Peso">
                <ItemTemplate>
                    <ml:TextBox runat="server" ID="txtPeso" MaxLength="10"
                         Text='<%#Bind("rtsPeso")%>'></ml:TextBox>
                </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ShowDeleteButton="true" DeleteText="Elim" HeaderText="Elim" />
            </Columns>
        </ml:GridView>
        </asp:Panel>
</asp:Content>
