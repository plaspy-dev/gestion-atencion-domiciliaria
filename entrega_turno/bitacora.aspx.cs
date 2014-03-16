using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class entrega_turno_bitacora : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {

            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            ViewState["entidades"] = usuario["entidades"];
            TFecha.Text = DateTime.Now.ToShortDateString();

            BAceptar.Enabled = usuario.CanInsert();
            GSeguimiento.Columns[0].Visible = usuario.CanUpdate();
            GSeguimiento.Columns[1].Visible = usuario.CanDelete();
            BMas.Visible = false;

            if (!string.IsNullOrEmpty(Request.QueryString["bid"]))
            {

                Query query = new Query("bitacora_turno");
                using (CConector conector = new CConector())
                {

                    query += "bitacora_turno.bitId";
                    query += "bitacora_turno.bitFecha";
                    query += "bitacora_turno.bitObservaciones";
                    query += "bitacora_turno.tpaId";
                    query += "bitacora_turno.NAdministrativa";
                    query += "bitacora_turno.NServicio";
                    query += "bitacora_turno.pacId";

                    MySqlDataReader reader = conector.Query(query.GetSelect("bitId=" + Query.GetValor(Request.QueryString["bid"])));
                    if (reader != null && reader.Read())
                    {

                        HBitacora.Value = reader["bitId"].ToString();
                        TFecha.Text = Query.GetFromMySQLDate(reader["bitFecha"]);
                        TObservaciones.Text = reader["bitObservaciones"].ToString();
                        DTipo.SelectedValue = reader["tpaId"].ToString();
                        TPacienteID.Text = reader["pacId"].ToString();
                        TPaciente.Text = Paciente.GetPaciente(TPacienteID.Text).NombreCompleto;
                        Utilidades.SelectInDropDown(DNAdministrativa, reader["NAdministrativa"]);
                        Utilidades.SelectInDropDown(DNServicio, reader["NServicio"]);

                        CCDetallePaciente.IdPaciente = TPacienteID.Text;
                        CCDetallePaciente.Visible = TPacienteID.Text.Length > 0;

                        BMas.Visible = true;
                        BMas.Enabled = usuario.CanInsert();
                        BAceptar.Enabled = usuario.CanUpdate();
                    }
                }
                ((MasterPageI)Master).Excel(GResultados);
                ((MasterPageI)Master).Imprimir(GResultados);
            }
        }
        Utilidades.GetRowsCount(GResultados, LTotal);
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            e.Row.Cells[2].Text = Procedimientos.GetVarios(e.Row.Cells[2].Text);
            e.Row.Cells[3].Text = Procedimientos.GetVarios(e.Row.Cells[3].Text);
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
        Query query = new Query("bitacora_turno");
        using (CConector conector = new CConector())
        {

            conector.StartTransaction();

            query["bitFecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["bitObservaciones"] = TObservaciones.Text;
            query["tpaId"] = DTipo.SelectedValue;
            query["NAdministrativa"] = DNAdministrativa.SelectedValue;
            query["NServicio"] = DNServicio.SelectedValue;
            query["pacId"] = TPacienteID.Text;

            if (string.IsNullOrEmpty(HBitacora.Value))
            {
                query["segUsuarioRegistro"] = Usuario.GetUsuario().GetLogin();
                query["segFechaRegistro"] = "SYSDATE()";

                int res = conector.QueryMod(query.GetInsert());
                if (res == -1)
                    return;
                HBitacora.Value = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("bitId=" + HBitacora.Value)) == -1)
                    return;
            }
            using(CConector conectorm= new CConector()) 
                if (conectorm.InsertModificacion(HBitacora.Value) == -1)
                    return;

            conector.Commit();
        }
        ((MasterPageI)Master).SetResultado("Bitácora editada.");
    }
    
    protected void BMas_Click(object sender, EventArgs e)
    {
        ViewState["idmas"] = null;
        TFechaSeguimiento.Text = DateTime.Now.ToShortDateString();
        THoraSeguimiento.Text = DateTime.Now.ToString("H:mm");
        TObjeto.Text = "";
        DArea.Focus();
        if (DArea.Items.Count == 0)
            DArea.DataBind();
        DArea.SelectedIndex= 0;
        PMas.Visible = true;
    }

    protected void BAceptarMas_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using (CConector conector = new CConector())
        {
            Query query = new Query("bitacora_seguimiento");

            query["bitacora"] = HBitacora.Value;
            query["fecha"] = Query.GetMySQLDateFormat(TFechaSeguimiento.Text + " " + THoraSeguimiento.Text + ":00", true);
            query["area"] = DArea.SelectedValue;
            query["objeto"] = TObjeto.Text;

            if (GSeguimiento.SelectedIndex == -1)
            {
                if (conector.QueryMod(query.GetInsert()) == -1)
                    return;
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id=" + GSeguimiento.DataKeys[GSeguimiento.SelectedIndex].Value.ToString())) == -1)
                    return;
            }
        }

        GSeguimiento.DataBind();
        GSeguimiento.SelectedIndex = -1;
        PMas.Visible = false;
    }

    protected void BCancelarMas_Click(object sender, EventArgs e)
    {
        ViewState["idmas"] = null;
        PMas.Visible = false;
        GSeguimiento.SelectedIndex = -1;
    }

    protected void GSeguimiento_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridViewRow row= GSeguimiento.Rows[GSeguimiento.SelectedIndex];
        DateTime fecha = Convert.ToDateTime(HttpUtility.HtmlDecode(row.Cells[2].Text).Trim());
        TFechaSeguimiento.Text = fecha.ToShortDateString();
        THoraSeguimiento.Text = fecha.ToString("H:mm");
        CConector.SelectInComboText(DArea, HttpUtility.HtmlDecode(row.Cells[3].Text).Trim());
        TObjeto.Text = HttpUtility.HtmlDecode(row.Cells[4].Text).Trim();

        PMas.Visible = true;
    }
}
