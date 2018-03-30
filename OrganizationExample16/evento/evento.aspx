<%@ Page Title="Evento" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evento.aspx.cs" Inherits="evento_evento" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">        
    .p1 div {
        padding-top: 1px;
        padding-bottom: 1px;
    }
    .afile {
        position: absolute;
        margin-left: 5px;
    }
    .tdinnertable {
        padding: 0 !important;
    }
    .tdinnertable > div > table {
        margin: 0 !important;
    }
</style>
<script type="text/javascript">
    function updateUbicacion(id) {
        if(id)
            $("#aubicacion").removeClass("hide").attr("href", "<%= ResolveUrl("~/evento/ubicacion.aspx") %>?ubid=" + id);
    }
    autoComplete({ controlId: "<%= TNombre.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Evento")%>", selectURL: "<%= Request.Url.AbsolutePath + "?eid=" %>" });
    autoComplete({ controlId: "<%= TAmbulancia.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Ambulancia")%>", controlDataId: "<%= TIdAmbulancia.ClientID %>", autoSelect: true });
    autoComplete({
        controlId: "<%= TUbicacion.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Ubicacion")%>", controlDataId: "<%= TUbicacionId.ClientID %>", autoSelect: true
        , onSelect: function (id, nombre) {
            updateUbicacion(id);
        }
        , onClear: function () {
            $("#aubicacion").addClass("hide");
        }
    });
    autoComplete({ controlId: "<%= TProductor.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Empresario")%>", controlDataId: "<%= TProductorId.ClientID %>", autoSelect: true
        , onSelect: function (id, nombre) {
            $("#<%= BProductor.ClientID %>").click();
        }
        , onClear: function () {
            $("#<%= BProductor.ClientID %>").click();
        }
    });
    autoComplete({ controlId: "<%= TEmpresario.ClientID %>", queryURL: "<%= ResolveUrl("~/webservices/servicios.asmx/Empresario")%>", controlDataId: "<%= TEmpresarioId.ClientID %>", autoSelect: true
        , onSelect: function (id, nombre) {
            $("#<%= BEmpresario.ClientID %>").click();
        }
        , onClear: function () {
            $("#<%= BEmpresario.ClientID %>").click();
        }
    });

    $inicio(function () {
        updateUbicacion($("#<%= TUbicacionId.ClientID %>").val());
        $("#<%= THDesde.ClientID %>,#<%= THHasta.ClientID %>,#<%= TInicio.ClientID %>,#<%= TFinal.ClientID %>").on("dp.change", function () {
            var final = $("#<%= TFinal.ClientID %>").data("DateTimePicker").date();
            var inicio = $("#<%= TInicio.ClientID %>").data("DateTimePicker").date();
            var horai = $("#<%= THDesde.ClientID %>").data("DateTimePicker").date();
            var horaf = $("#<%= THHasta.ClientID %>").data("DateTimePicker").date();
            if (!final || !inicio || !horaf || !horai)
                return;

            var duration= moment.duration(final.diff(inicio));
            var days = duration.asDays()+1;

            duration = moment.duration(horaf.diff(horai));
            var hours = duration.asHours();
            if (hours < 0)
                hours += 24;
            
            $("#<%= LDuracion.ClientID %>").html(Math.round(days * hours) + " horas");
        }).trigger("dp.change");
        $(".tc,.th,.tuh").change(function () {
            var $parent = $(this).closest("tr");
            var cantidad= $parent.find(".tc").autoNumeric('get');
            var horas= $parent.find(".th").autoNumeric('get');
            var cuhora = $parent.find(".tuh").autoNumeric('get');
            if (!cantidad || !horas || !cuhora)
                return;
            $parent.find(".tu").autoNumeric('set', horas*cuhora);
            $parent.find(".tct").autoNumeric('set', cantidad * horas * cuhora);
            var total = 0;
            $(".tct").each(function () {
                total += +$(this).autoNumeric('get');
            });
            $("#<%= TRTotal.ClientID %>").autoNumeric('set', total);
        }).change();
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table class="table table-striped table-condensed">
    <tr>
        <td>Nombre<asp:RequiredFieldValidator ControlToValidate="TNombre" ErrorMessage="Por favor ingrese un nombre." ID="R1" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" ID="TNombre"></asp:TextBox></td>
        <td>Tipo<asp:RequiredFieldValidator ControlToValidate="DTipo" ErrorMessage="Por favor seleccione un tipo." ID="R2" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:DropDownList ID="DTipo" runat="server" DataSourceID="STipo" CssClass="amd"
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="STipo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=9 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
    </tr>
    <tr>
        <td>Inicio<asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha de inicio." ID="R3" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" CssClass="fecha" ID="TInicio"></asp:TextBox></td>
        <td>Final<asp:RequiredFieldValidator ControlToValidate="TFinal" ErrorMessage="Por favor ingrese una fecha de finalización." ID="R4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        <td><asp:TextBox runat="server" CssClass="fecha" ID="TFinal"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Horario<asp:RequiredFieldValidator ControlToValidate="THDesde" ErrorMessage="Por favor ingrese una hora de inicio." ID="R" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            <asp:RequiredFieldValidator ControlToValidate="THHasta" ErrorMessage="Por favor ingrese una hora de finalización." ID="RequiredFieldValidator1" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
        </td>
        <td><asp:TextBox runat="server" ID="THDesde" CssClass="hora"></asp:TextBox>
            <asp:TextBox runat="server" ID="THHasta" CssClass="hora"></asp:TextBox></td>
        <td>Duración</td>
        <td><asp:Label runat="server" ID="LDuracion"></asp:Label></td>
    </tr>
    <tr>
        <td>Complejidad</td>
        <td><asp:DropDownList ID="DComplejidad" runat="server" DataSourceID="SComplejidad" CssClass="amd"
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SComplejidad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=10 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        <td>Plan de salud</td>
        <td><asp:DropDownList ID="DPlan" runat="server" DataSourceID="SPlan" CssClass="amd"
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SPlan" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=12 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
    </tr>
    <tr>
        <td>Aforo estimado</td>
        <td><asp:TextBox runat="server" ID="TAforo" CssClass="entero"></asp:TextBox></td>
        <td>Ubicación</td>
        <td>
            <asp:TextBox runat="server" ID="TUbicacion"></asp:TextBox>
            <asp:TextBox runat="server" ID="TUbicacionId" CssClass="hide"></asp:TextBox>
            <a id="aubicacion" target="_blank" href="#" class="btn btn-default btn-xs hide afile">
                <i class="fa fa-files-o"></i>
            </a>
        </td>
    </tr>
    <tr>
        <td>Descripción</td>
        <td colspan="3"><asp:TextBox runat="server" ID="TDescripcion" Width="100%"></asp:TextBox></td>
    </tr>
    <tr>
        <td colspan="4" class="well">Productor</td>
    </tr>
    <tr>
        <td colspan="4" class="tdinnertable">
            <asp:UpdatePanel runat="server" UpdateMode="Conditional" ID="UP">
                <ContentTemplate>
                    <table class="table table-striped table-condensed">
                        <tr>
                            <td class="tdl">Nombre</td>
                            <td colspan="3" class="tdr">
                                <asp:TextBox runat="server" ID="TProductor"></asp:TextBox>
                                <asp:HyperLink runat="server" ID="HProductor" Target="_blank" CssClass="btn btn-xs btn-default afile" Visible="false">
                                    <i class="fa fa-files-o"></i>
                                </asp:HyperLink>
                                <asp:TextBox runat="server" ID="TProductorId" CssClass="hide"></asp:TextBox>
                                <asp:Button runat="server" ID="BProductor" CausesValidation="false" CssClass="hide" OnClick="BProductor_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td class="tdl">Teléfono</td>
                            <td><asp:TextBox runat="server" ReadOnly="true" ID="TProductorT"></asp:TextBox></td>
                            <td>Celular</td>
                            <td class="tdr"><asp:TextBox ReadOnly="true" runat="server" ID="TProductorM"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td class="tdl">Nombres</td>
                            <td><asp:TextBox runat="server" ReadOnly="true" ID="TProductorC"></asp:TextBox></td>
                            <td>Apellidos</td>
                            <td class="tdr"><asp:TextBox ReadOnly="true" runat="server" ID="TProductorA"></asp:TextBox></td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td colspan="4" class="well">Empresario</td>
    </tr>
    <tr>
        <td colspan="4" class="tdinnertable">
            <asp:UpdatePanel runat="server" ID="UE" UpdateMode="Conditional">
                <ContentTemplate>
                    <table class="table table-striped table-condensed">
                        <tr>
                            <td class="tdl">Nombre</td>
                            <td class="tdr" colspan="3"><asp:TextBox runat="server" ID="TEmpresario"></asp:TextBox>
                                <asp:HyperLink runat="server" ID="HEmpresario" Target="_blank" CssClass="btn btn-xs btn-default afile" Visible="false">
                                    <i class="fa fa-files-o"></i>
                                </asp:HyperLink>
                                <asp:TextBox runat="server" ID="TEmpresarioId" CssClass="hide"></asp:TextBox>
                                <asp:Button runat="server" ID="BEmpresario" CausesValidation="false" CssClass="hide" OnClick="BEmpresario_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td class="tdl">Teléfono</td>
                            <td><asp:TextBox runat="server" ReadOnly="true" ID="TEmpresarioT"></asp:TextBox></td>
                            <td>Celular</td>
                            <td class="tdr"><asp:TextBox ReadOnly="true" runat="server" ID="TEmpresarioM"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td class="tdl">Nombres</td>
                            <td><asp:TextBox runat="server" ReadOnly="true" ID="TEmpresarioC"></asp:TextBox></td>
                            <td>Apellidos</td>
                            <td class="tdr"><asp:TextBox runat="server" ReadOnly="true" ID="TEmpresarioA"></asp:TextBox></td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td colspan="4" class="well">Responsable Pago</td>
    </tr>
    <tr>
        <td class="tdl">Nombre</td>
        <td><asp:TextBox runat="server" ID="TResponsable"></asp:TextBox></td>
        <td>Teléfono</td>
        <td class="tdr"><asp:TextBox runat="server" ID="TResponsableT"></asp:TextBox></td>
    </tr>
    <tr>
        <td class="tdl">Forma de pago</td>
        <td><asp:DropDownList ID="DPago" runat="server" DataSourceID="SPago" CssClass="amd"
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SPago" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=11 AND eliminado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
        <td></td>
        <td class="tdr"></td>
    </tr>
    <tr>
        <td colspan="4" class="well">Recursos</td>
    </tr>
    <tr>
        <td colspan="4" class="tdl tdr">
            <div class="row p1">
            <asp:Repeater runat="server" id="RRecursos" DataSourceID="SRecursos">
                <ItemTemplate><div class="col-sm-3"><asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' /> <asp:Label runat="server" ID="L" Text='<%# Eval("Nombre") %>'></asp:Label></div><div class="col-sm-3"><asp:TextBox runat="server" ID="T" Text='<%# Eval("valor") %>' CssClass="entero"></asp:TextBox></div></ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="SRecursos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id, varios.nombre,evento_recursos.valor 
                        FROM varios 
                        LEFT JOIN evento_recursos ON (evento_recursos.evento=@evento AND evento_recursos.tipo=varios.id)
                        WHERE varios.tipo=8 AND varios.eliminado IS NULL 
                        ORDER BY nombre">
                <SelectParameters>
                    <asp:Parameter Name="evento" DefaultValue="0" />
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
        <td colspan="4" class="tdr tdl">
            <asp:UpdatePanel runat="server" ID="UA" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:GridView ID="GA" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encontraron ambulancias" 
	                    CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="Id"
                        OnSelectedIndexChanged="GA_SelectedIndexChanged" OnRowDeleting="GA_RowDeleting">
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
                            <asp:BoundField HeaderText="Ambulancia" DataField="NombreAmbulancia" />
                            <asp:BoundField HeaderText="Medico" DataField="NMedico" />
                            <asp:BoundField HeaderText="Auxiliar" DataField="NAuxiliar" />
                            <asp:BoundField HeaderText="Conductor" DataField="NConductor" />
                            <asp:BoundField HeaderText="Ubicación" DataField="Ubicacion" />
                        </Columns>
                    </asp:GridView>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="BAmbulanciaA" />
                    <asp:AsyncPostBackTrigger ControlID="BAmbulanciaC" />
                </Triggers>
            </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td class="tdr tdl r" colspan="4">
            <button type="button" id="bAmbulancia" class="btn btn-submit" data-toggle="modal" data-target="#dlgAmbulancia"><i class="fa fa-plus"></i></button>
        </td>
    </tr>
    <tr>
        <td colspan="4" class="well">Cotizaciones</td>
    </tr>
    <tr>
        <td class="tdl tdr" colspan="4">
            <asp:UpdatePanel runat="server" ID="UCG" UpdateMode="Conditional">
                <ContentTemplate>
            <asp:GridView ID="GCotizaciones" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encontraron cotizaciones" 
	            CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="Id"
                OnSelectedIndexChanged="GCotizaciones_SelectedIndexChanged" OnRowDeleting="GCotizaciones_RowDeleting">
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
            <asp:TemplateField ItemStyle-Width="1px">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="P" Enabled='<%# !Eval("Id").ToString().StartsWith("-") %>' CssClass="btn btn-default btn-xs" Target="_blank" NavigateUrl='<%# string.Format("~/evento/evento.aspx?eid={0}&cid={1}&p=1", Request.QueryString["eid"], Eval("Id")) %>'><i class="fa fa-print"></i></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="1px">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="F" Enabled='<%# !Eval("Id").ToString().StartsWith("-") %>' CssClass="btn btn-default btn-xs" NavigateUrl='<%# string.Format("~/evento/evento.aspx?eid={0}&cid={1}&pdf=1", Request.QueryString["eid"], Eval("Id")) %>'><i class="fa fa-file-pdf-o"></i></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
                        <asp:BoundField DataField="Fecha" HeaderText="Fecha" SortExpression="Fecha" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="Respetado" HeaderText="Respetado" SortExpression="Respetado" />
                        <asp:BoundField DataField="Valor" HeaderText="Valor" SortExpression="Valor" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:C}" />
                    </Columns>
                </asp:GridView>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="BCotizacionA" />
                    <asp:AsyncPostBackTrigger ControlID="BCotizacionC" />
                </Triggers>
            </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td class="tdr tdl r" colspan="4">
            <button type="button" id="bCotizacion" class="btn btn-submit" data-toggle="modal" data-target="#dlgCotizacion"><i class="fa fa-plus"></i></button>
        </td>
    </tr>
    <tr>
        <td colspan="4" class="well">Facturas</td>
    </tr>
    <tr>
        <td class="tdl tdr" colspan="4">
            <asp:UpdatePanel runat="server" ID="UFG" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:GridView ID="GFacturas" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encontraron facturas" OnSelectedIndexChanged="GFacturas_SelectedIndexChanged" OnRowDeleting="GFacturas_RowDeleting"
	                    CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="Id">
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
                            <asp:BoundField DataField="Fecha" HeaderText="Fecha" SortExpression="Fecha" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="Numero" HeaderText="Numero" SortExpression="Numero" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="Valor" HeaderText="Valor" SortExpression="Valor" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:C}" />
                        </Columns>
                    </asp:GridView>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="BFacturaA" />
                    <asp:AsyncPostBackTrigger ControlID="BFacturaC" />
                </Triggers>
            </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td class="tdr tdl r" colspan="4"><button type="button" class="btn btn-submit" id="bFactura" data-toggle="modal" data-target="#dlgFactura"><i class="fa fa-plus"></i></button></td>
    </tr>
    <tr>
        <td colspan="4" class="well">Requisición</td>
    </tr>
    <tr>
        <td class="tdl tdr" colspan="4">
            <asp:UpdatePanel runat="server" ID="URR" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:GridView ID="GRequisiciones" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encontraron requisiciones" DataKeyNames="Id"
	                    CssClass="table table-condensed table-bordered table-hover table-striped" OnSelectedIndexChanged="GRequisiciones_SelectedIndexChanged" OnRowDeleting="GRequisiciones_RowDeleting">
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
            <asp:TemplateField ItemStyle-Width="1px">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="P" Enabled='<%# !Eval("Id").ToString().StartsWith("-") %>' CssClass="btn btn-default btn-xs" Target="_blank" NavigateUrl='<%# string.Format("~/evento/evento.aspx?eid={0}&rid={1}&p=1", Request.QueryString["eid"], Eval("Id")) %>'><i class="fa fa-print"></i></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="1px">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="F" Enabled='<%# !Eval("Id").ToString().StartsWith("-") %>' CssClass="btn btn-default btn-xs" NavigateUrl='<%# string.Format("~/evento/evento.aspx?eid={0}&rid={1}&pdf=1", Request.QueryString["eid"], Eval("Id")) %>'><i class="fa fa-file-pdf-o"></i></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
                            <asp:BoundField DataField="Fecha" HeaderText="Fecha" SortExpression="Fecha" ItemStyle-HorizontalAlign="Right" />
                        </Columns>
                    </asp:GridView>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="BRequisicionA" />
                    <asp:AsyncPostBackTrigger ControlID="BRequisicionC" />
                </Triggers>
            </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td class="tdr tdl r" colspan="4"><button type="button" id="bRequisicion" class="btn btn-submit" data-toggle="modal" data-target="#dlgRequisicion"><i class="fa fa-plus"></i></button></td>
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
                            <asp:HyperLink runat="server" Visible='<%# Eval("archivo") != DBNull.Value %>' ID="H" Text='<%# Eval("nombre") %>' NavigateUrl='<%# Eval("archivo")==DBNull.Value ? "" : Files.GetURL(Files.Directorys.EventoDocumentos, Files.ContentDisposition.Attachment, ViewState["id"], Eval("id"), Eval("Nombre").ToString() + Eval("archivo")) %>'></asp:HyperLink>
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
                    SelectCommand="SELECT varios.id, varios.nombre,evento_documento.archivo
                        FROM varios 
                        LEFT JOIN evento_documento ON (evento_documento.evento=@evento AND evento_documento.documento=varios.id)
                        WHERE varios.tipo=16 AND varios.eliminado IS NULL ORDER BY nombre">
                      <SelectParameters>
                          <asp:Parameter Name="evento" DefaultValue="0" />
                      </SelectParameters>
                </asp:SqlDataSource>
        </td>
    </tr>
    <tr>
        <td colspan="4" class="well">Bitácora</td>
    </tr>
    <tr class="tdl tdr tdb">
        <td colspan="4">
            <asp:TextBox runat="server" ID="TBitacora" TextMode="MultiLine" Width="100%"></asp:TextBox>
        </td>
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

