<%@ Page Title="Ambulancia" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ambulancia.aspx.cs" Inherits="ambulancia_ambulancia" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">        
.p1 div {
    padding-top: 1px;
    padding-bottom: 1px;
}
</style>
<script type="text/javascript">
    autoComplete({ controlId: "<%= TNIT.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Empresa")%>", selectURL: "<%= Request.Url.AbsolutePath + "?eid=" %>" });
    autoComplete({ controlId: "<%= TEmpresa.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Empresa")%>", selectURL: "<%= Request.Url.AbsolutePath + "?eid=" %>" });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table class="table table-striped table-condensed">
    <tr>
        <td>NIT</td>
        <td><asp:TextBox runat="server" ID="TNIT"></asp:TextBox></td>
        <td>Empresa</td>
        <td><asp:TextBox runat="server" ID="TEmpresa"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Representante Legal</td>
        <td><asp:TextBox runat="server" ID="TRepresentanteLegal"></asp:TextBox></td>
        <td>Código prestador</td>
        <td><asp:TextBox runat="server" ID="TCodigo"></asp:TextBox></td>
    </tr>
    <tr>
        <td colspan="4" class="well">Contacto programación</td>
    </tr>
    <tr>
        <td class="tdl">Teléfono</td>
        <td><asp:TextBox runat="server" ID="TTelefono"></asp:TextBox></td>
        <td>Celular</td>
        <td class="tdr"><asp:TextBox runat="server" ID="TCelular"></asp:TextBox></td>
    </tr>
    <tr>
        <td colspan="4" class="well">Capacidad</td>
    </tr>
    <tr>
        <td colspan="4" class="tdr tdl">
            <div class="row p1">
            <asp:Repeater runat="server" id="RCapacidad" DataSourceID="SCapacidad">
                <ItemTemplate><div class="col-sm-3"><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /> <%# Eval("Nombre") %></div><div class="col-sm-3"><asp:TextBox runat="server" ID="T" Text='<%# Eval("valor") %>' CssClass="entero"></asp:TextBox></div></ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="SCapacidad" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id, varios.nombre,empresa_capacidad.valor
                    FROM varios 
                    LEFT JOIN empresa_capacidad ON (empresa_capacidad.empresa=@empresa AND empresa_capacidad.tipo=varios.id)
                    WHERE varios.tipo=13 AND varios.eliminado IS NULL ORDER BY nombre">
                <SelectParameters>
                    <asp:Parameter Name="empresa" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
            </div>
            <div class="row">
                <div class="col-sm-3">Descripción Otros</div><div class="col-sm-9"><asp:TextBox runat="server" ID="TOtros" Width="100%"></asp:TextBox></div>
            </div>
        </td>
    </tr>
    <tr>
        <td colspan="4" class="well">Ambulancias</td>
    </tr>
    <tr>
        <td colspan="4" class="tdl tdr">
            <asp:UpdatePanel runat="server" ID="UA" UpdateMode="Conditional">
                <ContentTemplate>
            <asp:GridView ID="GAmbulancias" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encontraron ambulancias" 
                CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="Id"
                OnSelectedIndexChanged="GAmbulancias_SelectedIndexChanged" OnRowDeleting="GAmbulancias_RowDeleting">
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
                    <asp:BoundField DataField="Placa" HeaderText="Placa" SortExpression="Placa" />
                    <asp:BoundField DataField="Propietario" HeaderText="Propietario" SortExpression="Propietario" />
                </Columns>
            </asp:GridView>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="BCancelA" />
                </Triggers>
            </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td colspan="4" class="r"><button type="button" id="badd" class="btn btn-submit" data-toggle="modal" data-target="#addAmbulance"><i class="fa fa-plus"></i></button></td>
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
    <asp:UpdatePanel runat="server" ID="U" UpdateMode="Conditional">
        <ContentTemplate>
<div id="addAmbulance" class="modal fade" role="dialog" data-keyboard="false" data-backdrop="static">
    <div class="modal-dialog modal-lg">
    <!-- Modal content-->
    <div class="modal-content">
        <div class="modal-header">
        <h4 class="modal-title">Ambulancia</h4>
        </div>
        <div class="modal-body">
            <table class="table table-striped table-condensed">
                <tr>
                    <td>Placa<asp:RequiredFieldValidator ControlToValidate="TPlaca" ErrorMessage="Por favor ingrese una placa." ValidationGroup="ambulancia" ID="R1" 
	                            runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                    <td><asp:TextBox runat="server" ID="TPlaca"></asp:TextBox></td>
                    <td>Propietario</td>
                    <td><asp:TextBox runat="server" ID="TPropietario"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="4">
                        <asp:GridView ID="GAtributos" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encontraron atributos" 
                            CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="Tipo,FileExt">
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <Columns>
                                <asp:TemplateField HeaderText="Atributo" ItemStyle-Width="100%" ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <asp:HyperLink runat="server" ID="H" Text='<%# Eval("nombre") %>' NavigateUrl='<%# Eval("FileExt")==null || (bool)Eval("FileNew")==true ? "" : Files.GetURL(Files.Directorys.Ambulancia, Files.ContentDisposition.Attachment, ViewState["idAmbulancia"], Eval("Tipo"), Eval("Nombre").ToString() + Eval("FileExt")) %>'></asp:HyperLink>
                                        <asp:CustomValidator Display="Dynamic" ControlToValidate="D" ID="C" runat="server" ClientValidationFunction="ValidateFileUploadJPGPDF" ErrorMessage="Por favor seleccione una imagen en formato jpg o un archivo PDF" onservervalidate="OnValidaFileJPGPDF">*</asp:CustomValidator>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Archivo">
                                    <ItemTemplate>
                                        <asp:FileUpload runat="server" ID="D" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Observaciones" ItemStyle-Width="100%">
                                    <ItemTemplate>
                                        <asp:TextBox runat="server" ID="T" Width="100%" Text='<%# Eval("Observaciones") %>'></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Vencimiento">
                                    <ItemTemplate>
                                        <asp:TextBox runat="server" ID="F" CssClass="fecha" Text='<%# Eval("Vencimiento") %>'></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
        <div class="modal-footer">
            <asp:Button runat="server" ID="BAgregar" ValidationGroup="ambulancia" Text="Aceptar" CssClass="btn btn-submit" OnClick="BAgregar_Click" />
            <asp:Button runat="server" ID="BCancelA" class="btn btn-default" CausesValidation="false" Text="Cancelar" OnClick="BCancelA_Click" />
        </div>
    </div>

    </div>
</div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="GAmbulancias" />
            <asp:PostBackTrigger ControlID="BAgregar" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>