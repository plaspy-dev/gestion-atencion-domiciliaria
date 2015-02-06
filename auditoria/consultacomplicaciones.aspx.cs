using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class auditoria_consultacomplicaciones : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TFin.Text = DateTime.Now.ToShortDateString();
            TInicio.Text = DateTime.Now.AddDays(-30).ToShortDateString();
        }
        GResultados.DataBind();
        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Imprimir(GResultados);
            ((MasterPageI)Master).Excel(GResultados);
        }
    }
    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            ((HyperLink)e.Row.Cells[1].Controls[0]).Text = Paciente.GetPaciente(((HyperLink)e.Row.Cells[1].Controls[0]).Text).NombreCompleto;
            e.Row.Cells[2].Text = Funcionario.GetFuncionario(e.Row.Cells[2].Text).Nombres;
        }
    }
}
