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
            TFecha.Text = Query.GetFromMySQLDate(DateTime.Now.Date, true);

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

            Query query = new Query("digitalizacion");

            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["paciente"] = CCDetallePaciente.IdPaciente;
            query["factura"] = TFactura.Text;
            query["documento"] = CCDetallePaciente.Documento;
            query["tipo"] = "0";

            if (FFactura.HasFile) {
                string filename = TFactura.Text + "/" + FFactura.FileName;
                string file = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "digitalizacion", filename);
                Directory.CreateDirectory(Path.GetDirectoryName(file));
                FFactura.SaveAs(file);
                query["factura_archivo"] = filename;

                if (conector.QueryMod(query.GetDelete("factura={0} AND tipo=0", Query.GetValor(TFactura.Text))) == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            if (conector.QueryMod(query.GetInsert(true)) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            foreach (RepeaterItem item in RArchivo.Items) {

                HiddenField hi= (HiddenField) item.FindControl("HI");
                FileUpload upload= (FileUpload)item.FindControl("FHistoria");

                if (upload.HasFile)
                {
                    string filename = TFactura.Text + "/" + CCDetallePaciente.IdPaciente + "/" + upload.FileName;
                    string file = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "digitalizacion", filename);
                    Directory.CreateDirectory(Path.GetDirectoryName(file));
                    upload.SaveAs(file);
                    query["archivo"] = filename;
                    query["tipo"] = hi.Value;

                    if (conector.QueryMod(query.GetDelete("factura={0} AND paciente={1} AND tipo={0}"
                        , Query.GetValor(TFactura.Text)
                        , Query.GetValor(CCDetallePaciente.IdPaciente)
                        , Query.GetValor(hi.Value))) == -1) {
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

        if(string.IsNullOrEmpty(TFactura.Text))
            return;

        using (CConector conector = new CConector()) {

            CUsuario usuario= (CUsuario)Usuario.GetInstance();
            Query query = new Query("digitalizacion");

            query += "fecha";
            query += "archivo";
            query += "factura_archivo";

            /*MySqlDataReader reader = conector.Query(query.GetSelect("factura={0} AND paciente={1} AND tipo IS NULL", null, Query.GetValor(TFactura.Text), Query.GetValor(CCDetallePaciente.IdPaciente)));
            if (reader != null && reader.Read())
            {
                TFecha.Text = Query.GetFromMySQLDate(reader["fecha"]);

                HFactura.Text = Path.GetFileName(reader["factura_archivo"].ToString());
                HFactura.NavigateUrl = string.Format("~/archivo/archivo.ashx?n={0}&t=d", reader["factura_archivo"]);
                HFactura.Visible = HFactura.Text.Length > 0;

                /*HHistoria.Text = Path.GetFileName(reader["archivo"].ToString());
                HHistoria.NavigateUrl = string.Format("~/archivo/archivo.ashx?n={0}&t=d", reader["archivo"]);
                HHistoria.Visible = HFactura.Text.Length > 0;

                // RHistoria.Enabled = false;
                RFactura.Enabled = false;

                BAceptar.Enabled = usuario.CanUpdate();
                BEliminar.Visible = usuario.CanDelete();
                return;
            }*/

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

            if (conector.QueryMod(query.GetDelete("factura={0} AND paciente={1}", null, Query.GetValor(TFactura.Text), Query.GetValor(CCDetallePaciente.IdPaciente))) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            ((MasterPageI)Master).SetResultado("Archivos eliminados");
        }
    }
}