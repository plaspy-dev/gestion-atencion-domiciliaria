<%@ Page Title="Índice de Barthel" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="barthel.aspx.cs" Inherits="paciente_barthel" %>
<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="Panel1" DefaultButton="IBuscar">
    <fieldset>
        <legend>Datos del paciente</legend>
    <table>
        <tr>
                <td>
                    Documento
                    <asp:SqlDataSource ID="SDocumentos" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT [tdocId], [tdocDescripcion] FROM [phdTipoDocumento]">
                    </asp:SqlDataSource>
                </td>
                <td>
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <table>
                        <tr>
                            <td>
                            <asp:DropDownList ID="DDocumento" runat="server" 
                                DataSourceID="SDocumentos" DataTextField="tdocDescripcion" 
                                DataValueField="tdocId">
                                </asp:DropDownList>
                            </td>
                            <td><asp:TextBox ID="TDocumento" runat="server" ValidationGroup="documento" 
                                CssClass="entero"></asp:TextBox>
                            </td>
                        </tr>
                        </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td>
                    <asp:UpdatePanel ID="UBuscar" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Button ID="IBuscar" runat="server" Text="..." onclick="IBuscar_Click" ValidationGroup="documento" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:HiddenField ID="HId" runat="server" Value="" />
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="TDocumento" ErrorMessage="Por favor ingrese un documento." 
                        SetFocusOnError="True" ValidationGroup="documento"></asp:RequiredFieldValidator>
                </td>
                <td>&nbsp;
                    </td>
            </tr>
        <tr>
            <td>
                Apellidos</td>
            <td>
                <asp:Label runat="server" ID="LApellidos"></asp:Label>
            </td>
            <td>
                Nombres</td>
            <td>
                <asp:Label runat="server" ID="LNombres"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Entidad</td>
            <td>
                <asp:Label runat="server" ID="LEntidad"></asp:Label>
            </td>
            <td>
                Tipo de afiliado</td>
            <td>
                <asp:Label runat="server" ID="LTAfiliado"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Dirección</td>
            <td>
                <asp:Label runat="server" ID="LDireccion"></asp:Label>
            </td>
            <td>
                Edad</td>
            <td>
                <asp:Label runat="server" ID="LEdad"></asp:Label>
            </td>
        </tr>
    </table>
    </fieldset></asp:Panel>
    <fieldset>
        <legend>Datos</legend>
        <table style="width: 100%;">
            <tr>
                <td>
                    Fecha
                    <asp:HiddenField ID="HIdIndice" runat="server" />
                </td>
                <td>
                    <asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                </td>
                <td>
                    <asp:RangeValidator ID="RangeValidator1" runat="server" MaximumValue="12/12/2100" MinimumValue="12/12/1900" SetFocusOnError="true" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." Type="Date"></asp:RangeValidator></td>
            </tr>
            <tr>
                <td>
                    Hora
                </td>
                <td>
                    <asp:TextBox ID="THora" runat="server" CssClass="hora"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Diagnostico
                </td>
                <td>
                    <asp:TextBox ID="TDiagnostico" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
    </fieldset>
    <fieldset>
        <legend>Datos del paciente</legend>
        <table style="width: 100%;">
            <tr>
                <td>
                    <asp:Repeater ID="RGrupos" runat="server" DataSourceID="SqlDataSource1" 
                        onitemdatabound="RGrupos_ItemDataBound">
            <HeaderTemplate>
                <table width="100%" border="1">
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><b><%# DataBinder.Eval(Container.DataItem,"grupo") %>
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
                        <tr>
                            <td>
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
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
    <script type="text/javascript">
        function total() {
            var total=0;
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
            else if(total<60)
                $("#grave").css("font-weight", "bold");
            else if (total < 80)
                $("#moderada").css("font-weight", "bold");
            else if (total < 100)
                $("#ligera").css("font-weight", "bold");
        }
        $("input:radio").change(total);
        total();
        function iniciopagina() {
            $("#ctl00_cph_TDocumento").blur(function() { if ($.getUrlVar('id') != $(this).val()) $("#ctl00_cph_IBuscar").click(); });
        }
    </script>
</asp:Content>

