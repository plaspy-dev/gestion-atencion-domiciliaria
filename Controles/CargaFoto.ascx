<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="CargaFoto.ascx.vb" Inherits="ML.CargaFoto" %>
<%@ Register src="CargarArchivo.ascx" tagname="CargarArchivo" tagprefix="uc1" %>

<asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" width="700px">
   
    <asp:Panel ID="pnlTitulo" runat="server" Style="cursor: move;background-color:#DDDDDD;border:solid 1px Gray;color:Black; font-family:Verdana; font-size:xx-small; height:30px">
                <div>
                    <p class="">Cargar Foto</p>
                </div>
            </asp:Panel>
            <asp:Label runat="server" ID="lbl">Cómo desea cargar la foto?</asp:Label>
        <asp:RadioButtonList ID="rblTipo" runat="server" AutoPostBack="True" RepeatDirection="Horizontal">
            <asp:ListItem Value="1" Selected="True">Desde Archivo</asp:ListItem>
            <asp:ListItem Value="2">Desde Webcam</asp:ListItem>
    </asp:RadioButtonList>
    <hr />
    <asp:Panel runat="server" ID="pnlArchivo"  Width="400px">
        <asp:Label runat="server" ID="Label1">Por favor seleccione el archivo y haga click en 'Aceptar'</asp:Label>
        <asp:FileUpload ID="fupArchivo" runat="server" /><br />
    </asp:Panel>
    <asp:Panel ID="pnlWebCam" runat="server" Style="overflow:auto;" Visible="false" Height="450px"  Width="700px">
        <script type="text/javascript" src="../Util/Silverlight.js"></script>
        <script type="text/javascript">
            function onSilverlightError(sender, args) {
                var appSource = "";
                if (sender != null && sender != 0) {
                    appSource = sender.getHost().Source;
                }

                var errorType = args.ErrorType;
                var iErrorCode = args.ErrorCode;
                if (errorType == "ImageError" || errorType == "MediaError") {
                    return;
                }
                var errMsg = "Error no controlado en la aplicación de Silverlight " + appSource + "\n";
                errMsg += "Código: " + iErrorCode + "    \n";
                errMsg += "Categoría: " + errorType + "       \n";
                errMsg += "Mensaje: " + args.ErrorMessage + "     \n";
                if (errorType == "ParserError") {
                    errMsg += "Archivo: " + args.xamlFile + "     \n";
                    errMsg += "Línea: " + args.lineNumber + "     \n";
                    errMsg += "Posición: " + args.charPosition + "     \n";
                }
                else if (errorType == "RuntimeError") {
                    if (args.lineNumber != 0) {
                        errMsg += "Línea: " + args.lineNumber + "     \n";
                        errMsg += "Posición: " + args.charPosition + "     \n";
                    }
                    errMsg += "Nombre de método: " + args.methodName + "     \n";
                }
                throw new Error(errMsg);
            }
            function fotoCargada1(msj) {
                alert(msj);
            }
        </script>
            <asp:HiddenField ID="hdfCarga" runat="server" Value="" />       
            <object data="data:application/x-silverlight-2," type="application/x-silverlight-2" width="100%" height="100%">
		      <param name="source" value="Capturafoto.xap"/>
		      <param name="onError" value="onSilverlightError" />
		      <param name="background" value="white" />
		      <param name="minRuntimeVersion" value="4.0.50826.0" />
		      <param name="autoUpgrade" value="true" />
              <param name="initParams" value="path=<%= Request.Url.AbsoluteUri.Substring(0,Request.Url.AbsoluteUri.LastIndexOf("/"))%>/RHGuardaFoto.aspx,funcionJS=cargaCompleta" />
		      <a href="http://go.microsoft.com/fwlink/?LinkID=149156&v=4.0.50826.0" style="text-decoration:none">
 			      <img src="http://go.microsoft.com/fwlink/?LinkId=161376" alt="Obtenga Microsoft Silverlight" style="border-style:none"/>
		      </a>
	        </object>
	        <iframe id="_sl_historyFrame" style="visibility:hidden;height:0px;width:0px;border:0px"></iframe>
            <script type="text/javascript">
            function cargaCompleta(nom) {
                getEl('<%=hdfCarga.clientId%>').value = nom;
                getEl('<%=lnkAceptar.clientId%>').click();
            }
            function cargaFallida() {
                alert("Noooo");
            }
            </script>
    </asp:Panel> 
    <asp:LinkButton ID="lnkAceptar" runat="server">Aceptar</asp:LinkButton>
    <asp:LinkButton ID="lnkCancelar" runat="server">Cancelar</asp:LinkButton>
    <br />
</asp:Panel>
  
    <asp:LinkButton ID="lnkAux" runat="server" ></asp:LinkButton>

<asp:ModalPopupExtender ID="Panel1_ModalPopupExtender" runat="server" 
    BackgroundCssClass="modalBackground" DynamicServicePath="" Enabled="True"  
    TargetControlID="lnkAux" PopupControlID="Panel1" CancelControlID="" OkControlID=""
    DropShadow="true"
    PopupDragHandleControlID="pnlTitulo">
</asp:ModalPopupExtender>
  

