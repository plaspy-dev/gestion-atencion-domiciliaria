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
<table class="style1">
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
    </table>
    <hr />
    <asp:Panel runat="server" ID="pnlReg">
    <table class="style1">
        <tr>
            <td>
                Vehiculo</td> 
            <td>
                <asp:DropDownList ID="DVehiculo" runat="server" 
                                DataSourceID="SVehiculo" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SVehiculo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT vehPlaca id, vehPlaca+', '+vehFabricante+', '+vehModelo nombre FROM dbo.vehVehiculo ORDER BY 2">
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
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT perId id,perNombre nombre FROM dbo.admPersonalHS where eEstId=1 and (carId=20 OR carId=36) order by 2">
                </asp:SqlDataSource>
            </td>
        </tr>
    </table>
        <table class="style1">
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
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT perId id, perNombre nombre FROM dbo.admPersonalHS where eEstId=1 order by 2">
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
    </asp:Panel>
    
    <br />
    <br />
    <asp:GridView ID="GRecorrido" runat="server" DataKeyNames="vrcId,conductorId,profesional" DataSourceID="SRecorrido"
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
            <asp:BoundField DataField="vrcObservacion" HeaderText="Observacion" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SRecorrido" runat="server" 
        ConnectionString="<%$ ConnectionStrings:connBD %>" 
        SelectCommand="SELECT vehRecorrido.vrcId,vehRecorrido.vehPlaca,admPersonalHS.perNombre,vehRecorrido.vrcDestino,vehRecorrido.vrcActividad,
vehRecorrido.vrcHoraLleg, vehRecorrido.vrcHoraSal,vehRecorrido.vrcObservacion,vehRecorrido.perIdProf AS profesional, admPersonalHS.perId AS conductorId
FROM vehRecorrido
LEFT JOIN admPersonalHS ON (admPersonalHS.perId = vehRecorrido.perId)
WHERE vehRecorrido.vrcFecha=@fecha"
            DeleteCommand="DELETE FROM vehRecorrido WHERE vrcId=@vrcId">
        <SelectParameters>
            <asp:ControlParameter ControlID="TFecha" PropertyName="Text" Name="fecha" />
        </SelectParameters>
    </asp:SqlDataSource>
    <div style="text-align: right">
        <asp:Label ID="LTotal" runat="server"></asp:Label>
        </div>
</asp:Content>

