<%@ Page Title="Evento adverso o incidente en la IPS" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="eventoa.aspx.cs" Inherits="auditoria_eventoa" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= TProfesional.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetPersonal",
                    data: "{ 'q': '" + request.term + "' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            select: function(event, ui) {
                $("#<%= TProfesionalID.ClientID %>").val(ui.item.value);
                $("#<%= BProfesional.ClientID %>").click();
                return false;
            }
        });
        $("#<%= PEventos.ClientID %>").accordion({
            autoHeight: false,
            collapsible: true,
            active: false
        });
        $("#<%= BEliminar.ClientID %>").click(function () {
            return confirm("¿Esta seguro de eliminar este evento adverso?. Esta acción no se puede deshacer.");
        });

        FullRowSelect("#<%= GEventos.ClientID %>");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:Panel runat="server" id="PDatos" Visible="false">
        <asp:HiddenField runat="server" ID="HIdEvento" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table>
            <tr>
                <td colspan="4">
                <asp:Panel ID="PEventos" runat="server">
                    <h3><a href="#"><asp:Label runat="server" ID="LEventos"></asp:Label></a></h3>
                    <div class="hide">
                        <asp:GridView ID="GEventos" runat="server" AutoGenerateColumns="False"  Width="100%"
                            DataKeyNames="id" DataSourceID="SEventos" EmptyDataText="No se encontraron eventos de este usuario" >
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton CommandArgument='<%# Eval("id") %>' ID="IIr" runat="server" CausesValidation="False" ImageUrl="~/imgs/edit.gif" onclick="IIr_Click"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:d}" SortExpression="fecha" />
                                <asp:BoundField DataField="descripcion" HeaderText="Descripción" SortExpression="descripcion" ItemStyle-Width="100%" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SEventos" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id,fecha,descripcion FROM evento_adverso WHERE paciente=@paciente ORDER BY fecha DESC;">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="CCDetallePaciente" Name="paciente" PropertyName="IdPaciente" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    Fecha</td>
                <td>
                    <asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidator3" runat="server" 
                        ControlToValidate="TFecha" Display="Dynamic" 
                        ErrorMessage="Por favor ingrese una fecha valida." MaximumValue="01/01/2100" 
                        MinimumValue="01/01/1930" Type="Date">*</asp:RangeValidator>
                </td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>Descripción</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TDescripcion" Width="98%" 
                        TextMode="MultiLine" Height="80px"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TDescripcion" ErrorMessage="Por favor ingrese una descripción." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Tipo de evento adverso</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:DataList runat="server" ID="DTipo" DataSourceID="STipo" DataKeyField="id">
                    <ItemTemplate>
                        <asp:CheckBox runat="server" ID="CTipo" Text='<%# Eval("nombre") %>' Checked='<%# Eval("evento").ToString()!="" %>' />
                    </ItemTemplate>
                </asp:DataList>
                <asp:SqlDataSource ID="STipo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,tipo_evento_adverso.id AS evento FROM varios LEFT JOIN tipo_evento_adverso ON (tipo_evento_adverso.evento=@evento AND tipo_evento_adverso.tipo=varios.id) WHERE varios.tipo=17 AND varios.szReservado IS NULL">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HIdEvento" PropertyName="Value" Name="evento" DefaultValue="0" />
                      </SelectParameters>
                </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Consecuencias del evento adverso</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:DataList runat="server" ID="DConsecuencias" DataSourceID="SConsecuencias" DataKeyField="id" RepeatColumns="2">
                    <ItemTemplate>
                        <asp:CheckBox runat="server" ID="CTipo" Text='<%# Eval("nombre") %>' Checked='<%# Eval("evento").ToString()!="" %>' />
                    </ItemTemplate>
                </asp:DataList>
                <asp:SqlDataSource ID="SConsecuencias" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,consecuencias_evento_adverso.id AS evento FROM varios LEFT JOIN consecuencias_evento_adverso ON (consecuencias_evento_adverso.evento=@evento AND consecuencias_evento_adverso.consecuencia=varios.id) WHERE varios.tipo=18 AND varios.szReservado IS NULL">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="HIdEvento" PropertyName="Value" Name="evento" DefaultValue="0" />
                      </SelectParameters>
                </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td>Otro</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TOConsecuencia" Width="98%"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Datos del reportante y la institución</td>
            </tr>
            <tr>
                <td>Funcionario</td>
                <td colspan="2"><asp:TextBox runat="server" ID="TProfesional" Width="98%"></asp:TextBox>
                    <asp:TextBox runat="server" ID="TProfesionalID" CssClass="hide"></asp:TextBox>
                    <asp:Button runat="server" ID="BProfesional" CausesValidation="false" CssClass="hide"
                        Text="..." onclick="BProfesional_Click" /></td>
                <td><b><asp:Label runat="server" ID="LProfesion"></asp:Label><asp:Label runat="server" ID="LTProfesional"></asp:Label></b></td>
            </tr>
            <tr>
                <td>Observaciones</td>
                <td colspan="3"><asp:TextBox runat="server" ID="TObservaciones" Width="98%" 
                        TextMode="MultiLine" Height="80px"></asp:TextBox></td>
            </tr>
            <tr>
                <td><asp:Button runat="server" ID="BEliminar" CausesValidation="false" Visible="false" Text="Eliminar" OnClick="BEliminar_Click" /></td>
                <td colspan="3" align="right">
                <asp:ValidationSummary runat="server" ID="ValidationSummary1" />
                <asp:Button runat="server" ID="BAceptar" 
                        Text="Aceptar" onclick="BAceptar_Click" /><asp:Button runat="server" 
                        ID="BCancelar" Text="Cancelar" CausesValidation="false" 
                        onclick="BCancelar_Click" /></td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>