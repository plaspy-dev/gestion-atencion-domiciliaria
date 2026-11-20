using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SDG.Web.UI.WebControls
{
    public static class GridViewExtensions
    {
        public static int GetGridColumnIndex(this GridView grid, string columna) {

            columna = columna.ToLower();
            for (int i = 0; i < grid.Columns.Count; i++)
            {
                if (grid.Columns[i].HeaderText.ToLower() == columna)
                    return i;
            }
            return -1;
        }

        public static DataControlField GetGridColumn(this GridView grid, string columna)
        {
            columna = columna.ToLower();
            for (int i = 0; i < grid.Columns.Count; i++)
            {
                if (grid.Columns[i].HeaderText.ToLower() == columna)
                    return grid.Columns[i];
            }
            return null;
        }

        public static TableCell GetGridCell(this GridView grid, string columna, int fila)
        {
            return grid.Rows[fila].Cells[GetGridColumnIndex(grid, columna)];
        }

        public static string GetGridCellText(this GridView grid, string columna, int fila)
        {
            return HttpUtility.HtmlDecode(grid.Rows[fila].Cells[GetGridColumnIndex(grid, columna)].Text).Trim();
        }
    }
}
