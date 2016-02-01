<%@ Page Title="Consulta" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="consulta.aspx.cs" Inherits="programacion_consulta" %>
<%@ Register Src="~/usercontrol/funcionario.ascx" TagName="Funcionario" TagPrefix="UC" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="c" Runat="Server">
    <!--<div id="prueba" ng-controller="DataSource" ng-init="init('algo')" ng-app="m">
        <ul data-role="listview">
            <li ng-repeat="todo in source">{{todo.text}}</li>
        </ul>
    </div>-->
    <asp:UpdatePanel runat="server" ID="R">
        <ContentTemplate>
            <asp:Repeater runat="server" ID="RR" DataSourceID="SResultados">
                <HeaderTemplate><ul data-role="listview" id="rr"></HeaderTemplate>
                <ItemTemplate>
                    <li>
                        <asp:HyperLink runat="server" ID="H" NavigateUrl='<%# string.Format("~/programacion/programacion.aspx?pid={0}", Eval("pacId")) %>'>
                            <h2><%# Eval("pacNombres") %></h2>
                            <h2 class="wrap red"><%# Eval("novedad") %></h2>
                            <p class="wrap"><b><%# Eval("actividad") %></b></p>
                            <span class="ui-li-count"><%# Eval("prgNumSesion") %></span>
                            <p><%# Eval("pacDireccion") %><br />
                                <%# Eval("pacBarrio") %><br />
                                <%# Eval("pacTelefono") %><br />
                                <b><%# Eval("entNombre") %></b>
                            </p>
                            <p class="wrap"><%# Eval("prgObservaciones") %></p>
                        </asp:HyperLink>
                    </li>
                </ItemTemplate>
                <FooterTemplate></ul></FooterTemplate>
            </asp:Repeater>
            </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="m$BActualizar" />
        </Triggers>
    </asp:UpdatePanel>
    
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
                                    CASE programacion_novedad.novTipo WHEN 1 THEN 'Cancelación Programación' WHEN 2 THEN 'Reasignación' WHEN 3 THEN 'Cambio en num. sesiones' WHEN 4 THEN 'Otro' WHEN 5 THEN 'Paciente desprotegido' WHEN 6 THEN 'Cambio Servicio' ELSE NULL END
                                ) AS novedad
                                ,programacion.prgObservaciones
                                FROM programacion
                                LEFT JOIN paciente ON (paciente.pacId=programacion.pacId)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                                LEFT JOIN recurso_humano ON (recurso_humano.perId=programacion.perId)
                                LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId)
                                LEFT JOIN programacion_novedad ON (programacion_novedad.prgId=programacion.prgId)
                                LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=programacion.autNumero AND autorizacion_detalle.actId=programacion.actId)
                            WHERE DATE(programacion.prgFechaProg)=@inicio
                            AND programacion.prgActivo=1
                            AND (@asegurador=0 OR programacion.entId=@asegurador)
                            AND (@personal=0 OR programacion.perId=@personal)
                            {0}
                            GROUP BY programacion.prgId
                            ORDER BY programacion.prgFechaProg,paciente.pacNombres">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="m$DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="m$TDesde" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="m$UCFuncionario" Name="personal" PropertyName="IdFuncionario" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="m" Runat="Server">
    <table style="width: 100%; font-size: 0.9em">
        <tr>
            <td>Fecha</td>
            <td><asp:TextBox type="date" runat="server" ID="TDesde"></asp:TextBox></td>
        </tr>
        <!--<tr>
            <td>Hasta</td>
            <td><asp:TextBox type="date" runat="server" ID="THasta"></asp:TextBox></td>
        </tr>-->
        <tr>
            <td>Asegurador</td>
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
        </tr>
        <tr>
            <td>Profesional</td>
            <td><UC:Funcionario runat="server" id="UCFuncionario"></UC:Funcionario></td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button runat="server" ID="BActualizar" OnClick="BActualizar_Click" Text="Actualizar" data-theme="b" />
                <a href="#" data-rel="close" id="closep" data-role="button">Cancelar</a>
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="s" Runat="Server">
    <script type="text/javascript">
        $("#<%= R.ClientID %>").panelUpdated(function () {
            $("#ctl00_LT").text(
                angular.injector(["ng"]).get("$filter")('date')($("#<%=TDesde.ClientID %>").val(), 'shortDate')
            );
        });
    </script>
</asp:Content>