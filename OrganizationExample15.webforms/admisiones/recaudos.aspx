<%@ Page Title="Informe de recaudos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="recaudos.aspx.cs" Inherits="admisiones_recaudos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table>
        <tr>
            <td>Desde</td>
            <td>Hasta</td>
            <td>Asegurador</td>
            <td>Estado</td>
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
                                DataValueField="id" AppendDataBoundItems="true" CssClass="anchomaxcombo">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
                <asp:DropDownList runat="server" ID="DEstado" CssClass="anchomaxcombo">
                    <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Autorización Sin valor" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Con saldo" Value="2"></asp:ListItem>
                    <asp:ListItem Text="Cancelado" Value="3"></asp:ListItem>
                    <asp:ListItem Text="Cancelado parcial" Value="4"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                <asp:Button runat="server" ID="BBuscar" Text="Buscar" OnClick="BBuscar_Click" />
            </td>
        </tr>
    </table>
    <div id="dImprimir">
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
        AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones" Visible="false"
        AllowPaging="False" PageSize="50" AllowSorting="True" ShowFooter="true">
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="autNumero" HeaderText="Autorización" 
                DataNavigateUrlFields="autNumero" 
                DataNavigateUrlFormatString="~/admisiones/recibos.aspx?aut={0}" SortExpression="autNumero" Target="_blank" />
            <asp:BoundField HeaderText="Fecha" DataField="autFecha" SortExpression="autFecha" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Vencimiento" DataField="autFechaVenc" SortExpression="autFechaVenc" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Right" />
            <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Documento" DataNavigateUrlFields="pacId" SortExpression="pacDocumento"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-HorizontalAlign="Right" Target="_blank" />
            <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" DataNavigateUrlFields="pacId" SortExpression="pacNombres"
                DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" ItemStyle-Wrap="false" Target="_blank" />
            <asp:BoundField HeaderText="Direccion" DataField="pacDireccion" SortExpression="pacDireccion"/>
            <asp:BoundField HeaderText="Teléfono" DataField="pacTelefono" SortExpression="pacTelefono"/>
            <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre"/>
            <asp:TemplateField HeaderText="copia" SortExpression="copia" ItemStyle-CssClass="r">
                <ItemTemplate>
                    <asp:CheckBox Enabled="false" runat="server" Checked='<%# Eval("copia").ToString()=="1" %>' ID="C" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="Observaciones" DataField="autObservaciones" SortExpression="autObservaciones"/>
            <asp:TemplateField HeaderText="Exonerado" SortExpression="exonerado" ItemStyle-CssClass="r">
                <ItemTemplate>
                    <asp:CheckBox Enabled="false" runat="server" Checked='<%# Eval("exonerado").ToString()=="1" %>' ID="E" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="Valor" DataField="valor" SortExpression="valor" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Cancelado" DataField="pagado" SortExpression="pagado" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Saldo" DataField="saldo" SortExpression="saldo" DataFormatString="{0:C0}" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" FooterStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" />
        </Columns>
    </asp:GridView>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT autorizacion.autNumero,autorizacion.autFecha,autorizacion.autFechaVenc,autorizacion.autObservaciones
                            ,paciente.pacDocumento,paciente.pacNombres,paciente.pacDireccion,paciente.pacId
                            ,autorizacion.copia
                            ,IF(autorizacion.exonerado=1, 'Si', NULL) exonerado
                            ,paciente.pacTelefono
                            ,asegurador.entNombre
                            ,IFNULL(total,0) AS valor
                            ,IFNULL(pago_autorizacion.valor,0) AS pagado
                            ,IFNULL(total,0)-IFNULL(pago_autorizacion.valor,0) AS saldo
                            FROM autorizacion
                            LEFT JOIN paciente ON (paciente.pacId=autorizacion.pacId)
                            LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            LEFT JOIN (
	                            SELECT autNumero,SUM(valor) AS valor FROM pago_autorizacion GROUP BY pago_autorizacion.autNumero
							) AS pago_autorizacion ON (pago_autorizacion.autNumero=autorizacion.autNumero)
                            WHERE DATE(autorizacion.autFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND autorizacion.autActivo=1
                            AND (total IS NOT NULL OR pago_autorizacion.autNumero IS NOT NULL)
                            AND (@asegurador=0 OR paciente.entId=@asegurador)
                            AND (@estado=0 
                                OR (@estado=1 AND total IS NULL) 
                                OR (@estado=2 AND (total-pago_autorizacion.valor>0 OR ISNULL(pago_autorizacion.valor))) 
                                OR (@estado=3 AND total-pago_autorizacion.valor=0) 
                                OR (@estado=4 AND total-pago_autorizacion.valor))
                            GROUP BY autorizacion.autNumero
                            ORDER BY autorizacion.autFecha">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DEstado" Name="estado" PropertyName="SelectedValue" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

