<%@ Page Title="Productos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="productos.aspx.cs" Inherits="administrador_productos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        addFunctionToStart(function() {

            $("#<%= BImportar.ClientID %>").click(function() { return confirm('Puede realizar una copia de seguridad de los productos en el boton "Exportar".\nEsta acción no se puede deshacer.\n¿Esta seguro de importar este archivo?.'); });
            $("#tpr").tabs();
            $("#<%= TNombre.ClientID %>").autocomplete({
                source: function(request, response) {
                    $.ajax({
                        url: "../webservices/servicios.asmx/GetProducto",
                        data: "{ 'q': '" + request.term + "', 'p': '' }",
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataFilter: function(data) { return data; },
                        success: function(data) {
                            response($.map(data.d, function(item) {
                                item.label = item.ProductoCompleto;
                                return item;
                            }))
                        },
                        error: function(XMLHttpRequest, textStatus, errorThrown) {
                            alert(textStatus + ":" + errorThrown);
                        }
                    });
                },
                autoFocus: true,
                minLength: 3,
                select: function(event, ui) {

                    $.goURL("pid=" + ui.item.id);
                    return false;
                }
            });
            $("#<%= DVence.ClientID %>").change(function() {
                $("#<%= TDiasVencimiento.ClientID %>").attr("disabled", $(this).val() == "0");
            }).change();
            $("#<%= TFormatoLote.ClientID %>").change(function() {
                if ($(this).val().length == 0)
                    $("#sformatolote").text("Ejemplo: milote-%codigo%-%codigoalmacen%-%anoc%-%ano%-%mes%-%dia%");
                else {
                    var pad = "00";
                    var dia = new Date().getDate().toString();
                    var mes = (new Date().getMonth() + 1).toString();
                    var almacen = "1";
                    $("#sformatolote").text("Resultado: " +
                        $(this).val()
                        .replace("%codigo%", $("#<%= TCodigo.ClientID %>").val())
                        .replace("%codigoalmacen%", pad.substring(0, pad.length - almacen.length) + almacen)
                        .replace("%dia%", pad.substring(0, pad.length - dia.length) + dia)
                        .replace("%mes%", pad.substring(0, pad.length - mes.length) + mes)
                        .replace("%ano%", new Date().getFullYear().toString().substring(2))
                        .replace("%anoc%", new Date().getFullYear())
                    );
                }
            }).change();
        });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel ID="Panel1" runat="server" DefaultButton="BAceptar">
    <table width="100%" border="0">
  <tr>
    <td valign="top"><table width="100%" border="0">
      <tr>
        <td>
        <div id="tpr">
            <ul>
                <li><a href="#dProducto">Producto</a></li>
                <li><a href="#dMaxMin">Máximos y mínimos</a></li>
                <li runat="server" visible="false" id="lcostos"><a href="#<%= PCostos.ClientID %>">Costos</a></li>
                <li runat="server" visible="false" id="lprecios"><a href="#<%= UPrecios.ClientID %>">Precios</a></li>
                <li runat="server" visible="false" id="larchivos"><a href="#<%= PArchivos.ClientID %>">Exportar e importar</a></li>
            </ul>
            <div id="dProducto">
            <table width="100%" border="0" style="border-collapse: collapse">
          <tr>
            <td>Nombre</td>
            <td>
                <asp:TextBox ID="TNombre" runat="server" Width="98%"></asp:TextBox>
              </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="TNombre" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese un nombre." SetFocusOnError="True"></asp:RequiredFieldValidator>
              </td>
          </tr>
          <tr>
            <td>Descripción</td>
            <td>
                <asp:TextBox ID="TDescripcion" runat="server" Width="98%"></asp:TextBox>
              </td>
            <td align="right">
                <asp:HiddenField ID="HId" runat="server" />
              </td>
          </tr>
          <tr>
            <td>Código</td>
            <td>
                <asp:TextBox ID="TCodigo" runat="server"></asp:TextBox>
              </td>
                <td align="right">
              </td>
          </tr>
          <tr>
            <td>Empresa</td>
            <td>
                <asp:TextBox ID="TEmpresa" runat="server"></asp:TextBox>
              </td>
                <td align="right">
              </td>
          </tr>
          <tr>
            <td>Unidad de medida</td>
            <td>
                <asp:TextBox ID="TUnidad" runat="server"></asp:TextBox>
              </td>
            <td align="right">
              </td>
          </tr>
          <tr>
            <td>Grupo</td>
            <td>
            <asp:DropDownList ID="DGrupo" runat="server" AppendDataBoundItems="true" 
                    DataSourceID="SGrupo" DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Ninguno)" Value="0"></asp:ListItem>
            </asp:DropDownList>
            <asp:SqlDataSource ID="SGrupo" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=35 AND estado IS NULL ORDER BY nombre">
            </asp:SqlDataSource>
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
              <td nowrap="nowrap">
                  Manejo de cantidades</td>
              <td>
                  <asp:DropDownList ID="DCantidades" runat="server">
                      <asp:ListItem Text="Decimal" Value="0"></asp:ListItem>
                      <asp:ListItem Text="Entero" Value="1"></asp:ListItem>
                  </asp:DropDownList>
              </td>
              <td>
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                      ControlToValidate="DCantidades" Display="Dynamic" 
                      ErrorMessage="Por favor seleccione un valor." InitialValue="-1" 
                      SetFocusOnError="true"></asp:RequiredFieldValidator>
              </td>
          </tr>
          <tr>
            <td>Serial</td>
            <td><asp:DropDownList ID="DSerial" runat="server">
                    <asp:ListItem Text="(Ninguno)" Value="-1"></asp:ListItem>
                    <asp:ListItem Text="Obligatorio" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Opcional" Value="2"></asp:ListItem>
                    <asp:ListItem Text="No requerido" Value="0"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><asp:RequiredFieldValidator ControlToValidate="DSerial" InitialValue="-1" ErrorMessage="Por favor seleccione un valor." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator></td>
          </tr>
          <tr>
            <td>Estado</td>
            <td><asp:DropDownList ID="DEstado" runat="server">
                    <asp:ListItem Text="(Ninguno)" Value="-1"></asp:ListItem>
                    <asp:ListItem Text="Obligatorio" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Opcional" Value="2"></asp:ListItem>
                    <asp:ListItem Text="No requerido" Value="0"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><asp:RequiredFieldValidator ControlToValidate="DEstado" InitialValue="-1" ErrorMessage="Por favor seleccione un valor." ID="RequiredFieldValidator6" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator></td>
          </tr>
          <tr>
            <td colspan="3" class="GridHeader">Vencimiento</td>
          </tr>
          <tr>
            <td class="tdl">Fecha de vencimiento</td>
            <td><asp:DropDownList ID="DVence" runat="server">
                    <asp:ListItem Text="(Ninguna)" Value="-1"></asp:ListItem>
                    <asp:ListItem Text="Obligatoria" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Opcional" Value="2"></asp:ListItem>
                    <asp:ListItem Text="No requerida" Value="0"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td class="tdr">
            <asp:RequiredFieldValidator ControlToValidate="DVence" InitialValue="-1" ErrorMessage="Por favor seleccione un valor." ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator></td>
          </tr>
          <tr>
              <td class="tdl">Días para vencimiento</td>
              <td><asp:TextBox runat="server" ID="TDiasVencimiento" CssClass="entero"></asp:TextBox></td>
              <td class="tdr"><asp:RegularExpressionValidator ValidationExpression="[0-9]+" ID="REntero" runat="server" ErrorMessage="Por favor ingrese un numero entero." ControlToValidate="TDiasVencimiento" Display="Dynamic" SetFocusOnError="True"></asp:RegularExpressionValidator></td>
          </tr>
          <tr>
              <td class="tdl tdb">Días alerta vencimiento</td>
              <td class="tdb"><asp:TextBox runat="server" ID="TDAlertaV" CssClass="entero"></asp:TextBox></td>
              <td class="tdr tdb"><asp:RegularExpressionValidator ValidationExpression="[0-9]+" ID="RegularExpressionValidator1" runat="server" ErrorMessage="Por favor ingrese un numero entero." ControlToValidate="TDAlertaV" Display="Dynamic" SetFocusOnError="True"></asp:RegularExpressionValidator></td>
          </tr>
          <tr>
            <td colspan="3" class="GridHeader">Lote</td>
          </tr>
          <tr>
            <td class="tdl">Lote</td>
            <td>
                <asp:DropDownList ID="DLote" runat="server">
                    <asp:ListItem Text="(Ninguno)" Value="-1"></asp:ListItem>
                    <asp:ListItem Text="Obligatorio" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Opcional" Value="2"></asp:ListItem>
                    <asp:ListItem Text="No requerida" Value="0"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td class="tdr"><asp:RequiredFieldValidator ControlToValidate="DLote" InitialValue="-1" ErrorMessage="Por favor seleccione un valor." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator></td>
          </tr>
          <tr>
            <td class="tdl tdb">Formato lote</td>
            <td  class="tdb"><asp:TextBox runat="server" ID="TFormatoLote"></asp:TextBox> <span id="sformatolote"></span></td>
            <td class="tdr tdb"></td>
          </tr>
          <tr>
            <td></td>
            <td><asp:CheckBox runat="server" ID="COculto" Text="Produto oculto" /></td>
          </tr>
        </table>
            </div>
            <div id="dMaxMin" class="hide">
            <table>
                <tr>
                    <td></td>
                    <td colspan="2"><asp:CheckBox runat="server" ID="CMinMaxEstado" Text="Mínimos y máximos por estados" /></td>
                  </tr>
                  <tr>
                      <td>Mínimo global</td>
                      <td><asp:TextBox runat="server" ID="TMinimo" CssClass="float"></asp:TextBox></td>
                      <td><asp:RegularExpressionValidator ValidationExpression="[0-9]*[.]?[0-9]+" ID="RegularExpressionValidator3" runat="server" ErrorMessage="Por favor ingrese un numero." ControlToValidate="TMinimo" Display="Dynamic" SetFocusOnError="True"></asp:RegularExpressionValidator></td>
                  </tr>
                  <tr>
                      <td>Máximo global</td>
                      <td><asp:TextBox runat="server" ID="TMaximo" CssClass="float"></asp:TextBox></td>
                      <td><asp:RegularExpressionValidator ValidationExpression="[0-9]*[.]?[0-9]+" ID="RegularExpressionValidator2" runat="server" ErrorMessage="Por favor ingrese un numero." ControlToValidate="TMaximo" Display="Dynamic" SetFocusOnError="True"></asp:RegularExpressionValidator></td>
                  </tr>
            </table>
            </div>
            <asp:Panel runat="server" ID="PCostos" Visible="false" CssClass="hide">
                <table>
                  <tr>
                    <td>Último Costo</td>
                    <td><asp:TextBox runat="server" ID="TCosto" CssClass="dinero"></asp:TextBox></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td colspan="3" class="GridHeader">Costos por proveedor</td>
                  </tr>
                  <tr>
                    <td colspan="3">
                        <asp:GridView ID="GCostos" runat="server" DataSourceID="SCostos" 
                            AutoGenerateColumns="false" AllowSorting="True" AllowPaging="true" EmptyDataText="No hay proveedores">
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:BoundField HeaderText="Proveedor" DataField="nombre" SortExpression="nombre" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" SortExpression="fecha" ItemStyle-HorizontalAlign="Right" ItemStyle-Wrap="false" />
                                <asp:BoundField DataField="costo" HeaderText="Costo" SortExpression="costo" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:C}" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SCostos" runat="server"
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="select tercero.nombre,costo_proveedor.costo,costo_proveedor.fecha
                                        FROM costo_proveedor
                                        LEFT JOIN tercero ON (tercero.id=costo_proveedor.proveedor)
                                        WHERE costo_proveedor.producto=@producto
                                        ORDER BY costo_proveedor.fecha DESC
                                        ;">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="HId" PropertyName="Value" Name="producto" />
                                </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                  </tr>
                </table>
            </asp:Panel>
            <asp:UpdatePanel runat="server" ID="UPrecios" Visible="false" UpdateMode="Conditional">
                <ContentTemplate>
                <table>
                  <tr>
                    <td>Precio</td>
                    <td><asp:TextBox runat="server" ID="TPrecio" CssClass="dinero"></asp:TextBox></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>Último Precio</td>
                    <td><asp:TextBox runat="server" ID="TUltimoPrecio" CssClass="dinero"></asp:TextBox></td>
                    <td></td>
                  </tr>
                </table>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:Panel runat="server" ID="PArchivos" CssClass="hide" Visible="false">
                <table style="border-collapse: collapse">
                    <tr>
                        <td colspan="3">
                        Consideraciones para importar los productos
                        <ul>
                            <li>Es importante tener una copia de seguridad de los productos. Puede realizarla con el boton Exportar.</li>
                            <li>El archivo para importar tiene el mismo formato del exportado.</li>
                            <li>Los archivos deben tener en la primera línea las columnas que se van a modificar. </li>
                            <li>Para crear nuevos productos deje la columna 'id' en blanco. De lo contrario actualizara los existentes.</li>
                            <li>Si no se quiere modificar una columna se puede eliminar la columna. </li>
                            <li>Los grupos se crean automáticamente cuando no existen</li>
                            <li>Despues de una columna con el título en blanco el resto son omitidas</li>
                            <li>Las unica columna obligatoria es el 'id'.</li>
                            <li>El archivo debe estar codificado en UTF-7.</li>
                        </ul>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" class="GridHeader">Productos</td>
                    </tr>
                    <tr>
                        <td class="tdl">Exportar en archivo separador por comas</td>
                        <td><asp:Button runat="server" ID="BExportar" Text="Exportar" CausesValidation="false" onclick="BExportar_Click" /></td>
                        <td class="tdr"></td>
                    </tr>
                    <tr>
                        <td class="tdl tdb">Importar archivo separador por comas (Max: 20MB)</td>
                        <td class="tdb"><asp:FileUpload runat="server" ID="FImportar" /></td>
                        <td class="tdr tdb"><asp:Button runat="server" ID="BImportar" Text="Importar" ValidationGroup="archivo" onclick="BImportar_Click" /></td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <asp:RegularExpressionValidator ValidationGroup="archivo" ID="RFoto1" SetFocusOnError="true" ValidationExpression="^.+\.((csv)|(CSV))$" Display="Dynamic" ControlToValidate="FImportar" runat="server" ErrorMessage="Por favor seleccione un archivo csv valido."></asp:RegularExpressionValidator>
                            <asp:RequiredFieldValidator ValidationGroup="archivo" ControlToValidate="FImportar" ErrorMessage="Por favor seleccione una archivo." ID="RFFoto1" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
        </td>
      </tr>
      <tr>
        <td><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label></td>
      </tr>
      <tr>
        <td align="right">
             <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
             <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" />
             <asp:Button ID="BBuscar" runat="server" CausesValidation="false" onclick="BBuscar_Click" Text="Filtrar" />
             <asp:CheckBox ID="CFiltrado" runat="server" CssClass="hide" />
        </td>
      </tr>
      <tr>
        <td>
            <asp:GridView ID="GResultado" runat="server" AutoGenerateColumns="False" EmptyDataText="No se encontraron productos"
                DataKeyNames="id,estado" DataSourceID="SResultados" AllowSorting="true"
                onselectedindexchanged="GResultado_SelectedIndexChanged" 
                AllowPaging="true" PageSize="50" onrowdatabound="GResultado_RowDataBound" >
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                    <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" />
                    <asp:BoundField DataField="codigo" HeaderText="Código" SortExpression="codigo" />
                    <asp:BoundField DataField="unidad" HeaderText="Unidad" SortExpression="unidad" />
                    <asp:BoundField DataField="empresa" HeaderText="Empresa" SortExpression="empresa" />
                    <asp:BoundField DataField="descripcion" HeaderText="Descripción" SortExpression="descripcion" />
                    <asp:BoundField DataField="grupo" HeaderText="Grupo" SortExpression="grupo" />
                    <asp:BoundField DataField="entero" HeaderText="Manejo de cantidades" SortExpression="entero" />
                    <asp:BoundField DataField="serial" HeaderText="Serial" SortExpression="serial" />
                    <asp:BoundField DataField="nEstado" HeaderText="Estado" SortExpression="nEstado" />
                    <asp:BoundField DataField="vence" HeaderText="Fecha de vencimiento" SortExpression="vence" />
                    <asp:BoundField DataField="diasvencimiento" HeaderText="Días vencimiento" SortExpression="diasvencimiento" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="dias_alerta" HeaderText="Días alerta vencimiento" SortExpression="dias_alerta" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="lote" HeaderText="Lote" SortExpression="lote" />
                    <asp:BoundField DataField="formatolote" HeaderText="Formato lote" SortExpression="formatolote" />
                    <asp:BoundField DataField="maxmin_tipo" HeaderText="Mínimo y máximo por estados" SortExpression="maxmin_tipo" />
                    <asp:BoundField DataField="minimo" HeaderText="Mínimo global" SortExpression="minimo" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:F2}" />
                    <asp:BoundField DataField="maximo" HeaderText="Máximo global" SortExpression="maximo" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:F2}" />
                    <asp:BoundField DataField="costo" HeaderText="Último costo" SortExpression="costo" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="valor" HeaderText="Precio" SortExpression="valor" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:C}" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT producto.id,producto.nombre,producto.descripcion,producto.codigo,producto.unidad,producto.empresa 
                        ,CASE producto.vence WHEN 1 THEN 'Obligatoria' WHEN 2 THEN 'Opcional' ELSE 'No requerida' END AS vence
                        ,CASE producto.lote WHEN 1 THEN 'Obligatorio' WHEN 2 THEN 'Opcional' ELSE 'No requerido' END AS lote
                        ,CASE producto.nEstado WHEN 1 THEN 'Obligatorio' WHEN 2 THEN 'Opcional' ELSE 'No requerido' END AS nEstado
                        ,CASE producto.serial WHEN 1 THEN 'Obligatorio' WHEN 2 THEN 'Opcional' ELSE 'No requerido' END AS serial
                        ,CASE producto.entero WHEN 1 THEN 'Entero' ELSE 'Decimal' END AS entero
                        ,varios.nombre AS grupo
                        ,producto.formatolote
                        ,producto.costo
                        ,producto.valor
                        ,producto.diasvencimiento
                        ,producto.dias_alerta
                        ,producto.minimo
                        ,producto.maximo
                        ,CASE producto.maxmin_tipo WHEN 1 THEN 'Si' ELSE 'No' END AS maxmin_tipo
                        ,producto.estado
                        FROM producto 
                        LEFT JOIN varios ON (producto.grupo=varios.id)
                        WHERE (producto.estado IS NULL OR producto.estado=1)
                        AND (@filtrado=0 
                        OR (
                            ((producto.estado=@oculto=1) OR (@oculto=0 AND producto.estado IS NULL))
                            AND (@vence=-1 OR producto.vence=@vence)
                            AND (@lote=-1 OR producto.lote=@lote)
                            AND (@cantidades=-1 OR producto.entero=@cantidades)
                            AND (@serial=-1 OR producto.serial=@serial)
                            AND (@estado=-1 OR producto.nEstado=@estado)
                            AND (@nombre='_' OR producto.nombre LIKE CONCAT('%', @nombre,'%'))
                            AND (@unidad='_' OR producto.unidad LIKE CONCAT('%', @unidad,'%'))
                            AND (@codigo='_' OR producto.codigo LIKE CONCAT('%', @codigo,'%'))
                            AND (@descripcion='_' OR producto.descripcion LIKE CONCAT('%', @descripcion,'%'))
                        ))
                        ORDER BY codigo,nombre
                        " 
                DeleteCommand="UPDATE producto SET estado=-1 WHERE id=@id" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="CFiltrado" PropertyName="Checked" Name="filtrado" />
                    <asp:ControlParameter ControlID="DVence" PropertyName="SelectedValue" Name="vence" />
                    <asp:ControlParameter ControlID="DLote" PropertyName="SelectedValue" Name="lote" />
                    <asp:ControlParameter ControlID="DCantidades" PropertyName="SelectedValue" Name="cantidades" />
                    <asp:ControlParameter ControlID="DEstado" PropertyName="SelectedValue" Name="estado" />
                    <asp:ControlParameter ControlID="DSerial" PropertyName="SelectedValue" Name="serial" />
                    <asp:ControlParameter ControlID="TNombre" PropertyName="Text" Name="nombre" DefaultValue="_" />
                    <asp:ControlParameter ControlID="TDescripcion" PropertyName="Text" Name="descripcion" DefaultValue="_" />
                    <asp:ControlParameter ControlID="TUnidad" PropertyName="Text" Name="unidad" DefaultValue="_" />
                    <asp:ControlParameter ControlID="TCodigo" PropertyName="Text" Name="codigo" DefaultValue="_" />
                    <asp:ControlParameter ControlID="COculto" PropertyName="Checked" Name="oculto" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
          </td>
      </tr>
    </table></td>
  </tr>
</table>
</asp:Panel>
</asp:Content>

