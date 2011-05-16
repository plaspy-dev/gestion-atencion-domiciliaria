<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="phdRestriccion.aspx.vb" Inherits="ML.phdRestriccion" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <table class="style1" border="1">
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Seleccione el asegurador"></asp:Label>
            </td>
            <td>
                <uc1:DropDownListU ID="ddlEPS" runat="server" AutoPostBack="True" />
            </td>
        </tr>
    </table>
    <asp:Panel runat="server" ID="pnlRestricciones" Visible="false">
        <table class="style1"  border="1">
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:LinkButton ID="lnkReset" runat="server" OnClientClick="if(!confirm('Confirma la eliminación de las restricciones de este asegurador?'))return false;">Eliminar todas las restricciones de este asegurador</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label2" runat="server" Text="Valor Total por Mes"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="Label3" runat="server" Text="Valor total por Dia"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <ml:TextBox ID="txtValMes" runat="server" MaxLength="10" TipoTextBox="Entero" 
                        ToolTip="Registre aquí el valor total los servicios contratados con la EPS por mes, recuerde que el valor límite para restringir programación de servicios depende del porcentaje definido en el campo &quot;porcentaje restricción&quot;" Width="111px"></ml:TextBox>
                </td>
                <td>
                    <ml:TextBox ID="txtValDia" runat="server" MaxLength="10" TipoTextBox="Entero" 
                        Width="111px"
                        ToolTip="Registre aquí el valor total los servicios contratados con la EPS por dia, recuerde que el valor límite para restringir programación de servicios depende del porcentaje definido en el campo &quot;porcentaje restricción&quot;"></ml:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label4" runat="server" Text="Valor total mensual por paciente"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="Label5" runat="server" Text="Valor total diario por paciente"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <ml:TextBox ID="txtValPacMes" runat="server" MaxLength="10" TipoTextBox="Entero" 
                        Width="111px"
                        ToolTip="Registre aquí el valor límite de los servicios contratados por paciente para esta EPS por mes, para la resticción se tomará este valor y se multiplicará por el número de pacientes activos del mes, el resultado será el 100%, recuerde que el valor límite para restringir programación de servicios depende del porcentaje definido en el campo &quot;porcentaje restricción&quot;"></ml:TextBox>
                </td>
                <td>
                    <ml:TextBox ID="txtValPacDia" runat="server" MaxLength="10" TipoTextBox="Entero" 
                        Width="111px"
                        ToolTip="Registre aquí el valor total los servicios contratados por paciente para esta EPS por dia,en este caso, los servicios de cada paciente no podrán sobrepasar este valor en un dia, recuerde que el valor límite para restringir programación de servicios depende del porcentaje definido en el campo &quot;porcentaje restricción&quot;"></ml:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label6" runat="server" Text="Porcentaje alarma"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="Label7" runat="server" Text="Porcentaje restricción"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: center">
                    <ml:TextBox ID="txtPorAlerta" runat="server" MaxLength="2" TipoTextBox="Entero" 
                        Width="28px"
                        Tooltip="a partir de este porcentaje se notificará la alerta del valor de programaciones, aplica por EPS y por paciente"></ml:TextBox>
                    <asp:Label ID="Label8" runat="server" Text="%"></asp:Label>
                </td>
                <td style="text-align: center">
                    <ml:TextBox ID="txtPorRestriccion" runat="server" MaxLength="2" TipoTextBox="Entero" 
                        Width="28px"
                        Tooltip="a partir de este porcentaje se restringirá la programación de cualquier servicio, aplica por EPS y por paciente"></ml:TextBox>
                    <asp:Label ID="Label9" runat="server" Text="%"></asp:Label>
                </td>
            </tr>
        </table>
        
        <ml:GridView ID="grvTpAct" runat="server" AutoGenerateColumns="False" 
            TotalPaginas="0" DataKeyNames="tpaId">
            <Columns>
                <asp:BoundField DataField="tpaDescripcion" HeaderText="Tipo Actividad" />
                <asp:TemplateField HeaderText="Cantidad máxima mensual">
                    <ItemTemplate>
                        <ml:TextBox ID="TextBox1" runat="server" MaxLength="10" TipoTextBox="Entero" Text='<%#bind("resCantTotalMes")%>'></ml:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Cantidad máxima diaria">
                    <ItemTemplate>
                        <ml:TextBox ID="TextBox2" runat="server" MaxLength="10" TipoTextBox="Entero" Text='<%#bind("resCantTotalDia")%>'></ml:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Cantidad máxima mensual por paciente">
                    <ItemTemplate>
                        <ml:TextBox ID="TextBox3" runat="server" MaxLength="3" TipoTextBox="Entero" 
                            Width="38px" Text='<%#bind("resCantXPacienteMes")%>'></ml:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Cantidad máxima diaria por paciente">
                    <ItemTemplate>
                        <ml:TextBox ID="TextBox4" runat="server" MaxLength="3" TipoTextBox="Entero" Width="38px" Text='<%#bind("resCantXPacienteDia")%>'></ml:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </ml:GridView>        
        
        <br />
        <ml:GridView ID="grvAct" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="actId" TotalPaginas="0">
            <Columns>
                <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
                <asp:TemplateField HeaderText="Cantidad máxima mensual">
                    <ItemTemplate>
                        <ml:TextBox ID="TextBox1" runat="server" MaxLength="10" TipoTextBox="Entero" Text='<%#bind("resCantTotalMes")%>'></ml:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Cantidad máxima diaria">
                    <ItemTemplate>
                        <ml:TextBox ID="TextBox2" runat="server" MaxLength="10" TipoTextBox="Entero" Text='<%#bind("resCantTotalDia")%>'></ml:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Cantidad máxima mensual por paciente">
                    <ItemTemplate>
                        <ml:TextBox ID="TextBox3" runat="server" MaxLength="3" TipoTextBox="Entero" 
                            Width="38px" Text='<%#bind("resCantXPacienteMes")%>'></ml:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Cantidad máxima diaria por paciente">
                    <ItemTemplate>
                        <ml:TextBox ID="TextBox4" runat="server" MaxLength="3" TipoTextBox="Entero" Width="38px" Text='<%#bind("resCantXPacienteDia")%>'></ml:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </ml:GridView>
        
        
    </asp:Panel>
</asp:Content>
