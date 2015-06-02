<%@ Page Title="Informe EPS" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informeeps.aspx.cs" Inherits="clinicaheridas_informeeps" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">.GridHeader th {width: auto !important;}</style>
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
            <td>Entidad</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox></td>
            <td>
                <asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" Visible="false"
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" DataKeyNames="id"
                DataSourceID="SResultados" onrowdatabound="GResultados_RowDataBound" >
            <Columns>
                <asp:HyperLinkField HeaderText="NOMBRE" DataTextField="pacNombres" SortExpression="pacNombres" Target="_blank" DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/clinicaheridas/evolucion.aspx?hveid={0}" />
                <asp:BoundField HeaderText="SEXO" DataField="sexo" SortExpression="sexo" />
                <asp:BoundField HeaderText="TIPO DE DOCUMENTO" DataField="tdocDescripcion" SortExpression="tdocDescripcion" />
                <asp:BoundField HeaderText="N.DE DOCUMENTO" DataField="pacDocumento" SortExpression="pacDocumento" />
                <asp:BoundField HeaderText="IPS DOMICILIARIA" DataField="IPS" SortExpression="IPS" />
                <asp:HyperLinkField DataTextField="fecha" Target="_blank" SortExpression="Fecha" HeaderText="FECHA DE VALORACION (DD/MM/AAAA)" DataTextFormatString="{0:d}" DataNavigateUrlFields="id" DataNavigateUrlFormatString="~/clinicaheridas/evolucion.aspx?hveid={0}" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="EDAD" DataField="edad" SortExpression="edad" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="N° DE LESIONES" DataField="lesiones" SortExpression="lesiones" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="SUBPROCESO AUTORIZACION" DataField="Subproceso" SortExpression="Subproceso" />
                <asp:BoundField HeaderText="DIRECCION" DataField="pacDireccion" SortExpression="pacDireccion" />
                <asp:BoundField HeaderText="CIUDAD" DataField="Ciudad" SortExpression="Ciudad" />
                <asp:BoundField HeaderText="TELEFONO" DataField="pacTelefono" SortExpression="pacTelefono" />
                <asp:BoundField HeaderText="DIAGNOSTICO" DataField="diagnostico" SortExpression="diagnostico" />
                <asp:BoundField HeaderText="MES" DataField="fechaEvolucion" SortExpression="fechaEvolucion" DataFormatString="{0:MMMM}" />
                
                <asp:BoundField HeaderText="TIPO DE LESION 1" DataField="tipo1" SortExpression="tipo1" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano1" SortExpression="tamano1" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion1" SortExpression="localizacion1" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo1" SortExpression="ubicacionbolsillo1" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo1" SortExpression="tamanobolsillo1" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante1" SortExpression="pcircundante1" />
                <asp:BoundField HeaderText="CARACTERISTICAS DEL ESTOMA" DataField="estoma" SortExpression="estoma" />
                <asp:BoundField HeaderText="FISTULAS DE DRENAJE" DataField="fistula" SortExpression="fistula" />
                <asp:BoundField HeaderText="CANTIDAD DE AFLUENTE EN 24 H" DataField="afluente" SortExpression="afluente" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante1" SortExpression="tejidopredominante1" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion1" SortExpression="signoinfeccion1" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado1" SortExpression="exudado1" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado1" SortExpression="cantidadexudado1" />

                <asp:BoundField HeaderText="TIPO DE LESION 2" DataField="tipo2" SortExpression="tipo2" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano2" SortExpression="tamano2" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion2" SortExpression="localizacion2" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo2" SortExpression="ubicacionbolsillo2" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo2" SortExpression="tamanobolsillo2" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante2" SortExpression="pcircundante2" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante2" SortExpression="tejidopredominante2" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion2" SortExpression="signoinfeccion2" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado2" SortExpression="exudado2" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado2" SortExpression="cantidadexudado2" />

                <asp:BoundField HeaderText="TIPO DE LESION 3" DataField="tipo3" SortExpression="tipo3" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano3" SortExpression="tamano3" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion3" SortExpression="localizacion3" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo3" SortExpression="ubicacionbolsillo3" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo3" SortExpression="tamanobolsillo3" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante3" SortExpression="pcircundante3" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante3" SortExpression="tejidopredominante3" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion3" SortExpression="signoinfeccion3" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado3" SortExpression="exudado3" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado3" SortExpression="cantidadexudado3" />

                <asp:BoundField HeaderText="TIPO DE LESION 4" DataField="tipo4" SortExpression="tipo4" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano4" SortExpression="tamano4" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion4" SortExpression="localizacion4" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo4" SortExpression="ubicacionbolsillo4" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo4" SortExpression="tamanobolsillo4" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante4" SortExpression="pcircundante4" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante4" SortExpression="tejidopredominante4" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion4" SortExpression="signoinfeccion4" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado4" SortExpression="exudado4" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado4" SortExpression="cantidadexudado4" />

                <asp:BoundField HeaderText="TIPO DE LESION 5" DataField="tipo5" SortExpression="tipo5" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano5" SortExpression="tamano5" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion5" SortExpression="localizacion5" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo5" SortExpression="ubicacionbolsillo5" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo5" SortExpression="tamanobolsillo5" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante5" SortExpression="pcircundante5" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante5" SortExpression="tejidopredominante5" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion5" SortExpression="signoinfeccion5" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado5" SortExpression="exudado5" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado5" SortExpression="cantidadexudado5" />

                <asp:BoundField HeaderText="TIPO DE LESION 6" DataField="tipo6" SortExpression="tipo6" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano6" SortExpression="tamano6" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion6" SortExpression="localizacion6" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo6" SortExpression="ubicacionbolsillo6" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo6" SortExpression="tamanobolsillo6" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante6" SortExpression="pcircundante6" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante6" SortExpression="tejidopredominante6" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion6" SortExpression="signoinfeccion6" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado6" SortExpression="exudado6" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado6" SortExpression="cantidadexudado6" />

                <asp:BoundField HeaderText="TIPO DE LESION 7" DataField="tipo7" SortExpression="tipo7" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano7" SortExpression="tamano7" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion7" SortExpression="localizacion7" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo7" SortExpression="ubicacionbolsillo7" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo7" SortExpression="tamanobolsillo7" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante7" SortExpression="pcircundante7" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante7" SortExpression="tejidopredominante7" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion7" SortExpression="signoinfeccion7" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado7" SortExpression="exudado7" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado7" SortExpression="cantidadexudado7" />

                <asp:BoundField HeaderText="TIPO DE LESION 8" DataField="tipo8" SortExpression="tipo8" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano8" SortExpression="tamano8" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion8" SortExpression="localizacion8" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo8" SortExpression="ubicacionbolsillo8" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo8" SortExpression="tamanobolsillo8" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante8" SortExpression="pcircundante8" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante8" SortExpression="tejidopredominante8" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion8" SortExpression="signoinfeccion8" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado8" SortExpression="exudado8" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado8" SortExpression="cantidadexudado8" />

                <asp:BoundField HeaderText="TIPO DE LESION 9" DataField="tipo9" SortExpression="tipo9" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano9" SortExpression="tamano9" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion9" SortExpression="localizacion9" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo9" SortExpression="ubicacionbolsillo9" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo9" SortExpression="tamanobolsillo9" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante9" SortExpression="pcircundante9" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante9" SortExpression="tejidopredominante9" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion9" SortExpression="signoinfeccion9" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado9" SortExpression="exudado9" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado9" SortExpression="cantidadexudado9" />

                <asp:BoundField HeaderText="TIPO DE LESION 10" DataField="tipo10" SortExpression="tipo10" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano10" SortExpression="tamano10" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion10" SortExpression="localizacion10" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo10" SortExpression="ubicacionbolsillo10" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo10" SortExpression="tamanobolsillo10" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante10" SortExpression="pcircundante10" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante10" SortExpression="tejidopredominante10" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion10" SortExpression="signoinfeccion10" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado10" SortExpression="exudado10" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado10" SortExpression="cantidadexudado10" />

                <asp:BoundField HeaderText="TIPO DE LESION 11" DataField="tipo11" SortExpression="tipo11" />
                <asp:BoundField HeaderText="MEDIDAS (ANCHO X LARGO X PROFUNDIDAD) en cm" DataField="tamano11" SortExpression="tamano11" />
                <asp:BoundField HeaderText="LOCALIZACION ANATOMICA" DataField="localizacion11" SortExpression="localizacion11" />
                <asp:BoundField HeaderText="BOLSILLOS (UBICACION SEGUN MANECILLAS DEL RELOJ DE )" DataField="ubicacionbolsillo11" SortExpression="ubicacionbolsillo11" />
                <asp:BoundField HeaderText="PROFUNDIDAD DEL BOLSILLO (en cm)" DataField="tamanobolsillo11" SortExpression="tamanobolsillo11" />
                <asp:BoundField HeaderText="ESTADO DEL TEJIDO CIRCUNDANTE" DataField="pcircundante11" SortExpression="pcircundante11" />
                <asp:BoundField HeaderText="TEJIDO PREDOMINANTE" DataField="tejidopredominante11" SortExpression="tejidopredominante11" />
                <asp:BoundField HeaderText="SIGNOS DE INFECCION" DataField="signoinfeccion11" SortExpression="signoinfeccion11" />
                <asp:BoundField HeaderText="EXUDADO" DataField="exudado11" SortExpression="exudado11" />
                <asp:BoundField HeaderText="CANTIDAD DE EXUDADO" DataField="cantidadexudado11" SortExpression="cantidadexudado11" />

                <asp:BoundField HeaderText="INSUMO 1" DataField="medicamento1" SortExpression="medicamento1" />
                <asp:BoundField HeaderText="CANTIDAD DE INSUMO" DataField="formulada1" SortExpression="formulada1" />
                <asp:BoundField HeaderText="INSUMO 2" DataField="medicamento2" SortExpression="medicamento2" />
                <asp:BoundField HeaderText="CANTIDAD DE INSUMO" DataField="formulada2" SortExpression="formulada2" />
                <asp:BoundField HeaderText="INSUMO 3" DataField="medicamento3" SortExpression="medicamento3" />
                <asp:BoundField HeaderText="CANTIDAD DE INSUMO" DataField="formulada3" SortExpression="formulada3" />
                <asp:BoundField HeaderText="INSUMO 4" DataField="medicamento4" SortExpression="medicamento4" />
                <asp:BoundField HeaderText="CANTIDAD DE INSUMO" DataField="formulada4" SortExpression="formulada4" />
                <asp:BoundField HeaderText="FECHA DE CURACIONES" DataField="fechacuraciones" SortExpression="fechacuraciones" />
                <asp:BoundField HeaderText="COMPLEJIDAD DE CURACIONES" DataField="complejidad" SortExpression="complejidad" />
                <asp:BoundField HeaderText="NUMERO  DE CURACIONES MES" DataField="totalevoluciones" SortExpression="totalevoluciones" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="OBSERVACIONES" DataField="" SortExpression="" />
                <asp:BoundField HeaderText="TIEMPO ESTIMADO DE TRATAMIENTO ( semanas)" DataField="" SortExpression="" />

                <asp:TemplateField HeaderText="Lesión 1">
                    <ItemTemplate>
                        <asp:Image runat="server" Width="150px" ID="I1" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida1")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 2">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="I2" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida2")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 3">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="I3" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida3")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 4">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="I4" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida4")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 5">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="I5" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida5")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 6">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="I6" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida6")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 7">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="I7" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida7")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 8">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="I8" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida8")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 9">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="I9" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida9")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 10">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="I10" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida10")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 11">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="I11" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=v", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("id"),Eval("idherida11")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="Lesión 1">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L1" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida1")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 2">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L2" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida2")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 3">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L3" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida3")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 4">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L4" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida4")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 5">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L5" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida5")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 6">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L6" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida6")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 7">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L7" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida7")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 8">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L8" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida8")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 9">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L9" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida9")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 10">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L10" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida10")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lesión 11">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="L11" ImageUrl='<%# string.Format("{0}?p={1}&i={2}&hi={3}&w=150&h=150&x=1&t=fe", ResolveUrl("~/archivo/imagen.ashx"),Eval("paciente"),Eval("Idevolucion"),Eval("idherida11")) %>' />
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
            SelectCommand="SELECT 
                        valoracion_herida.id,valoracion_herida.paciente,evolucion_herida.id AS Idevolucion
                        ,paciente.pacNombres,IF(paciente.sexoId=2, 'Masculino', 'Femenino') AS sexo
                        ,tipo_documento.tdocDescripcion
                        ,paciente.pacDocumento
                        ,'OrganizationExample15 SAS' AS 'IPS'
                        ,valoracion_herida.fecha
                        ,TIMESTAMPDIFF(YEAR, paciente.pacFechaNac, NOW()) AS edad
                        ,COUNT(valoracion_herida_herida.id) AS 'lesiones'
                        ,'Subproceso'
                        ,paciente.pacDireccion
                        ,'Bogotá D.C.' AS 'Ciudad'
                        ,paciente.pacTelefono
                        ,paciente.cieCodDx AS diagnostico
                        ,evolucion_herida.fecha AS fechaEvolucion
                        ,CONCAT(IFNULL(valoracion_herida.ubicacion, ''),IFNULL(CONCAT(', ',color.nombre),''),IFNULL(CONCAT(', ',nivelpiel.nombre),''),IFNULL(CONCAT(', ',complicaciones.nombre),''),IFNULL(CONCAT(', ',estadopiel.nombre),'')) AS estoma
                        ,valoracion_herida.localizacion_fistula AS fistula
                        ,valoracion_herida.cantidad_afluente  AS afluente

                        ,NULL AS tipo1
                        ,IF(COALESCE(herida1.anchura,herida1.longitud,herida1.profundidad) IS NULL, '', CONCAT(IFNULL(herida1.anchura,'0'), 'x',IFNULL(herida1.longitud,'0'), 'x', IFNULL(herida1.profundidad,'0'))) AS tamano1
                        ,herida1.ubicacion_especifica AS localizacion1
                        ,herida1.bolsillo_ubicacion AS ubicacionbolsillo1
                        ,herida1.bolsillo_tamano AS tamanobolsillo1
                        ,pcircundante1.nombre AS pcircundante1
                        ,CASE GREATEST(IFNULL(herida1.compacto,0), IFNULL(herida1.fibrina,0), IFNULL(herida1.epitelizacion,0), IFNULL(herida1.escara,0), IFNULL(herida1.granulacion,0), IFNULL(herida1.hipergranulacion,0), IFNULL(herida1.limpio,0), IFNULL(herida1.necrosis,0))
                        WHEN herida1.compacto THEN 'Compacto'
								WHEN herida1.fibrina THEN 'De fibrina'
								WHEN herida1.epitelizacion THEN 'Epitelización'
								WHEN herida1.escara THEN 'Esfacelo'
								WHEN herida1.granulacion THEN 'Granulación'
								WHEN herida1.hipergranulacion THEN 'Hipergranulación'
								WHEN herida1.limpio THEN 'Limpio'
								WHEN herida1.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante1
                        ,herida1.signo_infeccion AS signoinfeccion1
                        ,tipo_exudado1.nombre AS exudado1
                        ,exudado1.nombre AS cantidadexudado1

                        ,NULL AS tipo2
                        ,IF(COALESCE(herida2.anchura,herida2.longitud,herida2.profundidad) IS NULL, '', CONCAT(IFNULL(herida2.anchura,'0'), 'x',IFNULL(herida2.longitud,'0'), 'x', IFNULL(herida2.profundidad,'0'))) AS tamano2
                        ,herida2.ubicacion_especifica AS localizacion2
                        ,herida2.bolsillo_ubicacion AS ubicacionbolsillo2
                        ,herida2.bolsillo_tamano AS tamanobolsillo2
                        ,pcircundante2.nombre AS pcircundante2
                        ,CASE GREATEST(IFNULL(herida2.compacto,0), IFNULL(herida2.fibrina,0), IFNULL(herida2.epitelizacion,0), IFNULL(herida2.escara,0), IFNULL(herida2.granulacion,0), IFNULL(herida2.hipergranulacion,0), IFNULL(herida2.limpio,0), IFNULL(herida2.necrosis,0))
                        WHEN herida2.compacto THEN 'Compacto'
								WHEN herida2.fibrina THEN 'De fibrina'
								WHEN herida2.epitelizacion THEN 'Epitelización'
								WHEN herida2.escara THEN 'Esfacelo'
								WHEN herida2.granulacion THEN 'Granulación'
								WHEN herida2.hipergranulacion THEN 'Hipergranulación'
								WHEN herida2.limpio THEN 'Limpio'
								WHEN herida2.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante2
                        ,herida2.signo_infeccion AS signoinfeccion2
                        ,tipo_exudado2.nombre AS exudado2
                        ,exudado2.nombre AS cantidadexudado2

                        ,NULL AS tipo3
                        ,IF(COALESCE(herida3.anchura,herida3.longitud,herida3.profundidad) IS NULL, '', CONCAT(IFNULL(herida3.anchura,'0'), 'x',IFNULL(herida3.longitud,'0'), 'x', IFNULL(herida3.profundidad,'0'))) AS tamano3
                        ,herida3.ubicacion_especifica AS localizacion3
                        ,herida3.bolsillo_ubicacion AS ubicacionbolsillo3
                        ,herida3.bolsillo_tamano AS tamanobolsillo3
                        ,pcircundante3.nombre AS pcircundante3
                        ,CASE GREATEST(IFNULL(herida3.compacto,0), IFNULL(herida3.fibrina,0), IFNULL(herida3.epitelizacion,0), IFNULL(herida3.escara,0), IFNULL(herida3.granulacion,0), IFNULL(herida3.hipergranulacion,0), IFNULL(herida3.limpio,0), IFNULL(herida3.necrosis,0))
                        WHEN herida3.compacto THEN 'Compacto'
								WHEN herida3.fibrina THEN 'De fibrina'
								WHEN herida3.epitelizacion THEN 'Epitelización'
								WHEN herida3.escara THEN 'Esfacelo'
								WHEN herida3.granulacion THEN 'Granulación'
								WHEN herida3.hipergranulacion THEN 'Hipergranulación'
								WHEN herida3.limpio THEN 'Limpio'
								WHEN herida3.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante3
                        ,herida3.signo_infeccion AS signoinfeccion3
                        ,tipo_exudado3.nombre AS exudado3
                        ,exudado3.nombre AS cantidadexudado3

                        ,NULL AS tipo4
                        ,IF(COALESCE(herida4.anchura,herida4.longitud,herida4.profundidad) IS NULL, '', CONCAT(IFNULL(herida4.anchura,'0'), 'x',IFNULL(herida4.longitud,'0'), 'x', IFNULL(herida4.profundidad,'0'))) AS tamano4
                        ,herida4.ubicacion_especifica AS localizacion4
                        ,herida4.bolsillo_ubicacion AS ubicacionbolsillo4
                        ,herida4.bolsillo_tamano AS tamanobolsillo4
                        ,pcircundante4.nombre AS pcircundante4
                        ,CASE GREATEST(IFNULL(herida4.compacto,0), IFNULL(herida4.fibrina,0), IFNULL(herida4.epitelizacion,0), IFNULL(herida4.escara,0), IFNULL(herida4.granulacion,0), IFNULL(herida4.hipergranulacion,0), IFNULL(herida4.limpio,0), IFNULL(herida4.necrosis,0))
                        WHEN herida4.compacto THEN 'Compacto'
								WHEN herida4.fibrina THEN 'De fibrina'
								WHEN herida4.epitelizacion THEN 'Epitelización'
								WHEN herida4.escara THEN 'Esfacelo'
								WHEN herida4.granulacion THEN 'Granulación'
								WHEN herida4.hipergranulacion THEN 'Hipergranulación'
								WHEN herida4.limpio THEN 'Limpio'
								WHEN herida4.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante4
                        ,herida4.signo_infeccion AS signoinfeccion4
                        ,tipo_exudado4.nombre AS exudado4
                        ,exudado4.nombre AS cantidadexudado4

                        ,NULL AS tipo5
                        ,IF(COALESCE(herida5.anchura,herida5.longitud,herida5.profundidad) IS NULL, '', CONCAT(IFNULL(herida5.anchura,'0'), 'x',IFNULL(herida5.longitud,'0'), 'x', IFNULL(herida5.profundidad,'0'))) AS tamano5
                        ,herida5.ubicacion_especifica AS localizacion5
                        ,herida5.bolsillo_ubicacion AS ubicacionbolsillo5
                        ,herida5.bolsillo_tamano AS tamanobolsillo5
                        ,pcircundante5.nombre AS pcircundante5
                        ,CASE GREATEST(IFNULL(herida5.compacto,0), IFNULL(herida5.fibrina,0), IFNULL(herida5.epitelizacion,0), IFNULL(herida5.escara,0), IFNULL(herida5.granulacion,0), IFNULL(herida5.hipergranulacion,0), IFNULL(herida5.limpio,0), IFNULL(herida5.necrosis,0))
                        WHEN herida5.compacto THEN 'Compacto'
								WHEN herida5.fibrina THEN 'De fibrina'
								WHEN herida5.epitelizacion THEN 'Epitelización'
								WHEN herida5.escara THEN 'Esfacelo'
								WHEN herida5.granulacion THEN 'Granulación'
								WHEN herida5.hipergranulacion THEN 'Hipergranulación'
								WHEN herida5.limpio THEN 'Limpio'
								WHEN herida5.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante5
                        ,herida5.signo_infeccion AS signoinfeccion5
                        ,tipo_exudado5.nombre AS exudado5
                        ,exudado5.nombre AS cantidadexudado5

                        ,NULL AS tipo6
                        ,IF(COALESCE(herida6.anchura,herida6.longitud,herida6.profundidad) IS NULL, '', CONCAT(IFNULL(herida6.anchura,'0'), 'x',IFNULL(herida6.longitud,'0'), 'x', IFNULL(herida6.profundidad,'0'))) AS tamano6
                        ,herida6.ubicacion_especifica AS localizacion6
                        ,herida6.bolsillo_ubicacion AS ubicacionbolsillo6
                        ,herida6.bolsillo_tamano AS tamanobolsillo6
                        ,pcircundante6.nombre AS pcircundante6
                        ,CASE GREATEST(IFNULL(herida6.compacto,0), IFNULL(herida6.fibrina,0), IFNULL(herida6.epitelizacion,0), IFNULL(herida6.escara,0), IFNULL(herida6.granulacion,0), IFNULL(herida6.hipergranulacion,0), IFNULL(herida6.limpio,0), IFNULL(herida6.necrosis,0))
                        WHEN herida6.compacto THEN 'Compacto'
								WHEN herida6.fibrina THEN 'De fibrina'
								WHEN herida6.epitelizacion THEN 'Epitelización'
								WHEN herida6.escara THEN 'Esfacelo'
								WHEN herida6.granulacion THEN 'Granulación'
								WHEN herida6.hipergranulacion THEN 'Hipergranulación'
								WHEN herida6.limpio THEN 'Limpio'
								WHEN herida6.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante6
                        ,herida6.signo_infeccion AS signoinfeccion6
                        ,tipo_exudado6.nombre AS exudado6
                        ,exudado6.nombre AS cantidadexudado6

                        ,NULL AS tipo7
                        ,IF(COALESCE(herida7.anchura,herida7.longitud,herida7.profundidad) IS NULL, '', CONCAT(IFNULL(herida7.anchura,'0'), 'x',IFNULL(herida7.longitud,'0'), 'x', IFNULL(herida7.profundidad,'0'))) AS tamano7
                        ,herida7.ubicacion_especifica AS localizacion7
                        ,herida7.bolsillo_ubicacion AS ubicacionbolsillo7
                        ,herida7.bolsillo_tamano AS tamanobolsillo7
                        ,pcircundante7.nombre AS pcircundante7
                        ,CASE GREATEST(IFNULL(herida7.compacto,0), IFNULL(herida7.fibrina,0), IFNULL(herida7.epitelizacion,0), IFNULL(herida7.escara,0), IFNULL(herida7.granulacion,0), IFNULL(herida7.hipergranulacion,0), IFNULL(herida7.limpio,0), IFNULL(herida7.necrosis,0))
                        WHEN herida7.compacto THEN 'Compacto'
								WHEN herida7.fibrina THEN 'De fibrina'
								WHEN herida7.epitelizacion THEN 'Epitelización'
								WHEN herida7.escara THEN 'Esfacelo'
								WHEN herida7.granulacion THEN 'Granulación'
								WHEN herida7.hipergranulacion THEN 'Hipergranulación'
								WHEN herida7.limpio THEN 'Limpio'
								WHEN herida7.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante7
                        ,herida7.signo_infeccion AS signoinfeccion7
                        ,tipo_exudado7.nombre AS exudado7
                        ,exudado7.nombre AS cantidadexudado7

                        ,NULL AS tipo8
                        ,IF(COALESCE(herida8.anchura,herida8.longitud,herida8.profundidad) IS NULL, '', CONCAT(IFNULL(herida8.anchura,'0'), 'x',IFNULL(herida8.longitud,'0'), 'x', IFNULL(herida8.profundidad,'0'))) AS tamano8
                        ,herida8.ubicacion_especifica AS localizacion8
                        ,herida8.bolsillo_ubicacion AS ubicacionbolsillo8
                        ,herida8.bolsillo_tamano AS tamanobolsillo8
                        ,pcircundante8.nombre AS pcircundante8
                        ,CASE GREATEST(IFNULL(herida8.compacto,0), IFNULL(herida8.fibrina,0), IFNULL(herida8.epitelizacion,0), IFNULL(herida8.escara,0), IFNULL(herida8.granulacion,0), IFNULL(herida8.hipergranulacion,0), IFNULL(herida8.limpio,0), IFNULL(herida8.necrosis,0))
                        WHEN herida8.compacto THEN 'Compacto'
								WHEN herida8.fibrina THEN 'De fibrina'
								WHEN herida8.epitelizacion THEN 'Epitelización'
								WHEN herida8.escara THEN 'Esfacelo'
								WHEN herida8.granulacion THEN 'Granulación'
								WHEN herida8.hipergranulacion THEN 'Hipergranulación'
								WHEN herida8.limpio THEN 'Limpio'
								WHEN herida8.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante8
                        ,herida8.signo_infeccion AS signoinfeccion8
                        ,tipo_exudado8.nombre AS exudado8
                        ,exudado8.nombre AS cantidadexudado8

                        ,NULL AS tipo9
                        ,IF(COALESCE(herida9.anchura,herida9.longitud,herida9.profundidad) IS NULL, '', CONCAT(IFNULL(herida9.anchura,'0'), 'x',IFNULL(herida9.longitud,'0'), 'x', IFNULL(herida9.profundidad,'0'))) AS tamano9
                        ,herida9.ubicacion_especifica AS localizacion9
                        ,herida9.bolsillo_ubicacion AS ubicacionbolsillo9
                        ,herida9.bolsillo_tamano AS tamanobolsillo9
                        ,pcircundante9.nombre AS pcircundante9
                        ,CASE GREATEST(IFNULL(herida9.compacto,0), IFNULL(herida9.fibrina,0), IFNULL(herida9.epitelizacion,0), IFNULL(herida9.escara,0), IFNULL(herida9.granulacion,0), IFNULL(herida9.hipergranulacion,0), IFNULL(herida9.limpio,0), IFNULL(herida9.necrosis,0))
                        WHEN herida9.compacto THEN 'Compacto'
								WHEN herida9.fibrina THEN 'De fibrina'
								WHEN herida9.epitelizacion THEN 'Epitelización'
								WHEN herida9.escara THEN 'Esfacelo'
								WHEN herida9.granulacion THEN 'Granulación'
								WHEN herida9.hipergranulacion THEN 'Hipergranulación'
								WHEN herida9.limpio THEN 'Limpio'
								WHEN herida9.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante9
                        ,herida9.signo_infeccion AS signoinfeccion9
                        ,tipo_exudado9.nombre AS exudado9
                        ,exudado9.nombre AS cantidadexudado9

                        ,NULL AS tipo10
                        ,IF(COALESCE(herida10.anchura,herida10.longitud,herida10.profundidad) IS NULL, '', CONCAT(IFNULL(herida10.anchura,'0'), 'x',IFNULL(herida10.longitud,'0'), 'x', IFNULL(herida10.profundidad,'0'))) AS tamano10
                        ,herida10.ubicacion_especifica AS localizacion10
                        ,herida10.bolsillo_ubicacion AS ubicacionbolsillo10
                        ,herida10.bolsillo_tamano AS tamanobolsillo10
                        ,pcircundante10.nombre AS pcircundante10
                        ,CASE GREATEST(IFNULL(herida10.compacto,0), IFNULL(herida10.fibrina,0), IFNULL(herida10.epitelizacion,0), IFNULL(herida10.escara,0), IFNULL(herida10.granulacion,0), IFNULL(herida10.hipergranulacion,0), IFNULL(herida10.limpio,0), IFNULL(herida10.necrosis,0))
                        WHEN herida10.compacto THEN 'Compacto'
								WHEN herida10.fibrina THEN 'De fibrina'
								WHEN herida10.epitelizacion THEN 'Epitelización'
								WHEN herida10.escara THEN 'Esfacelo'
								WHEN herida10.granulacion THEN 'Granulación'
								WHEN herida10.hipergranulacion THEN 'Hipergranulación'
								WHEN herida10.limpio THEN 'Limpio'
								WHEN herida10.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante10
                        ,herida10.signo_infeccion AS signoinfeccion10
                        ,tipo_exudado10.nombre AS exudado10
                        ,exudado10.nombre AS cantidadexudado10

                        ,NULL AS tipo11
                        ,IF(COALESCE(herida11.anchura,herida11.longitud,herida11.profundidad) IS NULL, '', CONCAT(IFNULL(herida11.anchura,'0'), 'x',IFNULL(herida11.longitud,'0'), 'x', IFNULL(herida11.profundidad,'0'))) AS tamano11
                        ,herida11.ubicacion_especifica AS localizacion11
                        ,herida11.bolsillo_ubicacion AS ubicacionbolsillo11
                        ,herida11.bolsillo_tamano AS tamanobolsillo11
                        ,pcircundante11.nombre AS pcircundante11
                        ,CASE GREATEST(IFNULL(herida11.compacto,0), IFNULL(herida11.fibrina,0), IFNULL(herida11.epitelizacion,0), IFNULL(herida11.escara,0), IFNULL(herida11.granulacion,0), IFNULL(herida11.hipergranulacion,0), IFNULL(herida11.limpio,0), IFNULL(herida11.necrosis,0))
                        WHEN herida11.compacto THEN 'Compacto'
								WHEN herida11.fibrina THEN 'De fibrina'
								WHEN herida11.epitelizacion THEN 'Epitelización'
								WHEN herida11.escara THEN 'Esfacelo'
								WHEN herida11.granulacion THEN 'Granulación'
								WHEN herida11.hipergranulacion THEN 'Hipergranulación'
								WHEN herida11.limpio THEN 'Limpio'
								WHEN herida11.necrosis THEN 'Necrosis'
								ELSE '' END AS tejidopredominante11
                        ,herida11.signo_infeccion AS signoinfeccion11
                        ,tipo_exudado11.nombre AS exudado11
                        ,exudado11.nombre AS cantidadexudado11

                        ,herida1.id AS IdHerida1
                        ,herida2.id AS IdHerida2
                        ,herida3.id AS IdHerida3
                        ,herida4.id AS IdHerida4
                        ,herida5.id AS IdHerida5
                        ,herida6.id AS IdHerida6
                        ,herida7.id AS IdHerida7
                        ,herida8.id AS IdHerida8
                        ,herida9.id AS IdHerida9
                        ,herida10.id AS IdHerida10
                        ,herida11.id AS IdHerida11

                        ,formulacion1.formulada AS formulada1
                        ,formulacion2.formulada AS formulada2
                        ,formulacion3.formulada AS formulada3
                        ,formulacion4.formulada AS formulada4

                        ,formulacion1.medicamento AS medicamento1
                        ,formulacion2.medicamento AS medicamento2
                        ,formulacion3.medicamento AS medicamento3
                        ,formulacion4.medicamento AS medicamento4

                        ,GROUP_CONCAT(DISTINCT complejidad.nombre) AS complejidad
                        ,COUNT(DISTINCT evolucion_herida_herida.id) AS totalevoluciones
                        ,GROUP_CONCAT(DISTINCT DATE(evolucion_herida.fecha) SEPARATOR '\n') AS fechacuraciones

                        FROM valoracion_herida
                        LEFT JOIN paciente ON (valoracion_herida.paciente=paciente.pacId)
                        LEFT JOIN tipo_documento ON (tipo_documento.tdocId=paciente.tdocId)
                        LEFT JOIN valoracion_herida_herida ON (valoracion_herida_herida.valoracion=valoracion_herida.id)
                        LEFT JOIN evolucion_herida ON (evolucion_herida.paciente=valoracion_herida.paciente)
                        LEFT JOIN evolucion_herida_herida ON (evolucion_herida_herida.evolucion=evolucion_herida.id)
                        LEFT JOIN varios AS complejidad ON (complejidad.id= evolucion_herida_herida.clasificacion)
                        LEFT JOIN varios AS color ON (color.id=valoracion_herida.color)
                        LEFT JOIN varios AS nivelpiel ON (nivelpiel.id=valoracion_herida.estoma)
                        LEFT JOIN varios AS complicaciones ON (complicaciones.id=valoracion_herida.complicaciones)
                        LEFT JOIN varios AS estadopiel ON (estadopiel.id=valoracion_herida.estado_piel)

                        LEFT JOIN evolucion_herida_herida AS herida1 ON (herida1.evolucion=evolucion_herida.id AND herida1.numero=1)
						LEFT JOIN evolucion_herida_herida AS herida2 ON (herida2.evolucion=evolucion_herida.id AND herida2.numero=2)
						LEFT JOIN evolucion_herida_herida AS herida3 ON (herida3.evolucion=evolucion_herida.id AND herida3.numero=3)
						LEFT JOIN evolucion_herida_herida AS herida4 ON (herida4.evolucion=evolucion_herida.id AND herida4.numero=4)
						LEFT JOIN evolucion_herida_herida AS herida5 ON (herida5.evolucion=evolucion_herida.id AND herida5.numero=5)
						LEFT JOIN evolucion_herida_herida AS herida6 ON (herida6.evolucion=evolucion_herida.id AND herida6.numero=6)
						LEFT JOIN evolucion_herida_herida AS herida7 ON (herida7.evolucion=evolucion_herida.id AND herida7.numero=7)
						LEFT JOIN evolucion_herida_herida AS herida8 ON (herida8.evolucion=evolucion_herida.id AND herida8.numero=8)
						LEFT JOIN evolucion_herida_herida AS herida9 ON (herida9.evolucion=evolucion_herida.id AND herida9.numero=9)
						LEFT JOIN evolucion_herida_herida AS herida10 ON (herida10.evolucion=evolucion_herida.id AND herida10.numero=10)
						LEFT JOIN evolucion_herida_herida AS herida11 ON (herida11.evolucion=evolucion_herida.id AND herida11.numero=11)
                       
                        LEFT JOIN varios AS pcircundante1 ON (pcircundante1.id=herida1.piel_circundante)
                        LEFT JOIN varios AS pcircundante2 ON (pcircundante2.id=herida2.piel_circundante)
                        LEFT JOIN varios AS pcircundante3 ON (pcircundante3.id=herida3.piel_circundante)
                        LEFT JOIN varios AS pcircundante4 ON (pcircundante4.id=herida4.piel_circundante)
                        LEFT JOIN varios AS pcircundante5 ON (pcircundante5.id=herida5.piel_circundante)
                        LEFT JOIN varios AS pcircundante6 ON (pcircundante6.id=herida6.piel_circundante)
                        LEFT JOIN varios AS pcircundante7 ON (pcircundante7.id=herida7.piel_circundante)
                        LEFT JOIN varios AS pcircundante8 ON (pcircundante8.id=herida8.piel_circundante)
                        LEFT JOIN varios AS pcircundante9 ON (pcircundante9.id=herida9.piel_circundante)
                        LEFT JOIN varios AS pcircundante10 ON (pcircundante10.id=herida10.piel_circundante)
                        LEFT JOIN varios AS pcircundante11 ON (pcircundante11.id=herida11.piel_circundante)

						LEFT JOIN varios AS exudado1 ON (exudado1.id=herida1.exudado)
                        LEFT JOIN varios AS exudado2 ON (exudado2.id=herida2.exudado)
                        LEFT JOIN varios AS exudado3 ON (exudado3.id=herida3.exudado)
                        LEFT JOIN varios AS exudado4 ON (exudado4.id=herida4.exudado)
                        LEFT JOIN varios AS exudado5 ON (exudado5.id=herida5.exudado)
                        LEFT JOIN varios AS exudado6 ON (exudado6.id=herida6.exudado)
                        LEFT JOIN varios AS exudado7 ON (exudado7.id=herida7.exudado)
                        LEFT JOIN varios AS exudado8 ON (exudado8.id=herida8.exudado)
                        LEFT JOIN varios AS exudado9 ON (exudado9.id=herida9.exudado)
                        LEFT JOIN varios AS exudado10 ON (exudado10.id=herida10.exudado)
                        LEFT JOIN varios AS exudado11 ON (exudado11.id=herida11.exudado)

                        LEFT JOIN varios AS tipo_exudado1 ON (tipo_exudado1.id=herida1.tipo_exudado)
						LEFT JOIN varios AS tipo_exudado2 ON (tipo_exudado2.id=herida2.tipo_exudado)
						LEFT JOIN varios AS tipo_exudado3 ON (tipo_exudado3.id=herida3.tipo_exudado)
						LEFT JOIN varios AS tipo_exudado4 ON (tipo_exudado4.id=herida4.tipo_exudado)
						LEFT JOIN varios AS tipo_exudado5 ON (tipo_exudado5.id=herida5.tipo_exudado)
						LEFT JOIN varios AS tipo_exudado6 ON (tipo_exudado6.id=herida6.tipo_exudado)
						LEFT JOIN varios AS tipo_exudado7 ON (tipo_exudado7.id=herida7.tipo_exudado)
						LEFT JOIN varios AS tipo_exudado8 ON (tipo_exudado8.id=herida8.tipo_exudado)
						LEFT JOIN varios AS tipo_exudado9 ON (tipo_exudado9.id=herida9.tipo_exudado)
						LEFT JOIN varios AS tipo_exudado10 ON (tipo_exudado10.id=herida10.tipo_exudado)
						LEFT JOIN varios AS tipo_exudado11 ON (tipo_exudado11.id=herida11.tipo_exudado)

                        LEFT JOIN formulacion ON (formulacion.paciente=valoracion_herida.paciente AND formulacion.fecha=valoracion_herida.fecha)
                        LEFT JOIN medicamento_formulacion AS formulacion1 ON (formulacion.id=formulacion1.formulacion AND formulacion1.numero=1)
						LEFT JOIN medicamento_formulacion AS formulacion2 ON (formulacion.id=formulacion2.formulacion AND formulacion2.numero=2)
						LEFT JOIN medicamento_formulacion AS formulacion3 ON (formulacion.id=formulacion3.formulacion AND formulacion3.numero=3)
						LEFT JOIN medicamento_formulacion AS formulacion4 ON (formulacion.id=formulacion4.formulacion AND formulacion4.numero=4)

                        WHERE 
                            valoracion_herida.paciente IN (SELECT paciente FROM evolucion_herida WHERE evolucion_herida.fecha BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (@asegurador=0 OR evolucion_herida.asegurador=@asegurador) GROUP BY paciente)
                            AND evolucion_herida.id IN (SELECT id FROM evolucion_herida WHERE evolucion_herida.paciente=valoracion_herida.paciente GROUP BY MONTH(fecha))
                        GROUP BY valoracion_herida.id">
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

