<%@ Page Title="Consulta gestión ambiental" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="consulta.aspx.cs" Inherits="rutasanitaria_consulta" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Inicio</td>
            <td>Fin</td>
            <td>Asegurador</td>
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
            <td><asp:Button runat="server" ID="BBuscar" Text="Buscar" onclick="BBuscar_Click" /></td>
        </tr>
        </table>
    </asp:Panel>
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Visible="false" 
        AutoGenerateColumns="False" EmptyDataText="No se encontró gestión ambiental" 
        AllowPaging="True" PageSize="50" AllowSorting="True" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:HyperLinkField DataTextField="rtsFecha" HeaderText="Fecha" 
                DataNavigateUrlFields="rtsId" 
                DataNavigateUrlFormatString="~/gestionambiental/gestionambiental.aspx?gaid={0}" SortExpression="rtsFecha" DataTextFormatString="{0:d}" />
            <asp:BoundField HeaderText="Documento" DataField="pacDocumento" SortExpression="pacDocumento"/>
            <asp:BoundField HeaderText="Paciente" DataField="pacNombres" SortExpression="pacNombres"/>
            <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre"/>
            <asp:BoundField HeaderText="Vehículo" DataField="vehPlaca" SortExpression="vehPlaca"/>
            <asp:BoundField HeaderText="Dirección" DataField="pacDireccion" SortExpression="pacDireccion"/>
            <asp:BoundField HeaderText="Barrio" DataField="pacBarrio" SortExpression="pacBarrio"/>
            <asp:BoundField HeaderText="Zona" DataField="pacZona" SortExpression="pacZona"/>
            <asp:BoundField HeaderText="Teléfono" DataField="pacTelefono" SortExpression="pacTelefono"/>
            <asp:BoundField HeaderText="Peso" DataField="rtsPeso" SortExpression="rtsPeso" ItemStyle-HorizontalAlign="Right"/>
            <asp:BoundField HeaderText="Observaciones" DataField="rtsObservaciones" SortExpression="rtsObservaciones"/>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                                rtsId,rtsFecha
                                ,paciente.PacDocumento
                                ,paciente.pacNombres
                                ,asegurador.entNombre
                                ,vehPlaca
                                ,paciente.pacDireccion
                                ,paciente.pacBarrio
                                ,paciente.pacZona
                                ,paciente.pacTelefono
                                ,rtsObservaciones
                                ,rtsPeso
                                FROM ruta_sanitaria
                                LEFT JOIN paciente ON (paciente.pacId=ruta_sanitaria.pacId)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            WHERE DATE(rtsFecha) BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND (@asegurador=0 OR paciente.entId=@asegurador)
                            ORDER BY rtsFecha">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                 </SelectParameters>
    </asp:SqlDataSource>
    <div align="right"><asp:Label runat="server" ID="LResultado"></asp:Label></div>
</asp:Content>