using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class auditoria_indicadores : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {
            THasta.Text= DateTime.Now.ToShortDateString();
            TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            BBuscar_Click(sender, e);
        }
    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        DResultados.DataBind();
        if (DResultados.Rows.Count == 0)
            return;

        LChart.Text= "['PHD', " + DResultados.Rows[3].Cells[1].Text + ", " + DResultados.Rows[4].Cells[1].Text + ", " + DResultados.Rows[5].Cells[1].Text + "],";
        LChart.Text+= "['Apoyo terapéutico', " + DResultados.Rows[6].Cells[1].Text + ", " + DResultados.Rows[7].Cells[1].Text + ", " + DResultados.Rows[8].Cells[1].Text + "]";

        DEventos.DataBind();

        LChart2.Text = "['Eventos'";
        for (int i = 0; i < DEventos.Rows.Count; i++)
            LChart2.Text += "," + DEventos.Rows[i].Cells[1].Text;
        LChart2.Text += "]";
    }
}
