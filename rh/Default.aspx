<%@ Page Title="Personal" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="rh_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    function pad(number, length) {
        var str = number;
        while (str.length < length) {
            str = ' ' + str;
        }
        return str;
    }
    $(function() {
        var dates = $("#<%= TInicio.ClientID %>, #<%= TFin.ClientID %>").datepicker({
            onSelect: function(selectedDate) {
                var option = this.id == "<%= TInicio.ClientID %>" ? "minDate" : "maxDate",
					        instance = $(this).data("datepicker"),
					        date = $.datepicker.parseDate(
						        instance.settings.dateFormat ||
						        $.datepicker._defaults.dateFormat,
						        selectedDate, instance.settings);
                dates.not(this).datepicker("option", option, date);
            }
        });
        $("#<%=  CRetiro.ClientID %>").change(function() {
            $("#<%= DRetiro.ClientID %>").toggle();
            $("#<%=  DRetiro.ClientID %>").val("0");
        });
        if (!$("#<%=  CRetiro.ClientID %>").is(':checked'))
            $("#<%=  CRetiro.ClientID %>").change();

        $("#<%= TNombres.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPersonal",
                    data: "{ 'q': '" + request.term + "' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
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

                $.goURL("fid=" + ui.item.value);
                return false;
            }
        });
    }
    );
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Estado</td>
            <td>
                <asp:DropDownList ID="DEStado" runat="server" AppendDataBoundItems="true" CssClass="anchomaxcombo"
                    DataSourceID="SEstado" DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstado" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT eEstId AS id,eEstDesc AS nombre FROM funcionario_estados">
                </asp:SqlDataSource>
            </td>
            <td>
                Nombres</td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
            </td>
            <td>
                Cargo</td>
            <td>
                <asp:DropDownList ID="DCargo" runat="server" AppendDataBoundItems="true"  CssClass="anchomaxcombo"
                    DataSourceID="SCargo" DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SCargo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT carId AS id,carDescripcion AS nombre FROM cargo ORDER BY nombre">
                </asp:SqlDataSource>
            </td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Inicio</td>
            <td>
                <asp:TextBox ID="TInicio" runat="server" CssClass="fecha" Text=""></asp:TextBox>
                <asp:RangeValidator ID="RangeValidator1" runat="server" Type="Date" ErrorMessage="Por favor ingrese una fecha valida." Text="*" MinimumValue="01/01/1900" MaximumValue="01/01/3000" SetFocusOnError="True" Display="Dynamic" ControlToValidate="TInicio"></asp:RangeValidator>
                </td>
            <td>
                Fin</td>
            <td>
                <asp:TextBox ID="TFin" runat="server" CssClass="fecha" Text=""></asp:TextBox>
                <asp:RangeValidator ID="RangeValidator2" runat="server" Type="Date" ErrorMessage="Por favor ingrese una fecha valida." Text="*" MinimumValue="01/01/1900" MaximumValue="01/01/3000" SetFocusOnError="True" Display="Dynamic" ControlToValidate="TFin"></asp:RangeValidator>
                </td>
            <td>
                <asp:CheckBox ID="CRetiro" runat="server" Text="Retiro" />
            </td>
            <td>
                <asp:DropDownList ID="DRetiro" runat="server" AppendDataBoundItems="true" CssClass="anchomaxcombo" 
                    DataSourceID="SRetiro" DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SRetiro" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT mteId AS id,mteDescripcion AS nombre from motivo_retiro">
                </asp:SqlDataSource>
            </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Width="100%"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron recursos humanos" 
        AllowPaging="True" PageSize="50" AllowSorting="True" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="documento" HeaderText="Documento" 
                DataNavigateUrlFields="id" SortExpression="documento"
                DataNavigateUrlFormatString="~/rh/Default.aspx?fid={0}" >
            <ItemStyle HorizontalAlign="Right" />
            </asp:HyperLinkField>
           <asp:HyperLinkField DataTextField="nombres" HeaderText="Nombres" 
                DataNavigateUrlFields="id" 
                DataNavigateUrlFormatString="~/rh/Default.aspx?fid={0}" SortExpression="nombres" ItemStyle-Wrap="false" />
            <asp:BoundField HeaderText="Cargo" DataField="cargo" SortExpression="cargo" ItemStyle-Wrap="false"/>
            <asp:BoundField HeaderText="Teléfono móvil" DataField="celular" 
                SortExpression="celular">
            <ItemStyle HorizontalAlign="Right" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Ingreso" DataField="fechacontrato" 
                SortExpression="fechacontrato" DataFormatString="{0:d}" >
            <ItemStyle HorizontalAlign="Right" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Estado" DataField="estado" SortExpression="estado"/>
            <asp:BoundField HeaderText="Retiro" DataField="perFechaTermContrato" 
                SortExpression="perFechaTermContrato" DataFormatString="{0:d}" >
            <ItemStyle HorizontalAlign="Right" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Motivo retiro" DataField="retiro" SortExpression="retiro"/>
        </Columns>
    </asp:GridView>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT per.perId AS id,per.perDocumento AS documento, per.perNombre AS nombres,  per.perFechaContrato AS fechacontrato,  
                per.perFechaTermContrato,cargo.carDescripcion AS cargo,motivo_retiro.mteDescripcion AS retiro,funcionario_estados.eEstDesc AS estado,
                per.perCelular AS celular
                FROM recurso_humano per  
                LEFT JOIN cargo on per.carId = cargo.carId    
                LEFT JOIN disponibilidad on disponibilidad.dispId = per.dispId    
                LEFT JOIN motivo_retiro ON (motivo_retiro.mteId=per.mteId)  
                LEFT JOIN funcionario_estados ON (funcionario_estados.eEstId=per.eEstId) 
                WHERE (@estado=0 OR per.eEstId=@estado)  AND(@cargo=0 or per.carId=@cargo)   
                and (
                (@fretiro=1 AND (@inicio=' ' OR perFechaTermContrato>=STR_TO_DATE(@inicio, '%d/%m/%Y')) and (@fin=' ' or perFechaTermContrato<=STR_TO_DATE(@fin, '%d/%m/%Y'))) OR
                (@fretiro=0 AND (@inicio=' ' OR per.perFechaContrato>=STR_TO_DATE(@inicio, '%d/%m/%Y')) and (@fin=' ' or per.perFechaContrato<=STR_TO_DATE(@fin, '%d/%m/%Y')))
                )
                AND (@nombres=' ' OR per.perNombre LIKE CONCAT('%', @nombres, '%'))
                AND (@retiro=0 or per.mteId=@retiro)  ORDER BY per.perFechaContrato DESC">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DEStado" PropertyName="SelectedValue" Name="estado" />
                    <asp:ControlParameter ControlID="DCargo" PropertyName="SelectedValue" Name="cargo" />
                    <asp:ControlParameter ControlID="DRetiro" PropertyName="SelectedValue" Name="retiro" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" DefaultValue=" " />
                    <asp:ControlParameter ControlID="TFin" Name="fin" DefaultValue=" " />
                    <asp:ControlParameter ControlID="TNombres" Name="nombres" PropertyName="Text" DefaultValue=" " />
                    <asp:ControlParameter ControlID="CRetiro" Name="fretiro" PropertyName="Checked" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

