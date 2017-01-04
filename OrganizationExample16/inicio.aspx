<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="inicio.aspx.cs" Inherits="inicio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
.closebutton {
    position: absolute;
    top: 0px; right: 0px;
    width: 20px; height: 20px
}
</style>
<script type="text/javascript">
    $(function() {
        $("#accordion").accordion({ autoHeight: false, navigation: true, collapsible: true, active: false, animated: false,
            change: function(event, ui) {
                ui.newContent.children('div:eq(0)').children(':submit').click();
            }
        });
        $(".closebutton").button({
            icons: {
                primary: "ui-icon-close"
            },
            text: false
        }).click(function() {
            $(this).parent().parent().hide();
            $.cookie("cumple-" + $(this).attr("perid"), "1", { expires: 7 });
            return false;
        });

        $("#notas ul li").each(function() {
            if ($.cookie("cumple-" + $(this).find("span").attr("perid")) == null)
                $(this).show();
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<div id="notas">
<asp:Repeater runat="server" ID="RCumpleanos" DataSourceID="SCumpleanos">
    <HeaderTemplate>
        <ul>
    </HeaderTemplate>
    <ItemTemplate>
        <li class="hidet">
          <a href="mailto:<%# Eval("perCorreoElectronico")%>" onclick="return false;">
            <span class="closebutton" perid="<%# Eval("id") %>">Close</span> 
            <h2><%# Eval("dia") %><br /><%# Eval("nombres") %></h2>
            <p><%# Eval("cargo") %><br />
            <%# Eval("celular")%><br />
            <%# Eval("perCorreoElectronico")%><br />
            </p>
          </a>
        </li>
    </ItemTemplate>
    <FooterTemplate>
        </ul>
    </FooterTemplate>
</asp:Repeater>
<asp:SqlDataSource ID="SCumpleanos" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
    SelectCommand="SELECT per.perId AS id,per.perNombre AS nombres
				,CASE DAY(perFechaNac) 
				WHEN DAY(SYSDATE()) THEN 'Hoy' 
				WHEN DAY(SYSDATE()-1) THEN 'Ayer'
				WHEN DAY(SYSDATE()-2) THEN 'Anteayer'
				WHEN DAY(SYSDATE()+1) THEN 'Mañana'
				END AS dia
				,cargo.carDescripcion AS cargo,perCorreoElectronico,per.perCelular AS celular
                FROM recurso_humano per  
                LEFT JOIN cargo on per.carId = cargo.carId    
				WHERE per.eEstId=1 
				AND MONTH(perFechaNac)=MONTH(SYSDATE())
				AND (DAY(perFechaNac)=DAY(SYSDATE())
				OR DAY(perFechaNac)=DAY(SYSDATE()-2)
				OR DAY(perFechaNac)=DAY(SYSDATE()-1)
				OR DAY(perFechaNac)=DAY(SYSDATE()+1)
				)
				ORDER BY DAY(perFechaNac)*100+DAY(perFechaNac);">
</asp:SqlDataSource>
</div>
<asp:Repeater runat="server" ID="RAlertas">
    <HeaderTemplate>
        <div id="accordion">
    </HeaderTemplate>
    <ItemTemplate>
        <h3><a href="#"><%# Eval("Nombre")+" (" + Eval("Numero") + ")" %></a></h3>
        <div class="hidet">
            <asp:UpdatePanel runat="server" ID="UD" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Image runat="server" ID="IL" ImageUrl="~/css/ajax-loader.gif" />
                    <asp:Button runat="server" ID="BA" OnClick="OnClickBA" CssClass="hidet" />
                    <asp:LinkButton Visible="false" Text="" runat="server" ID="LA" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
                    <asp:GridView ID="GAlertas" runat="server" AutoGenerateColumns="False" Visible="false" Width="100%"  OnRowDataBound="GAlertas_RowDataBound"
                        DataSourceID="SAlertas" EmptyDataText="No se encontraron alertas" ShowHeader="false">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:HyperLinkField DataTextField="nombre" HeaderText="Nombre" DataNavigateUrlFields="id" ItemStyle-HorizontalAlign="Left" DataNavigateUrlFormatString='~/' SortExpression="nombre" ItemStyle-Wrap="false" />
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SAlertas" runat="server" 
                        SelectCommand="SELECT NULL AS id,NULL AS nombre"
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" >
                    </asp:SqlDataSource>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </ItemTemplate>
    <FooterTemplate>
        </div>
    </FooterTemplate>
</asp:Repeater>
</asp:Content>

