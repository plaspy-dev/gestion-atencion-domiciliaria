<%@ Page Title="Epicrisis apoyo terapeútico" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="epicrisis.aspx.cs" Inherits="paciente_epicrisis" %>

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
    <table width="100%">
        <tr>
            <td>
                <table width="100%">
                    <tr>
                        <td>
                            Fecha
                        </td>
                        <td>
                        <asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                        </td>
                        <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ErrorMessage="Por favor ingrese una fecha." ControlToValidate="TFecha" 
                    Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator><asp:HiddenField ID="HIdIndice" runat="server" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
            <fieldset>
                <legend>Resultados valoración inicial</legend>
                <asp:TextBox ID="TValoracionInicial" runat="server" Width="100%" TextMode="MultiLine"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                    ErrorMessage="Por favor ingrese una valoración inicial." ControlToValidate="TValoracionInicial" 
                    Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
            </fieldset>
            <fieldset>
                <legend>Resultados valoración final</legend>
                <asp:TextBox ID="TValoracionFinal" runat="server" Width="100%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            <fieldset>
                <legend>Plan de intervención propuesto</legend>
                <asp:TextBox ID="TIntervencionPropuesta" runat="server" Width="100%" TextMode="MultiLine"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                    ErrorMessage="Por favor ingrese una intervención propuesta." ControlToValidate="TIntervencionPropuesta" 
                    Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
            </fieldset>
            <fieldset>
                <legend>Intervención realizada</legend>
                <asp:TextBox ID="TIntervencionRealizada" runat="server" Width="100%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            <fieldset>
                <legend>Logros obtenidos</legend>
                <asp:TextBox ID="TLogros" runat="server" Width="100%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            <fieldset>
                <legend>Observaciones</legend>
                <asp:TextBox ID="TObservaciones" runat="server" Width="100%" TextMode="MultiLine"></asp:TextBox>
            </fieldset>
            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" /><asp:Button ID="BCancelar"
                    runat="server" Text="Cancelar" CausesValidation="false" 
                    onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
    <script type="text/javascript">
        function iniciopagina() {
            $("#ctl00_cph_TDocumento").blur(function() { if ($.getUrlVar('id') != $(this).val()) $("#ctl00_cph_IBuscar").click(); });
        }
    </script>
</asp:Content>