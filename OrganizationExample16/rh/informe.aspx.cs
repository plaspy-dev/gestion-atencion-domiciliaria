using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class rh_informe : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            BActualizar_Click(sender, e);
        }
    }

    protected void BActualizar_Click(object sender, EventArgs e)
    {
        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0) {
            ((MasterPageI)Master).Excel(GResultados);
        }
    }
}