<%@ Page Title="Censo de Equipos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="equCenso.aspx.vb" Inherits="ML.equCenso" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc3" %>
<%@ Register src="../Controles/Fecha.ascx" tagname="Fecha" tagprefix="uc4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.ServiciosMedicos.equProgramacion" Campos="prgFecha" Titulos="Fecha de Consulta" />
    <ml:GridView ID="grvPrg" runat="server" AutoGenerateColumns="false">
    <Columns>
        <asp:BoundField HeaderText="Id Equipo" DataField="equId" />
        <asp:BoundField HeaderText="Nombre" DataField="equNombre" />
        <asp:BoundField HeaderText="Serial" DataField="equSerial" />
        <asp:BoundField HeaderText="Placa" DataField="equPlaca" />
        <asp:TemplateField HeaderText="Propietario">
            <ItemTemplate>
                <%#IIf(Eval("equPropietario") = 1, "OrganizationExample15", "OrganizationExample16")%>
            </ItemTemplate>
        </asp:TemplateField>
                <asp:TemplateField HeaderText="Estado">
            <ItemTemplate>
                <%#IIf(Eval("equActivo"), "Activo", "<span style='color:red;'>EN BAJA</span>")%>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField HeaderText="Asignado?" DataField="Asignado" />
        <asp:BoundField HeaderText="Se encuentra en" DataField="pacNombre" />
        <asp:BoundField HeaderText="Funcionario Responsable" DataField="perNombre" />
        <asp:BoundField HeaderText="Desde" DataField="prgFecha" DataFormatString="{0:dd/MM/yyyy}" />
        <asp:BoundField HeaderText="Hasta" DataField="prgFechaFin" DataFormatString="{0:dd/MM/yyyy}"/>
        <asp:BoundField HeaderText="Obs" DataField="equobs"/>
        <asp:TemplateField HeaderText="Asignar">
            <ItemTemplate>
                <asp:LinkButton ID="lnkProg" runat="server" Visible='<%#Eval("equActivo") %>' CommandName='Prog' Text='Asignar' CommandArgument='<%#ctype(Container,GridViewRow).rowIndex%>'></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Devolución">
            <ItemTemplate>
                <asp:LinkButton ID="lnkDev" runat="server" Visible='<%#Eval("equActivo") %>' CommandName='Dev' Text='Devolución' CommandArgument='<%#ctype(Container,GridViewRow).rowIndex%>'></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Dar de baja">
            <ItemTemplate>
                <asp:LinkButton ID="lnkBaja" runat="server" Visible='<%#Eval("equActivo") %>' CommandName='Baja' Text='Baja' CommandArgument='<%#ctype(Container,GridViewRow).rowIndex%>'></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    </ml:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>
    
    <asp:Panel ID="pnlNuevo" runat="server" Visible="false">
        <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="400px">
            <asp:Panel ID="pnlTitulo" runat="server" Style=" height:10%;cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small;">
                <div id="dvTitulo" runat="server">
                    Programar Equipo
                </div>
            </asp:Panel>
            <asp:Panel ID="Panel2" runat="server" >
                <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Panel runat="server" id="pnlPrincipal">
                        <table class="style1">
                            <tr id="trFecha" runat="server">
                                <td>
                                    <asp:Label ID="Label12" runat="server" Text="Fecha"></asp:Label>
                                </td>
                                <td>
                                    <uc4:Fecha ID="fchProg" runat="server" Requerido="true" ValidationGroup="GuardarAut" />
                                </td>
                                </tr>
                            <tr id="tr1" runat="server">
                                <td>
                                    <asp:Label ID="Label1" runat="server" Text="Fecha Final"></asp:Label>
                                </td>
                                <td>
                                    <uc4:Fecha ID="fchFin" runat="server" />
                                </td>
                            </tr>
                            <tr id="tr2" runat="server">
                                <td>
                                    <asp:Label ID="Label14" runat="server" Text="Paciente"></asp:Label>
                                </td>
                                <td style="text-align: left">
                                    <uc3:DropDownListU ID="ddlPaciente" runat="server"  NomTabla="PacientePorId" />
                                </td>
                            </tr>
                            <tr id="tr3" runat="server">
                                <td>
                                    <asp:Label ID="Label13" runat="server" Text="Funcionario Asignado"></asp:Label>
                                </td>
                                <td style="text-align: left">
                                    <uc3:DropDownListU ID="ddlPer" runat="server" NomTabla="PersonalHS"/>
                                </td>
                            </tr>
                            <tr id="tr4" runat="server">
                                <td>
                                    <asp:Label ID="Label15" runat="server" Text="Familiar Responsable "></asp:Label>
                                </td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="txtFam" runat="server" MaxLength="50" Width="255px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr id="tr5" runat="server">
                                <td>
                                <asp:CheckBox id="chkPagare" runat="server" Text="Pagaré?" />
                                </td>
                            </tr>
                             <tr id="tr6" runat="server">
                                <td>
                                    <asp:Label ID="Label2" runat="server" Text="Observaciones"></asp:Label>
                                </td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="txtObs" runat="server" MaxLength="250" TextMode="MultiLine" Width="255px"></asp:TextBox>
                                </td>
                            </tr>                            
                        </table>
                    </asp:Panel>  
                    <asp:Label ID="Label16" runat="server" Text="Últimas 5 programaciones:"></asp:Label>
                    <asp:GridView ID="grvHistProg" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            <asp:BoundField DataField="prgId" HeaderText="Id" />
                            <asp:BoundField DataField="prgFecha" HeaderText="Fec" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="prgFechaFin" HeaderText="Fec Fin" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="pacNombre" HeaderText="Paciente" />
                            <asp:BoundField DataField="perNombre" HeaderText="Funcionario" />
                            <asp:CommandField DeleteText="Elim" HeaderText="Elim" ShowDeleteButton="True" />
                        </Columns>
                    </asp:GridView>
                </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel> 
            <asp:LinkButton ID="lnkGuardar" runat="server" ValidationGroup="GuardarAut">Aceptar</asp:LinkButton>
                &nbsp;
            <asp:LinkButton ID="lnkCancelar" runat="server">Cancelar</asp:LinkButton>
            <br />
        </asp:Panel>
        <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>

        <asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
        BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True"  
        TargetControlID="lnkAux" PopupControlID="Panel1" CancelControlID="" OkControlID=""
        PopupDragHandleControlID="pnlTitulo">
        </asp:ModalPopupExtender>
    </asp:Panel>    
    
</asp:Content>
