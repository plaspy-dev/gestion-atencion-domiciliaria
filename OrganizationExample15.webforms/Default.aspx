<%@ Page Title="Ingreso a OrganizationExample15" Language="C#" MasterPageFile="~/nologin.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="h" ContentPlaceHolderID="h" Runat="Server">
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
</asp:Content>
<asp:Content ID="c" ContentPlaceHolderID="c" Runat="Server">
    <asp:Panel runat="server" ID="PDatos"  DefaultButton="m_BIngresar">
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
    </asp:Panel>
</asp:Content>

