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
using System.Configuration;

public partial class paciente_ingreso : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
            BAceptar.Enabled = false;
            BMasCDiagnostico.Enabled = false;

            DTV.MinumunValue = DateTime.Now.AddDays(-2);
            DTV.MaximunValue = DateTime.Now.AddMinutes(1);
            DTV.Enabled = !usuario.CanUpdate();

            if (!string.IsNullOrEmpty(Request.QueryString["aid"]))
            {
                using (CConector conector = new CConector())
                {
                    Response.Redirect(Request.Url.AbsolutePath + "?inid=" + Request.QueryString["aid"]
                        + "&pid="
                        + conector.QueryString("SELECT paciente FROM ingreso_paciente WHERE id=" + Query.GetValor(Request.QueryString["aid"]))
                        + "&pdf="
                        + Request.QueryString["pdf"]
                        + "&npdf=" + Request.QueryString["npdf"]
                        );
                }
            }

            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
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

                    if (Request.QueryString["npdf"] == "1")
                        Title = CCDetallePaciente.Documento + " - " + CCDetallePaciente.Nombres.Replace("(Inactivo)", "");

                    TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);
                    PDatos.Visible = true;
                    PMujer.Visible = CCDetallePaciente.Sexo != "M";

                    BAceptar.Enabled = usuario.CanInsert();
                    BMasCDiagnostico.Enabled = usuario.CanInsert();

                    DMedico.Enabled = usuario.CanAdmin();
                    if (!usuario.CanAdmin())
                    {
                        DMedico.DataBind();
                        ListItem item = DMedico.Items.FindByValue(usuario["personal"]);
                        if (item == null)
                            BAceptar.Enabled = false;
                        else item.Selected = true;
                    }

                    DMedico.Focus();

                    Query qIngreso = new Query("ingreso_paciente");

                    qIngreso += "id";
                    qIngreso += "medico";
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
                    qIngreso += "nivel_atencion";
                    qIngreso += "area_atencion";
                    qIngreso += "seguimiento";

                    using (CConector conector= new CConector())
                    {
                        MySqlDataReader readermysql = conector.Query(qIngreso.GetSelect("paciente=" + CCDetallePaciente.IdPaciente));
                        if (readermysql != null && readermysql.Read())
                        {
                            DTV.Enabled = false;
                            PNivelAtencion.Visible = true;
                            BActualizar.Visible = usuario.CanInsert();
                            BAceptar.Enabled = usuario.CanUpdate();
                            BMasCDiagnostico.Enabled = usuario.CanUpdate();
                            ((MasterPageI)Master).Imprimir("ingreso.html");

                            GCDiagnostico.Columns[0].Visible = usuario.CanUpdate();
                            GCDiagnostico.Columns[1].Visible = usuario.CanDelete();

                            HIdIngreso.Value = readermysql["id"].ToString();
                            conector.SelectInDropDown(DMedico, readermysql["medico"], "SELECT perNombre FROM recurso_humano WHERE perId={0}");

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
                            Utilidades.SelectInDropDown(DTipoDiagnostico, readermysql["tipo_diagnostico"]);
                            Utilidades.SelectInDropDown(DNivelAtencion, readermysql["nivel_atencion"]);
                            Utilidades.SelectInDropDown(DArea, readermysql["area_atencion"]);
                            TFechaSeguimiento.Text = Query.GetFromMySQLDate(readermysql["seguimiento"]);
                            TFecha.Text = Query.GetFromMySQLDate(readermysql["fecha"], true);
                            TConductaInicial.Text = HttpUtility.HtmlEncode(readermysql["conducta"].ToString().Trim());
                            if (TConductaInicial.Text.Length == 0)
                            {
                                string procedimientos = HttpUtility.HtmlEncode(Procedimientos.GetPlanDeManejo(conector, CCDetallePaciente.IdPaciente, TFecha.Text));
                                if (procedimientos.Length > 0)
                                {
                                    ViewState["procedimientos"] = procedimientos;
                                    TConductaInicial.Text = procedimientos;
                                }
                            }

                            TConductaInicial.ReadOnly = !usuario.CanAdmin();
                            BEliminar.Visible = usuario.CanDelete();

                            ((MasterPageI)Master).SetModificacion(HIdIngreso.Value);
                        }
                        else
                        {
                            GCDiagnostico.DataBind();
                            if (GCDiagnostico.Rows.Count == 0)
                            { // no se encontraron diagnosticos

                                Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);

                                for (int i = 0; i < paciente.cie10.Count; i++)
                                {
                                    TCIE10.Text = Procedimientos.GetCodigoCIE(paciente.cie10[i].ToString());
                                    BMasCDiagnostico_Click(sender, e);
                                }
                            }
                            TConductaInicial.ReadOnly = !usuario.CanAdmin();
                        }
                    }
                }
            }
        }
    }

    protected void BActualizar_Click(object sender, EventArgs e)
    {

        using (CConector conector = new CConector())
        {
            Query qIngreso = new Query("ingreso_paciente");

            qIngreso["area_atencion"] = DArea.SelectedValue;
            qIngreso["seguimiento"] = Query.GetMySQLDateFormat(TFechaSeguimiento.Text);

            string szQuery = qIngreso.GetUpdate("id='" + HIdIngreso.Value + "'");
            string mensaje = CCDetallePaciente.Nombres + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;

            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            ((MasterPageI)Master).SetResultado(mensaje);
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        using(CConector conector= new CConector()) 
        {
            Query qIngreso = new Query("ingreso_paciente");

            qIngreso["medico"] = DMedico.SelectedValue;
            qIngreso["motivo"] = TMotivo.Text;
            qIngreso["segun"] = DMotivo.SelectedValue;
            qIngreso["enfermedad_actual"] = TEnfermedadActual.Text;
            qIngreso["ta"] = TTA.Text;
            qIngreso["fc"] = TFC.Text;
            qIngreso["fr"] = TFR.Text;
            qIngreso["t"] = TT.Text;
            qIngreso["peso"] = TPeso.Text;
            qIngreso["fecha"] = Query.GetMySQLDateFormat(TFecha.Text, true);
            qIngreso["saturacion"] = TSaturacion.Text;
            qIngreso["analisis"] = TAnalisis.Text;
            qIngreso["glucometria"] = TGlucometria.Text;
            qIngreso["tipo_diagnostico"] = DTipoDiagnostico.SelectedValue;
            qIngreso["asegurador"] = CCDetallePaciente.AsegurdadorID;
            qIngreso["nivel_atencion"] = DNivelAtencion.SelectedValue;
            qIngreso["area_atencion"] = DArea.SelectedValue;
            qIngreso["seguimiento"] = Query.GetMySQLDateFormat(TFechaSeguimiento.Text);

            qIngreso["conducta"] =
                (string.IsNullOrEmpty((string)ViewState["procedimientos"]) || TConductaInicial.Text.Trim() != ViewState["procedimientos"].ToString())
                ? HttpUtility.HtmlDecode(TConductaInicial.Text.Trim())
                : ""; // guardamos la conducta si es diferente a la inicial

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

            for (int i = 0; i < GAntecedentes.Rows.Count; i++)
            {

                Query antecendentes = new Query("antecedentes_ingreso");
                string id = GAntecedentes.DataKeys[i].Values[1].ToString();

                antecendentes["estado"] = ((CheckBox)GAntecedentes.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
                antecendentes["observaciones"] = ((TextBox)GAntecedentes.Rows[i].Cells[1].FindControl("TObservaciones")).Text;
                if (id.Length > 0)
                {
                    id = antecendentes.GetUpdate("id='" + id + "'");
                }
                else
                {
                    antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                    antecendentes["motivo"] = GAntecedentes.DataKeys[i].Values[0].ToString();
                    id = antecendentes.GetInsert();
                }
                Paciente.SaveAntecedente(conector, CCDetallePaciente.IdPaciente, GAntecedentes.DataKeys[i].Values[0].ToString(), antecendentes["estado"].ToString(), antecendentes["observaciones"].ToString());
                conector.QueryMod(id);
            }


            for (int i = 0; i < GRiesgos.Rows.Count; i++)
            {
                Query riesgos = new Query("ingreso_riesgos");
                string id = GRiesgos.DataKeys[i].Values[1].ToString();

                riesgos["estado"] = ((CheckBox)GRiesgos.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
                riesgos["observaciones"] = ((TextBox)GRiesgos.Rows[i].Cells[1].FindControl("TObservaciones")).Text;
                if (id.Length > 0)
                {
                    id = riesgos.GetUpdate("id='" + id + "'");
                }
                else
                {
                    riesgos["ingreso_paciente"] = HIdIngreso.Value;
                    riesgos["motivo"] = GRiesgos.DataKeys[i].Values[0].ToString();
                    id = riesgos.GetInsert();
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
                } else {
                    antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                    antecendentes["motivo"] = GExamenFisico.DataKeys[i].Values[0].ToString();
                    id = antecendentes.GetInsert();
                }
                conector.QueryMod(id);
            }

            for (int i = 0; i < RPlanEducativo.Items.Count; i++)
            {
                Query riesgos = new Query("ingreso_plan_educativo");
                string id = RPlanEducativo.DataKeys[i].ToString();

                riesgos["estado"] = ((CheckBox)RPlanEducativo.Items[i].FindControl("CSi")).Checked ? "1" : "";
                if (id.Length > 0)
                {
                    id = riesgos.GetUpdate("id='" + id + "'");
                }
                else
                {
                    riesgos["ingreso_paciente"] = HIdIngreso.Value;
                    riesgos["motivo"] = ((HiddenField)RPlanEducativo.Items[i].FindControl("HId")).Value;
                    id = riesgos.GetInsert();
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

            if (conector.QueryMod("UPDATE paciente SET megId=" + Query.GetValor(DMedico.SelectedValue) + ",cieCodDx=" + Query.GetValor(cie10) + ",cieCodDx_1=" + Query.GetValor(cie102) + ",cieCodDx_2=" + Query.GetValor(cie103) + " WHERE pacId=" + CCDetallePaciente.IdPaciente) == -1)
                return;

            Paciente.RemovePaciente(CCDetallePaciente.IdPaciente);

            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            if (ingreso && Usuario.GetInstance().GetPermisosRaiz("~/App_data/Escalas")==0)
                Usuario.GetUsuario().SetForceURL("~/paciente/barthel.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + HttpUtility.UrlEncode(Query.GetMySQLDateFormat(TFecha.Text, true)), conector);
            ((MasterPageI)Master).SetResultado(mensaje);
        }
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

        using (CConector conector = new CConector())
        {
            string descripcion = conector.QueryString("SELECT cirDescripcion FROM cie10 WHERE cieCodDx='" + codigo + "'");
            if (descripcion.Length > 0)
            {  // si existe el codigo

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
                TCIE10.Focus();
            }
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
            resultado += "<b>" + HttpUtility.HtmlEncode(grid.Columns[i].HeaderText) + "</b></td>";
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
                            String texto = HttpUtility.HtmlEncode(((TextBox)controles[k]).Text);
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
                                resultado += HttpUtility.HtmlEncode(((CheckBox)controles[k]).Text);
                                if (negrilla)
                                {
                                    resultado += "</b>";
                                    negrilla = false;
                                }
                            }
                            break;
                        }
                    }
                } else {
                    resultado += HttpUtility.HtmlEncode(row.Cells[j].Text);
                }
                resultado += "</td>";
            }
            resultado += "</tr>";
        }
        resultado += "</table>";
        return resultado;
    }

    protected static string ImprimirGridTipo1(GridView grid)
    {

        string resultado = "";
        for (int i = 0; i < grid.Rows.Count; i++)
        {
            CheckBox check = (CheckBox)grid.Rows[i].FindControl("CSi");
            TextBox text = (TextBox)grid.Rows[i].FindControl("TObservaciones");
            if (text.Text.Length != 0)
            {
                if (resultado.Length > 0)
                    resultado += ", ";
                resultado += string.Format("<b>{0}: </b> {2}", HttpUtility.HtmlEncode(check.Text), check.Checked ? "X" : "_", HttpUtility.HtmlEncode(text.Text));
            }
        }
        if (resultado.Length == 0)
            resultado = grid.EmptyDataText;
        return resultado;
    }

    protected static string ImprimirGridTipo2(GridView grid)
    {
        string resultado = "";
        for (int i = 0; i < grid.Rows.Count; i++)
        {
            Label nombre = (Label)grid.Rows[i].FindControl("LNombre");
            CheckBox nor = (CheckBox)grid.Rows[i].FindControl("CNor");
            CheckBox pat = (CheckBox)grid.Rows[i].FindControl("CPat");
            TextBox text = (TextBox)grid.Rows[i].FindControl("TObservaciones");
            if (text.Text.Length != 0)
            {
                if (resultado.Length > 0)
                    resultado += "<br/>";
                string check = "";
                if (nor.Checked)
                    check = "Nor";
                if (pat.Checked)
                {
                    if (check.Length > 0)
                        check += ",";
                    check += "Pat";
                }
                if (check.Length == 0)
                    check = "_";
                resultado += string.Format("<b>{0}</b> ({1}) {2}.", HttpUtility.HtmlEncode(nombre.Text), check, HttpUtility.HtmlEncode(text.Text));
            }
        }
        if (resultado == "")
            resultado = grid.EmptyDataText;
        return resultado;
    }

    protected string ImprimirPlanEducativo()
    {

        string resultado = "";
        RPlanEducativo.DataBind();
        for (int i = 0; i < RPlanEducativo.Items.Count; i++)
        {
            CheckBox check = (CheckBox)RPlanEducativo.Items[i].FindControl("CSi");
            if (check.Checked)
            {
                if (resultado.Length > 0)
                    resultado += ", ";
                resultado += HttpUtility.HtmlEncode(check.Text);
            }
        }
        if (resultado.Length == 0)
            resultado = "No se encontro plan educativo.";
        return resultado;
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        // aqui modificamos el evento.Contenido
        evento.Contenido = evento.Contenido.Replace("$szAntecedentes$", ImprimirGridTipo1(GAntecedentes));
        evento.Contenido = evento.Contenido.Replace("$szRiesgos$", ImprimirGridTipo1(GRiesgos));
        evento.Contenido = evento.Contenido.Replace("$szRevision$", ImprimirGridTipo2(GRevision));
        evento.Contenido = evento.Contenido.Replace("$szExamenFisico$", ImprimirGridTipo2(GExamenFisico));
        evento.Contenido = evento.Contenido.Replace("$szPlanEducativo$", ImprimirPlanEducativo());
        if (PMujer.Visible)
            evento.Contenido = evento.Contenido.Replace("$szGinecologico$", "<strong>Examen ginecológico</strong>: " + ImprimirGridTipo1(GGinecologico));
        else evento.Contenido = evento.Contenido.Replace("$szGinecologico$", "");

        evento.Contenido = evento.Contenido.Replace("$szConductaInicial$", "<ol><li>" + TConductaInicial.Text.Replace("\n", "</li><li>") + "</li></ol>");
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());

        foreach (Calificacion.Escalas escala in (Calificacion.Escalas[])Enum.GetValues(typeof(Calificacion.Escalas)))
        {
            evento.Contenido = evento.Contenido.Replace("$sz" + escala.ToString() + "$", Calificacion.GetCalificacionYDescripcion(CCDetallePaciente.IdPaciente, TFecha.Text, escala));
        }

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

        Query query = new Query("recurso_humano");

        query["szProfesional"] = "recurso_humano.perDocumento";
        query["szMedico"] = "recurso_humano.perNombre";
        query["szCargo"] = "cargo.carDescripcion";

        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query(query.GetSelect("recurso_humano.perId=" + DMedico.SelectedValue
                , " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"
                ));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }
        }
        using (CConector conector = new CConector())
        {
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", DMedico.SelectedValue);
        }
        // limpiamos el inactivo de los pacientes
        evento.Contenido = evento.Contenido.Replace(" (Inactivo)", "");
    }
    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            if (conector.QueryMod("DELETE FROM antecedentes_ingreso WHERE ingreso_paciente=" + HIdIngreso.Value) == -1)
                return;
            if (conector.QueryMod("DELETE FROM revision_ingreso WHERE ingreso_paciente=" + HIdIngreso.Value) == -1)
                return;
            if (conector.QueryMod("DELETE FROM examen_ingreso WHERE ingreso_paciente=" + HIdIngreso.Value) == -1)
                return;
            if (conector.QueryMod("DELETE FROM varios_ingreso WHERE ingreso_paciente=" + HIdIngreso.Value) == -1)
                return;
            if (conector.QueryMod("DELETE FROM codigos_ingreso WHERE ingreso_paciente=" + HIdIngreso.Value) == -1)
                return;
            if (conector.QueryMod("DELETE FROM ingreso_paciente WHERE id=" + HIdIngreso.Value) == -1)
                return;
            conector.Commit();
            Response.Redirect(Request.Url.AbsolutePath);
        }
    }
}
