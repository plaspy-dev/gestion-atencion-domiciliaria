<%@ Page Title="Listado PQR" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="listadoquejas.aspx.cs" Inherits="cliente_listadoquejas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">.GridHeader th {width: auto !important;}</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde</td>
            <td>Hasta</td>
            <td>Asegurador</td>
            <td>Tipo</td>
            <td>Clasificación</td>
            <td>Cliente</td>
            <td>Estado</td>
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
            <td><asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM dbo.admEntidad WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
                <td><asp:DropDownList ID="DTipo" runat="server" 
                                DataSourceID="STipo" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="STipo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT tqrIdTipo id,tqrDescripcion nombre FROM serTipoFormulario ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td><asp:DropDownList ID="DClasificacion" runat="server" 
                                DataSourceID="SClasificacion" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SClasificacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=26 AND szReservado IS NULL ORDER BY nombre">
                </asp:SqlDataSource></td>
            <td>
                <asp:DropDownList runat="server" ID="DCliente">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Externo" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Interno" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:DropDownList runat="server" ID="DEstado">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Cerrado" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Atendido" Value="2"></asp:ListItem>
                    <asp:ListItem Text="Sin tramitar" Value="3"></asp:ListItem>
                </asp:DropDownList>
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
                AutoGenerateColumns="False" EmptyDataText="No se encontraron PQR" DataKeyNames="qrId"
                AllowPaging="True" PageSize="50" AllowSorting="True" OnRowDataBound="GResultados_RowDataBound" >
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:HyperLinkField DataTextField="qrFecha" HeaderText="Fecha" 
                        DataNavigateUrlFields="qrId" SortExpression="qrFecha"
                        DataNavigateUrlFormatString="~/cliente/quejas.aspx?qid={0}" 
                    ItemStyle-Wrap="false" />
                    <asp:BoundField HeaderText="Cliente" DataField="Cliente" SortExpression="Cliente" />
                    <asp:BoundField HeaderText="Usuario" DataField="nombre" SortExpression="nombre" />
                    <asp:BoundField HeaderText="Tipo" DataField="tqrDescripcion" SortExpression="tqrDescripcion" />
                    <asp:BoundField HeaderText="Clasificación" DataField="clasificacion" SortExpression="clasificacion" />
                    <asp:BoundField HeaderText="Descripción" DataField="qrDetalle" SortExpression="qrDetalle" />
                    <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" />
                    <asp:BoundField HeaderText="Estado" DataField="estado" SortExpression="estado" />
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div style="text-align: right;">
        <asp:DetailsView ID="DResumen" runat="server" AutoGenerateRows="False" DataSourceID="SResumen" HorizontalAlign="Right">
            <RowStyle CssClass="GridRow"></RowStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Fields>
                <asp:BoundField DataField="total" HeaderText="Total" ReadOnly="True" SortExpression="total" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField DataField="cerrados" HeaderText="Cerrados" ReadOnly="True" SortExpression="cerrados" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField DataField="atendidos" HeaderText="Atendidos" ReadOnly="True" SortExpression="atendidos" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField DataField="sinatender" HeaderText="Sin tramitar" ReadOnly="True" SortExpression="sinatender" HeaderStyle-HorizontalAlign="Left" />
            </Fields>
            
        </asp:DetailsView>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
        ConnectionString="<%$ ConnectionStrings:connBD %>" 
        SelectCommand="SELECT 
                    serQuejasReclamos.qrId
                    ,serQuejasReclamos.qrFecha
                    ,CASE serQuejasReclamos.qrTipoCliente WHEN 2 THEN 'Interno' ELSE 'Externo' END AS Cliente
                    ,ISNULL(phdPaciente.pacNombres, admPersonalHS.perNombre) AS nombre
                    ,serTipoFormulario.tqrDescripcion
                    ,serQuejasReclamos.qrPersonaLlama
                    ,serQuejasReclamos.qrDetalle
                    ,serQuejasReclamos.clasificacion
                    ,admEntidad.entNombre
                    ,CASE WHEN serQuejasReclamos.qrCerrado=1 THEN 'Cerrado' WHEN serQuejasReclamos.qrAtendido=1 THEN 'Atendido' ELSE 'Sin tramitar' END AS estado
                    FROM serQuejasReclamos
                    LEFT JOIN serTipoFormulario ON (serTipoFormulario.tqrIdTipo=serQuejasReclamos.tqrIdTipo)
                    LEFT JOIN admEntidad ON (admEntidad.entId=serQuejasReclamos.entId)
                    LEFT JOIN phdPaciente ON (phdPaciente.pacId=serQuejasReclamos.pacId)
                    LEFT JOIN admPersonalHS ON (admPersonalHS.perId=serQuejasReclamos.perId)
                    WHERE 
                    serQuejasReclamos.qrFecha BETWEEN @inicio AND @fin
                    AND (@asegurador=0 OR @asegurador=serQuejasReclamos.entId)
                    AND (@tipo=0 OR @tipo=serQuejasReclamos.tqrIdTipo)
                    AND (@clasificacion=0 OR @clasificacion=serQuejasReclamos.clasificacion)
                    AND (@cliente=0 OR @cliente=serQuejasReclamos.qrTipoCliente)
                    AND (@estado=0 
                        OR (@estado=1 AND serQuejasReclamos.qrCerrado=1) 
                        OR (@estado=2 AND serQuejasReclamos.qrCerrado=0 AND serQuejasReclamos.qrAtendido=1) 
                        OR (@estado=3 AND serQuejasReclamos.qrCerrado=0 AND serQuejasReclamos.qrAtendido=0))
                    ">
          <SelectParameters>
            <asp:ControlParameter ControlID="TInicio" PropertyName="Text" Name="inicio" />
            <asp:ControlParameter ControlID="TFin" PropertyName="Text" Name="fin" />
            <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
            <asp:ControlParameter ControlID="DTipo" PropertyName="SelectedValue" Name="tipo" />
            <asp:ControlParameter ControlID="DClasificacion" PropertyName="SelectedValue" Name="clasificacion" />
            <asp:ControlParameter ControlID="DCliente" PropertyName="SelectedValue" Name="cliente" />
            <asp:ControlParameter ControlID="DEstado" PropertyName="SelectedValue" Name="estado" />
          </SelectParameters>
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="SResumen" runat="server" 
        ConnectionString="<%$ ConnectionStrings:connBD %>" 
        SelectCommand="SELECT COUNT(*) AS total
                    ,COUNT(CASE estado WHEN 1 THEN 1 ELSE NULL END) AS cerrados 
                    ,COUNT(CASE estado WHEN 2 THEN 1 ELSE NULL END) AS atendidos 
                    ,COUNT(CASE estado WHEN 0 THEN 1 ELSE NULL END) AS sinatender
                    FROM 
                    (SELECT 
                    CASE WHEN qrCerrado=1 THEN 1 WHEN qrAtendido=1 THEN 2 ELSE 0 END AS estado
                    FROM serQuejasReclamos
                    WHERE 
                    qrFecha BETWEEN @inicio AND @fin
                    AND (@asegurador=0 OR @asegurador=entId)
                    AND (@tipo=0 OR @tipo=tqrIdTipo)
                    AND (@clasificacion=0 OR @clasificacion=clasificacion)
                    AND (@cliente=0 OR @cliente=qrTipoCliente)
                    AND (@estado=0 
                        OR (@estado=1 AND qrCerrado=1) 
                        OR (@estado=2 AND qrCerrado=0 AND qrAtendido=1) 
                        OR (@estado=3 AND qrCerrado=0 AND qrAtendido=0))
                    ) AS q
                    ">
          <SelectParameters>
            <asp:ControlParameter ControlID="TInicio" PropertyName="Text" Name="inicio" />
            <asp:ControlParameter ControlID="TFin" PropertyName="Text" Name="fin" />
            <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
            <asp:ControlParameter ControlID="DTipo" PropertyName="SelectedValue" Name="tipo" />
            <asp:ControlParameter ControlID="DClasificacion" PropertyName="SelectedValue" Name="clasificacion" />
            <asp:ControlParameter ControlID="DCliente" PropertyName="SelectedValue" Name="cliente" />
            <asp:ControlParameter ControlID="DEstado" PropertyName="SelectedValue" Name="estado" />
          </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

