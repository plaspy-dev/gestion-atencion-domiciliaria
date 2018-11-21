using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

/// <summary>
/// Summary description for GridUtil
/// </summary>
public class GridUtil
{
    public static int ContarFilas(List<GridViewRow> rows, int col)
    {
        return rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : 1);
    }

    public static void ContarFilas(GridView grid, GridViewRow Row, string columna, List<GridViewRow> rows)
    {
        int col = grid.GetGridColumnIndex(columna);
        Row.Cells[col].Text = GridUtil.ContarFilas(rows, col).ToString();
    }

    public static int TotalizarEntero(List<GridViewRow> rows, int col)
    {
        return rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : int.Parse(x.Cells[col].Text));
    }

    public static void TotalizarEntero(GridView grid, GridViewRow Row, string columna, List<GridViewRow> rows)
    {
        int col = grid.GetGridColumnIndex(columna);
        Row.Cells[col].Text = GridUtil.TotalizarEntero(rows, col).ToString();
    }

    public static decimal TotalizarDinero(List<GridViewRow> rows, int col) {
        return rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : decimal.Parse(x.Cells[col].Text, NumberStyles.Currency));
    }

    public static void TotalizarDinero(GridView grid, GridViewRow Row, string columna, List<GridViewRow> rows)
    {
        int col = grid.GetGridColumnIndex(columna);
        Row.Cells[col].Text = string.Format("{0:C0}", GridUtil.TotalizarDinero(rows, col));
    }

    public static void TotalizarColumnaDinero(GridView grid, string columna, List<GridViewRow> rows=null)
    {
        int col = grid.GetGridColumnIndex(columna);
        if (grid.FooterRow != null) {
            if (rows == null)
                rows = grid.Rows.Cast<GridViewRow>().ToList();
            grid.FooterRow.Cells[col].Text = string.Format("{0:C0}", TotalizarDinero(rows, col));
        }
    }
}