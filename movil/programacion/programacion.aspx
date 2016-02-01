<%@ Page Title="Programación" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="programacion.aspx.cs" Inherits="programacion_programacion" %>
<%@ Register Src="~/usercontrol/paciente.ascx" TagName="Paciente" TagPrefix="UC" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="c" Runat="Server">
    <UC:Paciente runat="server" ID="UP" />
    
    <asp:DropDownList ID="DProgramaciones" runat="server" Visible="false" 
                        AppendDataBoundItems="true" AutoPostBack="true" DataSourceID="SProgramaciones" 
                        DataTextField="nombre" DataValueField="id" >
                        <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SProgramaciones" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT programacion.actId AS id,medicamentos.nombre AS nombre 
                        FROM programacion 
                        LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId) 
                        WHERE programacion.pacId=@paciente {0} 
                        GROUP BY programacion.actId,medicamentos.nombre">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="UP" Name="paciente" PropertyName="IdPaciente" />
                        </SelectParameters>
                    </asp:SqlDataSource>
    <br />
    <asp:Repeater runat="server" ID="RR" DataSourceID="SProgramacion">
        <HeaderTemplate><ul data-role="listview" id="rr"></HeaderTemplate>
        <ItemTemplate>
            <li>
                <h2><%# Eval("perNombre") %></h2>
                <h2 class="wrap red"><%# Eval("novedad") %> <%# Eval("prgActivo") %></h2>
                <p class="wrap"><b><%# Eval("actividad") %></b></p>
                <span class="ui-li-count"><%# Eval("prgNumSesion") %></span>
                <p><%# Eval("prgFechaProg", "{0:d}") %><br />
                    <%# Eval("autorizacion") %>
                </p>
                <p class="wrap"><%# Eval("prgObservaciones") %></p>
            </li>
        </ItemTemplate>
        <FooterTemplate></ul></FooterTemplate>
    </asp:Repeater>

    <asp:SqlDataSource ID="SProgramacion" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT prgFechaProg,perNombre,prgNumSesion
                    ,medicamentos.nombre AS actividad
                    ,IF(prgActivo=1, '', 'Inactivo') AS prgActivo
                    ,CONCAT(programacion.autNumero,'[',IFNULL(autorizacion_detalle.autNumSesiones,0), ']') AS autorizacion
                    ,programacion.prgObservaciones
                    ,GROUP_CONCAT(
                        CASE programacion_novedad.novTipo WHEN 1 THEN 'Cancelación Programación' WHEN 2 THEN 'Reasignación' WHEN 3 THEN 'Cambio en num. sesiones' WHEN 4 THEN 'Otro' WHEN 5 THEN 'Paciente desprotegido' WHEN 6 THEN 'Cambio Servicio' ELSE NULL END
                    ) AS novedad
                    FROM programacion 
                    LEFT JOIN recurso_humano ON (recurso_humano.perId=programacion.perId) 
                    LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId) 
                    LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=programacion.autNumero AND autorizacion_detalle.actId=programacion.actId)
                    LEFT JOIN programacion_novedad ON (programacion_novedad.prgId=programacion.prgId)
                    WHERE pacId=@paciente AND (@actividad=0 OR programacion.actId=@actividad) {0}
                    GROUP BY programacion.prgId
                    ORDER BY prgFechaProg DESC LIMIT 20"
                    DeleteCommand="DELETE FROM programacion WHERE prgId=@prgId"
                    >
            <SelectParameters>
                <asp:ControlParameter ControlID="UP" Name="paciente" PropertyName="IdPaciente" />
                <asp:ControlParameter ControlID="DProgramaciones" PropertyName="SelectedValue" Name="actividad" />
            </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="m" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="s" Runat="Server">
</asp:Content>