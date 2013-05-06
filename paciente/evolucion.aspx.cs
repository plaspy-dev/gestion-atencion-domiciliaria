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
        CConectorMS conector = CConectorMS.GetConector();

        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
            BAceptar.Enabled = false;
            BMasCDiagnostico.Enabled = false;
            PEvoluciones.Visible = false;

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

                    BAceptar.Enabled = usuario.CanInsert();
                    BMasCDiagnostico.Enabled = usuario.CanInsert();

                    TFuncionario.Enabled = usuario.CanAdmin();
                    if (!usuario.CanAdmin())
                    {
                        if(usuario["personal"].Length==0)
                            BAceptar.Enabled = false;
                        else {
                            TIdFuncionario.Text = usuario["personal"];
                            TFuncionario.Text = conector.QueryString("SELECT perNombre FROM admPersonalHS WHERE perId='" +  TIdFuncionario.Text + "'");
                        }
                        PCIE10.Visible=conector.QueryString("SELECT carId FROM admPersonalHS WHERE perId='" + TIdFuncionario.Text + "'") == "6";
                        TTA.Focus();
                    } else {
                        PCIE10.Visible = true;
                        TFuncionario.Focus();
                    }

                    Query qIngreso = new Query("evolucion_paciente");

                    qIngreso += "id";
                    qIngreso += "medico";
                    qIngreso += "hora";
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

                    CConector conectormysql = CConector.GetConector();
                    MySqlDataReader readermysql = conectormysql.Query(qIngreso.GetSelect("id=" + Query.GetValor(Request.QueryString["evolid"])));
                    if (readermysql != null && readermysql.Read())
                    {
                        BAceptar.Enabled = usuario.CanUpdate();
                        BMasCDiagnostico.Enabled = usuario.CanUpdate();
                        ((MasterPageI)Master).Imprimir("evolucion.html");

                        GCDiagnostico.Columns[0].Visible = usuario.CanUpdate();
                        GCDiagnostico.Columns[1].Visible = usuario.CanDelete();

                        HIdEvolucion.Value = readermysql["id"].ToString();
                        TIdFuncionario.Text= readermysql["medico"].ToString();

                        THora.Text = readermysql["hora"].ToString();
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
                        if (readermysql["fecha"] != DBNull.Value)
                            TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();
                        else TFecha.Text = "";
                        TPlanManejo.Text = readermysql["plan_manejo"].ToString();
                        TFuncionario.Text = conector.QueryString("SELECT perNombre FROM admPersonalHS WHERE perId='" + TIdFuncionario.Text + "'");

                        ((MasterPageI)Master).SetModificacion(HIdEvolucion.Value);
                    } else {

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
                        TPlanManejo.Text = conectormysql.QueryString("SELECT plan_manejo FROM evolucion_paciente WHERE paciente=" + CCDetallePaciente.IdPaciente + " ORDER BY fecha DESC LIMIT 1");
                    }
                    
                    GEvoluciones.DataBind();
                    LEvoluciones.Text = GEvoluciones.Rows.Count + " Evoluci";
                    LEvoluciones.Text += GEvoluciones.Rows.Count == 1 ? "ón" : "ones";
                    PEvoluciones.Visible = GEvoluciones.Rows.Count > 0;
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        CConector conector = CConector.GetConector();
        Query qIngreso = new Query("evolucion_paciente");

        qIngreso["medico"] = TIdFuncionario.Text;
        qIngreso["hora"] = THora.Text;
        qIngreso["motivo"] = TMotivo.Text;
        qIngreso["datos_subjetivos"] = TDatosSubjetivos.Text;
        qIngreso["ta"] = TTA.Text;
        qIngreso["fc"] = TFC.Text;
        qIngreso["fr"] = TFR.Text;
        qIngreso["t"] = TT.Text;
        qIngreso["peso"] = TPeso.Text;
        qIngreso["analisis"]=TAnalisis.Text;
        qIngreso["fecha"] = CConector.GetDate(Convert.ToDateTime(TFecha.Text));
        qIngreso["plan_manejo"] = TPlanManejo.Text;
        qIngreso["saturacion"]= TSaturacion.Text;
        qIngreso["glucometria"]= TGlucometria.Text;

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
        string cie10="",cie102="", cie103="";

        MySqlDataReader reader= conector.Query("SELECT codigo FROM codigos_evolucion WHERE evolucion_paciente=" + HIdEvolucion.Value);
        if(reader!=null) {

            if(reader.Read()) {
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

        if (conector.QueryString("SELECT carId FROM admPersonalHS WHERE perId='" + TIdFuncionario.Text + "'") == "6") // medico
        {
            CConectorMS conectorms = new CConectorMS();
            if (conectorms.QueryMod("UPDATE phdPaciente SET megId=" + Query.GetValor(TIdFuncionario.Text) + ",cieCodDx=" + Query.GetValor(cie10) + ",cieCodDx_1=" + Query.GetValor(cie102) + ",cieCodDx_2=" + Query.GetValor(cie103) + " WHERE pacId=" + CCDetallePaciente.IdPaciente) == -1)
                return;
        }

        Paciente.RemovePaciente(CCDetallePaciente.IdPaciente);
        if (nuevaevolucion && (CCDetallePaciente.Edad == -1 || CCDetallePaciente.Edad > 14))
            Usuario.GetUsuario().SetForceURL("~/paciente/barthel.aspx?pid=" + CCDetallePaciente.IdPaciente, conector);
        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        ((MasterPageI)Master).SetResultado(mensaje);
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

        CConectorMS conector = new CConectorMS();

        string descripcion = conector.QueryString("SELECT cirDescripcion FROM phdCIE10 WHERE cieCodDx='" + codigo + "'");
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

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        // aqui modificamos el evento.Contenido
        evento.Contenido = evento.Contenido.Replace("$szAntecedentes$", Utilidades.RenderGrid(GAntecedentes, "border=0 cellspacing=0"));
        evento.Contenido = evento.Contenido.Replace("$szExamenFisico$", Utilidades.RenderGrid(GExamenFisico, "border=0 cellspacing=0"));

        evento.Contenido = evento.Contenido.Replace("$szPlanManejo$", "<ol><li>" + TPlanManejo.Text.Replace("\n", "</li><li>") + "</li></ol>");
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());

        CConectorMS conectorms = new CConectorMS();

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

        Query query = new Query("admPersonalHS");

        query["szProfesional"] = "admPersonalHS.perDocumento";
        query["szCargo"] = "admCargo.carDescripcion";

        SqlDataReader reader = conectorms.Query(query.GetSelect("perId=" + Query.GetValor(TIdFuncionario.Text), " LEFT JOIN admCargo ON (admCargo.carId=admPersonalHS.carId)"));
        if (reader != null)
        {
            bool l = reader.Read();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
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
            CConectorMS conector = new CConectorMS();
            e.Row.Cells[2].Text = conector.QueryString("SELECT perNombre FROM admPersonalHS WHERE perId='" + e.Row.Cells[2].Text + "'");
        }
    }
}
