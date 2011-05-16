<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="VerAvance.ascx.vb" Inherits="ML.VerAvance" %>
    <table class="style1" style="vertical-align:top;">
        <tr>
        <td><asp:Label ID="lblValor" runat="server" Text="" SkinID="lblFormatoFecha"></asp:Label></td>
            <td title="haga click acá para ver mas detalles" style="text-align:left;">
            <a href="<%=Url%>" class="aNulo">
            <div id="dvml" style="width:0px; text-align:right;">
                <img id="<%=me.clientId %>_flecha" alt="" src="../Util/flecha.jpg" style="width: 12px; height: 11px;" />
            </div>            
            <img id="<%=me.clientId %>_avance" alt="" src="../Util/avance.png" style="width: 161px; height: 43px;" /></a></td>
        </tr>
    </table>
    <script type="text/javascript">
        ubicarAvance1(document.getElementById("<%=me.clientId %>_avance"),document.getElementById("<%=me.clientId %>_flecha"),<%=Avance %>);
        function ubicarAvance1(objAvance, objFlecha, avance) {
            var f = parseInt(objFlecha.style.width.replace(/px/, ""));
            objFlecha.style.top = findPosY(objAvance)-5
            var locAvance = parseInt(objAvance.style.width.replace(/px/, ""));            
            locAvance = (locAvance-6) * (avance) / 100;
            objFlecha.style.left = 300;
            var add=4;
            if (navigator.userAgent.indexOf("Chrome") != -1) 
                add=0;            
            document.getElementById("dvml").style.width =  (locAvance+f+add) + "px";
        }
    </script>