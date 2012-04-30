using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class paciente_atendidos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {
            Session["paciente_atendido"] = null;
            TDesde.Focus();
        }
    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        int rows= TablaPaciente.Rebuild(TDesde.Text, THasta.Text, DAsegurador.SelectedValue).Rows.Count;

        LTotal.Text = rows + " paciente" + (rows == 1 ? "" : "s");
        GResultados.DataBind();

        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }
}
