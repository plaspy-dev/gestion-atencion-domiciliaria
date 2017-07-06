<%@ Page Title="Funcionario" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="funcionario.aspx.cs" Inherits="rh_funcionario" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
    .firma {
        max-width: 100%;
        max-height: 200px;
    }
</style>
<script type="text/javascript">
    autoComplete({ controlId: "<%= TDocumento.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/RH")%>", selectURL: "<%= Request.Url.AbsolutePath + "?fid=" %>" });
    autoComplete({ controlId: "<%= TNombres.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/RH")%>", selectURL: "<%= Request.Url.AbsolutePath + "?fid=" %>" });
    autoComplete({ controlId: "<%= TApellidos.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/RH")%>", selectURL: "<%= Request.Url.AbsolutePath + "?fid=" %>" });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table class="table table-striped table-condensed">
        <tr>
            <td>Documento<asp:RequiredFieldValidator ControlToValidate="TDocumento" ErrorMessage="Por favor ingrese un documento." ID="R1" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td>
                <asp:UpdatePanel runat="server" ID="UD" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:TextBox runat="server" ID="TDocumento" CssClass="likenumber" AutoPostBack="true" OnTextChanged="TDocumento_TextChanged"></asp:TextBox>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
            <td>Genero<asp:RequiredFieldValidator ControlToValidate="DGenero" ErrorMessage="Por favor selecione un genero." ID="R4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:DropDownList ID="DGenero" runat="server" CssClass="amd">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                    <asp:ListItem Text="Masculino" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Femenino" Value="2"></asp:ListItem>
                </asp:DropDownList></td>
        </tr>
        <tr>
            <td>Apellidos<asp:RequiredFieldValidator ControlToValidate="TApellidos" ErrorMessage="Por favor ingrese un apellido." ID="R2" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TApellidos"></asp:TextBox></td>
            <td>Nombres<asp:RequiredFieldValidator ControlToValidate="TNombres" ErrorMessage="Por favor ingrese un nombre." ID="R3" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><asp:TextBox runat="server" ID="TNombres"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Ingreso</td>
            <td class="nw"><asp:TextBox runat="server" ID="TIngreso" CssClass="fecha"></asp:TextBox>
                <asp:CheckBox runat="server" ID="CContrato" Text="Contrato" />
            </td>
            <td>Nacimiento</td>
            <td><asp:TextBox runat="server" ID="TNacimiento" CssClass="fecha"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Dirección</td>
            <td><asp:TextBox runat="server" ID="TDireccion"></asp:TextBox></td>
            <td>Barrio</td>
            <td><asp:TextBox runat="server" ID="TBarrio"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Teléfonos</td>
            <td><asp:TextBox runat="server" ID="TTelefonos"></asp:TextBox></td>
            <td>Celular</td>
            <td><asp:TextBox runat="server" ID="TCelular"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Estado civil</td>
            <td><asp:DropDownList ID="DEstadoCivil" runat="server" DataSourceID="SEstadoCivil" 
                    DataTextField="nombre" DataValueField="id" CssClass="amd" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstadoCivil" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=1 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td>Cónyugue</td>
            <td><asp:TextBox runat="server" ID="TConyugue"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Contacto</td>
            <td><asp:TextBox runat="server" ID="TContacto"></asp:TextBox></td>
            <td>Teléfono</td>
            <td><asp:TextBox runat="server" ID="TTelContacto"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Parentesco</td>
            <td><asp:TextBox runat="server" ID="TParentesco"></asp:TextBox></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Cargo</td>
            <td><asp:DropDownList ID="DCargo" runat="server" DataSourceID="SCargo" 
                    DataTextField="nombre" DataValueField="id" CssClass="amd" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SCargo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=5 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td>EPS</td>
            <td><asp:DropDownList ID="DEPS" runat="server" DataSourceID="SEPS" 
                    DataTextField="nombre" DataValueField="id" CssClass="amd" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEPS" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=2 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>ARP</td>
            <td><asp:DropDownList ID="DARP" runat="server" DataSourceID="SARP" 
                    DataTextField="nombre" DataValueField="id" CssClass="amd" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SARP" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=3 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td>FOP</td>
            <td><asp:DropDownList ID="DFOP" runat="server" DataSourceID="SFOP" 
                    DataTextField="nombre" DataValueField="id" CssClass="amd" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SFOP" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=4 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Teminación</td>
            <td><asp:TextBox runat="server" CssClass="fecha" ID="TTerminacion"></asp:TextBox></td>
            <td>Motivo</td>
            <td><asp:DropDownList ID="DTerminacion" runat="server" DataSourceID="STerminacion" 
                    DataTextField="nombre" DataValueField="id" CssClass="amd" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="STerminacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=6 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        </tr>
        <tr>
            <td>Empresas</td>
            <td colspan="3"><asp:TextBox runat="server" Width="100%" ID="TEmpresas"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="tdr tdl" style="padding: 0">
                <asp:GridView ID="GDocumentos" runat="server" AutoGenerateColumns="False" DataSourceID="SDocumentos" EmptyDataText="No se encontraron documentos" 
                    CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="id" OnRowDeleting="GDocumentos_RowDeleting">
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
                            <asp:HyperLink runat="server" Visible='<%# Eval("archivo") != DBNull.Value %>' ID="H" Text='<%# Eval("nombre") %>' NavigateUrl='<%# Eval("archivo")==DBNull.Value ? "" : Files.GetURL(Files.Directorys.RHDocumentos, Files.ContentDisposition.Attachment, ViewState["id"], Eval("id"), Eval("Nombre").ToString() + Eval("archivo")) %>'></asp:HyperLink>
                            <asp:CustomValidator Display="Dynamic" ControlToValidate="F" ID="C" runat="server" ClientValidationFunction="ValidateFileUploadJPGPDF" ErrorMessage="Por favor seleccione una imagen en formato jpg o un archivo PDF" onservervalidate="OnValidaFileJPGPDF">*</asp:CustomValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Archivo">
                        <ItemTemplate>
                            <asp:FileUpload runat="server" ID="F" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Vencimiento">
                        <ItemTemplate>
                            <asp:TextBox runat="server" ID="T" CssClass="fecha" Text='<%# SDG.Componentes.Query.GetFromMySQLDate(Eval("vencimiento")) %>'></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
                <asp:SqlDataSource ID="SDocumentos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id, varios.nombre,rh_documento.archivo,rh_documento.vencimiento
                        FROM varios 
                        LEFT JOIN rh_documento ON (rh_documento.funcionario=@funcionario AND rh_documento.documento=varios.id)
                        WHERE varios.tipo=7 AND varios.eliminado IS NULL ORDER BY nombre">
                      <SelectParameters>
                          <asp:Parameter Name="funcionario" DefaultValue="0" />
                      </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td class="well" colspan="2">Firma<asp:CustomValidator Display="Dynamic" ControlToValidate="FFirma" ID="C1" runat="server" ClientValidationFunction="ValidateFileUploadJPG" ErrorMessage="Por favor seleccione una imagen en formato jpg" onservervalidate="OnValidaFileJPG">*</asp:CustomValidator></td>
            <td class="well" colspan="2">Sello<asp:CustomValidator Display="Dynamic" ControlToValidate="FSello" ID="C2" runat="server" ClientValidationFunction="ValidateFileUploadJPG" ErrorMessage="Por favor seleccione una imagen en formato jpg" onservervalidate="OnValidaFileJPG">*</asp:CustomValidator></td>
        </tr>
        <tr>
            <td class="tdl tdr" colspan="2"><asp:Image runat="server" CssClass="firma" ID="IFirma" /></td>
            <td class="tdr" colspan="2"><asp:Image runat="server" CssClass="firma" ID="ISello" /></td>
        </tr>
        <tr>
            <td class="tdl tdr" colspan="2"><asp:FileUpload runat="server" ID="FFirma" /></td>
            <td class="tdr" colspan="2"><asp:FileUpload runat="server" ID="FSello" /></td>
        </tr>
        <tr>
            <td colspan="4"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
                <asp:ValidationSummary runat="server" ID="V" />
            </td>
        </tr>
        <tr>
            <td colspan="4" class="r">
                <asp:Button runat="server" ID="BAceptar" CssClass="btn btn-submit" Text="Aceptar" OnClick="BAceptar_Click" />
                <asp:Button runat="server" ID="BCancelar" CssClass="btn btn-default" Text="Cancelar" CausesValidation="false" OnClick="BCancelar_Click" />
            </td>
        </tr>
    </table>
</asp:Content>

