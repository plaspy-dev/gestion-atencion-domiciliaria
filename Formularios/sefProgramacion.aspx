<%@ Page Title="Programación Servicios Farmacéuticos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="sefProgramacion.aspx.vb" Inherits="ML.sefProgramacion" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc2" %>
<%@ Register src="../Controles/HistProgSerFarma.ascx" tagname="HistProgSerFarma" tagprefix="uc3" %>
<%@ Register src="../Controles/InsumosSerFarma.ascx" tagname="InsumosSerFarma" tagprefix="uc4" %>
<%@ Register src="../Controles/Lista.ascx" tagname="Lista" tagprefix="uc5" %>
<%@ Register src="../Controles/ConPacientes.ascx" tagname="ConPacientes" tagprefix="uc6" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
                <uc6:ConPacientes ID="ConPacientes1" runat="server" 
                    NomListaTabla="PacienteSuministros" VerInactivos="True" />
     <asp:Panel runat="server" id="pnlProgramacion" Visible="false">
         <br />
         <hr />
    <table class="style1" border="1">
        <tr>
            <td colspan="2" style="text-align: center">
            <asp:UpdatePanel runat="server"><ContentTemplate>
                <asp:LinkButton ID="lnkHistProg" runat="server" CausesValidation="false">Consultar Historial de Programación</asp:LinkButton>
                <uc3:HistProgSerFarma ID="HistProgSerFarma1" runat="server" />
                </ContentTemplate></asp:UpdatePanel>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center">
                <asp:Label ID="Label34" runat="server" Text="Datos de Programación" 
                    SkinID="EtiquetaSubT"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label35" runat="server" Text="Seleccione la Fecha de programación"></asp:Label>
                </td>
            <td>
                <uc1:Fecha ID="fecProg" runat="server" AutoPostBack="True" />
                </td>
        </tr>
        </table>
        <br />
        <table border="1" id="tblSelInsumos" runat="server">
        <tr>
            <td style="text-align: center">
                <asp:LinkButton ID="lnkConsInsumos" runat="server">Seleccionar Artículos a programar</asp:LinkButton>
            </td>
            <td style="text-align: center">
                <asp:LinkButton ID="lnkUltprog" runat="server">Copiar Última Programación</asp:LinkButton>
                </td>
                  <td style="text-align: center">
                    <asp:LinkButton ID="lnkDev" runat="server">Registrar Devolución</asp:LinkButton>
                </td>
        </tr>
        <tr>
            <td style="text-align: center" colspan="2">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                    EmptyDataText="No se han Programado Artículos para esta Fecha">
                    <Columns>
                        <asp:BoundField DataField="insId" HeaderText="Id Articulo" />
                        <asp:BoundField DataField="insDescripcion" HeaderText="Articulo" />
                        <asp:TemplateField HeaderText="Cantidad">
                            <ItemTemplate>
                                <ml:TextBox ID="txtCant" runat="server" TipoTextBox="Entero" MaxLength="18" Width="50px" text='<%#bind("proCantidad")%>'></ml:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Observaciones"><ItemTemplate>
                                <ml:TextBox ID="txtObs" runat="server" MaxLength="255" Width="264px" text='<%#bind("proObservaciones")%>'></ml:TextBox></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Fecha Vencimiento(ddmmaaaa)">
                            <ItemTemplate>
                                <ml:TextBox ID="txtFecVen" runat="server" TipoTextBox="Entero" MaxLength="8" Width="80px" text='<%#String.Format("{0:ddMMyyyy}",Eval("proFechaFin"))%>'></ml:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
                    </Columns></asp:GridView><uc4:InsumosSerFarma ID="InsumosSerFarma1" runat="server" />
            </td>
            <td>
                <asp:GridView ID="grvDev" runat="server" AutoGenerateColumns="False" 
                    EmptyDataText="No se han Registrado devoluciones">
                    <Columns>
                        <asp:BoundField DataField="insId" HeaderText="Id Articulo" />
                        <asp:BoundField DataField="insDescripcion" HeaderText="Articulo" />
                        <asp:TemplateField HeaderText="Cantidad">
                            <ItemTemplate>
                                <ml:TextBox ID="txtCant" runat="server" TipoTextBox="Entero" MaxLength="18" Width="50px" text='<%#bind("proCantidad")%>'></ml:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Observaciones"><ItemTemplate>
                                <ml:TextBox ID="txtObs" runat="server" MaxLength="255" Width="264px" text='<%#bind("proObservaciones")%>'></ml:TextBox></ItemTemplate></asp:TemplateField>
                        <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
                    </Columns></asp:GridView>
            </td>
        </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                <asp:LinkButton ID="lnkGuardar" runat="server">Guardar Programación</asp:LinkButton>               
                    </td>
            </tr>
    </table>
</asp:Panel>

    
</asp:Content>
