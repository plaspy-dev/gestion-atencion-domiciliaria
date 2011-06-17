<%@ Page Title="Hoja de enfermeria" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="enfermeria.aspx.cs" Inherits="paciente_enfermeria" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="Panel1" DefaultButton="IBuscar">
<fieldset>
        <legend>Datos del paciente</legend>
    <table>
        <tr>
                <td>
                    Documento
                    <asp:SqlDataSource ID="SDocumentos" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:connBD %>" 
                        SelectCommand="SELECT [tdocId], [tdocDescripcion] FROM [phdTipoDocumento]">
                    </asp:SqlDataSource>
                </td>
                <td>
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <table>
                        <tr>
                            <td>
                            <asp:DropDownList ID="DDocumento" runat="server" 
                                DataSourceID="SDocumentos" DataTextField="tdocDescripcion" 
                                DataValueField="tdocId">
                                </asp:DropDownList>
                            </td>
                            <td><asp:TextBox ID="TDocumento" runat="server" ValidationGroup="documento" 
                                CssClass="entero"></asp:TextBox>
                            </td>
                        </tr>
                        </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td>
                    <asp:UpdatePanel ID="UBuscar" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Button ID="IBuscar" runat="server" Text="..." onclick="IBuscar_Click" ValidationGroup="documento" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:HiddenField ID="HId" runat="server" Value="" />
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="TDocumento" ErrorMessage="Por favor ingrese un documento." 
                        SetFocusOnError="True" ValidationGroup="documento"></asp:RequiredFieldValidator>
                </td>
                <td>&nbsp;
                    </td>
            </tr>
        <tr>
            <td>
                Apellidos</td>
            <td>
                <asp:Label runat="server" ID="LApellidos"></asp:Label>
            </td>
            <td>
                Nombres</td>
            <td>
                <asp:Label runat="server" ID="LNombres"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Entidad</td>
            <td>
                <asp:Label runat="server" ID="LEntidad"></asp:Label>
            </td>
            <td>
                Tipo de afiliado</td>
            <td>
                <asp:Label runat="server" ID="LTAfiliado"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Dirección</td>
            <td>
                <asp:Label runat="server" ID="LDireccion"></asp:Label>
            </td>
            <td>
                Edad</td>
            <td>
                <asp:Label runat="server" ID="LEdad"></asp:Label>
            </td>
        </tr>
    </table>
    </fieldset></asp:Panel>
    <fieldset>
        <legend>Datos</legend>
        <table style="width: 100%;">
            <tr>
                <td>
                    Fecha</td>
                <td>
                    <asp:TextBox ID="TFecha" runat="server" CssClass="fecha"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="TFecha" Display="Dynamic" 
                        ErrorMessage="Por favor ingrese una fecha." SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:HiddenField ID="HIdHoja" runat="server" />
                    <asp:Button ID="BFecha" runat="server" CausesValidation="False" onclick="BFecha_Click" Text="->"/>
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td>
                    Diagnostico</td>
                <td>
                    <asp:TextBox ID="TDiagnostico" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td>
                    Dieta</td>
                <td>
                    <asp:TextBox ID="TDieta" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
        </table>
    </fieldset>
    <fieldset>
        <legend>Signos Vitales</legend>
        <asp:UpdatePanel ID="USignoVital" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="GSignoVital" runat="server" DataSourceID="SSignoVital" 
                AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
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
    </fieldset>
    <fieldset>
        <legend>Control de liquidos</legend>
        <table style="width: 100%;">
            <tr>
                <td>
                    <fieldset>
                    <legend>Administrados</legend>
                    <asp:UpdatePanel ID="UControlLiquidosA" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="GControlLiquidosA" runat="server" DataSourceID="SControlLiquidosA" 
                        AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
            <Columns>
                <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                <asp:BoundField DataField="horai" HeaderText="Hora Ini." />
                <asp:BoundField DataField="horaf" HeaderText="Hora Fin" />
                <asp:BoundField DataField="clase" HeaderText="Clase" />
                <asp:BoundField DataField="iv" HeaderText="IV" />
                <asp:TemplateField HeaderText="VO">
                    <ItemTemplate>
                        <asp:CheckBox ID="CheckBox1" runat="server" Enabled="false" Checked='<%# Bind("vo") %>'></asp:CheckBox>
                    </ItemTemplate>
                </asp:TemplateField>
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
                            SelectCommand="SELECT id,horai,horaf,clase,iv,vo,total FROM control_liquidos_hoja_enfermeria WHERE hoja_enfermeria=@hoja AND tipo=0"
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
                    <asp:BoundField DataField="iv" HeaderText="IV" />
                    <asp:TemplateField HeaderText="VO">
                        <EditItemTemplate>
                            <asp:CheckBox ID="CVo" runat="server" Checked='<%# Bind("vo") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="CVo" runat="server" Checked='<%# Bind("vo") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("vo") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="total" HeaderText="Total" />
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <sdg:CustomDataSource ID="SDControlLiquidosA" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,horai,horaf,clase,iv,vo,total FROM control_liquidos_hoja_enfermeria WHERE id=@id"
                            InsertCommand="INSERT INTO control_liquidos_hoja_enfermeria(hoja_enfermeria,horai,horaf,clase,iv,vo,total,tipo) VALUES (@hoja, @horai, @horaf, @clase, @iv, @vo, @total, 0)"
                            UpdateCommand="UPDATE control_liquidos_hoja_enfermeria SET horai=@horai,horaf=@horaf,clase=@clase,iv=@iv,vo=@vo,total=@total WHERE id=@id"
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
        </asp:UpdatePanel>
        </fieldset>
                </td>
                <td>
                    <fieldset>
                    <legend>Eliminados</legend>
                    <asp:UpdatePanel ID="UControlLiquidosE" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="GControlLiquidosE" runat="server" DataSourceID="SControlLiquidosE" 
                        AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
            <Columns>
                <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                <asp:BoundField DataField="horai" HeaderText="Hora Ini." />
                <asp:BoundField DataField="horaf" HeaderText="Hora Fin" />
                <asp:BoundField DataField="clase" HeaderText="Clase" />
                <asp:BoundField DataField="iv" HeaderText="IV" />
                <asp:TemplateField HeaderText="VO">
                    <ItemTemplate>
                        <asp:CheckBox ID="CheckBox1" runat="server" Enabled="false" Checked='<%# Bind("vo") %>'></asp:CheckBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="total" HeaderText="Total" />
            </Columns>
            <SelectedRowStyle CssClass="selecteditem" />
        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Button ID="BMaSControlLiquidosE" runat="server" Text="+" 
                            onclick="BMaSControlLiquidosE_Click"/>
                    </td>
                </tr>
            </table>
        <sdg:CustomDataSource ID="SControlLiquidosE" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,horai,horaf,clase,iv,vo,total FROM control_liquidos_hoja_enfermeria WHERE hoja_enfermeria=@hoja AND tipo=1"
                            DeleteCommand="DELETE FROM control_liquidos_hoja_enfermeria WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdHoja" DefaultValue="0" PropertyName="Value" Name="hoja" />
                            </SelectParameters>
        </sdg:CustomDataSource>
            <div id="dControlLiquidosE" title="Control de líquidos">
            <asp:DetailsView ID="DControlLiquidosE" runat="server" Width="100%" 
                DataSourceID="SDControlLiquidosE" DataKeyNames="id" 
                AutoGenerateRows="False" DefaultMode="Edit" 
                    onitemcommand="DControlLiquidosE_ItemCommand" 
                    oniteminserted="DControlLiquidosE_ItemInserted" 
                    onitemupdated="DControlLiquidosE_ItemUpdated" >
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
                    <asp:BoundField DataField="iv" HeaderText="IV" />
                    <asp:TemplateField HeaderText="VO">
                        <EditItemTemplate>
                            <asp:CheckBox ID="CVo" runat="server" Checked='<%# Bind("vo") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="CVo" runat="server" Checked='<%# Bind("vo") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("vo") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="total" HeaderText="Total" />
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <sdg:CustomDataSource ID="SDControlLiquidosE" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,horai,horaf,clase,iv,vo,total FROM control_liquidos_hoja_enfermeria WHERE id=@id"
                            InsertCommand="INSERT INTO control_liquidos_hoja_enfermeria(hoja_enfermeria,horai,horaf,clase,iv,vo,total,tipo) VALUES (@hoja, @horai, @horaf, @clase, @iv, @vo, @total, 1)"
                            UpdateCommand="UPDATE control_liquidos_hoja_enfermeria SET horai=@horai,horaf=@horaf,clase=@clase,iv=@iv,vo=@vo,total=@total WHERE id=@id"
                            ParentDataSource="SControlLiquidosE"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GControlLiquidosE" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:ControlParameter ControlID="GControlLiquidosE" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                                <asp:Parameter Name="vo" DbType="Boolean" /> 
                            </UpdateParameters>
        </sdg:CustomDataSource>
        </ContentTemplate>
        </asp:UpdatePanel>
        </fieldset></td>
            </tr>
        </table>
    </fieldset>
    <fieldset>
        <legend>Medicamentos</legend>
        <asp:UpdatePanel ID="UMedicamentos" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="GMedicamentos" runat="server" DataSourceID="SMedicamentos" 
                AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
            <Columns>
                <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
                <asp:BoundField DataField="medicamento" HeaderText="Medicamento" />
                <asp:BoundField DataField="hora" HeaderText="Hora" />
            </Columns>
            <SelectedRowStyle CssClass="selecteditem" />
        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Button ID="BMasMedicamentos" runat="server" onclick="BMasMedicamentos_Click" 
                            Text="+" />
                    </td>
                </tr>
            </table>
        <sdg:CustomDataSource ID="SMedicamentos" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,medicamento,hora FROM medicamentos_hoja_enfermeria WHERE hoja_enfermeria=@hoja"
                            DeleteCommand="DELETE FROM medicamentos_hoja_enfermeria WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdHoja" DefaultValue="0" PropertyName="Value" Name="hoja" />
                            </SelectParameters>
        </sdg:CustomDataSource>
            <div id="dMedicamentos" title="Medicamentos">
            <asp:DetailsView ID="DMedicamentos" runat="server" Width="100%" 
                DataSourceID="SDMedicamentos" DataKeyNames="id" 
                AutoGenerateRows="False" DefaultMode="Edit" 
                oniteminserted="DMedicamentos_ItemInserted" 
                onitemupdated="DMedicamentos_ItemUpdated" 
                onitemcommand="DMedicamentos_ItemCommand">
                <Fields>
                    <asp:BoundField DataField="medicamento" HeaderText="Medicamento" />
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
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <sdg:CustomDataSource ID="SDMedicamentos" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,medicamento,hora FROM medicamentos_hoja_enfermeria WHERE id=@id"
                            InsertCommand="INSERT INTO medicamentos_hoja_enfermeria(hoja_enfermeria,hora,medicamento) VALUES (@hoja, @hora, @medicamento)"
                            UpdateCommand="UPDATE medicamentos_hoja_enfermeria SET hora=@hora,medicamento=@medicamento WHERE id=@id"
                            ParentDataSource="SMedicamentos"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GMedicamentos" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:ControlParameter ControlID="GMedicamentos" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </UpdateParameters>
        </sdg:CustomDataSource>
        </ContentTemplate>
        </asp:UpdatePanel>
    </fieldset>
    <fieldset>
        <legend>Valoracion medica</legend>
        <asp:HiddenField ID="HIdValoracion" runat="server" />
        <table style="width: 100%;">
            <tr>
                <td>
                    Neurológico</td>
                <td>
                    <asp:TextBox ID="TNeurologico" runat="server" Width="100%"></asp:TextBox>
                    </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td>
                    Cabeza</td>
                <td>
                    <asp:TextBox ID="TCabeza" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td>
                    Cuello</td>
                <td>
                    <asp:TextBox ID="TCuello" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td>
                    Tórax</td>
                <td>
                    <asp:TextBox ID="TTorax" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Abdomen</td>
                <td>
                    <asp:TextBox ID="TAbdomen" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    MsSs</td>
                <td>
                    <asp:TextBox ID="TMsss" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Msls</td>
                <td>
                    <asp:TextBox ID="TMsls" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Genitourinario</td>
                <td>
                    <asp:TextBox ID="TGenitourinario" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    Observaciones</td>
                <td>
                    <asp:TextBox ID="TObservaciones" runat="server" Width="100%"></asp:TextBox>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
    </fieldset>
    <fieldset>
        <legend>Bitacora</legend>
        <asp:UpdatePanel ID="UBitacora" runat="server" UpdateMode="Conditional"> 
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="GBitacora" runat="server" DataSourceID="SBitacora" 
                AutoGenerateColumns="False" DataKeyNames="id" ShowFooter="True" >
            <Columns>
                <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/imgs/edit.gif" />
                <asp:CommandField ButtonType="Image" DeleteImageUrl="~/imgs/eliminar.gif" ShowDeleteButton="True" />
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
        <sdg:CustomDataSource ID="SBitacora" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,observaciones,hora FROM bitacora_hoja_enfermeria WHERE hoja_enfermeria=@hoja"
                            DeleteCommand="DELETE FROM bitacora_hoja_enfermeria WHERE id=@id"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdHoja" DefaultValue="0" PropertyName="Value" Name="hoja" />
                            </SelectParameters>
        </sdg:CustomDataSource>
            <div id="dBitacora" title="Bitacora">
            <asp:DetailsView ID="DBitacora" runat="server" Width="100%" 
                DataSourceID="SDBitacora" DataKeyNames="id" 
                AutoGenerateRows="False" DefaultMode="Edit" 
                oniteminserted="DBitacora_ItemInserted" 
                onitemupdated="DBitacora_ItemUpdated" 
                onitemcommand="DBitacora_ItemCommand">
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
                    <asp:TemplateField HeaderText="Observaciones">
                        <EditItemTemplate>
                            <asp:TextBox ID="TObservaciones" TextMode="MultiLine" Width="100%" runat="server" Text='<%# Bind("observaciones") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator1" runat="server" ErrorMessage="Por favor ingrese unas observaciones." ControlToValidate="TObservaciones" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TObservaciones" TextMode="MultiLine" Width="100%" runat="server" Text='<%# Bind("observaciones") %>'></asp:TextBox><asp:RequiredFieldValidator
                                ID="RequiredFieldValidator1" runat="server" ErrorMessage="Por favor ingrese unas observaciones." ControlToValidate="TObservaciones" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("observaciones") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" />
                    <asp:CommandField ButtonType="Button" ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>
            </div>
            <sdg:CustomDataSource ID="SDBitacora" runat="server" ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            SelectCommand="SELECT id,observaciones,hora FROM bitacora_hoja_enfermeria WHERE id=@id"
                            InsertCommand="INSERT INTO bitacora_hoja_enfermeria(hoja_enfermeria,hora,observaciones) VALUES (@hoja, @hora, @observaciones)"
                            UpdateCommand="UPDATE bitacora_hoja_enfermeria SET hora=@hora,observaciones=@observaciones WHERE id=@id" 
                            ParentDataSource="SBitacora"
                            >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GBitacora" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:ControlParameter ControlID="GBitacora" DefaultValue="0" PropertyName="SelectedValue" Name="id" />
                            </UpdateParameters>
        </sdg:CustomDataSource>
        </ContentTemplate>
        </asp:UpdatePanel>
    </fieldset>
    <table border="0" width="100%">
        <tr>
            <td align="right">
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                    onclick="BAceptar_Click" /><asp:Button ID="BCancelar"
                    runat="server" Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click"/></td>
        </tr>
    </table>
    <script type="text/javascript">

        $('#ctl00_cph_USignoVital').panelUpdated(function() {
            addDialog("#ctl00_cph_USignoVital", "#dSignoVital");
        });
        $('#ctl00_cph_UControlLiquidosA').panelUpdated(function() {
            addDialog("#ctl00_cph_UControlLiquidosA", "#dControlLiquidosA");
        });
        $('#ctl00_cph_UControlLiquidosE').panelUpdated(function() {
            addDialog("#ctl00_cph_UControlLiquidosE", "#dControlLiquidosE");
        });
        $('#ctl00_cph_UMedicamentos').panelUpdated(function() {
            addDialog("#ctl00_cph_UMedicamentos", "#dMedicamentos");
        });
        $('#ctl00_cph_UBitacora').panelUpdated(function() {
            addDialog("#ctl00_cph_UBitacora", "#dBitacora");
        });

        $(document).ready(function() {
            $("#ctl00_cph_BFecha").hide();
            $("#ctl00_cph_TFecha").datepicker({
                onClose: function(dateText, inst) { if ($.getUrlVar('f') != $(this).val()) $("#ctl00_cph_BFecha").click(); }
            });
        });
                
        function iniciopagina() {
            $("#ctl00_cph_TDocumento").blur(function() { if($.getUrlVar('id')!=$(this).val()) $("#ctl00_cph_IBuscar").click(); });
        }
    </script>
</asp:Content>

