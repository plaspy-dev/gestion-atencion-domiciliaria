<%@ Page Title="Programacion Evento" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="evmEvento.aspx.vb" Inherits="ML.evmEvento" %>

<%@ Register Assembly="ML" Namespace="ML" TagPrefix="cc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<%@ Register src="../Controles/Hora.ascx" tagname="Hora" tagprefix="uc2" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc3" %>
<%@ Register src="../Controles/Lista.ascx" tagname="Lista" tagprefix="uc4" %>
<%@ Register src="../Controles/ListaMulti.ascx" tagname="ListaMulti" tagprefix="uc5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <asp:Panel ID="pnlPrg" runat="server">
    <table id="tbl">
    <tr><th colspan="4">Programación de Evento # <%=idE%><hr /></th></tr>
        <tr>
            <td>
            
                Fecha</td>
            <td>
            
                <uc3:Fecha ID="fecha" runat="server" OrigenDatos="eveFecha" />
            </td>
            <td>
            
                Nombre</td>
            <td>
            
                <ml:TextBox ID="txtDesc" runat="server" Width="228px" OrigenDatos="eveDescripcion"></ml:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <ml:LabelMant ID="LabelMant1" runat="server"  Titulo="Lugar" PaginaMant="evmLugar" />
                </td>
            <td>
            
                <uc1:DropDownListU ID="ddlLugar" runat="server"  OrigenDatos="lugId"/>
            </td>
            <td>
            
                <ml:LabelMant ID="LabelMant2" runat="server"  Titulo="Programa" PaginaMant="evmPrograma" url="comTablaBasica.aspx?tabla=evmPrograma" /></td>
            <td>
            
                <uc1:DropDownListU ID="ddlPrg" runat="server"  OrigenDatos="prgEId"/>
            </td>
        </tr>
        <tr>
            <td>
            
                <ml:LabelMant ID="LabelMant3" runat="server"  Titulo="Actividad" PaginaMant="evmActividad" url="comTablaBasica.aspx?tabla=evmActividad" /></td></td>
            <td colspan="3">
            
                <uc1:DropDownListU ID="ddlAct" runat="server"  OrigenDatos="actEId"/>
            </td>
        </tr>
        <tr>
            <td>
            
                Hora inicial</td>
            <td>
            
                <uc2:Hora ID="HoraIni" runat="server"  OrigenDatos="eveFecha"/>
            </td>
            <td>
            
                Hora Final</td>
            <td>
            
                <uc2:Hora ID="HoraFin" runat="server"  OrigenDatos="eveHoraFin"/>
            </td>
        </tr>
        <tr>
            <td>
            
                Plan Tipo</td>
            <td colspan="3">
            
                <uc1:DropDownListU ID="ddlPlanTipo" runat="server"  OrigenDatos="plnId" AutoPostBack="true"/>
            </td>
        </tr>
        <tr>
            <td>
            
                Nro Ambulancias Básicas</td>
            <td>
            
                <ml:TextBox ID="txtNAmbB" runat="server" TipoTextBox="Entero" Width="39px" OrigenDatos="eveNroAmbBasica"></ml:TextBox>
            </td>
            <td>
            
                </td>
            <td>
            
                </td>
        </tr>
        <tr>
            <td>
            
                Nro Ambulancias Medicalizadas</td>
            <td>
            
                <ml:TextBox ID="txtNAmbM" runat="server" TipoTextBox="Entero" Width="39px" OrigenDatos="eveNroAmbMedicalizada"></ml:TextBox>
            </td>
            <td>
            
                </td>
            <td>
            
                </td>
        </tr>
        <tr>
            <td>
            
                Numero MEC</td>
            <td>
                <ml:TextBox ID="txtNroMEC" runat="server" TipoTextBox="Entero" Width="39px" 
                    OrigenDatos="eveNroMec" ></ml:TextBox>
            </td>
            <td>
            
                </td>
            <td>
            
                </td>
        </tr>
        <tr>
            <td>
            
                Coordinadores campo<asp:Label runat="server" ID="lblNroCoor"></asp:Label></td>
            <td>
                <uc5:ListaMulti ID="ListaMultiCoor" runat="server" nomTabla="PersonalSM" MostrarAlBuscar="true" />
            </td>
            <td>
            
                </td>
            <td>
            
                </td>
        </tr>
        <tr>
            <td>
            
                Auxiliares<asp:Label runat="server" ID="lblNroAux"></asp:Label></td>
            <td>
                <uc5:ListaMulti ID="ListaMultiAux" runat="server" nomTabla="PersonalSM" MostrarAlBuscar="true" />
            </td>
            <td>
            
                </td>
            <td>
            
                </td>
        </tr>
        <tr>
            <td>                
                Médicos<asp:Label runat="server" ID="lblNroMed"></asp:Label></td>
            <td>
            
                <uc5:ListaMulti ID="ListaMultiMed" runat="server" nomTabla="MedicosS"  MostrarAlBuscar="true"/>
            </td>
            <td>
            
                </td>
            <td>
            
                </td>
        </tr>
    </table>
    <br />
    <br />
        <asp:LinkButton ID="lnkImpPl" runat="server" >Imprimir Planilla de asistencia</asp:LinkButton>
    </asp:Panel>
    <script type="text/javascript">
    
    </script>
</asp:Content>
