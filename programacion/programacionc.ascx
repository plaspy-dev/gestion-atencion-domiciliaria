<%@ Control Language="C#" AutoEventWireup="true" CodeFile="programacionc.ascx.cs" Inherits="phd_programacionc" %>
<script type="text/javascript">
    $(function() {
        function copyfecha(elemento) {
            $("#<%= TFechaFinal.ClientID %>").val($(elemento).val());
        }
        $("#<%= TFecha.ClientID %>").change(function() { copyfecha(this) }).datepicker({
            onClose: function(dateText, inst) {
                copyfecha(this);
            }
        });
        if ($("#<%= HId.ClientID %>").val() != "")
            $("#<%= CRecurrente.ClientID %>").hide().next().hide();

        $("#<%= CRecurrente.ClientID %>").change(function() {

            $("#repeticion").hide();
            $("#semana").hide();

            if ($(this).attr("checked")) {

                $("#recurrente").show();
                $("#recurrente1").show();
                $("#exepciones").show();

                if ($("#<%= RPeriodicidad.ClientID %>_0").attr("checked"))
                    $("#<%= RPeriodicidad.ClientID %>_0").change();
                if ($("#<%= RPeriodicidad.ClientID %>_1").attr("checked"))
                    $("#<%= RPeriodicidad.ClientID %>_1").change();
                if ($("#<%= RPeriodicidad.ClientID %>_2").attr("checked"))
                    $("#<%= RPeriodicidad.ClientID %>_2").change();
            } else {
                $("#recurrente").hide();
                $("#recurrente1").hide();
                $("#exepciones").hide();
            }
        }).change();
        $("#radio").buttonset();
        $("#<%= RPeriodicidad.ClientID %>_0").change(function() {

            $("#repeticion").hide();
            $("#semana").hide();
        });
        $("#<%= RPeriodicidad.ClientID %>_1").change(function() {

            $("#repeticion").show();
            $("#semana").hide();
        });
        $("#<%= RPeriodicidad.ClientID %>_2").change(function() {
            $("#repeticion").hide();
            $("#semana").show();
        });
        $("#dExepciones").accordion({
            autoHeight: false,
            collapsible: true
        });
        $("#dExepciones").accordion("activate", -1);
        $("#<%= DActividad.ClientID %>").change(function() {
            $('span[id^="dact"]').hide();
            $("#dact" + $(this).val()).show();
        }).change();
        $("#<%=DProfesional.ClientID %>").combobox();
        addDialog("#dParentProgramacion", "#dProgramacion");
        addDialog("#<%= PConfirmar.ClientID %>", "#dConfirmar");
    });
</script>
<div id="dParentProgramacion">
<asp:Panel runat="server" ID="PConfirmar" Visible="false">
    <div id="dConfirmar" title="Confirmación" style="display:none;">
        <table>
            <tr><td>Se va a realizar la siguiente programación.</td></tr>
            <tr><td><asp:Label runat="server" ID="LConfirmar"></asp:Label></td></tr>
            <tr><td>¿Desea Continuar?</td></tr>
            <tr><td align="right"><asp:Button CausesValidation="false" ID="BSi" runat="server" Text="Si" 
                    onclick="BSi_Click" />
            <asp:Button ID="BNo" runat="server" Text="No" CausesValidation="false" 
                    onclick="BNo_Click" /></td></tr>
        </table>
    </div>
