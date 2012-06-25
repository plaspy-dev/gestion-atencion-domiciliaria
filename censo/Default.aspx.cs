using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class censo_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        GResultados.AllowPaging = false;
        GResultados.DataBind();
        LTotal.Text = GResultados.Rows.Count + " Resultados";
        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
        GResultados.AllowPaging = true;
        GResultados.DataBind();
    }
    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            e.Row.Cells[11].Text = Procedimientos.ReplaceVarios(
                                    Procedimientos.ReplaceProcedimientos(e.Row.Cells[11].Text))
                                    .Replace(",_", "<br/>");

            e.Row.Cells[8].Text = e.Row.Cells[8].Text.Replace(",_", "<br/>");

            // calculamos la edad
            int years = 0;
            try
            {
                DateTime birthDate = Convert.ToDateTime(HttpUtility.HtmlDecode(e.Row.Cells[3].Text));
                DateTime now = DateTime.Now;
                years = now.Year - birthDate.Year;
                if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                    --years;
            }
            catch (Exception ex) { }
            e.Row.Cells[3].Text = years==0 ? "" : years.ToString();
        }
    }
}
