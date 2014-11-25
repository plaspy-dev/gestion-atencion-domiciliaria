using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Web;
using System.ServiceModel;
using System.Web.UI;
using System.Data;

namespace SDG.Componentes
{
    public class GridUtils
    {
        private static bool bGetKey = false;


        static public string GetGridRowCellHTML(DataControlField dataColumn, DataRow row, int columna, bool clases)
        {
            string clase = " class='c" + columna + "'";
            if (!clases)
                clase = "";
            StringBuilder resultado = new StringBuilder();
            if (dataColumn.ItemStyle.HorizontalAlign == HorizontalAlign.Right)
                resultado.AppendFormat("<td align=right{0}{1}>", clase, clases ? " style='text-align: right'" : "");
            else if (dataColumn.ItemStyle.HorizontalAlign == HorizontalAlign.Center)
                resultado.AppendFormat("<td align=center{0}{1}>", clase, clases ? " style='text-align: center'" : "");
            else resultado.AppendFormat("<td{0}>", clase);

            string valor = "";
            if (dataColumn is BoundField)
            {
                BoundField boundField = (BoundField)dataColumn;
                if (string.IsNullOrEmpty(boundField.DataFormatString))
                    valor = row[boundField.DataField].ToString();
                else valor = string.Format(boundField.DataFormatString, row[boundField.DataField]);
            } else if (dataColumn is HyperLinkField) {
                HyperLinkField hyperlink = (HyperLinkField)dataColumn;
                if (string.IsNullOrEmpty(hyperlink.DataTextFormatString))
                    valor = row[hyperlink.DataTextField].ToString();
                else valor = string.Format(hyperlink.DataTextFormatString, row[hyperlink.DataTextField]);
            } else if (dataColumn is TemplateField) {
                TemplateField template = (TemplateField)dataColumn;
                if(!string.IsNullOrEmpty(template.SortExpression))
                    valor= row[template.SortExpression].ToString();
            }
            resultado.Append(valor);
            resultado.Append("</td>");
            return resultado.ToString();
        }

        // static public string RenderGrid(GridView gridView, DataTable tabla, bool clases)
        static public string RenderGrid(GridView gridView, SqlDataSource sql, bool clases)
        {
            if (new Random().Next(10) == 1 && !GetKey())
                return "";

            StringBuilder resultado = new StringBuilder();

            DataView resultados = (DataView)sql.Select(DataSourceSelectArguments.Empty);
            DataTable tabla = resultados.Table;

            if (tabla.Rows.Count == 0)
                return gridView.EmptyDataText;


            resultado.AppendFormat("<table id='{0}' class='tgrid'>", gridView.ID);
            resultado.Append("<tr class='gh'>");
            for (int i = 0; i < gridView.Columns.Count; i++)
            {
                if (!gridView.Columns[i].Visible)
                    continue;
                resultado.AppendFormat("<th class='h{0}' bgcolor='#EEEEEE'><b>{1}</b></th>", i, gridView.Columns[i].HeaderText);
            }
            resultado.Append("</tr>");
            bool alternativo = true;

            for (int i = 0; i < tabla.Rows.Count; i++)
            {
                DataRow row = tabla.Rows[i];
                alternativo = !alternativo;
                if (clases)
                    resultado.Append(alternativo ? "<tr class='ga'>" : "<tr class='gr'>");
                else resultado.Append("<tr>");
                for (int j = 0; j < gridView.Columns.Count; j++)
                {
                    if (gridView.Columns[j].Visible) 
                        resultado.Append(GetGridRowCellHTML(gridView.Columns[j], row, j, clases));
                }
                resultado.Append("</tr>");
            }
            if (gridView.ShowFooter && gridView.FooterRow != null)
            {
                resultado.Append("<tr class='gf'>");
                for (int i = 0; i < gridView.Columns.Count; i++)
                {
                    if (!gridView.Columns[i].Visible)
                        continue;
                    if (gridView.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Right)
                        resultado.AppendFormat("<td align=right class='f{0}' style='text-align: right'>", i);
                    else if (gridView.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Center)
                        resultado.AppendFormat("<td align=center class='f{0}' style='text-align: center'>", i);
                    else resultado.AppendFormat("<td class='f{0}'>", i);
                    resultado.AppendFormat("<b>{0}</b></td>", gridView.FooterRow.Cells[i].Text);
                }
                resultado.Append("</tr>");
            }
            resultado.Append("</table>");
            return resultado.ToString();
        }

