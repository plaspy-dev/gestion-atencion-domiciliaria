<%@ Page Title="Liquidación" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="RHLiquidacion.aspx.vb" Inherits="ML.RHLiquidacion" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<%@ Register src="../Controles/admLiqAct.ascx" tagname="admLiqAct" tagprefix="uc1" %>
<%@ Register src="../Controles/admLiqGlosa.ascx" tagname="admLiqGlosa" tagprefix="uc2" %>
<%@ Register src="../Controles/admLiqAjuste.ascx" tagname="admLiqAjuste" tagprefix="uc3" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        .style2
        {
            width: 44px;
        }
         .style3
        {
            width: 100px;
        }
        .style4
        {
            width: 200px;
            text-align:right ;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<div class="style1" style="text-align:center">
<asp:LinkButton ID="lnkLiquidar" runat="server"  OnClientClick="if(!confirm('Confirma que desea Liquidar el último periodo?'))return false;">Liquidar último Periodo</asp:LinkButton>
</div>
<table class="style1"><tr><td >
    <asp:Label ID="Label4" runat="server" Text="Seleccione periodo"></asp:Label>
    <uc4:DropDownListU ID="ddlLiq" runat="server" AutoPostBack="True" />
</td>
<td class="style4">
    <asp:LinkButton ID="lnkReliq" runat="server"  OnClientClick="if(!confirm('Confirma que desea reliquidar este periodo?\nRecuerde que se perderán las glosas y ajustes realizados'))return false;">Reliquidar Periodo</asp:LinkButton>
</td>
</tr></table>
    &nbsp;
    <table class="style1" runat="server" id="tblLiq" visible="false">
        <tr>
            <td>
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                <asp:Label ID="Label5" runat="server" Text="Detalles de la liquidación"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
    <asp:GridView ID="grvLiq" runat="server" AllowPaging="True" 
        AutoGenerateColumns="False" DataKeyNames="perId" Width="100%">
        <Columns>
            <asp:TemplateField headertext="Liquidaciones">
                <ItemTemplate>
                <div class="divMargen">
                    <table class="style1">
                        <tr>
                            <td colspan="3">
                                <asp:Label ID="Label2" runat="server" Text='<%#bind("perNombre")%>'></asp:Label>
                            </td>                            
                        </tr>
                        <tr>
                            <td class="style3">
                                <%--<asp:TextBox ID="TextBox2" runat="server" ReadOnly="True" Width="240px" Text='<%#bind("perNombre")%>'></asp:TextBox>--%>
                                <asp:Label ID="Label3" runat="server" Text="Valor Total"></asp:Label>
                            </td>
                            <td>
                                <ml:TextBox ID="txtValor" runat="server" ReadOnly="True" Width="68px" Text='<%#bind("liqpValorTotal")%>'></ml:TextBox>
                            </td>
                            <td>
                                <asp:ImageButton ID="ImageButton2" runat="server" SkinID="imbBajar" CommandName="sel" CommandArgument='<%#bind("perId")%>' ToolTip="Mostrar"/>
                                <asp:ImageButton ID="ImageButton1" runat="server" SkinID="imbSubir" CommandName="nosel" CommandArgument='<%#bind("perId")%>' ToolTip="Ocultar" Visible="false"/>
                            </td>
                        </tr>
                    </table>
                    <table class="style1">
                    <tr>
                    <td class="style2"></td>
                    <td>
                         <uc1:admLiqAct ID="admLiqAct1" runat="server" Visible="false"/>
                                <uc2:admLiqGlosa ID="admLiqGlosa1" runat="server"  Visible="false" accion="accion"/>
                                <uc3:admLiqAjuste ID="admLiqAjuste1" runat="server"  Visible="false" accion="accion"/>
                    </td></tr>
                    </table>         
                    </div>                                         
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    
</asp:GridView>
            </td>
        </tr>
    </table>
</asp:Content>
