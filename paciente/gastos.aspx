<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="gastos.aspx.cs" Inherits="paciente_gastos" %>

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
        <legend>Suministros</legend>
        <table style="width: 100%;">
            <tr>
                <td>
                    <table style="width: 100%;">
                        <tr>
                            <td>
                                Fecha
                            </td>
                            <td>
                                <asp:TextBox ID="TFecha" CssClass="fecha" runat="server"></asp:TextBox>
                                <asp:HiddenField ID="HIdHoja" runat="server" />
                                <asp:Button ID="BFecha" runat="server" onclick="BFecha_Click" Text="-&gt;" />
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ControlToValidate="TFecha" SetFocusOnError="true" Display="Dynamic" ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese una fecha."></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="RangeValidator1" runat="server" MinimumValue="12/12/1900" MaximumValue="12/12/2100" SetFocusOnError="true" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." Display="Dynamic" Type="Date"></asp:RangeValidator>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="USuministros" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="GSuministros" runat="server" DataSourceID="SSuministros" 
                AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
            <Columns>
                <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                <asp:BoundField DataField="szSuministro" HeaderText="Suministro" />
                <asp:BoundField DataField="diurna" HeaderText="C. Diurna" />
                <asp:BoundField DataField="nocturna" HeaderText="C. Nocturna" />
            </Columns>
            <SelectedRowStyle CssClass="selecteditem" />
        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Button ID="BMasSuministros" runat="server" onclick="BMasSuministros_Click" 
                            Text="+" />
                    </td>
                </tr>
            </table>
        <sdg:CustomDataSource ID="SSuministros" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,diurna,nocturna,suministro,szSuministro FROM suministros_hoja_gastos WHERE hoja_gastos=@hoja"
                            DeleteCommand="DELETE FROM suministros_hoja_gastos WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdHoja" DefaultValue="0" PropertyName="Value" Name="hoja" />
                            </SelectParameters>
        </sdg:CustomDataSource>
            <div id="dSuministros" title="Suministros">
            <asp:DetailsView ID="DSuministros" runat="server" Width="100%" 
                DataSourceID="SDSuministros" DataKeyNames="id" 
                AutoGenerateRows="False" DefaultMode="Edit" 
                oniteminserted="DSuministros_ItemInserted" 
                onitemupdated="DSuministros_ItemUpdated" 
                onitemcommand="DSuministros_ItemCommand">
                <Fields>
                    <asp:TemplateField HeaderText="Suministro">
                        <EditItemTemplate>
                            <asp:DropDownList ID="DSuministro" runat="server" DataSourceID="SSuministro" SelectedValue='<%# Bind("suministro") %>'
                                DataTextField="nombre" DataValueField="id" 
                                AppendDataBoundItems="True">
                                <asp:ListItem Text="(Otros)" Value="0" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            <asp:SqlDataSource ID="SSuministro" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=9 AND szReservado IS NULL ORDER BY nombre" >
                            </asp:SqlDataSource>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:DropDownList ID="DSuministro" runat="server" DataSourceID="SSuministro" SelectedValue='<%# Bind("suministro") %>'
                                DataTextField="nombre" DataValueField="id" 
                                AppendDataBoundItems="True">
                                <asp:ListItem Text="(Otros)" Value="0" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            <asp:SqlDataSource ID="SSuministro" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=9 AND szReservado IS NULL ORDER BY nombre" >
                            </asp:SqlDataSource>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Suministro">
                        <EditItemTemplate>
                            <asp:TextBox ID="TSuministro" runat="server" Text='<%# Bind("szSuministro") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese un suministro." ControlToValidate="TSuministro" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TSuministro" runat="server" Text='<%# Bind("szSuministro") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese un suministro." ControlToValidate="TSuministro" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="C. Diurna">
                        <EditItemTemplate>
                            <asp:TextBox ID="TDiurna" runat="server" CssClass="entero" Text='<%# Bind("diurna") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator3" runat="server" ErrorMessage="Por favor ingrese una cantidad." ControlToValidate="TDiurna" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TDiurna" runat="server" CssClass="entero" Text='<%# Bind("diurna") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator3" runat="server" ErrorMessage="Por favor ingrese una cantidad." ControlToValidate="TDiurna" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="C. Nocturna">
                        <EditItemTemplate>
                            <asp:TextBox ID="TNocturna" CssClass="entero" runat="server" Text='<%# Bind("nocturna") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator4" runat="server" ErrorMessage="Por favor ingrese una cantidad." ControlToValidate="TNocturna" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TNocturna" CssClass="entero" runat="server" Text='<%# Bind("nocturna") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator4" runat="server" ErrorMessage="Por favor ingrese una cantidad." ControlToValidate="TNocturna" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <sdg:CustomDataSource ID="SDSuministros" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,diurna,nocturna,suministro,szSuministro FROM suministros_hoja_gastos WHERE id=@id"
                            InsertCommand="INSERT INTO suministros_hoja_gastos(hoja_gastos,diurna,nocturna,suministro,szSuministro) VALUES (@hoja,@diurna,@nocturna,@suministro,@szSuministro)"
                            UpdateCommand="UPDATE suministros_hoja_gastos SET diurna=@diurna,nocturna=@nocturna,suministro=@suministro,szSuministro=@szSuministro WHERE id=@id"
                            ParentDataSource="SSuministros"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GSuministros" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:ControlParameter ControlID="GSuministros" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </UpdateParameters>
        </sdg:CustomDataSource>
        </ContentTemplate>
        </asp:UpdatePanel>
                    </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" 
                        Text="Aceptar" />
                    <asp:Button ID="BCancelar" runat="server" CausesValidation="False" 
                        onclick="BCancelar_Click" Text="Cancelar" />
                </td>
            </tr>
        </table>
    </fieldset>
    <script type="text/javascript">
        $('#ctl00_cph_USuministros').panelUpdated(function() {
            addDialog("#ctl00_cph_USuministros", "#dSuministros");
        });
        $(document).ready(function() {
            $("#ctl00_cph_BFecha").hide();
            $("#ctl00_cph_TFecha").datepicker({
                onClose: function(dateText, inst) { if ($.getUrlVar('f') != $(this).val()) $("#ctl00_cph_BFecha").click(); }
            });
        });
        function iniciopagina() {

            $("#ctl00_cph_TDocumento").blur(function() { if ($.getUrlVar('id') != $(this).val()) $("#ctl00_cph_IBuscar").click(); });
            if ($("#ctl00_cph_DSuministros_DSuministro").length > 0) {
                $("#ctl00_cph_DSuministros_DSuministro").change(function() {
                    $("#ctl00_cph_DSuministros_TSuministro").attr("readonly", $("#ctl00_cph_DSuministros_DSuministro").val() == 0 ? false : true);
                    if ($("#ctl00_cph_DSuministros_DSuministro").val() == 0) {
                       $("#ctl00_cph_DSuministros_TSuministro").val("");
                    } else {
                        $("#ctl00_cph_DSuministros_TSuministro").val($("#ctl00_cph_DSuministros_DSuministro option:selected").text());
                    }
                });
            }
        }
    </script>
</asp:Content>

