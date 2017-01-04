<%@ Page Title="Parámetros" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="administrador_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel ID="Panel1" runat="server" DefaultButton="BAceptar">
    <table width="100%" border="0">
  <tr>
    <td valign="top">
        <asp:TreeView ID="TTipo" runat="server"  ImageSet="Arrows" >
            <ParentNodeStyle Font-Bold="False" />
            <HoverNodeStyle Font-Underline="True" ForeColor="#5555DD" />
            <SelectedNodeStyle Font-Underline="True" ForeColor="#5555DD" HorizontalPadding="0px" VerticalPadding="0px" />
            <NodeStyle Font-Names="Verdana" ForeColor="Black" HorizontalPadding="5px" NodeSpacing="0px" VerticalPadding="0px" />
        </asp:TreeView>
        <br />
      </td>
    <td valign="top"><table width="100%" border="0">
      <tr>
        <td align="left" bgcolor="#406BAF" style="color: #FFF">
            <asp:Label ID="LTipo" runat="server"></asp:Label>
          </td>
      </tr>
      <tr>
        <td>
<table width="100%" border="0">
          <tr>
            <td>Nombre</td>
            <td>
                <asp:TextBox ID="TNombre" runat="server"></asp:TextBox>
              </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="TNombre" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un nombre." SetFocusOnError="True"></asp:RequiredFieldValidator>
              </td>
          </tr>
          <tr>
            <td>Descripción</td>
            <td>
                <asp:TextBox ID="TDescripcion" runat="server" EnableViewState="False"></asp:TextBox>
              </td>
            <td align="right">
                <asp:HiddenField ID="HId" runat="server" />
              </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" onclick="BAceptar_Click" CssClass="btn btn-submit" />
                <asp:Button ID="BCancelar" runat="server" CausesValidation="False" Text="Cancelar" onclick="BCancelar_Click" CssClass="btn btn-default" />
              </td>
            <td>
                <asp:HiddenField ID="HTipo" runat="server" />
              </td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td>
            <asp:GridView ID="GResultado" runat="server" AutoGenerateColumns="False" Width="100%"
                DataKeyNames="id" DataSourceID="SqlDataSource1" CssClass="table table-condensed table-bordered table-hover table-striped"
                onselectedindexchanged="GResultado_SelectedIndexChanged" >
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
                    <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" ItemStyle-Width="100%" />
                    <asp:BoundField DataField="descripcion" HeaderText="Descripción" SortExpression="descripcion" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre, descripcion FROM varios WHERE tipo=@tipo AND eliminado IS NULL" 
                DeleteCommand="UPDATE varios SET eliminado=SYSDATE() WHERE id=@id" >
                <SelectParameters>
                    <asp:QueryStringParameter QueryStringField="tipo" Name="tipo" Type="Int32" DefaultValue="1" />
                </SelectParameters>
            </asp:SqlDataSource>
          </td>
      </tr>
    </table></td>
  </tr>
</table>
</asp:Panel>
</asp:Content>

