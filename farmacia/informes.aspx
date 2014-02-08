<%@ Page Title="Informes" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informes.aspx.cs" Inherits="farmacia_informes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link rel="Stylesheet" type="text/css" href="../css/jquery.multiselect.css" />
<script type="text/javascript" src="<%=ResolveUrl("~/")%>js/jquery.multiselect.min.js"></script>
<style type="text/css">.GridHeader th {width: auto;} .anchomax { width: 150px; }</style>
<script type="text/javascript">
    $(function() {
        $("#<%= TTercero.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservices/servicios.asmx/GetTercero",
                    data: "{ 'q': '" + request.term + "', tipo: 2 }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            item.label = item.value;
                            return item;
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            autoFocus: true,
            minLength: 3,
            select: function(event, ui) {

                $("#<%= TTerceroID.ClientID %>").val(ui.item.item);
                $("#<%= TTercero.ClientID %>").val(ui.item.value);
                return false;
            }
        }).change(function() {
            if($(this).val()=="")
                $("#<%= TTerceroID.ClientID %>").val("");
        });
        $("#<%= TPaciente.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: '../webservices/servicios.asmx/GetPacienteI',
                    data: "{ 'q': '" + request.term + "', 'e': '<%= ViewState["entidades"].ToString() %>' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            autoFocus: true,
            search: function() {
                $("#<%= TPacienteID.ClientID %>").val("");
            },
            select: function(event, ui) {
                $("#<%= TPacienteID.ClientID %>").val(ui.item.value);
                $("#<%= TPaciente.ClientID %>").val(ui.item.label);
                return false;
            }
        }).change(function() { 
            if($(this).val().length==0)
                $("#<%= TPacienteID.ClientID %>").val("");
        });
        $("#<%= DVer.ClientID %>").multiselect({
            noneSelectedText: "(Ninguno)",
            checkAllText: "Todos",
            uncheckAllText: "Ninguno",
            selectedText: "# seleccionados"
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Ver</td>
            <td>Desde</td>
            <td>Hasta</td>
            <td>Proveedor</td>
            <td>Producto</td>
            <td>Paciente</td>
            <td>Grupo</td>
            <td><asp:CheckBox runat="server" ID="CAlmacen" Text="Ver almacén" CssClass="hide" /></td>
        </tr>
        <tr>
            <td>
                <asp:ListBox runat="server" ID="DVer" SelectionMode="Multiple" Height="20px">
                    <asp:ListItem Text="Orden de compra" Value="2" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Entradas" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Requisición" Value="3"></asp:ListItem>
                    <asp:ListItem Text="Devolución" Value="4"></asp:ListItem>
                </asp:ListBox>
            <td>
                <asp:TextBox ID="TDesde" runat="server" CssClass="fecha" Text=""></asp:TextBox>
                <asp:RangeValidator ID="RangeValidator2" runat="server" Type="Date" ErrorMessage="Por favor ingrese una fecha valida." Text="*" MinimumValue="01/01/1900" MaximumValue="01/01/3000" SetFocusOnError="True" Display="Dynamic" ControlToValidate="TDesde"></asp:RangeValidator>
            </td>
            <td>
                <asp:TextBox ID="THasta" runat="server" CssClass="fecha" Text=""></asp:TextBox>
                <asp:RangeValidator ID="RangeValidator1" runat="server" 
                    ControlToValidate="THasta" Display="Dynamic" 
                    ErrorMessage="Por favor ingrese una fecha valida." MaximumValue="01/01/3000" 
                    MinimumValue="01/01/1900" SetFocusOnError="True" Text="*" Type="Date"></asp:RangeValidator>
            </td>
            <td>
                <asp:TextBox runat="server" ID="TTercero"></asp:TextBox><asp:TextBox runat="server" ID="TTerceroID" CssClass="hide"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox runat="server" ID="TNombre"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox runat="server" ID="TPaciente"></asp:TextBox><asp:TextBox runat="server" ID="TPacienteID" CssClass="hide"></asp:TextBox>
            </td>
            <td><asp:DropDownList ID="DGrupo" runat="server" AppendDataBoundItems="true" CssClass="anchomax" 
                    DataSourceID="SGrupo" DataTextField="nombre" DataValueField="id">
                    <asp:ListItem Text="(Todos)" Value="-1"></asp:ListItem>
                    <asp:ListItem Text="(Ninguno)" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="SGrupo" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id, nombre FROM varios WHERE tipo=35 AND estado IS NULL ORDER BY nombre">
                </asp:SqlDataSource>
                </td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Actualizar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    <br />
    <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" Visible="false"
        AutoGenerateColumns="False" EmptyDataText="No se encontraron productos" 
        AllowSorting="True" ShowFooter="true"
        DataKeyNames="consulta,id" onrowdatabound="GResultados_RowDataBound" >
        <RowStyle CssClass="GridRow"></RowStyle>
        <FooterStyle CssClass="GridFooter"></FooterStyle>
        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField HeaderText="Tipo" DataField="consulta" SortExpression="consulta" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Número" DataField="id" SortExpression="id" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Fecha" DataField="fecha" SortExpression="fecha" DataFormatString="{0:d}" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Proveedor" DataField="nombre" SortExpression="nombre" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Paciente" DataField="paciente" SortExpression="paciente" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Productos" DataField="producto" SortExpression="producto" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Cantidad" DataField="total" SortExpression="total" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
        </Columns>
    </asp:GridView>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="
                    (SELECT 1 AS consulta, entrada{0}.id,entrada{0}.fecha,tercero.nombre AS nombre
                            ,medicamentos.nombre AS producto, -entrada_items{0}.cantidad AS total,NULL AS paciente
                            FROM entrada{0}
                            LEFT JOIN tercero ON (tercero.id=entrada{0}.tercero)
                            LEFT JOIN entrada_items{0} ON (entrada{0}.id=entrada_items{0}.entrada)
                            LEFT JOIN medicamentos ON (medicamentos.id=entrada_items{0}.producto)
                        WHERE 
                        1 IN (@consultas)
                        AND @paciente=0
                        AND (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=entrada{0}.fecha)
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=entrada{0}.fecha)
                        AND (@tercero=0 OR entrada{0}.tercero=@tercero)
                        AND (@grupo=-1 OR medicamentos.grupo=@grupo OR (@grupo=0 AND producto IS NULL))
                        AND (@nombre='_' OR medicamentos.codigo LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.nombre LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.forma LIKE CONCAT('%', @nombre, '%'))
                        ORDER BY id
                   ) UNION ALL (
                        SELECT 3 AS consulta, salida{0}.id,salida{0}.fecha,NULL AS nombre
                            ,medicamentos.nombre AS producto, salida_items{0}.cantidad AS total,salida{0}.paciente
                            FROM salida{0}
                            LEFT JOIN salida_items{0} ON (salida{0}.id=salida_items{0}.salida)
                            LEFT JOIN medicamentos ON (medicamentos.id=salida_items{0}.producto)
                        WHERE 
                        3 IN (@consultas)
                        AND (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=salida{0}.fecha)
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=salida{0}.fecha)
                        AND (@paciente=0 OR salida{0}.paciente=@paciente)
                        AND (@grupo=-1 OR medicamentos.grupo=@grupo OR (@grupo=0 AND producto IS NULL))
                        AND (@nombre='_' OR medicamentos.codigo LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.nombre LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.forma LIKE CONCAT('%', @nombre, '%'))
                        ORDER BY id
                   ) UNION ALL (
                        SELECT 2 AS consulta,orden_compra{0}.id,orden_compra{0}.fecha,tercero.nombre AS nombre
                            ,medicamentos.nombre AS producto, orden_compra_items{0}.cantidad AS total,orden_compra{0}.paciente
                            FROM orden_compra{0}
                            LEFT JOIN tercero ON (tercero.id=orden_compra{0}.tercero)
                            LEFT JOIN orden_compra_items{0} ON (orden_compra{0}.id=orden_compra_items{0}.orden_compra)
                            LEFT JOIN medicamentos ON (medicamentos.id=orden_compra_items{0}.producto)
                        WHERE 
                        2 IN (@consultas)
                        AND (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=orden_compra{0}.fecha)
                        AND orden_compra{0}.estado IS NULL
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=orden_compra{0}.fecha)
                        AND (@tercero=0 OR orden_compra{0}.tercero=@tercero)
                        AND (@paciente=0 OR orden_compra{0}.paciente=@paciente)
                        AND (@grupo=-1 OR medicamentos.grupo=@grupo OR (@grupo=0 AND producto IS NULL))
                        AND (@nombre='_' OR medicamentos.codigo LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.nombre LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.forma LIKE CONCAT('%', @nombre, '%'))
                        ORDER BY id
                   ) UNION ALL (
                        SELECT 4 AS consulta,devolucion{0}.id,devolucion{0}.fecha,NULL AS nombre
                            ,medicamentos.nombre AS producto, -devolucion_items{0}.cantidad AS total,devolucion{0}.paciente
                            FROM devolucion{0}
                            LEFT JOIN devolucion_items{0} ON (devolucion{0}.id=devolucion_items{0}.devolucion)
                            LEFT JOIN medicamentos ON (medicamentos.id=devolucion_items{0}.producto)
                        WHERE 
                        4 IN (@consultas)
                        AND (@desde=' ' OR STR_TO_DATE(@desde, '%d/%m/%Y')<=devolucion{0}.fecha)
                        AND devolucion{0}.estado IS NULL
                        AND (@hasta=' ' OR STR_TO_DATE(@hasta, '%d/%m/%Y')>=devolucion{0}.fecha)
                        AND (@paciente=0 OR devolucion{0}.paciente=@paciente)
                        AND (@grupo=-1 OR medicamentos.grupo=@grupo OR (@grupo=0 AND producto IS NULL))
                        AND (@nombre='_' OR medicamentos.codigo LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.nombre LIKE CONCAT('%', @nombre, '%')
                            OR medicamentos.forma LIKE CONCAT('%', @nombre, '%'))
                        ORDER BY id
                   ) ORDER BY fecha
                        ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TDesde" PropertyName="Text" Name="desde" DefaultValue=" " />
                    <asp:ControlParameter ControlID="THasta" PropertyName="Text" Name="hasta" DefaultValue=" " />
                    <asp:ControlParameter ControlID="TTerceroID" PropertyName="Text" Name="tercero" DefaultValue="0" />
                    <asp:ControlParameter ControlID="TNombre" PropertyName="Text" Name="nombre" DefaultValue="_" />
                    <asp:ControlParameter ControlID="DGrupo" PropertyName="SelectedValue" Name="grupo" />
                    <asp:ControlParameter ControlID="TPacienteID" PropertyName="Text" Name="paciente" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
    </asp:Panel>
</asp:Content>

