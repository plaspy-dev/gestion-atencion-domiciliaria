<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administrador de Servicios Médicos OrganizationExample15::Inicio</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%= SDG.Componentes.HtmlUtil.RenderStyle("~/css/estilo.css") %>
    <%= SDG.Componentes.HtmlUtil.RenderScript("~/js/jquery-1.7.2.min.js") %>
    <script type="text/javascript">
		$(function() {
			$("#m_EUsuario").attr("title","Por favor ingrese un usuario");
			$("#m_EContrasena").attr("title","Por favor ingrese una contraseña");
			
			// simple jQuery validation script
			$('#form1').submit(function(){
				
				var valid = true;
				var errormsg = 'Campo requerido';
				var errorcn = 'error';
				
				$('.' + errorcn, this).remove();			
				
				$('.required', this).each(function(){
					var parent = $(this).parent();
					if( $(this).val() == '' ){
						var msg = $(this).attr('title');
						msg = (msg != '') ? msg : errormsg;
						$('<span class="'+ errorcn +'">'+ msg +'</span>')
							.appendTo(parent)
							.fadeIn('fast')
							.click(function(){ $(this).remove(); })
						$(this).focus();
						valid = false;
					};
				});
				
				return valid;
			});
		});
	</script>
    <style>

/* //  HTML elements */	

#login{
	margin:5em auto;
	width: 300px;
	background:#fff;
	border:8px solid #eee;
	-moz-border-radius:5px;
	-webkit-border-radius:5px;
	border-radius:5px;
	-moz-box-shadow:0 0 10px #4e707c;
	-webkit-box-shadow:0 0 10px #4e707c;
	box-shadow:0 0 10px #4e707c;
	text-align:left;
	position:relative;
	}
#login a, #login a:visited{color:#0283b2;}
#login a:hover{color:#111;}
#login h1{
	background:rgb(50, 127, 205);
	color:#fff;
	text-shadow:#007dab 0 1px 0;
	font-size:14px;
	padding:18px 23px;
	margin:0 0 1.5em 0;
	border-bottom:1px solid #007dab;
	text-align: right;
	}
#login .register{
	position:absolute;
	float:left;
	margin:0;
	line-height:30px;
	top:-40px;
	right:0;
	font-size:11px;
	}
#login p{margin:.5em 25px;}
#login div{
	margin:.5em 25px;
	background:#eee;
	padding:4px;
	-moz-border-radius:3px;
	-webkit-border-radius:3px;
	border-radius:3px;
	text-align:right;
	position:relative;
	}	
#login label{
	float:left;
	line-height:30px;
	padding-left:10px;
	}
#login .field{
	border:1px solid #ccc;
	font-size:12px;
	line-height:1em;
	padding:4px;
	-moz-box-shadow:inset 0 0 5px #ccc;
	-webkit-box-shadow:inset 0 0 5px #ccc;
	box-shadow:inset 0 0 5px #ccc;
	}	
#login div.submit{background:none;margin:1em 25px;text-align:right;}	
#login div.submit label{float:none;display:inline;font-size:11px;}	
#login button{
	border:0;
	padding:0 30px;
	height:30px;
	line-height:30px;
	text-align:center;
	font-size:12px;
	color:#fff;
	text-shadow:#007dab 0 1px 0;
	background:#0092c8;
	-moz-border-radius:50px;
	-webkit-border-radius:50px;
	border-radius:50px;
	cursor:pointer;
	}
	
#login .forgot{text-align:right;font-size:11px;}
#login .back{padding:1em 0;border-top:1px solid #eee;text-align:right;font-size:11px;}
#login .error{
	float:left;
	position:absolute;
	left:95%;
	top:-5px;
	background:#890000;
	padding:5px 10px;	
	font-size:11px;
	color:#fff;
	text-shadow:#500 0 1px 0;
	text-align:left;
	white-space:nowrap;
	border:1px solid #500;
	-moz-border-radius:3px;
	-webkit-border-radius:3px;
	border-radius:3px;
	-moz-box-shadow:0 0 5px #700;
	-webkit-box-shadow:0 0 5px #700;
	box-shadow:0 0 5px #700;
	}

/* //  login form */	
		
