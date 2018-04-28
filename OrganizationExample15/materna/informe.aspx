<%@ Page Title="MME Gestante" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="informe.aspx.cs" Inherits="materna_informe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <asp:Label runat="server" ID="LMessage"></asp:Label>
<asp:Panel runat="server" ID="PBuscar" DefaultButton="BBuscar">
    <table>
        <tr>
            <td>Desde</td>
            <td>Hasta</td>
            <td>Tipo</td>
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
            <td><asp:DropDownList runat="server" ID="DTipo">
                <asp:ListItem Text="Gestante" Value="1"></asp:ListItem>
                <asp:ListItem Text="Posparto" Value="2"></asp:ListItem>
                <asp:ListItem Text="NeoNato" Value="3"></asp:ListItem>
                </asp:DropDownList></td>
            <td>
                <asp:Button runat="server" ID="BBuscar" Text="Actualizar" OnClick="BBuscar_Click" />
            </td>
        </tr>
    </table>
</asp:Panel>
<br />
    <asp:UpdatePanel ID="PResultados" runat="server">
        <ContentTemplate>
            <asp:GridView ID="GGestante" Visible="false" runat="server" DataSourceID="SResultados" 
                AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones"
                AllowPaging="True" PageSize="50" AllowSorting="false">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField HeaderText="MEDICO" DataField="perNombre" SortExpression="perNombre"/>
                    <asp:HyperLinkField HeaderText="1. DATOS PERSONALES   1.1 FECHA ENCUESTA" DataTextField="fecha" SortExpression="fecha" DataNavigateUrlFields="id,paciente" Target="_blank" DataNavigateUrlFormatString="~/materna/seguimiento.aspx?pid={1}&emid={0}" />
                    <asp:BoundField HeaderText="1. DATOS PERSONALES   1.2 NOMBRES " DataField="nombres" SortExpression="nombres"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES   1.3 APELLIDOS" DataField="apellidos" SortExpression="apellidos"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES1.4 TIPO DE DOCUMENTO" DataField="tipodocumento" SortExpression="tipodocumento"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES    1.5 NO. IDENTIFICACION" DataField="pacDocumento" SortExpression="pacDocumento"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES 1.6 IPS PRIMARIA" DataField="ips" SortExpression="ips"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES    1.7 TIPO DE AFILIACION" DataField="tipoafiliacion" SortExpression="tipoafiliacion"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES 1.8 EDAD" DataField="years" SortExpression="years"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES 1.9 TELEFONOS" DataField="telefonos" SortExpression="telefonos"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES 1.10 DIRECCION DE RESIDENCIA" DataField="direccion" SortExpression="direccion"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES 1.11 NIVEL DE ESCOLARIDAD" DataField="escolaridad" SortExpression="escolaridad"/>
                    <asp:TemplateField HeaderText="2. M C Y E A  2.1 Adolescentes menores de 15 años"><ItemTemplate><asp:Label runat="server" ID="L21" Text='<%# GetData(Eval("id").ToString(), "2.1")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.2 Adolescentes entre 15 y 19 años con 2 o mas gestaciones"><ItemTemplate><asp:Label runat="server" ID="L22" Text='<%# GetData(Eval("id").ToString(), "2.2")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.3 Mujeres Mayores de 35 años"><ItemTemplate><asp:Label runat="server" ID="L23" Text='<%# GetData(Eval("id").ToString(), "2.3")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.4 Mujeres con insuficiente control prenatal (según edad gestacional)"><ItemTemplate><asp:Label runat="server" ID="L24" Text='<%# GetData(Eval("id").ToString(), "2.4")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.5 Mujeres con enfermedades preexistente como cardiopatias, diabetes, hipertension, entre otros"><ItemTemplate><asp:Label runat="server" ID="L25" Text='<%# GetData(Eval("id").ToString(), "2.5")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.6 Mujeres con 3 o mas criterios de inclusion para morbilidad materna extrema"><ItemTemplate><asp:Label runat="server" ID="L26" Text='<%# GetData(Eval("id").ToString(), "2.6")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.7 Mujeres con secuelas o discapacidades secundarias al evento obstetrico"><ItemTemplate><asp:Label runat="server" ID="L27" Text='<%# GetData(Eval("id").ToString(), "2.7")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P          3.1 Pareja estable:       SI-NO"><ItemTemplate><asp:Label runat="server" ID="L31" Text='<%# GetData(Eval("id").ToString(), "3.1")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P           3.2 Misma Pareja de eventos obstetricos anteriores:   SI-NO"><ItemTemplate><asp:Label runat="server" ID="L32" Text='<%# GetData(Eval("id").ToString(), "3.2")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P           3.3 Embarazo Planeado:    SI-NO"><ItemTemplate><asp:Label runat="server" ID="L33" Text='<%# GetData(Eval("id").ToString(), "3.3")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P           3.4 Embarazo deseado:     SI-NO"><ItemTemplate><asp:Label runat="server" ID="L34" Text='<%# GetData(Eval("id").ToString(), "3.4")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P           3.5 Embarazo aceptado:    SI-NO"><ItemTemplate><asp:Label runat="server" ID="L35" Text='<%# GetData(Eval("id").ToString(), "3.5")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P          3.6 Red de apoyo          SI-NO"><ItemTemplate><asp:Label runat="server" ID="L36" Text='<%# GetData(Eval("id").ToString(), "3.6")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.1 Menarquia"><ItemTemplate><asp:Label runat="server" ID="L41" Text='<%# GetData(Eval("id").ToString(), "4.1") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E        4.2 Ciclos"><ItemTemplate><asp:Label runat="server" ID="L42" Text='<%# GetData(Eval("id").ToString(), "4.2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E        4.3 FUM"><ItemTemplate><asp:Label runat="server" ID="L43" Text='<%# GetData(Eval("id").ToString(), "4.3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E        4.4 PF Previa SI-NO"><ItemTemplate><asp:Label runat="server" ID="L44" Text='<%# GetData(Eval("id").ToString(), "4.4")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E        4.5 Consulta Preconcepcional                SI-NO"><ItemTemplate><asp:Label runat="server" ID="L45" Text='<%# GetData(Eval("id").ToString(), "4.5")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E        4.6 Edad gestacional"><ItemTemplate><asp:Label runat="server" ID="L46" Text='<%# GetData(Eval("id").ToString(), "4.6") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E        4.7 FPP"><ItemTemplate><asp:Label runat="server" ID="L47" Text='<%# GetData(Eval("id").ToString(), "4.7") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.8 Antecedentes  patologicos"><ItemTemplate><asp:Label runat="server" ID="L48" Text='<%# GetData(Eval("id").ToString(), "4.8") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.9 Antecedentes  quirurgicos"><ItemTemplate><asp:Label runat="server" ID="L49" Text='<%# GetData(Eval("id").ToString(), "4.9") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.10 Antecedentes  familiares relevantes"><ItemTemplate><asp:Label runat="server" ID="L410" Text='<%# GetData(Eval("id").ToString(), "4.10") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.11 Antecedentes  toxicologicos (alcohol, cigarrillo, spa)"><ItemTemplate><asp:Label runat="server" ID="L411" Text='<%# GetData(Eval("id").ToString(), "4.11") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.12 Antecedentes  transfusinales            SI-NO"><ItemTemplate><asp:Label runat="server" ID="L412" Text='<%# GetData(Eval("id").ToString(), "4.12")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.13 Deseo de PF posterior al embarazo     SI-NO"><ItemTemplate><asp:Label runat="server" ID="L413" Text='<%# GetData(Eval("id").ToString(), "4.13")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.14 Metodo seleccionado"><ItemTemplate><asp:Label runat="server" ID="L414" Text='<%# GetData(Eval("id").ToString(), "4.14") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O                             5.1 G_ 5.2 P_ 5.3 A_5.4 C_5.5 E_ 5.6 V_5.7 M_"><ItemTemplate><asp:Label runat="server" ID="L5" Text='<%# "G" + GetData(Eval("id").ToString(), "5.8") +"P" + GetData(Eval("id").ToString(), "5.9")+"A" + GetData(Eval("id").ToString(), "5.10")+"C" + GetData(Eval("id").ToString(), "5.11")+"E" + GetData(Eval("id").ToString(), "5.12")+"M" + GetData(Eval("id").ToString(), "5.13") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O           5.8 Gestaciones"><ItemTemplate><asp:Label runat="server" ID="L58" Text='<%# GetData(Eval("id").ToString(), "5.8_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. FO             5.9 Partos "><ItemTemplate><asp:Label runat="server" ID="L59" Text='<%# GetData(Eval("id").ToString(), "5.9_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O         5.10 Abortos "><ItemTemplate><asp:Label runat="server" ID="L510" Text='<%# GetData(Eval("id").ToString(), "5.10_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O         5.11 Cesareas "><ItemTemplate><asp:Label runat="server" ID="L511" Text='<%# GetData(Eval("id").ToString(), "5.11_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O          5.12 Ectopicos "><ItemTemplate><asp:Label runat="server" ID="L512" Text='<%# GetData(Eval("id").ToString(), "5.12_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O         5.13 Muertos "><ItemTemplate><asp:Label runat="server" ID="L513" Text='<%# GetData(Eval("id").ToString(), "5.13_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S        6.1 Mov. Fetales        SI-NO     "><ItemTemplate><asp:Label runat="server" ID="L61" Text='<%# GetData(Eval("id").ToString(), "6.1")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S        6.2 Actividad Uterina            SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L62" Text='<%# GetData(Eval("id").ToString(), "6.2")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S        6.3  Amniorrea            SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L63" Text='<%# GetData(Eval("id").ToString(), "6.3")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S        6.4  Sangrado Vaginal            SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L64" Text='<%# GetData(Eval("id").ToString(), "6.4")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S        6.5  Sintomas Urinarios            SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L65" Text='<%# GetData(Eval("id").ToString(), "6.5")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S        6.6  Flujo Vaginal            SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L66" Text='<%# GetData(Eval("id").ToString(), "6.6")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S          6.7 Sintomas Respiratorios                 SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L67" Text='<%# GetData(Eval("id").ToString(), "6.7")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S          6.8 Fiebre                 SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L68" Text='<%# GetData(Eval("id").ToString(), "6.8")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S             6.9 Sintomas de sangrado anormal (coagulopatias)                   SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L69" Text='<%# GetData(Eval("id").ToString(), "6.9")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S             6.10 Sintomas de sangrado anormal (coagulopatias) Cual                       "><ItemTemplate><asp:Label runat="server" ID="L610" Text='<%# GetData(Eval("id").ToString(), "6.10") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S             6.11 Sintomas de vaso espasmo     6.12 cefalea                    "><ItemTemplate><asp:Label runat="server" ID="L612" Text='<%# GetData(Eval("id").ToString(), "6.12")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S             6.11 Sintomas de vaso espasmo     6.13 fosfenos                    "><ItemTemplate><asp:Label runat="server" ID="L613" Text='<%# GetData(Eval("id").ToString(), "6.13")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S             6.11 Sintomas de vaso espasmo     6.14 acufenos                    "><ItemTemplate><asp:Label runat="server" ID="L614" Text='<%# GetData(Eval("id").ToString(), "6.14")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S             6.11 Sintomas de vaso espasmo     6.15 edemas                    "><ItemTemplate><asp:Label runat="server" ID="L615" Text='<%# GetData(Eval("id").ToString(), "6.15")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S             6.11 Sintomas de vaso espasmo     6.16 epigastralgia                    "><ItemTemplate><asp:Label runat="server" ID="L616" Text='<%# GetData(Eval("id").ToString(), "6.16")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="6. R P S             6.17 Observaciones de la RPS                    " DataField="obssistemas" SortExpression="obssistemas"/>
                    <asp:TemplateField HeaderText="7. R L            Hemoclasificacion                  7.1 Primer Trimestre                   "><ItemTemplate><asp:Label runat="server" ID="LH" Text='<%# GetData(Eval("id").ToString(), "HEMOCLASIFICACION") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Hemoclasificacion                  7.2 Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LH2" Text='<%# GetData(Eval("id").ToString(), "HEMOCLASIFICACION_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Hemoclasificacion                  7.3 Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LH3" Text='<%# GetData(Eval("id").ToString(), "HEMOCLASIFICACION_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Toxoplasma                  7.1 Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LT" Text='<%# GetData(Eval("id").ToString(), "TOXOPLASMA") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Toxoplasma                  7.2 Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LT2" Text='<%# GetData(Eval("id").ToString(), "TOXOPLASMA_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Toxoplasma                  7.3 Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LT3" Text='<%# GetData(Eval("id").ToString(), "TOXOPLASMA_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Serologia                  7.1 Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LS" Text='<%# GetData(Eval("id").ToString(), "SEROLOGIA") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Serologia                  7.2 Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LS2" Text='<%# GetData(Eval("id").ToString(), "SEROLOGIA_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Serologia                  7.3 Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LS3" Text='<%# GetData(Eval("id").ToString(), "SEROLOGIA_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            VIH                  7.1 Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LV" Text='<%# GetData(Eval("id").ToString(), "VIH") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            VIH                  7.2 Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LV2" Text='<%# GetData(Eval("id").ToString(), "VIH_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            VIH                  7.3 Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LV3" Text='<%# GetData(Eval("id").ToString(), "VIH_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Rubeola                 7.1 Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LR" Text='<%# GetData(Eval("id").ToString(), "RUBEOLA") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Rubeola                 7.2 Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LR2" Text='<%# GetData(Eval("id").ToString(), "RUBEOLA_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Rubeola                 7.3 Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LR3" Text='<%# GetData(Eval("id").ToString(), "RUBEOLA_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            P.O/Urocultivo                7.1 Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LP" Text='<%# GetData(Eval("id").ToString(), "P.O/UROCULTIVO") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            P.O/Urocultivo                7.2 SegundoTrimestre                  "><ItemTemplate><asp:Label runat="server" ID="LP2" Text='<%# GetData(Eval("id").ToString(), "P.O/UROCULTIVO_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            P.O/Urocultivo                7.3 Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LP3" Text='<%# GetData(Eval("id").ToString(), "P.O/UROCULTIVO_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Frotis Flujo Vaginal            7.1 Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LF" Text='<%# GetData(Eval("id").ToString(), "FROTIS FLUJO VAGINAL") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Frotis Flujo Vaginal            7.2 Segudo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LF2" Text='<%# GetData(Eval("id").ToString(), "FROTIS FLUJO VAGINAL_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Frotis Flujo Vaginal            7.3 Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LF3" Text='<%# GetData(Eval("id").ToString(), "FROTIS FLUJO VAGINAL_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Glicemia/Curva                 7.1 Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LG" Text='<%# GetData(Eval("id").ToString(), "GLICEMIA/ CURVA DE GLICEMIA") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Glicemia/Curva                 7.2 Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LG2" Text='<%# GetData(Eval("id").ToString(), "GLICEMIA/ CURVA DE GLICEMIA_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Glicemia/Curva                 7.3 Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LG3" Text='<%# GetData(Eval("id").ToString(), "GLICEMIA/ CURVA DE GLICEMIA_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Hemoglobina              7.1 Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LH" Text='<%# GetData(Eval("id").ToString(), "HEMOGLOBINA") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Hemoglobina              7.2 Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LH2" Text='<%# GetData(Eval("id").ToString(), "HEMOGLOBINA_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Hemoglobina              7.3 Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LH3" Text='<%# GetData(Eval("id").ToString(), "HEMOGLOBINA_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Hepatitis B              7.1 Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LB" Text='<%# GetData(Eval("id").ToString(), "HEPATITIS B") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Hepatitis B              7.2 Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LB2" Text='<%# GetData(Eval("id").ToString(), "HEPATITIS B_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R L            Hepatitis B              7.3 Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LB3" Text='<%# GetData(Eval("id").ToString(), "HEPATITIS B_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.4 Fecha Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LF" Text='<%# GetData(Eval("id").ToString(), "FECHA") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.5 Fecha Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LF2" Text='<%# GetData(Eval("id").ToString(), "FECHA_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.6 Fecha Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LF3" Text='<%# GetData(Eval("id").ToString(), "FECHA_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.4 Edad gestacional Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LE" Text='<%# GetData(Eval("id").ToString(), "EDAD GESTACIONAL") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.5 Edad gestacional Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LE2" Text='<%# GetData(Eval("id").ToString(), "EDAD GESTACIONAL_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.6 Edad gestacional Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LE3" Text='<%# GetData(Eval("id").ToString(), "EDAD GESTACIONAL_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.4 Bienestar fetal Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LBI" Text='<%# GetData(Eval("id").ToString(), "BIENESTAR FETAL") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.5 Bienestar fetal Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LBI2" Text='<%# GetData(Eval("id").ToString(), "BIENESTAR FETAL_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.6 Bienestar fetal Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LBI3" Text='<%# GetData(Eval("id").ToString(), "BIENESTAR FETAL_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.4 Placenta Primer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LPL" Text='<%# GetData(Eval("id").ToString(), "PLACENTA") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.5 Placenta Segundo Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LPL2" Text='<%# GetData(Eval("id").ToString(), "PLACENTA_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="7. R E                         7.6 Placenta Tercer Trimestre                  "><ItemTemplate><asp:Label runat="server" ID="LPL3" Text='<%# GetData(Eval("id").ToString(), "PLACENTA_3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.1 Talla                  "><ItemTemplate><asp:Label runat="server" ID="L81" Text='<%# GetData(Eval("id").ToString(), "8.1") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.2 Peso incio del embarazo                  "><ItemTemplate><asp:Label runat="server" ID="L82" Text='<%# GetData(Eval("id").ToString(), "8.2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.3 IMC al inicio                  "><ItemTemplate><asp:Label runat="server" ID="L83" Text='<%# GetData(Eval("id").ToString(), "8.3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.4 Peso Actual                  "><ItemTemplate><asp:Label runat="server" ID="L84" Text='<%# GetData(Eval("id").ToString(), "8.4") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.5 Clasificacion del peso                  "><ItemTemplate><asp:Label runat="server" ID="L85" Text='<%# GetData(Eval("id").ToString(), "8.5") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.6 Ganancia de peso durante el embarazo                  "><ItemTemplate><asp:Label runat="server" ID="L86" Text='<%# GetData(Eval("id").ToString(), "8.6") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.7 T/A                  "><ItemTemplate><asp:Label runat="server" ID="L87" Text='<%# GetData(Eval("id").ToString(), "8.7") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.8 F C                 "><ItemTemplate><asp:Label runat="server" ID="L88" Text='<%# GetData(Eval("id").ToString(), "8.8") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.9 F R                  "><ItemTemplate><asp:Label runat="server" ID="L89" Text='<%# GetData(Eval("id").ToString(), "8.9") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.10 T°                 "><ItemTemplate><asp:Label runat="server" ID="L810" Text='<%# GetData(Eval("id").ToString(), "8.10") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.11 Glicometria                  "><ItemTemplate><asp:Label runat="server" ID="L811" Text='<%# GetData(Eval("id").ToString(), "8.11") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="8. E F                         8.12 Cardiopulmonar                  " DataField="tcardiopulmunar" SortExpression="tcardiopulmunar"/>
                    <asp:TemplateField HeaderText="8. E F         Abdomen                       8.13 A U                  "><ItemTemplate><asp:Label runat="server" ID="L813" Text='<%# GetData(Eval("id").ToString(), "8.13") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F         Abdomen                       8.14 Presentacion del feto                  "><ItemTemplate><asp:Label runat="server" ID="L814" Text='<%# GetData(Eval("id").ToString(), "8.14") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F         Abdomen                       8.15 Situacion fetal                  "><ItemTemplate><asp:Label runat="server" ID="L815" Text='<%# GetData(Eval("id").ToString(), "8.15") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F         Abdomen                       8.16 FCF                  "><ItemTemplate><asp:Label runat="server" ID="L816" Text='<%# GetData(Eval("id").ToString(), "8.16") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="8. E F         Abdomen                       8.17 Observaciones                  " DataField="abdomen" SortExpression="abdomen"/>
                    <asp:TemplateField HeaderText="8. E F         Miembros Inf                       8.18 Edemas  SI-NO                  "><ItemTemplate><asp:Label runat="server" ID="L818" Text='<%# GetData(Eval("id").ToString(), "8.18")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F         Miembros Inf                       8.19 Varices  SI-NO                  "><ItemTemplate><asp:Label runat="server" ID="L819" Text='<%# GetData(Eval("id").ToString(), "8.19")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="9. DIAGNOSTICOS        9.1 Codigo      " DataField="cie10" SortExpression="cie10"/>
                    <asp:TemplateField HeaderText="9. DIAGNOSTICOS        9.2 Descripcion     "><ItemTemplate><asp:Label runat="server" ID="Lcie10" Text='<%# GetCIE10(Eval("cie10").ToString()) %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="9. DIAGNOSTICO        9.3 Patologias asociadas  (al egreso)   " DataField="patvisita" SortExpression="patvisita"/>
                    <asp:BoundField HeaderText="9. DIAGNOSTICO        9.4 Patologias identificadas (en la visita)     " DataField="pategreso" SortExpression="pategreso"/>
                    <asp:TemplateField HeaderText="10. PLAN DE MANEJO        10.1  Verificacion y cumplimiento del plan de manejo de egreso hospitalario     "><ItemTemplate><asp:Label runat="server" ID="L101" Text='<%# GetData(Eval("id").ToString(), "10.1") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="10. PLAN DE MANEJO        10.2  Plan de manejo de situaciones evidenciadas durante la visita      "><ItemTemplate><asp:Label runat="server" ID="L102" Text='<%# GetData(Eval("id").ToString(), "10.2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="10. PLAN DE MANEJO        10.3  Barreras de acceso  evidenciadas     "><ItemTemplate><asp:Label runat="server" ID="L103" Text='<%# GetData(Eval("id").ToString(), "10.3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="10. PLAN DE MANEJO        10.4  Entrega de numeros telefonicos de contactos con la EPS        SI-NO     "><ItemTemplate><asp:Label runat="server" ID="L104" Text='<%# GetData(Eval("id").ToString(), "10.4")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="10. PLAN DE MANEJO        10.5  Educacion en signos de alarma     "><ItemTemplate><asp:Label runat="server" ID="L105" Text='<%# GetData(Eval("id").ToString(), "10.5") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="11. OBSERVACIONES GENERALES DE LA VISITA" DataField="obsgeneral" SortExpression="obsgeneral"/>
                    <asp:TemplateField HeaderText="12. VALORACION DEL RIESGO     12.1 Riesgo Psicosocial     Alto-Bajo"><ItemTemplate><asp:Label runat="server" ID="LR1" Text='<%# Eval("robstetrico").ToString()=="1" ? "ALTO" : "BAJO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="12. VALORACION DEL RIESGO       12.2  Riesgo obstetrico      Alto-Bajo"><ItemTemplate><asp:Label runat="server" ID="LR2" Text='<%# Eval("trsicosocial").ToString()=="1" ? "ALTO" : "BAJO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="13. INTERCONSULTAS  13.1 N°                       13.2 Descripcion" DataField="tinterconsultas" SortExpression="tinterconsultas"/>
                </Columns>
            </asp:GridView>


            <asp:GridView ID="GPosParto" Visible="false" runat="server" DataSourceID="SResultados" 
                AutoGenerateColumns="False" EmptyDataText="No se encontraron autorizaciones"
                AllowPaging="True" PageSize="50" AllowSorting="false">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField HeaderText="MEDICO" DataField="perNombre" SortExpression="perNombre"/>
                    <asp:HyperLinkField HeaderText="1. DATOS PERSONALES   1.1 FECHA ENCUESTA" DataTextField="fecha" SortExpression="fecha" DataNavigateUrlFields="id,paciente" Target="_blank" DataNavigateUrlFormatString="~/materna/seguimiento.aspx?pid={1}&emid={0}" />
                    <asp:BoundField HeaderText="1. DATOS PERSONALES   1.2 NOMBRES " DataField="nombres" SortExpression="nombres"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES   1.3 APELLIDOS" DataField="apellidos" SortExpression="apellidos"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES1.4 TIPO DE DOCUMENTO" DataField="tipodocumento" SortExpression="tipodocumento"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES    1.5 NO. IDENTIFICACION" DataField="pacDocumento" SortExpression="pacDocumento"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES 1.6 IPS PRIMARIA" DataField="ips" SortExpression="ips"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES    1.7 TIPO DE AFILIACION" DataField="tipoafiliacion" SortExpression="tipoafiliacion"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES 1.8 EDAD" DataField="years" SortExpression="years"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES 1.9 TELEFONOS" DataField="telefonos" SortExpression="telefonos"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES 1.10 DIRECCION DE RESIDENCIA" DataField="direccion" SortExpression="direccion"/>
                    <asp:BoundField HeaderText="1. DATOS PERSONALES 1.11 NIVEL DE ESCOLARIDAD" DataField="escolaridad" SortExpression="escolaridad"/>                    
                    <asp:TemplateField HeaderText="2. M C Y E A  2.1 Adolescentes menores de 15 años"><ItemTemplate><asp:Label runat="server" ID="L21" Text='<%# GetData(Eval("id").ToString(), "2.1")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.2 Adolescentes entre 15 y 19 años con 2 o mas gestaciones"><ItemTemplate><asp:Label runat="server" ID="L22" Text='<%# GetData(Eval("id").ToString(), "2.2")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.3 Adolescentes  con histerectomia"><ItemTemplate><asp:Label runat="server" ID="L23" Text='<%# GetData(Eval("id").ToString(), "2.3")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.4 Mujeres Mayores de 35 años"><ItemTemplate><asp:Label runat="server" ID="L24" Text='<%# GetData(Eval("id").ToString(), "2.4")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.5 Mujeres con insuficiente control prenatal (3 o menos)"><ItemTemplate><asp:Label runat="server" ID="L25" Text='<%# GetData(Eval("id").ToString(), "2.5")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.6 Mujeres con enfermedades preexistente como cardiopatias, diabetes, hipertension, entre otros"><ItemTemplate><asp:Label runat="server" ID="L26" Text='<%# GetData(Eval("id").ToString(), "2.6")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.7 Mujeres con 3 o mas criterios de inclusion para morbilidad materna extrema"><ItemTemplate><asp:Label runat="server" ID="L27" Text='<%# GetData(Eval("id").ToString(), "2.7")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.8 Mujeres con secuelas o discapacidades secundarias al evento obstetrico"><ItemTemplate><asp:Label runat="server" ID="L28" Text='<%# GetData(Eval("id").ToString(), "2.8")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="2. M C Y E A   2.9 Mujeres con perdida perinatal"><ItemTemplate><asp:Label runat="server" ID="L29" Text='<%# GetData(Eval("id").ToString(), "2.9")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P          3.1 Pareja estable:       SI-NO"><ItemTemplate><asp:Label runat="server" ID="L31" Text='<%# GetData(Eval("id").ToString(), "3.1")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P           3.2 Misma Pareja de eventos obstetricos anteriores:   SI-NO"><ItemTemplate><asp:Label runat="server" ID="L32" Text='<%# GetData(Eval("id").ToString(), "3.2")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P           3.3 Embarazo Planeado:    SI-NO"><ItemTemplate><asp:Label runat="server" ID="L33" Text='<%# GetData(Eval("id").ToString(), "3.3")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P           3.4 Embarazo deseado:     SI-NO"><ItemTemplate><asp:Label runat="server" ID="L34" Text='<%# GetData(Eval("id").ToString(), "3.4")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P           3.5 Embarazo aceptado:    SI-NO"><ItemTemplate><asp:Label runat="server" ID="L35" Text='<%# GetData(Eval("id").ToString(), "3.5")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="3. F R P          3.6 Red de apoyo          SI-NO"><ItemTemplate><asp:Label runat="server" ID="L36" Text='<%# GetData(Eval("id").ToString(), "3.6")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.1 Menarquia"><ItemTemplate><asp:Label runat="server" ID="L41" Text='<%# GetData(Eval("id").ToString(), "4.1") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E        4.2 Ciclos"><ItemTemplate><asp:Label runat="server" ID="L42" Text='<%# GetData(Eval("id").ToString(), "4.2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E        4.3 FUM"><ItemTemplate><asp:Label runat="server" ID="L43" Text='<%# GetData(Eval("id").ToString(), "4.3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E          4.4 Fecha Parto"><ItemTemplate><asp:Label runat="server" ID="L44" Text='<%# GetData(Eval("id").ToString(), "4.4") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E        4.5 Consulta Preconcepcional                SI-NO"><ItemTemplate><asp:Label runat="server" ID="L45" Text='<%# GetData(Eval("id").ToString(), "4.5")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E        4.6 Edad gestacional al momento del parto"><ItemTemplate><asp:Label runat="server" ID="L46" Text='<%# GetData(Eval("id").ToString(), "4.6") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.7 Antecedentes  patologicos"><ItemTemplate><asp:Label runat="server" ID="L47" Text='<%# GetData(Eval("id").ToString(), "4.7") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.8 Antecedentes  quirurgicos"><ItemTemplate><asp:Label runat="server" ID="L48" Text='<%# GetData(Eval("id").ToString(), "4.8") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.9 Antecedentes  familiares relevantes"><ItemTemplate><asp:Label runat="server" ID="L49" Text='<%# GetData(Eval("id").ToString(), "4.9") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.10 Antecedentes  toxicologicos (alcohol, cigarrillo, spa)"><ItemTemplate><asp:Label runat="server" ID="L410" Text='<%# GetData(Eval("id").ToString(), "4.10") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.11 Antecedentes  transfusinales            SI-NO"><ItemTemplate><asp:Label runat="server" ID="L411" Text='<%# GetData(Eval("id").ToString(), "4.11")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.12 Planificacion familiar       SI-NO"><ItemTemplate><asp:Label runat="server" ID="L412" Text='<%# GetData(Eval("id").ToString(), "4.12")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.13 Quiere tener mas hijos                SI-NO"><ItemTemplate><asp:Label runat="server" ID="L413" Text='<%# GetData(Eval("id").ToString(), "4.13")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="4. A P E           4.14 Metodo seleccionado"><ItemTemplate><asp:Label runat="server" ID="L414" Text='<%# GetData(Eval("id").ToString(), "4.14") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O                             5.1 G_ 5.2 P_ 5.3 A_5.4 C_5.5 E_ 5.6 V_5.7 M_"><ItemTemplate><asp:Label runat="server" ID="L5" Text='<%# "G" + GetData(Eval("id").ToString(), "5.8") +"P" + GetData(Eval("id").ToString(), "5.9")+"A" + GetData(Eval("id").ToString(), "5.10")+"C" + GetData(Eval("id").ToString(), "5.11")+"E" + GetData(Eval("id").ToString(), "5.12")+"M" + GetData(Eval("id").ToString(), "5.13") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O           5.8 Gestaciones"><ItemTemplate><asp:Label runat="server" ID="L58" Text='<%# GetData(Eval("id").ToString(), "5.8_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. FO             5.9 Partos "><ItemTemplate><asp:Label runat="server" ID="L59" Text='<%# GetData(Eval("id").ToString(), "5.9_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O         5.10 Abortos "><ItemTemplate><asp:Label runat="server" ID="L510" Text='<%# GetData(Eval("id").ToString(), "5.10_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O         5.11 Cesareas "><ItemTemplate><asp:Label runat="server" ID="L511" Text='<%# GetData(Eval("id").ToString(), "5.11_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O          5.12 Ectopicos "><ItemTemplate><asp:Label runat="server" ID="L512" Text='<%# GetData(Eval("id").ToString(), "5.12_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="5. F O         5.13 Muertos "><ItemTemplate><asp:Label runat="server" ID="L513" Text='<%# GetData(Eval("id").ToString(), "5.13_2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S        6.1  Sangrado           SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L61" Text='<%# GetData(Eval("id").ToString(), "6.1")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S           6.2 Caracteristicas del  Sangrado "><ItemTemplate><asp:Label runat="server" ID="L62" Text='<%# GetData(Eval("id").ToString(), "6.2")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S        6.3  Sintomas Urinarios            SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L63" Text='<%# GetData(Eval("id").ToString(), "6.3")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S        6.4  Lactancia"><ItemTemplate><asp:Label runat="server" ID="L64" Text='<%# GetData(Eval("id").ToString(), "6.4")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S          6.5 Sintomas Respiratorios                 SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L65" Text='<%# GetData(Eval("id").ToString(), "6.5")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S          6.6 Fiebre                 SI-NO    "><ItemTemplate><asp:Label runat="server" ID="L66" Text='<%# GetData(Eval("id").ToString(), "6.6")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S              Sintomas de vaso espasmo     6.7 Cefalea                    "><ItemTemplate><asp:Label runat="server" ID="L67" Text='<%# GetData(Eval("id").ToString(), "6.7")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S              Sintomas de vaso espasmo     6.8 fosfenos                    "><ItemTemplate><asp:Label runat="server" ID="L68" Text='<%# GetData(Eval("id").ToString(), "6.8")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S              Sintomas de vaso espasmo     6.9 acufenos                    "><ItemTemplate><asp:Label runat="server" ID="L69" Text='<%# GetData(Eval("id").ToString(), "6.9")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S             Sintomas de vaso espasmo     6.10 edemas                    "><ItemTemplate><asp:Label runat="server" ID="L610" Text='<%# GetData(Eval("id").ToString(), "6.10")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="6. R P S             Sintomas de vaso espasmo     6.11 epigastralgia                    "><ItemTemplate><asp:Label runat="server" ID="L611" Text='<%# GetData(Eval("id").ToString(), "6.11")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="7. Resultados de laboratorios al egreso de acuerdo a la causa principal                  " DataField="TLaboratorio" SortExpression="TLaboratorio"/>
                    <asp:TemplateField HeaderText="8. E F                         8.1 Talla                  "><ItemTemplate><asp:Label runat="server" ID="L81" Text='<%# GetData(Eval("id").ToString(), "8.1") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.2 Peso incio del embarazo                  "><ItemTemplate><asp:Label runat="server" ID="L82" Text='<%# GetData(Eval("id").ToString(), "8.2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.3 IMC al inicio                  "><ItemTemplate><asp:Label runat="server" ID="LH" Text='<%# GetData(Eval("id").ToString(), "8.3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.4 Peso Actual                  "><ItemTemplate><asp:Label runat="server" ID="LH2" Text='<%# GetData(Eval("id").ToString(), "8.4") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.5 IMC actual                  "><ItemTemplate><asp:Label runat="server" ID="LH3" Text='<%# GetData(Eval("id").ToString(), "8.5") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.6 Ganancia de peso durante el embarazo                  "><ItemTemplate><asp:Label runat="server" ID="LT" Text='<%# GetData(Eval("id").ToString(), "8.6") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.7 T/A                  "><ItemTemplate><asp:Label runat="server" ID="LT2" Text='<%# GetData(Eval("id").ToString(), "8.7") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.8 F C                 "><ItemTemplate><asp:Label runat="server" ID="LT3" Text='<%# GetData(Eval("id").ToString(), "8.8") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.9 F R                  "><ItemTemplate><asp:Label runat="server" ID="LS" Text='<%# GetData(Eval("id").ToString(), "8.9") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F                         8.10 T°                 "><ItemTemplate><asp:Label runat="server" ID="LS2" Text='<%# GetData(Eval("id").ToString(), "8.10") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="8. E F                         8.11 Cardiopulmonar                  " DataField="tcardiopulmunar" SortExpression="tcardiopulmunar"/>
                    <asp:TemplateField HeaderText="8. E F         Senos                      8.12 Signos de Mastitis   SI-NO                "><ItemTemplate><asp:Label runat="server" ID="LV" Text='<%# GetData(Eval("id").ToString(), "8.12")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F         Senos                      Signos de Mastitis     8.13 Cual                 "><ItemTemplate><asp:Label runat="server" ID="LV2" Text='<%# GetData(Eval("id").ToString(), "8.13") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F         Abdomen                       8.14 Involucion uterina adecuada    SI-NO               "><ItemTemplate><asp:Label runat="server" ID="LV3" Text='<%# GetData(Eval("id").ToString(), "8.14")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="8. E F         Abdomen                       8.15 Observaciones                  " DataField="abdomen" SortExpression="abdomen"/>
                    <asp:TemplateField HeaderText="8. E F         Miembros Inf                       8.16 Edemas  SI-NO                  "><ItemTemplate><asp:Label runat="server" ID="LR2" Text='<%# GetData(Eval("id").ToString(), "8.16")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="8. E F         Miembros Inf                       8.18 Varices  SI-NO                  "><ItemTemplate><asp:Label runat="server" ID="LR3" Text='<%# GetData(Eval("id").ToString(), "8.18")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="9. DIAGNOSTICOS        9.1 Codigo      " DataField="cie10" SortExpression="cie10"/>
                    <asp:TemplateField HeaderText="9. DIAGNOSTICOS        9.2 Descripcion     "><ItemTemplate><asp:Label runat="server" ID="Lcie10" Text='<%# GetCIE10(Eval("cie10").ToString()) %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="9. DIAGNOSTICOS Resultado  Perinatal           9.3.1 Vivo"><ItemTemplate><asp:Label runat="server" ID="LRVivo" Text='<%# Eval("RVivo").ToString()=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="9. DIAGNOSTICOS Resultado  Perinatal             9.3.2 Muerto"><ItemTemplate><asp:Label runat="server" ID="LRVivo" Text='<%# Eval("RVivo").ToString()=="0" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="9. DIAGNOSTICOS Resultado  Perinatal             9.3.3 En casa"><ItemTemplate><asp:Label runat="server" ID="LRUbicacion" Text='<%# Eval("RUbicacion").ToString()=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="9. DIAGNOSTICOS Resultado  Perinatal             9.3.4 Hospitalizado"><ItemTemplate><asp:Label runat="server" ID="LRUbicacion" Text='<%# Eval("RUbicacion").ToString()=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="9. DIAGNOSTICOS Resultado  Perinatal             9.3.5 Peso al nacer" DataField="TPeso" SortExpression="TPeso"/>
                    <asp:BoundField HeaderText="9. DIAGNOSTICOS                9.4 Patologias asociadas (al egreso)" DataField="pategreso" SortExpression="pategreso"/>
                    <asp:BoundField HeaderText="9. DIAGNOSTICOS                9.5 Patologias identificadas (en la visita)" DataField="patvisita" SortExpression="patvisita"/>
                    <asp:TemplateField HeaderText="10. PLAN DE MANEJO        10.1  Verificacion y cumplimiento del plan de manejo de egreso hospitalario     "><ItemTemplate><asp:Label runat="server" ID="L101" Text='<%# GetData(Eval("id").ToString(), "10.1") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="10. PLAN DE MANEJO        10.2  Plan de manejo de situaciones evidenciadas durante la visita      "><ItemTemplate><asp:Label runat="server" ID="L102" Text='<%# GetData(Eval("id").ToString(), "10.2") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="10. PLAN DE MANEJO        10.3  Barreras de acceso  evidenciadas     "><ItemTemplate><asp:Label runat="server" ID="L103" Text='<%# GetData(Eval("id").ToString(), "10.3") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="10. PLAN DE MANEJO        10.4  Entrega de numeros telefonicos de contactos con la EPS        SI-NO     "><ItemTemplate><asp:Label runat="server" ID="L104" Text='<%# GetData(Eval("id").ToString(), "10.4")=="1" ? "SI" : "NO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="10. PLAN DE MANEJO        10.5  Educacion en signos de alarma     "><ItemTemplate><asp:Label runat="server" ID="L105" Text='<%# GetData(Eval("id").ToString(), "10.5") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="11. OBSERVACIONES GENERALES DE LA VISITA" DataField="obsgeneral" SortExpression="obsgeneral"/>
                    <asp:TemplateField HeaderText="12. VALORACION DEL RIESGO      12.1 Alto-Medio-Bajo"><ItemTemplate><asp:Label runat="server" ID="LR1" Text='<%# Eval("RRiesgo").ToString()=="1" ? "ALTO" : Eval("RRiesgo").ToString()=="2" ? "MEDIO" : "BAJO" %>'></asp:Label></ItemTemplate></asp:TemplateField>
                    <asp:BoundField HeaderText="13. INTERCONSULTAS  13.1 N°                     13.2 Descripcion" DataField="tinterconsultas" SortExpression="tinterconsultas"/>
                </Columns>
            </asp:GridView>


            <asp:GridView ID="GNeonato" Visible="false" runat="server" DataSourceID="SNeonato" 
                AutoGenerateColumns="False" EmptyDataText="No se encontraron seguimientos"
                AllowPaging="True" PageSize="50" AllowSorting="false">
                <RowStyle CssClass="GridRow"></RowStyle>
                <FooterStyle CssClass="GridFooter"></FooterStyle>
                <PagerStyle CssClass="GridPager" ForeColor="White"></PagerStyle>
                <SelectedRowStyle CssClass="GridSelRow"></SelectedRowStyle>
                <HeaderStyle CssClass="GridHeader" ForeColor="White"></HeaderStyle>
                <AlternatingRowStyle CssClass="GridAltRow"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField HeaderText="#" DataField="row" SortExpression="row"/>
