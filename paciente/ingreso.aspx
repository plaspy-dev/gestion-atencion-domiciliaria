<%@ Page Title="Hoja de ingreso" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ingreso.aspx.cs" Inherits="paciente_ingreso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
	.ui-autocomplete {
		max-height: 200px;
		overflow-y: auto;
		/* prevent horizontal scrollbar */
		overflow-x: hidden;
		/* add padding to account for vertical scrollbar */
		padding-right: 20px;
		text-align: left;
	}
	/* IE 6 doesn't support max-height
	 * we use height instead, but this forces the menu to always be this tall
	 */
	* html .ui-autocomplete {
		height: 200px;
	}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="Panel1" DefaultButton="IBuscar">
    <fieldset>
        <legend>Datos del paciente</legend>
        <table>
            <tr>
                <td>
    <table>
        <tr>
                <td>
                    Documento
                    <asp:SqlDataSource ID="SDocumentos" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT [tdocId], [tdocDescripcion] FROM [phdTipoDocumento]">
                    </asp:SqlDataSource>
                </td>
                <td>
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <table>
                        <tr>
                            <td>
                            <asp:DropDownList ID="DDocumento" runat="server" 
                                DataSourceID="SDocumentos" DataTextField="tdocDescripcion" 
                                DataValueField="tdocId">
                                </asp:DropDownList>
                            </td>
                            <td><asp:TextBox ID="TDocumento" runat="server" ValidationGroup="documento" 
                                CssClass="entero"></asp:TextBox>
                            </td>
                        </tr>
                        </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td>
                    <asp:UpdatePanel ID="UBuscar" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Button ID="IBuscar" runat="server" Text="..." onclick="IBuscar_Click" ValidationGroup="documento" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:HiddenField ID="HId" runat="server" Value="" />
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="TDocumento" ErrorMessage="Por favor ingrese un documento." 
                        SetFocusOnError="True" ValidationGroup="documento"></asp:RequiredFieldValidator>
                </td>
                <td>&nbsp;
                    </td>
            </tr>
        <tr>
            <td>
                Apellidos</td>
            <td>
                <asp:Label runat="server" ID="LApellidos"></asp:Label>
            </td>
            <td>
                Nombres</td>
            <td>
                <asp:Label runat="server" ID="LNombres"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Entidad</td>
            <td>
                <asp:Label runat="server" ID="LEntidad"></asp:Label>
            </td>
            <td>
                Tipo de afiliado</td>
            <td>
                <asp:Label runat="server" ID="LTAfiliado"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Sexo</td>
            <td>
                <asp:Label ID="LSexo" runat="server"></asp:Label>
            </td>
            <td>
                Edad</td>
            <td>
                <asp:Label ID="LEdad" runat="server"></asp:Label>
            </td>
        </tr>
    </table>
    </td>
            </tr>
            <tr>
                <td>
                <asp:Repeater ID="RCodigosC10" runat="server" DataSourceID="SCodigosC10">
                <HeaderTemplate>
                <fieldset>
                <legend>CIE 10</legend>
                <table>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr><td>
                    <%# Eval("descripcion") %>
                    </td></tr>
                </ItemTemplate>
                <FooterTemplate>
                </table>
                </fieldset>
                </FooterTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="SCodigosC10" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT descripcion FROM codigos_ingreso WHERE ingreso_paciente=@idingreso" >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HIdIngreso" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource>
                </td>
            </tr>
        </table>
    </fieldset></asp:Panel>
    <fieldset>
    <legend>II. Información de atención básica</legend>
   	  <table border="0">
  <tr>
    <td>
    <table border="0" width="100%">
        <tr>
            <td class="td1">
                Medico que atiende<asp:HiddenField ID="HIdIngreso" runat="server" />
            </td>
            <td>
                <asp:DropDownList ID="DMedico" runat="server" DataSourceID="SMedicos" 
                DataTextField="perNombre" DataValueField="perId"> </asp:DropDownList>
            <asp:SqlDataSource ID="SMedicos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="SELECT perId,perNombre FROM admPersonalHS WHERE eEstId=1 and carId=6 ORDER BY perNombre">
            </asp:SqlDataSource>
                Hora<asp:TextBox ID="THora" runat="server" CssClass="hora"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="td1">
                Motivo consulta</td>
            <td>
                <asp:TextBox ID="TMotivo" runat="server" Width="100%" TextMode="MultiLine"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="td1">
                Según</td>
            <td>
                <asp:DropDownList ID="DMotivo" runat="server" DataSourceID="SMotivos" 
                DataTextField="nombre" DataValueField="id"></asp:DropDownList>
            <asp:SqlDataSource ID="SMotivos" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=1 AND szReservado IS NULL" >
            </asp:SqlDataSource>
            </td>
        </tr>
    </table>
      </td>
  </tr>
  <tr><td><hr /></td></tr>
  <tr>
    <td><table width="100%" border="0">
      <tr>
        <td> Enfermedad actual<br />
          <asp:TextBox ID="TEnfermedadActual" runat="server" Height="120px" 
                TextMode="MultiLine" Width="100%"></asp:TextBox></td>
        <td><table border="0">
          <tr>
            <td>TA</td>
            <td><asp:TextBox ID="TTA" runat="server" CssClass="likenumber"></asp:TextBox></td>
            <td>mm/Hg</td>
          </tr>
          <tr>
            <td>FC</td>
            <td><asp:TextBox ID="TFC" runat="server" CssClass="entero"></asp:TextBox></td>
            <td>Lat/min</td>
          </tr>
          <tr>
            <td>FR</td>
            <td><asp:TextBox ID="TFR" runat="server" CssClass="entero"></asp:TextBox></td>
            <td>Min</td>
          </tr>
          <tr>
            <td>T</td>
            <td><asp:TextBox ID="TT" runat="server" CssClass="float"></asp:TextBox></td>
            <td>&deg;</td>
          </tr>
          <tr>
            <td>Peso</td>
            <td><asp:TextBox ID="TPeso" runat="server" CssClass="float"></asp:TextBox></td>
            <td>Kg</td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
  <tr><td><hr /></td></tr>
  <tr>
    <td><table border="0" width="100%">
      <tr>
        <td class="td1"><asp:GridView ID="GAntecedentes" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="id, antecedente" DataSourceID="SAntecendentes">
                <Columns>
                    <asp:TemplateField HeaderText="Antecedentes">
                        <ItemTemplate>
                            <asp:CheckBox ID="CSi" runat="server" Checked='<%# Eval("estado").ToString()=="1" ? true : false %>' Text='<%# Eval("nombre") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SAntecendentes" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre,antecedentes_ingreso.id AS antecedente,antecedentes_ingreso.estado AS estado FROM varios LEFT JOIN antecedentes_ingreso ON (antecedentes_ingreso.ingreso_paciente=@idingreso AND antecedentes_ingreso.motivo=varios.id) WHERE varios.tipo=2 AND varios.szReservado IS NULL" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdIngreso" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
          </td>
        <td>
            <asp:GridView ID="GRevision" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="id,revision" DataSourceID="SRevision">
                <Columns>
                    <asp:BoundField DataField="nombre" HeaderText="Revisión sistemas" />
                    <asp:TemplateField HeaderText="Nor">
                        <ItemTemplate>
                            <asp:CheckBox ID="CNor" runat="server" Checked='<%# Eval("nor").ToString()=="1" ? true : false %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Pat">
                        <ItemTemplate>
                            <asp:CheckBox ID="CPat" runat="server" Checked='<%# Eval("pat").ToString()=="1" ? true : false %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SRevision" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre,revision_ingreso.id AS revision,revision_ingreso.nor AS nor, revision_ingreso.pat AS pat FROM varios LEFT JOIN revision_ingreso ON (revision_ingreso.ingreso_paciente=@idingreso AND revision_ingreso.motivo=varios.id) WHERE varios.tipo=3 AND varios.szReservado IS NULL" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdIngreso" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
          </td>
        <td style="width: 50%; vertical-align: top;">Observaciones<br />
            <asp:TextBox ID="TObservacionesAntecedentes" runat="server" Height="150px" 
                TextMode="MultiLine" Width="100%"></asp:TextBox>
            <br />
          </td>
      </tr>
    </table></td>
  </tr>
  <tr><td><hr /></td></tr>
  <tr>
    <td>
        <asp:Panel runat="server" ID="PMujer">
            <fieldset>
                <legend>Datos ginecológicos</legend>
                <asp:Repeater ID="RVarios" runat="server" DataSourceID="SVarios">
                <ItemTemplate>
                    <asp:CheckBox ID="CVarios" runat="server" Checked='<%# Eval("estado").ToString()=="1" ? true : false %>' Text='<%# Eval("nombre") %>' />
                    <asp:HiddenField runat="server" ID="HId" Value='<%# Eval("id") %>' />
                    <asp:HiddenField runat="server" ID="HIdVarios" Value='<%# Eval("varios") %>' />
                </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="SVarios" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre,varios_ingreso.id AS varios, varios_ingreso.estado AS estado FROM varios LEFT JOIN varios_ingreso ON (varios_ingreso.ingreso_paciente=@idingreso AND varios_ingreso.motivo=varios.id) WHERE varios.tipo=5 AND varios.szReservado IS NULL" >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HIdIngreso" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource><br />
                Ampliación de la información<asp:TextBox ID="TAmpliacion" runat="server" 
                    TextMode="MultiLine" Width="99%"></asp:TextBox>    
            </fieldset>
        </asp:Panel>
        </td>
  </tr>
  <tr><td><hr /></td></tr>
  <tr>
    <td><table border="0" width="100%">
      <tr>
        <td><asp:GridView ID="GExamenFisico" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="id, examen" DataSourceID="SExamenFisico">
            <Columns>
                <asp:BoundField DataField="nombre" HeaderText="Examen físico" />
                <asp:TemplateField HeaderText="Nor">
                    <ItemTemplate>
                        <asp:CheckBox ID="CNor" runat="server" Checked='<%# Eval("nor").ToString()=="1" ? true : false %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Pat">
                    <ItemTemplate>
                        <asp:CheckBox ID="CPat" runat="server" Checked='<%# Eval("pat").ToString()=="1" ? true : false %>'/>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SExamenFisico" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT varios.id AS id, varios.nombre AS nombre, examen_ingreso.id AS examen,examen_ingreso.nor AS nor,examen_ingreso.pat AS pat FROM varios LEFT JOIN examen_ingreso ON (examen_ingreso.ingreso_paciente=@idingreso AND examen_ingreso.motivo=varios.id) WHERE varios.tipo=4 AND varios.szReservado IS NULL" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="HIdIngreso" Name="idingreso" PropertyName="Value" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
          </td>
        <td style="width: 50%; vertical-align: top;">Observaciones<br />
            <asp:TextBox ID="TObservacionesFisico" runat="server" Height="150px" 
                TextMode="MultiLine" Width="100%"></asp:TextBox>
          </td>
      </tr>
    </table></td>
  </tr>
  <tr><td><hr /></td></tr>
  <tr>
    <td><table border="0">
      <tr>
        <td class="td1">Código diagnostico de ingreso</td>
        <td>
            <asp:TextBox ID="TDIngreso" runat="server"></asp:TextBox>
          </td>
        <td>Código diagnostico de egreso</td>
        <td>
            <asp:TextBox ID="TDEgreso" runat="server"></asp:TextBox>
          </td>
      </tr>
      <tr>
        <td>Descripción del diagnóstico</td>
        <td>
            <asp:TextBox ID="TDescripcionIngreso" runat="server"></asp:TextBox>
          </td>
        <td>Descripción de diagnóstico</td>
        <td>
            <asp:TextBox ID="TDescripcionEgreso" runat="server"></asp:TextBox>
          </td>
      </tr>
      </table>
      </td>
  </tr>
  <tr>
    <td><fieldset>
    <legend>Código de diagnóstico</legend>
    <asp:UpdatePanel ID="UCDiagnostico" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="GCDiagnostico" runat="server" DataSourceID="SCDiagnostico" 
                AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
            <Columns>
                <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                <asp:BoundField DataField="codigo" HeaderText="Código" />
                <asp:BoundField DataField="descripcion" HeaderText="Descripción" />
            </Columns>
            <SelectedRowStyle CssClass="selecteditem" />
        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Button ID="BMasCDiagnostico" runat="server" onclick="BMasCDiagnostico_Click" 
                            Text="+" />
                    </td>
                </tr>
            </table>
        <sdg:CustomDataSource ID="SCDiagnostico" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,codigo,descripcion FROM codigos_ingreso WHERE ingreso_paciente=@ingreso"
                            DeleteCommand="DELETE FROM codigos_ingreso WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdIngreso" DefaultValue="0" PropertyName="Value" Name="ingreso" />
                            </SelectParameters>
        </sdg:CustomDataSource>
            <div id="dCDiagnostico" title="Código de diagnóstico">
            <asp:DetailsView ID="DCDiagnostico" runat="server" Width="100%" 
                DataSourceID="SDCDiagnostico" DataKeyNames="id" 
                AutoGenerateRows="False" DefaultMode="Edit" 
                oniteminserted="DCDiagnostico_ItemInserted" 
                onitemupdated="DCDiagnostico_ItemUpdated" 
                onitemcommand="DCDiagnostico_ItemCommand">
                <Fields>
                    <asp:TemplateField HeaderText="codigo">
                        <EditItemTemplate>
                            <asp:TextBox ID="TCodigo" Width="200px" runat="server" Text='<%# Bind("codigo") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor seleccione un código." ControlToValidate="TDescripcion" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TCodigo" Width="200px" runat="server" Text='<%# Bind("codigo") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor seleccione un código." ControlToValidate="TDescripcion" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("codigo") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="descripcion">
                        <EditItemTemplate>
                            <asp:TextBox ID="TDescripcion" Width="200px" runat="server" Text='<%# Bind("descripcion") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TDescripcion" Width="200px" runat="server" Text='<%# Bind("descripcion") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("descripcion") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <sdg:CustomDataSource ID="SDCDiagnostico" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,codigo,descripcion FROM codigos_ingreso WHERE id=@id"
                            InsertCommand="INSERT INTO codigos_ingreso(ingreso_paciente,codigo,descripcion) VALUES (@ingreso, @codigo, @descripcion)"
                            UpdateCommand="UPDATE codigos_ingreso SET codigo=@codigo,descripcion=@descripcion WHERE id=@id" 
                            ParentDataSource="SCDiagnostico"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GCDiagnostico" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:ControlParameter ControlID="GCDiagnostico" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </UpdateParameters>
        </sdg:CustomDataSource>
        </ContentTemplate>
        </asp:UpdatePanel>
    </fieldset>
    </td>
  </tr>
  <tr>
    <td>Conducta inicial<br />
        <asp:TextBox ID="TConductaInicial" runat="server" Height="200px" 
            TextMode="MultiLine" Width="100%"></asp:TextBox>
      </td>
  </tr>
  <tr>
    <td align="right">
        <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" 
            Text="Aceptar" />
        <asp:Button ID="BCancelar" runat="server" CausesValidation="False" 
            onclick="BCancelar_Click" Text="Cancelar" />
      </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
      </table>
    </fieldset>
    <script type="text/javascript">
        function iniciopagina() {
            $("#ctl00_cph_TDocumento").blur(function() { if ($.getUrlVar('id') != $(this).val()) $("#ctl00_cph_IBuscar").click(); });
        }
        $('#ctl00_cph_UCDiagnostico').panelUpdated(function() {
            addDialog("#ctl00_cph_UCDiagnostico", "#dCDiagnostico");
            $('#ctl00_cph_DCDiagnostico_TDescripcion').attr("disabled","true");
            $("#ctl00_cph_DCDiagnostico_TCodigo").autocomplete({
                source: function(request, response) {
                    $.ajax({
                        url: "../webservices/servicios.asmx/GetCodigoDiagnosticos",
                        data: "{}",
                        data: "{ 'q': '" + request.term + "' }",
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataFilter: function(data) { return data; },
                        success: function(data) {
                            response($.map(data.d, function(item) {
                                return {
                                    value: item.Value, label: item.Name
                                }
                            }))
                        },
                        error: function(XMLHttpRequest, textStatus, errorThrown) {
                            alert(textStatus);
                        }
                    });
                },
                minLength: 2,
                select: function(event, ui) {
                    $('#ctl00_cph_DCDiagnostico_TDescripcion').val(ui.item.label);
                    return true;
                },
                search: function(event, ui) {
                    $('#ctl00_cph_DCDiagnostico_TDescripcion').val("");
                }
            });
        });
        
        $(function() {
            $("#ctl00_cph_TTA").mask("999/99");
        });
    </script>
</asp:Content>

