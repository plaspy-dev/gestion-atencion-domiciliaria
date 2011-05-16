<%@ Page Title="Fechas de Corte" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="RHFechasCorte.aspx.vb" Inherits="ML.RHFechasCorte" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:Panel runat="server" ID="pnl">
    <table border="1" cellpadding="4">
        <tr>
            <th>
                Año</th>
            <td colspan="4">
                <uc1:DropDownListU ID="ddlAnio" runat="server" AutoPostBack="true" />
            </td>
        </tr>
        <tr>
            <th>
                Mes</th>
            <th colspan="2">
                Auxiliares(ddmmaaaa)</th>
            <th colspan="2">
                Terapeutas(ddmmaaaa)</th>
        </tr>
                <tr>
            <th>
                </th>
            <th>
                1</th>
            <th>
                2</th>
            <th>
                1</th>
            <th>
                2</th>
        </tr>
        <tr>
            <td>
                Enero</td>
            <td>
                <ml:TextBox ID="txtMes_1_1_1" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_1_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_1_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_1_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Febrero</td>
            <td>
                <ml:TextBox ID="txtMes_2_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_2_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_2_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_2_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Marzo</td>
            <td>
                <ml:TextBox ID="txtMes_3_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_3_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_3_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_3_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Abril</td>
            <td>
                <ml:TextBox ID="txtMes_4_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_4_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_4_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_4_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Mayo</td>
            <td>
                <ml:TextBox ID="txtMes_5_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_5_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_5_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_5_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Junio</td>
            <td>
                <ml:TextBox ID="txtMes_6_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_6_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_6_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_6_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Julio</td>
            <td>
                <ml:TextBox ID="txtMes_7_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_7_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_7_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_7_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Agosto</td>
            <td>
                <ml:TextBox ID="txtMes_8_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_8_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_8_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_8_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Septiembre</td>
            <td>
                <ml:TextBox ID="txtMes_9_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_9_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_9_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_9_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Octubre</td>
            <td>
                <ml:TextBox ID="txtMes_10_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_10_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_10_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_10_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Noviembre</td>
            <td>
                <ml:TextBox ID="txtMes_11_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_11_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_11_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_11_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Diciembre</td>
            <td>
                <ml:TextBox ID="txtMes_12_1_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_12_2_1" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_12_1_2" runat="server"  MaxLength="8" 
                    Width="60px"></ml:TextBox>
            </td>
            <td>
                <ml:TextBox ID="txtMes_12_2_2" runat="server"  MaxLength="8"  
                    Width="60px"></ml:TextBox>
            </td>
        </tr>
    </table>
    </asp:Panel>
</asp:Content>
