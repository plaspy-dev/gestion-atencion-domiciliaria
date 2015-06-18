using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class clinicaheridas_egresos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            TDesde.Text = Query.GetFromMySQLDate(DateTime.Now.AddDays(-30));
            THasta.Text = Query.GetFromMySQLDate(DateTime.Now);
            BBuscar_Click(sender, e);
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        int rows = GridUtils.GetRowsCount(GResultados);
        LTotal.Text = rows + " paciente" + (rows == 1 ? "" : "s");

        if (rows > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }
}