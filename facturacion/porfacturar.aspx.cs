using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class facturacion_porfacturar : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SResultados.SelectCommand = SResultados.SelectCommand.Replace("@area", DArea.SelectedValue);
        if (!IsPostBack) {
            TInicio.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        if (Utilidades.GetRowsCount(GResultados, LResultados) > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            /*List<GridViewRow> rows = GResultados.Rows.Cast<GridViewRow>().ToList();
            Totalizar(rows, "Valor facturado");
            Totalizar(rows, "Glosa");
            Totalizar(rows, "Glosa aceptada");
            Totalizar(rows, "Glosa soportada");
            Totalizar(rows, "Valor devolución");*/
        }
        else
        {
            ((MasterPageI)Master).Excel(null);
        }
    }
}
