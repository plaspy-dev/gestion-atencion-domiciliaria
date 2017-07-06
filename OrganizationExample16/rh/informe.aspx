<%@ Page Title="Informe" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informe.aspx.cs" Inherits="rh_informe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="P" DefaultButton="BActualizar">
<table class="table table-condensed">
    <tr>
        <td class="px">Estado</td>
        <td></td>
    </tr>
    <tr>
        <td><asp:DropDownList ID="DEstado" runat="server" CssClass="amd" AppendDataBoundItems="true">
            <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>            
            <asp:ListItem Text="Activo" Value="1" Selected="True"></asp:ListItem>
            <asp:ListItem Text="Inactivo" Value="2"></asp:ListItem>
                </asp:DropDownList></td>
        <td><asp:Button runat="server" ID="BActualizar" Text="Actualizar" CssClass="btn btn-submit" OnClick="BActualizar_Click" /></td>
    </tr>
</table>
</asp:Panel>
<asp:GridView ID="GResultados" runat="server" AutoGenerateColumns="False" DataSourceID="SResultados" EmptyDataText="No se encontraron " CssClass="table table-condensed table-bordered table-hover table-striped"
    PageSize="50" AllowPaging="true" AllowSorting="true">
    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
    <Columns>
        <asp:HyperLinkField DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/rh/funcionario.aspx?fid={0}" Target="_blank" DataTextField="documento" HeaderText="Documento" SortExpression="documento" ItemStyle-HorizontalAlign="Right" />
        <asp:BoundField DataField="apellidos" HeaderText="Apellidos" SortExpression="apellidos" />
        <asp:BoundField DataField="nombres" HeaderText="Nombres" SortExpression="nombres" />
        <asp:BoundField DataField="telefonos" HeaderText="Teléfonos" SortExpression="telefonos" />
        <asp:BoundField DataField="celular" HeaderText="Celular" SortExpression="celular" />
        <asp:BoundField DataField="ingreso" HeaderText="Ingreso" SortExpression="ingreso" DataFormatString="{0:d}" />
        <asp:TemplateField HeaderText="Acta de grado" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C0" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Acta de grado") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Afiliación" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C1" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Afiliación") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Capacitación BLS" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C2" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Capacitación BLS") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Diploma profesional" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C3" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Diploma profesional") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Fotocopia cédula ciudadanía" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C4" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Fotocopia cédula ciudadanía") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Fotocopia Libreta militar" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C5" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Fotocopia Libreta militar") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Hoja de vida" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C6" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Hoja de vida") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Otros" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C7" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Otros") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Resolución" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C8" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Resolución") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="RUT" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C9" Enabled="false" Checked='<%# HasDocument(Eval("id"), "RUT") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Tarjeta profesional" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C10" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Tarjeta profesional") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Vacunación" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C11" Enabled="false" Checked='<%# HasDocument(Eval("id"), "Vacunación") %>' />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
    <asp:Label runat="server" ID="LTotal" CssClass="pull-right"></asp:Label>
<asp:SqlDataSource ID="SResultados" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
    SelectCommand="SELECT 
        id, documento, apellidos, nombres, ingreso, telefonos, celular
        FROM rh
        WHERE
        (@estado=0 
            OR (@estado=1 AND rh.terminacion IS NULL)
            OR (@estado=2 AND rh.terminacion IS NOT NULL)
        )
        ORDER BY apellidos,nombres
    ">
        <SelectParameters>
            <asp:ControlParameter ControlID="DEstado" PropertyName="SelectedValue" Name="estado" />
        </SelectParameters>
</asp:SqlDataSource>
</asp:Content>

