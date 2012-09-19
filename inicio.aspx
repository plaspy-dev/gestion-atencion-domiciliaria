<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="inicio.aspx.cs" Inherits="inicio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#accordion").accordion({ autoHeight: false, navigation: true, collapsible: true, active: false, animated: false,
            change: function(event, ui) {
                ui.newContent.children('div:eq(0)').children(':submit').click();
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Repeater runat="server" ID="RAlertas">
    <HeaderTemplate>
        <div id="accordion">
    </HeaderTemplate>
    <ItemTemplate>
        <h3><a href="#"><%# Eval("Nombre")+" (" + Eval("Numero") + ")" %></a></h3>
        <div class="hide">
            <asp:UpdatePanel runat="server" ID="UD" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Image runat="server" ID="IL" ImageUrl="~/css/ajax-loader.gif" />
                    <asp:Button runat="server" ID="BA" OnClick="OnClickBA" CssClass="hide" />
                    <asp:LinkButton Visible="false" Text="" runat="server" ID="LA" CommandName='<%# Eval("SelectCommand") %>' CommandArgument='<%# Eval("URL") %>'></asp:LinkButton>
                    <asp:GridView ID="GAlertas" runat="server" AutoGenerateColumns="False" Visible="false"
                        DataSourceID="SAlertas" EmptyDataText="No se encontraron alertas" ShowHeader="false">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:HyperLinkField DataTextField="nombre" HeaderText="Nombre" DataNavigateUrlFields="id" ItemStyle-HorizontalAlign="Left"
                                DataNavigateUrlFormatString='~/' SortExpression="nombre" ItemStyle-Wrap="false" />
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SAlertas" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="">
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

