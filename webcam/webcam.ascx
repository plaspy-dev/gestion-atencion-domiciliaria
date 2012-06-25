<%@ Control Language="C#" AutoEventWireup="true" CodeFile="webcam.ascx.cs" Inherits="webcam_webcam" %>
<script type="text/javascript" src="<%=ResolveUrl("~/")%>webcam/jquery.webcam.js"></script>
<style type="text/css">
.foto 
{
        height: 240px;
        width: 320px;
}
object {
	display:block; /* HTML5 fix */
	position:relative;
	z-index:1000;
}
</style>
<script type="text/javascript">
    $(function() {
        $("#webcam").webcam({
            width: 320,
            height: 240,
            mode: "save",
            swffile: "<%=ResolveUrl("~/webcam/jscam.swf")%>",
            onTick: function() { },
            onSave: function(data) {
                $("#foto").attr('src', "<%=ResolveUrl("~/webcam/up.ashx")%>?par=" + Math.random());
                $(webfoto).attr("src", "<%=ResolveUrl("~/webcam/up.ashx")%>?par=" + Math.random())
                    .width(120).height(90).click(function() { return false;});
                $("#bTomar").val('Tomar').attr('disable',false);
                $("#bAceptar,#foto").show();
                $( "#dwebcam" ).dialog( "option", "width", 670);
            },
            onCapture: function() { 
            },
            onLoad: function() { 
                if(webcam.getCameraList().length)
                    $("#bTomar").show();
                else $("#aTomarFoto,#bTomar").hide();
            }
        });
    });
</script>
<input id="aTomarFoto" type="button" value="Tomar foto" onclick="$('#dwebcam').dialog( { width: 350 });$('#bAceptar,#foto').hide();Page_IsValid=false;" />
<div id="dwebcam" title="Tomar foto" class="hide">
<table>
    <tr>
        <td>
            <div id="webcam" class="foto">
            </div>
        </td>
        <td>
            <img id="foto" class="foto hide" src="" alt="foto"/>
        </td>
    </tr>
    <tr>
        <td align="right"><input type="button" value="Tomar" id="bTomar" onclick="$(this).val('Procesando...').attr('disable',true);setTimeout(function() {webcam.capture();webcam.save('<%=ResolveUrl("~/webcam/up.ashx")%>');},100);Page_IsValid=false;" />
        <input type="button" value="Aceptar" id="bAceptar" class="hide" onclick="$('#dwebcam').dialog('close');Page_IsValid=false;" /></td>
        <td></td>
    </tr>
</table>
</div>