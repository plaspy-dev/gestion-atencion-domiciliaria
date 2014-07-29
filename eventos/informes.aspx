<%@ Page Title="Informes" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informes.aspx.cs" Inherits="eventos_informes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Desde</td>
            <td>
                <asp:TextBox ID="TDesde" CssClass="fecha" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TDesde" ID="RequiredFieldValidator1" Display="Dynamic" SetFocusOnError="true" runat="server" ErrorMessage="Por favor ingrese una fecha.">*</asp:RequiredFieldValidator>
                </td>
            <td>
                Hasta</td>
            <td>
                <asp:TextBox ID="THasta" CssClass="fecha" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TDesde" ID="RequiredFieldValidator2" Display="Dynamic" SetFocusOnError="true" runat="server" ErrorMessage="Por favor ingrese una fecha.">*</asp:RequiredFieldValidator>
            </td>
            <td>
                Evento</td>
            <td>
                    <asp:DropDownList ID="DEvento" runat="server" DataSourceID="SEvento" CssClass="anchomaxcombo"
                        DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                        <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SEvento" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT programacion_evento.id AS id
                                ,CONCAT(programacion_evento.nombre,'-',varios.nombre) AS nombre1
                                ,CAST(CONCAT(programacion_evento.nombre,' (', DATE_FORMAT(programacion_evento.inicio,'%d/%m/%Y'),'-',DATE_FORMAT(programacion_evento.fin,'%d/%m/%Y'), ')') AS CHAR) AS nombre
                                FROM programacion_evento 
                                LEFT JOIN varios ON (varios.id=programacion_evento.lugar)
                                WHERE inicio<=SYSDATE() AND DATE_ADD(fin,INTERVAL 60 DAY)>=SYSDATE() 
                                ORDER BY nombre,inicio,fin" >
                                <SelectParameters>
                                </SelectParameters>
                </asp:SqlDataSource></td>
            <td class="nw">
                <asp:CheckBox ID="CAmbulancia" runat="server" Text="Trasladados" />
            </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
        AllowPaging="True" PageSize="50" AllowSorting="true">
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField HeaderText="Fecha" DataField="fecha" DataFormatString="{0:d}" SortExpression="fecha" />
            <asp:BoundField HeaderText="Hora" DataField="hora" SortExpression="hora" />
            <asp:HyperLinkField DataTextField="nombres" HeaderText="Nombres" 
                DataNavigateUrlFields="documento" 
                DataNavigateUrlFormatString="~/eventos/pacientes.aspx?id={0}"  SortExpression="nombres">
            <ItemStyle Wrap="False" />
            </asp:HyperLinkField>
            <asp:HyperLinkField DataTextField="apellidos" HeaderText="Apellidos" DataNavigateUrlFields="documento" DataNavigateUrlFormatString="~/eventos/pacientes.aspx?id={0}" SortExpression="apellidos" />
            <asp:BoundField HeaderText="Edad" DataField="edad" SortExpression="edad">
                <ItemStyle HorizontalAlign="Right" />
            </asp:BoundField>
            <asp:HyperLinkField DataTextField="documento" HeaderText="Documento" 
                DataNavigateUrlFields="documento" 
                DataNavigateUrlFormatString="~/eventos/pacientes.aspx?id={0}" SortExpression="documento" >
            <ItemStyle HorizontalAlign="Right" />
            </asp:HyperLinkField>
            <asp:BoundField HeaderText="CIE10" DataField="cie10" SortExpression="CIE10" />
            <asp:BoundField HeaderText="Diagnostico" DataField="diagnostico" SortExpression="diagnostico" />
            <asp:BoundField HeaderText="Evento" DataField="evento" SortExpression="evento" />
            <asp:CheckBoxField HeaderText="Ambulancia" DataField="ambulancia" SortExpression="ambulancia" />
            <asp:CheckBoxField HeaderText="Remitido" DataField="remitido" SortExpression="remitido" />
            <asp:BoundField HeaderText="IPS remisión" DataField="ips" SortExpression="ips" />
        </Columns>
    </asp:GridView>
    <div style="text-align: right"><asp:Label runat="server" ID="LTotal"></asp:Label></div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT atencion_paciente.fecha, atencion_paciente.hora, atencion_paciente.diagnostico, atencion_paciente.ambulancia, atencion_paciente.remitido
                    , ips.nombre AS ips, paciente_evento.documento, paciente_evento.nombres, paciente_evento.apellidos, paciente_evento.edad, CONCAT(cie10.cieCodDx,'-',cie10.cirDescripcion) AS cie10
                    , programacion_evento.nombre AS evento
                    FROM paciente_evento 
                    LEFT JOIN atencion_paciente ON (atencion_paciente.paciente=paciente_evento.documento) 
                    LEFT JOIN varios AS ips ON (atencion_paciente.IPSremitida=ips.id) 
                    LEFT JOIN cie10 ON (cie10.cieCodDx=atencion_paciente.cie10)
                    LEFT JOIN programacion_evento ON (programacion_evento.id=atencion_paciente.evento)
                    WHERE (@ambulancia=0 OR atencion_paciente.ambulancia=@ambulancia) 
                    AND atencion_paciente.fecha>=STR_TO_DATE(@desde, '%d/%m/%Y') 
                    AND atencion_paciente.fecha<=STR_TO_DATE(@hasta, '%d/%m/%Y')
                    AND (@evento=0 OR atencion_paciente.evento=@evento)
                    ">
        <SelectParameters>
            <asp:ControlParameter ControlID="CAmbulancia" Name="ambulancia" DefaultValue="0" PropertyName="Checked" />
            <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
            <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
            <asp:ControlParameter ControlID="DEvento" Name="evento" PropertyName="SelectedValue" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

