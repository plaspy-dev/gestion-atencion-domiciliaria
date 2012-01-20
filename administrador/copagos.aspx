<%@ Page Title="Copagos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="copagos.aspx.cs" Inherits="administrador_copagos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table style="width: 100%;">
        <tr>
            <td valign="top" colspan="2" class="celdaTitulo">
                <asp:Label ID="LCategoriaText" runat="server"></asp:Label>
                </td>
        </tr>
        <tr>
            <td valign="top">
                <asp:HiddenField runat="server" ID="HId" />
                <asp:ListBox ID="LCategoria" runat="server" DataSourceID="SCategoria" 
                    DataTextField="nombre" DataValueField="id" 
                    onselectedindexchanged="LCategoria_SelectedIndexChanged" 
                    AutoPostBack="True"></asp:ListBox>
                <asp:SqlDataSource ID="SCategoria" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id,nombre FROM varios WHERE tipo=13 AND szReservado IS NULL">
                </asp:SqlDataSource>
            </td>
            <td>
                <table style="width:100%;" align="right">
                    <tr>
                        <td>
                            Porcentaje del valor del servicio</td>
                        <td align="right">
                            <asp:TextBox ID="TPorcentaje" CssClass="float" Width="60" runat="server"></asp:TextBox>%
                        </td>
                        <td><asp:RequiredFieldValidator ControlToValidate="TPorcentaje" ErrorMessage="Por favor ingrese un porcentaje." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                            </td>
                    </tr>
                    <tr>
                        <td>
                            Valor tope máximo a cobrar por servicio año</td>
                        <td align="right">
                            $<asp:TextBox ID="TServicio" CssClass="dinero" Width="60" runat="server"></asp:TextBox>&nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:RequiredFieldValidator ControlToValidate="TServicio" ErrorMessage="Por favor ingrese un valor máximo por servicio." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    </tr>
                    <tr>
                        <td>
                            Valor tope máximo a cobrar por año</td>
                        <td align="right">
                            $<asp:TextBox ID="TTotal" CssClass="dinero" Width="60" runat="server"></asp:TextBox>&nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:RequiredFieldValidator ControlToValidate="TTotal" ErrorMessage="Por favor ingrese un valor máximo total." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                        <td align="right">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                            <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                                onclick="BAceptar_Click" />
                            <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                                CausesValidation="false" onclick="BCancelar_Click" />
                        </td>
                        <td>
                            &nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
        </table>
</asp:Content>