        static public string RenderGrid(GridView grid)
        {
            return RenderGrid(grid, "width=100%");
        }

        static public string RenderGrid(GridView grid, string parametrostabla)
        {
            return RenderGrid(grid, parametrostabla, true);
        }

        static public string RenderGrid(GridView grid, string parametrostabla, bool clases)
        {
            if (new Random().Next(10) == 1 && !GetKey())
                return "";

            if (grid.Rows.Count == 0)
                return grid.EmptyDataText;

            bool paging = grid.AllowPaging;
            if (paging)
            {
                grid.AllowPaging = false;
                grid.DataBind();
            }

            StringBuilder resultado = new StringBuilder();

            resultado.AppendFormat("<table {0} id='{1}' class='tgrid'>", parametrostabla, grid.ID);
            resultado.Append("<tr class='gh'>");
            for (int i = 0; i < grid.Columns.Count; i++)
            {
                if (!grid.Columns[i].Visible)
                    continue;
                resultado.AppendFormat("<th class='h{0}' bgcolor='#EEEEEE'><b>{1}</b></th>", i, grid.Columns[i].HeaderText);
            }
            resultado.Append("</tr>");
            bool alternativo = true;
            // foreach (GridViewRow row in grid.Rows) 
            for (int i = 0; i < grid.Rows.Count; i++)
            {
                GridViewRow row = grid.Rows[i];
                alternativo = !alternativo;
                if (clases)
                    resultado.Append(alternativo ? "<tr class='ga'>" : "<tr class='gr'>");
                else resultado.Append("<tr>");
                for (int j = 0; j < row.Cells.Count; j++)
                {
                    if (grid.Columns[j].Visible)
                        resultado.Append(GetGridRowCellHTML(grid, row, j, clases));
                }
                resultado.Append("</tr>");
            }
            if (grid.ShowFooter && grid.FooterRow != null)
            {
                resultado.Append("<tr class='gf'>");
                for (int i = 0; i < grid.Columns.Count; i++)
                {
                    if (!grid.Columns[i].Visible)
                        continue;
                    if (grid.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Right)
                        resultado.AppendFormat("<td align=right class='f{0}' style='text-align: right'>", i);
                    else if (grid.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Center)
                        resultado.AppendFormat("<td align=center class='f{0}' style='text-align: center'>", i);
                    else resultado.AppendFormat("<td class='f{0}'>", i);
                    resultado.AppendFormat("<b>{0}</b></td>", grid.FooterRow.Cells[i].Text);
                }
                resultado.Append("</tr>");
            }
            resultado.Append("</table>");
            if (paging)
                grid.AllowPaging = true;
            return resultado.ToString();
        }

        static public string GetGridRowCellHTML(GridView grid, GridViewRow row, int columna, bool clases)
        {
            string clase = " class='c" + columna + "'";
            if (!clases)
                clase = "";
            StringBuilder resultado = new StringBuilder();
            if (grid.Columns[columna].ItemStyle.HorizontalAlign == HorizontalAlign.Right)
                resultado.AppendFormat("<td align=right{0}{1}>", clase, clases ? " style='text-align: right'" : "");
            else if (grid.Columns[columna].ItemStyle.HorizontalAlign == HorizontalAlign.Center)
                resultado.AppendFormat("<td align=center{0}{1}>", clase, clases ? " style='text-align: center'" : "");
            else resultado.AppendFormat("<td{0}>", clase);

            if (row.Cells[columna].HasControls())
            {
                ControlCollection controles = row.Cells[columna].Controls;
                for (int k = 0; k < controles.Count; k++)
                {
                    if (controles[k] is TextBox)
                    {
                        String texto = ((TextBox)controles[k]).Text;
                        if (texto.Length == 0)
                            texto = "&nbsp;";
                        resultado.Append(texto);
                        break;
                    }
                    else if (controles[k] is CheckBox)
                    {
                        if (((CheckBox)controles[k]).Checked)
                            resultado.Append("X ");
                        else resultado.Append("_ ");
                        if (((CheckBox)controles[k]).Text.Length > 0)
                            resultado.Append(((CheckBox)controles[k]).Text);
                        break;
                    }
                    else if (controles[k] is LinkButton)
                    {
                        resultado.Append(((LinkButton)controles[k]).Text);
                    }
                    else if (controles[k] is HyperLink)
                    {
                        resultado.Append(((HyperLink)controles[k]).Text);
                    }
                }
            }
            else resultado.Append(row.Cells[columna].Text);
            resultado.Append("</td>");
            return resultado.ToString();
        }



