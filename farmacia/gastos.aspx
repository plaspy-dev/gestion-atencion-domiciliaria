<%@ Page Title="Informe de gastos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="gastos.aspx.cs" Inherits="farmacia_gastos" %>
<%@ Register Src="~/paciente/pacienteSimple.ascx" TagName="pacienteSimple" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde<asp:RangeValidator ID="RangeValidator2" runat="server" Type="Date" ErrorMessage="Por favor ingrese una fecha valida." Text="*" MinimumValue="01/01/1900" MaximumValue="01/01/3000" SetFocusOnError="True" Display="Dynamic" ControlToValidate="TDesde">*</asp:RangeValidator></td>
            <td>Hasta<asp:RangeValidator ID="RangeValidator1" runat="server" 
                    ControlToValidate="THasta" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese una fecha valida." MaximumValue="01/01/3000" 
                    MinimumValue="01/01/1900" SetFocusOnError="True" Text="*" Type="Date">*</asp:RangeValidator></td>
            <td>Paciente<asp:RequiredFieldValidator ID="RPaciente" ControlToValidate="UCPaciente$TPacienteID" runat="server" ErrorMessage="Por favor ingrese un paciente" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox ID="TDesde" runat="server" CssClass="fecha" Text=""></asp:TextBox></td>
            <td><asp:TextBox ID="THasta" runat="server" CssClass="fecha" Text=""></asp:TextBox></td>
            <td><uc1:pacienteSimple runat="server" ID="UCPaciente" /></td>
            <td><asp:Button ID="BBuscar" runat="server" Text="Actualizar" onclick="BBuscar_Click" /></td>
        </tr>
    </table>
</asp:Panel>
<asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Visible="false"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron productos" 
        AllowSorting="True" ShowFooter="true"
        onrowdatabound="GResultados_RowDataBound" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:TemplateField HeaderText="Productos" FooterText="Total" SortExpression="producto" ItemStyle-Wrap="false">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="H" Text='<%# Eval("producto") %>' Target="_blank" NavigateUrl='<%# string.Format("~/farmacia/informes.aspx?f={0}&d={1}&m={2}&p={3}&r=1"
                        , HttpUtility.UrlEncode(TDesde.Text), HttpUtility.UrlEncode(THasta.Text), Eval("id"), UCPaciente.IdPaciente) %>'></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="Cantidad" DataField="total" SortExpression="total" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Costo" DataField="costo" SortExpression="costo" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" DataFormatString="{0:C0}" />
            <asp:BoundField HeaderText="Precio" DataField="valor" SortExpression="valor" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" DataFormatString="{0:C0}" />
            <asp:BoundField HeaderText="Utilidad" DataField="utilidad" SortExpression="utilidad" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" DataFormatString="{0:C0}" />
        </Columns>
    </asp:GridView>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id,consulta,producto,fecha,SUM(total) AS total,SUM(costo) AS costo,SUM(valor) AS valor,SUM(valor)-SUM(costo) AS utilidad FROM (
                    (
                        SELECT 2 AS consulta, salida_items{0}.producto AS id,salida{0}.fecha
                            ,medicamentos.nombre AS producto, salida_items{0}.cantidad AS total
                            ,salida_items{0}.cantidad*salida_items{0}.costo AS costo
                            ,salida_items{0}.cantidad*salida_items{0}.valor AS valor
                            FROM salida{0}
                            LEFT JOIN salida_items{0} ON (salida{0}.id=salida_items{0}.salida)
                            LEFT JOIN medicamentos ON (medicamentos.id=salida_items{0}.producto)
                        WHERE 
                        (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=salida{0}.fecha)
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=salida{0}.fecha)
                        AND (@paciente=0 OR salida{0}.paciente=@paciente)
                        ORDER BY id
                   ) UNION ALL (
                        SELECT 3 AS consulta, orden_compra_items{0}.producto AS id,orden_compra{0}.fecha
                            ,medicamentos.nombre AS producto, orden_compra_items{0}.cantidad AS total
                            ,orden_compra_items{0}.cantidad*orden_compra_items{0}.costo AS costo
                            ,orden_compra_items{0}.cantidad*orden_compra_items{0}.valor AS valor
                            FROM orden_compra{0}
                            LEFT JOIN orden_compra_items{0} ON (orden_compra{0}.id=orden_compra_items{0}.orden_compra)
                            LEFT JOIN medicamentos ON (medicamentos.id=orden_compra_items{0}.producto)
                        WHERE 
                        (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=orden_compra{0}.fecha)
                        AND orden_compra{0}.estado IS NULL
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=orden_compra{0}.fecha)
                        AND (@paciente=0 OR orden_compra{0}.paciente=@paciente)
                        ORDER BY id
                   ) UNION ALL (
                        SELECT 4 AS consulta, devolucion_items{0}.producto AS id,devolucion{0}.fecha
                            ,medicamentos.nombre AS producto, -devolucion_items{0}.cantidad AS total
                            ,-devolucion_items{0}.cantidad*devolucion_items{0}.costo AS costo
                            ,-devolucion_items{0}.cantidad*devolucion_items{0}.valor AS valor
                            FROM devolucion{0}
                            LEFT JOIN devolucion_items{0} ON (devolucion{0}.id=devolucion_items{0}.devolucion)
                            LEFT JOIN medicamentos ON (medicamentos.id=devolucion_items{0}.producto)
                        WHERE 
                        (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=devolucion{0}.fecha)
                        AND devolucion{0}.estado IS NULL
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=devolucion{0}.fecha)
                        AND (@paciente=0 OR devolucion{0}.paciente=@paciente)
                        ORDER BY id
                   )) AS t GROUP BY id ORDER BY producto
                        ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" PropertyName="Text" Name="desde" DefaultValue=" " />
                    <asp:ControlParameter ControlID="THasta" PropertyName="Text" Name="hasta" DefaultValue=" " />
                    <asp:ControlParameter ControlID="UCPaciente" PropertyName="IdPaciente" Name="paciente" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

