using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class auditoria_autorizadovsrealizado : System.Web.UI.Page
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
            try
            {
                Convert.ToInt32(e.Row.Cells[0].Text);
                e.Row.Cells[0].Text = Procedimientos.GetProcedimiento(e.Row.Cells[0].Text);
            } catch {}
        }
    }
}
