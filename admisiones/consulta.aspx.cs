using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class admisiones_consulta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            TInicio.Text = TFin.Text = DateTime.Now.ToShortDateString();
        }
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
            int pos = e.Row.Cells[8].Text.IndexOf("%%");
            while (pos != -1)
            {
                string texto = "";
                for (int i = pos + 2; i < e.Row.Cells[8].Text.Length; i++)
                {
                    if (e.Row.Cells[8].Text[i] == ' ')
                        break;
                    texto += e.Row.Cells[8].Text[i];
                }
                e.Row.Cells[8].Text = e.Row.Cells[8].Text.Replace("%%" + texto, Procedimientos.GetProcedimiento(texto));
                pos = e.Row.Cells[8].Text.IndexOf("%%");
            }
            e.Row.Cells[8].Text = e.Row.Cells[8].Text.Replace(",", "<br/>");
        }
    }
}
