<%@ Page Title="Informe" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informe.aspx.cs" Inherits="rh_informe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="P" DefaultButton="BActualizar">
<table class="table table-condensed">
    <tr>
        <td class="px">Estado</td>
        <td class="px">Documentos</td>
        <td></td>
    </tr>
    <tr>
        <td><asp:DropDownList ID="DEstado" runat="server" CssClass="amd" AppendDataBoundItems="true">
            <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>            
            <asp:ListItem Text="Activo" Value="1" Selected="True"></asp:ListItem>
            <asp:ListItem Text="Inactivo" Value="2"></asp:ListItem>
                </asp:DropDownList></td>
        <td>
            <asp:DropDownList ID="DDocumento" runat="server" CssClass="amd"
                DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                <asp:ListItem Text="Vencidos" Value="1"></asp:ListItem>
                <asp:ListItem Text="Sin vencer" Value="2"></asp:ListItem>
            </asp:DropDownList>
        </td>
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
                <asp:CheckBox runat="server" ID="C0" Enabled="false" Checked='<%# Eval("actadegrado").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Afiliación" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C1" Enabled="false" Checked='<%# Eval("afiliacion").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Capacitación BLS" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C2" Enabled="false" Checked='<%# Eval("capacitacionbls").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Diploma profesional" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C3" Enabled="false" Checked='<%# Eval("diplomaprofesional").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Fotocopia cédula ciudadanía" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C4" Enabled="false" Checked='<%# Eval("cedula").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Fotocopia Libreta militar" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C5" Enabled="false" Checked='<%# Eval("libreta").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Hoja de vida" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C6" Enabled="false" Checked='<%# Eval("hojavida").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Otros" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C7" Enabled="false" Checked='<%# Eval("otros").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Resolución" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C8" Enabled="false" Checked='<%# Eval("resolucion").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="RUT" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C9" Enabled="false" Checked='<%# Eval("rut").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Tarjeta profesional" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C10" Enabled="false" Checked='<%# Eval("tarjeta").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Vacunación" ItemStyle-CssClass="r">
            <ItemTemplate>
                <asp:CheckBox runat="server" ID="C11" Enabled="false" Checked='<%# Eval("vacunacion").ToString()=="1" %>' />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
    <asp:Label runat="server" ID="LTotal" CssClass="pull-right"></asp:Label>
<asp:SqlDataSource ID="SResultados" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
    SelectCommand="SELECT 
        rh.id, rh.documento, rh.apellidos, rh.nombres, rh.ingreso, rh.telefonos, rh.celular
        ,MAX(IF(doc.nombre='Acta de grado' AND rh_documento.archivo IS NOT NULL, 1,NULL)) actadegrado
        ,MAX(IF(doc.nombre='Afiliación' AND rh_documento.archivo IS NOT NULL, 1,NULL)) afiliacion
        ,MAX(IF(doc.nombre='Capacitación BLS' AND rh_documento.archivo IS NOT NULL, 1,NULL)) capacitacionbls
        ,MAX(IF(doc.nombre='Diploma profesional' AND rh_documento.archivo IS NOT NULL, 1,NULL)) diplomaprofesional
        ,MAX(IF(doc.nombre='Fotocopia cédula ciudadanía' AND rh_documento.archivo IS NOT NULL, 1,NULL)) cedula
        ,MAX(IF(doc.nombre='Fotocopia Libreta militar' AND rh_documento.archivo IS NOT NULL, 1,NULL)) libreta
        ,MAX(IF(doc.nombre='Hoja de vida' AND rh_documento.archivo IS NOT NULL, 1,NULL)) hojavida
        ,MAX(IF(doc.nombre='Otros' AND rh_documento.archivo IS NOT NULL, 1,NULL)) otros
        ,MAX(IF(doc.nombre='Resolución' AND rh_documento.archivo IS NOT NULL, 1,NULL)) resolucion
        ,MAX(IF(doc.nombre='RUT' AND rh_documento.archivo IS NOT NULL, 1,NULL)) rut
        ,MAX(IF(doc.nombre='Tarjeta profesional' AND rh_documento.archivo IS NOT NULL, 1,NULL)) tarjeta
        ,MAX(IF(doc.nombre='Vacunación' AND rh_documento.archivo IS NOT NULL, 1,NULL)) vacunacion
        FROM rh
        LEFT JOIN rh_documento ON (rh_documento.funcionario=rh.id)
        LEFT JOIN varios doc ON (doc.id=rh_documento.documento)
        WHERE
        (@estado=0 
            OR (@estado=1 AND rh.terminacion IS NULL)
            OR (@estado=2 AND rh.terminacion IS NOT NULL)
        )
        AND (@documento=0 
            OR (@documento=1 AND rh_documento.vencimiento<NOW()) 
            OR (@documento=2 AND rh_documento.vencimiento>NOW()))
        GROUP BY rh.id
        ORDER BY rh.apellidos,rh.nombres
    ">
        <SelectParameters>
            <asp:ControlParameter ControlID="DEstado" PropertyName="SelectedValue" Name="estado" />
            <asp:ControlParameter ControlID="DDocumento" PropertyName="SelectedValue" Name="documento" />
        </SelectParameters>
</asp:SqlDataSource>
</asp:Content>

