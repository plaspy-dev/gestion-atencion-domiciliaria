<%@ Page Title="Usuarios" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="usuario.aspx.cs" Inherits="administrador_usuario" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
        <table>
        <tr>
            <td>
                Nombres<asp:HiddenField ID="HId" runat="server" /><asp:HiddenField ID="HUsuario" runat="server" />
            </td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TNombres" Display="Dynamic" ErrorMessage="Por favor ingrese un nombre." SetFocusOnError="True"></asp:RequiredFieldValidator>
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
            <td>Grupo</td>
            <td>
                <asp:DropDownList ID="DGrupos" runat="server" DataSourceID="SGrupos" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true" CssClass="anchomaxcombo">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                    <asp:ListItem Text="Administrador" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SGrupos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM grupo ORDER BY nombre" >
            </asp:SqlDataSource>
            </td>
            <td><asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="DGrupos" Display="Dynamic" ErrorMessage="Por favor seleccione un grupo." SetFocusOnError="True"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td>
                Contraseña</td>
            <td>
                <asp:TextBox ID="TContrasena" TextMode="Password" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RContrasena" runat="server" ControlToValidate="TContrasena" Display="Dynamic" ErrorMessage="Por favor ingrese una contraseña." SetFocusOnError="True"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Confirmar contraseña</td>
            <td>
                <asp:TextBox ID="TConfirmar" TextMode="Password" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="TContrasena" ControlToValidate="TConfirmar" Display="Dynamic" ErrorMessage="Las contraseñas no coinciden." SetFocusOnError="True"></asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td>Estado</td>
            <td><asp:Label runat="server" ID="LEstado"></asp:Label></td>
        </tr>
        <tr>
            <td></td>
            <td>&nbsp;</td>
            <td align="right" nowrap="nowrap">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" onclick="BAceptar_Click" CssClass="btn btn-submit" />
                <asp:Button ID="BCancelar" runat="server" Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" CssClass="btn btn-default" />
            </td>
        </tr>
    </table>
    <asp:GridView ID="GUsuarios" runat="server" DataSourceID="SUsuarios"  Width="100%"
        DataKeyNames="id" AutoGenerateColumns="false" 
        onselectedindexchanged="GUsuarios_SelectedIndexChanged" 
        AllowSorting="True" AllowPaging="true" PageSize="50" CssClass="table table-condensed table-bordered table-hover table-striped">
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <Columns>
        <asp:TemplateField ItemStyle-Width="1px">
            <ItemTemplate>
                <asp:LinkButton runat="server" ID="S" CssClass="btn btn-success btn-xs" CausesValidation="False" CommandName="Select" ToolTip="Editar"><i class="fa fa-edit"></i></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField ItemStyle-Width="1px">
            <ItemTemplate>
                <asp:LinkButton runat="server" ID="D" CssClass="btn btn-danger btn-xs" CausesValidation="False" CommandName="Delete" ToolTip="Eliminar"><i class="fa fa-trash-o"></i></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
                    <asp:BoundField DataField="nombre" HeaderText="Nombres" SortExpression="nombre" ItemStyle-Width="100%" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="usuario" HeaderText="Usuario" SortExpression="usuario" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="grupo" HeaderText="Grupo" SortExpression="grupo" ItemStyle-Wrap="false" />
                    <asp:BoundField DataField="ingreso" HeaderText="Último ingreso" SortExpression="ingreso" ItemStyle-Wrap="false" />
                    <asp:TemplateField HeaderText="Inactivo" SortExpression="estado" ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:CheckBox ID="I" runat="server" Checked='<%# Eval("estado").ToString()=="0" %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
        </Columns>
        <SelectedRowStyle CssClass="selecteditem" />
    </asp:GridView>
    <asp:SqlDataSource ID="SUsuarios" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT usuario.id AS id,usuario.nombre AS nombre,usuario.usuario AS usuario,IFNULL(grupo.nombre,'Administrador') AS grupo,usuario.ingreso AS ingreso
                        ,usuario.estado
                        FROM usuario 
                        LEFT JOIN grupo ON (usuario.grupo=grupo.id) 
                        WHERE usuario.estado IS NULL OR usuario.estado!=-1 
                        ORDER BY usuario.nombre" 
                 DeleteCommand="UPDATE usuario SET estado=-1 WHERE id=@id">
    </asp:SqlDataSource>
</asp:Content>

