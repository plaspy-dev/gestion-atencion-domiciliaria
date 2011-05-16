<%@ Page Title="Programacion rápida" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="PhdPrgRapida.aspx.vb" Inherits="ML.PhdPrgRapida" %>
<%@ Register src="../Controles/ConPacientesLightM.ascx" tagname="ConPacientesLightM" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:ConPacientesLightM ID="ConPacientesLightM1" runat="server" />
    <asp:Panel runat="server" ID="pnlPrg" Visible="false">
     <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0">
        <asp:TabPanel runat="server" HeaderText="TabPanel1" ID="TabPanel1">
            <HeaderTemplate>
                Programacion
            </HeaderTemplate>
            <ContentTemplate>
            <table >
            <tr>
                <td colspan="2">Tipo de servicio</td>
                    <uc2:DropDownListU ID="ddlTS" runat="server" AutoPostBack="true" />
                <td colspan="2"></td>
            </tr>
            <tr>
                <td>
                    año
                </td>
                <td>
                    <uc2:DropDownListU ID="ddlanio" runat="server" />
                </td>
                <td>
                    Mes
                </td>
                <td>
                    <uc2:DropDownListU ID="ddlMes" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    Actividad
                </td>
                <td colspan="2">
                <uc2:DropDownListU ID="ddlActiv" runat="server" />
                    </td>
                <td>
                    <asp:ImageButton ID="imbBuscar" runat="server" SkinID="lupa" />
                </td>
            </tr>
        </table>
        <br />
    <ml:GridView ID="grvPrg" runat="server" AutoGenerateColumns="False" DataKeyNames="prgId" 
                            TotalPaginas="0">
        <Columns>
            <asp:TemplateField HeaderText="Fecha(ddmmaaaa)">
                <ItemTemplate>
                    <ml:TextBox ID="txtFch" runat="server" MaxLength="8" Width="60px" Text='<%# String.format("{0:ddMMyyyy}",Eval("prgFechaProg"))%>'></ml:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Actividad">
                <ItemTemplate>
                    <uc2:DropDownListU ID="ddlAct" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Profesional">
                <ItemTemplate>
                    <uc2:DropDownListU  ID="ddlProf" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="NS">
                <ItemTemplate>
                <ml:TextBox ID="txtNS" runat="server" MaxLength="1" Width="20px" Text='<%#Bind("prgNumSesion")%>'></ml:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Autorizacion">
                <ItemTemplate>
                    <ml:TextBox ID="txtAut" runat="server" MaxLength="25" Width="80px" Text='<%#Bind("autNumero")%>'></ml:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Obs">
                <ItemTemplate>
                            <ml:TextBox ID="txtObs" runat="server" MaxLength="100" Text='<%#Bind("prgObservaciones")%>'></ml:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowDeleteButton="True" EditText="elim"/>
        </Columns>    
    </ml:GridView>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel ID="TabPanel2" runat="server" HeaderText="TabPanel2">
            <HeaderTemplate>
                Autorizaciones
            </HeaderTemplate>
            <ContentTemplate >     sadsds       
            </ContentTemplate>
        </asp:TabPanel>
     </asp:TabContainer>
       

    </asp:Panel>
    
</asp:Content>
