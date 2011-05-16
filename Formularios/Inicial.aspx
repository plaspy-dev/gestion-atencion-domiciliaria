<%@ Page Title="Inicio" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="Inicial.aspx.vb" Inherits="ML.Inicial" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<%@ Register src="../Controles/VerAvance.ascx" tagname="VerAvance" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%  If qu Then%>             
         <script type="text/javascript" src="https://www.google.com/jsapi"></script>  
            <script type="text/javascript">  
              google.load("visualization", "1", {packages:["corechart"]});  
              google.setOnLoadCallback(drawChart);  
              function drawChart() {
                var data = new google.visualization.DataTable();  
                data.addColumn('string', 'Quejas');  
                data.addColumn('number', 'Cantidad');  
                data.addRows(3);
                data.setValue(0, 0, 'Cerradas');  
                data.setValue(0, 1, <%=dtt.Rows(0)(0).ToString  %>);  
                data.setValue(1, 0, 'Atendidas sin cerrar');  
                data.setValue(1, 1, <%=dtt.Rows(0)(1).ToString  %>);
                data.setValue(2, 0, 'Sin atender');  
                data.setValue(2, 1, <%=dtt.Rows(0)(2).ToString  %>);  
          
                var chart = new google.visualization.PieChart(document.getElementById('chart_div'));  
                chart.draw(data, {colors:['rgb(128,255,128)','rgb(255,255,128)','rgb(255,128,128)'], is3D:true, width: 400, height: 150, title: 'Oportunidad en atención de quejas en el mes'});  
              }
            </script>  
    <%End If%>
    <style type="text/css">
        .ml
        {
               color:#406BAF;
            
            }
    </style>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
    <div style="text-align: center">
        <asp:Image ID="Image2" runat="server" SkinID="imgLogo"/>
    </div>
    <asp:Panel ID="Panel2" runat="server">
        <asp:Label ID="lblTitNot" runat="server" Text="Noticias desde Recursos Humanos"></asp:Label>
        <br />
        <marquee style="width: 429px; height: 127px" direction="up" scrolldelay="200" class="marquee" OnMouseOver="this.stop()" OnMouseOut="this.start()">
        <div runat="server" id="dvMsj"></div>
        </marquee>
    <br />
    <br />

    </asp:Panel>
    <% If qu Then%>
        <div id="chart_div"></div>    
    <%End If%>
    <asp:Repeater ID="rtrSeguimientoRestriccion" runat="server">
    <HeaderTemplate>
<hr/>
    <asp:Label runat="server" ID="Label1" Text='Seguimiento a restricciones de costos por Asegurador en el mes' SkinID="EtiquetaSubT"></asp:Label>
    </HeaderTemplate>
    <ItemTemplate>
        <br />
        <asp:Label runat="server" ID="lvlEnt" Text='<%#"Avance en costos para "+Eval("entNombre")+"<br>Valor total planeado: $"+String.Format("{0:N}",Eval("res"))+"; Porcentaje máximo permitido: "+String.format("{0}%",Eval("porMax"))+"; Valor total ejecutado: $"+String.Format("{0:N}",Eval("val"))%>'></asp:Label>
        <br />
        <br />
        <uc3:VerAvance ID="VerAvance1" runat="server" Avance='<%#Bind("por")%>' Url='<%# "audCostosEnt.aspx?a="+date.now.year.toString()+"&m="+date.now.month.toString()+"&e="+eval("entId").toString()%>' />
    </ItemTemplate>
    <FooterTemplate>
<hr/>
    </FooterTemplate>
    </asp:Repeater>

<asp:Panel runat="server" ID="pnlTarea">
    <asp:Panel ID="pnlTitulo" runat="server" Height="30px" Width="250px">
        <asp:Label ID="lbltitulo" runat="server" Text="Lista de Tareas y revisiones" SkinId="EtiquetaHand"></asp:Label>
        <asp:ImageButton ID="imbExp" runat="server"   CausesValidation="false" SkinID="imbBajar"/>
        <hr />
    </asp:Panel>

    <asp:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" 
        TargetControlID="pnlContenido" ExpandControlID="pnlTitulo" ExpandedText="(Ocultar)" CollapsedText="(Mostrar)" CollapseControlID="pnlTitulo"
        ImageControlID="imbExp"  AutoCollapse="False"
        AutoExpand="False"
        ExpandDirection="Vertical" Collapsed="false">
    </asp:CollapsiblePanelExtender>
    <asp:Panel ID="pnlContenido" runat="server" Height="20px" >
            <div style=" height:150px; overflow:auto; border-style:solid; border-width:thin; font-weight:bold; font-size:larger;width:98%">
            <asp:DataList ID="dtlTarea" runat="server">
               <ItemTemplate>
                    <asp:LinkButton CssClass="ml" ID="lnk" runat="server" SkinId="lnkSinEstilo" PostBackUrl='<%#"~/"+Eval("meRuta")%>' Text='<%#bind("descripcion")%>'></asp:LinkButton>
                </ItemTemplate>
            </asp:DataList>
            </div>
    </asp:Panel>
</asp:Panel>    
    <div id="dvMensajes" runat="server" style="position:absolute;top:0;left:0" class="dvMensajes" visible="false">
    <table><tr><td><div runat="server" id="dvMensjesUs"></div></td><td style="width:5px;"></td></tr></table>
    </div>

<script type="text/javascript">
    var i = 1;
    setTimeout("a();", 1000);
    function a() {
        document.styleSheets[1].rules[0].style.cssText = 'color:' + (i == 0 ? '#406BAF' : 'black') + ';';
        i = i == 0 ? 1 : 0;
        setTimeout("a();", 1000);
    }
    
</script>
   </asp:Content>
