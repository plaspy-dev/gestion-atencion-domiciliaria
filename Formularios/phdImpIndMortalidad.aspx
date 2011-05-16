<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="phdImpIndMortalidad.aspx.vb" Inherits="ML.phdImpIndMortalidad" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        .style2
        {
            font-weight: bold;
        }
    </style>
</head>
<body style="background-color:White;" >
    <form id="form1" runat="server">
    <div>
    
        <table class="style1" border="1">
            <tr>
                <td colspan="4">
                    <img alt="Logo OrganizationExample15" src="../imgs/logo.jpg" 
                        style="width: 273px; height: 82px" /></td>
            </tr>
            <tr>
                <td colspan="4">
                    <b>ANALISIS DE MORTALIDAD</b></td>
            </tr>
            <tr>
                <td class="style2">
                    Fecha Defunción</td>
                <td>
                    <asp:Label ID="lblFecDef" runat="server" ></asp:Label></td>
                <td>
                    <b>Fecha de Análisis</b></td>
                <td>
                    <asp:Label ID="lblFecAnalisis" runat="server" ></asp:Label></td>
            </tr>
            <tr>
                <td>
                    <b>Ciudad</b></td>
                <td>
                    Bogotá</td>
                <td>
                    <b>Centro 1Er Nivel Asignado</b></td>
                <td>
                    Gestión de atención domiciliaria</td>
            </tr>
            <tr>
                <td>
                    <b>Nombre del fallecido</b></td>
                <td>
                    <asp:Label ID="lblNom" runat="server" ></asp:Label>
                </td>
                <td>
                    <b></b></td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    <b>Tipo documento identidad</b></td>
                <td>
                    <asp:Label ID="lblTDoc" runat="server" SkinID="lblFormatoFecha" ></asp:Label>
                </td>
                <td>
                    <b>Número</b></td>
                <td>
                    <asp:Label ID="lblDoc" runat="server" SkinID="lblFormatoFecha" ></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <b>Edad</b></td>
                <td>
                    <asp:Label ID="lblEdad" runat="server" SkinID="lblFormatoFecha"></asp:Label>
                </td>
                <td>
                    <b>Sexo</b></td>
                <td>
                    <asp:Label ID="lblSexo" runat="server" SkinID="lblFormatoFecha" ></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <b>Afiliación</b></td>
                <td>
                    <asp:Label ID="lblAfiliacion" runat="server" SkinID="lblFormatoFecha" 
                        ></asp:Label>
                </td>
                <td>
                    <b>Estrato socio económico</b></td>
                <td>
                    <asp:Label ID="lblEstrato" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <b>Lugar de defunción</b></td>
                <td>
                    <b>Extrahospitalario:</b></td>
                <td>
                    Casa</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
                <td>
                    <b>IPS</b></td>
                <td>
                    Gestión de atención domiciliaria</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    <b>Estancia</b></td>
                <td>
                    <asp:Label ID="lblEstancia" runat="server" SkinID="lblFormatoFecha"></asp:Label></td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    <b>Analisis dde mortalidad o comité EPS</b></td>
                <td>
                    SI</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    <b>Autopsia</b></td>
                <td>
                    NO</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    <b>Dignóstico</b></td>
                <td colspan="3">
                    <asp:Label ID="lblDiag" runat="server" SkinID="lblFormatoFecha" ></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <b>Causa última de muerte</b></td>
                <td colspan="3">
                    Paro&nbsp; Cardiorespiratorio</td>
            </tr>
            <tr>
                <td>
                    <b>Indicador (Variable) de mortalidad</b></td>
                <td colspan="3">
                    <asp:DataList ID="dtlInd" runat="server">
                    <ItemTemplate>
                        <%#Eval("inmDescripcion")%>
                    </ItemTemplate>
                    </asp:DataList>
                </td>
            </tr>
        </table>
    <br />
    <br />
    <br />
                        <table align="right" width="50%">
                        <tr>
                            <td>
                                &nbsp;</td>
                            <td>
                            <hr />
                                Firma Auditoría</td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;</td>
                            <td>
                                Servicios Médicos</td>
                        </tr>
                    </table>
    </div>
    </form>
</body>
</html>
