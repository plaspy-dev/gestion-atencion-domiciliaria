<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="evImprimir.aspx.vb" Inherits="ML.evImprimir" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    <style type="text/css">
        .style1
        {
            width: 100%;
            text-align:left;
        }
    </style>
</head>
<body onload="print();close();">
    <form id="form1" runat="server">
    <div>
    
        <table class="style1" border="1">
            <tr>
                <td colspan="2" style="text-align:center;">
                    <asp:Label ID="lblTit" runat="server" SkinID="EtiquetaSubT" Text="Evento"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblLugar" runat="server" Text="Lugar: "></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblFecha" runat="server" Text="Fecha: "></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblDireccion" runat="server" Text="Hora Inicial: "></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblEncargado" runat="server" Text="Hora Inicial: "></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblHoraIni" runat="server" Text="Hora Inicial: "></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblHoraFin" runat="server" Text="Hora Final: "></asp:Label>
                </td>
            </tr>
        </table>
    <br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" EmptyDataText="No se ha registrado funcionarios para el evento" Width="100%"
             RowStyle-BorderWidth="1" RowStyle-BorderStyle="Solid" RowStyle-BorderColor="Black" RowStyle EnableViewState="false">
            <Columns>
            <asp:TemplateField HeaderText="Cargo" ItemStyle-Width="100px">
                <ItemTemplate>
                    <asp:Label runat="server" ID="lblCar" Text='<%#GetCargo(Eval("recTipo"))%>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
                <asp:BoundField DataField="perDocumento" HeaderText="Documento" ItemStyle-Width="100px"/>
                <asp:BoundField DataField="perNombre" HeaderText="Nombre" ItemStyle-Width="250px"/>
                <asp:BoundField HeaderText="Hora Llegada" ItemStyle-Width="50px"/>
                <asp:BoundField HeaderText="Hora Salida" ItemStyle-Width="50px" ItemStyle-Height="40px"/>
                <asp:BoundField HeaderText="Firma"  />
                <asp:BoundField HeaderText="Recibe dotación?(SI/NO)"  />
            </Columns>
        </asp:GridView>
    
    </div>
    </form>
</body>
</html>
