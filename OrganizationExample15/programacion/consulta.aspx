<%@ Page Title="Consulta programación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="consulta.aspx.cs" Inherits="programacion_consulta" %>
<%@ Register src="~/programacion/novedad.ascx" tagname="novedad" tagprefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">.GridHeader th {width: auto !important;}</style>
<script type="text/javascript">
    $(function() {
        $("#<%= TProcedimiento.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetMedicamentos",
                    data: "{ 'q': '" + request.term + "', 't': '173' }",
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
                $("#<%= TProcedimientoID.ClientID %>").val(ui.item.value);
                $("#<%= TProcedimiento.ClientID %>").val(ui.item.label);
                return false;
            },
            search: function(event, ui) {
                $("#<%= TProcedimientoID.ClientID %>").val("");
                // $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
            }
        }).change(function() { if ($(this).val() == "") $("#<%= TProcedimientoID.ClientID %>").val(""); });

        $("#<%= TPersonal.ClientID %>").autocomplete({
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
            $("#<%= TPersonalID.ClientID %>").val(ui.item.value);
            $("#<%= TPersonal.ClientID %>").val(ui.item.label);
                return false;
            },
            search: function(event, ui) {
            $("#<%= TPersonalID.ClientID %>").val("");
                // $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
            }
        }).change(function() { if ($(this).val() == "") $("#<%= TPersonalID.ClientID %>").val(""); });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Inicio</td>
            <td>Fin</td>
            <td>Asegurador</td>
            <td style="white-space: nowrap">Actividad o CUPS</td>
            <td>Profesional</td>
            <td><asp:Label runat="server" ID="LArea">Área</asp:Label></td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TInicio" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFin" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFin" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:DropDownList ID="DAsegurador" runat="server" CssClass="anchomaxcombo"
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
            <asp:TextBox Width="99%" runat="server" ID="TProcedimiento"></asp:TextBox><asp:TextBox runat="server" ID="TProcedimientoID" CssClass="hide"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox Width="99%" runat="server" ID="TPersonal"></asp:TextBox><asp:TextBox runat="server" ID="TPersonalID" CssClass="hide"></asp:TextBox>
            </td>
            <td><asp:DropDownList ID="DArea" runat="server" DataSourceID="SArea"  CssClass="anchomaxcombo"
                    DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SArea" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT CAST(IFNULL(GROUP_CONCAT(medicamentos.id),-1) AS CHAR) AS id, varios.nombre FROM varios LEFT JOIN medicamentos ON (medicamentos.grupo=varios.id) WHERE varios.tipo=22 AND varios.szReservado IS NULL GROUP BY varios.id ORDER BY varios.nombre;">
                </asp:SqlDataSource>
            </td>
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="dImprimir">
    <asp:UpdatePanel ID="PResultados" runat="server">
        <ContentTemplate>
            <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
                AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" DataKeyNames="prgId"
                AllowPaging="True" PageSize="50" AllowSorting="True" 
                    OnRowDataBound="GResultados_RowDataBound" 
                    onselectedindexchanged="GResultados_SelectedIndexChanged" >
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField HeaderText="Fecha" DataField="prgFechaProg" SortExpression="prgFechaProg" DataFormatString="{0:d}" />
                    <asp:TemplateField HeaderText="Documento" SortExpression="pacDocumento" ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:HyperLink Enabled='<%# CUsuario.GetInstance().CanInsert() %>' runat="server" ID="H" Text='<%# Eval("pacDocumento") %>' NavigateUrl='<%# string.Format("~/programacion/programacion.aspx?pid={0}", Eval("pacId")) %>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Paciente" SortExpression="pacNombres" ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <asp:HyperLink Enabled='<%# CUsuario.GetInstance().CanInsert() %>' runat="server" ID="D" Text='<%# Eval("pacNombres") %>' NavigateUrl='<%# string.Format("~/programacion/programacion.aspx?pid={0}", Eval("pacId")) %>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-Wrap="false"/>
                    <asp:BoundField HeaderText="Actividad" DataField="actividad" SortExpression="actividad" ItemStyle-Wrap="false"/>
                    <asp:BoundField HeaderText="Sesiones" DataField="prgNumSesion" SortExpression="prgNumSesion" ItemStyle-HorizontalAlign="Right"/>
                    <asp:BoundField HeaderText="Profesional" DataField="perNombre" SortExpression="perNombre" ItemStyle-Wrap="false"/>
                    <asp:BoundField HeaderText="Barrio" DataField="pacBarrio" SortExpression="pacBarrio"/>
                    <asp:BoundField HeaderText="Direccion" DataField="pacDireccion" SortExpression="pacDireccion"/>
                    <asp:BoundField HeaderText="Teléfono" DataField="pacTelefono" SortExpression="pacTelefono"/>
                    <asp:TemplateField HeaderText="Autorización" SortExpression="autNumero" ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <asp:HyperLink Enabled='<%# CUsuario.GetInstance().CanInsert() %>' runat="server" ID="A" Text='<%# Eval("autNumero") %>' NavigateUrl='<%# string.Format("~/admisiones/autorizaciones.aspx?aut={0}", Eval("autNumero")) %>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Observaciones" DataField="prgObservaciones" SortExpression="prgObservaciones"/>
                    <asp:TemplateField HeaderText="Novedades" SortExpression="novedad" ItemStyle-Wrap="false">
                        <ItemTemplate>
                            <asp:LinkButton ID="LNovedad" runat="server" CausesValidation="False" Visible='<%# Eval("novedad").ToString()=="" ? false : true %>' CommandName="Select" Text='<%# Eval("novedad").ToString() %>'></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <uc3:novedad ID="UCNovedad" runat="server" OnAceptarClicked="UCNovedad_AceptarClicked" Visible="false" OnCancelarClicked="UCNovedad_CancelarClicked" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT programacion.prgFechaProg,programacion.autNumero
                                ,paciente.pacDocumento,paciente.pacNombres,paciente.pacBarrio,paciente.pacDireccion,paciente.pacId
                                ,paciente.pacTelefono
                                ,asegurador.entNombre
                                ,recurso_humano.perNombre
                                ,medicamentos.nombre AS actividad
                                ,programacion.prgId
                                ,programacion.prgNumSesion
                                ,GROUP_CONCAT(
                                    CONCAT(CASE programacion_novedad.novTipo WHEN 1 THEN 'Cancelación Programación' WHEN 2 THEN 'Reasignación' WHEN 3 THEN 'Cambio en num. sesiones' WHEN 4 THEN 'Otro' WHEN 5 THEN 'Paciente desprotegido' WHEN 6 THEN 'Cambio Servicio' ELSE NULL END,',_')
                                ) AS novedad
                                ,programacion.prgObservaciones
                                FROM programacion
                                LEFT JOIN paciente ON (paciente.pacId=programacion.pacId)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                                LEFT JOIN recurso_humano ON (recurso_humano.perId=programacion.perId)
                                LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId)
                                LEFT JOIN programacion_novedad ON (programacion_novedad.prgId=programacion.prgId)
                                LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=programacion.autNumero AND autorizacion_detalle.actId=programacion.actId)
                            WHERE DATE(programacion.prgFechaProg) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND programacion.prgActivo=1
                            AND (@asegurador=0 OR programacion.entId=@asegurador)
                            AND (@personal=0 OR programacion.perId=@personal)
                            AND (@procedimiento=0 OR programacion.actId=@procedimiento)
                            AND ('@area'='0' OR programacion.actId IN (@area))
                            {0}
                            GROUP BY programacion.prgId
                            ORDER BY programacion.prgFechaProg,paciente.pacNombres">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TProcedimientoID" Name="procedimiento" PropertyName="Text" DefaultValue="0" />
                    <asp:ControlParameter ControlID="TPersonalID" Name="personal" PropertyName="Text" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>