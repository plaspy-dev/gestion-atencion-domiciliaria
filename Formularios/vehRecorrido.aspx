<%@ Page Title="Recorrido de Vehículos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="vehRecorrido.aspx.vb" Inherits="ML.vehRecorrido" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<%@ Register src="../Controles/Hora.ascx" tagname="Hora" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">    
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

    <table class="style1">
        <tr>
            <td>
                Fecha</td>
            <td>
                <uc1:Fecha ID="fchFechaRec" runat="server" AutoPostBack="true"/>
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
                <uc2:DropDownListU ID="ddlVehiculo" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                Conductor</td>
            <td>
                <uc2:DropDownListU ID="ddlConductor" runat="server" />
            </td>
        </tr>
    </table>
        <table class="style1">
        <tr>
            <td>
                Lugar</td>
            <td>
                <ml:TextBox ID="txtDestino" runat="server" MaxLength="255" Width="253px" Requerido="true" ValidationGroup="Guardar"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Actividad</td>
            <td>
                <ml:TextBox ID="txtActividad" runat="server" MaxLength="255" Width="253px" Requerido="true" ValidationGroup="Guardar"></ml:TextBox>
            </td>
        </tr>
            <tr>
                <td>
                    Profesional</td>
                <td>
                    <uc2:DropDownListU ID="ddlProf" runat="server" />
                </td>
            </tr>
        <tr>
            <td>
                Hora llegada</td>
            <td>
                <uc3:Hora ID="horaLlegada" runat="server"   Requerido="true" ValidationGroup="Guardar"/>
            </td>
        </tr>
        <tr>
            <td>
                Hora salida</td>
            <td>
                <uc3:Hora ID="horaSalida" runat="server"/>
            </td>
        </tr>
            <tr>
            <td>
                Observaciones</td>
            <td>
                <ml:TextBox ID="txtObs" runat="server" MaxLength="500" TextMode="MultiLine" 
                    Width="258px"></ml:TextBox>
                </td>
        </tr>
        </tr>
            <tr>
            <td colspan="2" style="text-align: center">
                <asp:LinkButton ID="lnkGuardar" runat="server" ValidationGroup="Guardar">Guardar</asp:LinkButton>
                &nbsp
                <asp:LinkButton ID="lnkCancelar" Visible="false" runat="server">Cancelar</asp:LinkButton>
                </td>
         </tr>
    </table>
    </asp:Panel>
    
    <br />
    <br />
    <ml:GridView ID="grvRecorrido" runat="server" DataKeyNames="vrcId" 
        EmptyDataText="No se ha registrado recorrido del día" 
        AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="vehPlaca" HeaderText="Placa" />
            <asp:BoundField DataField="perNombre" HeaderText="Conductor" />
            <asp:BoundField DataField="vrcDestino" HeaderText="Lugar" />
            <asp:BoundField DataField="vrcActividad" HeaderText="Actividad" />
            <asp:BoundField DataField="vrcHoraLleg" HeaderText="Hora Llegada" />
            <asp:BoundField DataField="vrcHoraSal" HeaderText="Hora Salida" />
            <asp:BoundField DataField="vrcObservacion" HeaderText="Observacion" />
            <asp:CommandField EditText="Edit" ShowEditButton="true" HeaderText="Edit" />
            <asp:CommandField DeleteText="Elim" ShowDeleteButton="true" HeaderText="Del" />
        </Columns>
    </ml:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
   
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
    
</asp:Content>
