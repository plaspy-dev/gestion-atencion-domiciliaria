<%@ Page Title="Gestión documental" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="archivo_Browser" Codebehind="Browser.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <%= SDG.Componentes.HtmlUtil.RenderStyle("~/archivo/dropzone.css") %>
    <%= SDG.Componentes.HtmlUtil.RenderScript("~/archivo/dropzone.js") %>
    <%= SDG.Componentes.HtmlUtil.RenderScript("~/js/jquery.updatepanel.js") %>
    <style type="text/css">
        #<%= GFiles.ClientID %> .fa {
            padding-top: 2px;
            font-size: 16px;
        }
        .expiredl {
            float: right;
            font-size: 8px;
        }
    </style>
    <script type="text/javascript">
        $inicio(function () {
            var $buttons = $("#<%= BDelete.ClientID %>");
            // $buttons.addClass("disabled");
            var $checkbox = $("#<%= GFiles.ClientID %> :checkbox");
            $("#<%= GFiles.ClientID %> :checkbox").change(function () {
                if ($checkbox.filter(":checked").length)
                    $buttons.removeClass("disabled");
                else $buttons.addClass("disabled");
            }).change();
        });
        $(function () {
            $("#<%= BFolderD.ClientID %>").click(function () {
                $("#<%= TFolder.ClientID %>,#<%=BFolder.ClientID %>").toggle();
                if ($(this).html() == "Cancelar") {
                    $(this).html($(this).attr("_text"));
                } else {
                    $(this).html("Cancelar");
                    $("#<%= TFolder.ClientID %>").focus();
                }
                return false;
            }).attr("_text", $("#<%= BFolderD.ClientID %>").html());
            $("#<%= BUpload.ClientID %>").click(function () {

                if ($("#dZUpload").is(":visible"))
                    $(this).html($(this).attr("_text"));
                else $(this).html("<i class='fa fa-close'></i> Cerrar");
                $(this).toggleClass("btn-default").toggleClass("btn-submit");
                $("#dZUpload").toggle();
                return false;
            }).attr("_text", $("#<%= BUpload.ClientID %>").html());

            Dropzone.autoDiscover = false;
            $(".dropzone").dropzone({
                url: '<%= ResolveClientUrl("~/archivo/UploadFile.ashx") + "?r="+ HttpUtility.UrlEncode(ViewState["root"].ToString()) %>',
                maxFilesize: 2048, // MB
                enqueueForUpload: true,
                dictDefaultMessage: "Arrastre sus archivos para subir",
                dictFallbackMessage: "Su navegador no soporta arrastrar archivos.",
                dictFallbackText: "Por favor use el formulario para subir los archivos.",
                dictFileTooBig: "El archivo es muy grande ({{filesize}}MiB). Tamaño máximo: {{maxFilesize}}MiB.",
                dictInvalidFileType: "No se pueden subir archivos de este tipo.",
                dictResponseError: "El servidor repondio con el código {{statusCode}}.",
                dictCancelUpload: "Cancelar subida",
                dictCancelUploadConfirmation: "¿Está seguro de cancelar esta subida?",
                dictRemoveFile: "Remover archivo",
                dictMaxFilesExceeded: "No se pueden subir mas archivos."
                , accept: function (file, done) {
                    /*var regex = /^\d{8}.*$/i;
                    if(!regex.test(file.name)) {
                      done("Por favor seleccione un archivo que comience por el nombre de una ODS.");
                    } else { done(); }*/
                    done();
                }, success: function (file, response) {
                    if (response.Error) {
                        _ref = file.previewElement.querySelectorAll("[data-dz-errormessage]");
                        _results = [];
                        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                            node = _ref[_i];
                            _results.push(node.textContent = response.Message);
                        }
                        return file.previewElement.classList.add("dz-error");
                    }
                    eval($("#<%= BUpdate.ClientID %>").attr("href"));
                    return file.previewElement.classList.add("dz-success");
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:PlaceHolder runat="server" ID="PU">
    <table>
        <tr>
            <td><asp:LinkButton runat="server" ID="BUpload" CssClass="btn btn-submit"><i class="fa fa-cloud-upload"></i> Subir</asp:LinkButton></td>
            <td>
                <asp:Panel runat="server" ID="PF" DefaultButton="BFolder">
                    <asp:TextBox runat="server" placeholder="Directorio"  ID="TFolder" CssClass="hidet"></asp:TextBox>
                    <asp:Button runat="server" ID="BFolder" OnClick="BFolder_Click" CssClass="btn btn-submit hidet" Text="Aceptar" />
                    <asp:LinkButton runat="server" ID="BFolderD" CssClass="btn btn-default"><i class="fa fa-folder"></i> Crear directorio</asp:LinkButton>
                </asp:Panel>
            </td>
            <td>
                <asp:LinkButton runat="server" ID="BUpdate" CssClass="btn btn-default" OnClick="BUpdate_Click"><i class="fa fa-refresh"></i> Actualizar</asp:LinkButton>
            </td>
            <td>
                <asp:LinkButton runat="server" ID="BDelete" CssClass="btn btn-danger" OnClick="BDelete_Click"><i class="fa fa-trash-o"></i> Eliminar</asp:LinkButton>
            </td>
        </tr>
    </table>
    <asp:Panel runat="server" ID="dZUpload" ClientIDMode="Static" CssClass="dropzone hidet">
        <div class="dz-default dz-message">Para agregar archivos por favor seleccionelos haciendo clic sobre este mensaje o arrastrelos sobre el mensaje</div>
    </asp:Panel>
    </asp:PlaceHolder>
    <div>
        <asp:Repeater runat="server" ID="RPath">
            <HeaderTemplate><h5><i class="fa fa-home"></i> </HeaderTemplate>
            <ItemTemplate>&nbsp;<asp:HyperLink runat="server" ID="H" Text='<%# string.Format("{0}", Eval("Name")) %>' NavigateUrl='<%# string.Format("~/archivo/Browser.aspx?dir={0}", HttpUtility.UrlEncode(Eval("Path").ToString())) %>'></asp:HyperLink>&nbsp;/</ItemTemplate>
            <FooterTemplate></h5></FooterTemplate>
        </asp:Repeater>
    </div>
    <asp:UpdatePanel runat="server" ID="UF" UpdateMode="Conditional">
        <ContentTemplate>
            <div>
                <asp:Label runat="server" ID="LMessage" ForeColor="Red"></asp:Label>
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="width: 100%; vertical-align: top">
                        <asp:GridView ID="GFiles" runat="server" AutoGenerateColumns="False" AllowSorting="true" DataSourceID="SFiles" 
                            EmptyDataText="No se encontraron archivos" BorderWidth="0" GridLines="None" CssClass="table table-condensed table-hover table-striped"
                            DataKeyNames="path">
                            <Columns>
                                <asp:TemplateField HeaderText=""><ItemTemplate><asp:CheckBox runat="server" ID="C" /></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText=""><ItemTemplate><i class="fa <%# GetFileIcon(Eval("filename")) %>"></i></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="Archivo" ItemStyle-Width="100%" SortExpression="filename">
                                    <ItemTemplate>
                                        <asp:HyperLink runat="server" ID="H" Text='<%# Eval("filename") %>' NavigateUrl='<%# string.Format("~/archivo/Browser.aspx?dir={0}", HttpUtility.UrlEncode(Eval("path").ToString())) %>'></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tamaño" SortExpression="size" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false">
                                    <ItemTemplate><%# GetHumanFileSize(Eval("size")) %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="creation" SortExpression="creation" HeaderText="Creación" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
            </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="BUpdate" />
            <asp:AsyncPostBackTrigger ControlID="BDelete" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="SFiles" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT 
                        sha,md5,path,size,creation
                        ,SUBSTRING_INDEX(path, '/', IF(path LIKE '%/', -2,-1)) AS filename 
                        FROM files 
                        WHERE (@dir='/' OR path LIKE CONCAT(@dir, '_%'))
                        AND path NOT LIKE CONCAT(@dir, '%/_%')
                        ORDER BY path">
        <SelectParameters>
            <asp:Parameter Name="dir" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

