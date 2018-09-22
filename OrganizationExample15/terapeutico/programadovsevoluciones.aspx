<%@ Page Title="Programado sin evolución" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="terapeutico_programadovsevoluciones" Codebehind="programadovsevoluciones.aspx.cs" %>
<%@ Register src="~/paciente/pacienteSimple.ascx" tagname="PacienteSimple" tagprefix="uc5" %>
<%@ Register src="~/rh/funcionarioSimple.ascx" tagname="funcionario" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">    
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Inicio</td>
            <td>Fin</td>
            <td>Asegurador</td>
            <td>Paciente</td>
            <td>Funcionario</td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TInicio" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TInicio" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TInicio" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:TextBox runat="server" ID="TFin" CssClass="fecha"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TFin" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TFin" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator>
            </td>
            <td><asp:DropDownList ID="DAsegurador" runat="server"  CssClass="anchomaxcombo"
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todos)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM asegurador WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
                <uc5:PacienteSimple runat="server" ID="UCPaciente" />
            </td>
            <td>
                <uc1:funcionario runat="server" ID="UCFuncionario" />
            </td>
            <td>
                <asp:Button runat="server" ID="BBuscar" Text="Actualizar" OnClick="BBuscar_Click" />
            </td>
        </tr>
    </table>
        </asp:Panel>
    <br />
    <asp:UpdatePanel ID="PResultados" runat="server">
        <ContentTemplate>
            <asp:GridView ID="GResultados" runat="server" DataSourceID="SResultados" 
                AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones"
                AllowPaging="True" PageSize="50" AllowSorting="True">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField HeaderText="Fecha" DataField="prgFechaProg" SortExpression="prgFechaProg" ItemStyle-Wrap="false" DataFormatString="{0:d}"/>
                    <asp:BoundField HeaderText="Paciente" DataField="pacNombres" SortExpression="pacNombres" ItemStyle-Wrap="false"/>
                    <asp:BoundField HeaderText="Funcionario" DataField="perNombre" SortExpression="perNombre" ItemStyle-Wrap="false"/>
                    <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-Wrap="false"/>
                    <asp:BoundField HeaderText="Servicio" DataField="nombre" SortExpression="nombre" ItemStyle-Wrap="false"/>
                    <asp:BoundField HeaderText="Autorización" DataField="autNumero" SortExpression="autNumero" ItemStyle-Wrap="false"/>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT programacion.prgFechaProg,paciente.pacNombres,recurso_humano.perNombre,asegurador.entNombre
                            ,CONCAT(medicamentos.codigo, ' - ',medicamentos.nombre) AS nombre
                            ,programacion.autNumero
                            FROM programacion 
                            LEFT JOIN paciente ON (paciente.pacId=programacion.pacId)
                            LEFT JOIN recurso_humano ON (recurso_humano.perId=programacion.perId)
                            LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId)
                            LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                            WHERE prgFechaProg BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND (@paciente=0 OR programacion.pacId=@paciente)
                            AND (@personal=0 OR programacion.perId=@personal)
                            AND (@asegurador=0 OR paciente.entId=@asegurador)
                            AND (NOT EXISTS (SELECT 1 FROM evolucion_terapeutivo WHERE evolucion_terapeutivo.autorizacion=programacion.autNumero 
                                    AND evolucion_terapeutivo.tipo=programacion.actId
                                    AND DATE(evolucion_terapeutivo.fecha)=DATE(programacion.prgFechaProg) LIMIT 1
                                ) AND NOT EXISTS (SELECT 1 FROM valoracionat WHERE valoracionat.autorizacion=programacion.autNumero 
                                    AND valoracionat.tipo=programacion.actId
                                    AND DATE(valoracionat.inicio)=DATE(programacion.prgFechaProg) LIMIT 1
                                ))
                            ORDER BY programacion.prgFechaProg">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="DAsegurador" PropertyName="SelectedValue" Name="asegurador" />
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="UCFuncionario" Name="personal" PropertyName="IdFuncionario" DefaultValue="0" />
                     <asp:ControlParameter ControlID="UCPaciente$TPacienteID" Name="paciente" PropertyName="Text" DefaultValue="0" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>