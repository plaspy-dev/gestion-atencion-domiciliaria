<%@ Page Title="Informe formulación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informulacion.aspx.cs" Inherits="paciente_informulacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">.GridHeader th {width: auto !important;}</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Desde<asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
            <td>
                Hasta<asp:RequiredFieldValidator ControlToValidate="THasta" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Tipo</td>
            <td>Entidad</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox></td>
            <td><asp:DropDownList ID="DTipo" runat="server" DataSourceID="STipo" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="STipo" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=19 AND szReservado IS NULL ORDER BY nombre">
                    </asp:SqlDataSource></td>
            <td>
                <asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" 
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SResultados" onrowdatabound="GResultados_RowDataBound" >
            <Columns>
                <asp:BoundField DataField="fecha" SortExpression="Fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                <asp:BoundField DataField="tipo" SortExpression="tipo" HeaderText="Tipo" />
                <asp:BoundField DataField="paciente" HeaderText="Paciente" />
                <asp:BoundField DataField="documento" HeaderText="Documento" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Medicamento" DataField="medicamento" SortExpression="medicamento" />
                <asp:BoundField HeaderText="Cantidad" DataField="formulada" SortExpression="formulada" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Posología" DataField="posologia" SortExpression="posologia" />
                <asp:BoundField HeaderText="Vía" DataField="via" SortExpression="via" />
                <asp:BoundField HeaderText="Tiempo" DataField="tiempo" SortExpression="tiempo" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
        <asp:SqlDataSource ID="SResultados" runat="server" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            SelectCommand="SELECT formulacion.id,formulacion.fecha,formulacion.paciente,tipo.nombre AS tipo
                            ,NULL AS paciente
                            ,NULL AS documento
                            ,medicamento_formulacion.medicamento
                            ,medicamento_formulacion.formulada
                            ,medicamento_formulacion.posologia
                            ,medicamento_formulacion.via
                            ,medicamento_formulacion.tiempo
                            FROM formulacion
                            LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id)
                            LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento)
                            LEFT JOIN varios AS tipo ON (tipo.id=formulacion.tipo)
                            WHERE 
                            DATE(formulacion.fecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                            AND (@tipo=0 OR @tipo=formulacion.tipo)
                            AND (@asegurador=0 OR @asegurador=formulacion.asegurador)
                            ORDER BY fecha,paciente
                            ">
            <SelectParameters>
                <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                <asp:ControlParameter ControlID="DTipo" Name="tipo" PropertyName="SelectedValue" />
                <asp:ControlParameter ControlID="DAsegurador" Name="asegurador" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

