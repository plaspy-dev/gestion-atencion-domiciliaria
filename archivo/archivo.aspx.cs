using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using SDG.Componentes;

public partial class archivo_archivo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            TFecha.Text = DateTime.Now.Month.ToString().PadLeft(2, '0') 
                + "/"
                + DateTime.Now.Year.ToString().PadLeft(2, '0');
            TFecha.Focus();
            BAceptar.Enabled = usuario.CanInsert();

            if (!string.IsNullOrEmpty(Request.QueryString["aid"]))
            {
                Query query = new Query("arcArchivoGestion");
                CConectorMS conector = new CConectorMS();

                query += "arcArchivoGestion.arcId";
                query += "phdPaciente.pacNombres";
                query += "arcArchivoGestion.pacId";
                query["fecha"] = "REPLACE(STR(CAST(arcArchivoGestion.arcMes AS varchar), 2), SPACE(1), '0') + '/' + CAST(arcArchivoGestion.arcAnio AS varchar)";
                query += "arcArchivoGestion.arcFactura";
                query += "arcArchivoGestion.arcAZ";
                query += "arcArchivoGestion.arcObservaciones";

                SqlDataReader reader = conector.Query(query.GetSelect("arcId=" + Query.GetValor(Request.QueryString["aid"]), "LEFT JOIN phdPaciente ON (phdPaciente.pacId=arcArchivoGestion.pacId)"));
                if (reader != null && reader.Read())
                {
                    ViewState["id"] = reader["arcId"].ToString();
                    TFecha.Text = reader["fecha"].ToString();
                    TObservaciones.Text = reader["arcObservaciones"].ToString();
                    TFactura.Text = reader["arcFactura"].ToString();
                    TAZ.Text = reader["arcAZ"].ToString();
                    TPacienteID.Text = reader["pacId"].ToString();
                    TPaciente.Text = reader["pacNombres"].ToString();

                    BAceptar.Enabled = usuario.CanUpdate();
                }
            }
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
        Utilidades.GetRowsCount(GResultados, LTotal);
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        /*if (e.Row.RowIndex != -1)
        {
            e.Row.Cells[2].Text = Procedimientos.GetVarios(e.Row.Cells[2].Text);
            e.Row.Cells[3].Text = Procedimientos.GetVarios(e.Row.Cells[3].Text);
        }*/
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        Query query = new Query("arcArchivoGestion");
        CConectorMS conector = new CConectorMS();

        conector.StartTransaction();

        query["arcMes"] = TFecha.Text.Split('/')[0];
        query["arcAnio"] = TFecha.Text.Split('/')[1];
        query["arcObservaciones"] = TObservaciones.Text;
        query["pacId"] = TPacienteID.Text;
        query["arcFactura"] = TFactura.Text;
        query["arcAZ"] = TAZ.Text;

        if (string.IsNullOrEmpty((string)ViewState["id"]))
        {
            query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
            query["segFechaIngreso"] = "GETDATE()";

            int res = conector.QueryMod(query.GetInsert());
            if (res == -1)
                return;
            ViewState["id"] = res.ToString();
        }
        else
        {
            if (conector.QueryMod(query.GetUpdate("arcId=" + ViewState["id"].ToString())) == -1)
                return;
        }
        if (new CConector().InsertModificacion(ViewState["id"].ToString()) == -1)
            return;

        conector.Commit();
        ((MasterPageI)Master).SetResultado("Archivo editada.");
    }

    protected void BMas_Click(object sender, EventArgs e)
    {
        ViewState["idmas"] = null;
        TFechaPrestamos.Text = DateTime.Now.ToShortDateString();
        TObjeto.Text = "";
        TSolicitadoPor.Text = "";
        TEntrega.Text = "";
        TDevolucion.Text = "";
        DTipo.Focus();
        if (DTipo.Items.Count == 0)
            DTipo.DataBind();
        DTipo.SelectedIndex = 0;

        PMas.Visible = true;
    }

    protected void BAceptarMas_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        CConectorMS conector = new CConectorMS();
        Query query = new Query("prestamo_archivo");

        query["archivo"] = Request.QueryString["aid"];
        query["tipo"] = DTipo.SelectedValue;
        query["solicitadopor"] = TSolicitadoPor.Text;
        query["solicitud"] = TFechaPrestamos.Text;
        query["entrega"] = TEntrega.Text;
        query["devolucion"] = TDevolucion.Text;
        query["objeto"] = TObjeto.Text;

        if (GPrestamos.SelectedIndex == -1)
        {
            if (conector.QueryMod(query.GetInsert()) == -1)
                return;
        }
        else
        {
            if (conector.QueryMod(query.GetUpdate("id=" + GPrestamos.DataKeys[GPrestamos.SelectedIndex].Value.ToString())) == -1)
                return;
        }

        GPrestamos.DataBind();
        GPrestamos.SelectedIndex = -1;
        PMas.Visible = false;
    }

    protected void BCancelarMas_Click(object sender, EventArgs e)
    {
        ViewState["idmas"] = null;
        PMas.Visible = false;
        GPrestamos.SelectedIndex = -1;
    }

    protected void GPrestamos_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridViewRow row = GPrestamos.Rows[GPrestamos.SelectedIndex];
        TFechaPrestamos.Text = HttpUtility.HtmlDecode(row.Cells[2].Text).Trim();
        CConector.SelectInComboText(DTipo, HttpUtility.HtmlDecode(row.Cells[3].Text).Trim());
        TSolicitadoPor.Text = HttpUtility.HtmlDecode(row.Cells[4].Text).Trim();
        TObjeto.Text = HttpUtility.HtmlDecode(row.Cells[5].Text).Trim();
        TEntrega.Text = HttpUtility.HtmlDecode(row.Cells[6].Text).Trim();
        TDevolucion.Text = HttpUtility.HtmlDecode(row.Cells[7].Text).Trim();

        PMas.Visible = true;
    }
}
