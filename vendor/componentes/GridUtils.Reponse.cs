using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SDG.Componentes
{
    public partial class GridUtils
    {
        static public void RenderGrid(HttpResponse Response, GridView gridView, SqlDataSource sql, bool clases)
        {
            DataView resultados = (DataView)sql.Select(DataSourceSelectArguments.Empty);
            DataTable tabla = resultados.Table;

            if (tabla.Rows.Count == 0)
            {
                Response.Write(gridView.EmptyDataText);
                Response.Flush();
                return;
            }

            Response.Write(string.Format("<table id='{0}' class='tgrid'>", gridView.ID));
            if (gridView.ShowHeader)
            {
                Response.Write("<tr class='gh'>");
                for (int i = 0; i < gridView.Columns.Count; i++)
                {
                    if (!gridView.Columns[i].Visible)
                        continue;
                    Response.Write(string.Format("<th class='h{0}' bgcolor='#EEEEEE'><b>{1}</b></th>", i, gridView.Columns[i].HeaderText));
                }
                Response.Write("</tr>");
            }
            if (!Response.IsClientConnected)
                return;
            bool alternativo = true;

            for (int i = 0; i < tabla.Rows.Count; i++)
            {
                DataRow row = tabla.Rows[i];
                alternativo = !alternativo;
                if (clases)
                    Response.Write(alternativo ? "<tr class='ga'>" : "<tr class='gr'>");
                else Response.Write("<tr>");
                for (int j = 0; j < gridView.Columns.Count; j++)
                {
                    if (gridView.Columns[j].Visible)
                        Response.Write(GetGridRowCellHTML(gridView.Columns[j], row, j, clases));
                }
                Response.Write("</tr>");
                if (!Response.IsClientConnected)
                    return;
            }
            if (!Response.IsClientConnected)
                return;
            if (gridView.ShowFooter && gridView.FooterRow != null)
            {
                Response.Write("<tr class='gf'>");
                for (int i = 0; i < gridView.Columns.Count; i++)
                {
                    if (!gridView.Columns[i].Visible)
                        continue;
                    if (gridView.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Right)
                        Response.Write(string.Format("<td align=right class='f{0}' style='text-align: right'>", i));
                    else if (gridView.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Center)
                        Response.Write(string.Format("<td align=center class='f{0}' style='text-align: center'>", i));
                    else Response.Write(string.Format("<td class='f{0}'>", i));
                    Response.Write(string.Format("<b>{0}</b></td>", gridView.FooterRow.Cells[i].Text));
                }
                Response.Write("</tr>");
            }
            Response.Write("</table>");
        }


        static public void RenderGrid(HttpResponse Response, GridView grid)
        {
            RenderGrid(Response, grid, "width=100%");
        }

        static public void RenderGrid(HttpResponse Response, GridView grid, string parametrostabla)
        {
            RenderGrid(Response, grid, parametrostabla, true);
        }

        static public void RenderGrid(HttpResponse Response, GridView grid, string parametrostabla, bool clases)
        {
            if (grid.Rows.Count == 0)
            {
                Response.Write(grid.EmptyDataText);
                return;
            }

            bool paging = grid.AllowPaging;
            if (paging)
            {
                grid.AllowPaging = false;
                grid.DataBind();
            }

            Response.Write(string.Format("<table {0} id='{1}' class='tgrid'>", parametrostabla, grid.ID));
            if (grid.ShowHeader)
            {
                Response.Write("<tr class='gh'>");
                for (int i = 0; i < grid.Columns.Count; i++)
                {
                    if (!grid.Columns[i].Visible)
                        continue;
                    Response.Write(string.Format("<th class='h{0}' bgcolor='#EEEEEE'><b>{1}</b></th>", i, grid.Columns[i].HeaderText));
                }
                Response.Write("</tr>");
            }
            if (!Response.IsClientConnected)
                return;
            bool alternativo = true;
            // foreach (GridViewRow row in grid.Rows) 
            for (int i = 0; i < grid.Rows.Count; i++)
            {
                GridViewRow row = grid.Rows[i];
                alternativo = !alternativo;
                if (clases)
                    Response.Write(alternativo ? "<tr class='ga'>" : "<tr class='gr'>");
                else Response.Write("<tr>");
                for (int j = 0; j < row.Cells.Count; j++)
                {
                    if (grid.Columns[j].Visible)
                        Response.Write(GetGridRowCellHTML(grid, row, j, clases));
                }
                Response.Write("</tr>");
                if (!Response.IsClientConnected)
                    return;
            }
            if (!Response.IsClientConnected)
                return;
            if (grid.ShowFooter && grid.FooterRow != null)
            {
                Response.Write("<tr class='gf'>");
                for (int i = 0; i < grid.Columns.Count; i++)
                {
                    if (!grid.Columns[i].Visible)
                        continue;
                    if (grid.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Right)
                        Response.Write(string.Format("<td align=right class='f{0}' style='text-align: right'>", i));
                    else if (grid.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Center)
                        Response.Write(string.Format("<td align=center class='f{0}' style='text-align: center'>", i));
                    else Response.Write(string.Format("<td class='f{0}'>", i));
                    Response.Write(string.Format("<b>{0}</b></td>", grid.FooterRow.Cells[i].Text));
                }
                Response.Write("</tr>");
            }
            Response.Write("</table>");
            if (paging)
                grid.AllowPaging = true;
        }
    }
}
