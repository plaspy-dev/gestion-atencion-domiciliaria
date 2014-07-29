<%@ Page Title="Asistencia" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="asistencia.aspx.cs" Inherits="eventos_asistencia" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table>
        <tr>
            <td>Evento</td>
            <td>Fecha</td>
            <td></td>
        </tr>
        <tr>
            <td><asp:DropDownList ID="DEvento" runat="server" DataSourceID="SEvento" 
                        DataTextField="nombre" DataValueField="id" CssClass="anchomaxcombo"
                        AutoPostBack="True" onselectedindexchanged="DEvento_SelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SEvento" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                        SelectCommand="SELECT programacion_evento.id AS id
                                ,CONCAT(programacion_evento.nombre,'-',varios.nombre) AS nombre1
                                ,CAST(CONCAT(programacion_evento.nombre,' (', DATE_FORMAT(programacion_evento.inicio,'%d/%m/%Y'),'-',DATE_FORMAT(programacion_evento.fin,'%d/%m/%Y'), ')') AS CHAR) AS nombre
                                FROM programacion_evento 
                                LEFT JOIN varios ON (varios.id=programacion_evento.lugar)
                                WHERE inicio<=SYSDATE() AND DATE_ADD(fin,INTERVAL 60 DAY)>=SYSDATE() 
                                ORDER BY nombre,inicio,fin" >
                                <SelectParameters>
                                </SelectParameters>
                </asp:SqlDataSource></td>
                <td><asp:TextBox runat="server" ID="TFecha" CssClass="fecha"></asp:TextBox></td>
                <td><asp:Button runat="server" ID="BIr" Text="Ir" onclick="BIr_Click" /></td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:RangeValidator ControlToValidate="TFecha" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RFecha" Display="Dynamic" Type="Date"></asp:RangeValidator>
                <asp:RequiredFieldValidator ControlToValidate="TFecha" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:GridView ID="GResultados" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="id,perId" DataSourceID="SResultados">
                        <RowStyle CssClass="GridRow"></RowStyle>
                        <FooterStyle CssClass="GridFooter"></FooterStyle>
                        <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                        <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                        <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                        <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                        <SelectedRowStyle CssClass="selecteditem" />
                    <Columns>
                        <asp:BoundField DataField="idpersonal" SortExpression="idpersonal" HeaderText="idpersonal" ItemStyle-CssClass="hide" HeaderStyle-CssClass="hide" />
                        <asp:BoundField DataField="cargo" HeaderText="Cargo" SortExpression="cargo" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="personal" HeaderText="Funcionario" SortExpression="personal" ItemStyle-Wrap="false" />
                        <asp:TemplateField HeaderText="Ingreso" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TIngreso" CssClass="hora" Text='<%# Bind("ingreso") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Salida" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="TSalida" CssClass="hora" Text='<%# Bind("salida") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SResultados" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT personal_programacion.id AS id,personal_programacion.personal AS idpersonal
                                    ,recurso_humano.perNombres AS personal
                                    ,cargo.carDescripcion AS cargo 
                                    ,asistencia.ingreso,asistencia.salida
                                    ,recurso_humano.perId
                                    FROM personal_programacion 
                                    LEFT JOIN recurso_humano ON (recurso_humano.perId=personal_programacion.personal) 
                                    LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId) 
                                    LEFT JOIN asistencia ON (asistencia.personal=personal_programacion.personal AND asistencia.evento=personal_programacion.programacion AND asistencia.fecha=STR_TO_DATE(@fecha, '%d/%m/%Y'))
                                    WHERE personal_programacion.programacion=@programacion 
                                    ORDER BY cargo, personal"
                    >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="DEvento" Name="programacion" PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="TFecha" Name="fecha" PropertyName="Text" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="right">
                <asp:Button runat="server" Text="Aceptar" ID="BAceptar" 
                    onclick="BAceptar_Click" />
                <asp:Button runat="server" ID="BCancelar" Text="Cancelar" 
                    CausesValidation="false" onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
    <script type="text/javascript">
        $(function() {
            <asp:Literal runat="server" ID="LFecha"></asp:Literal>
        });
    </script>
</asp:Content>

