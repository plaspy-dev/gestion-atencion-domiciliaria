using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using System.Collections;

public partial class admisiones_consulta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SResultados.SelectCommand = SResultados.SelectCommand.Replace("@area", DArea.SelectedValue);
        SResumen.SelectCommand = SResumen.SelectCommand.Replace("@area", DArea.SelectedValue);
        
        if (!IsPostBack) {
            TInicio.Text = TFin.Text = DateTime.Now.ToShortDateString();
        }
        GResultados.DataBind();
        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
        GResumen.DataBind();
    }
    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            e.Row.Cells[8].Text = Procedimientos.ReplaceVarios(
                                    Procedimientos.ReplaceProcedimientos(e.Row.Cells[8].Text))
                                    .Replace(",_", "<br/>");
        }
    }

    protected void GResumen_RowDataBound(object sender, GridViewRowEventArgs e) {
        if (e.Row.RowIndex != -1) {
            switch (e.Row.Cells[0].Text) { 
                case "-1":
                    e.Row.Cells[0].Text = "Total Pacientes";
                    break;
                case "5000000":
                    e.Row.Cells[0].Text = "Sesiones Autorizadas";
                    break;
                case "-3":
                    e.Row.Cells[0].Text = "Total Autorizaciones";
                    break;
                default:
                    e.Row.Cells[0].Text = Procedimientos.GetProcedimiento(e.Row.Cells[0].Text);
                    break;
            }
        }
    }
}
