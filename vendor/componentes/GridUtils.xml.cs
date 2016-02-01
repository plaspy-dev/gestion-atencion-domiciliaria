using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;


namespace SDG.Componentes
{
    public partial class GridUtils
    {
        public static Regex RegexIntegerStartWithZero = new Regex("^[0\\+]\\d+$", RegexOptions.Compiled);

        static public string GetGridRowCellXML(GridView grid, GridViewRow row, int columna)
        {
            StringBuilder resultado = new StringBuilder();

            if (grid.Columns[columna].ItemStyle.HorizontalAlign == HorizontalAlign.Right)
                resultado.Append(string.Format("<Cell ss:StyleID=\"r{0}\">", grid.Columns[columna].ItemStyle.Font.Bold ? "b" : ""));
            else if (grid.Columns[columna].ItemStyle.HorizontalAlign == HorizontalAlign.Center)
                resultado.Append(string.Format("<Cell ss:StyleID=\"c{0}\">", grid.Columns[columna].ItemStyle.Font.Bold ? "b" : ""));
            else resultado.Append(string.Format("<Cell{0}>", grid.Columns[columna].ItemStyle.Font.Bold ? " ss:StyleID=\"b\"" : ""));

            string valor = "";
            if (row.Cells[columna].HasControls())
            {
                ControlCollection controles = row.Cells[columna].Controls;
                for (int k = 0; k < controles.Count; k++)
                {
                    if (controles[k] is TextBox)
                    {
                        valor = ((TextBox)controles[k]).Text;
                        break;
                    }
                    else if (controles[k] is CheckBox)
                    {
                        if (((CheckBox)controles[k]).Checked)
                            valor = "X ";
                        else valor = "_ ";
                        if (((CheckBox)controles[k]).Text.Length > 0)
                            valor += ((CheckBox)controles[k]).Text;
                        break;
                    }
                    else if (controles[k] is LinkButton)
                    {
                        valor = ((LinkButton)controles[k]).Text;
                    }
                    else if (controles[k] is HyperLink)
                    {
                        valor = ((HyperLink)controles[k]).Text;
                    }
                    else if (controles[k] is Image)
                    {
                        Image imagen = (Image)controles[k];
                        valor = string.Format("<img src='{0}' />", Utilidades.GetURLFullPath(imagen.ImageUrl));
                    }
                    else if (controles[k] is Label)
                    {
                        valor = ((Label)controles[k]).Text;
                    }
                }
            } else valor = row.Cells[columna].Text;

            resultado.AppendFormat("<Data ss:Type=\"{0}\">", GetTypeValue(ref valor));
            resultado.Append(RenderPage.GetXMLString(valor));
            resultado.Append("</Data></Cell>");
            return resultado.ToString();
        }

        public static string GetTypeValue(ref string valor) {

            if (!string.IsNullOrEmpty(valor) && !RegexIntegerStartWithZero.IsMatch(valor)) {
                try {
                    valor = Convert.ToInt64(valor).ToString();
                    return "Number";
                } catch { }
                try {
                    valor= Convert.ToDouble(valor).ToString(CultureInfo.InvariantCulture);
                    return "Number";
                } catch { }
                try {
                    valor = Convert.ToDouble(valor, CultureInfo.InvariantCulture).ToString(CultureInfo.InvariantCulture);
                    return "Number";
                } catch { }
            }
            return "String";
        }

        public static void ExportExcelXML(HttpResponse Response, GridView view, string titulo, string author)
        {
            bool paging = view.AllowPaging;
            if (paging)
            {
                view.AllowPaging = false;
                view.DataBind();
            }

            Response.Clear();
            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode(titulo + ".xls"));
            Response.ContentType = "application/vnd.ms-excel";
            Response.ContentEncoding = System.Text.Encoding.UTF8;

