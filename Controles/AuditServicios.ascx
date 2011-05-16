<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AuditServicios.ascx.vb" Inherits="ML.AuditServicios" Debug="false" %>
<asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Width="700px">
    <asp:Panel ID="pnlTitulo" runat="server" Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small; height:10%">
                <div>
                    <p class="">Auditoría Servicios Paciente</p>
                </div>
            </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" Style="height:300px;overflow:auto;">
    <asp:GridView ID="GridView1" runat="server" 
    AutoGenerateColumns="False" 
            EmptyDataText="No se tiene registro de auditoría para ese paciente" 
            EnableViewState="False">
    
        <Columns>
        <asp:BoundField HeaderText="Fecha" DataField="audFecha" DataFormatString="{0:dd/MM/yyyy}" />
        <asp:BoundField HeaderText="Usuario" DataField="audUsuario" />
            <asp:TemplateField HeaderText="Ingreso">
                <ItemTemplate>
                    <%#RetTipoB(Eval("audIngreso"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Egreso">
                <ItemTemplate>
                    <%#RetTipoB(Eval("audEgreso"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Curaciones">
                <ItemTemplate>
                    <%#retTipo(Eval("pacCuraciones"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Act.Puntual">
                <ItemTemplate>
                    <%#retTipo(Eval("pacAdmPuntual"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ter.Física">
                <ItemTemplate>
                    <%#retTipo(Eval("pacTerapiaFisica"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ter.Resp.">
                <ItemTemplate>
                    <%#retTipo(Eval("pacTerapiaResp"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ter.Ocup">
                <ItemTemplate>
                    <%#retTipo(Eval("pacTerapiaOcup"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ter.Leng.">
                <ItemTemplate>
                    <%#retTipo(Eval("pacTerapiaLenguaje"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Val.Nutri.">
                <ItemTemplate>
                    <%#retTipo(Eval("pacValNutricional"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Val.Médica">
                <ItemTemplate>
                    <%#retTipo(Eval("pacValMedica"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Enf.12H">
                <ItemTemplate>
                    <%#retTipo(Eval("pacEnfermeria_12"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Enf.24H">
                <ItemTemplate>
                    <%#retTipo(Eval("pacEnfermeria_24"))%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="Causa Ing" DataField="cingDescripcion" />
            <asp:BoundField HeaderText="Causa Egr" DataField="cegDescripcion" />
            <asp:BoundField HeaderText="Obs" DataField="audObs" />
        </Columns>
    </asp:GridView>
    </asp:Panel> 
    <asp:LinkButton ID="lnkCancelar" runat="server">Aceptar</asp:LinkButton>
    <br />
</asp:Panel>
  
    <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>

<asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
    BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True"  
    TargetControlID="lnkAux" PopupControlID="Panel1" CancelControlID="lnkCancelar" OkControlID=""
    DropShadow="true"
    PopupDragHandleControlID="pnlTitulo">
</asp:ModalPopupExtender>
