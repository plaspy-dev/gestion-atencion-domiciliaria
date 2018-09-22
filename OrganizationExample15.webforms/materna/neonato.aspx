<%@ Page Title="Seguimiento domiciliario neonatos alto riesgo" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="neonato.aspx.cs" Inherits="materna_neonato" %>
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
.dscu {
    height: 28px;
}
.dscu > table {
    float: right;
    margin-left: 5px;
}
.dscu > span {
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
        $("#<%=TMadre.ClientID%>")._autoComplete({ url: "<%= ResolveClientUrl("~/webservices/servicios.asmx/GetPaciente")%>", idField: "<%=TMadreId.ClientID %>", data: {e:'<%= CUsuario.GetInstance()["entidades"] %>'} });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc5:SeleccionarPaciente ID="SeleccionarPaciente" runat="server" />
    <uc4:detallepaciente ID="CCDetallePaciente" runat="server" Visible="false" />
<asp:Panel ID="PD" runat="server" Visible="false">
    <uc:History runat="server" ID="UCH" />
    <table style="border-collapse: collapse; min-width: 620px;" class="tdl tdr tdt">
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
            <td>Madre</td>
            <td colspan="3">
                <asp:TextBox runat="server" ID="TMadre"></asp:TextBox>
                <asp:TextBox runat="server" ID="TMadreId" CssClass="hide"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2" class="celdaTitulo" style="width: 50%">Cuidados del recien nacido</td>
            <td colspan="2" class="celdaTitulo">Lactancia materna</td>
        </tr>
        <tr>
            <td colspan="2" class="tat tdr">
                <asp:Repeater runat="server" ID="RCuidados" DataSourceID="SCuidados">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <div class="dscu">
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
                <asp:SqlDataSource ID="SCuidados" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_neonato_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_neonato_items.valor) AS value ,seguimiento_neonato_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=173 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
            <td colspan="2" class="tat">
                <asp:Repeater runat="server" ID="RLactancia" DataSourceID="SLactancia">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <div class="dscu">
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
                <asp:SqlDataSource ID="SLactancia" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_neonato_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_neonato_items.valor) AS value ,seguimiento_neonato_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=174 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="2" class="tdr">Observaciones</td>
            <td colspan="2">Observaciones</td>
        </tr>
        <tr>
            <td colspan="2" class="tdr">
                <asp:TextBox runat="server" ID="TOCuidados" TextMode="MultiLine" CssClass="w100"></asp:TextBox>
            </td>
            <td colspan="2">
                <asp:TextBox runat="server" ID="TOLactancia" TextMode="MultiLine" CssClass="w100"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Antecedentes para el embarazo</td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Repeater runat="server" ID="RAntecedentesE" DataSourceID="SAntecedentesE">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <div class="dant">
                            <span><%# GetHeader(Eval("Nombre")) %>
                                <asp:RequiredFieldValidator runat="server" ID="R" Display="Dynamic" SetFocusOnError="true" ControlToValidate="T" ErrorMessage='<%# string.Format("Por favor ingrese un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                            </span><asp:TextBox runat="server" ID="T" Text='<%# Eval("Value") %>'></asp:TextBox>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SAntecedentesE" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,seguimiento_neonato_items.valor AS value 
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=175 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GAntecedentes1" runat="server" AutoGenerateColumns="False" DataSourceID="SAntecedentes1" EmptyDataText="No se encontraron " 
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
                <asp:SqlDataSource ID="SAntecedentes1" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,seguimiento_neonato_items.valor AS value 
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=176 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Repeater runat="server" ID="RAntecedentesT" DataSourceID="SAntecedentesT">
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
                <asp:SqlDataSource ID="SAntecedentesT" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_neonato_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_neonato_items.valor) AS value ,seguimiento_neonato_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=177 AND szReservado IS NULL">
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
                    SelectCommand="SELECT varios.id,varios.nombre,seguimiento_neonato_items.valor AS value,seguimiento_neonato_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=147 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Valoración de la madre y del recien nacido</td>
        </tr>
        <tr>
            <td colspan="4" class="stripped">
                <asp:Repeater runat="server" ID="RValoracion" DataSourceID="SValoracion">
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
                <asp:SqlDataSource ID="SValoracion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_neonato_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_neonato_items.valor) AS value ,seguimiento_neonato_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=165 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Síntomas de vasos espasmo</td>
        </tr>
        <tr>
            <td colspan="4" class="stripped">
                <asp:Repeater runat="server" ID="RSintomasVE" DataSourceID="SSintomasVE">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="H" Value='<%# Eval("id") %>' />
                        <div class="dant">
                            <span><%# GetHeader(Eval("Nombre")) %>
                                <asp:RequiredFieldValidator runat="server" ID="R" Display="Dynamic" SetFocusOnError="true" ControlToValidate="T" ErrorMessage='<%# string.Format("Por favor ingrese un valor para {0}", Eval("Nombre")) %>'>*</asp:RequiredFieldValidator>
                            </span><asp:TextBox runat="server" ID="T" Text='<%# Eval("Value") %>'></asp:TextBox>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SSintomasVE" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,seguimiento_neonato_items.valor AS value 
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=166 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td><b>Senos</b></td>
            <td colspan="3">
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
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_neonato_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_neonato_items.valor) AS value ,seguimiento_neonato_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=167 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td><b>Abdomen</b></td>
            <td colspan="3">
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
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_neonato_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_neonato_items.valor) AS value ,seguimiento_neonato_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=168 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td><b>Miembros inferiores</b></td>
            <td colspan="3">
                <asp:Repeater runat="server" ID="RMInferiores" DataSourceID="SMInferiores">
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
                <asp:SqlDataSource ID="SMInferiores" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_neonato_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_neonato_items.valor) AS value ,seguimiento_neonato_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=169 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Valoración del recién nacido</td>
        </tr>
        <tr>
            <td>Peso al nacer</td>
            <td class="nw"><asp:TextBox runat="server" ID="TPeso" CssClass="entero"></asp:TextBox> gramos</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="4">Patologías asociadas al ingreso</td>
        </tr>
        <tr>
            <td colspan="4">
                <uc6:CIE10 runat="server" ID="CIE10" />
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Repeater runat="server" ID="RValoracionRN" DataSourceID="SValoracionRN">
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
                <asp:SqlDataSource ID="SValoracionRN" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_neonato_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_neonato_items.valor) AS value ,seguimiento_neonato_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=170 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:GridView ID="GAntecedentes" runat="server" AutoGenerateColumns="False" DataSourceID="SAntecedentes" EmptyDataText="No se encontraron " 
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
                <asp:SqlDataSource ID="SAntecedentes" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,seguimiento_neonato_items.valor AS value 
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=171 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Repeater runat="server" ID="RPrevencion" DataSourceID="SPrevencion">
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
                <asp:SqlDataSource ID="SPrevencion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT varios.id,varios.nombre,varios.descripcion,IF(seguimiento_neonato_items.valor IS NULL AND @seguimiento!=0,0, seguimiento_neonato_items.valor) AS value ,seguimiento_neonato_items.valor2
                            FROM varios 
                            LEFT JOIN seguimiento_neonato_items ON (seguimiento_neonato_items.seguimiento=@seguimiento AND seguimiento_neonato_items.tipo=varios.id)
                            WHERE varios.tipo=172 AND szReservado IS NULL">
                        <SelectParameters>
                            <asp:Parameter Name="seguimiento" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="4" class="celdaTitulo">Interconsultas<asp:RequiredFieldValidator runat="server" ID="R" Display="Dynamic" SetFocusOnError="true" ControlToValidate="TInterconsultas" ErrorMessage="Por favor ingrese unas interconsultas">*</asp:RequiredFieldValidator></td>
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