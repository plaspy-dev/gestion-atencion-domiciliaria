using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using SDG.Componentes;
using SDG.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class archivo_archivo : System.Web.UI.Page
{
    protected int columnaTipo=-1;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            ViewState["entidades"] = usuario["entidades"];
            TFecha.Text = DateTime.Now.Month.ToString().PadLeft(2, '0') 
                + "/"
                + DateTime.Now.Year.ToString().PadLeft(2, '0');
            TFecha.Focus();
            BMas.Visible = false;
            BAceptar.Enabled = usuario.CanInsert();

            if (!string.IsNullOrEmpty(Request.QueryString["aid"]))
            {
                Query query = new Query("paciente_archivo");
                using (CConector conector = new CConector())
                {

                    query += "paciente_archivo.arcId";
                    query += "paciente_archivo.pacId";
                    query["fecha"] = "CONCAT(LPAD(paciente_archivo.arcMes,2,'0'),'/', paciente_archivo.arcAnio)";
                    query += "paciente_archivo.arcFactura";
                    query += "paciente_archivo.arcAZ";
                    query += "paciente_archivo.arcObservaciones";

                    MySqlDataReader reader = conector.Query(query.GetSelect("arcId=" + Query.GetValor(Request.QueryString["aid"])));
                    if (reader != null && reader.Read())
                    {
                        ViewState["id"] = reader["arcId"].ToString();
                        TFecha.Text = reader["fecha"].ToString();
                        TObservaciones.Text = reader["arcObservaciones"].ToString();
                        TFactura.Text = reader["arcFactura"].ToString();
                        TAZ.Text = reader["arcAZ"].ToString();
                        TPacienteID.Text = reader["pacId"].ToString();
                        TPaciente.Text = Paciente.GetPaciente(TPacienteID.Text).NombreCompleto;

                        BAceptar.Enabled = usuario.CanUpdate();
                        BMas.Visible = true;
                        BMas.Enabled = usuario.CanInsert();
                    }
                }
                ((MasterPageI)Master).Excel(GResultados);
                ((MasterPageI)Master).Imprimir(GResultados);
            }
        }
        GridUtils.GetRowsCount(GResultados, LTotal);
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            if (columnaTipo==-1)
                columnaTipo = GResultados.GetGridColumnIndex("Tipo");

            e.Row.Cells[columnaTipo].Text = Procedimientos.GetVarios(e.Row.Cells[columnaTipo].Text);
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        Query query = new Query("paciente_archivo");
        using (CConector conector = new CConector())
        {
            string antigua = conector.QueryString(string.Format("SELECT arcId FROM paciente_archivo WHERE arcFactura={0}", Query.GetValor(TFactura.Text)));
            if (antigua.Length > 0)
            {
                if (string.IsNullOrEmpty((string)ViewState["id"]) || antigua != ViewState["id"].ToString())
                {
                    LMensaje.Text = "Ya existe un archivo con la factura '" + TFactura.Text + "'";
                    return;
                }
            }

            conector.StartTransaction();

            query["arcMes"] = TFecha.Text.Split('/')[0];
            query["arcAnio"] = TFecha.Text.Split('/')[1];
            query["arcObservaciones"] = TObservaciones.Text;
            query["pacId"] = TPacienteID.Text;
            query["arcFactura"] = TFactura.Text;
            query["arcAZ"] = TAZ.Text;
            query["tipo"] = DTipoArchivo.SelectedValue;

            if (string.IsNullOrEmpty((string)ViewState["id"]))
            {
                query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
                query["segFechaIngreso"] = "SYSDATE()";

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
            if (conector.InsertModificacion(ViewState["id"].ToString()) == -1)
                return;

            conector.Commit();
        }
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
        DTipoArchivo.SelectedIndex=0;
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

        using (CConector conector = new CConector())
        {
            Query query = new Query("prestamo_archivo");

            query["archivo"] = Request.QueryString["aid"];
            query["tipo"] = DTipo.SelectedValue;
            query["solicitadopor"] = TSolicitadoPor.Text;
            query["solicitud"] = Query.GetMySQLDateFormat(TFechaPrestamos.Text);
            query["entrega"] = Query.GetMySQLDateFormat(TEntrega.Text);
            query["devolucion"] = Query.GetMySQLDateFormat(TDevolucion.Text);
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
    protected void GResultados_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GResultados.PageIndex = e.NewPageIndex;
        GResultados.DataBind();
    }
}
