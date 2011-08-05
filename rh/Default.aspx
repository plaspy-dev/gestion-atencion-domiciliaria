<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="rh_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#ctl00_cph_BBuscar").hide();
        $("#ctl00_cph_TDocumento").blur(function() { if ($.getUrlVar('id') != $(this).val()) $("#ctl00_cph_BBuscar").click(); });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<fieldset>
<legend>Datos personales</legend>
    <table style="width: 100%;">
        <tr>
            <td>
                Documento<asp:HiddenField ID="HDocumento" runat="server" />
            </td>
            <td>
                <asp:TextBox ID="TDocumento" CssClass="entero" runat="server"></asp:TextBox>
                <asp:Button ID="BBuscar" runat="server" Text="..." CausesValidation="false" 
                    onclick="BBuscar_Click" />
            </td>
            <td>
                Lugar expedición</td>
            <td>
                <asp:TextBox ID="TExpedicion" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Apellidos</td>
            <td>
                <asp:TextBox ID="TApellidos" runat="server"></asp:TextBox>
            </td>
            <td>
                Nombres</td>
            <td>
                <asp:TextBox ID="TNombres" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Libreta militar</td>
            <td>
                <asp:TextBox ID="TLibreta" runat="server"></asp:TextBox>
            </td>
            <td>
                No. distrito</td>
            <td>
                <asp:TextBox ID="TDistrito" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Pasado judicial</td>
            <td>
                <asp:TextBox ID="TPasadoJudicial" runat="server"></asp:TextBox>
            </td>
            <td>
                Fecha expedición</td>
            <td>
                <asp:TextBox ID="TExpedicionPasado" CssClass="fecha" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Certificado inscripción secretaria de salud</td>
            <td>
                <asp:TextBox ID="TCertificadoSalud" runat="server"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Grupo Sanguineo</td>
            <td>
                <asp:DropDownList ID="DGrupoSanguineo" runat="server" DataSourceID="SGrupoSanguineo" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SGrupoSanguineo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=1 AND szReservado IS NULL" >
            </asp:SqlDataSource>
            </td>
            <td>
                Sexo</td>
            <td>
                <asp:DropDownList ID="DSexo" runat="server" DataSourceID="SSexo" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SSexo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=2 AND szReservado IS NULL" >
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>
                Fecha nacimiento</td>
            <td>
                <asp:TextBox ID="TFechaNacimiento" CssClass="fecha" runat="server"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
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
        </tr>
        <tr>
            <td>
                Teléfono</td>
            <td>
                <asp:TextBox ID="TTelefono" runat="server"></asp:TextBox>
            </td>
            <td>
                Teléfono móvil</td>
            <td>
                <asp:TextBox ID="TMovil" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Correo electrónico</td>
            <td>
                <asp:TextBox ID="TEMail" runat="server"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Estado civil</td>
            <td>
                <asp:DropDownList ID="DEstadoCivil" runat="server" DataSourceID="SEstadoCivil" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEstadoCivil" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=3 AND szReservado IS NULL" >
            </asp:SqlDataSource>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                Nombres del cónyuge</td>
            <td colspan="3">
                <asp:TextBox ID="TConyuge" runat="server" Width="100%"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                EPS</td>
            <td>
                <asp:DropDownList ID="DEPS" runat="server" DataSourceID="SEPS" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SEPS" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=4 AND szReservado IS NULL" >
            </asp:SqlDataSource>
            </td>
            <td>
                AFP</td>
            <td>
                <asp:DropDownList ID="DAFP" runat="server" DataSourceID="SAFP" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SAFP" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=6 AND szReservado IS NULL" >
            </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>
                ARP</td>
            <td>
                <asp:DropDownList ID="DARP" runat="server" DataSourceID="SARP" DataTextField="nombre" DataValueField="id">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SARP" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=5 AND szReservado IS NULL" >
            </asp:SqlDataSource>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        </table>
</fieldset>
<fieldset>
    <legend>Nivel educativo</legend>
    <asp:UpdatePanel ID="UNivelEducativo" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="GNivelEducativo" runat="server" DataSourceID="SNivelEducativo" AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
            <Columns>
                <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                <asp:BoundField DataField="nivel" HeaderText="Nivel" />
                <asp:BoundField DataField="ano" HeaderText="" />
                <asp:BoundField DataField="institucion" HeaderText="" />
                <asp:BoundField DataField="titulo" HeaderText="" />
            </Columns>
            <SelectedRowStyle CssClass="selecteditem" />
        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Button ID="BMasNivelEducativo" runat="server" onclick="BMasNivelEducativo_Click" Text="+" />
                    </td>
                </tr>
            </table>
        <sdg:CustomDataSource ID="SNivelEducativo" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,nivel,ano,institucion,titulo FROM nivel_educativo_recurso_humano WHERE recurso_humano=@ingreso"
                            DeleteCommand="DELETE FROM nivel_educativo_recurso_humano WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdIngreso" DefaultValue="0" PropertyName="Value" Name="ingreso" />
                            </SelectParameters>
        </sdg:CustomDataSource>
            <div id="dNivelEducativo" title="Código de diagnóstico">
            <asp:DetailsView ID="DNivelEducativo" runat="server" Width="100%" 
                DataSourceID="SDNivelEducativo" DataKeyNames="id" 
                AutoGenerateRows="False" DefaultMode="Edit" 
                oniteminserted="DNivelEducativo_ItemInserted" 
                onitemupdated="DNivelEducativo_ItemUpdated" 
                onitemcommand="DNivelEducativo_ItemCommand">
                <Fields>
                    <asp:TemplateField HeaderText="codigo">
                        <EditItemTemplate>
                            <asp:TextBox ID="TCodigo" Width="200px" runat="server" Text='<%# Bind("codigo") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor seleccione un código." ControlToValidate="TDescripcion" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TCodigo" Width="200px" runat="server" Text='<%# Bind("codigo") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor seleccione un código." ControlToValidate="TDescripcion" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("codigo") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="descripcion">
                        <EditItemTemplate>
                            <asp:TextBox ID="TDescripcion" Width="200px" runat="server" Text='<%# Bind("descripcion") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TDescripcion" Width="200px" runat="server" Text='<%# Bind("descripcion") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("descripcion") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <sdg:CustomDataSource ID="SDNivelEducativo" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,codigo,descripcion FROM codigos_ingreso WHERE id=@id"
                            InsertCommand="INSERT INTO codigos_ingreso(ingreso_paciente,codigo,descripcion) VALUES (@ingreso, @codigo, @descripcion)"
                            UpdateCommand="UPDATE codigos_ingreso SET codigo=@codigo,descripcion=@descripcion WHERE id=@id" 
                            ParentDataSource="SNivelEducativo"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GNivelEducativo" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:ControlParameter ControlID="GNivelEducativo" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </UpdateParameters>
        </sdg:CustomDataSource>
        </ContentTemplate>
        </asp:UpdatePanel>
</fieldset>
<fieldset>
    <legend>Información laboral</legend>
    
</fieldset>
<fieldset>
    <legend>Espacio reservado para la empresa</legend>
</fieldset>
<div style="text-align: right">
    <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
        onclick="BAceptar_Click" />
    <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
        CausesValidation="false" onclick="BCancelar_Click" />
</div>
</asp:Content>