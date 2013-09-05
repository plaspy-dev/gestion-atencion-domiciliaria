<%@ Page Title="Encuesta de satisfacción al usuario" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="escliente.aspx.cs" Inherits="cliente_escliente" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
.rot-neg-90 { 
    writing-mode:bt-lr;
	-webkit-transform:rotate(90deg);
	-moz-transform:rotate(90deg);
	-o-transform: rotate(90deg);
	white-space:nowrap;
} 
.tabla 
{
    border-collapse: collapse; 
    border-color: #a6c9e2;
}
.tabla td 
{
    border: 1px solid #a6c9e2;
}
</style>
<script type="text/javascript">
    $(function() {

        function GetColor(valor) {
            var color = "";
            var tipo = "";
            switch (valor) {
                case 1:
                    color = "#FF0000";
                    tipo = "Muy insatisfecho";
                    break;
                case 2:
                    color = "#FFCC00";
                    tipo = "Insatisfecho";
                    break;
                case 3:
                    color = "#FFFF00";
                    tipo = "Conforme";
                    break;
                case 4:
                    color = "#99CC00";
                    tipo = "Satisfecho";
                    break;
                case 5:
                    color = "#CCFFFF";
                    tipo = "Muy satisfecho";
                    break;
            }
            $("#sres").html(tipo);
            return color;
        }

        $("#promedio").autoNumeric({ vMin: 0, aSep: '', mDec: 2, aPad: false });


        jQuery.fn.ForceNumericOnly =
            function() {
                return this.each(function() {
                    $(this).keydown(function(e) {
                        var key = e.charCode || e.keyCode || 0;
                        // allow backspace, tab, delete, arrows, numbers and keypad numbers ONLY
                        return (
                            key == 8 ||
                            key == 9 ||
                            key == 46 ||
                            key == 109 ||
                            key == 189 ||
                            (key >= 37 && key <= 40) ||
                            (key >= 49 && key <= 53) ||
                            (key >= 97 && key <= 101));
                    });
                });
            };
        $(".cal").css("text-align", "left").ForceNumericOnly().change(function() {

            if ($(this).val() == "-") {
                $(this).parent().css("background-color", "#0000FF")
                .prev().css("background-color", "#0000FF");
            } else $(this).parent().css("background-color", GetColor(parseInt($(this).val())))
                .prev().css("background-color", GetColor(parseInt($(this).val())));
            var total = 0;
            var cuenta = 0;
            $(".cal").each(function() {
                var valor = parseInt($(this).val());
                if (isNaN(valor)) {
                    valor = 0;
                    cuenta--;
                }
                total += valor;
                cuenta++;
            });
            total = total / cuenta;
            $("#promedio").autoNumeric('set', total);
            $("#<%= HCalificacion.ClientID %>").val($("#promedio").val());
            if (total > 0 && total < 0.6)
                total = 1;
            total = Math.round(total);
            $("#promedio").parent().parent().css("background-color", GetColor(total));
        }).change();

        $("#<%= PEncuestas.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });

        FullRowSelect("#<%= GEncuestas.ClientID %>");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:Panel runat="server" id="PDatos" Visible="false">
        <asp:HiddenField runat="server" ID="HIdEncuesta" />
        <asp:HiddenField runat="server" ID="HCalificacion" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table>
            <tr>
                <td>
                    <asp:Panel ID="PEncuestas" runat="server">
                        <h3><a href="#"><asp:Label runat="server" ID="LEncuestas"></asp:Label></a></h3>
                        <div class="hide">
                            <asp:GridView ID="GEncuestas" runat="server" AutoGenerateColumns="False" Width="100%"
                                DataKeyNames="id" DataSourceID="SEncuestas" EmptyDataText="No se encontraron encuestas de este usuario" >
                                <RowStyle CssClass="GridRow"></RowStyle>
                                <FooterStyle CssClass="GridFooter"></FooterStyle>
                                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:ImageButton CommandArgument='<%# Eval("id") %>' ID="IIr" runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" onclick="IIr_Click"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                                    <asp:BoundField DataField="calificacion" HeaderText="Calificación" DataFormatString="{0:g}" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="100%" />
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="SEncuestas" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT id,fecha,calificacion FROM escliente WHERE paciente=@paciente
                                            ORDER BY fecha DESC;">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>Fecha <asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
            </tr>
            <tr>
                <td class="celdaTitulo">Instrucciones</td>
            </tr>
            <tr>
                <td>1-Diligencie según lo establecido en el procedimiento de aplicación y análisis de las encuestas de satisfacción al cliente externo<br />
                    2-Marque con una X según corresponda teniendo en cuenta que (1 insatisfacho total  y 5 satisfacción). o <b>'-'</b> si no aplica aplica.<br />
                    3-Diligencie la totalidad de los items</td>
            </tr>
            <tr>
                <td>
                <asp:Repeater ID="RGrupos" runat="server" DataSourceID="SGrupos">
                    <HeaderTemplate>
                        <table class="tabla">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td rowspan=<%# Eval("rows") %>><span class="rot-neg-90"><%# Eval("nombre") %><asp:HiddenField runat="server" ID="HId" Value='<%# Eval("id") %>' /></span></td>
                        </tr>
                        <asp:Repeater runat="server" ID="RPreguntas" DataSourceID="SPreguntas">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("nombre") %><asp:HiddenField runat="server" ID="HId" Value='<%# Eval("id") %>' /><asp:HiddenField runat="server" ID="HIdr" Value='<%# Eval("idr") %>' /></td>
                                    <td><asp:TextBox runat="server" Width="10px" MaxLength="1" CssClass="cal" ID="TRespuesta" Text='<%# Eval("calificacion") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="TRespuesta" ErrorMessage="Por favor ingrese una calificación." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ValidationExpression="^[12345-]{1}$" ID="RegularExpressionValidator1" ControlToValidate="TRespuesta" ErrorMessage="Por favor ingrese una calificación valida." Display="Dynamic" SetFocusOnError="true" runat="server">*</asp:RegularExpressionValidator></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:SqlDataSource ID="SPreguntas" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT varios.id,varios.nombre,escliente_calificacion.id AS idr, CAST(IF(escliente_calificacion.calificacion=0, '-',escliente_calificacion.calificacion) AS char) AS calificacion
                                            FROM varios 
                                            LEFT JOIN escliente_calificacion ON (escliente_calificacion.encuesta=@encuesta AND escliente_calificacion.concepto=varios.id)
                                            WHERE varios.tipo=16 AND varios.parametro1=@id AND varios.szReservado IS NULL" >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HId" Name="id" PropertyName="Value" />
                                <asp:ControlParameter ControlID="HIdEncuesta" Name="encuesta" PropertyName="Value" DefaultValue="0" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </ItemTemplate>
                    <FooterTemplate>
                            <tr>
                                <td align="right" colspan="2"><span id="sres" style="font-weight: bold"></span> <input id="promedio" type="text" readonly="readonly" style="width: 30px;" /></td>
                            </tr>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SGrupos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id,nombre,(SELECT COUNT(*)+1 FROM varios AS s WHERE s.tipo=16 AND s.parametro1=varios.id AND s.szReservado IS NULL ) AS rows FROM varios WHERE tipo=15 AND szReservado IS NULL" >
                </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:ValidationSummary runat="server" ID="VSummary" />
                    <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                        onclick="BAceptar_Click" />
                    <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                        CausesValidation="false" onclick="BCancelar_Click" />
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>