            Response.Write(string.Format(@"<?xml version=""1.0""?>
<?mso-application progid=""Excel.Sheet"" ?>
<Workbook
   xmlns=""urn:schemas-microsoft-com:office:spreadsheet""
   xmlns:o=""urn:schemas-microsoft-com:office:office""
   xmlns:x=""urn:schemas-microsoft-com:office:excel""
   xmlns:ss=""urn:schemas-microsoft-com:office:spreadsheet""
   xmlns:html=""http://www.w3.org/TR/REC-html40"" >
  <DocumentProperties xmlns=""urn:schemas-microsoft-com:office:office"">
    <Author>{0}</Author>
    <Created>{1}</Created></DocumentProperties>
  <Styles>  
	  <Style ss:ID=""sd""><NumberFormat ss:Format=""Short Date"" /></Style>
	  <Style ss:ID=""gd""><NumberFormat ss:Format=""General Date"" /></Style>
	  <Style ss:ID=""c""><Alignment ss:Horizontal=""Center"" /></Style>
	  <Style ss:ID=""r""><Alignment ss:Horizontal=""Right"" /></Style>
	  <Style ss:ID=""b""><Font ss:Bold=""1"" /></Style>
	  <Style ss:ID=""cb""><Font ss:Bold=""1"" /><Alignment ss:Horizontal=""Center"" /></Style>
	  <Style ss:ID=""rb""><Font ss:Bold=""1"" /><Alignment ss:Horizontal=""Right"" /></Style>
  </Styles>
  <Worksheet ss:Name=""{2}"">
    <Table>"
, author, DateTime.Now.ToString("o"), titulo));

            if (view.ShowHeader)
            {
                Response.Write("<Row>\n");
                for (int i = 0; i < view.Columns.Count; i++)
                {
                    if (view.Columns[i].Visible)
                    {
                        Response.Write(string.Format("<Cell ss:StyleID=\"cb\"><Data ss:Type=\"String\">{0}</Data></Cell>", view.Columns[i].HeaderText));
                    }
                }
                Response.Write("</Row>\n");
            }

            for (int i = 0; i < view.Rows.Count; i++)
            {
                Response.Write("<Row>\n");
                for (int j = 0; j < view.Columns.Count; j++)
                {
                    if (view.Columns[j].Visible)
                    {
                        Response.Write(GetGridRowCellXML(view, view.Rows[i], j));
                    }
                }
                Response.Write("</Row>\n");
            }

            Response.Write(@"</Table>
  </Worksheet>
</Workbook>");

            Response.End();

            if (paging)
            {
                view.AllowPaging = true;
            }
        }





        static public string GetGridRowCellXML(DataControlField dataColumn, DataRow row, int columna)
        {
            StringBuilder resultado = new StringBuilder();

            if (dataColumn.ItemStyle.HorizontalAlign == HorizontalAlign.Right)
                resultado.Append(string.Format("<Cell ss:StyleID=\"r{0}\">", dataColumn.ItemStyle.Font.Bold ? "b" : ""));
            else if (dataColumn.ItemStyle.HorizontalAlign == HorizontalAlign.Center)
                resultado.Append(string.Format("<Cell ss:StyleID=\"c{0}\">", dataColumn.ItemStyle.Font.Bold ? "b" : ""));
            else resultado.Append("<Cell>");

            string valor = "";
            if (dataColumn is BoundField)
            {
                BoundField boundField = (BoundField)dataColumn;
                if (!string.IsNullOrEmpty(boundField.DataField))
                {
                    if (string.IsNullOrEmpty(boundField.DataFormatString))
                        valor = row[boundField.DataField].ToString();
                    else valor = string.Format(boundField.DataFormatString, row[boundField.DataField]);
                }
            }
            else if (dataColumn is HyperLinkField)
            {
                HyperLinkField hyperlink = (HyperLinkField)dataColumn;
                if (string.IsNullOrEmpty(hyperlink.DataTextFormatString))
                    valor = row[hyperlink.DataTextField].ToString();
                else valor = string.Format(hyperlink.DataTextFormatString, row[hyperlink.DataTextField]);
            }
            else if (dataColumn is TemplateField)
            {
                TemplateField template = (TemplateField)dataColumn;
                if (!string.IsNullOrEmpty(template.SortExpression))
                    valor = row[template.SortExpression].ToString();
            }
            resultado.AppendFormat("<Data ss:Type=\"{0}\">", GetTypeValue(ref valor));
            resultado.Append(RenderPage.GetXMLString(valor));
            resultado.Append("</Data></Cell>");
            return resultado.ToString();
        }

