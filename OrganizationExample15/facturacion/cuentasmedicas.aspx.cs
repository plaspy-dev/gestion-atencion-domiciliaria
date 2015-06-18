using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

public partial class facturacion_cuentasmedicas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) { 
            TInicio.Text= DateTime.Now.AddMonths(-1).ToShortDateString();
            TFin.Text= DateTime.Now.ToShortDateString();

#if DEBUG
            TInicio.Text = DateTime.Now.AddYears(-1).ToShortDateString();
            BBuscar_Click(sender, e);
#endif
        }

        SResultados.SelectCommand = SResultados.SelectCommand.Replace("@area", DArea.SelectedValue);
    }
    protected void Totalizar(List<GridViewRow> rows, string columna) {

        int col = GResultados.GetGridColumnIndex(columna);
        if(GResultados.FooterRow!=null)
            GResultados.FooterRow.Cells[col].Text = string.Format("{0:C0}", rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : decimal.Parse(x.Cells[col].Text.Replace("$", ""), NumberStyles.Currency)));
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        if (GridUtils.GetRowsCount(GResultados, LResultados) > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            /*List<GridViewRow> rows = GResultados.Rows.Cast<GridViewRow>().ToList();

            int col = GResultados.GetGridColumnIndex("Total facturado");
            decimal total= rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : decimal.Parse(x.Cells[col].Text, NumberStyles.Currency));
            GResultados.FooterRow.Cells[col].Text = string.Format("{0:C0}", rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : decimal.Parse(x.Cells[col].Text, NumberStyles.Currency)));

            GridUtil.TotalizarColumnaDinero(GResultados, "Total facturado", rows);*/
            /*GridUtil.TotalizarColumnaDinero(GResultados, "Glosa", rows);
            GridUtil.TotalizarColumnaDinero(GResultados, "Glosa aceptada", rows);
            GridUtil.TotalizarColumnaDinero(GResultados, "Glosa soportada", rows);
            GridUtil.TotalizarColumnaDinero(GResultados, "Valor devolución", rows);*/
        } else {
            ((MasterPageI)Master).Excel(null);
        }
    }

    public int CountAutorizaciones(TableCell cell) {

        if (!cell.HasControls())
            return 0;
        foreach(Control info in cell.Controls) {
            if (info is HyperLink) 
                return ((HyperLink)info).Text.Split(new string[] {"<br />"}, StringSplitOptions.RemoveEmptyEntries).Length;
        }
        return 0;
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Footer) {

            List<GridViewRow> rows = GResultados.Rows.Cast<GridViewRow>().ToList();
            GridUtil.TotalizarDinero(GResultados, e.Row, "Total facturado", rows);
            GridUtil.TotalizarDinero(GResultados, e.Row, "Total Valor Glosa", rows);
            GridUtil.TotalizarDinero(GResultados, e.Row, "Total Valor Glosa Aceptada", rows);
            GridUtil.TotalizarDinero(GResultados, e.Row, "Total Valor Glosa Soportada", rows);
            GridUtil.TotalizarEntero(GResultados, e.Row, "Servicios no facturados", rows);

            int col = GResultados.GetGridColumnIndex("Factura");
            e.Row.Cells[col].Text = rows.Count.ToString();

            col = GResultados.GetGridColumnIndex("Autorización");
            e.Row.Cells[col].Text = rows.Sum(x => CountAutorizaciones(x.Cells[col])).ToString();
        }
    }
}