<asp:UpdatePanel runat="server" ID="UC" UpdateMode="Conditional">
    <ContentTemplate>
        <div id="dlgCotizacion" class="modal fade" role="dialog" data-keyboard="false" data-backdrop="static">
            <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                <h4 class="modal-title">Cotización</h4>
                </div>
                <div class="modal-body">
                    <table class="table table-striped table-condensed">
                        <tr>
                            <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TCFecha" ValidationGroup="cotizacion" ErrorMessage="Por favor ingrese una fecha." ID="R8" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                            <td><asp:TextBox runat="server" ID="TCFecha" CssClass="fecha"></asp:TextBox></td>
                            <td>Respetado</td>
                            <td><asp:TextBox runat="server" ID="TCRespetado"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>Señores</td>
                            <td colspan="3"><asp:TextBox runat="server" Width="100%" ID="TCSeñores"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>Valor</td>
                            <td><asp:TextBox runat="server" ID="TCValor" CssClass="dinero"></asp:TextBox></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <asp:Button runat="server" ID="BCotizacionA" ValidationGroup="cotizacion" Text="Aceptar" CssClass="btn btn-submit" OnClick="BCotizacionA_Click" />
                    <asp:Button runat="server" ID="BCotizacionC" Text="Cancelar" CssClass="btn btn-default" CausesValidation="false" OnClick="BCotizacionC_Click" />
                </div>
            </div>
            </div>
        </div>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="GCotizaciones" />
    </Triggers>
