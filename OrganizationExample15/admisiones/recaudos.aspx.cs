using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class admisiones_recaudos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            TInicio.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
            // BBuscar_Click(sender, e);
        }
    }
    

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        /*if (!IsValid)
            return;*/
        GResultados.Visible = true;
        GResultados.DataBind();
        List<GridViewRow> rows = GResultados.Rows.Cast<GridViewRow>().ToList();
        GridUtil.TotalizarColumnaDinero(GResultados, "Valor", rows);
        GridUtil.TotalizarColumnaDinero(GResultados, "Cancelado", rows);
        GridUtil.TotalizarColumnaDinero(GResultados, "Saldo", rows);
        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
        else
        {
            ((MasterPageI)Master).Excel(null);
            ((MasterPageI)Master).Imprimir((GridView) null);
        }
    }
}