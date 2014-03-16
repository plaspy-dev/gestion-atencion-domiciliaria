<%@ Page Title="Informe de cumplimiento" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="autorizadovsrealizado.aspx.cs" Inherits="auditoria_autorizadovsrealizado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= GResultados.ClientID %>> tbody tr:first").after("<tr><td colspan=7 class='celdaTitulo'>CONSOLIDADO TOTAL</td></tr>");
        $("#<%= GResultados.ClientID %> b").filter(".h1:last").parent().parent().after("<tr><td colspan=7 class='celdaTitulo'>CONSOLIDADO POR ACTIVIDAD</td></tr>");
        $("#<%= GResultados.ClientID %> b").filter(".h2:last").parent().parent().after("<tr class=''><td colspan=7 class='celdaTitulo'>CONSOLIDADO POR ASEGURADOR</td></tr>");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Inicio</td>
            <td>Fin</td>
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
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" /></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Width="100%" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron actividades" AllowSorting="True" OnRowDataBound="GResultados_RowDataBound" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField HeaderText="Actividad" DataField="nombre" SortExpression="i,nombre" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
            <asp:BoundField HeaderText="Sesiones autorizadas" DataField="ses" SortExpression="i,ses" ItemStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Sesiones realizadas" DataField="a" SortExpression="i,a" ItemStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Sesiones canceladas por novedad" DataField="b" SortExpression="i,b" ItemStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Sesiones incumplidas" DataField="c" SortExpression="i,c" ItemStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Inclumplimiento" DataField="d" SortExpression="i,d" DataFormatString="{0:p}" ItemStyle-HorizontalAlign="Right"/>
            <asp:TemplateField ItemStyle-CssClass="hide" HeaderStyle-CssClass="hide">  
                <ItemTemplate><b class="h<%# Eval("i") %>"></b></ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="(
                                SELECT 1 AS i,'Consolidad total' AS nombre, SUM(autNumSesiones) AS ses,SUM(a) AS a,SUM(b) AS b
                                ,SUM(autNumSesiones)-SUM(a)-SUM(b) AS c 
                                ,CASE SUM(autNumSesiones) WHEN 0 THEN 0 ELSE ((SUM(autNumSesiones)-SUM(a)-SUM(b))/SUM(autNumSesiones)) END AS d
                                FROM 
                                (
                                SELECT autorizacion.autNumero, autorizacion_detalle.autNumSesiones
                                ,SUM(CASE prgActivo WHEN 1 THEN programacion.prgNumSesion ELSE 0 END) AS a
                                ,SUM(CASE prgActivo WHEN 0 THEN programacion.prgNumSesion ELSE 0 END) AS b
                                FROM autorizacion
                                LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                                LEFT JOIN programacion ON (programacion.autNumero=autorizacion.autNumero AND programacion.actId=autorizacion_detalle.actId AND (programacion.intensidad=autorizacion_detalle.intensidad OR (programacion.intensidad IS NULL AND autorizacion_detalle.intensidad IS NULL)))
                                WHERE autorizacion.autFecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                GROUP BY autorizacion.autNumero, autorizacion_detalle.actId,autorizacion_detalle.intensidad, autorizacion_detalle.autNumSesiones
                                ) AS a
                            ) UNION (
                                SELECT 2 AS i,a.actId AS nombre,SUM(autNumSesiones) AS ses,SUM(a) AS a,SUM(b) AS b
                                ,SUM(autNumSesiones)-SUM(a)-SUM(b) AS c 
                                ,CASE SUM(autNumSesiones) WHEN 0 THEN 0 ELSE ((SUM(autNumSesiones)-SUM(a)-SUM(b))/SUM(autNumSesiones)) END AS d
                                FROM 
                                (
                                    SELECT autorizacion.autNumero, autorizacion_detalle.actId,autorizacion_detalle.autNumSesiones
                                    ,SUM(CASE prgActivo WHEN 1 THEN programacion.prgNumSesion ELSE 0 END) AS a
                                    ,SUM(CASE prgActivo WHEN 0 THEN programacion.prgNumSesion ELSE 0 END) AS b
                                    FROM autorizacion
                                    LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                                    LEFT JOIN programacion ON (programacion.autNumero=autorizacion.autNumero AND programacion.actId=autorizacion_detalle.actId AND (programacion.intensidad=autorizacion_detalle.intensidad OR (programacion.intensidad IS NULL AND autorizacion_detalle.intensidad IS NULL)))
                                    WHERE autorizacion.autFecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                    AND autorizacion_detalle.actId IS NOT NULL
                                    GROUP BY autorizacion.autNumero, autorizacion_detalle.actId,autorizacion_detalle.intensidad,autorizacion_detalle.autNumSesiones
                                ) AS a GROUP BY a.actId
                            ) UNION (
                                
                                SELECT 3 AS i,IFNULL(a.entNombre,'(Ninguno)'),SUM(autNumSesiones),SUM(a),SUM(b)
                                ,SUM(autNumSesiones)-SUM(a)-SUM(b) AS c 
                                ,CASE SUM(autNumSesiones) WHEN 0 THEN 0 ELSE ((SUM(autNumSesiones)-SUM(a)-SUM(b))/SUM(autNumSesiones)) END AS d
                                FROM 
                                (
                                SELECT autorizacion.autNumero, asegurador.entNombre, autorizacion_detalle.autNumSesiones
                                ,SUM(CASE prgActivo WHEN 1 THEN programacion.prgNumSesion ELSE 0 END) AS a
                                ,SUM(CASE prgActivo WHEN 0 THEN programacion.prgNumSesion ELSE 0 END) AS b
                                FROM autorizacion
                                LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=autorizacion.autNumero)
                                LEFT JOIN programacion ON (programacion.autNumero=autorizacion.autNumero AND programacion.actId=autorizacion_detalle.actId AND (programacion.intensidad=autorizacion_detalle.intensidad OR (programacion.intensidad IS NULL AND autorizacion_detalle.intensidad IS NULL)))
                                LEFT JOIN asegurador ON (asegurador.entId=autorizacion.entId)
                                WHERE autorizacion.autFecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                                GROUP BY autorizacion.autNumero, autorizacion_detalle.actId,autorizacion_detalle.intensidad, asegurador.entNombre,autorizacion_detalle.autNumSesiones
                                ) AS a
                                GROUP BY a.entNombre
                            ) ORDER BY i,nombre
                            ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
