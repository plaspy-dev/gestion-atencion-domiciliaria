using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using SDG.Componentes;
using System.Collections.Specialized;

public partial class paciente_evolucion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
            BAceptar.Enabled = false;
            BMasCDiagnostico.Enabled = false;
            PEvoluciones.Visible = false;

            if (!string.IsNullOrEmpty(Request.QueryString["aid"])) {

                if (Request.QueryString["aid"][0] == 'i') {
                    Response.Redirect("~/paciente/ingreso.aspx?aid=" 
                        + Request.QueryString["aid"].Substring(1)
                        + "&pdf="
                        + Request.QueryString["pdf"]
                        + "&npdf=" + Request.QueryString["npdf"]
                        );
                }
                using (CConector conector = new CConector()) {
                    Response.Redirect(Request.Url.AbsolutePath + "?evolid=" + Request.QueryString["aid"] 
                        + "&pid=" 
                        + conector.QueryString("SELECT paciente FROM evolucion_paciente WHERE id=" + Query.GetValor(Request.QueryString["aid"]))
                        + "&pdf=" 
                        + Request.QueryString["pdf"]
                        + "&npdf=" + Request.QueryString["npdf"]
                        );
                }
            }

            if (Request.QueryString["pid"] != null)
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    if(usuario.CanAdmin())
                        DArchivo.IdPaciente = CCDetallePaciente.IdPaciente;
                    ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                    TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);

                    if (Request.QueryString["npdf"] == "1")
                        Title = CCDetallePaciente.Documento + " - " + CCDetallePaciente.Nombres.Replace("(Inactivo)", "");

                    PDatos.Visible = true;

                    BAceptar.Enabled = usuario.CanInsert();
                    BMasCDiagnostico.Enabled = usuario.CanInsert();
                    using (CConector conector = new CConector())
                    {
                        TFuncionario.Enabled = usuario.CanAdmin();
                        if (!usuario.CanAdmin())
                        {
                            if (usuario["personal"].Length == 0)
                                BAceptar.Enabled = false;
                            else
                            {
                                TIdFuncionario.Text = usuario["personal"];
                                TFuncionario.Text = conector.QueryString("SELECT perNombre FROM recurso_humano WHERE perId='" + TIdFuncionario.Text + "'");
                            }
                            PCIE10.Visible = conector.QueryString("SELECT carId FROM recurso_humano WHERE perId='" + TIdFuncionario.Text + "'") == "6";
                            TTA.Focus();
                        }
                        else
                        {
                            PCIE10.Visible = true;
                            TFuncionario.Focus();
                        }
                    }

                    Query qIngreso = new Query("evolucion_paciente");

                    qIngreso += "id";
                    qIngreso += "medico";
                    qIngreso += "motivo";
                    qIngreso += "datos_subjetivos";
                    qIngreso += "ta";
                    qIngreso += "fc";
                    qIngreso += "fr";
                    qIngreso += "t";
                    qIngreso += "peso";
                    qIngreso += "plan_manejo";
                    qIngreso += "analisis";
                    qIngreso += "fecha";
                    qIngreso += "saturacion";
                    qIngreso += "glucometria";
                    qIngreso += "nivel_atencion";
                    qIngreso += "area_atencion";
                    qIngreso += "seguimiento";

                    using(CConector conector= new CConector()) 
                    {
                        MySqlDataReader readermysql = conector.Query(qIngreso.GetSelect("id=" + Query.GetValor(Request.QueryString["evolid"])));
                        if (readermysql != null && readermysql.Read())
                        {
                            PNivelAtencion.Visible = true;
                            BActualizar.Visible = usuario.CanInsert();

                            BAceptar.Enabled = usuario.CanUpdate();
                            BMasCDiagnostico.Enabled = usuario.CanUpdate();
                            ((MasterPageI)Master).Imprimir("evolucion.html");

                            GCDiagnostico.Columns[0].Visible = usuario.CanUpdate();
                            GCDiagnostico.Columns[1].Visible = usuario.CanDelete();

                            HIdEvolucion.Value = readermysql["id"].ToString();
                            TIdFuncionario.Text = readermysql["medico"].ToString();

                            TMotivo.Text = readermysql["motivo"].ToString();
                            TDatosSubjetivos.Text = readermysql["datos_subjetivos"].ToString();
                            TTA.Text = readermysql["ta"].ToString();
                            TFC.Text = readermysql["fc"].ToString();
                            TFR.Text = readermysql["fr"].ToString();
                            TT.Text = readermysql["t"].ToString();
                            TSaturacion.Text = readermysql["saturacion"].ToString();
                            TGlucometria.Text = readermysql["glucometria"].ToString();
                            TAnalisis.Text = readermysql["analisis"].ToString();
                            TPeso.Text = readermysql["peso"].ToString();
                            TFecha.Text = Query.GetFromMySQLDate(readermysql["fecha"], true);
                            TPlanManejo.Text = readermysql["plan_manejo"].ToString();
                            Utilidades.SelectInDropDown(DNivelAtencion, readermysql["nivel_atencion"]);
                            Utilidades.SelectInDropDown(DArea, readermysql["area_atencion"]);
                            TFechaSeguimiento.Text = Query.GetFromMySQLDate(readermysql["seguimiento"]);

                            TFuncionario.Text = conector.QueryString("SELECT perNombre FROM recurso_humano WHERE perId='" + TIdFuncionario.Text + "'");

                            if (TPlanManejo.Text.Length == 0)
                            {
                                string procedimientos = Procedimientos.GetPlanDeManejo(conector, CCDetallePaciente.IdPaciente, TFecha.Text);
                                if (procedimientos.Length > 0)
                                {
                                    ViewState["procedimientos"] = procedimientos;
                                    TPlanManejo.Text = procedimientos;
                                }
                            }
                            TPlanManejo.ReadOnly = !usuario.CanAdmin();
                            BEliminar.Visible = usuario.CanDelete();

                            ((MasterPageI)Master).SetModificacion(HIdEvolucion.Value);
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
                            TPlanManejo.ReadOnly = !usuario.CanAdmin();
                            // TPlanManejo.Text = conectormysql.QueryString("SELECT plan_manejo FROM evolucion_paciente WHERE paciente=" + CCDetallePaciente.IdPaciente + " ORDER BY fecha DESC LIMIT 1");
                        }
                    }
                    GEvoluciones.DataBind();
                    LEvoluciones.Text = GEvoluciones.Rows.Count + " Evoluci";
                    LEvoluciones.Text += GEvoluciones.Rows.Count == 1 ? "ón" : "ones";
                    PEvoluciones.Visible = GEvoluciones.Rows.Count > 0;
                }
            }
        }
    }

    protected void BActualizar_Click(object sender, EventArgs e) {

        using (CConector conector = new CConector())
        {
            Query qIngreso = new Query("evolucion_paciente");

            qIngreso["area_atencion"] = DArea.SelectedValue;
            qIngreso["seguimiento"] = Query.GetMySQLDateFormat(TFechaSeguimiento.Text);

            string szQuery = qIngreso.GetUpdate("id='" + HIdEvolucion.Value + "'");
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
            Query qIngreso = new Query("evolucion_paciente");

            qIngreso["medico"] = TIdFuncionario.Text;
            qIngreso["motivo"] = TMotivo.Text;
            qIngreso["datos_subjetivos"] = TDatosSubjetivos.Text;
            qIngreso["ta"] = TTA.Text;
            qIngreso["fc"] = TFC.Text;
            qIngreso["fr"] = TFR.Text;
            qIngreso["t"] = TT.Text;
            qIngreso["peso"] = TPeso.Text;
            qIngreso["analisis"] = TAnalisis.Text;
            qIngreso["fecha"] = Query.GetMySQLDateFormat(TFecha.Text, true);
            qIngreso["saturacion"] = TSaturacion.Text;
            qIngreso["glucometria"] = TGlucometria.Text;
            qIngreso["asegurador"] = CCDetallePaciente.AsegurdadorID;
            qIngreso["nivel_atencion"] = DNivelAtencion.SelectedValue;
            qIngreso["area_atencion"] = DArea.SelectedValue;
            qIngreso["seguimiento"] = Query.GetMySQLDateFormat(TFechaSeguimiento.Text);

            qIngreso["plan_manejo"] =
                (string.IsNullOrEmpty((string)ViewState["procedimientos"]) || TPlanManejo.Text != ViewState["procedimientos"].ToString())
                ? TPlanManejo.Text
                : "";

            string szQuery;
            string mensaje;
            bool nuevaevolucion = HIdEvolucion.Value.Length == 0;

            if (HIdEvolucion.Value.Length == 0)
            {
                qIngreso["paciente"] = CCDetallePaciente.IdPaciente;

                szQuery = qIngreso.GetInsert();
                mensaje = CCDetallePaciente.Nombres + " ingresado";
                int resultado = conector.QueryMod(szQuery, true);
                if (resultado == -1)
                    return;
                HIdEvolucion.Value = resultado.ToString();
            }
            else
            {
                szQuery = qIngreso.GetUpdate("id='" + HIdEvolucion.Value + "'");
                mensaje = CCDetallePaciente.Nombres + " editado";
                if (conector.QueryMod(szQuery) == -1)
                    return;
            }
            if (conector.InsertModificacion(HIdEvolucion.Value) == -1)
                return;

            for (int i = 0; i < GAntecedentes.Rows.Count; i++)
            {
                Query antecendentes = new Query("antecedentes_evolucion");
                string id = GAntecedentes.DataKeys[i].Values[1].ToString();

                antecendentes["estado"] = ((CheckBox)GAntecedentes.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
                antecendentes["observaciones"] = ((TextBox)GAntecedentes.Rows[i].Cells[1].FindControl("TObservaciones")).Text;
                if (id.Length > 0)
                {
                    id = antecendentes.GetUpdate("id='" + id + "'");
                }
                else
                {
                    antecendentes["evolucion_paciente"] = HIdEvolucion.Value;
                    antecendentes["motivo"] = GAntecedentes.DataKeys[i].Values[0].ToString();
                    id = antecendentes.GetInsert();
                }
                conector.QueryMod(id);
            }

            for (int i = 0; i < GRiesgos.Rows.Count; i++)
            {
                Query riesgos = new Query("evolucion_riesgos");
                string id = GRiesgos.DataKeys[i].Values[1].ToString();

                riesgos["estado"] = ((CheckBox)GRiesgos.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
                riesgos["observaciones"] = ((TextBox)GRiesgos.Rows[i].Cells[1].FindControl("TObservaciones")).Text;
                if (id.Length > 0)
                {
                    id = riesgos.GetUpdate("id='" + id + "'");
                }
                else
                {
                    riesgos["evolucion_paciente"] = HIdEvolucion.Value;
                    riesgos["motivo"] = GRiesgos.DataKeys[i].Values[0].ToString();
                    id = riesgos.GetInsert();
                }
                conector.QueryMod(id);
            }


            for (int i = 0; i < RPlanEducativo.Items.Count; i++)
            {
                Query riesgos = new Query("evolucion_plan_educativo");
                string id = RPlanEducativo.DataKeys[i].ToString();

                riesgos["estado"] = ((CheckBox)RPlanEducativo.Items[i].FindControl("CSi")).Checked ? "1" : "";
                if (id.Length > 0)
                {
                    id = riesgos.GetUpdate("id='" + id + "'");
                }
                else
                {
                    riesgos["evolucion_paciente"] = HIdEvolucion.Value;
                    riesgos["motivo"] = ((HiddenField)RPlanEducativo.Items[i].FindControl("HId")).Value;
                    id = riesgos.GetInsert();
                }
                conector.QueryMod(id);
            }

            for (int i = 0; i < GExamenFisico.Rows.Count; i++)
            {

                Query antecendentes = new Query("examen_evolucion");
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
                    antecendentes["evolucion_paciente"] = HIdEvolucion.Value;
                    antecendentes["motivo"] = GExamenFisico.DataKeys[i].Values[0].ToString();
                    id = antecendentes.GetInsert();
                }
                conector.QueryMod(id);
            }

            string[] querys = SCDiagnostico.GetQuerys();
            if (querys != null)
            {
                for (int i = 0; i < querys.Length; i++)
                {
                    szQuery = querys[i].Replace("@ingreso", Query.GetValor(HIdEvolucion.Value));
                    if (conector.QueryMod(szQuery) == -1)
                        return;
                }
            }


            // actualizamos el cie10 del paciente
            string cie10 = "", cie102 = "", cie103 = "";

            MySqlDataReader reader = conector.Query("SELECT codigo FROM codigos_evolucion WHERE evolucion_paciente=" + HIdEvolucion.Value);
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

            if (conector.QueryString("SELECT carId FROM recurso_humano WHERE perId='" + TIdFuncionario.Text + "'") == "6") // medico
            {
                if (conector.QueryMod("UPDATE paciente SET megId=" + Query.GetValor(TIdFuncionario.Text) + ",cieCodDx=" + Query.GetValor(cie10) + ",cieCodDx_1=" + Query.GetValor(cie102) + ",cieCodDx_2=" + Query.GetValor(cie103) + " WHERE pacId=" + CCDetallePaciente.IdPaciente) == -1)
                    return;
            }

            Paciente.RemovePaciente(CCDetallePaciente.IdPaciente);

            if (nuevaevolucion)
                Usuario.GetUsuario().SetForceURL("~/paciente/barthel.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + HttpUtility.UrlEncode(Query.GetMySQLDateFormat(TFecha.Text, true)), conector);
            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            ((MasterPageI)Master).SetResultado(mensaje);
        }
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
        string codigo = GetCodigoCIE(TCIE10.Text);

        using (CConector conector = new CConector())
        {

            string descripcion = conector.QueryString("SELECT cirDescripcion FROM cie10 WHERE cieCodDx='" + codigo + "'");
            if (descripcion.Length > 0)
            {  // si existe el codigo

                IOrderedDictionary data = new OrderedDictionary();
                data.Add("codigo", codigo);
                data.Add("descripcion", descripcion);

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
                    dataold.Add("id", GCDiagnostico.DataKeys[GCDiagnostico.SelectedIndex].Value);

                    SCDiagnostico.GetView().Update(data, data, dataold, OnDataSourceOperationComplete);
                }
                GCDiagnostico.SelectedIndex = -1;
                GCDiagnostico.DataBind();

                TCIE10.Text = "";
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
        TCIE10.Text += " - " + HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[3].Text).Trim();
    }

    protected static string ImprimirGridTipo1(GridView grid) {

        string resultado = "";
        for (int i = 0; i < grid.Rows.Count; i++)
        {
            CheckBox check = (CheckBox)grid.Rows[i].FindControl("CSi");
            TextBox text = (TextBox)grid.Rows[i].FindControl("TObservaciones");
            if (text.Text.Length != 0) {
                if (resultado.Length > 0)
                    resultado += ", ";
                resultado += string.Format("<b>{0}: </b> {2}", check.Text, check.Checked ? "X" : "_", text.Text);
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
            Label nombre= (Label)grid.Rows[i].FindControl("LNombre");
            CheckBox nor = (CheckBox)grid.Rows[i].FindControl("CNor");
            CheckBox pat = (CheckBox)grid.Rows[i].FindControl("CPat");
            TextBox text = (TextBox)grid.Rows[i].FindControl("TObservaciones");
            if (text.Text.Length != 0)
            {
                if (resultado.Length > 0)
                    resultado += "<br/>";
                string check= "";
                if(nor.Checked)
                    check="Nor";
                if (pat.Checked)
                {
                    if (check.Length > 0)
                        check += ",";
                    check += "Pat";
                }
                if (check.Length == 0)
                    check = "_";
                resultado += string.Format("<b>{0}</b> ({1}) {2}.", nombre.Text, check, text.Text);
            }
        }
        if (resultado=="")
            resultado = grid.EmptyDataText;
        return resultado;
    }

    protected string ImprimirPlanEducativo() {
        
        string resultado = "";
        RPlanEducativo.DataBind();
        for (int i = 0; i < RPlanEducativo.Items.Count; i++) {
            CheckBox check= (CheckBox)RPlanEducativo.Items[i].FindControl("CSi");
            if (check.Checked)
            {
                if (resultado.Length > 0)
                    resultado += ", ";
                resultado += check.Text;
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
        evento.Contenido = evento.Contenido.Replace("$szExamenFisico$", ImprimirGridTipo2(GExamenFisico));
        evento.Contenido = evento.Contenido.Replace("$szPlanEducativo$", ImprimirPlanEducativo());
        

        evento.Contenido = evento.Contenido.Replace("$szPlanManejo$", "<ol><li>" + HttpUtility.HtmlEncode(TPlanManejo.Text).Replace("\n", "</li><li>") + "</li></ol>");
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());

        foreach (Calificacion.Escalas escala in (Calificacion.Escalas[])Enum.GetValues(typeof(Calificacion.Escalas)))
        {
            evento.Contenido = evento.Contenido.Replace("$sz" + escala.ToString() + "$", Calificacion.GetCalificacionYDescripcion(CCDetallePaciente.IdPaciente, TFecha.Text, escala));
        }

        using (CConector conector = new CConector())
        {
            Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
            evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
            evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

            Query query = new Query("recurso_humano");

            query["szProfesional"] = "recurso_humano.perDocumento";
            query["szCargo"] = "cargo.carDescripcion";

            MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(TIdFuncionario.Text), " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", conector.QueryString("SELECT id FROM usuario WHERE personal=" + Query.GetValor(TIdFuncionario.Text)));
        }
        // limpiamos el inactivo de los pacientes
        evento.Contenido = evento.Contenido.Replace(" (Inactivo)", "");
    }

    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/paciente/evolucion.aspx?pid=" + CCDetallePaciente.IdPaciente + "&evolid=" + ((ImageButton)sender).CommandArgument);
    }
    protected void GEvoluciones_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            e.Row.Cells[2].Text = Funcionario.GetFuncionario(e.Row.Cells[2].Text).Nombres;
        }
    }
    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            if (conector.QueryMod("DELETE FROM antecedentes_evolucion WHERE evolucion_paciente=" + HIdEvolucion.Value) == -1)
                return;
            if (conector.QueryMod("DELETE FROM examen_evolucion WHERE evolucion_paciente=" + HIdEvolucion.Value) == -1)
                return;
            if (conector.QueryMod("DELETE FROM codigos_evolucion WHERE evolucion_paciente=" + HIdEvolucion.Value) == -1)
                return;
            if (conector.QueryMod("DELETE FROM evolucion_paciente WHERE id=" + HIdEvolucion.Value) == -1)
                return;
            conector.Commit();
            Response.Redirect(Request.Url.AbsolutePath);
        }
    }
}
