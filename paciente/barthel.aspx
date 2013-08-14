<%@ Page Title="Índice de Barthel" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="barthel.aspx.cs" Inherits="paciente_barthel" %>
<%@ Import Namespace="System.Data" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
.tabla 
{
    border-collapse: collapse; 
}
.tabla td 
{
    border: 1px solid #a6c9e2;
}
</style>
<script type="text/javascript">
    function total() {
        var total = 0;
        $("input:radio").each(function(i) {
            if ($(this).is(":checked")) {
                total += parseInt($(this).val());
            }
        });
        $("#ctl00_cph_TTotal").val(total);
        $("#severa").css("font-weight", "");
        $("#grave").css("font-weight", "");
        $("#moderada").css("font-weight", "");
        $("#ligera").css("font-weight", "");
        if (total < 45)
            $("#severa").css("font-weight", "bold");
        else if (total < 60)
            $("#grave").css("font-weight", "bold");
        else if (total < 80)
            $("#moderada").css("font-weight", "bold");
        else // if (total < 100)
            $("#ligera").css("font-weight", "bold");
    }

    addFunctionToStart(function() {

        $("#<%= TFuncionario.ClientID %>").autocomplete({
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
                var nombre = ui.item.label;
                var pos = nombre.indexOf(" - ");
                if (pos != -1) {
                    nombre = nombre.substring(pos + 3);
                }
                $("#<%= TFuncionario.ClientID %>").val(nombre);
                $("#<%= TIdFuncionario.ClientID %>").val(ui.item.value);
                return false;
            },
            search: function(event, ui) {
                $("#<%= TIdFuncionario.ClientID %>").val("");
            }
        });
    
        $("input:radio").change(total);
        total();

        $("#<%= TFecha.ClientID %>").datepicker({
            onClose: function(dateText, inst) { if ($.getUrlVar('f') != $(this).val()) $("#<%=BFecha.ClientID %>").click(); }
        });
        $("#<%= PHistorial.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });

        FullRowSelect("#<%= GHistorial.ClientID %>");
    });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<div id="dImprimir">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
        <ContentTemplate>
        <asp:HiddenField runat="server" ID="HIdEpicrisis" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
    <fieldset>
        <legend>Datos</legend>
        <table style="width: 100%;">
            <tr>
            <td colspan="3">
                <asp:Panel ID="PHistorial" runat="server">
                    <h3><a href="#"><asp:Label runat="server" ID="LHistorial"></asp:Label></a></h3>
                    <div class="hide">
                        <asp:GridView ID="GHistorial" runat="server" AutoGenerateColumns="False"  Width="100%"
                            DataSourceID="SHistorial" EmptyDataText="No se encontraron índices anteriores de este paciente" >
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton CommandArgument='<%# Eval("fecha") %>' ID="IIr" runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" onclick="IIr_Click"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="diagnostico" HeaderText="Incapacidad funcional" ItemStyle-Width="100%" />
                                <asp:BoundField DataField="resultado" HeaderText="Puntaje" ItemStyle-HorizontalAlign="Right" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SHistorial" runat="server" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT indice_barthel.fecha,SUM(varios.descripcion) AS resultado
                                        ,CASE 
                                        WHEN SUM(varios.descripcion)<45 THEN 'Severa' 
                                        WHEN SUM(varios.descripcion)<60 THEN 'Grave' 
                                        WHEN SUM(varios.descripcion)<80 THEN 'Moderada' 
                                        WHEN SUM(varios.descripcion)<100 THEN 'Ligera' 
                                        ELSE '' END AS diagnostico 
                                        FROM indice_barthel
                                        LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id)
                                        LEFT JOIN varios ON (varios.id=analisis_barthel.resultado)
                                        WHERE indice_barthel.paciente=@paciente
                                        GROUP BY indice_barthel.fecha
                                        ORDER BY fecha DESC;
                                        ">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="CCDetallePaciente" PropertyName="IdPaciente" Name="paciente" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </asp:Panel>
            </td>
            </tr>
            <tr>
                <td>
                    Fecha
                    <asp:HiddenField ID="HIdIndice" runat="server" />
                </td>
                <td>
                    <asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox><asp:Button ID="BFecha" CssClass="hide" runat="server" Text="..." onclick="BFecha_Click" />
                </td>
                <td>
                    <asp:RangeValidator ID="RangeValidator1" runat="server" MaximumValue="12/12/2100" MinimumValue="12/12/1900" SetFocusOnError="true" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." Type="Date"></asp:RangeValidator></td>
                    <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            </tr>
            <tr>
                <td>
                    Hora mas larga
                </td>
                <td>
                    <asp:TextBox ID="THora" runat="server" CssClass="hora"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="THora" ErrorMessage="Por favor ingrese una Hora." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>Funcionario que atiende</td>
                <td colspan="2">
                    <asp:TextBox ID="TFuncionario" runat="server" Width="98%"></asp:TextBox>
                    <asp:TextBox ID="TIdFuncionario" runat="server" CssClass="hide"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="TIdFuncionario" ErrorMessage="Por favor ingrese un funcionario." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    </td>
            </tr>
        </table>
    </fieldset>
    <fieldset>
        <legend>Datos del paciente</legend>
        <table style="width: 100%;" cellspacing=0 cellpadding=0>
            <tr>
                <td>
                    <asp:Repeater ID="RGrupos" runat="server" DataSourceID="SqlDataSource1" 
                        onitemdatabound="RGrupos_ItemDataBound">
            <HeaderTemplate>
                <table width="100%" class="tabla" cellspacing=0 cellpadding=0>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><b>
                        <asp:Label runat="server" ID="LN" Text='<%# DataBinder.Eval(Container.DataItem,"grupo") %>'></asp:Label>
                        <asp:HiddenField ID="HIdGrupo" runat="server" Value='<%# DataBinder.Eval(Container.DataItem,"id") %>' />
                        <asp:HiddenField ID="HIdAnalisis" runat="server" Value='<%# DataBinder.Eval(Container.DataItem,"idanalisis") %>' />
                        <asp:HiddenField ID="HIdResultado" runat="server" Value='<%# DataBinder.Eval(Container.DataItem,"resultado") %>' />
                        </b><br>
                        </td>
                        <td>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT CONVERT(CONCAT(varios.descripcion, '#',varios.id),CHAR) AS id,varios.nombre AS nombre FROM varios WHERE varios.tipo=8 AND varios.parametro1=@grupo AND varios.szReservado IS NULL" >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdGrupo" DefaultValue="0" PropertyName="Value" Name="grupo" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:RadioButtonList ID="RConceptos" runat="server" DataSourceID="SqlDataSource1" DataTextField="nombre" DataValueField="id">
                        </asp:RadioButtonList>
                        <asp:RequiredFieldValidator ControlToValidate="RConceptos" ErrorMessage="Por favor selecione un valor." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                      </td>
                 </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id,varios.nombre AS grupo,analisis_barthel.id AS idanalisis,analisis_barthel.resultado AS resultado FROM varios LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=@indice AND analisis_barthel.grupo=varios.id) WHERE varios.tipo=7 AND varios.szReservado IS NULL" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdIndice" DefaultValue="0" PropertyName="Value" Name="indice" />
                </SelectParameters>
            </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td>
                    <table style="width:100%;">
                        <tr>
                            <td>
                                La incapacidad funcional se valora como: <span id='severa'>Severa &lt; 45 puntos</span>, <span id='grave'>Grave 45-59 Puntos</span>, 
                                <span id='moderada'>Moderada 60-80</span>, <span id='ligera'>Ligera 80-100</span>.</td>
                            <td>
                                Puntuación</td>
                            <td>
                                <asp:TextBox ID="TTotal" runat="server" ReadOnly="True" CssClass="izquierdo"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                            <td>
                                <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" 
                                    Text="Aceptar" />
                                <asp:Button ID="BCancelar" runat="server" CausesValidation="False" 
                                    onclick="BCancelar_Click" Text="Cancelar" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
    </fieldset>
    </ContentTemplate>
    </asp:UpdatePanel>
    </div>
</asp:Content>

