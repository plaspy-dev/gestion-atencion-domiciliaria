<%@ Page Title="Recorrido vehiculos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="recorrido.aspx.cs" Inherits="vehiculos_recorrido" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    var fecha="";
    $(function() {
        fecha = $('#<%= TFecha.ClientID %>').val();
        $('#<%= TIr.ClientID %>').hide();
        $('#<%= TFecha.ClientID %>').datepicker({
            onClose: function(dateText, inst) {
                if (fecha != $('#<%= TFecha.ClientID %>').val())
                    $('#<%= TIr.ClientID %>').click();
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<table>
    <tr>
        <td>
            Fecha</td>
        <td>
            <asp:TextBox runat="server" ID="TFecha" CssClass="fecha" AutoPostBack="true"></asp:TextBox>
            <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
            <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            <asp:Button ID="TIr" runat="server" Text="Ir" CausesValidation="false" />
        </td>
    </tr>
    <tr>
        <td colspan="2"><hr /></td>
    </tr>
    <tr>
        <td>
            Vehiculo</td> 
        <td>
            <asp:DropDownList ID="DVehiculo" runat="server" 
                            DataSourceID="SVehiculo" DataTextField="nombre" 
                            DataValueField="id">
                            </asp:DropDownList>
            <asp:SqlDataSource ID="SVehiculo" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT vehPlaca AS id, CONCAT(vehPlaca,', ',vehFabricante,', ',vehModelo) AS nombre FROM vehiculo ORDER BY 2">
            </asp:SqlDataSource>
        </td>
    </tr>
    <tr>
        <td>
            Conductor</td>
        <td>
            <asp:DropDownList ID="DConductor" runat="server" 
                            DataSourceID="SConductor" DataTextField="nombre" 
                            DataValueField="id">
                            </asp:DropDownList>
            <asp:SqlDataSource ID="SConductor" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT perId id,perNombre nombre 
                        FROM recurso_humano 
                        LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)
                        WHERE recurso_humano.eEstId=1 
                        AND cargo.carDescripcion like '%conductor%'
                        ORDER BY nombre;">
            </asp:SqlDataSource>
        </td>
    </tr>
    <tr>
        <td>
            Lugar</td>
        <td>
            <asp:TextBox runat="server" ID="TLugar"></asp:TextBox>
            <asp:RequiredFieldValidator ControlToValidate="TLugar" ErrorMessage="Por favor ingrese un lugar." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td>
            Actividad</td>
        <td>
            <asp:TextBox runat="server" ID="TActividad"></asp:TextBox>
            <asp:RequiredFieldValidator ControlToValidate="TActividad" ErrorMessage="Por favor ingrese una actividad." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
        </td>
    </tr>
        <tr>
            <td>
                Profesional</td>
            <td>
                <asp:DropDownList ID="DProfesional" runat="server" 
                            DataSourceID="SProfesional" DataTextField="nombre" 
                            DataValueField="id" AppendDataBoundItems="true">
                            <asp:ListItem Text="" Value=""></asp:ListItem>
                            </asp:DropDownList>
                <asp:SqlDataSource ID="SProfesional" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT perId id, perNombre nombre FROM recurso_humano where eEstId=1 order by 2">
                </asp:SqlDataSource>
            </td>
        </tr>
    <tr>
        <td>
            Hora llegada</td>
        <td>
            <asp:TextBox runat="server" ID="TLlegada" CssClass="hora"></asp:TextBox>
            <asp:RequiredFieldValidator ControlToValidate="TLlegada" ErrorMessage="Por favor ingrese una hora de llegada." ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td>
            Hora salida</td>
        <td>
            <asp:TextBox runat="server" ID="TSalida" CssClass="hora"></asp:TextBox>
        </td>
    </tr>
        <tr>
        <td>
            Observaciones</td>
        <td>
            <asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="258px"></asp:TextBox>
            </td>
    </tr>
        <tr>
        <td colspan="2" style="text-align: right">
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
            <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                onclick="BAceptar_Click" />
            <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                CausesValidation="false" onclick="BCancelar_Click" />
            </td>
     </tr>
</table>    
    <br />
    <br />
    <asp:GridView ID="GRecorrido" runat="server" DataKeyNames="vrcId,conductorId,profesional" DataSourceID="SRecorrido" Width="100%"
        EmptyDataText="No se ha registrado recorrido del día" 
        AutoGenerateColumns="False" 
        onselectedindexchanged="GRecorrido_SelectedIndexChanged">
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
            <asp:BoundField DataField="vehPlaca" HeaderText="Placa" />
            <asp:BoundField DataField="perNombre" HeaderText="Conductor">
            <ItemStyle Wrap="false" /></asp:BoundField>
            <asp:BoundField DataField="vrcDestino" HeaderText="Lugar" />
            <asp:BoundField DataField="vrcActividad" HeaderText="Actividad" />
            <asp:BoundField DataField="vrcHoraLleg" HeaderText="Hora Llegada" >
            <ItemStyle HorizontalAlign="Right" /></asp:BoundField>
            <asp:BoundField DataField="vrcHoraSal" HeaderText="Hora Salida" >
            <ItemStyle HorizontalAlign="Right" /></asp:BoundField>
            <asp:BoundField DataField="vrcObservacion" HeaderText="Observacion" ItemStyle-Width="100%" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SRecorrido" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT vehiculo_recorrido.vrcId,vehiculo_recorrido.vehPlaca,recurso_humano.perNombre,vehiculo_recorrido.vrcDestino,vehiculo_recorrido.vrcActividad,
vehiculo_recorrido.vrcHoraLleg, vehiculo_recorrido.vrcHoraSal,vehiculo_recorrido.vrcObservacion,vehiculo_recorrido.perIdProf AS profesional, recurso_humano.perId AS conductorId
FROM vehiculo_recorrido
LEFT JOIN recurso_humano ON (recurso_humano.perId = vehiculo_recorrido.perId)
WHERE vehiculo_recorrido.vrcFecha=STR_TO_DATE(@fecha, '%d/%m/%Y')"
            DeleteCommand="DELETE FROM vehiculo_recorrido WHERE vrcId=@vrcId">
        <SelectParameters>
            <asp:ControlParameter ControlID="TFecha" PropertyName="Text" Name="fecha" />
        </SelectParameters>
    </asp:SqlDataSource>
    <div style="text-align: right">
        <asp:Label ID="LTotal" runat="server"></asp:Label>
        </div>
</asp:Content>

