<%@ Page Title="Ubicación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ubicacion.aspx.cs" Inherits="evento_ubicacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
        autoComplete({ controlId: "<%= TNombre.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Ubicacion")%>", selectURL: "<%= Request.Url.AbsolutePath + "?ubid=" %>" });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table class="table table-striped table-condensed">
        <tr>
            <td>Nombre<asp:RequiredFieldValidator ControlToValidate="TNombre" ErrorMessage="Por favor ingrese un nombre." ID="R1" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TNombre"></asp:TextBox></td>
            <td>Descripción</td>
            <td><asp:TextBox runat="server" ID="TDescripcion"></asp:TextBox></td>
        </tr>
    <tr>
        <td colspan="4" class="well">Documentos</td>
    </tr>
    <tr>
        <td colspan="4">
                <asp:GridView ID="GDocumentos" runat="server" AutoGenerateColumns="False" DataSourceID="SDocumentos" EmptyDataText="No se encontraron documentos" 
                    CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="id" OnRowDeleting="GDocumentos_RowDeleting" ShowHeader="false">
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <Columns>
                    <asp:TemplateField ItemStyle-Width="1px">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" ID="D" CssClass="btn btn-danger btn-xs" CausesValidation="False" CommandName="Delete" ToolTip="Eliminar"><i class="fa fa-trash-o"></i></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Documento" ItemStyle-Width="100%">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="L" Visible='<%# Eval("archivo") == DBNull.Value %>' Text='<%# Eval("nombre") %>'></asp:Label>
                            <asp:HyperLink runat="server" Visible='<%# Eval("archivo") != DBNull.Value %>' ID="H" Text='<%# Eval("nombre") %>' NavigateUrl='<%# Eval("archivo")==DBNull.Value ? "" : Files.GetURL(Files.Directorys.UbicacionDocumentos, Files.ContentDisposition.Attachment, ViewState["id"], Eval("id"), Eval("Nombre").ToString() + Eval("archivo")) %>'></asp:HyperLink>
                            <asp:CustomValidator Display="Dynamic" ControlToValidate="F" ID="C" runat="server" ClientValidationFunction="ValidateFileUploadJPGPDF" ErrorMessage="Por favor seleccione una imagen en formato jpg o un archivo PDF" onservervalidate="OnValidaFileJPGPDF">*</asp:CustomValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Archivo">
                        <ItemTemplate>
                            <asp:FileUpload runat="server" ID="F" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
                <asp:SqlDataSource ID="SDocumentos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id, varios.nombre,documentos_ubicacion.archivo
                        FROM varios 
                        LEFT JOIN documentos_ubicacion ON (documentos_ubicacion.ubicacion=@ubicacion AND documentos_ubicacion.documento=varios.id)
                        WHERE varios.tipo=18 AND varios.eliminado IS NULL ORDER BY nombre">
                      <SelectParameters>
                          <asp:Parameter Name="ubicacion" DefaultValue="0" />
                      </SelectParameters>
                </asp:SqlDataSource>
        </td>
    </tr>
        <tr>
            <td colspan="4">
                <asp:Label runat="server" ID="LMessage" ForeColor="Red"></asp:Label>
                <asp:ValidationSummary runat="server" ID="V" />
            </td>
        </tr>
        <tr>
            <td colspan="4" class="r">
                <asp:Button runat="server" ID="BEliminar" CssClass="btn btn-danger pull-left" Text="Eliminar" Visible="false" OnClick="BEliminar_Click" />
                <asp:Button runat="server" ID="BAceptar" CssClass="btn btn-submit" Text="Aceptar" OnClick="BAceptar_Click" />
                <asp:Button runat="server" id="BCancelar" CssClass="btn btn-default" Text="Cancelar" OnClick="BCancelar_Click" CausesValidation="false" />
            </td>
        </tr>
</table>
</asp:Content>

