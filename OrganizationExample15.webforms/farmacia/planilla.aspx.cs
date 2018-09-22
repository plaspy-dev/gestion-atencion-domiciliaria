using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class farmacia_planilla : System.Web.UI.Page
{
    public const int m_nAlmacen = 1;

    protected void Page_Load(object sender, EventArgs e)
    {
        SResultados.SelectCommand = String.Format(SResultados.SelectCommand, m_nAlmacen, m_nAlmacen);

        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            // para el filtro por usuarios.
            if (string.IsNullOrEmpty(Request.QueryString["d"]))
                THasta.Text = Query.GetFromMySQLDate(DateTime.Now);
            else THasta.Text = Request.QueryString["d"];
            if (string.IsNullOrEmpty(Request.QueryString["f"]))
                TDesde.Text = Query.GetFromMySQLDate(DateTime.Now.AddDays(-30));
            else TDesde.Text = Request.QueryString["f"];

            if (((MasterPageI)Master).RestoreState() || !string.IsNullOrEmpty(Request.QueryString["r"]))
            {
                BBuscar_Click(sender, e);
            }
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        LMensaje.Text = "";
        GResultados.Visible = true;

        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Imprimir("planilla.html", true);
            ((MasterPageI)Master).Excel(GResultados);
            List<GridViewRow> rows = GResultados.Rows.Cast<GridViewRow>().ToList();
        }
    }
}