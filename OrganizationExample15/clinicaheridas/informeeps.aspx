<%@ Page Title="Informe EPS" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informeeps.aspx.cs" Inherits="clinicaheridas_informeeps" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/pacienteSimple.ascx" tagname="PacienteSimple" tagprefix="uc5" %>

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
            <td>Entidad</td>
            <td>Paciente</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox></td>
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
            <td><uc5:PacienteSimple runat="server" ID="UCPaciente" /></td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" DataKeyNames="id,paciente,evolucion"
                DataSourceID="SResultados">
            <Columns>
                <asp:TemplateField HeaderText="Fecha" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:HyperLink runat="server" ID="L" Text='<%# Eval("fecha") %>' Target="_blank" NavigateUrl='<%# 
                            string.Format(Eval("evolucion").ToString()=="1" 
                                            ?  "~/clinicaheridas/evolucion.aspx?pid={0}&ehid={1}" 
                                            : "~/clinicaheridas/valoracion.aspx?pid={0}&vhid={1}"
                                          , Eval("paciente"), Eval("id"))
                            %>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField HeaderText="Documento" DataField="pacDocumento" SortExpression="pacDocumento" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Paciente" DataField="pacNombres" SortExpression="pacNombres" />
                <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-Wrap="false"/>
                <asp:BoundField HeaderText="Funcionario" DataField="perNombre" SortExpression="perNombre" />
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
                        valoracion_herida.id,valoracion_herida.paciente,NULL AS evolucion
                        ,paciente.pacDocumento
                        ,paciente.pacNombres
                        ,valoracion_herida.fecha
                        ,recurso_humano.perNombre,asegurador.entNombre
                        FROM valoracion_herida
                        LEFT JOIN paciente ON (valoracion_herida.paciente=paciente.pacId)
                        LEFT JOIN recurso_humano ON (valoracion_herida.funcionario=recurso_humano.perId)
                        LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                        WHERE 
                            valoracion_herida.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') 
                            AND (@paciente=0 OR @paciente=valoracion_herida.paciente)
                            AND (@asegurador=0 OR @asegurador=paciente.entId)
                        ) UNION (
                            SELECT 
                                evolucion_herida.id,evolucion_herida.paciente,1 AS evolucion
                                ,paciente.pacDocumento
                                ,paciente.pacNombres
                                ,evolucion_herida.fecha
                                ,recurso_humano.perNombre,asegurador.entNombre
                                FROM evolucion_herida
                                LEFT JOIN paciente ON (evolucion_herida.paciente=paciente.pacId)
                                LEFT JOIN recurso_humano ON (evolucion_herida.funcionario=recurso_humano.perId)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                                WHERE 
                                    evolucion_herida.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') 
                                    AND (@paciente=0 OR @paciente=evolucion_herida.paciente)
                                    AND (@asegurador=0 OR @asegurador=paciente.entId)
                        )
                        ORDER BY fecha
                        ">
            <SelectParameters>
                <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                <asp:ControlParameter ControlID="DAsegurador" Name="asegurador" PropertyName="SelectedValue" />
                <asp:ControlParameter ControlID="UCPaciente$TPacienteID" Name="paciente" PropertyName="Text" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>

    <asp:Panel runat="server" ID="PP" Visible="false">
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <asp:Label runat="server" ID="TPaciente"></asp:Label>
        <asp:Label runat="server" ID="LPaciente"></asp:Label>
    </asp:Panel>
</asp:Content>