</asp:UpdatePanel>

<asp:UpdatePanel runat="server" ID="UF" UpdateMode="Conditional">
    <ContentTemplate>
        <div id="dlgFactura" class="modal fade" role="dialog" data-keyboard="false" data-backdrop="static">
            <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                <h4 class="modal-title">Factura</h4>
                </div>
                <div class="modal-body">
                    <table class="table table-striped table-condensed">
                        <tr>
                            <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFFecha" ValidationGroup="factura" ErrorMessage="Por favor ingrese una fecha." ID="R6" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                            <td><asp:TextBox runat="server" ID="TFFecha" CssClass="fecha"></asp:TextBox></td>
                            <td>Numero<asp:RequiredFieldValidator ControlToValidate="TFNumero" ValidationGroup="factura" ErrorMessage="Por favor ingrese un numero." ID="R7" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                            <td><asp:TextBox runat="server" ID="TFNumero" CssClass="entero"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>Valor</td>
                            <td><asp:TextBox runat="server" ID="TFValor" CssClass="dinero"></asp:TextBox></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <asp:Button runat="server" ID="BFacturaA" ValidationGroup="factura" Text="Aceptar" CssClass="btn btn-submit" OnClick="BFacturaA_Click" />
                    <asp:Button runat="server" ID="BFacturaC" CausesValidation="false" Text="Cancelar" CssClass="btn btn-default" OnClick="BFacturaC_Click" />
                </div>
            </div>
            </div>
        </div>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="GFacturas" />
    </Triggers>
