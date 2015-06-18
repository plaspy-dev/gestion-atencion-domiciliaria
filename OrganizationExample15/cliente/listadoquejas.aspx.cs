using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class cliente_listadoquejas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TInicio.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
        }
        ((MasterPageI)Master).Excel(GResultados);
        ((MasterPageI)Master).Imprimir(GResultados);

    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            e.Row.Cells[4].Text = Procedimientos.GetVarios(e.Row.Cells[4].Text);
        }
    }
}
