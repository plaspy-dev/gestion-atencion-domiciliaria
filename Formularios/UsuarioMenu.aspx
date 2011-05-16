<%@ Page Title="Asignación de Menús" Language="vb" AutoEventWireup="false" MasterPageFile="~/Princ.Master" CodeBehind="UsuarioMenu.aspx.vb" Inherits="ML.UsuarioMenu" %>
<%@ Register src="../Controles/DropDownListU.ascx" tagname="DropDownListU" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" runat="server">
<div style="text-align:center">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        <asp:Panel runat="server" ID="pnlCopiar" style="text-align: left" Visible="false">
        Copiar permisos de otro usuario:
            <uc1:DropDownListU ID="ddlCopia" runat="server" AutoPostBack="true"/>
        
        </asp:Panel>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
    DataKeyNames="idUsuario,IdMenu" AllowSorting="true">
                <Columns>
                    <asp:TemplateField HeaderText="Usuario" SortExpression="IdUsuario">
                        <ItemTemplate>
                            <%#Eval("idUsuario")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Menu" SortExpression="Menu">
                        <ItemTemplate>
                            <div runat="server" id="dvDesc"><%#Eval("Menu.DescMenu")%></div> 
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CheckBoxField DataField="Asignado" HeaderText="Ver" Visible="false"/>
                    <asp:CheckBoxField DataField="Inserta" HeaderText="Inserta"  Visible="false"/>
                    <asp:CheckBoxField DataField="Modifica" HeaderText="Modifica"  Visible="false"/>
                    <asp:CheckBoxField DataField="Elimina" HeaderText="Elimina"  Visible="false"/>
                    <asp:CommandField CancelText="Cancelar" EditText="Editar" ShowEditButton="True" UpdateText="Guardar"  Visible="false"/>
                    <asp:TemplateField HeaderText="Asignar">
                    <HeaderTemplate>
                    <ml:CheckBox ID="chkHA" runat="server"/>Ver
                    </HeaderTemplate>
                    <ItemTemplate>
                    <ml:CheckBox ID="chkA" runat="server" Checked='<%#Bind("Asignado") %>' />
                    </ItemTemplate>                    
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Inserta">
                    <HeaderTemplate>
                    <ml:CheckBox ID="chkHI" runat="server"/>Inserta
                    </HeaderTemplate>
                    <ItemTemplate>
                    <ml:CheckBox ID="chkI" runat="server" Checked='<%#Bind("Inserta") %>' />
                    </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Modifica">                    
                    <HeaderTemplate>
                    <ml:CheckBox ID="chkHM" runat="server"/>Modifica
                    </HeaderTemplate>
                    <ItemTemplate>
                    <ml:CheckBox ID="chkM" runat="server" Checked='<%#Bind("Modifica") %>' />
                    </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Elimina">
                    <HeaderTemplate>
                    <ml:CheckBox ID="chkHE" runat="server"/>Elimina
                    </HeaderTemplate>
                    <ItemTemplate>
                    <ml:CheckBox ID="chkE" runat="server" Checked='<%#Bind("Elimina") %>' />
                    </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>

        </ContentTemplate>
    </asp:UpdatePanel>
    </div>
    <script type="text/javascript">
        function valChk(as, ins, mo, el) {
            if (!as) {
                getEl(ins).checked = false;
                getEl(mo).checked = false;
                getEl(el).checked = false;
            }
            var s="";

        }
        function selAll(str, check) {
            var items = document.getElementsByTagName("input");
            for (var i = 0; i < items.length; i++) {
                if (items[i].id.endsWith(str)) {
                    items[i].checked = check;
                }
            }
        }
    </script>
    </asp:Content>
