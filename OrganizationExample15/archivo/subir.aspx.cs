using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class archivo_subir : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            BAceptar.Enabled = false;
            TFecha.Text = Query.GetFromMySQLDate(DateTime.Now.Date);

            using (CConector conector = new CConector())
            {
                if (Request.QueryString["pid"] != null)
                {
                    CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                    if (CCDetallePaciente.IdPaciente.Length == 0)
                    {
                        Response.Redirect(Request.Url.AbsolutePath);
                    } else {
                        ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                        TFactura.Focus();
                        CCDetallePaciente.Visible =
                        PDatos.Visible = true;

                        BAceptar.Enabled = usuario.CanInsert();
                        SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                        SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                        TFactura.Text = Request.QueryString["fn"];
                        TFactura_TextChanged(sender, e);
                    }
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using (CConector conector = new CConector()) {

            conector.StartTransaction();
            string factura = TFactura.Text;

            Query query = new Query("digitalizacion");

            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["paciente"] = CCDetallePaciente.IdPaciente;
            query["factura"] = string.IsNullOrEmpty(factura) ? "0" : factura;
            query["documento"] = CCDetallePaciente.Documento;
            query["tipo"] = "0";

            if (FFactura.HasFile)
            {
                string filename = TFactura.Text + "/" + FFactura.FileName;
                string file = Path.Combine(HomeCareVersion.FilesPath, "digitalizacion", filename);
                Directory.CreateDirectory(Path.GetDirectoryName(file));
                FFactura.SaveAs(file);
                query["factura_archivo"] = filename;

                if (conector.QueryMod(query.GetDelete("factura={0} AND tipo=0", Query.GetValor(TFactura.Text))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }

                if (conector.QueryMod(query.GetInsert(true)) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            } else {
                if (conector.QueryMod(query.GetUpdate("fecha={0} AND factura={1} AND paciente={2}"
                    , Query.GetValor(Query.GetMySQLDateFormat(TFecha.Text)), Query.GetValor(CCDetallePaciente.IdPaciente)
                    , Query.GetValor(TFactura.Text.Length > 0 ? TFactura.Text : "0"))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            if (string.IsNullOrEmpty(factura))
                factura = Query.GetMySQLDateFormat(TFecha.Text);

            foreach (RepeaterItem item in RArchivo.Items) {

                HiddenField hi= (HiddenField) item.FindControl("HI");
                FileUpload upload= (FileUpload)item.FindControl("FHistoria");

                if (upload.HasFile)
                {
                    string filename = factura + "/" + CCDetallePaciente.IdPaciente + "/" + upload.FileName;
                    string file = Path.Combine(HomeCareVersion.FilesPath, "digitalizacion", filename);
                    Directory.CreateDirectory(Path.GetDirectoryName(file));
                    upload.SaveAs(file);
                    query["archivo"] = filename;
                    query["tipo"] = hi.Value;

                    if (conector.QueryMod(query.GetDelete("factura={0} AND paciente={1} AND tipo={2} AND fecha={3}"
                        , Query.GetValor(TFactura.Text.Length>0 ? TFactura.Text : "0")
                        , Query.GetValor(CCDetallePaciente.IdPaciente)
                        , Query.GetValor(hi.Value)
                        , Query.GetValor(Query.GetMySQLDateFormat(TFecha.Text))
                        )) == -1) {
                        LMensaje.Text = conector.LastError;
                        return;
                    }

                    if (conector.QueryMod(query.GetInsert(true)) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                }
            }

            conector.Commit();
            ((MasterPageI)Master).SetResultado("Archivo ingresado");
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void TFactura_TextChanged(object sender, EventArgs e)
    {
        HFactura.Visible=
        // HHistoria.Visible=
        // RHistoria.Enabled = false;
        RFactura.Enabled = true;
        BEliminar.Visible = false;
        TFecha.ReadOnly = false;

        PFactura.Visible = TFactura.Text.Length > 0;
        if (string.IsNullOrEmpty(TFactura.Text))
            return;

        using (CConector conector = new CConector()) {

            CUsuario usuario= (CUsuario)Usuario.GetInstance();
            Query query = new Query("digitalizacion");

            query += "fecha";
            query += "archivo";
            query += "factura_archivo";

            // buscamos solo la factura
            MySqlDataReader reader = conector.Query(query.GetSelect("factura=" + Query.GetValor(TFactura.Text) + " AND tipo=0"));
            if (reader != null && reader.Read()) {

                HFactura.Text = Path.GetFileName(reader["factura_archivo"].ToString());
                HFactura.NavigateUrl = string.Format("~/archivo/archivo.ashx?n={0}&t=d", reader["factura_archivo"]);
                HFactura.Visible = HFactura.Text.Length > 0;

                TFecha.Text = Query.GetFromMySQLDate(reader["fecha"]);
                TFecha.ReadOnly = usuario.CanUpdate();
                // RHistoria.Enabled = true;
                RFactura.Enabled = false;
                FFactura.Enabled = usuario.CanUpdate();
            }
        }
    }

    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            Query query = new Query("digitalizacion");

            if (conector.QueryMod(query.GetDelete("factura={0} AND paciente={1}", null
                , Query.GetValor(TFactura.Text.Length>0 ? TFactura.Text : "0"), Query.GetValor(CCDetallePaciente.IdPaciente)
                , Query.GetValor(Query.GetMySQLDateFormat(TFecha.Text))
                )) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            ((MasterPageI)Master).SetResultado("Archivos eliminados");
        }
    }

    protected void TFecha_TextChanged(object sender, EventArgs e)
    {
    }
}