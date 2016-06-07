using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace SDG.Componentes
{
    public partial class GridUtils
    {
        public static string GetTypeValueXLSX(string value) {
            if (string.IsNullOrEmpty(value))
                return ">";
            string cleanvalue = value;
            if (value.Contains("$"))
                cleanvalue = value.Replace("$", "");
            if (!RegexIntegerStartWithZero.IsMatch(cleanvalue))
            {
                try
                {
                    return string.Format(CultureInfo.InvariantCulture, "><v>{0}</v>", Convert.ToDouble(cleanvalue));
                }
                catch { }
                try
                {
                    return string.Format(CultureInfo.InvariantCulture, "><v>{0}</v>", Convert.ToDouble(cleanvalue));
                }
                catch { }
                try
                {
                    return string.Format(CultureInfo.InvariantCulture, "><v>{0}</v>", Convert.ToDouble(cleanvalue, CultureInfo.InvariantCulture));
                }
                catch { }
            }
            return string.Format(" t=\"inlineStr\"><is><t>{0}</t></is>", RenderPage.GetXMLString(value));
        }

        public static string GetTypeValueXLSX(object value)
        {
            if (value == null)
                return ">";
            if (value is DateTime) {
                DateTime date = (DateTime)value;
                return string.Format(CultureInfo.InvariantCulture, " s=\"{1}\"><v>{0}</v>", date.ToOADate(), date.Hour == 0 && date.Minute == 0 && date.Second == 0 ? 7 : 6);
            }
            if (value is int || value is uint || value is long || value is ulong || value is short || value is ushort || value is double || value is float || value is decimal) {
                return string.Format(CultureInfo.InvariantCulture, "><v>{0}</v>", value);
            }
            return GetTypeValueXLSX(value is string ? value as string : value.ToString());
        }


        static public string GetGridRowCellXLSX(GridView grid, GridViewRow row, int columna)
        {
            StringBuilder resultado = new StringBuilder();

            if (grid.Columns[columna].ItemStyle.HorizontalAlign == HorizontalAlign.Right)
                resultado.Append(string.Format("<c s=\"{0}\"", grid.Columns[columna].ItemStyle.Font.Bold ? "5" : "3"));
            else if (grid.Columns[columna].ItemStyle.HorizontalAlign == HorizontalAlign.Center)
                resultado.Append(string.Format("<c s=\"{0}\"", grid.Columns[columna].ItemStyle.Font.Bold ? "4" : "2"));
            else resultado.Append(string.Format("<c s=\"{0}\"", grid.Columns[columna].ItemStyle.Font.Bold ? "1" : "0"));

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
                        // valor = string.Format("<img src='{0}' />", Utilidades.GetURLFullPath(imagen.ImageUrl));
                    }
                    else if (controles[k] is Label)
                    {
                        valor = ((Label)controles[k]).Text;
                    }
                }
            }
            else valor = row.Cells[columna].Text;

            resultado.Append(GetTypeValueXLSX(valor));
            resultado.Append("</c>");
            return resultado.ToString();
        }

        public static void ExportExcelXLSX(HttpResponseBase Response, Conector conector, string query, string fullPath, string titulo, string author, List<string> Headers=null, Func<string, object, object>FuncFormat=null) {

            // Request.Headers["Accept-Encoding"] = "";
            Response.Clear();
            // Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode(titulo + ".xlsx"));
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";


            using (var outputStream = new PositionWrapperStream(Response.OutputStream))
            using (ZipArchive zipArchive = new ZipArchive(outputStream, ZipArchiveMode.Create))
            {
                RenderPage.RenderXLSX(Response, zipArchive, fullPath, titulo, author);

                ZipArchiveEntry zipEntry = zipArchive.CreateEntry("xl/worksheets/sheet1.xml");
                using (Stream zipStream = zipEntry.Open())
                {
                    RenderPage.WriteString(zipStream, @"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>
<worksheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"" xmlns:r=""http://schemas.openxmlformats.org/officeDocument/2006/relationships"" xmlns:mc=""http://schemas.openxmlformats.org/markup-compatibility/2006"" mc:Ignorable=""x14ac"" xmlns:x14ac=""http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"">
	<sheetData>");

                    MySqlDataReader reader= conector.Query(query);
                    if (reader != null)
                    {
                        RenderPage.WriteString(zipStream, "<row>\n");
                        if (Headers == null || Headers.Count == 0)
                        {
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                // Fix the encoding of headers from mysql
                                RenderPage.WriteString(zipStream, string.Format("<c s=\"4\" t=\"inlineStr\"><is><t>{0}</t></is></c>", RenderPage.GetXMLString(Encoding.UTF8.GetString(Encoding.Default.GetBytes(reader.GetName(i))))));
                            }
                        } else {
                            for (int i = 0; i < Headers.Count; i++) {
                                RenderPage.WriteString(zipStream, string.Format("<c s=\"4\" t=\"inlineStr\"><is><t>{0}</t></is></c>", RenderPage.GetXMLString(Headers[i])));
                            }
                        }
                        RenderPage.WriteString(zipStream, "</row>\n");
                        while (Response.IsClientConnected && reader.Read())
                        {
                            RenderPage.WriteString(zipStream, "<row>\n");
                            for (int j = 0; j < reader.FieldCount; j++)
                            {
                                RenderPage.WriteString(zipStream, "<c");
                                RenderPage.WriteString(zipStream, GetTypeValueXLSX(FuncFormat == null ? reader[j] : FuncFormat(reader.GetName(j), reader[j])));
                                RenderPage.WriteString(zipStream, "</c>");
                            }
                            RenderPage.WriteString(zipStream, "</row>\n");
                        }
                    }

                    RenderPage.WriteString(zipStream, @"</sheetData></worksheet>");
                    Response.Flush();
                    zipStream.Close();
                }
            }

            Response.End();
        }

        public static void ExportExcelXLSX(HttpResponse Response, GridView view, string fullPath, string titulo, string author)
        {
            bool paging = view.AllowPaging;
            if (paging)
            {
                view.AllowPaging = false;
                view.DataBind();
            }

            Response.Clear();
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode(titulo + ".xlsx"));
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";


            using (var outputStream = new PositionWrapperStream(Response.OutputStream))
            using (ZipArchive zipArchive = new ZipArchive(outputStream, ZipArchiveMode.Create))
            {
                RenderPage.RenderXLSX(Response, zipArchive, fullPath, titulo, author);

                ZipArchiveEntry zipEntry = zipArchive.CreateEntry("xl/worksheets/sheet1.xml");
                using (Stream zipStream = zipEntry.Open())
                {
                    RenderPage.WriteString(zipStream, @"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>
<worksheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"" xmlns:r=""http://schemas.openxmlformats.org/officeDocument/2006/relationships"" xmlns:mc=""http://schemas.openxmlformats.org/markup-compatibility/2006"" mc:Ignorable=""x14ac"" xmlns:x14ac=""http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"">
	<sheetData>");

                    if (view.ShowHeader)
                    {
                        RenderPage.WriteString(zipStream, "<row>\n");
                        for (int i = 0; i < view.Columns.Count; i++)
                        {
                            if (view.Columns[i].Visible)
                            {
                                RenderPage.WriteString(zipStream, string.Format("<c s=\"4\" t=\"inlineStr\"><is><t>{0}</t></is></c>", RenderPage.GetXMLString(view.Columns[i].HeaderText)));
                            }
                        }
                        RenderPage.WriteString(zipStream, "</row>\n");
                    }

                    for (int i = 0; i < view.Rows.Count; i++)
                    {
                        RenderPage.WriteString(zipStream, "<row>\n");
                        for (int j = 0; j < view.Columns.Count; j++)
                        {
                            if (view.Columns[j].Visible)
                            {
                                RenderPage.WriteString(zipStream, GetGridRowCellXLSX(view, view.Rows[i], j));
                            }
                        }
                        RenderPage.WriteString(zipStream, "</row>\n");
                    }

                    RenderPage.WriteString(zipStream, @"</sheetData></worksheet>");
                    Response.Flush();
                    zipStream.Close();
                }
            }

            Response.End();

            if (paging)
            {
                view.AllowPaging = true;
            }
        }

        static public string GetGridRowCellXLSX(DataControlField dataColumn, DataRow row, int columna)
        {
            StringBuilder resultado = new StringBuilder();

            if (dataColumn.ItemStyle.HorizontalAlign == HorizontalAlign.Right)
                resultado.Append(string.Format("<c s=\"{0}\"", dataColumn.ItemStyle.Font.Bold ? "5" : "3"));
            else if (dataColumn.ItemStyle.HorizontalAlign == HorizontalAlign.Center)
                resultado.Append(string.Format("<c s=\"{0}\"", dataColumn.ItemStyle.Font.Bold ? "4" : "2"));
            else resultado.Append(string.Format("<c s=\"{0}\"", dataColumn.ItemStyle.Font.Bold ? "1" : "0"));

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
            resultado.Append(GetTypeValueXLSX(valor));
            resultado.Append("</c>");
            return resultado.ToString();
        }

        static public void RenderGridXLSX(HttpResponse HttpResponse, Stream zipOutputStream, GridView gridView, SqlDataSource sql)
        {

            DataView resultados = (DataView)sql.Select(DataSourceSelectArguments.Empty);
            DataTable tabla = resultados.Table;

            if (tabla.Rows.Count == 0)
            {
                RenderPage.WriteString(zipOutputStream, string.Format("<row><c t=\"inlineStr\"><is><t>{0}</t></is></c></row>", RenderPage.GetXMLString(gridView.EmptyDataText)));
                HttpResponse.Flush();
                return;
            }

            if (gridView.ShowHeader)
            {
                RenderPage.WriteString(zipOutputStream, "<row>\n");
                for (int i = 0; i < gridView.Columns.Count; i++)
                {
                    if (!gridView.Columns[i].Visible)
                        continue;
                    RenderPage.WriteString(zipOutputStream, string.Format("<c s=\"4\" t=\"inlineStr\"><is><t>{0}</t></is></c>", RenderPage.GetXMLString(gridView.Columns[i].HeaderText)));
                }
                RenderPage.WriteString(zipOutputStream, "</row>\n");
            }
            if (!HttpResponse.IsClientConnected)
                return;
            // bool alternativo = true;

            for (int i = 0; i < tabla.Rows.Count; i++)
            {
                DataRow row = tabla.Rows[i];
                RenderPage.WriteString(zipOutputStream, "<row>\n");
                for (int j = 0; j < gridView.Columns.Count; j++)
                {
                    if (gridView.Columns[j].Visible)
                        RenderPage.WriteString(zipOutputStream, GetGridRowCellXLSX(gridView.Columns[j], row, j));
                }
                RenderPage.WriteString(zipOutputStream, "</row>\n");
                if (!HttpResponse.IsClientConnected)
                    return;
            }
            if (!HttpResponse.IsClientConnected)
                return;
            if (gridView.ShowFooter && gridView.FooterRow != null)
            {
                RenderPage.WriteString(zipOutputStream, "<row>\n");
                for (int i = 0; i < gridView.Columns.Count; i++)
                {
                    if (!gridView.Columns[i].Visible)
                        continue;
                    if (gridView.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Right)
                        RenderPage.WriteString(zipOutputStream, "<c");
                    else if (gridView.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Center)
                        RenderPage.WriteString(zipOutputStream, "<c");
                    else RenderPage.WriteString(zipOutputStream, "<c");
                    string valor = gridView.FooterRow.Cells[i].Text;
                    RenderPage.WriteString(zipOutputStream, string.Format("{0}</c>", GetTypeValueXLSX(valor)));
                }
                RenderPage.WriteString(zipOutputStream, "</row>\n");
            }
        }

        static public void RenderGridXLSX(HttpResponse HttpResponse, Stream zipOutputStream, GridView grid)
        {
            if (grid.Rows.Count == 0)
            {
                RenderPage.WriteString(zipOutputStream, string.Format("<row><c t=\"inlineStr\"><is><t>{0}</t></is></c></row>", RenderPage.GetXMLString(grid.EmptyDataText)));
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
                RenderPage.WriteString(zipOutputStream, "<row>\n");
                for (int i = 0; i < grid.Columns.Count; i++)
                {
                    if (!grid.Columns[i].Visible)
                        continue;
                    RenderPage.WriteString(zipOutputStream, string.Format("<c s=\"1\" t=\"inlineStr\"><is><t>{0}</t></is></c>", RenderPage.GetXMLString(grid.Columns[i].HeaderText)));
                }
                RenderPage.WriteString(zipOutputStream, "</row>\n");
            }
            if (!HttpResponse.IsClientConnected)
                return;

            for (int i = 0; i < grid.Rows.Count; i++)
            {
                GridViewRow row = grid.Rows[i];
                RenderPage.WriteString(zipOutputStream, "<row>\n");
                for (int j = 0; j < row.Cells.Count; j++)
                {
                    if (grid.Columns[j].Visible)
                        RenderPage.WriteString(zipOutputStream, GetGridRowCellXLSX(grid, row, j));
                }
                RenderPage.WriteString(zipOutputStream, "</row>\n");
                if (!HttpResponse.IsClientConnected)
                    return;
            }
            if (!HttpResponse.IsClientConnected)
                return;
            if (grid.ShowFooter && grid.FooterRow != null)
            {
                RenderPage.WriteString(zipOutputStream, "<row>\n");
                for (int i = 0; i < grid.Columns.Count; i++)
                {
                    if (!grid.Columns[i].Visible)
                        continue;

                    if (grid.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Right)
                        RenderPage.WriteString(zipOutputStream, "<c");
                    else if (grid.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Center)
                        RenderPage.WriteString(zipOutputStream, "<c");
                    else RenderPage.WriteString(zipOutputStream, "<c");
                    string valor = grid.FooterRow.Cells[i].Text;
                    RenderPage.WriteString(zipOutputStream, string.Format("{0}</c>", GetTypeValueXLSX(valor)));
                }
                RenderPage.WriteString(zipOutputStream, "</row>\n");
            }

            if (paging)
                grid.AllowPaging = true;
        }
    }
}
