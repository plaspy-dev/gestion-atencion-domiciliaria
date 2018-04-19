<%@ Page Title="Informe MIPRES" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informemipres.aspx.cs" Inherits="paciente_informemipres" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>
                Desde<asp:RequiredFieldValidator ControlToValidate="TDesde" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="TDesde" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                </td>
            <td>
                Hasta<asp:RequiredFieldValidator ControlToValidate="THasta" ErrorMessage="Por favor ingrese una fecha." ID="RequiredFieldValidator1" runat="server" Display="Dynamic" >*</asp:RequiredFieldValidator>
                <asp:RangeValidator ControlToValidate="THasta" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator1" Display="Dynamic" Type="Date">*</asp:RangeValidator></td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td><asp:TextBox runat="server" ID="TDesde" CssClass="fecha" ></asp:TextBox></td>
            <td><asp:TextBox runat="server" ID="THasta" CssClass="fecha"></asp:TextBox></td>
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
                DataSourceID="SResultados" DataKeyNames="id" >
            <Columns>
                <asp:HyperLinkField DataNavigateUrlFields="id,pacId" SortExpression="numero" DataTextField="numero" HeaderText="N° DE PRESCRIPCION" Target="_blank" DataNavigateUrlFormatString="~/paciente/mipres.aspx?pid={1}&ampid={0}" />
                <asp:BoundField DataField="prescripcion" SortExpression="prescripcion" HeaderText="FECHA DE PRESCRIPCION" DataFormatString="{0:d}" ItemStyle-CssClass="r" />
                <asp:BoundField DataField="pacDocumento" SortExpression="pacDocumento" HeaderText="ID PACIENTE" />
                <asp:BoundField DataField="servicios" SortExpression="servicios" HeaderText="SERVICIO, MEDICAMENTO, TECNOLOGIA O NUTRICION FORMULADA" />
                <asp:BoundField DataField="elaboradopor" SortExpression="elaboradopor" HeaderText="MÉDICO QUE REALIZA LA JUNTA" />
                <asp:BoundField DataField="id" SortExpression="id" HeaderText="N° ACTA" />
                <asp:BoundField DataField="fecha" SortExpression="fecha" HeaderText="FECHA DE LA JUNTA" DataFormatString="{0:d}" ItemStyle-CssClass="r" />
            </Columns>
            <RowStyle CssClass="GridRow"></RowStyle>
            <FooterStyle CssClass="GridFooter"></FooterStyle>
            <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
            <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
            <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
            <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
        </asp:GridView>
        <asp:SqlDataSource ID="SResultados" runat="server" 
            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
            SelectCommand="SELECT mipres.id,mipres.prescripcion,mipres.numero,mipres.fecha
,paciente.pacDocumento
,paciente.pacId
,recurso_humano.perNombre elaboradopor
,GROUP_CONCAT(servicios.nombre) servicios
FROM mipres
LEFT JOIN paciente ON (paciente.pacId=mipres.paciente)
LEFT JOIN recurso_humano ON (recurso_humano.perId=mipres.elaboradopor)
LEFT JOIN varios servicios ON (FIND_IN_SET(servicios.id,mipres.servicios)!=0)
                            WHERE 
                            DATE(mipres.fecha) BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y')
                            GROUP BY mipres.id
                            ORDER BY fecha
                            ">
            <SelectParameters>
                <asp:ControlParameter ControlID="TDesde" Name="desde" PropertyName="Text" />
                <asp:ControlParameter ControlID="THasta" Name="hasta" PropertyName="Text" />
            </SelectParameters>
        </asp:SqlDataSource>
        <div style="text-align: right;">
            <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>

