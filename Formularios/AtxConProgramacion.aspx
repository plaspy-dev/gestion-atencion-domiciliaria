<%@ Page Title="Consulta Programación Apoyo Terapéutico" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="AtxConProgramacion.aspx.vb" Inherits="ML.AtxConProgramacion" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro"  tagprefix="uc1" %>
<%@ Register src="../Controles/Novedad.ascx" tagname="Novedad" tagprefix="uc2" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <uc1:Filtro ID="Filtro1" runat="server" Tipo="ML.Datos.PHD.ConProgramacion" Campos="pacDocumento,FechaIni,FechaFin,entId,perNombre,actId" Titulos="Digite Nombre o Documento Paciente,Fecha Inicial,Fecha Final,Asegurador,Digite Nombre o Documento Profesional,Actividad" Referencias=",,,Asegurador,,ActividadTer" Expandido="true" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    <ml:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        TotalPaginas="0" EmptyDataText="La búsqueda no generó registros">
        <Columns>
            <asp:BoundField DataField="prgFechaProg" DataFormatString="{0:dd/MM/yyyy}" 
                HeaderText="Fecha" />
            <asp:BoundField DataField="pacDocumento" HeaderText="Documento" />
            <asp:BoundField DataField="pacNombre" HeaderText="Paciente" />
            <asp:BoundField DataField="entNombre" HeaderText="Asegurador" />
            <asp:BoundField DataField="actDescripcion" HeaderText="Actividad" />
            <asp:BoundField DataField="perNombre" HeaderText="Profesional" />
            <asp:BoundField DataField="pacBarrio" HeaderText="Barrio" />
            <asp:BoundField DataField="pacZona" HeaderText="Zona" />
            <asp:BoundField DataField="pacTelefono" HeaderText="Telefono" />
             <asp:TemplateField HeaderText="Direccion">
                <ItemTemplate>
                <div style="display:none;">
                <asp:Label runat="server" ID="lbld" Text='<%#Eval("pacDireccion")%>'></asp:Label>
                </div>
                    <a title="Haga click acá para ver la dirección en el mapa" target="_blank" href='https://service.example.invalid/mad/buscador.php?direccion=<%#Server.UrlEncode(Eval("pacDireccion"))%>'><%#Eval("pacDireccion")%>'</a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="cieCodDx" HeaderText="CIE10" />
            <asp:BoundField DataField="autNumero" HeaderText="Autorización" />
            <asp:BoundField DataField="autNumSesiones" HeaderText="SA" />
            <asp:BoundField DataField="prgNumSesion" HeaderText="SD" />
            <asp:BoundField DataField="numSesion" HeaderText="NS" />
            <asp:BoundField DataField="segUsuarioIngreso" HeaderText="Usuario" />
            <asp:BoundField DataField="segFechaIngreso" HeaderText="Fecha Registro" />
            <asp:TemplateField HeaderText="Novedad">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkNovedad" runat="server" CommandName='Novedad' Text='Ver Novedades' CommandArgument='<%#bind("prgId")%>' Visible='<%#Bind("Novedad")%>' ></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </ml:GridView>
         <uc2:Novedad ID="Novedad1" runat="server" TipoServicio="Terapias" Editable="False" />
        <asp:HiddenField runat="server" ID="hddVerNov" Value="0" />
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>

        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
    <asp:LinkButton ID="lnkCorreo" runat="server" OnClientClick="verEnvioCorreo();return false;">Enviar esta Programación por correo</asp:LinkButton>
    <br />
    <ml:Panel ID="pnlCorreo" runat="server" Titulo="Enviar Programación por correo">
        <table>
            <tr><td colspan="2">
                <asp:DropDownList runat="server" ID="ddlEnvio">
                    <%--<asp:ListItem Text="Enviar a todos los profesionales programados" Value="1" Selected="True"></asp:ListItem>--%>
                    <asp:ListItem Text="Enviar a un funcionario" Value="2" Selected="True"></asp:ListItem>
                </asp:DropDownList>
            </td></tr>
            <tr  id="trProfCorreo">
                <td>Seleccione el funcionario</td>
                <td>                    
                    <uc3:DropDownListU ID="ddlPorfCorreo" runat="server" />
                </td>
            </tr>
            <tr>
                <td>Correo</td>
                <td><asp:TextBox runat="server" ID="txtCorreo" Width="250px"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Digite el encabezado del mensaje</td>
                <td>
                    <asp:TextBox runat="server" ID="txtMensaje" TextMode="MultiLine" Width="250px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>Escriba aquí el pie del mensaje</td>
                <td> 
                    <asp:TextBox runat="server" ID="txtFirma" TextMode="MultiLine" Width="250px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:LinkButton ID="lnkEnviar" runat="server" OnClientClick="if(!confirm('Confirma el envío del correo'))return false;">Enviar Correo</asp:LinkButton>
                </td>
            </tr>
        </table>
    </ml:Panel>
     <script type="text/javascript">
        <%if pnlCorreo.Visible then %>
             function verEnvioCorreo() { 
                <%=pnlCorreo.fnMostrar %>;
             }
             function valOpcionCorreo(){
                getEl('trProfCorreo').style.display=getEl('<%=ddlEnvio.ClientId%>').value=="1"?"none":"block";
             }
             if(getEl('<%=ddlEnvio.ClientId%>'))getEl('<%=ddlEnvio.ClientId%>').onchange=valOpcionCorreo;
             valOpcionCorreo();
         <%End If %>
         function valVerNov(ver) {
             document.getElementById('<%=hddVerNov.clientId %>').value = ver;
         }   
         function verCorreo(){
            document.getElementById('<%=txtCorreo.clientId %>').value="";
            PageMethods.GetCorreo(getEl('<%=ddlPorfCorreo.ControlDdl.ClientID%>').value, retVal, enErrorVal);
         }
         function retVal(oretVal) {
            document.getElementById('<%=txtCorreo.clientId %>').value = oretVal;
        }
         function enErrorVal(mensaje) {
            alert(mensaje.get_message())
         }
         getEl('<%=ddlPorfCorreo.ControlDdl.ClientID%>').onchange=verCorreo;
         verCorreo();
        </script></asp:Content>
