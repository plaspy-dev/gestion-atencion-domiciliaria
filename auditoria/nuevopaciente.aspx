<%@ Page Title="Pacientes nuevos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="nuevopaciente.aspx.cs" Inherits="auditoria_nuevopaciente" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    addFunctionToStart(function() {
        $('#<%= TDesde.ClientID %>').datepicker({
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            dateFormat: 'mm/yy',
            onClose: function(dateText, inst) {
                var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                $("#<%= TMes.ClientID %>").val(parseInt(month, 10)+1);
                $("#<%= TAno.ClientID %>").val(year);
                $(this).datepicker('setDate', new Date(year, month, 1));
            }
        });
    });
</script>
<style type="text/css">
    .ancho { min-width: 400px; }
    .ui-datepicker-calendar {display: none;}
    .ui-datepicker-close {display: none;}
    .fechaex 
{
    width: 100px;
    text-align: right;
    background: white url('../imgs/cal.gif') left center no-repeat;
}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Mes</td>
            <td>
                Entidad</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:TextBox runat="server" ID="TDesde" CssClass="fechaex" ></asp:TextBox>
                <asp:TextBox runat="server" ID="TMes" CssClass="hide"></asp:TextBox>
                <asp:TextBox runat="server" ID="TAno" CssClass="hide"></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="TMes" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
            </td>
            <td>
                <asp:DropDownList ID="DAsegurador" runat="server" 
                                DataSourceID="SAsegurador" DataTextField="nombre" 
                                DataValueField="id" AppendDataBoundItems="true">
                                <asp:ListItem Text="(Todas)" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                <asp:SqlDataSource ID="SAsegurador" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:connBD %>" 
                    SelectCommand="SELECT entId id,entNombre nombre FROM dbo.admEntidad WHERE entEPS=1 ORDER BY 2">
                </asp:SqlDataSource></td>
            <td>
                <asp:Button ID="BBuscar" runat="server" Text="Buscar" onclick="BBuscar_Click" />
            </td>
        </tr>
        </table>
    </asp:Panel>
    <br />
        <div id="dImprimir">
        <asp:GridView ID="GResultados" runat="server" 
            AutoGenerateColumns="False" EmptyDataText="No se encontraron pacientes" 
            AllowPaging="True" PageSize="50" AllowSorting="True" 
                DataSourceID="SResultados" onrowdatabound="GResultados_RowDataBound" >
            <Columns>
                <asp:BoundField DataField="pacFecIngPrograma" SortExpression="pacFecIngPrograma" HeaderText="Fecha ingreso" DataFormatString="{0:d}" />
                <asp:HyperLinkField DataTextField="pacDocumento" HeaderText="Paciente" 
                    DataNavigateUrlFields="pacId" 
                    DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" SortExpression="pacDocumento" >
                    <ItemStyle Wrap="False" HorizontalAlign="Right" />
                </asp:HyperLinkField>
                <asp:HyperLinkField DataTextField="pacNombres" HeaderText="Paciente" 
                    DataNavigateUrlFields="pacId" 
                    DataNavigateUrlFormatString="~/paciente/paciente.aspx?pid={0}" SortExpression="pacNombres" >
                    <ItemStyle Wrap="False" />
                </asp:HyperLinkField>
                <asp:BoundField HeaderText="Edad" DataField="pacFechaNac" SortExpression="pacFechaNac" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" />
                <asp:BoundField HeaderText="Diagnóstico" DataField="cied10" SortExpression="cied10" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="Asegurador" DataField="entNombre" SortExpression="entNombre" ItemStyle-Wrap="false" />
                <asp:BoundField HeaderText="Observaciones" DataField="pacObservaciones" SortExpression="pacObservaciones" HeaderStyle-CssClass="ancho" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:connBD %>" 
                SelectCommand="SELECT phdPaciente.pacId,phdPaciente.pacNombres,phdPaciente.pacFechaNac,phdPaciente.pacDocumento
                                ,ISNULL(phdPaciente.cieCodDx,'')+ ',' + ISNULL(phdPaciente.cieCodDx_1,'') + ','+ ISNULL(phdPaciente.cieCodDx_2,'') AS cied10
                                ,phdPaciente.pacFecIngPrograma
                                ,phdPaciente.pacObservaciones
                                ,admEntidad.entNombre
                                FROM phdPaciente
                                LEFT JOIN  admEntidad ON (admEntidad.entId=phdPaciente.entId)
                                WHERE 
                                DATEPART(month,phdPaciente.pacFecIngPrograma)=@mes
                                AND DATEPART(year,phdPaciente.pacFecIngPrograma)=@ano
                                AND (@entidad=0 OR phdPaciente.entId=@entidad)
                                ORDER BY phdPaciente.pacFecIngPrograma
                                ">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TMes" Name="mes" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TAno" Name="ano" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DAsegurador" Name="entidad" PropertyName="SelectedValue" />
                 </SelectParameters>
    </asp:SqlDataSource>        
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

