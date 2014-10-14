using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class rutasanitaria_consulta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            TInicio.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
        }
    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        ((MasterPageI)Master).Excel(GridUtils.GetRowsCount(GResultados, LResultado) > 0 ? GResultados : null);
    }
}