        static public void RenderGridXML(HttpResponse Response, GridView gridView, SqlDataSource sql)
        {
            DataView resultados = (DataView)sql.Select(DataSourceSelectArguments.Empty);
            DataTable tabla = resultados.Table;

            if (tabla.Rows.Count == 0)
            {
                Response.Write("<Row>\n");
                Response.Write(string.Format("<Cell ss:StyleID=\"cb\"><Data ss:Type=\"String\">{0}</Data></Cell>", RenderPage.GetXMLString(gridView.EmptyDataText)));
                Response.Write("</Row>\n");
                Response.Flush();
                return;
            }

            if (gridView.ShowHeader)
            {
                Response.Write("<Row>\n");
                for (int i = 0; i < gridView.Columns.Count; i++)
                {
                    if (!gridView.Columns[i].Visible)
                        continue;
                    Response.Write(string.Format("<Cell ss:StyleID=\"cb\"><Data ss:Type=\"String\">{0}</Data></Cell>", RenderPage.GetXMLString(gridView.Columns[i].HeaderText)));
                }
                Response.Write("</Row>\n");
            }
            if (!Response.IsClientConnected)
                return;
            // bool alternativo = true;

            for (int i = 0; i < tabla.Rows.Count; i++)
            {
                DataRow row = tabla.Rows[i];
                Response.Write("<Row>\n");
                for (int j = 0; j < gridView.Columns.Count; j++)
                {
                    if (gridView.Columns[j].Visible)
                        Response.Write(GetGridRowCellXML(gridView.Columns[j], row, j));
                }
                Response.Write("</Row>\n");
                if (!Response.IsClientConnected)
                    return;
            }
            if (!Response.IsClientConnected)
                return;
            if (gridView.ShowFooter && gridView.FooterRow != null)
            {
                Response.Write("<Row>\n");
                for (int i = 0; i < gridView.Columns.Count; i++)
                {
                    if (!gridView.Columns[i].Visible)
                        continue;
                    if (gridView.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Right)
                        Response.Write("<Cell ss:StyleID=\"rb\">");
                    else if (gridView.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Center)
                        Response.Write("<Cell ss:StyleID=\"cb\">");
                    else Response.Write("<Cell ss:StyleID=\"b\">");
                    string valor = gridView.FooterRow.Cells[i].Text;
                    Response.Write(string.Format("<Data ss:Type=\"{0}\">{1}</Data></Cell>", GetTypeValue(ref valor), RenderPage.GetXMLString(valor)));
                }
                Response.Write("</Row>\n");
            }
        }

        static public void RenderGridXML(HttpResponse Response, GridView grid)
        {
            if (grid.Rows.Count == 0)
            {
                Response.Write("<Row>\n");
                Response.Write(string.Format("<Cell ss:StyleID=\"cb\"><Data ss:Type=\"String\">{0}</Data></Cell>", RenderPage.GetXMLString(grid.EmptyDataText)));
                Response.Write("</Row>\n");
                return;
            }

            bool paging = grid.AllowPaging;
            if (paging)
            {
                grid.AllowPaging = false;
                grid.DataBind();
            }

            if (grid.ShowHeader)
            {
                Response.Write("<Row>\n");
                for (int i = 0; i < grid.Columns.Count; i++)
                {
                    if (!grid.Columns[i].Visible)
                        continue;
                    Response.Write(string.Format("<Cell ss:StyleID=\"cb\"><Data ss:Type=\"String\">{0}</Data></Cell>", RenderPage.GetXMLString(grid.Columns[i].HeaderText)));
                }
                Response.Write("</Row>\n");
            }
            if (!Response.IsClientConnected)
                return;

            for (int i = 0; i < grid.Rows.Count; i++)
            {
                GridViewRow row = grid.Rows[i];
                Response.Write("<Row>\n");
                for (int j = 0; j < row.Cells.Count; j++)
                {
                    if (grid.Columns[j].Visible)
                        Response.Write(GetGridRowCellXML(grid, row, j));
                }
                Response.Write("</Row>\n");
                if (!Response.IsClientConnected)
                    return;
            }
            if (!Response.IsClientConnected)
                return;
            if (grid.ShowFooter && grid.FooterRow != null)
            {
                Response.Write("<Row>\n");
                for (int i = 0; i < grid.Columns.Count; i++)
                {
                    if (!grid.Columns[i].Visible)
                        continue;

                    if (grid.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Right)
                        Response.Write("<Cell ss:StyleID=\"rb\">");
                    else if (grid.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Center)
                        Response.Write("<Cell ss:StyleID=\"cb\">");
                    else Response.Write("<Cell ss:StyleID=\"b\">");
                    string valor = grid.FooterRow.Cells[i].Text;
                    Response.Write(string.Format("<Data ss:Type=\"{0}\">{1}</Data></Cell>", GetTypeValue(ref valor), RenderPage.GetXMLString(valor)));
                }
                Response.Write("</Row>\n");
            }

            if (paging)
                grid.AllowPaging = true;
        }
    }
}
