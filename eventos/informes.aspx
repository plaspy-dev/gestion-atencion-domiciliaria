<%@ Page Title="Informes" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informes.aspx.cs" Inherits="eventos_informes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= TEvento.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetEventos",
                    data: "{ 'q': '" + request.term + "' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.item, label: item.value
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            select: function(event, ui) {
                $('#<%= TEvento.ClientID %>').val(ui.item.label);
                $('#<%= TEventoID.ClientID %>').val(ui.item.value);
                return false;
            },
            search: function(event, ui) {
                $('#<%= TEventoID.ClientID %>').val("");
            }
        });
    });
</script>
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
                <asp:TextBox runat="server" ID="TEvento"></asp:TextBox>
                <asp:TextBox runat="server" ID="TEventoID" CssClass="hide"></asp:TextBox>
            </td>
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
            <asp:TemplateField HeaderText="Ambulancia" SortExpression="ambulancia">
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="C1" Enabled="false" Checked='<%# Eval("ambulancia").ToString()=="1" %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Remitido" SortExpression="remitido">
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="C1" Enabled="false" Checked='<%# Eval("remitido").ToString()=="1" %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="IPS remisión" DataField="ips" SortExpression="ips" />
        </Columns>
    </asp:GridView>
    <div style="text-align: right"><asp:Label runat="server" ID="LTotal"></asp:Label></div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT atencion_paciente.fecha, atencion_paciente.hora, atencion_paciente.diagnostico
                    , IF(atencion_paciente.ambulancia,'True', 'False') AS ambulancia, IF(atencion_paciente.remitido,'True', 'False') AS remitido
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
            <asp:ControlParameter ControlID="TEventoID" Name="evento" PropertyName="Text" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

