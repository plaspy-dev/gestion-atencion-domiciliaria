<%@ Page Title="Aseguradores" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="administrador_aseguradores" Codebehind="aseguradores.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:UpdatePanel runat="server" ID="PDatos" UpdateMode="Conditional">
<ContentTemplate>
    <asp:Panel ID="Panel1" runat="server" DefaultButton="BAceptar">
    <table style="width: 100%;">
        <tr>
            <td>
                <table style="width: 100%;">
        <tr>
            <td>
                Nombre</td>
            <td>
                <asp:TextBox runat="server" ID="TNombre"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ControlToValidate="TNombre" ErrorMessage="Por favor ingrese un nombre." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>Máximo por paciente</td>
            <td><asp:TextBox runat="server" ID="TMaximoPaciente" CssClass="dinero"></asp:TextBox>
            </td>
            <td>&nbsp;
            </td>
        </tr>
        <tr>
            <td>Máximo mensual</td>
            <td><asp:TextBox runat="server" ID="TMaximoMensual" CssClass="dinero"></asp:TextBox>
            </td>
            <td>&nbsp;
            </td>
        </tr>
        <tr>
            <td>&nbsp;
                </td>
            <td>
                <asp:CheckBox runat="server" ID="CEPS" Text="EPS" />
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>&nbsp;
                </td>
            <td>
                <asp:CheckBox runat="server" ID="CAFP" Text="AFP" />
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>&nbsp;
                </td>
            <td>
                <asp:CheckBox runat="server" ID="CARP" Text="ARP" />
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>&nbsp;
                </td>
            <td>
                <asp:CheckBox runat="server" ID="CProgramar" Text="Programar sin autorización" />
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                <asp:Button ID="BCancelar" runat="server" onclick="BCancelar_Click" Text="Cancelar" CausesValidation="False" />
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>
            </td>
        </tr>
        <tr>
            <td>
                <asp:GridView ID="GResultado" runat="server" AutoGenerateColumns="False" Width="100%"
                    DataKeyNames="id" DataSourceID="SqlDataSource2" 
                    onselectedindexchanged="GResultado_SelectedIndexChanged">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="S" CssClass="btn btn-success btn-xs" CausesValidation="False" CommandName="Select" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-CssClass="px">
	                    <ItemTemplate><asp:LinkButton runat="server" ID="D" CssClass="btn btn-danger btn-xs" CausesValidation="False" CommandName="Delete" ToolTip="Eliminar"><i class="fa fa-trash-o"></i></asp:LinkButton></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" ItemStyle-Width="100%" />
                    <asp:BoundField DataField="maximo_paciente" SortExpression="maximo_paciente" HeaderText="Máximo paciente" DataFormatString="{0:c}" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="maximo_mensual" SortExpression="maximo_mensual" HeaderText="Máximo mensual" DataFormatString="{0:c}" ItemStyle-HorizontalAlign="Right" />
                    <asp:CheckBoxField DataField="entEPS" SortExpression="entEPS" HeaderText="EPS" />
                    <asp:CheckBoxField DataField="entAFP" SortExpression="entAFP" HeaderText="AFP" />
                    <asp:CheckBoxField DataField="entARP" SortExpression="entARP" HeaderText="ARP" />
                    <asp:CheckBoxField DataField="entPrgNoAut" SortExpression="entPrgNoAut" HeaderText="Programar sin autorización" />
                </Columns>
                <SelectedRowStyle CssClass="selecteditem" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>"  
                SelectCommand="SELECT entId AS id,entNombre AS nombre,entEPS,entAFP,entARP,entPrgNoAut,maximo_mensual,maximo_paciente FROM asegurador ORDER BY nombre" 
                DeleteCommand="DELETE FROM asegurador WHERE entId=@id" >
            </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
        </tr>
    </table>
    </asp:Panel>
    </ContentTemplate></asp:UpdatePanel>
</asp:Content>