</style>
</head>
<body>
    <form id="form1" runat="server">
    <table border="0" align="center" cellpadding="0" cellspacing="0" width="100%">
    <tr style="background-color: #184580">
        <td style="width:1000px;"></td>
        <td style="min-width: 700px;">
            <!-- encablezado -->
            <table width="100%" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td class="fhl"></td>
                <td width="1px">
                    <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="172" height="55" id="FlashID" title="OrganizationExample15">
                      <param name="movie" value="<%=ResolveUrl("~/")%>images/logo.swf" />
                      <param name="quality" value="high" />
                      <param name="wmode" value="opaque" />
                      <param name="swfversion" value="6.0.65.0" />
                      <!-- La siguiente etiqueta object es para navegadores distintos de IE. Ocúltela a IE mediante IECC. -->
                      <!--[if !IE]>-->
                      <object type="application/x-shockwave-flash" data="<%=ResolveUrl("~/")%>images/logo.swf" width="172" height="55">
                        <!--<![endif]-->
                        <param name="quality" value="high" />
                        <param name="wmode" value="opaque" />
                        <param name="swfversion" value="6.0.65.0" />
                        <!-- El navegador muestra el siguiente contenido alternativo para usuarios con Flash Player 6.0 o versiones anteriores. -->
                        <asp:ImageButton ID="ILogo" runat="server" ImageUrl="~/images/tema/logop.jpg" Width="150" Height="55" CausesValidation="False" PostBackUrl="~/inicio.aspx"/>
                        <!--[if !IE]>-->
                      </object>
                      <!--<![endif]-->
                    </object>
                </td>
                <td colspan="2" valign="middle" align="right" style="text-align:right; white-space: nowrap; border-top: solid #0D6AB8 1px; background-color: #327FCD; vertical-align: middle;">
                </td>
                <td class="fhr"></td>
              </tr>
            </table>
        </td>
        <td style="width:1000px;"></td>
    </tr>
    <tr>
        <td class="red"></td>
        <td>
            <!-- contenido -->
            <asp:Panel runat="server" ID="PDatos"  DefaultButton="m_BIngresar">
                        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr>
                          <td class="fcl"></td>
                          <td width="645" valign="top" bgcolor="#FFFFFF">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                          <tr>
                            <td class="fondoTituloUsuario" style="padding:18px 50px 20px 5px" align="right">
                            <table cellpadding="0" cellspacing="0">
                                <tr>
                                    <td><b>Ingreso a Gestión de atención domiciliaria</b></td>
                                    <td>&nbsp;
                                    </td>
                                </tr>
                            </table>
                            </td>
                          </tr>
                          <tr>
                            <td style="padding:10px 20px 5px 5px" class="fondoPagina" align="right">
                            <div id="login">
                            	    <div>
                                        <asp:Label ID="LUsuario" Text="Usuario" AssociatedControlID="m_EUsuario" runat="server"> </asp:Label>
                                        <asp:TextBox ID="m_EUsuario" runat="server" MaxLength="25" CssClass="field required"></asp:TextBox>
                                    </div>
                                    <div>
                                        <asp:Label ID="LContrasena" Text="Contraseña" AssociatedControlID="m_EContrasena" runat="server"> </asp:Label>
                                        <asp:TextBox ID="m_EContrasena" runat="server" MaxLength="25" CssClass="field required" TextMode="Password"></asp:TextBox>
                                    </div>			
                                    
                                    <p class="forgot">
                                    <asp:Label ID="m_SMensaje" runat="server" Text="" ForeColor="#FF0000" Width="100%"></asp:Label>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="m_EContrasena" Display="Dynamic" ForeColor="#FFFFFF" ErrorMessage=""></asp:RequiredFieldValidator>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="m_EUsuario" Display="Dynamic" ForeColor="#FFFFFF" ErrorMessage=""></asp:RequiredFieldValidator>
                                    </p>
                                                
                                    <div class="submit">
                                        <asp:Button ID="m_BIngresar" runat="server" Text="Ingresar" onclick="m_BIngresar_Click" />
                                    </div>
                            </div>
                            </td>
                          </tr>
                        </table>
                      </td>
                      <td class="fcr"></td>
                      </tr>
                    </table>
                    </asp:Panel>
    </td>
    <td class="red"></td>
    </tr>
    <tr style="background-color: #184580">
        <td></td>
        <td><!-- pie de pagina -->
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#184580">
              <tr>
                <td class="fhl"></td>
                <td align="right" style="background-color: #FFF; padding-right: 30px;">Versión <asp:Label ID="LVersion" runat="server" Text=""></asp:Label></td>
                <td class="fhr"></td>
              </tr>
              <tr>
                <td></td>
                <td style="padding:5px 0px 20px 25px;font-size: 10px;color: #ffffff;">
                <b>OrganizationExample15</b> © Demostración local<br />
                  Dirección de demostración · Teléfono de prueba 000 000 0000<br />
                  Desarrollado por <a href="http://www.sdg.com.co">Software Developers Group LTDA</a>
                </td>
                <td></td>
              </tr>
            </table>
        </td>
        <td></td>
    </tr>
    </table>
</form>
</body>
</html>