<asp:BoundField HeaderText="MES" DataField="fecha" SortExpression="fecha" DataFormatString="{0:MMMM}" />
<asp:BoundField HeaderText="1 NOMBRE" DataField="pacPNombre" SortExpression="pacPNombre"/>
<asp:BoundField HeaderText="2 NOMBRE" DataField="pacSNombre" SortExpression="pacSNombre"/>
<asp:BoundField HeaderText="1 APELLIDO" DataField="pacPApellido" SortExpression="pacPApellido"/>
<asp:BoundField HeaderText="2 APELLIDO" DataField="pacSApellido" SortExpression="pacSApellido"/>
<asp:BoundField HeaderText="TIPIDE" DataField="tipodocumento" SortExpression="tipodocumento"/>
<asp:BoundField HeaderText="NUMIDE" DataField="pacDocumento" SortExpression="pacDocumento"/>
<asp:BoundField HeaderText="CUMPLE CRITERIO VISITA" DataField="" SortExpression=""/>
<asp:BoundField HeaderText="AFILIACION" DataField="tipoafiliacion" SortExpression="tipoafiliacion"/>
<asp:BoundField HeaderText="DIRECCION" DataField="direccion" SortExpression="direccion"/>
<asp:BoundField HeaderText="TELEFONOS" DataField="telefonos" SortExpression="telefonos"/>
<asp:BoundField HeaderText="IPS HOSPITALARIA" DataField="ips" SortExpression="ips"/>
<asp:BoundField HeaderText="FECHA REMISION" DataField="" SortExpression=""/>
<asp:BoundField HeaderText="DIAGNOSTICO" DataField="cie10" SortExpression="cie10"/>
<asp:BoundField HeaderText="CRITERIO DE PRIORIZACION" DataField="" SortExpression=""/>
<asp:BoundField HeaderText="USUARIO CONTACTADO" DataField="" SortExpression=""/>
<asp:BoundField HeaderText="SE REALIZA VISITA" DataField="" SortExpression=""/>
<asp:HyperLinkField HeaderText="FECHA DE LA VISITA" DataTextField="fecha" SortExpression="fecha" DataNavigateUrlFields="id,paciente" Target="_blank" DataNavigateUrlFormatString="~/materna/neonato.aspx?pid={1}&snid={0}" />
<asp:BoundField HeaderText="OBSERVACIONES" DataField="" SortExpression=""/>
                    <asp:TemplateField HeaderText="Recomendaciones en Puericultura">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="L1" Text='<%# GetData(Eval("id").ToString(),"puericultura") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Consejeria en Lactancia Materna">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="L2" Text='<%# GetData(Eval("id").ToString(),"consejeria") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Deteccion de signos de alarma">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="L3" Text='<%# GetData(Eval("id").ToString(),"alarma") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Prevencion de enfermedad respiratoria">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="L4" Text='<%# GetData(Eval("id").ToString(),"respiratoria")=="1" ? "SI" :"NO" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Ingreso Programa Madre Canguro">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="L5" Text='<%# GetData(Eval("id").ToString(),"canguro")=="1" ? "SI" :"NO" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Control con Pediatria Crecimiento y Desarrollo">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="L6" Text='<%# GetData(Eval("id").ToString(),"crecimiento")=="1" ? "SI" :"NO" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Interconsulta con especialista y/o remision" SortExpression="interconsultas" DataField="interconsultas" />
                    <asp:TemplateField HeaderText="Resumen acciones realizadas">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="L8" Text='<%# GetData(Eval("id").ToString(),"resumen") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

        </ContentTemplate>
    </asp:UpdatePanel>
    <div style="text-align: right;">
        <asp:Label ID="LTotal" runat="server" Text=""></asp:Label>
    </div>
    <asp:SqlDataSource ID="SNeonato" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                            seguimiento_neonato.id
                            ,seguimiento_neonato.paciente
                            ,@row:=@row+1 row
                            ,paciente.pacPNombre
                            ,paciente.pacSNombre
                            ,paciente.pacPApellido
                            ,paciente.pacSApellido
                            ,tipo_documento.tdocDescripcion AS tipodocumento
                            ,paciente.pacDocumento
                            ,paciente.pacDireccion AS direccion
                            ,CONCAT(IFNULL(paciente.pacTelefono,''), ' ', IFNULL(paciente.pacCelular,'')) AS telefonos
                            ,CASE paciente.pacTipoAfiliado WHEN 2 THEN 'Beneficiario' WHEN 1 THEN 'Cotizante' END as tipoafiliacion
                            ,ips.nombre ips
                            ,seguimiento_neonato.fecha
                            ,(SELECT GROUP_CONCAT(CONCAT(cie10.cieCodDx,'-',cie10.cirDescripcion)) FROM cie10 WHERE cie10.cieCodDx=CONVERT(seguimiento_neonato.data->>'$.cie10' USING latin1)) cie10
                            ,seguimiento_neonato.data->>'$.TInterconsultas' interconsultas
                            FROM seguimiento_neonato
                            JOIN (SELECT @row:=0) r
                            LEFT JOIN paciente ON (paciente.pacId=seguimiento_neonato.paciente)
                            LEFT JOIN tipo_documento ON (tipo_documento.tdocId=paciente.tdocId)
                            LEFT JOIN recurso_humano ON (recurso_humano.perId=seguimiento_neonato.funcionario)
                            LEFT JOIN paciente_tipo_pago ON (paciente_tipo_pago.pdirId=paciente.pdirId)
                            LEFT JOIN varios ips ON (paciente.ips_remitente=ips.id)
                            WHERE 
                            seguimiento_neonato.fecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            ORDER BY seguimiento_neonato.fecha;">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DTipo" Name="tipo" PropertyName="SelectedValue" />
                 </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SResultados" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                SelectCommand="SELECT 
                            seguimiento_materno.id
                            ,seguimiento_materno.paciente
                            ,seguimiento_materno.fecha
                            ,paciente.pacNombres,recurso_humano.perNombre
                            ,CONCAT(paciente.pacPNombre, ' ', paciente.pacSNombre) AS nombres
                            ,CONCAT(paciente.pacPApellido, ' ', paciente.pacSApellido) AS apellidos
                            ,tipo_documento.tdocDescripcion AS tipodocumento
                            ,paciente.pacDocumento
                            ,seguimiento_materno.data->>'$.TIPS' AS ips
                            ,CASE paciente.pacTipoAfiliado WHEN 2 THEN 'Beneficiario' WHEN 1 THEN 'Cotizante' END as tipoafiliacion
                            ,timestampdiff(YEAR, paciente.pacFechaNac, SYSDATE()) AS years
                            ,CONCAT(IFNULL(paciente.pacTelefono,''), ' ', IFNULL(paciente.pacCelular,'')) AS telefonos
                            ,paciente.pacDireccion AS direccion
                            ,seguimiento_materno.data->>'$.TEscolaridad' AS escolaridad
                            ,seguimiento_materno.data->>'$.TLaboratorio' AS TLaboratorio
                            ,seguimiento_materno.data->>'$.TAbdomen' AS abdomen
                            ,seguimiento_materno.data->>'$.RRObstetrico' AS robstetrico
                            ,seguimiento_materno.data->>'$.RRPsicosocial' AS trsicosocial
                            ,seguimiento_materno.data->>'$.TCardioPulmonar' AS tcardiopulmunar
                            ,seguimiento_materno.data->>'$.TInterconsultas' AS tinterconsultas
                            ,seguimiento_materno.data->>'$.TPatologiaVisita' AS patvisita
                            ,seguimiento_materno.data->>'$.TPatologiasEgreso' AS pategreso
                            ,seguimiento_materno.data->>'$.TSistemasObservaciones' AS obssistemas
                            ,seguimiento_materno.data->>'$.TObservacionesGenerales' AS obsgeneral
                            ,seguimiento_materno.data->>'$.cie10' AS cie10
                            ,seguimiento_materno.data->>'$.RVivo' AS RVivo
                            ,seguimiento_materno.data->>'$.TPeso' AS TPeso
                            ,seguimiento_materno.data->>'$.RRiesgo' AS RRiesgo
                            ,seguimiento_materno.data->>'$.RUbicacion' AS RUbicacion
                            ,seguimiento_materno.data->>'$.TRPerinatal' AS TRPerinatal

                            FROM seguimiento_materno
                            LEFT JOIN paciente ON (paciente.pacId=seguimiento_materno.paciente)
                            LEFT JOIN tipo_documento ON (tipo_documento.tdocId=paciente.tdocId)
                            LEFT JOIN recurso_humano ON (recurso_humano.perId=seguimiento_materno.funcionario)
                            LEFT JOIN paciente_tipo_pago ON (paciente_tipo_pago.pdirId=paciente.pdirId)
                            WHERE 
                            seguimiento_materno.fecha BETWEEN STR_TO_DATE(@inicio, '%d/%m/%Y') AND STR_TO_DATE(@fin, '%d/%m/%Y')
                            AND tipo=@tipo
                            ORDER BY seguimiento_materno.fecha;">
                 <SelectParameters>
                    <asp:ControlParameter ControlID="TInicio" Name="inicio" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TFin" Name="fin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DTipo" Name="tipo" PropertyName="SelectedValue" />
                 </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>