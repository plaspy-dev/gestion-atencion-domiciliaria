using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class eventos_informes : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            THasta.Text = DateTime.Now.ToShortDateString();
            TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
        }
        // TDesde.Focus();
        Page.Header.Title = CAmbulancia.Checked ? "Registro de pacientes trasladados" : "Registro de pacientes atendidos";
        ((MasterPageI)Master).SetTitulo(Page.Header.Title);

        GResultados.AllowPaging = false;
        GResultados.DataBind();
        LTotal.Text = GResultados.Rows.Count + " Resultados";
        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
        }
        GResultados.AllowPaging = true;
        GResultados.DataBind();
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {

    }
}
