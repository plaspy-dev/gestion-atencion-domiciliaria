using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using MySql.Data.MySqlClient;
using SDG.Componentes;
using System.Collections.Specialized;

public partial class paciente_ingreso : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        CConectorMS conector = CConectorMS.GetConector();

        if (!IsPostBack)
        {
            Usuario usuario = Usuario.GetUsuario();
            BAceptar.Enabled = false;
            BMasCDiagnostico.Enabled = false;

            if (Request.QueryString["pid"] != null)
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    TFecha.Text = DateTime.Now.ToShortDateString(); 
                    PDatos.Visible = true;
                    PMujer.Visible = CCDetallePaciente.Sexo!= "M";
                                        
                    BAceptar.Enabled = usuario.CanInsert();
                    BMasCDiagnostico.Enabled = usuario.CanInsert();

                    DMedico.Enabled = usuario.CanAdmin();
                    if(!usuario.CanAdmin()) {
                        DMedico.DataBind();
                        ListItem item= DMedico.Items.FindByValue(usuario["personal"]);
                        if (item == null)
                            BAceptar.Enabled = false;
                        else item.Selected = true;
                    }

                    DMedico.Focus();

                    Query qIngreso = new Query("ingreso_paciente");

                    qIngreso += "id";
                    qIngreso += "medico";
                    qIngreso += "hora";
                    qIngreso += "motivo";
                    qIngreso += "segun";
                    qIngreso += "enfermedad_actual";
                    qIngreso += "ta";
                    qIngreso += "fc";
                    qIngreso += "fr";
                    qIngreso += "t";
                    qIngreso += "peso";
                    qIngreso += "saturacion";
                    qIngreso += "analisis";
                    qIngreso += "glucometria";
                    qIngreso += "tipo_diagnostico";
                    qIngreso += "conducta";
                    qIngreso += "fecha";

                    CConector conectormysql = CConector.GetConector();
                    MySqlDataReader readermysql = conectormysql.Query(qIngreso.GetSelect("paciente=" + CCDetallePaciente.IdPaciente));
                    if (readermysql != null && readermysql.Read())
                    {
                        BAceptar.Enabled = usuario.CanUpdate();
                        BMasCDiagnostico.Enabled = usuario.CanUpdate();
                        ((MasterPageI)Master).Imprimir("ingreso.html");

                        GCDiagnostico.Columns[0].Visible = usuario.CanUpdate();
                        GCDiagnostico.Columns[1].Visible = usuario.CanDelete();

                        HIdIngreso.Value = readermysql["id"].ToString();
                        conector.SelectInDropDown(DMedico, readermysql["medico"], "SELECT perNombre FROM admPersonalHS WHERE perId={0}");
                        THora.Text = readermysql["hora"].ToString();
                        TMotivo.Text = readermysql["motivo"].ToString();
                        DMotivo.SelectedValue = readermysql["segun"].ToString();
                        TEnfermedadActual.Text = readermysql["enfermedad_actual"].ToString();
                        TTA.Text = readermysql["ta"].ToString();
                        TFC.Text = readermysql["fc"].ToString();
                        TFR.Text = readermysql["fr"].ToString();
                        TT.Text = readermysql["t"].ToString();
                        TPeso.Text = readermysql["peso"].ToString();
                        TSaturacion.Text = readermysql["saturacion"].ToString();
                        TAnalisis.Text = readermysql["analisis"].ToString();
                        TGlucometria.Text = readermysql["glucometria"].ToString();
                        conector.SelectInDropDown(DTipoDiagnostico, readermysql["tipo_diagnostico"]);
                        if (readermysql["fecha"] != DBNull.Value)
                            TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();
                        else TFecha.Text = "";
                        TConductaInicial.Text = readermysql["conducta"].ToString();

                        ((MasterPageI)Master).SetModificacion(HIdIngreso.Value);
                    }
                    else
                    {
                        GCDiagnostico.DataBind();
                        if (GCDiagnostico.Rows.Count == 0)
                        { // no se encontraron diagnosticos

                            CConectorMS conectorms = new CConectorMS();
                            SqlDataReader reader = conectorms.Query("SELECT cieCodDx,cieCodDx_1,cieCodDx_2 FROM phdPaciente WHERE pacId=" + CCDetallePaciente.IdPaciente);
                            if (reader != null && reader.Read())
                            {

                                TCIE10.Text = reader["cieCodDx"].ToString();
                                if (TCIE10.Text.Length > 0)
                                {
                                    TCIE10.Text += "-";
                                    BMasCDiagnostico_Click(sender, e);
                                }
                                TCIE10.Text = reader["cieCodDx_1"].ToString();
                                if (TCIE10.Text.Length > 0)
                                {
                                    TCIE10.Text += "-";
                                    BMasCDiagnostico_Click(sender, e);
                                }
                                TCIE10.Text = reader["cieCodDx_2"].ToString();
                                if (TCIE10.Text.Length > 0)
                                {
                                    TCIE10.Text += "-";
                                    BMasCDiagnostico_Click(sender, e);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        CConector conector = CConector.GetConector();
        Query qIngreso = new Query("ingreso_paciente");

        qIngreso["medico"]= DMedico.SelectedValue;
        qIngreso["hora"]= THora.Text;
        qIngreso["motivo"]= TMotivo.Text;
        qIngreso["segun"]= DMotivo.SelectedValue;
        qIngreso["enfermedad_actual"]= TEnfermedadActual.Text;
        qIngreso["ta"]= TTA.Text;
        qIngreso["fc"]= TFC.Text;
        qIngreso["fr"]= TFR.Text;
        qIngreso["t"]= TT.Text;
        qIngreso["peso"]= TPeso.Text;
        qIngreso["fecha"] = CConector.GetDate(Convert.ToDateTime(TFecha.Text));
        qIngreso["conducta"]= TConductaInicial.Text;
        qIngreso["saturacion"] = TSaturacion.Text;
        qIngreso["analisis"] = TAnalisis.Text;
        qIngreso["glucometria"] = TGlucometria.Text;
        qIngreso["tipo_diagnostico"] = DTipoDiagnostico.SelectedValue;

        string szQuery;
        string mensaje;
        bool ingreso = false;

        if (HIdIngreso.Value.Length == 0)
        {
            ingreso = true;
            qIngreso["paciente"] = CCDetallePaciente.IdPaciente;

            szQuery = qIngreso.GetInsert();
            mensaje = CCDetallePaciente.Nombres + " ingresado";
            int resultado = conector.QueryMod(szQuery, true);
            if (resultado == -1)
                return;
            HIdIngreso.Value = resultado.ToString();
        }
        else
        {
            szQuery = qIngreso.GetUpdate("id='" + HIdIngreso.Value + "'");
            mensaje = CCDetallePaciente.Nombres + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdIngreso.Value) == -1)
            return;

        for(int i=0; i<GAntecedentes.Rows.Count; i++) {

            Query antecendentes = new Query("antecedentes_ingreso");
            string id= GAntecedentes.DataKeys[i].Values[1].ToString();

            antecendentes["estado"] = ((CheckBox)GAntecedentes.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
            antecendentes["observaciones"] = ((TextBox)GAntecedentes.Rows[i].Cells[1].FindControl("TObservaciones")).Text;
            if(id.Length>0) {
                id = antecendentes.GetUpdate("id='" + id + "'");
            } else {
                antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                antecendentes["motivo"] = GAntecedentes.DataKeys[i].Values[0].ToString();
                id = antecendentes.GetInsert();
            }
            conector.QueryMod(id);
        }

        for (int i = 0; i < GRevision.Rows.Count; i++)
        {
            Query antecendentes = new Query("revision_ingreso");
            string id = GRevision.DataKeys[i].Values[1].ToString();

            antecendentes["nor"] = ((CheckBox)GRevision.Rows[i].Cells[1].FindControl("CNor")).Checked ? "1" : "";
            antecendentes["pat"] = ((CheckBox)GRevision.Rows[i].Cells[2].FindControl("CPat")).Checked ? "1" : "";
            antecendentes["observaciones"] = ((TextBox)GRevision.Rows[i].Cells[3].FindControl("TObservaciones")).Text;

            if (id.Length > 0)
            {
                id = antecendentes.GetUpdate("id='" + id + "'");
            }
            else
            {
                antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                antecendentes["motivo"] = GRevision.DataKeys[i].Values[0].ToString();
                id = antecendentes.GetInsert();
            }
            conector.QueryMod(id);
        }

         for (int i = 0; i < GExamenFisico.Rows.Count; i++)
        {

            Query antecendentes = new Query("examen_ingreso");
            string id = GExamenFisico.DataKeys[i].Values[1].ToString();

            antecendentes["nor"] = ((CheckBox)GExamenFisico.Rows[i].Cells[1].FindControl("CNor")).Checked ? "1" : "";
            antecendentes["pat"] = ((CheckBox)GExamenFisico.Rows[i].Cells[2].FindControl("CPat")).Checked ? "1" : "";
            antecendentes["observaciones"] = ((TextBox)GExamenFisico.Rows[i].Cells[3].FindControl("TObservaciones")).Text;

            if (id.Length > 0)
            {
                id = antecendentes.GetUpdate("id='" + id + "'");
            }
            else
            {
                antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                antecendentes["motivo"] = GExamenFisico.DataKeys[i].Values[0].ToString();
                id = antecendentes.GetInsert();
            }
            conector.QueryMod(id);
        }

         if (PMujer.Visible)
         {
             for (int i = 0; i < GGinecologico.Rows.Count; i++)
             {

                 Query antecendentes = new Query("varios_ingreso");
                 string id = GGinecologico.DataKeys[i].Values[1].ToString();

                 antecendentes["estado"] = ((CheckBox)GGinecologico.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
                 antecendentes["observaciones"] = ((TextBox)GGinecologico.Rows[i].Cells[1].FindControl("TObservaciones")).Text;
                 if (id.Length > 0)
                 {
                     id = antecendentes.GetUpdate("id='" + id + "'");
                 }
                 else
                 {
                     antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                     antecendentes["motivo"] = GGinecologico.DataKeys[i].Values[0].ToString();
                     id = antecendentes.GetInsert();
                 }
                 conector.QueryMod(id);
             }
         }

        string[] querys = SCDiagnostico.GetQuerys();
        if (querys != null)
        {
            for (int i = 0; i < querys.Length; i++)
            {
                szQuery = querys[i].Replace("@ingreso", Query.GetValor(HIdIngreso.Value));
                if (conector.QueryMod(szQuery) == -1)
                    return;
            }
        }


        // actualizamos el cie10 del paciente
        string cie10 = "", cie102 = "", cie103 = "";

        MySqlDataReader reader = conector.Query("SELECT codigo FROM codigos_ingreso WHERE ingreso_paciente=" + HIdIngreso.Value);
        if (reader != null)
        {

            if (reader.Read())
            {
                cie10 = reader["codigo"].ToString();
                if (reader.Read())
                {
                    cie102 = reader["codigo"].ToString();
                    if (reader.Read())
                    {
                        cie103 = reader["codigo"].ToString();
                    }
                }
            }
        }

        CConectorMS conectorms = new CConectorMS();
        if (conectorms.QueryMod("UPDATE phdPaciente SET megId=" + Query.GetValor(DMedico.SelectedValue) + ",cieCodDx=" + Query.GetValor(cie10) + ",cieCodDx_1=" + Query.GetValor(cie102) + ",cieCodDx_2=" + Query.GetValor(cie103) + " WHERE pacId=" + CCDetallePaciente.IdPaciente) == -1)
            return;

        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        if (ingreso)
            Usuario.GetUsuario().SetForceURL("~/paciente/barthel.aspx?pid=" + CCDetallePaciente.IdPaciente, conector);
        ((MasterPageI)Master).SetResultado(mensaje);
        // Session["szMensaje"] = mensaje;
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected string GetCodigoCIE(string text)
    {
        int pos = text.IndexOf('-');
        if (pos != -1)
        {
            string resultado = text.Substring(0, pos);
            return text.Substring(0, pos).Trim();
        }
        return "";
    }

    protected void BMasCDiagnostico_Click(object sender, EventArgs e)
    {
        Validate("cie10");
        if (!IsValid)
            return;

        string codigo = GetCodigoCIE(TCIE10.Text);

        CConectorMS conector = new CConectorMS();

        string descripcion = conector.QueryString("SELECT cirDescripcion FROM phdCIE10 WHERE cieCodDx='" + codigo + "'");
        if (descripcion.Length > 0) {  // si existe el codigo

            IOrderedDictionary data = new OrderedDictionary();
            data.Add("codigo", codigo);
            data.Add("descripcion", descripcion);
            data.Add("observaciones", TObservacionesCIE10.Text);

            if (GCDiagnostico.SelectedIndex == -1)
            {
                SCDiagnostico.GetView().Insert(data, OnDataSourceOperationComplete);
            }
            else
            {
                data.Add("id", GCDiagnostico.DataKeys[GCDiagnostico.SelectedIndex].Value);

                IOrderedDictionary dataold = new OrderedDictionary();
                dataold.Add("codigo", HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[2].Text).Trim());
                dataold.Add("descripcion", HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[3].Text).Trim());
                dataold.Add("observaciones", HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[4].Text).Trim());
                dataold.Add("id", GCDiagnostico.DataKeys[GCDiagnostico.SelectedIndex].Value);

                SCDiagnostico.GetView().Update(data, data, dataold, OnDataSourceOperationComplete);
            }
            GCDiagnostico.SelectedIndex = -1;
            GCDiagnostico.DataBind();

            TCIE10.Text = "";
            TObservacionesCIE10.Text = "";
        }
    }

    private bool OnDataSourceOperationComplete(int count, Exception e)
    {
        if (e != null)
        {
            throw e;
        }
        return false;
    }

    protected void GCDiagnostico_SelectedIndexChanged(object sender, EventArgs e)
    {
        TCIE10.Text = HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[2].Text).Trim();
        TCIE10.Text+= " - " + HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[3].Text).Trim();
        TObservacionesCIE10.Text = HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[4].Text).Trim();
    }

    protected string RenderGrid(GridView grid, bool pdf) {

        String resultado = "<table border=1 width=100% cellspacing=0>";
        resultado += "<tr>";
        for (int i = 0; i < grid.Columns.Count; i++) {
            /*if (i == 0 && pdf)
                resultado += "<td width='300'>";
            else */
            resultado += "<td>";
            resultado += "<b>" + grid.Columns[i].HeaderText + "</b></td>";
        }
        resultado += "</tr>";
        bool negrilla=false;
        for (int i = 0; i < grid.Rows.Count; i++) {
            GridViewRow row = grid.Rows[i];
            resultado += "<tr>";
            for(int j=0; j<row.Cells.Count; j++) {
                resultado += "<td>";
                if (row.Cells[j].HasControls())
                {
                    ControlCollection controles = row.Cells[j].Controls;
                    for (int k = 0; k < controles.Count; k++)
                    {

                        if (controles[k] is TextBox)
                        {
                            String texto = ((TextBox)controles[k]).Text;
                            if (texto.Length == 0)
                                texto = "&nbsp;";
                            resultado += texto;
                            break;
                        }
                        else if (controles[k] is CheckBox)
                        {
                            if (((CheckBox)controles[k]).Checked)
                            {
                                negrilla = true;
                                resultado += "<b>X </b>";
                            }
                            if (((CheckBox)controles[k]).Text.Length > 0)
                            {
                                if (negrilla)
                                    resultado += "<b>";
                                resultado += ((CheckBox)controles[k]).Text;
                                if (negrilla)
                                {
                                    resultado += "</b>";
                                    negrilla = false;
                                }
                            }
                            break;
                        }
                    }
                }
                else
                {
                    resultado += row.Cells[j].Text;
                }
                resultado += "</td>";
            }
            resultado += "</tr>";
        }
        resultado += "</table>";
        return resultado;
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        // aqui modificamos el evento.Contenido
        evento.Contenido = evento.Contenido.Replace("$GAntecedentes$", RenderGrid(GAntecedentes, evento.pdf));
        evento.Contenido = evento.Contenido.Replace("$GRevision$", RenderGrid(GRevision, evento.pdf));
        evento.Contenido = evento.Contenido.Replace("$GExamenFisico$", RenderGrid(GExamenFisico, evento.pdf));
        if (PMujer.Visible)
            evento.Contenido = evento.Contenido.Replace("$GGinecologico$", RenderGrid(GGinecologico, evento.pdf));
        else evento.Contenido = evento.Contenido.Replace("$GGinecologico$", "");

        evento.Contenido = evento.Contenido.Replace("$szConductaInicial$", "<ol><li>" + TConductaInicial.Text.Replace("\n", "</li><li>") + "</li></ol>");
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());

        Query query = new Query("phdPaciente");

        query["categoria"] = "categoria";
        query["szTipoAfiliacion"] = "CASE pacTipoAfiliado WHEN 1 THEN 'Cotizante' WHEN 2 THEN 'Beneficiario' ELSE '' END";
        query["szProfesional"] = "admPersonalHS.perDocumento";
        query["szMedico"] = "admPersonalHS.perNombre";
        query["szCargo"] = "admCargo.carDescripcion";

        CConectorMS conectorms = new CConectorMS();

        SqlDataReader reader = conectorms.Query(query.GetSelect("pacId=" + CCDetallePaciente.IdPaciente
            , "LEFT JOIN admPersonalHS ON (admPersonalHS.perId=phdPaciente.megId)"
            + " LEFT JOIN admCargo ON (admCargo.carId=admPersonalHS.carId)"
            ));
        if (reader != null)
        {
            bool l = reader.Read();
            if (l)
            {
                evento.Contenido = evento.Contenido.Replace("$szCategoria$", new CConector().QueryString("SELECT nombre FROM varios WHERE id='" + reader["categoria"].ToString() + "' AND tipo=13"));
            }
            for (int i = 0; i < reader.FieldCount; i++)
            {
                evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
        }
    }
}
