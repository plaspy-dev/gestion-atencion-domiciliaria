using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cliente_estadisticas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            TDesde.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
            THasta.Text = DateTime.Now.ToShortDateString();
        }
        GResultados.DataBind();
        int total = 0;
        LResultado.Text = "['Concepto','Encuestas']";
        for(int i=0; i<GResultados.Rows.Count; i++) {
            int actual= Convert.ToInt32(GResultados.Rows[i].Cells[1].Text);
            total += actual;
            LResultado.Text += ",['" + ((LinkButton)GResultados.Rows[i].FindControl("LC")).Text + "', " + actual.ToString() + "]";
        }
        LTotal.Text = total + " Encuesta";
        if (total != 1)
            LTotal.Text += "s";
    }
    protected void GResultados_SelectedIndexChanged(object sender, EventArgs e)
    {
        LCalificacion.Text = "Detalle " + ((LinkButton)GResultados.SelectedRow.FindControl("LC")).Text;
        PDetalle.Visible = true;
    }
    protected void GDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex == -1)
            return;
        ((LinkButton)e.Row.FindControl("LPaciente")).Text = Paciente.GetPaciente(((LinkButton)e.Row.FindControl("LPaciente")).Text).NombreCompleto; ;
    }
}
