using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using SDG.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Globalization;
using FileHelpers;

public partial class facturacion_facturactrl : System.Web.UI.UserControl
{
    public event EventHandler BAceptarClicked = null;
    public event EventHandler BCancelarClicked = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            Usuario usuario= Usuario.GetInstance();
            GDevoluciones.Columns[1].Visible = usuario.CanDelete();
        }
    }

    public void BAdd_Clicked(object sender, EventArgs e)
    {

        List<Autorizaciones> lista = (List<Autorizaciones>)ViewState["autorizaciones"];
        if (lista == null)
            lista = new List<Autorizaciones>();

        if (sender != null)
        {
            using (CConector conector = new CConector())
            {
                string factura = conector.QueryString("SELECT factura FROM facturacion_autorizacion WHERE autorizacion=" + Query.GetValor(TAutorizacionID.Text));
                if (!string.IsNullOrEmpty(factura))
                {

                    ScriptManager.RegisterClientScriptBlock(UA, typeof(string), "alert"
                        , string.Format("alert('Autorización {0} ya esta en la factura No. {1}');", TAutorizacionID.Text, factura)
                        , true);
                    return;
                }
            }
        }

        Autorizaciones autorizacion = new Autorizaciones(TAutorizacionID.Text);
        lista.Add(autorizacion);

        ViewState["autorizaciones"] = lista;
        GAutorizacion.DataSource = lista;
        HAutorizaciones.Value = "";
        foreach (Autorizaciones info in lista)
        {
            if (HAutorizaciones.Value.Length > 0)
                HAutorizaciones.Value += ",";
            HAutorizaciones.Value += info.Autorizacion;
        }
        GAutorizacion.DataBind();
        TAutorizacionID.Text = TAutorizacion.Text = "";
        TAutorizacion.Focus();
    }

    protected void A_DataBound(object sender, EventArgs e)
    {
	DropDownList drop = (DropDownList)sender;
        drop.SelectedIndex = -1;
        GridViewRow row = (GridViewRow)drop.Parent.Parent;
        string seleccion = null;
        try { seleccion = (string)ViewState[GDetalle.DataKeys[row.RowIndex].Values["_CodigoProducto"] + "_" + GDetalle.DataKeys[row.RowIndex].Values["Secuencia"]]; } catch { 
            if(row.DataItem!=null)
                seleccion = (string)ViewState[DataBinder.Eval(row.DataItem,"_CodigoProducto") + "_" + DataBinder.Eval(row.DataItem,"Secuencia")];
        }
        if (seleccion != null)
            Utilidades.SelectInDropDown(drop, seleccion);
    }

    protected void GAutorizacion_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

        e.Cancel = true;
        List<Autorizaciones> lista = (List<Autorizaciones>)ViewState["autorizaciones"];
        if (lista == null)
            lista = new List<Autorizaciones>();
        string autorizacion = GAutorizacion.DataKeys[e.RowIndex].Values["Autorizacion"].ToString();
        lista.RemoveAll(x => x.Autorizacion == autorizacion);

        ViewState["autorizaciones"] = lista;
        GAutorizacion.DataSource = lista;

        HAutorizaciones.Value = "";
        foreach (Autorizaciones info in lista)
        {
            if (HAutorizaciones.Value.Length > 0)
                HAutorizaciones.Value += ",";
            HAutorizaciones.Value += info.Autorizacion;
        }
        GAutorizacion.DataBind();
        TAutorizacionID.Text = TAutorizacion.Text = autorizacion;
        TAutorizacion.Focus();
    }

    public void BAceptar_Clicked(object sender, EventArgs e)
    {
        LMensaje.Text = "";
        if (!Page.IsValid)
            return;
        List<Autorizaciones> autorizaciones = (List<Autorizaciones>)ViewState["autorizaciones"];
        if (autorizaciones == null || autorizaciones.Count == 0)
        {
            LMensaje.Text = "Por favor ingrese por lo menos una autorización";
            return;
        }

        List<SIIGOFile> lista = (List<SIIGOFile>)ViewState["lista"];
        SIIGOFile factura = lista.Find(x => x.Documento.ToString() == HFactura.Value && x.TipoDocumentoCruze == "F" && x.DebitoCredito == "D");
        if (factura == null)
            return;

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            // insertamos la factura
            Query query = new Query("factura");

            query["fecha"] = Query.GetMySQLDateFormat(factura.Fecha);
            query["radicacion"] = Query.GetMySQLDateFormat(TRadicacion.Text);
            query["vencimiento"] = Query.GetMySQLDateFormat(TVencimientoF.Text);
            query["pago"] = Query.GetMySQLDateFormat(TPago.Text);
            query["factura"] = factura.Documento.ToString();
            FixedFileEngine engine = new FixedFileEngine(typeof(SIIGOFile));
            query["importacion"] = engine.WriteString(lista);
            query["valor"] = lista.Sum(x => x.ValorMovimiento).ToString(CultureInfo.InvariantCulture);

            if (conector.QueryMod(query.GetUpdate("factura=" + Query.GetValor(factura.Documento.ToString()))) == -1)
                return;
            if (conector.QueryMod(query.GetInsert().Replace("INSERT INTO ", "INSERT IGNORE INTO ")) == -1)
                return;

            if (conector.InsertModificacion(factura.Documento.ToString()) == -1)
                return;

            query = new Query("factura_glosa");

            if (conector.QueryMod(query.GetDelete("factura=" + Query.GetValor(HFactura.Value))) == -1)
                return;
            query["factura"] = HFactura.Value;

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

            foreach (Autorizaciones autorizacion in autorizaciones)
            {
                query = new Query("facturacion_autorizacion");

                query["factura"] = factura.Documento.ToString();
                query["glosa_conciliacion"] = Query.GetMySQLDateFormat(TConciliacion.Text);
                query["entidad"] = Paciente.GetPaciente(autorizacion.IdPaciente).entidadId;
                query["paciente"] = autorizacion.IdPaciente;
                query["autorizacion"] = autorizacion.Autorizacion;

                if (conector.QueryMod(query.GetUpdate("autorizacion=" + Query.GetValor(autorizacion.Autorizacion))) == -1)
                    return;
                if (conector.QueryMod(query.GetInsert().Replace("INSERT INTO ", "INSERT IGNORE INTO ")) == -1)
                    return;

                query = new Query("facturacion_autorizacion_servicio");

                if (conector.QueryMod(query.GetDelete("autorizacion=" + Query.GetValor(autorizacion.Autorizacion))) == -1)
                    return;

                query["autorizacion"] = autorizacion.Autorizacion;

                foreach (GridViewRow row in GDetalle.Rows)
                {
                    DropDownList drop = (DropDownList)row.FindControl("A");
                    if (drop.SelectedValue.Length == 0)
                        continue;
                    string[] valores = drop.SelectedValue.Split(';');
                    if (autorizacion.Autorizacion != valores[0]) // es otra autorizacion
                        continue;
                    string idProcedimiento = valores[1];
                    string cantidad = valores[2];

                    query["procedimiento"] = idProcedimiento;
                    query["cantidad"] = ((decimal)GDetalle.DataKeys[row.RowIndex].Values["Cantidad"]).ToString(CultureInfo.InvariantCulture);
                    query["valor"] = ((decimal)GDetalle.DataKeys[row.RowIndex].Values["_ValorMovimiento"]).ToString(CultureInfo.InvariantCulture);
                    query["autorizado"] = cantidad;
                    query["secuencia"] = GDetalle.DataKeys[row.RowIndex].Values["Secuencia"].ToString();
                    query["codigoSIIGO"] = GDetalle.DataKeys[row.RowIndex].Values["_CodigoProducto"].ToString();

                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                }
            }
            conector.Commit();
            LMensaje.Text = "Se ha editado la factura número " + factura.Documento.ToString();
            if (BAceptarClicked != null)
                BAceptarClicked(sender, e);
            BCancelar_Clicked(sender, e);
        }

    }

    public void BCancelar_Clicked(object sender, EventArgs e)
    {
        if (BCancelarClicked != null)
            BCancelarClicked(sender, e);
    }

    public void SetFactura(int NumeroFactura, List<SIIGOFile> lista, bool existe=false) {

        ViewState.Clear(); // limpiamos todo el viewstate
        GAutorizacion.DataBind();
        HAutorizaciones.Value = "";
        TAutorizacion.Text = TAutorizacionID.Text = "";
        TRadicacion.Text = TVencimientoF.Text = TDevolucion.Text = TPago.Text = "";
        PDevolucion.Visible = false;
        PDevoluciones.Visible = LDevolucion.Visible = TDevolucion.Visible = existe;
        LFactura.Visible = !existe;

        decimal valor = lista.Sum(x=>x.ValorMovimiento);
        lista = lista.Where(x => x.Documento == NumeroFactura).ToList(); // limpiamos y solo dejamos el que necesitamos
        HFactura.Value= NumeroFactura.ToString();
        ViewState["lista"] = lista;
        SIIGOFile factura = lista.Find(x => x.Documento == NumeroFactura && x.TipoDocumentoCruze == "F" && x.DebitoCredito == "D");
        if (factura == null)
            return;

        using (CConector conector = new CConector())
        {
            Query query = new Query("facturacion_autorizacion");

            query += "autorizacion";
            query += "glosa_conciliacion";

            MySqlDataReader reader = conector.Query(query.GetSelect("factura=" + Query.GetValor(factura.Documento.ToString())));
            if (reader != null)
            {
                while (reader.Read())
                {
                    TAutorizacionID.Text = reader["autorizacion"].ToString();
                    TConciliacion.Text= Query.GetFromMySQLDate(reader["glosa_conciliacion"]);
                    BAdd_Clicked(null, null);
                }
            }

            query = new Query("factura");

            query += "radicacion";
            query += "vencimiento";
            query += "pago";

            reader = conector.Query(query.GetSelect("factura=" + Query.GetValor(factura.Documento.ToString())));
            if (reader != null && reader.Read())
            {
                TRadicacion.Text = Query.GetFromMySQLDate(reader["radicacion"]);
                TVencimientoF.Text = Query.GetFromMySQLDate(reader["vencimiento"]);
                TPago.Text = Query.GetFromMySQLDate(reader["pago"]);
                PGlosa.Visible = TPago.Text.Length > 0;
                ViewState["factura"] = NumeroFactura.ToString();
            }

            query = new Query("facturacion_autorizacion_servicio");

            query += "secuencia";
            query += "codigoSIIGO";
            query += "procedimiento";
            query += "autorizado";

            List<Autorizaciones> autorizaciones = (List<Autorizaciones>)ViewState["autorizaciones"];
            if (autorizaciones == null)
                autorizaciones = new List<Autorizaciones>();

            foreach (Autorizaciones autorizacion in autorizaciones)
            {
                reader = conector.Query(query.GetSelect("autorizacion=" + Query.GetValor(autorizacion.Autorizacion)));
                if (reader != null)
                {
                    while (reader.Read())
                    {

                        ViewState[reader["codigoSIIGO"].ToString() + "_" + reader["secuencia"].ToString()] = autorizacion.Autorizacion.ToString() + ";" + reader["procedimiento"].ToString() + ";" + reader["autorizado"].ToString();
                    }
                }
            }
        }

        lista=  lista.Where(x => x.Documento == factura.Documento && x.DebitoCredito == "C" && x.Cantidad != 0).ToList();
        GDetalle.DataSource = lista;
        GDetalle.DataBind();

        if (GDetalle.FooterRow != null) {

            GDetalle.FooterRow.Cells[GDetalle.GetGridColumnIndex("Cantidad")].Text = lista.Sum(x => x.Cantidad).ToString();
            GDetalle.FooterRow.Cells[GDetalle.GetGridColumnIndex("Valor")].Text= lista.Sum(x=>x._ValorMovimiento).ToString("C0");
            GDetalle.FooterRow.Cells[GDetalle.GetGridColumnIndex("Descripción")].Text = lista.Count.ToString();
        }

        LFecha.Text = factura.Fecha.ToShortDateString();
        LValor.Text = string.Format("{0:C0}", valor);

        LFactura.Text = "Factura No. " + factura.Documento;
    }

    protected void BD_OnClicked(object sender, EventArgs e)
    {
        PDevolucion.Visible = TDevolucion.Text.Length > 0;
        PGlosa.Visible = TPago.Text.Length > 0;
        BADevolucion.Enabled = Usuario.GetInstance().CanInsert();
    }

    protected void BADevolucion_Click(object sender, EventArgs e)
    {

        if (!Page.IsValid)
            return;

        // la factura tiene que existir.
        if (string.IsNullOrEmpty((string)ViewState["factura"]))
            return;

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            Query query = new Query("factura_devolucion");
            string id = GDevoluciones.SelectedIndex==-1 ? null : GDevoluciones.SelectedValue.ToString();

            query["factura"] = HFactura.Value;
            query["antigua_radicacion"] = Query.GetMySQLDateFormat(TRadicacion.Text);
            query["devolucion"] = Query.GetMySQLDateFormat(TDevolucion.Text);

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                id = res.ToString();
            } else {
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
                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                }
            }

            // insertamos la factura
            if (GDevoluciones.SelectedIndex == -1)
            {
                query = new Query("factura");

                query["radicacion"] = "";

                if (conector.QueryMod(query.GetUpdate("factura=" + Query.GetValor(HFactura.Value))) == -1)
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

        TRadicacion.Text = GDevoluciones.GetGridCellText("Radicación", GDevoluciones.SelectedIndex);
        TDevolucion.Text = GDevoluciones.GetGridCellText("Devolución", GDevoluciones.SelectedIndex);
        BD_OnClicked(sender, e);
    }
}
