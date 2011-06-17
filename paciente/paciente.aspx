<%@ Page Title="Paciente" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="paciente.aspx.cs" Inherits="seguimiento_paciente" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="Panel1" DefaultButton="IBuscar">
       <fieldset>
        <legend>Información personal</legend>
        <table>
            <tr>
                <td>
                    Documento
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
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
                                DataSourceID="SqlDataSource2" DataTextField="tdocDescripcion" 
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
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Primer apellido</td>
                <td>
                    <asp:TextBox ID="TPApellido" runat="server" 
                        ></asp:TextBox>
                </td>
                <td>
                    Segundo apellido</td>
                <td>
                    <asp:TextBox ID="TSApellido" runat="server"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Primer nombre</td>
                <td>
                    <asp:TextBox ID="TPNombre" runat="server"></asp:TextBox>
                </td>
                <td>
                    Segundo nombre</td>
                <td>
                    <asp:TextBox ID="TSNombre" runat="server"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Sexo</td>
                <td>
                    <asp:DropDownList ID="DSexo" runat="server" 
                        DataSourceID="SqlDataSource1" DataTextField="sexoDesc" 
                        DataValueField="sexoId">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT [sexoId], [sexoDesc] FROM [admSexo]">
                    </asp:SqlDataSource>
                </td>
                <td>
                    Fecha nacimiento</td>
                <td>
                    <asp:TextBox ID="TNacimiento" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="LEdad" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    Dirección</td>
                <td>
                    <asp:TextBox ID="TDireccion" runat="server"></asp:TextBox>
                </td>
                <td>
                    Barrio</td>
                <td>
                    <asp:TextBox ID="TBarrio" runat="server"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Teléfonos</td>
                <td>
                    <asp:TextBox ID="TTelefono" runat="server" ></asp:TextBox>
                </td>
                <td>
                    Teléfono movil</td>
                <td>
                    <asp:TextBox ID="TMovil" runat="server" CssClass="entero"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Correo electronico</td>
                <td>
                    <asp:TextBox ID="TCorreo" runat="server"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
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
                <td>
                    &nbsp;</td>
            </tr>
        </table>
    </fieldset>
    </asp:Panel>
    <script type="text/javascript">

        $(document).ready(function() {
            $('#ctl00_cph_TNacimiento').datepicker({
                onClose: function(dateText, inst) {
                    var fecha = $("#ctl00_cph_TNacimiento").datepicker("getDate");
                    if (fecha) {
                        var currentTime = new Date();
                        var diff_date = currentTime - fecha;
                        var num_years = diff_date / 31536000000;
                        $("#ctl00_cph_LEdad").html(Math.floor(num_years) + " años");
                    } else {
                        $("#ctl00_cph_LEdad").html("");
                    }
                },
                changeMonth: true,
                changeYear: true
            });
       });
       function iniciopagina() {
           $("#ctl00_cph_TDocumento").blur(function() { if ($.getUrlVar('id') != $(this).val()) $("#ctl00_cph_IBuscar").click(); });
        }
</script>
</asp:Content>

