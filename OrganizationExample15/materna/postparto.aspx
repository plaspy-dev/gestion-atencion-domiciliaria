<%@ Page Title="SEGUIMIENTO DOMICILIARIO POSPARTO" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="materna_postparto" Codebehind="postparto.aspx.cs" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>
<%@ Register src="~/paciente/detallepaciente.ascx" tagname="detallepaciente" tagprefix="uc4" %>
<%@ Register src="~/paciente/SeleccionarPaciente.ascx" tagname="SeleccionarPaciente" tagprefix="uc5" %>
<%@ Register src="~/paciente/cie10list.ascx" tagname="CIE10" tagprefix="uc6" %>
<%@ Register src="~/ctrl/history.ascx" tagname="History" tagprefix="uc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style>
.dantd, .dant {
    display: inline-block;
    min-width: 49%;
    white-space: nowrap;
    padding: 5px;
    padding-left: 1px;
}
.dantd {
    min-width: 200px;
}
.dantd > table {
    float: right;
    margin-left: 5px;
}
.dantd > span {
    margin-top: 5px;   
    display: inline-block;
}
.dantd .dinside {
    display: inline-block;
    float: right;
    margin-left: 10px;
    margin-top: 3px;
}
.dantd .dinside > input[type="text"] {
    width: 100px;
    margin-left: 5px;
}
.dant span {
    /*min-width: 100px;*/
    width: 60%;
    white-space: normal;
    display: inline-block;
}
.dant input {
    width: 100px;
}
.fobs {
    display: inline-block;
    padding: 5px;
}
.table-motivo td {
    white-space: nowrap;
}
.table-motivo label {
    width: 100%;
    white-space: normal;
}
.rbfr > table {
    float: right;
}
.rbfr > span {
    white-space: normal;
}
</style>
<%= SDG.Componentes.HtmlUtil.RenderScript("~/js/tinymce.min.js") %>
<script type="text/javascript">
    $(function () {
        $("#<%= TInterconsultas.ClientID %>")._tinyMCE({ idMirrorTextArea: "elm1", readonly: <%= TInterconsultas.ReadOnly ? "true" : "false" %>});
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
<uc4:detallepaciente ID="CCDetallePaciente" runat="server" Visible="false" />
<asp:Panel ID="PD" runat="server" Visible="false">
    <uc:History runat="server" ID="UCH" />
    <table style="border-collapse: collapse" class="tdl tdr tdt">
        <tr>
            <td>Fecha<asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="R4" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="R2" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una hora valida" Display="Dynamic" 
                            SetFocusOnError="true" ValidationExpression="^((?!00:00).)*$" runat="server" >*</asp:RegularExpressionValidator>
                        <sdg:DateTimeValidator runat="server" ID="DTV" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha valida." 
                    Display="Dynamic" SetFocusOnError="true">*</sdg:DateTimeValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TFecha" CssClass="fechahora"></asp:TextBox></td>
            <td>Funcionario<asp:RequiredFieldValidator ControlToValidate="UCFuncionario$TFuncionarioID" ErrorMessage="Por favor ingrese un funcionario." ID="R1" 
	                    runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td><uc1:funcionario runat="server" ID="UCFuncionario" /></td>
        </tr>
        <tr>
            <td>IPS Primaria</td>
            <td><asp:TextBox runat="server" ID="TIPS"></asp:TextBox></td>
            <td>Nivel escolaridad</td>
            <td><asp:TextBox runat="server" ID="TEscolaridad"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="2" valign="top">
                <asp:GridView ID="GMotivo" runat="server" AutoGenerateColumns="False" DataSourceID="SMotivo" EmptyDataText="No se encontraron " 
                    CssClass="table table-condensed table-bordered table-hover table-striped table-motivo" DataKeyNames="id" ShowHeader="false">
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <Columns>
                        <asp:TemplateField ItemStyle-CssClass="rbfr">
                            <ItemTemplate>
                                <asp:RadioButtonList runat="server" ID="R" RepeatColumns="2" SelectedValue='<%# Eval("value").ToString()=="1" ? "1" : (Eval("value").ToString()=="0" ? "0" : null) %>'>
                                    <asp:ListItem Value="1" Text="Si"></asp:ListItem>
                                    <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                </asp:RadioButtonList>
                                <span><%# GetHeader(Eval("Nombre")) %>
                                    <asp:RequiredFieldValidator runat="server" ID="E" Display="Dynamic" SetFocusOnError="true" ControlToValidate="R" ErrorMessage='<%# string.Format("Por favor seleccione un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SMotivo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,IF(seguimiento_materno_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_materno_items.valor) AS value 
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=156 AND varios.szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
            <td colspan="2" valign="top">
                <asp:GridView ID="GRiesgo" runat="server" AutoGenerateColumns="False" DataSourceID="SRiesgo" EmptyDataText="No se encontraron " 
                    CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="id" ShowHeader="false">
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <Columns>
                        <asp:TemplateField ItemStyle-CssClass="rbfr">
                            <ItemTemplate>
                                <asp:RadioButtonList runat="server" ID="R" RepeatColumns="2" SelectedValue='<%# Eval("value").ToString()=="1" ? "1" : (Eval("value").ToString()=="0" ? "0" : null)%>'>
                                    <asp:ListItem Value="1" Text="Si"></asp:ListItem>
                                    <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                </asp:RadioButtonList>
                                <span><%# GetHeader(Eval("Nombre")) %>
                                    <asp:RequiredFieldValidator runat="server" ID="E" Display="Dynamic" SetFocusOnError="true" ControlToValidate="R" ErrorMessage='<%# string.Format("Por favor seleccione un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SRiesgo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,IF(seguimiento_materno_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_materno_items.valor) AS value  
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=142 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Antecedentes para el embarazo</td>
        </tr>
        <tr>
            <td colspan="4" class="stripped">
                <asp:Repeater runat="server" ID="RAntecendetes" DataSourceID="SAntecendentes">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <div class="dant">
                            <span><%# GetHeader(Eval("Nombre")) %>
                                <asp:RequiredFieldValidator runat="server" ID="R" Display="Dynamic" SetFocusOnError="true" ControlToValidate="T" ErrorMessage='<%# string.Format("Por favor ingrese un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                            </span><asp:TextBox runat="server" ID="T" Text='<%# Eval("Value") %>'></asp:TextBox>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SAntecendentes" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,seguimiento_materno_items.valor AS value 
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=157 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Repeater runat="server" ID="RAntecendetes2" DataSourceID="SAntecendentes2">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <div class="dantd">
                            <asp:PlaceHolder runat="server" ID="P" Visible='<%# !string.IsNullOrEmpty(Eval("descripcion").ToString()) %>'>
                            <div class="dinside">
                                <%# GetHeader(Eval("Descripcion")) %><asp:TextBox runat="server" ID="T" Text='<%# Eval("valor2") %>'></asp:TextBox>
                            </div>
                            </asp:PlaceHolder>
                            <asp:RadioButtonList runat="server" ID="R" RepeatColumns="2" SelectedValue='<%# Eval("value").ToString()=="1" ? "1" : (Eval("value").ToString()=="0" ? "0" : null) %>'>
                                <asp:ListItem Value="1" Text="Si"></asp:ListItem>
                                <asp:ListItem Value="0" Text="No"></asp:ListItem>
                            </asp:RadioButtonList>
                            <span><%# GetHeader(Eval("Nombre")) %>
                                <asp:RequiredFieldValidator runat="server" ID="E" Display="Dynamic" SetFocusOnError="true" ControlToValidate="R" ErrorMessage='<%# string.Format("Por favor seleccione un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SAntecendentes2" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_materno_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_materno_items.valor) AS value ,seguimiento_materno_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=158 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        
        <tr>
            <td colspan="4">
                <asp:GridView ID="GAntecendentes3" runat="server" AutoGenerateColumns="False" DataSourceID="SAntecendentes3" EmptyDataText="No se encontraron " 
                    CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="id" ShowHeader="false">
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate><%# GetHeader(Eval("Nombre")) %>
                                <asp:RequiredFieldValidator runat="server" ID="R" Display="Dynamic" SetFocusOnError="true" ControlToValidate="T" ErrorMessage='<%# string.Format("Por favor ingrese un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="100%">
                            <ItemTemplate>
                                <asp:TextBox Width="100%" TextMode="MultiLine" Height="50px" runat="server" ID="T" Text='<%# Eval("Value") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SAntecendentes3" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,seguimiento_materno_items.valor AS value 
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=145 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Formula obstetrica</td>
        </tr>
        <tr>
            <td colspan="4">
                DESCRIBIR DETALLES DE ANTECEDENTES GINECOLOGICOS SEGÚN LO QUE LA PACIENTE REFIRIÓ EN EL ITEM ANTERIOR CON FECHA:
                <asp:GridView ID="GAObstetrica" runat="server" AutoGenerateColumns="False" DataSourceID="SAObstetrica" EmptyDataText="No se encontraron " 
                    CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="id">
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Concepto">
                            <ItemTemplate><asp:Label runat="server" ID="L" Text='<%# GetHeader(Eval("Nombre")) %>'></asp:Label>
                                <asp:RequiredFieldValidator runat="server" ID="R" Display="Dynamic" SetFocusOnError="true" ControlToValidate="T" ErrorMessage='<%# string.Format("Por favor ingrese un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator runat="server" ID="E" Display="Dynamic" SetFocusOnError="true" ControlToValidate="T2" ErrorMessage='<%# string.Format("Por favor ingrese un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Numero">
                            <ItemTemplate>
                                <asp:TextBox Width="100%" CssClass="entero" runat="server" ID="T" Text='<%# Eval("Value") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="100%" HeaderText="Observaciones">
                            <ItemTemplate>
                                <asp:TextBox Width="100%" runat="server" ID="T2" Text='<%# Eval("valor2") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SAObstetrica" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,seguimiento_materno_items.valor AS value,seguimiento_materno_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=147 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Revisión por sistemas</td>
        </tr>
        <tr>
            <td colspan="4" class="stripped">
                <asp:Repeater runat="server" ID="RSistemas" DataSourceID="SSistemas">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <div class="dantd">
                            <asp:PlaceHolder runat="server" ID="P" Visible='<%# !string.IsNullOrEmpty(Eval("descripcion").ToString()) %>'>
                            <div class="dinside">
                                <%# GetHeader(Eval("Descripcion")) %><asp:TextBox runat="server" ID="T" Text='<%# Eval("valor2") %>'></asp:TextBox>
                            </div>
                            </asp:PlaceHolder>
                            <asp:RadioButtonList runat="server" ID="R" RepeatColumns="2" SelectedValue='<%# Eval("value").ToString()=="1" ? "1" : (Eval("value").ToString()=="0" ? "0" : null) %>'>
                                <asp:ListItem Value="1" Text="Si"></asp:ListItem>
                                <asp:ListItem Value="0" Text="No"></asp:ListItem>
                            </asp:RadioButtonList>
                            <span><%# GetHeader(Eval("Nombre")) %>
                                <asp:RequiredFieldValidator runat="server" ID="E" Display="Dynamic" SetFocusOnError="true" ControlToValidate="R" ErrorMessage='<%# string.Format("Por favor seleccione un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SSistemas" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_materno_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_materno_items.valor) AS value ,seguimiento_materno_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=159 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Resultados laboratorio al egreso de acuerdo a causa principal</td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:TextBox runat="server" ID="TLaboratorio" TextMode="MultiLine" Width="100%" Height="50px"></asp:TextBox>
            </td>
        </tr>
        
        <tr>
            <td colspan="4" class="celdaTitulo">Examen físico</td>
        </tr>
        <tr>
            <td colspan="4" class="stripped">
                <asp:Repeater runat="server" ID="REFisico" DataSourceID="SEFisico">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <div class="dant">
                            <span><%# GetHeader(Eval("Nombre")) %><asp:RequiredFieldValidator ControlToValidate="T" ErrorMessage='<%# "Por favor ingrese un valor para "+ GetHeader(Eval("Nombre")) %>' ID="V" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></span><asp:TextBox runat="server" ID="T" Text='<%# Eval("Value") %>' placeholder='<%# GetHeader(Eval("Descripcion")) %>'></asp:TextBox>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SEFisico" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,seguimiento_materno_items.valor AS value 
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=152 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>Cardiopulmonar</td>
            <td colspan="3"><asp:TextBox runat="server" ID="TCardioPulmonar" TextMode="MultiLine" Width="100%"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="tda"><b>Senos</b></td>
        </tr>
        <tr>
            <td colspan="4" class="stripped">
                <asp:Repeater runat="server" ID="RSenos" DataSourceID="SSenos">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <div class="dantd">
                            <asp:PlaceHolder runat="server" ID="P" Visible='<%# !string.IsNullOrEmpty(Eval("descripcion").ToString()) %>'>
                            <div class="dinside">
                                <%# GetHeader(Eval("Descripcion")) %><asp:TextBox runat="server" ID="T" Text='<%# Eval("valor2") %>'></asp:TextBox>
                            </div>
                            </asp:PlaceHolder>
                            <asp:RadioButtonList runat="server" ID="R" RepeatColumns="2" SelectedValue='<%# Eval("value").ToString()=="1" ? "1" : (Eval("value").ToString()=="0" ? "0" : null) %>'>
                                <asp:ListItem Value="1" Text="Si"></asp:ListItem>
                                <asp:ListItem Value="0" Text="No"></asp:ListItem>
                            </asp:RadioButtonList>
                            <span><%# GetHeader(Eval("Nombre")) %>
                                <asp:RequiredFieldValidator runat="server" ID="E" Display="Dynamic" SetFocusOnError="true" ControlToValidate="R" ErrorMessage='<%# string.Format("Por favor seleccione un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SSenos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,seguimiento_materno_items.valor AS value ,seguimiento_materno_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=160 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="tda"><b>Abdomen</b></td>
        </tr>
        <tr>
            <td colspan="4" class="stripped">
                <asp:Repeater runat="server" ID="RAbdomen" DataSourceID="SAbdomen">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <div class="dantd">
                            <asp:PlaceHolder runat="server" ID="P" Visible='<%# !string.IsNullOrEmpty(Eval("descripcion").ToString()) %>'>
                            <div class="dinside">
                                <%# GetHeader(Eval("Descripcion")) %><asp:TextBox runat="server" ID="T" Text='<%# Eval("valor2") %>'></asp:TextBox>
                            </div>
                            </asp:PlaceHolder>
                            <asp:RadioButtonList runat="server" ID="R" RepeatColumns="2" SelectedValue='<%# Eval("value").ToString()=="1" ? "1" : (Eval("value").ToString()=="0" ? "0" : null) %>'>
                                <asp:ListItem Value="1" Text="Si"></asp:ListItem>
                                <asp:ListItem Value="0" Text="No"></asp:ListItem>
                            </asp:RadioButtonList>
                            <span><%# GetHeader(Eval("Nombre")) %>
                                <asp:RequiredFieldValidator runat="server" ID="E" Display="Dynamic" SetFocusOnError="true" ControlToValidate="R" ErrorMessage='<%# string.Format("Por favor seleccione un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SAbdomen" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,seguimiento_materno_items.valor AS value ,seguimiento_materno_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=161 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr class="tdb">
            <td>Observaciones</td>
            <td colspan="3"><asp:TextBox runat="server" ID="TAbdomen" TextMode="MultiLine" Width="100%"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="stripped">
                Miembros inferiores
                <asp:Repeater runat="server" ID="RMInferiores" DataSourceID="SMInferiores">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <asp:CheckBox CssClass="fobs" runat="server" ID="C" Text='<%# GetHeader(Eval("Nombre")) %>' Checked='<%# Eval("Value").ToString()=="1" %>' />
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SMInferiores" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,seguimiento_materno_items.valor AS value 
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=154 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Diagnostico</td>
        </tr>
        <tr class="stripped">
            <td colspan="4">
                <uc6:CIE10 runat="server" ID="CIE10" />
            </td>
        </tr>
        <tr>
            <td>Resultado perinatal<asp:RequiredFieldValidator runat="server" ID="R5" Display="Dynamic" SetFocusOnError="true" ControlToValidate="TRPerinatal" ErrorMessage="Por favor ingrese un resultado perinatal">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><asp:TextBox runat="server" ID="TRPerinatal" TextMode="MultiLine" Width="100%" Height="50px"></asp:TextBox></td>
        </tr>
        <tr>
            <td>
                <asp:RequiredFieldValidator ControlToValidate="RVivo" ErrorMessage="Por favor seleccione un valor." ID="R6" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RadioButtonList runat="server" ID="RVivo" RepeatColumns="2">
                <asp:ListItem Text="Vivo" Value="1"></asp:ListItem>
                <asp:ListItem Text="Muerto" Value="0"></asp:ListItem>
                </asp:RadioButtonList></td>
            <td>
                <asp:RequiredFieldValidator ControlToValidate="RUbicacion" ErrorMessage="Por favor seleecione un valor." ID="R7" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RadioButtonList runat="server" ID="RUbicacion" RepeatColumns="2">
                <asp:ListItem Text="Casa" Value="1"></asp:ListItem>
                <asp:ListItem Text="Hospitalizado" Value="0"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
            <td class="nw">Peso al nacer</td>
            <td>
                <asp:TextBox runat="server" ID="TPeso" CssClass="entero" placeholder="gramos"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>PATOLOGIA(S) ASOCIADAS (Al egreso)<asp:RequiredFieldValidator ControlToValidate="TPatologiasEgreso" ErrorMessage="Por favor ingrese una patología egreso." ID="R8" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><asp:TextBox runat="server" ID="TPatologiasEgreso" TextMode="MultiLine" Width="100%" Height="50px"></asp:TextBox></td>
        </tr>
        <tr class="stripped">
            <td>PATOLOGIAS IDENTIFICADAS (En la visita)<asp:RequiredFieldValidator ControlToValidate="TPatologiaVisita" ErrorMessage="Por favor ingrese una patología visita." ID="R9" 
	runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="3"><asp:TextBox runat="server" ID="TPatologiaVisita" TextMode="MultiLine" Width="100%" Height="50px"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Plan de manejo</td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GManejo" runat="server" AutoGenerateColumns="False" DataSourceID="SManejo" EmptyDataText="No se encontraron " 
                    CssClass="table table-condensed table-bordered table-hover table-striped" DataKeyNames="id" ShowHeader="false">
                    <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                    <Columns>
                        <asp:TemplateField ItemStyle-Width="30%">
                            <ItemTemplate><%# GetHeader(Eval("Nombre")) %>
                                <asp:RequiredFieldValidator runat="server" ID="R" Display="Dynamic" SetFocusOnError="true" ControlToValidate="T" ErrorMessage='<%# string.Format("Por favor ingrese un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:TextBox Width="100%" runat="server" ID="T" TextMode="MultiLine" Height="50px" Text='<%# Eval("Value") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SManejo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,seguimiento_materno_items.valor AS value 
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento=@seguimiento AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo=155 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:CheckBox runat="server" ID="CEntregaTelefonos" Text="ENTREGA DE NUMEROS TELEFONICO DE CONTACTOS CON LA EPS" />
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">OBSERVACIONES GENERALES DE LA VISITA</td>
        </tr>
        <tr>
            <td colspan="4"><asp:TextBox runat="server" ID="TObservacionesGenerales" TextMode="MultiLine" Width="100%" Height="50px"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Valoración del riesgo</td>
        </tr>
        <tr class="stripped">
            <td colspan="2">Valoración del riesgo<asp:RequiredFieldValidator ControlToValidate="RRiesgo" ErrorMessage="Por favor seleccione un riesgo." ID="R10" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
            <td colspan="2">
                <asp:RadioButtonList runat="server" ID="RRiesgo" RepeatColumns="3">
                    <asp:ListItem Text="Alto" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Medio" Value="2"></asp:ListItem>
                    <asp:ListItem Text="Bajo" Value="3"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Interconsultas<asp:RequiredFieldValidator ControlToValidate="TInterconsultas" ErrorMessage="Por favor ingrese una interconsulta." ID="R11" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:TextBox runat="server" ID="TInterconsultas" TextMode="MultiLine" CssClass="hide" Width="100%" Height="50px"></asp:TextBox>
                <textarea id="elm1" name="elm1" style="width: 99%; height: 200px;" rows="2" cols="20"></textarea>
            </td>
        </tr>

        <tr class="tdn">
            <td colspan="4"><asp:Label runat="server" ID="LMensaje" ForeColor="Red"></asp:Label>
                <asp:ValidationSummary runat="server" ID="V" /></td>
        </tr>
        <tr>
            <td><asp:Button Text="Eliminar" runat="server" ID="BEliminar" Visible="false" OnClientClick="confirm('¿Esta seguro de eliminar esta documento?')" 
                        CausesValidation="false" onclick="BEliminar_Click" /></td>
            <td colspan="3" align="right">
                <asp:Button ID="BAceptar" runat="server" onclick="BAceptar_Click" Text="Aceptar" />
                <asp:Button ID="BCancelar" runat="server" CausesValidation="False" onclick="BCancelar_Click" Text="Cancelar" />
            </td>
        </tr>
    </table>
</asp:Panel>
</asp:Content>

