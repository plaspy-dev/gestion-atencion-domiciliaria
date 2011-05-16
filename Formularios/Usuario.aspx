<%@ Page Title="Usuarios" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="Usuario.aspx.vb" Inherits="ML.Usuario" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

    <asp:Panel id="pnlCons" runat="server" style="text-align: center">
                <asp:GridView ID="grvUsuarios" runat="server" AllowSorting="True" 
                    AutoGenerateColumns="False" EmptyDataText="No hay usuarios Registrados">
                    <Columns>
                        <asp:BoundField DataField="IdUsuario" HeaderText="Usuario" 
                            SortExpression="idUsuario" />
                        <asp:BoundField DataField="NombreUsuario" HeaderText="Nombre" 
                            SortExpression="NombreUsuario" />
                        <asp:CheckBoxField DataField="Activo" HeaderText="Activo" />
                        <asp:CommandField EditText="Editar" HeaderText="Editar" ShowEditButton="True" />
                        <asp:CommandField DeleteText="Eliminar" HeaderText="Eliminar" 
                            ShowDeleteButton="True" />
                        <asp:ButtonField AccessibleHeaderText="Per..." CommandName="PERMISOS" 
                            HeaderText="Permisos" Text="&nbsp Permisos &nbsp" />
                        <asp:ButtonField AccessibleHeaderText="Per..." CommandName="PERMISOSESPE" 
                            HeaderText="Permisos" Text="&nbsp Permisos Especiales &nbsp" />
                        <asp:ButtonField AccessibleHeaderText="Per..." CommandName="ALERTAS" 
                            HeaderText="Alertas" Text="&nbsp Alertas &nbsp" />                            
                    </Columns>
                </asp:GridView>
</asp:Panel>
<asp:Panel id="pnlIns" runat="server" Visible="false" >
    <table class="style1">
        <tr>
            
            <td>
                <asp:Label ID="Label1" runat="server" Text="Usuario"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtUsuario" runat="server" MaxLength="25"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="txtUsuario" Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Nombre"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtNombre" runat="server" MaxLength="50"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="txtNombre" Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="Clave"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtClave" runat="server" MaxLength="25" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvClave" runat="server" 
                    ControlToValidate="txtClave" Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:CheckBox ID="chkActivo" runat="server" Text="Activo?" />
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center">            
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" />
            </td>
        </tr>
    </table>
    </asp:Panel>
    <asp:Panel id="pnlPerEspe" runat="server" Visible="false" >
        <asp:GridView ID="grvPer" runat="server" AutoGenerateColumns="False" DataKeyNames="perIdPermiso" EmptyDataText="No hay permisos disponibles">
            <Columns>
                <asp:BoundField DataField="perDescripcion" HeaderText="Permiso Especial" />
                <asp:TemplateField HeaderText="Asignado?">
                    <ItemTemplate>
                        <ml:CheckBox ID="chkAsig" runat="server" Checked='<%#bind("asignado")%>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        
        
    
        <br />
        <asp:LinkButton ID="lnkAceptar" runat="server">Aceptar</asp:LinkButton>
        &nbsp;&nbsp;&nbsp;
        <asp:LinkButton ID="lnkCancelar" runat="server">Cancelar</asp:LinkButton>
        
        
    
    </asp:Panel>
        <asp:Panel id="pnlAlertas" runat="server" Visible="false" >
        <asp:GridView ID="grvAlertas" runat="server" AutoGenerateColumns="False" DataKeyNames="tarId" EmptyDataText="No hay permisos disponibles">
            <Columns>
                <asp:BoundField DataField="tarTitulo" HeaderText="Alerta" />
                <asp:TemplateField HeaderText="Asignado?">
                    <ItemTemplate>
                        <ml:CheckBox ID="chkAsig" runat="server" Checked='<%#bind("asignado")%>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <br />
        <asp:LinkButton ID="lnkAceptarAl" runat="server">Aceptar</asp:LinkButton>
        &nbsp;&nbsp;&nbsp;
        <asp:LinkButton ID="lnkCancelarAl" runat="server">Cancelar</asp:LinkButton>
        
        
    
    </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>

</asp:Content>
