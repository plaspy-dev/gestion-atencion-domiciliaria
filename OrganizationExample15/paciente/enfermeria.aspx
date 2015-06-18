<%@ Page Title="Hoja de enfermería" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="enfermeria.aspx.cs" Inherits="paciente_enfermeria" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">

    $(function() {
        $('#<%= USignoVital.ClientID %>').panelUpdated(function() {
            addDialog("#<%= USignoVital.ClientID %>", "#dSignoVital");
        });
        $('#<%= UControlLiquidosA.ClientID %>').panelUpdated(function() {
            addDialog("#<%= UControlLiquidosA.ClientID %>", "#dControlLiquidosA");
        });
        $('#<%= UControlLiquidosE.ClientID %>').panelUpdated(function() {
            addDialog("#<%= UControlLiquidosE.ClientID %>", "#dControlLiquidosE");
        });
        $('#<%= UMedicamentos.ClientID %>').panelUpdated(function() {
            addDialog("#<%= UMedicamentos.ClientID %>", "#dMedicamentos");
        });
        $('#<%= UBitacora.ClientID %>').panelUpdated(function() {
            addDialog("#<%= UBitacora.ClientID %>", "#dBitacora");
        });
        $("#<%= TFecha.ClientID %>").datepicker({
            onClose: function(dateText, inst) { if ($.getUrlVar('f') != $(this).val()) $("#<%= BFecha.ClientID %>").click(); }
        });
    });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<div id="dImprimir">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <asp:UpdatePanel runat="server" id="PDatos" Visible="false" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:HiddenField runat="server" ID="HIdValoracion" />
        <uc4:detallepaciente ID="CCDetallePaciente" runat="server" />
        <table>
            <tr>
                <td>Fecha</td>
                <td><asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="TFecha" Display="Dynamic" 
                        ErrorMessage="Por favor ingrese una fecha." SetFocusOnError="True"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidator1" runat="server" MinimumValue="12/12/1900" MaximumValue="12/12/2100" SetFocusOnError="true" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." Type="Date"></asp:RangeValidator>
                    <asp:HiddenField ID="HIdHoja" runat="server" />
                    <asp:Button ID="BFecha" CssClass="hide" runat="server" CausesValidation="False" onclick="BFecha_Click" Text="->"/></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>Dieta</td>
                <td><asp:DropDownList ID="DDieta" runat="server" DataSourceID="SDieta" 
                        DataTextField="nombre" DataValueField="id"></asp:DropDownList>
            <asp:SqlDataSource ID="SDieta" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT id, nombre FROM varios WHERE tipo=10 AND szReservado IS NULL ORDER BY nombre" >
            </asp:SqlDataSource></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Signos vitales</td>
            </tr>
            <tr>
                <td colspan="4">
                <asp:UpdatePanel ID="USignoVital" runat="server" UpdateMode="Conditional"> 
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <asp:GridView ID="GSignoVital" runat="server" DataSourceID="SSignoVital" 
                            AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
                            <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                            <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                            <asp:BoundField DataField="hora" HeaderText="Hora" />
                            <asp:BoundField DataField="ta" HeaderText="T.A." />
                            <asp:BoundField DataField="fc" HeaderText="F.C." />
                            <asp:BoundField DataField="fr" HeaderText="F.R." />
                            <asp:BoundField DataField="t" HeaderText="T." />
                        </Columns>
                        <SelectedRowStyle CssClass="selecteditem" />
                    </asp:GridView>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    <asp:Button ID="BMasSVital" runat="server" onclick="BMasSVital_Click" 
                                        Text="+" />
                                </td>
                            </tr>
                        </table>
                    <sdg:CustomDataSource ID="SSignoVital" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        SelectCommand="SELECT id,hora,ta,fc,fr,t FROM signo_vital_hoja_enfermeria WHERE hoja_enfermeria=@hoja"
                                        DeleteCommand="DELETE FROM signo_vital_hoja_enfermeria WHERE id=@id"
                                        >
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="HIdHoja" DefaultValue="0" PropertyName="Value" Name="hoja" />
                                        </SelectParameters>
                    </sdg:CustomDataSource>
                        <div id="dSignoVital" title="Signos vitales">
                        <asp:DetailsView ID="DSignoVital" runat="server" Width="100%" 
                            DataSourceID="SDetalleView" DataKeyNames="id" 
                            AutoGenerateRows="False" DefaultMode="Edit" 
                            oniteminserted="DSignoVital_ItemInserted" 
                            onitemupdated="DSignoVital_ItemUpdated" 
                            onitemcommand="DSignoVital_ItemCommand">
                            <Fields>
                                <asp:TemplateField HeaderText="Hora">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="THora" runat="server" CssClass="hora" Text='<%# Bind("hora") %>'></asp:TextBox><asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese una hora." ControlToValidate="THora" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                        <asp:TextBox ID="THora" runat="server" CssClass="hora" Text='<%# Bind("hora") %>'></asp:TextBox><asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese una hora." ControlToValidate="THora" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("hora") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ta" HeaderText="T.A." />
                                <asp:BoundField DataField="fc" HeaderText="F.C." />
                                <asp:BoundField DataField="fr" HeaderText="F.R." />
                                <asp:BoundField DataField="t" HeaderText="T." />
                                <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                                <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                            </Fields>
                        </asp:DetailsView>
                        </div>
                        <sdg:CustomDataSource ID="SDetalleView" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        SelectCommand="SELECT id,hora,ta,fc,fr,t FROM signo_vital_hoja_enfermeria WHERE id=@id"
                                        InsertCommand="INSERT INTO signo_vital_hoja_enfermeria(hoja_enfermeria,hora,ta,fc,fr,t) VALUES (@hoja, @hora, @ta, @fc, @fr, @t)"
                                        UpdateCommand="UPDATE signo_vital_hoja_enfermeria SET hora=@hora,ta=@ta,fc=@fc,fr=@fr,t=@t WHERE id=@id"
                                        ParentDataSource="SSignoVital"
                                        >
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="GSignoVital" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                                        </SelectParameters>
                                        <UpdateParameters>
                                            <asp:ControlParameter ControlID="GSignoVital" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                                        </UpdateParameters>
                    </sdg:CustomDataSource>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="celdaTitulo">Control de líquidos</td>
            </tr>
            <tr>
                <td colspan="2" class="celdaTitulo" style="width: 50%">Administrados</td>
                <td colspan="2" class="celdaTitulo" style="width: 50%">Eliminados</td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:UpdatePanel ID="UControlLiquidosA" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="GControlLiquidosA" runat="server" DataSourceID="SControlLiquidosA" 
                        AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
                        <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
            <Columns>                
                <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                <asp:BoundField DataField="horai" HeaderText="Hora Ini." />
                <asp:BoundField DataField="horaf" HeaderText="Hora Fin" />
                <asp:BoundField DataField="clase" HeaderText="Clase" />
                <asp:BoundField DataField="iv" HeaderText="Vía" />
                <asp:BoundField DataField="total" HeaderText="Total" />
            </Columns>
            <SelectedRowStyle CssClass="selecteditem" />
        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Button ID="BMasControlLiquidosA" runat="server" Text="+" 
                            onclick="BMasControlLiquidosA_Click" />
                    </td>
                </tr>
            </table>
        <sdg:CustomDataSource ID="SControlLiquidosA" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,horai,clase,total,iv,horaf FROM control_liquidos_hoja_enfermeria WHERE hoja_enfermeria=@hoja AND tipo=0"
                            DeleteCommand="DELETE FROM control_liquidos_hoja_enfermeria WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdHoja" DefaultValue="0" PropertyName="Value" Name="hoja" />
                            </SelectParameters>
        </sdg:CustomDataSource>
            <div id="dControlLiquidosA" title="Control de líquidos">
            <asp:DetailsView ID="DControlLiquidosA" runat="server" Width="100%" 
                DataSourceID="SDControlLiquidosA" DataKeyNames="id" 
                AutoGenerateRows="False" DefaultMode="Edit" 
                    onitemcommand="DControlLiquidosA_ItemCommand" 
                    oniteminserted="DControlLiquidosA_ItemInserted" 
                    onitemupdated="DControlLiquidosA_ItemUpdated" >
                <Fields>
                    <asp:TemplateField HeaderText="Hora Ini.">
                        <EditItemTemplate>
                            <asp:TextBox ID="THoraI" runat="server" CssClass="hora" Text='<%# Bind("horai") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese una hora." ControlToValidate="THoraI" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="THoraI" runat="server" CssClass="hora" Text='<%# Bind("horai") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor ingrese una hora." ControlToValidate="THoraI" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("horai") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Hora Fin">
                        <EditItemTemplate>
                            <asp:TextBox ID="THoraF" runat="server" CssClass="hora" Text='<%# Bind("horaf") %>'></asp:TextBox></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="THoraF" runat="server" CssClass="hora" Text='<%# Bind("horaf") %>'></asp:TextBox></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("horaf") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="clase" HeaderText="Clase" />
                    <asp:TemplateField HeaderText="Vía">
                        <EditItemTemplate>
                            <asp:DropDownList ID="DVia" runat="server" SelectedValue='<%# Bind("iv") %>' DataSourceID="SVia" DataTextField="nombre" DataValueField="nombre">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SVia" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT nombre FROM varios WHERE tipo=12 AND szReservado IS NULL ORDER BY nombre" >
                            </asp:SqlDataSource>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:DropDownList ID="DVia" runat="server" SelectedValue='<%# Bind("iv") %>' DataSourceID="SVia" DataTextField="nombre" DataValueField="nombre">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SVia" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                SelectCommand="SELECT nombre FROM varios WHERE tipo=12 AND szReservado IS NULL ORDER BY nombre" >
                            </asp:SqlDataSource>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label5" runat="server" Text='<%# Bind("iv") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="total" HeaderText="Total" />
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <sdg:CustomDataSource ID="SDControlLiquidosA" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,horai,clase,total,iv,horaf FROM control_liquidos_hoja_enfermeria WHERE id=@id"
                            InsertCommand="INSERT INTO control_liquidos_hoja_enfermeria(hoja_enfermeria,horai,clase,total,tipo,iv,horaf) VALUES (@hoja, @horai, @clase, @total, 0, @iv, @horaf)"
                            UpdateCommand="UPDATE control_liquidos_hoja_enfermeria SET horai=@horai,clase=@clase,total=@total,iv=@iv,horaf=@horaf WHERE id=@id"
                            ParentDataSource="SControlLiquidosA"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GControlLiquidosA" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:ControlParameter ControlID="GControlLiquidosA" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </UpdateParameters>
        </sdg:CustomDataSource>
        </ContentTemplate>
        </asp:UpdatePanel></td>
                    <td colspan="2">
                        <asp:UpdatePanel ID="UControlLiquidosE" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:GridView ID="GControlLiquidosE" runat="server" AutoGenerateColumns="False" 
                                                DataKeyNames="id" DataSourceID="SControlLiquidosE" ShowFooter="True">
                                                <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                                                <Columns>
                                                    <asp:CommandField ButtonType="Image" SelectImageUrl="~/imgs/edit.gif" 
                                                        ShowSelectButton="True" />
                                                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" 
                                                        ShowDeleteButton="True" />
                                                    <asp:BoundField DataField="horai" HeaderText="Hora" />
                                                    <asp:BoundField DataField="clase" HeaderText="Tipo" />
                                                    <asp:BoundField DataField="total" HeaderText="Cantidad" 
                                                        ItemStyle-HorizontalAlign="Right" />
                                                </Columns>
                                                <SelectedRowStyle CssClass="selecteditem" />
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Button ID="BMaSControlLiquidosE" runat="server" 
                                                onclick="BMaSControlLiquidosE_Click" Text="+" />
                                        </td>
                                    </tr>
                                </table>
                                <sdg:CustomDataSource ID="SControlLiquidosE" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    DeleteCommand="DELETE FROM control_liquidos_hoja_enfermeria WHERE id=@id" 
                                    SelectCommand="SELECT id,horai,clase,total FROM control_liquidos_hoja_enfermeria WHERE hoja_enfermeria=@hoja AND tipo=1">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="HIdHoja" DefaultValue="0" Name="hoja" 
                                            PropertyName="Value" />
                                    </SelectParameters>
                                </sdg:CustomDataSource>
                                <div ID="dControlLiquidosE" title="Control de líquidos">
                                    <asp:DetailsView ID="DControlLiquidosE" runat="server" AutoGenerateRows="False" 
                                        DataKeyNames="id" DataSourceID="SDControlLiquidosE" DefaultMode="Edit" 
                                        onitemcommand="DControlLiquidosE_ItemCommand" 
                                        oniteminserted="DControlLiquidosE_ItemInserted" 
                                        onitemupdated="DControlLiquidosE_ItemUpdated" Width="100%">
                                        <Fields>
                                            <asp:TemplateField HeaderText="Hora">
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="THoraI" runat="server" CssClass="hora" 
                                                        Text='<%# Bind("horai") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                        ControlToValidate="THoraI" Display="Dynamic" 
                                                        ErrorMessage="Por favor ingrese una hora." SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                                <InsertItemTemplate>
                                                    <asp:TextBox ID="THoraI" runat="server" CssClass="hora" 
                                                        Text='<%# Bind("horai") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                        ControlToValidate="THoraI" Display="Dynamic" 
                                                        ErrorMessage="Por favor ingrese una hora." SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                </InsertItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("horai") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Tipo">
                                                <EditItemTemplate>
                                                    <asp:DropDownList ID="DTipo" runat="server" DataSourceID="STipo" 
                                                        DataTextField="nombre" DataValueField="nombre" 
                                                        SelectedValue='<%# Bind("clase") %>'>
                                                    </asp:DropDownList>
                                                    <asp:SqlDataSource ID="STipo" runat="server" 
                                                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                                        SelectCommand="SELECT nombre FROM varios WHERE tipo=11 AND szReservado IS NULL ORDER BY nombre">
                                                    </asp:SqlDataSource>
                                                </EditItemTemplate>
                                                <InsertItemTemplate>
                                                    <asp:DropDownList ID="DTipo" runat="server" DataSourceID="STipo" 
                                                        DataTextField="nombre" DataValueField="nombre" 
                                                        SelectedValue='<%# Bind("clase") %>'>
                                                    </asp:DropDownList>
                                                    <asp:SqlDataSource ID="STipo" runat="server" 
                                                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                                        SelectCommand="SELECT nombre FROM varios WHERE tipo=11 AND szReservado IS NULL ORDER BY nombre">
                                                    </asp:SqlDataSource>
                                                </InsertItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("clase") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Cantidad">
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="TCantidad" runat="server" CssClass="entero" 
                                                        Text='<%# Bind("total") %>'></asp:TextBox>
                                                    ml. o gr.
                                                </EditItemTemplate>
                                                <InsertItemTemplate>
                                                    <asp:TextBox ID="TCantidad" runat="server" CssClass="entero" 
                                                        Text='<%# Bind("total") %>'></asp:TextBox>
                                                    ml. o gr.
                                                </InsertItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("total") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:CommandField ButtonType="Button" ShowInsertButton="True" />
                                            <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                                        </Fields>
                                    </asp:DetailsView>
                                </div>
                                <sdg:CustomDataSource ID="SDControlLiquidosE" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    InsertCommand="INSERT INTO control_liquidos_hoja_enfermeria(hoja_enfermeria,horai,clase,total,tipo) VALUES (@hoja, @horai, @clase, @total, 1)" 
                                    ParentDataSource="SControlLiquidosE" 
                                    SelectCommand="SELECT id,horai,clase,total FROM control_liquidos_hoja_enfermeria WHERE id=@id" 
                                    UpdateCommand="UPDATE control_liquidos_hoja_enfermeria SET horai=@horai,clase=@clase,total=@total WHERE id=@id">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="GControlLiquidosE" DefaultValue="0" Name="id" 
                                            PropertyName="SelectedValue" />
                                    </SelectParameters>
                                    <UpdateParameters>
                                        <asp:ControlParameter ControlID="GControlLiquidosE" DefaultValue="0" Name="id" 
                                            PropertyName="SelectedValue" />
                                        <asp:Parameter DbType="Boolean" Name="vo" />
                                    </UpdateParameters>
                                </sdg:CustomDataSource>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="celdaTitulo" colspan="4">
                        Medicamentos</td>
                </tr>
                <tr>
                    <td colspan="4">
                        <asp:UpdatePanel ID="UMedicamentos" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:GridView ID="GMedicamentos" runat="server" AutoGenerateColumns="False" 
                                                DataKeyNames="id" DataSourceID="SMedicamentos" ShowFooter="True">
                                                <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                                                <Columns>
                                                    <asp:CommandField ButtonType="Image" SelectImageUrl="~/imgs/edit.gif" 
                                                        ShowSelectButton="True" />
                                                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" 
                                                        ShowDeleteButton="True" />
                                                    <asp:BoundField DataField="medicamento" HeaderText="Medicamento" />
                                                    <asp:BoundField DataField="hora" HeaderText="Hora" />
                                                </Columns>
                                                <SelectedRowStyle CssClass="selecteditem" />
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Button ID="BMasMedicamentos" runat="server" 
                                                onclick="BMasMedicamentos_Click" Text="+" />
                                        </td>
                                    </tr>
                                </table>
                                <sdg:CustomDataSource ID="SMedicamentos" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    DeleteCommand="DELETE FROM medicamentos_hoja_enfermeria WHERE id=@id" 
                                    SelectCommand="SELECT id,medicamento,hora FROM medicamentos_hoja_enfermeria WHERE hoja_enfermeria=@hoja">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="HIdHoja" DefaultValue="0" Name="hoja" 
                                            PropertyName="Value" />
                                    </SelectParameters>
                                </sdg:CustomDataSource>
                                <div ID="dMedicamentos" title="Medicamentos">
                                    <asp:DetailsView ID="DMedicamentos" runat="server" AutoGenerateRows="False" 
                                        DataKeyNames="id" DataSourceID="SDMedicamentos" DefaultMode="Edit" 
                                        onitemcommand="DMedicamentos_ItemCommand" 
                                        oniteminserted="DMedicamentos_ItemInserted" 
                                        onitemupdated="DMedicamentos_ItemUpdated" Width="100%">
                                        <Fields>
                                            <asp:BoundField DataField="medicamento" HeaderText="Medicamento" />
                                            <asp:TemplateField HeaderText="Hora">
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="THora" runat="server" CssClass="hora" 
                                                        Text='<%# Bind("hora") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                        ControlToValidate="THora" Display="Dynamic" 
                                                        ErrorMessage="Por favor ingrese una hora." SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                                <InsertItemTemplate>
                                                    <asp:TextBox ID="THora" runat="server" CssClass="hora" 
                                                        Text='<%# Bind("hora") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                        ControlToValidate="THora" Display="Dynamic" 
                                                        ErrorMessage="Por favor ingrese una hora." SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                </InsertItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("hora") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:CommandField ButtonType="Button" ShowInsertButton="True" />
                                            <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                                        </Fields>
                                    </asp:DetailsView>
                                </div>
                                <sdg:CustomDataSource ID="SDMedicamentos" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    InsertCommand="INSERT INTO medicamentos_hoja_enfermeria(hoja_enfermeria,hora,medicamento) VALUES (@hoja, @hora, @medicamento)" 
                                    ParentDataSource="SMedicamentos" 
                                    SelectCommand="SELECT id,medicamento,hora FROM medicamentos_hoja_enfermeria WHERE id=@id" 
                                    UpdateCommand="UPDATE medicamentos_hoja_enfermeria SET hora=@hora,medicamento=@medicamento WHERE id=@id">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="GMedicamentos" DefaultValue="0" Name="id" 
                                            PropertyName="SelectedValue" />
                                    </SelectParameters>
                                    <UpdateParameters>
                                        <asp:ControlParameter ControlID="GMedicamentos" DefaultValue="0" Name="id" 
                                            PropertyName="SelectedValue" />
                                    </UpdateParameters>
                                </sdg:CustomDataSource>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="celdaTitulo" colspan="4">
                        Valoración medica</td>
                </tr>
                <tr>
                    <td>
                        Neurológico</td>
                    <td colspan="3">
                        <asp:TextBox ID="TNeurologico" runat="server" Width="98%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Cabeza</td>
                    <td colspan="3">
                        <asp:TextBox ID="TCabeza" runat="server" Width="98%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Cuello</td>
                    <td colspan="3">
                        <asp:TextBox ID="TCuello" runat="server" Width="98%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Tórax</td>
                    <td colspan="3">
                        <asp:TextBox ID="TTorax" runat="server" Width="98%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Abdomen</td>
                    <td colspan="3">
                        <asp:TextBox ID="TAbdomen" runat="server" Width="98%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        MsSs</td>
                    <td colspan="3">
                        <asp:TextBox ID="TMsss" runat="server" Width="98%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Msls</td>
                    <td colspan="3">
                        <asp:TextBox ID="TMsls" runat="server" Width="98%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Genitourinario</td>
                    <td colspan="3">
                        <asp:TextBox ID="TGenitourinario" runat="server" Width="98%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Observaciones</td>
                    <td colspan="3">
                        <asp:TextBox ID="TObservaciones" runat="server" Width="98%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="celdaTitulo" colspan="4">
                        Bitácora</td>
                </tr>
                <tr>
                    <td colspan="4">
                        <asp:UpdatePanel ID="UBitacora" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:GridView ID="GBitacora" runat="server" AutoGenerateColumns="False" 
                                                DataKeyNames="id" DataSourceID="SBitacora" ShowFooter="True">
                                                <RowStyle CssClass="GridRow"></RowStyle>
                            <FooterStyle CssClass="GridFooter"></FooterStyle>
                            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                                                <Columns>
                                                    <asp:CommandField ButtonType="Image" SelectImageUrl="~/imgs/edit.gif" 
                                                        ShowSelectButton="True" />
                                                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" 
                                                        ShowDeleteButton="True" />
                                                    <asp:BoundField DataField="hora" HeaderText="Hora" />
                                                    <asp:BoundField DataField="observaciones" HeaderText="Observaciones" />
                                                </Columns>
                                                <SelectedRowStyle CssClass="selecteditem" />
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Button ID="BMasBitacora" runat="server" onclick="BMasBitacora_Click" 
                                                Text="+" />
                                        </td>
                                    </tr>
                                </table>
                                <sdg:CustomDataSource ID="SBitacora" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    DeleteCommand="DELETE FROM bitacora_hoja_enfermeria WHERE id=@id" 
                                    SelectCommand="SELECT id,observaciones,hora FROM bitacora_hoja_enfermeria WHERE hoja_enfermeria=@hoja">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="HIdHoja" DefaultValue="0" Name="hoja" 
                                            PropertyName="Value" />
                                    </SelectParameters>
                                </sdg:CustomDataSource>
                                <div ID="dBitacora" title="Bitacora">
                                    <asp:DetailsView ID="DBitacora" runat="server" AutoGenerateRows="False" 
                                        DataKeyNames="id" DataSourceID="SDBitacora" DefaultMode="Edit" 
                                        onitemcommand="DBitacora_ItemCommand" oniteminserted="DBitacora_ItemInserted" 
                                        onitemupdated="DBitacora_ItemUpdated" Width="100%">
                                        <Fields>
                                            <asp:TemplateField HeaderText="Hora">
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="THora" runat="server" CssClass="hora" 
                                                        Text='<%# Bind("hora") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                        ControlToValidate="THora" Display="Dynamic" 
                                                        ErrorMessage="Por favor ingrese una hora." SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                                <InsertItemTemplate>
                                                    <asp:TextBox ID="THora" runat="server" CssClass="hora" 
                                                        Text='<%# Bind("hora") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                        ControlToValidate="THora" Display="Dynamic" 
                                                        ErrorMessage="Por favor ingrese una hora." SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                </InsertItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("hora") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Observaciones">
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="TObservaciones" runat="server" Rows="10" 
                                                        Text='<%# Bind("observaciones") %>' TextMode="MultiLine" Width="400px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                                        ControlToValidate="TObservaciones" Display="Dynamic" 
                                                        ErrorMessage="Por favor ingrese unas observaciones." SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                                <InsertItemTemplate>
                                                    <asp:TextBox ID="TObservaciones" runat="server" Rows="10" 
                                                        Text='<%# Bind("observaciones") %>' TextMode="MultiLine" Width="400px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                                        ControlToValidate="TObservaciones" Display="Dynamic" 
                                                        ErrorMessage="Por favor ingrese unas observaciones." SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                </InsertItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("observaciones") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:CommandField ButtonType="Button" ShowInsertButton="True" />
                                            <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                                        </Fields>
                                    </asp:DetailsView>
                                </div>
                                <sdg:CustomDataSource ID="SDBitacora" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                    InsertCommand="INSERT INTO bitacora_hoja_enfermeria(hoja_enfermeria,hora,observaciones) VALUES (@hoja, @hora, @observaciones)" 
                                    ParentDataSource="SBitacora" 
                                    SelectCommand="SELECT id,observaciones,hora FROM bitacora_hoja_enfermeria WHERE id=@id" 
                                    UpdateCommand="UPDATE bitacora_hoja_enfermeria SET hora=@hora,observaciones=@observaciones WHERE id=@id">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="GBitacora" DefaultValue="0" Name="id" 
                                            PropertyName="SelectedValue" />
                                    </SelectParameters>
                                    <UpdateParameters>
                                        <asp:ControlParameter ControlID="GBitacora" DefaultValue="0" Name="id" 
                                            PropertyName="SelectedValue" />
                                    </UpdateParameters>
                                </sdg:CustomDataSource>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td align="right" colspan="4">
                        <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" 
                            Text="Aceptar" />
                        <asp:Button ID="BCancelar" runat="server" CausesValidation="false" 
                            onclick="BCancelar_Click" Text="Cancelar" />
                    </td>
                </tr>
            </tr>
    </table>
    </ContentTemplate>
    </asp:UpdatePanel>
    </div>
</asp:Content>