</asp:UpdatePanel>
<asp:UpdatePanel runat="server" ID="UR" UpdateMode="Conditional">
                <ContentTemplate>
                    <div id="dlgRequisicion" class="modal fade" role="dialog" data-keyboard="false" data-backdrop="static">
                        <div class="modal-dialog modal-lg">
                        <!-- Modal content-->
                        <div class="modal-content">
                            <div class="modal-header">
                            <h4 class="modal-title">Requisición</h4>
                            </div>
                            <div class="modal-body">
                                <table class="table table-striped table-condensed">
                                    <tr>
                                        <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TRFecha" ErrorMessage="Por favor ingrese una fecha." ID="R5"  ValidationGroup="requisicion"
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                                        <td colspan="3"><asp:TextBox runat="server" ID="TRFecha" CssClass="fecha"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <asp:GridView ID="GServicios" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encontraron servicios" 
                                                DataKeyNames="Tipo"
                                                CssClass="table table-condensed table-bordered table-hover table-striped">
                                                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                                                <Columns>
                                                    <asp:BoundField DataField="nombre" HeaderText="Servicio" SortExpression="nombre" ItemStyle-Width="100%" />
                                                    <asp:TemplateField HeaderText="Cantidad">
                                                        <ItemTemplate><asp:TextBox runat="server" ID="C" Text='<%# Eval("Cantidad") %>' CssClass="entero tc"></asp:TextBox></ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Horas">
                                                        <ItemTemplate><asp:TextBox runat="server" ID="H" Text='<%# Eval("Horas") %>' CssClass="entero th"></asp:TextBox></ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="C. Un. Hora">
                                                        <ItemTemplate><asp:TextBox runat="server" ID="CH" Text='<%# Eval("CUHora") %>' CssClass="dinero tuh"></asp:TextBox></ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="C. Un.">
                                                        <ItemTemplate><asp:TextBox runat="server" ID="CU" ReadOnly="true" CssClass="dinero tu"></asp:TextBox></ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Costo Total">
                                                        <ItemTemplate><asp:TextBox runat="server" ID="T" ReadOnly="true" CssClass="dinero tct"></asp:TextBox></ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td class="r">Total <asp:TextBox runat="server" ID="TRTotal" ReadOnly="true" CssClass="dinero"></asp:TextBox></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="modal-footer">
                                <asp:Button runat="server" ID="BRequisicionA" ValidationGroup="requisicion" Text="Aceptar" CssClass="btn btn-submit" OnClick="BRequisicionA_Click" />
                                <asp:Button runat="server" ID="BRequisicionC" CausesValidation="false" Text="Cancelar" CssClass="btn btn-default" OnClick="BRequisicionC_Click" />
                            </div>
                        </div>
                    </div>
                </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="GRequisiciones" />
        </Triggers>
    </asp:UpdatePanel>


