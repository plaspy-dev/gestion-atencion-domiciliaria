using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cliente_estadisticas2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            THasta.Text = DateTime.Now.ToShortDateString();
            TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            BBuscar_Click(sender, e);
        }
    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        DResultados.DataBind();
        DSolucion.DataBind();
        if (DResultados.Rows.Count == 0)
        {
            LResultado2.Text = LResultado.Text = "";
            LTotal.Text = "0 Quejas";
            return;
        }

        LTotal.Text= DResultados.Rows[0].Cells[1].Text + " Quejas";

        LResultado.Text = "";
        for(int i=1; i<4; i++) {
            if (LResultado.Text.Length > 0)
                LResultado.Text += ",";
            LResultado.Text += "['" + DResultados.Rows[i].Cells[0].Text + "', " + DResultados.Rows[i].Cells[1].Text + "]";
        }

        LResultado2.Text = "";
        for (int i = 0; i < DSolucion.Rows.Count; i++)
        {
            if (LResultado2.Text.Length > 0)
                LResultado2.Text += ",";
            LResultado2.Text += "['" + HttpUtility.HtmlDecode(DSolucion.Rows[i].Cells[0].Text) + "', " + DSolucion.Rows[i].Cells[1].Text + "]";
        }
    }
}
