<%@ Page Title="Evolución manejo de heridas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evolucion.aspx.cs" Inherits="clinicaheridas_evolucion" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
.cms {
    width: 75px;
    text-align: right;
}
.porcentaje {
    width: 75px;
    text-align: right;
}
</style>
<script type="text/javascript">
    $(function() {
        $('.cms:not(.rcms)').autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' cm', pSign: 's' }).addClass("rcms");
        $('.porcentaje:not(.rporcentaje)').autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' %', pSign: 's' }).addClass("rporcentaje");
        $("#<%= TTA.ClientID %>").mask("999/99 mm/Hg");
        $("#<%= TFC.ClientID %>, #<%= TPDMS.ClientID %>, #<%= TPDMI.ClientID %>").autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' Lat/min', pSign: 's' });
        $("#<%= TFR.ClientID %>").autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' Min', pSign: 's' });
        $("#<%= TT.ClientID %>").autoNumeric('init', { vMin: 0, mDec: 0, aSep: '', aSign: ' °', pSign: 's' });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
<asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
<ContentTemplate>
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table style="border-collapse: collapse">
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Examén físico</td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Datos objetivos</td>
            </tr>
            <tr>
                <td class="tdl">TA</td>
                <td><asp:TextBox ID="TTA" runat="server" CssClass="likenumber"></asp:TextBox></td>
                <td>FC</td>
                <td class="tdr"><asp:TextBox ID="TFC" runat="server" CssClass="entero"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl">FR</td>
                <td><asp:TextBox ID="TFR" runat="server" CssClass="entero"></asp:TextBox></td>
                <td>T</td>
                <td class="tdr"><asp:TextBox ID="TT" runat="server" CssClass="float"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl">Pulsos distales MS</td>
                <td><asp:TextBox ID="TPDMS" runat="server" CssClass="entero"></asp:TextBox></td>
                <td>Pulsos distales MI</td>
                <td class="tdr"><asp:TextBox ID="TPDMI" runat="server" CssClass="entero"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Diagnóstico - Condición actual</td>
            </tr>
            <tr>
                <td>Valoración inicial</td>
                <td><asp:Label runat="server" ID="LValoracionInicial"></asp:Label></td>
                <td>Días de evolución</td>
                <td class="tdr"><asp:Label runat="server" ID="LDiasEvolucion"></asp:Label></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdl tdr">Seguimiento de heridas</td>
            </tr>
            <tr>
                <td class="tdl">Tipo</td>
                <td><asp:TextBox runat="server" ID="TTipo"></asp:TextBox></td>
                <td>Localización</td>
                <td class="tdr"><asp:TextBox runat="server" ID="TLocalizacion"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl">Categoría</td>
                <td><asp:TextBox runat="server" ID="TCategoria"></asp:TextBox></td>
                <td>Clasificación</td>
                <td class="tdr"><asp:DropDownList ID="DClasificacion" runat="server" DataSourceID="SClasificacion" 
                    DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SClasificacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=53 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Tamaño</td>
            </tr>
            <tr>
                <td class="tdl">Longitud</td>
                <td><asp:TextBox runat="server" ID="TLongitud" CssClass="cms"></asp:TextBox></td>
                <td>Anchura</td>
                <td class="tdr"><asp:TextBox runat="server" ID="TAnchura" CssClass="cms"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl">Profundidad</td>
                <td><asp:TextBox runat="server" ID="TProfunidad" CssClass="cms"></asp:TextBox></td>
                <td></td>
                <td class="tdr"></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Cm</td>
            </tr>
            <tr>
                <td class="tdl">Tunelizacion</td>
                <td><asp:TextBox runat="server" ID="TTunelizacion" CssClass="cms"></asp:TextBox></td>
                <td>Cavidad</td>
                <td class="tdr"><asp:TextBox runat="server" ID="TCavidad" CssClass="cms"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Lecho ulceral</td>
            </tr>
            <tr>
                <td class="tdl">Epitelización</td>
                <td><asp:TextBox runat="server" ID="TEpitelizacion" CssClass="porcentaje"></asp:TextBox></td>
                <td>Escara</td>
                <td class="tdr"><asp:TextBox runat="server" ID="TEscara" CssClass="porcentaje"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl">Granulación</td>
                <td><asp:TextBox runat="server" ID="TGranulacion" CssClass="porcentaje"></asp:TextBox></td>
                <td>Hipergranulación</td>
                <td class="tdr"><asp:TextBox runat="server" ID="THiperGranulacion" CssClass="porcentaje"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl">Limpio pero no granulado</td>
                <td><asp:TextBox runat="server" ID="TLimpio" CssClass="porcentaje"></asp:TextBox></td>
                <td>Necrosis profunda</td>
                <td class="tdr"><asp:TextBox runat="server" ID="TNecrosis" CssClass="porcentaje"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Exudado</td>
            </tr>
            <tr>
                <td class="tdl">Cantidad</td>
                <td><asp:DropDownList ID="DExudado" runat="server" DataSourceID="SExudado" 
                    DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SExudado" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=56 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
                <td>Tipo</td>
                <td class="tdr"><asp:DropDownList ID="DTipoExudado" runat="server" DataSourceID="STipoExudado" 
                    DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="STipoExudado" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=57 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td class="tdl">Bordes de la herida</td>
                <td><asp:DropDownList ID="DBordesHerida" runat="server" DataSourceID="SBordesHerida" 
                    DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SBordesHerida" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=59 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
                <td></td>
                <td class="tdr"></td>
            </tr>
            <tr>
                <td class="tdl">Piel perilesional</td>
                <td><asp:DropDownList ID="DPiel" runat="server" DataSourceID="SPiel" 
                    DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SPiel" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=63 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
                <td>Signos de infección</td>
                <td class="tdr"><asp:DropDownList ID="DSignosInfeccion" runat="server" DataSourceID="SSignosInfeccion" 
                    DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SSignosInfeccion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=64 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Cambios locales de herida</td>
            </tr>
            <tr>
                <td class="tdl">Tipo</td>
                <td><asp:DropDownList ID="DTipoCambios" runat="server" DataSourceID="STipoCambios" 
                    DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="STipoCambios" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=65 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
                <td>Signos de infección</td>
                <td class="tdr"><asp:TextBox runat="server" ID="TSignosInfeccion"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Plan de manejo</td>
            </tr>
            <tr>
                <td class="tdl">Procedimiento</td>
                <td colspan="3" class="tdr"><asp:TextBox runat="server" ID="TProcedimiento" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="tdl">Insumos, dispositivos utilizados</td>
                <td colspan="3" class="tdr"><asp:TextBox runat="server" ID="TInsumos" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Indicaciones terapeuticas</td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Clínica</td>
            </tr>
            <tr>
                <td colspan="4" class="tdr tdl">
                    <asp:GridView ID="GClinica" runat="server" ShowHeader="false" AutoGenerateColumns="False" DataSourceID="SClinica" EmptyDataText="No se encontraron componentes" Width="100%" DataKeyNames="id">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:TemplateField HeaderText="Si">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="CSi" Text='<%# Eval("nombre") %>' Checked='<%# Eval("valor").ToString()=="1" %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SClinica" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre,valor FROM varios 
                                LEFT JOIN valoracion_herida_educativo ON (valoracion_herida_educativo.valoracion=@valoracion AND varios.id=valoracion_herida_educativo.concepto)
                                WHERE tipo=62 AND szReservado IS NULL ORDER BY nombre">
                            <SelectParameters>
                                <asp:Parameter Name="valoracion" DefaultValue="0" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td class="tdl">Otros</td>
                <td class="tdr" colspan="3"><asp:TextBox runat="server" ID="TOtros" Width="99%"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaSubTitulo tdr tdl">Componente educativo</td>
            </tr>
            <tr>
                <td colspan="4" class="tdr tdl tdb">
                    <asp:GridView ID="GEducativo" runat="server" ShowHeader="false" AutoGenerateColumns="False" DataSourceID="SEducativo" EmptyDataText="No se encontraron componentes" Width="100%" DataKeyNames="id">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:TemplateField HeaderText="Si">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="CSi" Text='<%# Eval("nombre") %>' Checked='<%# Eval("valor").ToString()=="1" %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SEducativo" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre,valor FROM varios 
                                LEFT JOIN valoracion_herida_educativo ON (valoracion_herida_educativo.valoracion=@valoracion AND varios.id=valoracion_herida_educativo.concepto)
                                WHERE tipo=62 AND szReservado IS NULL ORDER BY nombre">
                            <SelectParameters>
                                <asp:Parameter Name="valoracion" DefaultValue="0" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td colspan="4"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label></td>
            </tr>
            <tr>
                <td colspan="4"><asp:ValidationSummary runat="server" /></td>
            </tr>
            <tr>
                <td colspan="4" align="right">
                    <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                    <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" />
                </td>
            </tr>
        </table>
</ContentTemplate>
</asp:UpdatePanel>
</asp:Content>