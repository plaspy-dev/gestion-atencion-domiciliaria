<%@ Page Title="Nómina" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="eventos_nomina" Codebehind="nomina.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table>
        <tr>
            <td>Evento</td>
            <td>Desde</td>
            <td>Hasta</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:DropDownList ID="DEvento" runat="server" DataSourceID="SEvento" CssClass="anchomaxcombo"
                        DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true"
                        AutoPostBack="True" onselectedindexchanged="DEvento_SelectedIndexChanged">
                        <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SEvento" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT programacion_evento.id AS id
                                ,CONCAT(programacion_evento.nombre,'-',varios.nombre) AS nombre1
                                ,CAST(CONCAT(programacion_evento.nombre,' (', DATE_FORMAT(programacion_evento.inicio,'%d/%m/%Y'),'-',DATE_FORMAT(programacion_evento.fin,'%d/%m/%Y'), ')') AS CHAR) AS nombre
                                FROM programacion_evento 
                                LEFT JOIN varios ON (varios.id=programacion_evento.lugar)
                                WHERE inicio<=SYSDATE() AND DATE_ADD(fin,INTERVAL 60 DAY)>=SYSDATE() 
                                ORDER BY nombre,inicio,fin" >
                                <SelectParameters>
                                </SelectParameters>
                </asp:SqlDataSource></td>
                <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha"></asp:TextBox></td>
                <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox></td>
                <td><asp:Button runat="server" ID="BIr" Text="Ir" onclick="BIr_Click" /></td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GResultados" runat="server" AutoGenerateColumns="False" ShowFooter="true"
                    DataSourceID="SResultados" EmptyDataText="No se encontro asistencia a eventos">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <SelectedRowStyle CssClass="selecteditem" />
                    <Columns>
                        <asp:BoundField DataField="cargo" HeaderText="Cargo" SortExpression="cargo" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="personal" HeaderText="Funcionario" SortExpression="personal" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="horas" HeaderText="Horas" SortExpression="horas" DataFormatString="{0:0.00}" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="vhora" HeaderText="Valor hora" SortExpression="vhora" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="valor" HeaderText="Valor" SortExpression="valor" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SResultados" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT recurso_humano.perNombres AS personal
                                    ,cargo.carDescripcion AS cargo 
                                    ,SUM(HOUR(SUBTIME(asistencia.salida,asistencia.ingreso))+MINUTE(SUBTIME(asistencia.salida,asistencia.ingreso))/60) AS horas
                                    ,IF(cargo.CarId IN (6,66),programacion_evento.vmedico, programacion_evento.vauxiliar) AS vhora
                                    ,SUM(HOUR(SUBTIME(asistencia.salida,asistencia.ingreso))+MINUTE(SUBTIME(asistencia.salida,asistencia.ingreso))/60)*IF(cargo.CarId IN (6,66),programacion_evento.vmedico, programacion_evento.vauxiliar) AS valor
                                    FROM asistencia 
                                    LEFT JOIN recurso_humano ON (recurso_humano.perId=asistencia.personal) 
                                    LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)
                                    LEFT JOIN programacion_evento ON (programacion_evento.id=asistencia.evento)
                                    WHERE 
                                    (@programacion=0 OR asistencia.evento=@programacion)
                                    AND (@inicio=' ' OR @fin=' ' OR asistencia.fecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y'))
                                    GROUP BY personal
                                    ORDER BY cargo, personal"
                    >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="DEvento" Name="programacion" PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                        <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text"  />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GAmbulancias" runat="server" AutoGenerateColumns="False" ShowFooter="true"
                    DataSourceID="SAmbulancias" EmptyDataText="No se encontraron ambulancias en el evento">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <SelectedRowStyle CssClass="selecteditem" />
                    <Columns>
                        <asp:BoundField DataField="empresa" HeaderText="Empresa" SortExpression="empresa" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="tipo" HeaderText="Tipo" SortExpression="tipo" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="codigo" HeaderText="Código" SortExpression="codigo" ItemStyle-Wrap="false" ItemStyle-Width="100%" />
                        <asp:BoundField DataField="horas" HeaderText="Horas" SortExpression="horas" DataFormatString="{0:0.00}" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="vhora" HeaderText="Valor hora" SortExpression="vhora" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="valor" HeaderText="Valor" SortExpression="valor" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SAmbulancias" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT 
                                    programacion_evento_ambulancia.codigo,IF(tipo=1, 'TAM', 'TAB') AS tipo,empresa,ingreso,salida
                                    ,SUM(HOUR(SUBTIME(asistencia_ambulancia.salida,asistencia_ambulancia.ingreso))+MINUTE(SUBTIME(asistencia_ambulancia.salida,asistencia_ambulancia.ingreso))/60) AS horas
                                    ,IF(tipo=1, programacion_evento.vtam,programacion_evento.vtab) AS vhora
                                    ,SUM(HOUR(SUBTIME(asistencia_ambulancia.salida,asistencia_ambulancia.ingreso))+MINUTE(SUBTIME(asistencia_ambulancia.salida,asistencia_ambulancia.ingreso))/60)*IF(tipo=1, programacion_evento.vtam,programacion_evento.vtab) AS valor
                                    FROM asistencia_ambulancia
                                    LEFT JOIN programacion_evento ON (programacion_evento.id=asistencia_ambulancia.evento)
                                    LEFT JOIN programacion_evento_ambulancia ON (programacion_evento_ambulancia.evento=asistencia_ambulancia.evento AND programacion_evento_ambulancia.codigo=asistencia_ambulancia.codigo)
                                    WHERE 
                                    (@programacion=0 OR asistencia_ambulancia.evento=@programacion)
                                    AND (@inicio=' ' OR @fin=' ' OR asistencia_ambulancia.fecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y'))
                                    GROUP BY codigo
                                    ORDER BY empresa, codigo"
                    >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="DEvento" Name="programacion" PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="TDesde" Name="inicio" PropertyName="Text" />
                        <asp:ControlParameter ControlID="THasta" Name="fin" PropertyName="Text"  />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" align="right">
            </td>
        </tr>
    </table>
</asp:Content>