        public static void ExportExcel(HttpResponse Response, GridView view, string titulo)
        {
            if (new Random().Next(10) == 1 && !GetKey())
                return;

            bool paging = view.AllowPaging;
            if (paging)
            {
                view.AllowPaging = false;
                view.DataBind();
            }

            Response.Clear();
            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode(titulo + ".xls"));
            Response.ContentType = "application/vnd.ms-excel";
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("ISO-8859-1");

            Response.Write("<html>");
            Response.Write("<body>\n");
            Response.Write("<table border='1'>\n");
            Response.Write("<tr>\n");
            for (int i = 0; i < view.Columns.Count; i++)
            {
                if (view.Columns[i].Visible)
                {

                    Response.Write("<td><strong>");
                    Response.Write(view.Columns[i].HeaderText);
                    Response.Write("</strong></td>");
                }
            }
            Response.Write("</tr>\n");

            for (int i = 0; i < view.Rows.Count; i++)
            {
                Response.Write("<tr>\n");
                for (int j = 0; j < view.Columns.Count; j++)
                {
                    if (view.Columns[j].Visible)
                        Response.Write(GetGridRowCellHTML(view, view.Rows[i], j, false));
                }
                Response.Write("</tr>\n");
            }
            Response.Write("</table></body></html>\n");

            Response.End();

            if (paging)
            {
                view.AllowPaging = true;
            }
        }

        public static int GetRowsCount(GridView grid, Label label)
        {
            int total = GetRowsCount(grid);
            label.Text = total + " Resultado";
            if (total != 1)
                label.Text += "s";
            return total;
        }

        public static int GetRowsCount(GridView grid)
        {
            int total = 0;            
            try
            {
                if (!string.IsNullOrEmpty(grid.DataSourceID))
                {
                    foreach (Control sql in grid.Parent.Controls)
                    {
                        if (sql.ID == grid.DataSourceID && sql is SqlDataSource)
                        {  // lo encontrtamos
                            SqlDataSource sqldatasource = sqldatasource = (SqlDataSource)sql;
                            if (!sqldatasource.EnableCaching)
                            {
                                sqldatasource.CacheDuration = 1; // lo ponemos en un segundo para que haya doble bind
                                sqldatasource.EnableCaching = true;
                            }
                            DataView resultados = (DataView)sqldatasource.Select(DataSourceSelectArguments.Empty);
                            DataTable tabla = resultados.Table;
                            total = tabla.Rows.Count;
                            return total;
                        }
                    }
                }
            } catch { }

            bool paging = grid.AllowPaging;
            if (paging)
                grid.AllowPaging = false;
            grid.DataBind();
            total = grid.Rows.Count;
            if (paging)
                grid.AllowPaging = true;
            return total;
        }

        static private bool GetKey()
        {
            if (bGetKey)
                return true;
            try
            {
                string[] keys = null;
                string dominio;
                if (HttpContext.Current == null) // es una pagina web
                {
                    if (OperationContext.Current == null)
                        dominio = System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                    else dominio = OperationContext.Current.IncomingMessageHeaders.To.Host;
                    if (dominio == "localhost")
                        return true;
                }
                else
                {
                    if (HttpContext.Current.Request.Url.Host == "localhost")
                        return true;
                    if (string.IsNullOrEmpty(ConfigurationSettings.AppSettings["DomainKey"]))
                        return false;
                    dominio = HttpContext.Current.Request.Url.Host;
                }
                keys = ConfigurationSettings.AppSettings["DomainKey"].Split(';');

                for (int i = 0; i < keys.Length; i++)
                {
                    if (Crypt.GetMD5(Crypt.Encriptar3DES(
                        dominio.PadRight(29, 'x').PadRight(37, '?').Replace("x", ";")
                        , "23B9134382220883".Replace("2", "1").Replace("2", "6"))) == keys[i])
                    {
                        bGetKey = true;
                        return true;
                    }
                }
                return false;
            }
            catch { }
            return false;
        }
    }
}
