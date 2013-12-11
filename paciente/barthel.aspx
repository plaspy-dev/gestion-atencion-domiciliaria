<%@ Page Title="Índice y escalas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="barthel.aspx.cs" Inherits="paciente_barthel" %>
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
    var escala = null;
    function total() {
        var total = 0;
        $("input:radio").each(function(i) {
            if ($(this).is(":checked")) {
                total += parseInt($(this).val());
            }
        });
        $("#<%= TTotal.ClientID %>").val(total);
        $("#<%= LResultado.ClientID %>").html();
        
        for(var i=0; i<escala.length; i++) {
            if (total < escala[i][0]) {
                $("#<%= LResultado.ClientID %>").html(escala[i][1]);
                break;
            }
        }
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
                        <asp:GridView ID="GHistorial" runat="server" AutoGenerateColumns="False"  Width="100%" OnRowDataBound="GHistorial_RowDataBound"
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
                                        <asp:ImageButton CommandArgument='<%# Eval("id") %>' ID="IIr" runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" onclick="IIr_Click"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy HH:mm}" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="tipo" HeaderText="Tipo" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="resultado" HeaderText="Puntuación" ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="idtipo" HeaderText="Descripción" ItemStyle-Width="100%" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SHistorial" runat="server" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT indice_barthel.id,indice_barthel.fecha,SUM(varios.descripcion) AS resultado
                                        ,indice_barthel.tipo AS idtipo
                                        ,IF(indice_barthel.tipo=8, 'Índice de Barthel', 'Escala Braden') AS tipo
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
                <td>Índice o escala</td>
                <td><asp:DropDownList runat="server" ID="DIndice" AutoPostBack="true" 
                        onselectedindexchanged="DIndice_SelectedIndexChanged">
                    <asp:ListItem Text="Índice de Barthel" Value="8"></asp:ListItem>
                    <asp:ListItem Text="Escala Braden" Value="41"></asp:ListItem>
                </asp:DropDownList></td>
                <td></td>
            </tr>
            <tr>
                <td>
                    Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha valida" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))) (0[0-9]|1\d|2[0-3]):([0-5]\d)$" runat="server" >*</asp:RegularExpressionValidator>
                    <asp:HiddenField ID="HIdIndice" runat="server" />
                </td>
                <td>
                    <asp:TextBox ID="TFecha" runat="server" CssClass="fechahora"></asp:TextBox>
                </td>
                <td></td>
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
        <table style="width: 100%; border-collapse: collapse;" cellspacing=0 cellpadding=0>
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
                            SelectCommand="SELECT CONVERT(CONCAT(varios.descripcion, '#',varios.id),CHAR) AS id,varios.nombre AS nombre FROM varios WHERE varios.tipo=@tipo AND varios.parametro1=@grupo AND varios.szReservado IS NULL" >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdGrupo" DefaultValue="0" PropertyName="Value" Name="grupo" />
                                <asp:ControlParameter ControlID="DIndice" PropertyName="SelectedValue" Name="tipo" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:RadioButtonList ID="RConceptos" runat="server" DataSourceID="SqlDataSource1" DataTextField="nombre" DataValueField="id" Width="100%">
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
                SelectCommand="SELECT varios.id AS id,varios.nombre AS grupo,analisis_barthel.id AS idanalisis,analisis_barthel.resultado AS resultado FROM varios LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=@indice AND analisis_barthel.grupo=varios.id) WHERE varios.tipo=@tipo-1 AND varios.szReservado IS NULL" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdIndice" DefaultValue="0" PropertyName="Value" Name="indice" />
                    <asp:ControlParameter ControlID="DIndice" PropertyName="SelectedValue" Name="tipo" />
                </SelectParameters>
            </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td>
                    <table style="width:100%;">
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="LIncapacidad"></asp:Label>
                                <asp:Label runat="server" ID="LResultado" Font-Bold="true"></asp:Label>
                                </td>
                            <td align="right" nowrap="nowrap">
                                Puntuación
                                <asp:TextBox ID="TTotal" runat="server" ReadOnly="True" CssClass="izquierdo" Width="30px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="right">
                                <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                                <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" />
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

