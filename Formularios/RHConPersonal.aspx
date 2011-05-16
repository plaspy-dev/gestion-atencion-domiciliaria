<%@ Page Title="Personal OrganizationExample15" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="RHConPersonal.aspx.vb" Inherits="ML.RHConPersonal" %>
<%@ Register src="../Controles/Filtro.ascx" tagname="Filtro" tagprefix="uc1" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style1
        {
            width: 100%;
            border-style:none;
        }
        .style2
        {
            width: 60px;
            border-style:none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<span id="ctl00_cph_grvPer_ctl03_Label3" class="Etiqueta">Teléfono:</span>
    <uc1:Filtro ID="Filtro1" runat="server" tipo="ML.Datos.RRHH.Personal" Campos="perNombre,perActivo,carId" Titulos="Digite Nombre o Identificación,Mostrar Inactivos,Cargo" Referencias=",,Cargo" />

    
    <br />
    
    <asp:GridView ID="grvPer" runat="server" AutoGenerateColumns="False" 
        AllowPaging="True" PageSize="5" ShowHeader="False" DataKeyNames="perId">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                <table class="style1" border="1">
                <tr>
                    <td colspan="2">
                        <table  >
                            <tr>
                                <td class="style2">
                                    <asp:Image ID="Image2" runat="server" Height="40px" ImageUrl='<%#urlImg(eval("ftUrlImagen"))%>'
                                        Width="54px"  />
                                        <%----%>
                                </td>
                                <td>
                                    <asp:Label ID="lblNombre" runat="server" SkinID="EtiquetaSubT" 
                                        Text='<%# bind("perNombre") %>' width="400px"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table class="style1">
                            <tr>
                                <td>
                                    <asp:Label ID="Label6" runat="server" Text="Cargo:"></asp:Label></td>
                                <td>
                                    <asp:Label ID="Label5" runat="server" Text='<%#bind("carDescripcion")%>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label1" runat="server" Text="Documento:"></asp:Label>
                                </td>
                                <td width="100%">
                                    <asp:Label ID="lblDoc" runat="server" Text='<%#bind("perDocumento")%>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label3" runat="server" Text="Celular:"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblTel" runat="server" Text='<%#bind("perCelular")%>'></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table class="style1">
                            <tr>
                                <td>
                                    <asp:Label ID="Label2" runat="server" Text="Fecha de Ingreso:" ></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblFechaIng" runat="server" Text='<%#formatoFecha(Eval("perFechaIngreso"))%>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%#bind("perActivo")%>' Text="Activo?" />
                                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%#Not Eval("perActivo")%>' Text="Inactivo?"  />
                                </td>
                                <td>
                                    
                                    </td>
                            </tr>
                            <tr runat="server" visible='<%#Not Eval("perActivo")%>'>
                                <td>
                                    <asp:Label ID="Label7" runat="server" Text="Fecha de Retiro:" ></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label8" runat="server" Text='<%#iif(Eval("perFechaTermContrato").year=1,"",formatoFecha(Eval("perFechaTermContrato")))%>'></asp:Label>
                                </td>
                            </tr>
                            <tr runat="server" visible='<%#Not Eval("perActivo")%>'>
                                <td>
                                    <asp:Label ID="Label4" runat="server" Text="Motivo retiro:"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblDir" runat="server" Text='<%#bind("mteDescripcion")%>'></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowSelectButton="True" SelectText="Editar" HeaderText="Editar" />
            <asp:CommandField DeleteText="Eliminar" ShowDeleteButton="True" />
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblTotal" runat="server" SkinID="lblFormatoFecha"></asp:Label>

    
  <%--  <br />

    <asp:GridView ID="grvPer_1" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="perId">
        <Columns>
            <asp:CommandField ShowSelectButton="True" SelectText="Editar" HeaderText="Editar" />
            <asp:CommandField ShowDeleteButton="True" DeleteText="Eliminar" HeaderText="Eliminar" />
            <asp:BoundField DataField="perId" HeaderText="Id" SortExpression="perId" />
            <asp:BoundField DataField="perDocumento" HeaderText="Documento" 
                SortExpression="perDocumento" />
            <asp:BoundField DataField="perNombre" HeaderText="Nombre" 
                SortExpression="perNombre" />
            <asp:BoundField DataField="perFechaIngreso" HeaderText="FechaIngreso" 
                SortExpression="perFechaIngreso" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="carId" HeaderText="carId" SortExpression="carId" />
            <asp:BoundField DataField="perTelefono" HeaderText="perTelefono" 
                SortExpression="perTelefono" />
            <asp:BoundField DataField="perDireccion" HeaderText="Direccion" 
                SortExpression="perDireccion" />
            <asp:CheckBoxField DataField="perActivo" HeaderText="Activo" 
                SortExpression="perActivo" />
        </Columns>
    </asp:GridView>--%>

</asp:Content>