</asp:Panel>
<div id="dProgramacion" title="Programación" style="display:none;">
<asp:HiddenField ID="HId" runat="server" />
<asp:HiddenField ID="HIdPaciente" runat="server" />
<asp:ValidationSummary ValidationGroup="CProgramacion" ID="ValidationSummary1" runat="server" />
<table>
    <tr>
        <td align="left">Autorización</td>
        <td align="left"><asp:DropDownList ID="DAutorizacion" runat="server" 
                                DataSourceID="SAutorizacion" DataTextField="autNumero" 
                                DataValueField="autNumero" AutoPostBack="true" 
                onselectedindexchanged="DAutorizacion_SelectedIndexChanged" 
                ondatabound="DAutorizacion_DataBound">
                                </asp:DropDownList><asp:RequiredFieldValidator ValidationGroup="CProgramacion" ControlToValidate="DAutorizacion" ErrorMessage="Por favor seleccione un autorización." ID="RequiredFieldValidator5" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:SqlDataSource ID="SAutorizacion" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT phdAutorizacion.autNumero
                                FROM phdAutorizacion
                                LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero)
                                LEFT JOIN phdActividad ON (phdActividad.actId=phdDetalleAutorizacion.actId)
								LEFT JOIN phdTipoActividad ON (phdActividad.tpaId = phdTipoActividad.tpaId)
                                WHERE 
                                phdAutorizacion.autActivo=1
                                AND phdAutorizacion.pacId=@paciente
                                AND GETDATE()<=ISNULL(autFechaVenc+30,autFecha+60)
                                AND phdTipoActividad.tpaTipoServicio=1 
                                AND
                                phdDetalleAutorizacion.autNumSesiones>(SELECT ISNULL(SUM(phdProgramacion.prgNumSesion),0) FROM phdProgramacion WHERE phdProgramacion.pacId=phdAutorizacion.pacId AND phdProgramacion.autNumero=phdAutorizacion.autNumero AND phdProgramacion.actId=phdDetalleAutorizacion.actId)
                                GROUP BY phdAutorizacion.autNumero">
			                <SelectParameters>
			                    <asp:ControlParameter ControlID="HIdPaciente" PropertyName="Value" Name="paciente" DefaultValue="0" />
			                </SelectParameters>
                </asp:SqlDataSource>
            </td>
    </tr>
    <tr>
        <td align="left">Actividad</td>
        <td align="left">
            <asp:DropDownList ID="DActividad" runat="server" 
                                DataSourceID="SActividad" DataTextField="nombre" 
                                DataValueField="id">
                                </asp:DropDownList>
                <asp:RequiredFieldValidator ValidationGroup="CProgramacion" ControlToValidate="DActividad" ErrorMessage="Por favor seleccione una actividad." ID="RequiredFieldValidator6" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:Repeater runat="server" ID="RActividad" DataSourceID="SActividad" >
                    <ItemTemplate>
                    <span id='dact<%# DataBinder.Eval(Container.DataItem, "id") %>' style="display:none;">                        
                        <asp:label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "realizadas") %>' ID="LRealizadas"></asp:label> de <asp:label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "autNumSesiones") %>' ID="LMaximo"></asp:label>
                    </span>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SActividad" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT phdDetalleAutorizacion.actId AS id,phdActividad.actDescripcion AS nombre
                        ,phdDetalleAutorizacion.autNumSesiones
                        ,(SELECT ISNULL(SUM(phdProgramacion.prgNumSesion),0) FROM phdProgramacion WHERE phdProgramacion.pacId=phdAutorizacion.pacId AND phdProgramacion.autNumero=phdAutorizacion.autNumero AND phdProgramacion.actId=phdDetalleAutorizacion.actId) AS realizadas
                        FROM phdAutorizacion
                        LEFT JOIN phdDetalleAutorizacion ON (phdDetalleAutorizacion.autNumero=phdAutorizacion.autNumero)
                        LEFT JOIN phdActividad ON (phdActividad.actId=phdDetalleAutorizacion.actId)
                        LEFT JOIN phdTipoActividad ON (phdActividad.tpaId = phdTipoActividad.tpaId) 
                        WHERE 
                        phdAutorizacion.pacId=@paciente
                        AND phdAutorizacion.autNumero=@autorizacion 
                        AND phdTipoActividad.tpaTipoServicio=1 
                        AND phdDetalleAutorizacion.autNumSesiones>(SELECT ISNULL(SUM(phdProgramacion.prgNumSesion),0) FROM phdProgramacion WHERE phdProgramacion.pacId=phdAutorizacion.pacId AND phdProgramacion.autNumero=phdAutorizacion.autNumero AND phdProgramacion.actId=phdDetalleAutorizacion.actId)
                        ORDER BY phdActividad.actDescripcion">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="HIdPaciente" PropertyName="Value" Name="paciente" DefaultValue="0" />
                            <asp:ControlParameter ControlID="DAutorizacion" PropertyName="SelectedValue" Name="autorizacion" DefaultValue="0" />
                        </SelectParameters>
                </asp:SqlDataSource>
                </td>
    </tr>
    <tr>
        <td align="left">Fecha</td>
        <td align="left"><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="CProgramacion" ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic">*</asp:RequiredFieldValidator>
        <asp:RangeValidator ValidationGroup="CProgramacion" ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RFecha" Display="Dynamic" Type="Date">*</asp:RangeValidator>
        <asp:CheckBox ID="CRecurrente" runat="server" Text="Recurrente" />
        </td>
    </tr>
    <tr id="recurrente">
        <td>Fecha final</td>
        <td align="left"><asp:TextBox runat="server" ID="TFechaFinal" CssClass="fecha"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="CProgramacion" ControlToValidate="TFechaFinal" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic">*</asp:RequiredFieldValidator>
        <asp:RangeValidator ValidationGroup="CProgramacion" ControlToValidate="TFechaFinal" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RFechaFinal" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
    </tr>
    <tr id="recurrente1">
        <td colspan="2" align="left"><div id="radio">
            <asp:RadioButtonList ID="RPeriodicidad" runat="server" RepeatDirection="Horizontal" >
                <asp:ListItem Selected="True" Value="1">Diario</asp:ListItem>
                <asp:ListItem Value="2">Mediante patrón de repetición</asp:ListItem>
                <asp:ListItem Value="3">Por día de la semana</asp:ListItem>
            </asp:RadioButtonList>
        </div>
        </td>
    </tr>
    <tr id="repeticion">
        <td>Cada</td>
        <td align="left"><asp:TextBox runat="server" ID="TDias" MaxLength="2" CssClass="entero" Width="24px"></asp:TextBox>&nbsp;Días</td>
    </tr>
    <tr id="semana">
        <td colspan="2" align="left">
        <asp:CheckBoxList ID="CSemana" runat="server" CssClass="Etiqueta" RepeatColumns="4">
            <asp:ListItem Value="0">Domingo</asp:ListItem>
            <asp:ListItem Value="1">Lunes</asp:ListItem>
            <asp:ListItem Value="2">Martes</asp:ListItem>
            <asp:ListItem Value="3">Miércoles</asp:ListItem>
            <asp:ListItem Value="4">Jueves</asp:ListItem>
            <asp:ListItem Value="5">Viernes</asp:ListItem>
            <asp:ListItem Value="6">Sábado</asp:ListItem>
        </asp:CheckBoxList>
        </td>
    </tr>
    <tr id="exepciones">
        <td colspan="2">
            <div id="dExepciones">
                <h3><a href="#">Exepciones</a></h3>
                <div>
                    <table>
                        <tr>
                            <td><asp:TextBox runat="server" ID="TExepcion1" CssClass="fecha"></asp:TextBox></td>
                            <td><asp:TextBox runat="server" ID="TExepcion2" CssClass="fecha"></asp:TextBox></td>
                            <td><asp:TextBox runat="server" ID="TExepcion5" CssClass="fecha"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td><asp:TextBox runat="server" ID="TExepcion3" CssClass="fecha"></asp:TextBox></td>
                            <td><asp:TextBox runat="server" ID="TExepcion4" CssClass="fecha"></asp:TextBox></td>
                            <td><asp:TextBox runat="server" ID="TExepcion6" CssClass="fecha"></asp:TextBox></td>
                        </tr>
                    </table>
                </div>
            </div>
        </td>
    </tr>
    <tr><td colspan="2" align="left"><hr /></td></tr>
    <tr>
        <td align="left">Profesional</td>
        <td align="left"><asp:DropDownList ID="DProfesional" runat="server" Width="200px" 
                                DataSourceID="SProfesional" DataTextField="nombre"
                                DataValueField="id">
                                <asp:ListItem Value="" Text=""></asp:ListItem>
                                </asp:DropDownList>
                <asp:RequiredFieldValidator ValidationGroup="CProgramacion" InitialValue="0" ControlToValidate="DProfesional" ErrorMessage="Por favor seleccione un profesional." ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:SqlDataSource ID="SProfesional" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="(SELECT '' AS id,'' AS nombre) UNION (SELECT perId id,perNombre nombre FROM dbo.admPersonalHS where eEstId=1 and (areaid=2 or carId in (8,11,25,27))) ORDER BY 2">
                </asp:SqlDataSource></td>
    </tr>
    <tr>
        <td align="left">Num Sesiones/Día</td>
        <td align="left"><asp:TextBox runat="server" Text="1" ID="TSesiones" CssClass="entero" MaxLength="2" Width="40px"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="CProgramacion" ControlToValidate="TSesiones" ErrorMessage="Por favor ingrese un número de sesiones." ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
        <asp:CompareValidator ValidationGroup="CProgramacion" ID="CompareValidator2" runat="server" ErrorMessage="el valor debe ser mayor a cero" ControlToValidate="TSesiones" Operator="GreaterThan" ValueToCompare="0" Type="Integer" >*</asp:CompareValidator></td>
    </tr>
    <tr>
        <td align="left">Observaciones</td>
        <td align="left"><asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" Width="200px"></asp:TextBox> 
        </td>
    </tr>
    <tr>
        <td></td>
        <td align="right"><asp:Button ValidationGroup="CProgramacion" ID="BAceptar" runat="server" Text="Aceptar" 
                onclick="BAceptar_Click" /><asp:Button ID="BCancelar" runat="server" 
                Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
        </td>
    </tr>
</table>  
</div></div>