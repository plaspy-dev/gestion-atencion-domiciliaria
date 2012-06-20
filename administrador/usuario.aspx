<%@ Page Title="Usuario" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="usuario.aspx.cs" Inherits="administrador_usuario" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#accordion").accordion({
            autoHeight: false,
            navigation: true,
            collapsible: true,
            active: -1
        });
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
                var nombre = ui.item.label;
                var pos = nombre.indexOf(" - ");
                if (pos != -1) {
                    nombre = nombre.substring(pos + 3);
                }
                $("#<%= TNombres.ClientID %>").val(nombre);
                $("#<%= TIdPersonal.ClientID %>").val(ui.item.value);
                return false;
            },
            search: function(event, ui) {
                $("#<%= TIdPersonal.ClientID %>").val("");
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <fieldset>
        <legend>Usuario</legend>
        <table>
        <tr>
            <td>
                Nombres<asp:HiddenField ID="HId" runat="server" /><asp:HiddenField ID="HUsuario" runat="server" />
            </td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
                <asp:TextBox ID="TIdPersonal" runat="server" CssClass="hide"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="TNombres" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un nombre." SetFocusOnError="True"></asp:RequiredFieldValidator>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                    ControlToValidate="TIdPersonal" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un nombre." SetFocusOnError="True"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Usuario</td>
            <td>
                <asp:TextBox ID="TUsuario" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="TUsuario" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un usuario." SetFocusOnError="True"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Grupo</td>
            <td>
                <asp:DropDownList ID="DGrupos" runat="server" DataSourceID="SGrupos" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="Administrador" Value="0" Selected="True"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SGrupos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM grupo" >
            </asp:SqlDataSource>
            </td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Contraseña</td>
            <td>
                <asp:TextBox ID="TContrasena" TextMode="Password" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RContrasena" runat="server" 
                    ControlToValidate="TContrasena" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese una contraseña." SetFocusOnError="True"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Confirmar contraseña</td>
            <td>
                <asp:TextBox ID="TConfirmar" TextMode="Password" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ControlToCompare="TContrasena" ControlToValidate="TConfirmar" Display="Dynamic" 
                    ErrorMessage="Las contraseñas no coinciden." SetFocusOnError="True"></asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <div id="accordion">
                    <h3><a href="#">Cargos a programar</a></h3>
                    <div class="hide">
                        <asp:GridView ID="GCargos" runat="server" DataSourceID="SCargos" 
                            DataKeyNames="id" AutoGenerateColumns="false" ShowHeader="false"
                            AllowSorting="True" onrowdatabound="GCargos_RowDataBound">
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField HeaderText="Permiso">
                                    <ItemTemplate>
                                        <asp:CheckBox runat="server" ID="CCargo" Checked="false" Text='<%# Eval("nombre").ToString() %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SCargos" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                                SelectCommand="SELECT carId id,carDescripcion nombre FROM dbo.admCargo ORDER BY 2;">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="HUsuario" Name="usuario" PropertyName="Value" DefaultValue=" " />
                                    </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <h3><a href="#">Permisos especiales</a></h3>
                    <div style="display: none">
                <asp:GridView ID="GEspeciales" runat="server" DataSourceID="SEspeciales" 
                    DataKeyNames="perIdPermiso" AutoGenerateColumns="false" ShowHeader="false"
                    AllowSorting="True">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Permiso">
                            <ItemTemplate>
                                <asp:CheckBox runat="server" ID="CPermiso" Checked='<%# Eval("usIdUsuario").ToString()!="" %>' Text='<%# Eval("perDescripcion").ToString() %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>        
                </asp:GridView>
                <asp:SqlDataSource ID="SEspeciales" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT segPermiso.perIdPermiso,segPermiso.perDescripcion, segPermisoEspecial.usIdUsuario
                                    FROM segPermiso
                                    LEFT JOIN segPermisoEspecial ON (segPermisoEspecial.usIdUsuario=@usuario AND segPermisoEspecial.perIdPermiso= segPermiso.perIdPermiso)
                                    ORDER BY segPermiso.perDescripcion
                                    ;">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HUsuario" Name="usuario" PropertyName="Value" DefaultValue=" " />
                            </SelectParameters>
                </asp:SqlDataSource>
                </div>
                    <h3><a href="#">Alertas</a></h3>
                    <div style="display: none">                
                <asp:GridView ID="GAlertas" runat="server" DataSourceID="SAlertas" 
                    DataKeyNames="tarId" AutoGenerateColumns="false" ShowHeader="false"
                    AllowSorting="True">
                    <RowStyle CssClass="GridRow"></RowStyle>
                    <FooterStyle CssClass="GridFooter"></FooterStyle>
                    <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Alerta">
                            <ItemTemplate>
                                <asp:CheckBox runat="server" ID="CPermiso" Checked='<%# Eval("usIdUsuario").ToString()!="" %>' Text='<%# Eval("tarTitulo").ToString() %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SAlertas" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT genTareas.tarId,genTareas.tarTitulo, GenUsuarioTarea.usIdUsuario
                                    FROM genTareas
                                    LEFT JOIN GenUsuarioTarea ON (GenUsuarioTarea.usIdUsuario=@usuario AND GenUsuarioTarea.tarId=genTareas.tarId)
                                    ORDER BY genTareas.tarTitulo
                                    ;">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HUsuario" Name="usuario" PropertyName="Value" DefaultValue=" " />
                            </SelectParameters>
                </asp:SqlDataSource>                  
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Button ID="BMigrar" Visible="false" runat="server" CausesValidation="False" OnClientClick="return confirm('Esta acción modificara los permisos de los ususarios, ¿esta seguro de continuar?')"
                    onclick="BMigrar_Click" Text="Migrar usuarios" />
            </td>
            <td>
                &nbsp;</td>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" onclick="BAceptar_Click" OnClientClick="return confirm('Esta acción reemplazara los permisos del usuario. ¿Esta seguro de continuar?');" />
                <asp:Button ID="BCancelar" runat="server" Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
    </fieldset>
    <asp:GridView ID="GUsuarios" runat="server" DataSourceID="SUsuarios" 
        DataKeyNames="id" AutoGenerateColumns="false" 
        onselectedindexchanged="GUsuarios_SelectedIndexChanged" 
        AllowSorting="True" onrowdeleted="GUsuarios_RowDeleted" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
                    <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                    <asp:BoundField DataField="nombre" HeaderText="Nombres" SortExpression="nombre" />
                    <asp:BoundField DataField="usuario" HeaderText="Usuario" SortExpression="usuario" />
                    <asp:BoundField DataField="grupo" HeaderText="Grupo" SortExpression="grupo" />
                    <asp:BoundField DataField="ingreso" HeaderText="Último ingreso" SortExpression="ingreso" />
                    <asp:BoundField DataField="personal" HeaderText="PersonalID" SortExpression="personal" ItemStyle-CssClass="hide" HeaderStyle-CssClass="hide" />
        </Columns>
        <SelectedRowStyle CssClass="selecteditem" />
    </asp:GridView>
    <asp:SqlDataSource ID="SUsuarios" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT usuario.id AS id,usuario.nombre AS nombre,usuario.usuario AS usuario,IFNULL(grupo.nombre,'Administrador') AS grupo,usuario.ingreso AS ingreso,usuario.personal FROM usuario LEFT JOIN grupo ON (usuario.grupo=grupo.id) WHERE usuario.estado IS NULL OR usuario.estado!=-1 ORDER BY usuario.nombre" 
                 DeleteCommand="UPDATE usuario SET estado=-1 WHERE id=@id">
    </asp:SqlDataSource>
</asp:Content>

