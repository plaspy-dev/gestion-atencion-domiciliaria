using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Globalization;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Collections.Specialized;

public partial class facturacion_facturacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PPaciente.Visible = false;
            TNumero.Focus();
            GPagos.Visible = false;
            GActivades.DataBind();

            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            ViewState["entidades"] = usuario["entidades"];
            using (CConectorMS conector = new CConectorMS())
            {
                if (Request.QueryString["aut"] != null)
                {
                    Query query = new Query("phdAutorizacion");

                    query += "autNumero";
                    query += "pacId";
                    query += "autFecha";
                    query += "autFechaVenc";
                    query += "total";
                    query += "autObservaciones";
                    query += "entId";
                    query += "autActivo";
                    query += "autFechaSuspension";
                    query += "id";
                    query += "formulacion";

                    SqlDataReader reader = conector.Query(query.GetSelect("autNumero=" + Query.GetValor(Request.QueryString["aut"])));
                    if (reader != null && reader.Read())
                    {

                        GPagos.Visible = true;
                        BAceptar.Enabled = usuario.CanUpdate();

                        GPagos.Columns[0].Visible = usuario.CanUpdate();
                        GPagos.Columns[1].Visible = usuario.CanDelete();

                        HIdAutorizacion.Value = Request.QueryString["aut"];
                        HId.Value = reader["id"].ToString();
                        ((MasterPageI)Master).SetModificacion(HId.Value);

                        HIdEntidad.Value = reader["entId"].ToString();
                        TNumero.Text = reader["autNumero"].ToString();
                        TPaciente.Text = reader["pacId"].ToString();
                        TFecha.Text = reader["autFecha"].ToString();
                        TVencimiento.Text = reader["autFechaVenc"].ToString();
                        TValor.Text = reader["total"].ToString();
                        TObservaciones.Text = reader["autObservaciones"].ToString();

                        if (reader["autActivo"].ToString().ToLower() == "false")
                        {
                            if (reader["autFechaSuspension"].ToString().Length == 0)
                                LEstado.Text = "Anulada";
                            else LEstado.Text = "Suspendida hasta el " + Query.GetFromMySQLDate(reader["autFechaSuspension"]);
                        }
                        else
                        {
                            if (reader["autFechaVenc"].ToString() != "")
                            {
                                DateTime vencimiento = (DateTime)reader["autFechaVenc"];
                                if (vencimiento == null)
                                {
                                    vencimiento = (DateTime)reader["autFecha"];
                                    vencimiento = vencimiento.AddDays(30);
                                }
                                LEstado.Text = DateTime.Now.Date > vencimiento ? "Vencida" : "Activa";
                            }
                        }
                        GActivades.DataBind();
                        BIr_Click(sender, e);

                        BAceptar.Enabled = Usuario.GetInstance().CanInsert();

                        using(CConector conectormy= new CConector()) {
                            query = new Query("facturacion_autorizacion");

                            query += "autorizacion";
                            query += "factura";
                            query += "fecha";
                            query += "radicacion";
                            query += "vencimiento";
                            query += "segunda_radicacion";
                            query += "pago";
                            query += "devolucion";
                            query += "glosa_conciliacion";

                            MySqlDataReader readermy = conectormy.Query(query.GetSelect("autorizacion=" + Query.GetValor(Request.QueryString["aut"])));
                            if (readermy != null && readermy.Read()) {

                                BAceptar.Enabled = Usuario.GetInstance().CanUpdate();
                                ViewState["autorizacion"] = readermy["autorizacion"].ToString();
                                TFactura.Text = readermy["factura"].ToString();
                                TFFactura.Text = Query.GetFromMySQLDate(readermy["fecha"]);
                                TRadicacion.Text = Query.GetFromMySQLDate(readermy["radicacion"]);
                                TVencimientoF.Text = Query.GetFromMySQLDate(readermy["vencimiento"]);
                                TSegundaR.Text = Query.GetFromMySQLDate(readermy["segunda_radicacion"]);
                                TPago.Text = Query.GetFromMySQLDate(readermy["pago"]);
                                TDevolucion.Text = Query.GetFromMySQLDate(readermy["devolucion"]);
                                TConciliacion.Text = Query.GetFromMySQLDate(readermy["glosa_conciliacion"]);
                            }
                        }
                    }
                }
            }

        }
    }
    
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        LError.Text = "";

        if (!IsValid)
            return;

        using (CConector conector = new CConector()) {

            conector.StartTransaction();

            string id = (string)ViewState["autorizacion"];
            Query query = new Query("facturacion_autorizacion");
            
            query["factura"]= TFactura.Text;
            query["fecha"]= Query.GetMySQLDateFormat(TFFactura.Text);
            query["radicacion"]= Query.GetMySQLDateFormat(TRadicacion.Text);
            query["vencimiento"]= Query.GetMySQLDateFormat(TVencimientoF.Text);
            query["segunda_radicacion"]= Query.GetMySQLDateFormat(TSegundaR.Text);
            query["pago"]= Query.GetMySQLDateFormat(TPago.Text);
            query["devolucion"]= Query.GetMySQLDateFormat(TDevolucion.Text);
            query["glosa_conciliacion"]= Query.GetMySQLDateFormat(TConciliacion.Text);
            query["entidad"] = Paciente.GetPaciente(HIdPaciente.Value).entidadId;
            query["paciente"] = HIdPaciente.Value;

            if (string.IsNullOrEmpty(id))
            {
                query["autorizacion"] = HIdAutorizacion.Value;
                if (conector.QueryMod(query.GetInsert()) == -1)
                {
                    return;
                }
            } else {
                if (conector.QueryMod(query.GetUpdate("autorizacion=" + Query.GetValor(id))) == -1) {
                    return;
                }
            }
            if (conector.InsertModificacion(HId.Value) == -1)
                return;

            query = new Query("facturacion_autorizacion_servicio");

            if (conector.QueryMod(query.GetDelete("autorizacion=" + Query.GetValor(HIdAutorizacion.Value))) == -1)
                return;
            query["autorizacion"] = HIdAutorizacion.Value;
            foreach(GridViewRow row in GActivades.Rows) {

                query["procedimiento"] = GActivades.DataKeys[row.RowIndex].Values["actId"].ToString();
                query["intensidad"] = GActivades.DataKeys[row.RowIndex].Values["intensidad"].ToString();
                query["cantidad"]= ((TextBox)row.FindControl("TC")).Text;
                query["valor"] = ((TextBox)row.FindControl("TV")).Text.Replace(",", "").Replace("$", "");
                query["autorizado"] = GActivades.DataKeys[row.RowIndex].Values["autNumSesiones"].ToString();

                if (conector.QueryMod(query.GetInsert()) == -1)
                    return;
            }

            query = new Query("facturacion_autorizacion_glosa");

            if (conector.QueryMod(query.GetDelete("autorizacion=" + Query.GetValor(HIdAutorizacion.Value))) == -1)
                return;
            query["autorizacion"] = HIdAutorizacion.Value;

            foreach (GridViewRow row in GGlosa.Rows) {
                if (((CheckBox)row.FindControl("CC")).Checked) {
                    
                    query["causal"] = GGlosa.DataKeys[row.RowIndex].Value.ToString();
                    query["valor"] = ((TextBox)row.FindControl("TV")).Text.Replace("$", "").Replace(",", "");
                    query["valor_aceptado"] = ((TextBox)row.FindControl("TA")).Text.Replace("$", "").Replace(",", "");
                    query["valor_soportado"] = ((TextBox)row.FindControl("TS")).Text.Replace("$", "").Replace(",", "");
                    
                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                }
            }

            query = new Query("facturacion_autorizacion_devolucion");

            if (conector.QueryMod(query.GetDelete("autorizacion=" + Query.GetValor(HIdAutorizacion.Value))) == -1)
                return;
            query["autorizacion"] = HIdAutorizacion.Value;

            foreach (GridViewRow row in GDevolucion.Rows)
            {
                if (((CheckBox)row.FindControl("CC")).Checked)
                {
                    query["causal"] = GDevolucion.DataKeys[row.RowIndex].Value.ToString();
                    query["valor"] = ((TextBox)row.FindControl("TV")).Text.Replace("$", "").Replace(",", "");

                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                }
            }

            conector.Commit();
        }

        ((MasterPageI)Master).SetResultado("Número de autorización " + TNumero.Text + " editada.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BIr_Click(object sender, EventArgs e)
    {
        string id = TPaciente.Text;

        HIdPaciente.Value = "";
        LCategoria.Text = "";
        LPorcentaje.Text = "";
        LMaximoServicio.Text = "";
        LMaximoano.Text = "";
        LNombrePaciente.Text = "";
        HIdEntidad.Value = "";
        LInactivo.Visible = false;
        PAutorizaciones.Visible = false;

        Paciente paciente = Paciente.GetPaciente(id);

        PDatos.Visible = false;
        {
            PDatos.Visible = true;
            double maximo = 0;
            PPaciente.Visible = true;
            HIdPaciente.Value = id;
            HIdEntidad.Value = paciente.entidadId;

            TPaciente.Text = paciente.documento;
            LNombrePaciente.Text = paciente.NombreCompleto;

            LInactivo.Visible = !paciente.Activo;

            LEntidad.Text = paciente.NombreEntidad;
            CultureInfo culture = new CultureInfo("en-US");

            if (paciente.Categoria != "")
            {

                using (CConector conectormysql = new CConector())
                {
                    MySqlDataReader rtopes = conectormysql.Query("SELECT varios.nombre AS categoria,topes.nombre AS por, topes.descripcion AS tser, topes.szReservado AS tano "
                                                            + " FROM varios"
                                                            + " LEFT JOIN varios AS topes ON (topes.tipo=14 AND topes.parametro1=varios.id)"
                                                            + " WHERE varios.id=" + paciente.Categoria);
                    if (rtopes != null && rtopes.Read())
                    {
                        LCategoria.Text = "<b>" + rtopes["categoria"].ToString() + "</b>";
                        LPorcentaje.Text = string.Format("{0:p}", Convert.ToDouble(rtopes["por"].ToString(), culture.NumberFormat) / 100);
                        LMaximoServicio.Text = string.Format("{0:c}", Convert.ToDouble(rtopes["tser"].ToString(), culture.NumberFormat));
                        maximo = Convert.ToDouble(rtopes["tano"].ToString(), culture.NumberFormat);
                        LMaximoano.Text = string.Format("{0:c}", maximo);
                    }
                }
            }
            if (paciente.TipoAfiliacion != "")
            {
                if (LCategoria.Text.Length > 0)
                    LCategoria.Text += "/";
                LCategoria.Text += (paciente.TipoAfiliacion == "1" ? "Cotizante" : "Beneficiario");
            }

            TFecha.Focus();
            GAutorizaciones.DataBind();
            LAutorizaciones.Text = GAutorizaciones.Rows.Count + " Autorizaci";
            LAutorizaciones.Text += GAutorizaciones.Rows.Count == 1 ? "ón" : "ones";
            PAutorizaciones.Visible = GAutorizaciones.Rows.Count > 0;

            using (CConectorMS conector = new CConectorMS())
            {
                string valor = conector.QueryString("SELECT SUM(valor) FROM pago_autorizacion LEFT JOIN phdAutorizacion ON (phdAutorizacion.autNumero=pago_autorizacion.autNumero) WHERE pacId=" + HIdPaciente.Value + " AND YEAR(phdAutorizacion.autFecha)=YEAR(GETDATE())");
                if (valor == "")
                    valor = "0";
                maximo -= Convert.ToDouble(valor, culture.NumberFormat);
                LAcumulado.Text = string.Format("{0:c}", Convert.ToDouble(valor, culture.NumberFormat));
            }
        }
    }

    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/facturacion/facturacion.aspx?aut=" + ((ImageButton)sender).CommandArgument);
    }

    protected void GActividades_RowDataBound(object sender, GridViewRowEventArgs e) {

        if (e.Row.RowIndex != -1) {
            TableCell cell = e.Row.Cells[Utilidades.GetGridColumnIndex(GActivades, "Intensidad")];
            cell.Text = Procedimientos.GetVarios(cell.Text);

            cell = e.Row.Cells[Utilidades.GetGridColumnIndex(GActivades, "Actividad")];
            cell.Text = Procedimientos.GetProcedimiento(cell.Text);

            using (CConector conector = new CConector())
            {
                Query query = new Query("facturacion_autorizacion_servicio");

                query += "valor";
                query += "cantidad";

                MySqlDataReader reader = conector.Query(query.GetSelect(string.Format("autorizacion={0} AND procedimiento={1} AND intensidad={2}"
                                                                    , Query.GetValor(HIdAutorizacion.Value)
                                                                    , Query.GetValor(GActivades.DataKeys[e.Row.RowIndex].Values["actId"].ToString())
                                                                    , Query.GetValor(GActivades.DataKeys[e.Row.RowIndex].Values["intensidad"].ToString())
                                                                    )));
                if (reader != null && reader.Read()) {
                    ((TextBox)e.Row.FindControl("TC")).Text = reader["cantidad"].ToString();
                    try { ((TextBox)e.Row.FindControl("TV")).Text = Convert.ToDecimal(reader["valor"]).ToString(CultureInfo.InvariantCulture); } catch {}
                }
            }
        }
    }

    protected void GAutorizaciones_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {

            int pos = e.Row.Cells[3].Text.IndexOf("%%");
            while (pos != -1)
            {

                string texto = "";
                for (int i = pos + 2; i < e.Row.Cells[3].Text.Length; i++)
                {
                    if (e.Row.Cells[3].Text[i] == ' ')
                        break;
                    texto += e.Row.Cells[3].Text[i];
                }
                e.Row.Cells[3].Text = e.Row.Cells[3].Text.Replace("%%" + texto, Procedimientos.GetProcedimiento(texto));
                pos = e.Row.Cells[3].Text.IndexOf("%%");
            }
            e.Row.Cells[3].Text = e.Row.Cells[3].Text.Replace(",", "<br/>");
        }
    }
}