<asp:UpdatePanel runat="server" ID="UDA" UpdateMode="Conditional">
    <ContentTemplate>
        <div id="dlgAmbulancia" class="modal fade" role="dialog" data-keyboard="false" data-backdrop="static">
            <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                <h4 class="modal-title">Ambulancia</h4>
                </div>
                <div class="modal-body">
                    <table class="table table-striped table-condensed">
                        <tr>
                            <td>Ambulancia<asp:RequiredFieldValidator ControlToValidate="TIdAmbulancia" ValidationGroup="ambulancia" ErrorMessage="Por favor seleccione una ambulancia." ID="R15" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
                            <td>
                                <asp:TextBox runat="server" ID="TAmbulancia"></asp:TextBox>
                                <asp:TextBox runat="server" ID="TIdAmbulancia" CssClass="hide"></asp:TextBox>
                            </td>
                            <td>Ubicación</td>
                            <td><asp:TextBox runat="server" ID="TUbicacionA"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td colspan="4" class="well">Medico</td>
                        </tr>
                        <tr class="tdr tdl">
                            <td>Documento</td>
                            <td><asp:TextBox runat="server" ID="TDMedico"></asp:TextBox></td>
                            <td>Nombre</td>
                            <td><asp:TextBox runat="server" ID="TNMedico"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td colspan="4" class="well">Auxiliar</td>
                        </tr>
                        <tr class="tdr tdl">
                            <td>Documento</td>
                            <td><asp:TextBox runat="server" ID="TDAuxiliar"></asp:TextBox></td>
                            <td>Nombre</td>
                            <td><asp:TextBox runat="server" ID="TNAuxiliar"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td colspan="4" class="well">Conductor</td>
                        </tr>
                        <tr class="tdr tdl tdb">
                            <td>Documento</td>
                            <td><asp:TextBox runat="server" ID="TDConductor"></asp:TextBox></td>
                            <td>Nombre</td>
                            <td><asp:TextBox runat="server" ID="TNConductor"></asp:TextBox></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <asp:Button runat="server" ID="BAmbulanciaA" ValidationGroup="ambulancia" Text="Aceptar" CssClass="btn btn-submit" OnClick="BAmbulanciaA_Click" />
                    <asp:Button runat="server" ID="BAmbulanciaC" Text="Cancelar" CssClass="btn btn-default" CausesValidation="false" OnClick="BAmbulanciaC_Click" />
                </div>
            </div>
            </div>
        </div>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="GA" />
    </Triggers>
</asp:UpdatePanel>
</asp:Content>