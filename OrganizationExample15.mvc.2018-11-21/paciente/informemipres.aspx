<%@ Page Title="Informe MIPRES" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="paciente_informemipres" Codebehind="informemipres.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Desde<asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
            <td>
                Hasta<asp:RequiredFieldValidator ControlToValidate="THasta" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>Asegurador</td>
            <td>&nbsp;</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox></td>
            <td><asp:DropDownList ID="DAsegurador" runat="server" CssClass="amc"
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
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
            <td><asp:LinkButton runat="server" ID="LDownload" Visible="false" OnClick="LDownload_Click">Descargar</asp:LinkButton></td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" 
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SResultados" DataKeyNames="id,pacId,numero" >
            <Columns>
                <asp:HyperLinkField DataNavigateUrlFields="id,pacId" SortExpression="numero" DataTextField="numero" HeaderText="N° DE PRESCRIPCION" Target="_blank" DataNavigateUrlFormatString="~/paciente/mipres.aspx?pid={1}&ampid={0}" />
                <asp:BoundField DataField="prescripcion" SortExpression="prescripcion" HeaderText="FECHA DE PRESCRIPCION" DataFormatString="{0:d}" ItemStyle-CssClass="r" />
                <asp:BoundField DataField="pacDocumento" SortExpression="pacDocumento" HeaderText="ID PACIENTE" />
                <asp:BoundField DataField="servicios" SortExpression="servicios" HeaderText="SERVICIO, MEDICAMENTO, TECNOLOGIA O NUTRICION FORMULADA" />
                <asp:BoundField DataField="elaboradopor" SortExpression="elaboradopor" HeaderText="MÉDICO QUE REALIZA LA JUNTA" />
                <asp:BoundField DataField="actaid" SortExpression="actaid" HeaderText="N° ACTA" />
                <asp:BoundField DataField="fecha" SortExpression="fecha" HeaderText="FECHA DE LA JUNTA" DataFormatString="{0:d}" ItemStyle-CssClass="r" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <a href="<%# ResolveClientUrl(string.Format("~/paciente/mipres.aspx?pid={0}&ampid={1}&pdf=1",Eval("pacId"),Eval("id"))) %>" class="btn btn-default">
                            <i class="fa fa-file-pdf-o"></i>
                        </a>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
        <asp:SqlDataSource ID="SResultados" runat="server" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            SelectCommand="SELECT mipres.id,IFNULL(mipres.actaid, mipres.id) actaid, mipres.prescripcion,mipres.numero,mipres.fecha
,paciente.pacDocumento
,paciente.pacId
,recurso_humano.perNombre elaboradopor
,GROUP_CONCAT(servicios.nombre) servicios
FROM mipres
LEFT JOIN paciente ON (paciente.pacId=mipres.paciente)
LEFT JOIN recurso_humano ON (recurso_humano.perId=mipres.elaboradopor)
LEFT JOIN varios servicios ON (FIND_IN_SET(servicios.id,mipres.servicios)!=0)
                            WHERE 
                            DATE(mipres.fecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                            AND (@asegurador=0 OR @asegurador=paciente.entId)
                            GROUP BY mipres.id
                            ORDER BY fecha
                            ">
            <SelectParameters>
                <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
                <asp:ControlParameter ControlID="DAsegurador" Name="asegurador" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

