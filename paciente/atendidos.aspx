<%@ Page Title="Pacientes atendidos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="atendidos.aspx.cs" Inherits="paciente_atendidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">.ancho { min-width: 400px; }</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde
                <asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Hasta
                <asp:RequiredFieldValidator ControlToValidate="THasta" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Entidad</td>
            <td>Nivel de atención</td>
            <td>Área encargada</td>
            <td>Estado</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox>
                </td>
            <td>
                <asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox>
            </td>
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
            <td><asp:DropDownList ID="DNivelAtencion" runat="server" DataSourceID="SNivelAtencion" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SNivelAtencion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=37 AND szReservado IS NULL">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList ID="DArea" runat="server" DataSourceID="SArea" 
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SArea" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT CAST(IFNULL(GROUP_CONCAT(medicamentos.id),-1) AS CHAR) AS id, varios.nombre FROM varios LEFT JOIN medicamentos ON (medicamentos.grupo=varios.id) WHERE varios.tipo=22 AND varios.szReservado IS NULL GROUP BY varios.id ORDER BY varios.nombre;">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:DropDownList ID="DEstado" runat="server">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Con seguimiento" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Sin seguimiento" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </td>
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
                <asp:BoundField DataField="fecha" SortExpression="fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                <asp:BoundField DataField="paciente"  HeaderText="Paciente" />
                <asp:BoundField DataField="paciente"  HeaderText="Documento" />
                <asp:BoundField DataField="paciente"  HeaderText="Sexo" />
                <asp:BoundField DataField="paciente"  HeaderText="Edad" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="paciente"  HeaderText="Dirección" />
                <asp:BoundField DataField="paciente"  HeaderText="Barrio" />
                <asp:BoundField DataField="paciente"  HeaderText="Teléfonos" />
                <asp:BoundField DataField="barthel" SortExpression="barthel" HeaderText="Índice de Barthel" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField DataField="paciente"  HeaderText="Diagnostico 1" />
                <asp:BoundField DataField="paciente"  HeaderText="Diagnostico 2" />
                <asp:BoundField DataField="paciente"  HeaderText="Diagnostico 3" />
                <asp:BoundField DataField="analisis" SortExpression="analisis" HeaderText="Análisis clínico" HeaderStyle-CssClass="ancho" />
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
            SelectCommand="(SELECT 
                                ingreso_paciente.fecha
                                ,ingreso_paciente.analisis
                                ,SUM(varios.descripcion) AS barthel
                                ,ingreso_paciente.paciente
                                FROM ingreso_paciente 
                                LEFT JOIN indice_barthel ON (indice_barthel.paciente=ingreso_paciente.paciente)
                                LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id)
                                LEFT JOIN varios ON (varios.id=analisis_barthel.resultado)
                                WHERE 
                                ingreso_paciente.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                                AND (@asegurador=0 OR @asegurador=ingreso_paciente.asegurador)
                                AND (@nivel_atencion=0 OR @nivel_atencion=ingreso_paciente.nivel_atencion)
                                AND (@area=0 OR @area=ingreso_paciente.area_atencion)
                                AND (@estado=0 
                                        OR (@estado=1 AND ingreso_paciente.seguimiento IS NOT NULL)
                                        OR (@estado=2 AND ingreso_paciente.seguimiento IS NULL)
                                    )
                                GROUP BY ingreso_paciente.id
                            ) UNION (
                            SELECT 
                                evolucion_paciente.fecha
                                ,evolucion_paciente.analisis
                                ,SUM(varios.descripcion) AS barthel
                                ,evolucion_paciente.paciente
                                FROM evolucion_paciente 
                                LEFT JOIN indice_barthel ON (indice_barthel.paciente=evolucion_paciente.paciente)
                                LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id)
                                LEFT JOIN varios ON (varios.id=analisis_barthel.resultado)
                                WHERE 
                                evolucion_paciente.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                                AND (@asegurador=0 OR @asegurador=evolucion_paciente.asegurador)
                                AND (@nivel_atencion=0 OR @nivel_atencion=evolucion_paciente.nivel_atencion)
                                AND (@area=0 OR @area=evolucion_paciente.area_atencion)
                                AND (@estado=0 
                                        OR (@estado=1 AND evolucion_paciente.seguimiento IS NOT NULL)
                                        OR (@estado=2 AND evolucion_paciente.seguimiento IS NULL)
                                    )
                                GROUP BY evolucion_paciente.id
                            ) ORDER BY fecha;
                            ">
            <SelectParameters>
                <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                <asp:ControlParameter ControlID="DAsegurador" Name="asegurador" PropertyName="SelectedValue" />
                <asp:ControlParameter ControlID="DNivelAtencion" Name="nivel_atencion" PropertyName="SelectedValue" />
                <asp:ControlParameter ControlID="DArea" Name="area" PropertyName="SelectedValue" />
                <asp:ControlParameter ControlID="DEstado" Name="estado" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

