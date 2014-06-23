using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Globalization;

public partial class facturacion_facturacioninsumos : System.Web.UI.Page
{
    int valor_servicios = 0;
    public static int m_nAlmacen = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        SResultados.SelectCommand = String.Format(SResultados.SelectCommand, m_nAlmacen, m_nAlmacen);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            // para el filtro por usuarios.
            THasta.Text = DateTime.Now.ToShortDateString();
            TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            if (((MasterPageI)Master).RestoreState())
            {
                BBuscar_Click(sender, e);
            }
        }
    }

    protected void Totalizar(List<GridViewRow> rows, string columna)
    {
        int col = Utilidades.GetGridColumnIndex(GResultados, columna);
        if(GResultados.FooterRow!=null) 
            GResultados.FooterRow.Cells[col].Text = rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : Convert.ToInt32(x.Cells[col].Text)).ToString();
    }

    protected void TotalizarDinero(List<GridViewRow> rows, string columna)
    {
        int col = Utilidades.GetGridColumnIndex(GResultados, columna);
        if(GResultados.FooterRow!=null) 
            GResultados.FooterRow.Cells[col].Text = string.Format("{0:C0}", rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : decimal.Parse(x.Cells[col].Text, NumberStyles.Currency)));
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        GResultados.DataSourceID = "SResultados";

        if (Utilidades.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Imprimir("gastos.html", true);
            List<GridViewRow> rows = GResultados.Rows.Cast<GridViewRow>().ToList();
            Totalizar(rows, "Cantidad");
            TotalizarDinero(rows, "Costo");
            TotalizarDinero(rows, "Precio");
            TotalizarDinero(rows, "Utilidad");
        }
        else
        {
            ((MasterPageI)Master).Imprimir((string)null);
        }
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
        }
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        evento.Contenido = evento.Contenido.Replace("$szEntidad$", Entidad.GetEntidad(Paciente.GetPaciente(UCPaciente.IdPaciente).entidadId).Nombre);

        Utilidades.GetGridColumn(GResultados, "Costo").Visible = false;
        Utilidades.GetGridColumn(GResultados, "Utilidad").Visible = false;
    }

    protected void TFactura_TextChanged(object sender, EventArgs e)
    {

        ViewState["factura"] = null;
        TVencimientoF.Text =
            TPago.Text =
            TRadicacion.Text =
            LVFactura.Text =
            TFFactura.Text = "";

        if (TFactura.Text.Length == 0)
            return;

        using (CConector conector = new CConector())
        {

            Query query = new Query("factura");

            query += "factura.fecha";
            query += "factura.radicacion";
            query += "factura.vencimiento";
            query += "factura.pago";
            query["valor"] = "SUM(facturacion_autorizacion_servicio.valor)";

            MySqlDataReader reader = conector.Query(query.GetSelect("factura.factura=" + Query.GetValor(TFactura.Text) + " GROUP BY factura.factura"
                                                        , @"LEFT JOIN facturacion_autorizacion ON (facturacion_autorizacion.factura=factura.factura)
                                                        LEFT JOIN facturacion_autorizacion_servicio ON (facturacion_autorizacion_servicio.autorizacion=facturacion_autorizacion.autorizacion)"));
            if (reader != null && reader.Read())
            {

                ViewState["factura"] = TFactura.Text;
                TFFactura.Text = Query.GetFromMySQLDate(reader["fecha"]);
                TRadicacion.Text = Query.GetFromMySQLDate(reader["radicacion"]);
                TPago.Text = Query.GetFromMySQLDate(reader["pago"]);
                TVencimientoF.Text = Query.GetFromMySQLDate(reader["vencimiento"]);
                try
                {
                    decimal valor = Convert.ToDecimal(reader["valor"]);
                    LVFactura.Text = string.Format("{0:C0}", valor);
                    ScriptManager.RegisterClientScriptBlock(PTodo, typeof(string), "valorf", "valor_factura=" + (valor - valor_servicios).ToString(CultureInfo.InvariantCulture) + ";", true);
                }
                catch { }
            }
        }
    }
    protected void BD_OnClicked(object sender, EventArgs e)
    {
        PDevolucion.Visible = TDevolucion.Text.Length > 0;
        BADevolucion.Enabled = Usuario.GetInstance().CanInsert();
    }

    protected void BADevolucion_Click(object sender, EventArgs e)
    {

        if (!IsValid)
            return;

        // la factura tiene que existir.
        if (string.IsNullOrEmpty((string)ViewState["factura"]))
            return;

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            Query query = new Query("factura_devolucion");
            string id = GDevoluciones.SelectedValue.ToString();

            query["factura"] = TFactura.Text;
            query["antigua_radicacion"] = Query.GetMySQLDateFormat(TRadicacion.Text);
            query["devolucion"] = Query.GetMySQLDateFormat(TDevolucion.Text);

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                id = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(id))) == -1)
                    return;
            }

            query = new Query("factura_causal_devolucion");

            if (conector.QueryMod(query.GetDelete("factura_devolucion=" + Query.GetValor(id))) == -1)
                return;

            query["factura_devolucion"] = id;

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

            // insertamos la factura
            if (GDevoluciones.SelectedIndex == -1)
            {
                query = new Query("factura");

                query["radicacion"] = "";

                if (conector.QueryMod(query.GetUpdate("factura=" + Query.GetValor(TFactura.Text))) == -1)
                    return;
            }

            ViewState["radicacion"] = null;
            BCDevolucion_Click(sender, e);
            conector.Commit();

            GDevoluciones.DataBind();
        }
    }

    protected void BCDevolucion_Click(object sender, EventArgs e)
    {

        TRadicacion.Text = (string)ViewState["radicacion"];
        GDevoluciones.SelectedIndex = -1;
        TDevolucion.Text = "";
        GDevolucion.DataBind();
        BD_OnClicked(sender, e);
    }

    protected void GDevoluciones_SelectedIndexChanged(object sender, EventArgs e)
    {

        ViewState["radicacion"] = TRadicacion.Text;

        TRadicacion.Text = Utilidades.GetGridCellText(GDevoluciones, "Radicación", GDevoluciones.SelectedIndex);
        TDevolucion.Text = Utilidades.GetGridCellText(GDevoluciones, "Devolución", GDevoluciones.SelectedIndex);
        BD_OnClicked(sender, e);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        /*LError.Text = "";

        if (!IsValid)
            return;

        using (CConector conector = new CConector())
        {

            conector.StartTransaction();

            string id = (string)ViewState["autorizacion"];
            Query query = new Query("facturacion_autorizacion");

            query["factura"] = TFactura.Text;
            query["glosa_conciliacion"] = Query.GetMySQLDateFormat(TConciliacion.Text);
            query["entidad"] = UCPaciente.IdAsegurador;
            query["paciente"] = UCPaciente.IdPaciente;

            if (string.IsNullOrEmpty(id))
            {
                query["autorizacion"] = HIdAutorizacion.Value;
                if (conector.QueryMod(query.GetInsert()) == -1)
                {
                    return;
                }
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("autorizacion=" + Query.GetValor(id))) == -1)
                {
                    return;
                }
            }
            if (conector.InsertModificacion(HId.Value) == -1)
                return;

            // insertamos la factura
            query = new Query("factura");

            query["fecha"] = Query.GetMySQLDateFormat(TFFactura.Text);
            query["radicacion"] = Query.GetMySQLDateFormat(TRadicacion.Text);
            query["vencimiento"] = Query.GetMySQLDateFormat(TVencimientoF.Text);
            query["pago"] = Query.GetMySQLDateFormat(TPago.Text);

            if (string.IsNullOrEmpty((string)ViewState["factura"]))
            {
                query["factura"] = TFactura.Text;
                if (conector.QueryMod(query.GetInsert()) == -1)
                    return;
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("factura=" + Query.GetValor(TFactura.Text))) == -1)
                    return;
            }

            query = new Query("facturacion_autorizacion_servicio");

            if (conector.QueryMod(query.GetDelete("autorizacion=" + Query.GetValor(HIdAutorizacion.Value))) == -1)
                return;
            query["autorizacion"] = HIdAutorizacion.Value;
            foreach (GridViewRow row in GActivades.Rows)
            {

                query["procedimiento"] = GActivades.DataKeys[row.RowIndex].Values["actId"].ToString();
                query["intensidad"] = GActivades.DataKeys[row.RowIndex].Values["intensidad"].ToString();
                query["cantidad"] = ((TextBox)row.FindControl("TC")).Text;
                query["valor"] = ((TextBox)row.FindControl("TV")).Text.Replace(",", "").Replace("$", "");
                query["autorizado"] = GActivades.DataKeys[row.RowIndex].Values["autNumSesiones"].ToString();

                if (conector.QueryMod(query.GetInsert()) == -1)
                    return;
            }

            query = new Query("facturacion_autorizacion_glosa");

            if (conector.QueryMod(query.GetDelete("autorizacion=" + Query.GetValor(HIdAutorizacion.Value))) == -1)
                return;
            query["autorizacion"] = HIdAutorizacion.Value;

            foreach (GridViewRow row in GGlosa.Rows)
            {
                if (((CheckBox)row.FindControl("CC")).Checked)
                {

                    query["causal"] = GGlosa.DataKeys[row.RowIndex].Value.ToString();
                    query["valor"] = ((TextBox)row.FindControl("TV")).Text.Replace("$", "").Replace(",", "");
                    query["valor_aceptado"] = ((TextBox)row.FindControl("TA")).Text.Replace("$", "").Replace(",", "");
                    query["valor_soportado"] = ((TextBox)row.FindControl("TS")).Text.Replace("$", "").Replace(",", "");

                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                }
            }

            conector.Commit();
        }

        ((MasterPageI)Master).SetResultado("Número de autorización " + TNumero.Text + " editada.");*/
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
}
