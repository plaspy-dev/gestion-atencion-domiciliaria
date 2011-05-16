<%@ Page Title="Megas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="ParPHDMegas.aspx.vb" Inherits="ML.ParPHDMegas" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<div >
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

<br />
        <asp:FormView ID="fvwInsertar" runat="server" Visible="False"
            DataSourceID="EntityDataSource1" GridLines="Both" Width="100%"
            DataKeyNames="megId">
            <InsertItemTemplate>
                <asp:Label ID="Label1" runat="server" Text="Id:"></asp:Label>                
                <ml:TextBox ID="megIdTextBox" runat="server" Text='<%# Bind("megId") %>' TipoTextBox="Entero" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="megIdTextBox" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                <br />
                <asp:Label ID="Label2" runat="server" Text="CodigoSUIS:"></asp:Label>                
                
                <ml:TextBox ID="megCodigoSUISTextBox" runat="server" 
                    Text='<%# Bind("megCodigoSUIS") %>' TipoTextBox="Entero" />
                <br />
                <asp:Label ID="Label3" runat="server" Text="Documento:"></asp:Label>                
                
                <ml:TextBox ID="megDocumentoTextBox" runat="server" 
                    Text='<%# Bind("megDocumento") %>' TipoTextBox="Entero" />
                <br />
                <asp:Label ID="Label4" runat="server" Text="Nombre:"></asp:Label>                
                <asp:TextBox ID="megNombreTextBox" runat="server" 
                    Text='<%# Bind("megNombre") %>' />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="megNombreTextBox" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                <br />
                <asp:Label ID="Label5" runat="server" Text="Correo-E:"></asp:Label>                
                
                <asp:TextBox ID="megCorreoETextBox" runat="server" 
                    Text='<%# Bind("megCorreoE") %>' />
                <br />
                <asp:Label ID="Label6" runat="server" Text="Dirección:"></asp:Label>                
                
                <asp:TextBox ID="megDireccionTextBox" runat="server" 
                    Text='<%# Bind("megDireccion") %>' />
                <br />
                <asp:Label ID="Label7" runat="server" Text="Teléfonos Consultorio:"></asp:Label>                
                
                <asp:TextBox ID="megTelefonosConsultorioTextBox" runat="server" 
                    Text='<%# Bind("megTelefonosConsultorio") %>' />
                <br />
                <asp:Label ID="Label8" runat="server" Text="Celular:"></asp:Label>                
                
                <asp:TextBox ID="megCelularTextBox" runat="server" 
                    Text='<%# Bind("megCelular") %>' />
                <br />
                <asp:Label ID="Label9" runat="server" Text="Horario Atención:"></asp:Label>                
                
                <asp:TextBox ID="megHorarioAtencionTextBox" runat="server"  TextMode="MultiLine"
                    Text='<%# Bind("megHorarioAtencion") %>' />
                <br />
                <br />
                <asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" 
                    CausesValidation="True" Text="Guardar"></asp:LinkButton>
                &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CommandName="Cancel" 
                    CausesValidation="False" Text="Cancelar"></asp:LinkButton>
            </InsertItemTemplate>
            <ItemTemplate>
                <br />
            </ItemTemplate>
        </asp:FormView>
        <asp:GridView ID="grvSel" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="megId" 
            DataSourceID="EntityDataSource1">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" DeleteText="Eliminar" EditText="Editar" CancelText="Cancelar"  UpdateText="Guardar"/>
                <asp:BoundField DataField="megId" HeaderText="Id" ReadOnly="True" 
                    SortExpression="megId"/>
                <asp:BoundField DataField="megCodigoSUIS" HeaderText="CodigoSUIS" 
                    SortExpression="megCodigoSUIS" />
                <asp:BoundField DataField="megDocumento" HeaderText="Documento" 
                    SortExpression="megDocumento" />
                <asp:BoundField DataField="megNombre" HeaderText="Nombre" 
                    SortExpression="megNombre" />
                <asp:BoundField DataField="megCorreoE" HeaderText="Correo-E" 
                    SortExpression="megCorreoE" />
                <asp:BoundField DataField="megDireccion" HeaderText="Dirección" 
                    SortExpression="megDireccion" />
                <asp:BoundField DataField="megTelefonosConsultorio" 
                    HeaderText="Teléfonos Consultorio" SortExpression="megTelefonosConsultorio" />
                <asp:BoundField DataField="megCelular" HeaderText="Celular" 
                    SortExpression="megCelular" />
                <asp:BoundField DataField="megHorarioAtencion" HeaderText="Horario Atención" 
                    SortExpression="megHorarioAtencion" />
            </Columns>
        </asp:GridView>
        <asp:EntityDataSource ID="EntityDataSource1" runat="server" 
            ConnectionString="name=ParametrizacionContainer" 
            DefaultContainerName="ParametrizacionContainer" EnableDelete="True" 
            EnableInsert="True" EnableUpdate="True" EntitySetName="phdMegas">
        </asp:EntityDataSource>
                        </ContentTemplate>
    </asp:UpdatePanel>

</div>
</asp:Content>
