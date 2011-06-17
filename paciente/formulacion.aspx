<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="formulacion.aspx.cs" Inherits="paciente_formulacion" %>

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
                <table>
                    <tr>
                        <td>
                            Fecha
                        </td>
                        <td>
                            <asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                            <asp:Button ID="BFecha" runat="server" Text="..." onclick="BFecha_Click" />
                        </td>
                        <td>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese una fecha." SetFocusOnError="true" ControlToValidate="TFecha" Display="Dynamic"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Código de diagnóstico</td>
                        <td>
                            <asp:TextBox ID="TCodigo" runat="server"></asp:TextBox>
                        </td>
                        <td>
                            <asp:HiddenField ID="HIdFormulacion" runat="server" />
                            </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
            <fieldset>
        <legend>Formulación</legend>
        <asp:UpdatePanel ID="UFormulacion" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="GFormulacion" runat="server" DataSourceID="SFormulacion" 
                AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
            <Columns>
                <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                <asp:BoundField DataField="medicamento" HeaderText="Nombre del medicamento" />
                <asp:BoundField DataField="formulada" HeaderText="Cantidad formulada" />
                <asp:BoundField DataField="entregada" HeaderText="Cantidad entregada" />
            </Columns>
            <SelectedRowStyle CssClass="selecteditem" />
        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Button ID="BMasFormulacion" runat="server" onclick="BMasFormulacion_Click" 
                            Text="+" />
                    </td>
                </tr>
            </table>
        <sdg:CustomDataSource ID="SFormulacion" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,medicamento,formulada,entregada FROM medicamento_formulacion WHERE formulacion=@formulacion"
                            DeleteCommand="DELETE FROM medicamento_formulacion WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdFormulacion" DefaultValue="0" PropertyName="Value" Name="formulacion" />
                            </SelectParameters>
        </sdg:CustomDataSource>
            <div id="dFormulacion" title="Signos vitales">
            <asp:DetailsView ID="DFormulacion" runat="server" Width="100%" 
                DataSourceID="SDetalleView" DataKeyNames="id" 
                AutoGenerateRows="False" DefaultMode="Edit" 
                oniteminserted="DFormulacion_ItemInserted" 
                onitemupdated="DFormulacion_ItemUpdated" 
                onitemcommand="DFormulacion_ItemCommand">
                <Fields>
                    <asp:TemplateField HeaderText="Medicamento">
                        <EditItemTemplate>
                            <asp:TextBox ID="TMedicamento" runat="server" Text='<%# Bind("medicamento") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese un medicamento." ControlToValidate="TMedicamento" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TMedicamento" runat="server" Text='<%# Bind("medicamento") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese un medicamento." ControlToValidate="TMedicamento" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("medicamento") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Cantidad formulada">
                        <EditItemTemplate>
                            <asp:TextBox ID="TFormulada" runat="server" CssClass="entero" Text='<%# Bind("formulada") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator3" runat="server" ErrorMessage="Por favor ingrese una cantidad." ControlToValidate="TFormulada" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TFormulada" runat="server" CssClass="entero" Text='<%# Bind("formulada") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator3" runat="server" ErrorMessage="Por favor ingrese una cantidad." ControlToValidate="TFormulada" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("formulada") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Cantidad entregada">
                        <EditItemTemplate>
                            <asp:TextBox ID="TEntregada" runat="server" CssClass="entero" Text='<%# Bind("entregada") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TEntregada" runat="server" CssClass="entero" Text='<%# Bind("entregada") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("entregada") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <sdg:CustomDataSource ID="SDetalleView" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,medicamento,formulada,entregada FROM medicamento_formulacion WHERE id=@id"
                            InsertCommand="INSERT INTO medicamento_formulacion(formulacion,medicamento,formulada,entregada) VALUES (@formulacion, @medicamento, @formulada, @entregada)"
                            UpdateCommand="UPDATE medicamento_formulacion SET medicamento=@medicamento,formulada=@formulada,entregada=@entregada WHERE id=@id"
                            ParentDataSource="SFormulacion"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GFormulacion" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:ControlParameter ControlID="GFormulacion" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </UpdateParameters>
        </sdg:CustomDataSource>
        </ContentTemplate>
        </asp:UpdatePanel>
    </fieldset>
            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" /><asp:Button ID="BCancelar" 
                    CausesValidation="false" runat="server" Text="Cancelar" 
                    onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
    <script type="text/javascript">
        $('#ctl00_cph_UFormulacion').panelUpdated(function() {
            addDialog("#ctl00_cph_UFormulacion", "#dFormulacion");
        });
        $(document).ready(function() {
            $("#ctl00_cph_BFecha").hide();
            $("#ctl00_cph_TFecha").datepicker({
                onClose: function(dateText, inst) { if ($.getUrlVar('f') != $(this).val()) $("#ctl00_cph_BFecha").click(); }
            });
        });
        function iniciopagina() {
            $("#ctl00_cph_TDocumento").blur(function() { if ($.getUrlVar('id') != $(this).val()) $("#ctl00_cph_IBuscar").click(); });
        }
    </script>
</asp:Content>