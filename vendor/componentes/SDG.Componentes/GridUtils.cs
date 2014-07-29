using System;
using System.Configuration;
using System.Data;
using System.IO;
using System.Reflection;
using System.ServiceModel;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SDG.Componentes;

public class GridUtils
{
	private static bool bGetKey = false;

	public static string GetGridRowCellHTML(DataControlField dataColumn, DataRow row, int columna, bool clases)
	{
		string arg = " class='c" + columna + "'";
		if (!clases)
		{
			arg = "";
		}
		StringBuilder stringBuilder = new StringBuilder();
		if (dataColumn.ItemStyle.HorizontalAlign == HorizontalAlign.Right)
		{
			stringBuilder.AppendFormat("<td align=right{0}{1}>", arg, clases ? " style='text-align: right'" : "");
		}
		else if (dataColumn.ItemStyle.HorizontalAlign == HorizontalAlign.Center)
		{
			stringBuilder.AppendFormat("<td align=center{0}{1}>", arg, clases ? " style='text-align: center'" : "");
		}
		else
		{
			stringBuilder.AppendFormat("<td{0}>", arg);
		}
		string value = "";
		if (dataColumn is BoundField)
		{
			BoundField boundField = (BoundField)dataColumn;
			value = ((!string.IsNullOrEmpty(boundField.DataFormatString)) ? string.Format(boundField.DataFormatString, row[boundField.DataField]) : row[boundField.DataField].ToString());
		}
		else if (dataColumn is HyperLinkField)
		{
			HyperLinkField hyperLinkField = (HyperLinkField)dataColumn;
			value = ((!string.IsNullOrEmpty(hyperLinkField.DataTextFormatString)) ? string.Format(hyperLinkField.DataTextFormatString, row[hyperLinkField.DataTextField]) : row[hyperLinkField.DataTextField].ToString());
		}
		else if (dataColumn is TemplateField)
		{
			TemplateField templateField = (TemplateField)dataColumn;
			if (!string.IsNullOrEmpty(templateField.SortExpression))
			{
				value = row[templateField.SortExpression].ToString();
			}
		}
		stringBuilder.Append(value);
		stringBuilder.Append("</td>");
		return stringBuilder.ToString();
	}

	public static string RenderGrid(GridView gridView, SqlDataSource sql, bool clases)
	{
		if (new Random().Next(10) == 1 && !GetKey())
		{
			return "";
		}
		StringBuilder stringBuilder = new StringBuilder();
		DataView dataView = (DataView)sql.Select(DataSourceSelectArguments.Empty);
		DataTable table = dataView.Table;
		if (table.Rows.Count == 0)
		{
			return gridView.EmptyDataText;
		}
		stringBuilder.AppendFormat("<table id='{0}' class='tgrid'>", gridView.ID);
		stringBuilder.Append("<tr class='gh'>");
		for (int i = 0; i < gridView.Columns.Count; i++)
		{
			if (gridView.Columns[i].Visible)
			{
				stringBuilder.AppendFormat("<th class='h{0}' bgcolor='#EEEEEE'><b>{1}</b></th>", i, gridView.Columns[i].HeaderText);
			}
		}
		stringBuilder.Append("</tr>");
		bool flag = true;
		for (int i = 0; i < table.Rows.Count; i++)
		{
			DataRow row = table.Rows[i];
			flag = !flag;
			if (clases)
			{
				stringBuilder.Append(flag ? "<tr class='ga'>" : "<tr class='gr'>");
			}
			else
			{
				stringBuilder.Append("<tr>");
			}
			for (int j = 0; j < gridView.Columns.Count; j++)
			{
				if (gridView.Columns[j].Visible)
				{
					stringBuilder.Append(GetGridRowCellHTML(gridView.Columns[j], row, j, clases));
				}
			}
			stringBuilder.Append("</tr>");
		}
		if (gridView.ShowFooter && gridView.FooterRow != null)
		{
			stringBuilder.Append("<tr class='gf'>");
			for (int i = 0; i < gridView.Columns.Count; i++)
			{
				if (gridView.Columns[i].Visible)
				{
					if (gridView.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Right)
					{
						stringBuilder.AppendFormat("<td align=right class='f{0}' style='text-align: right'>", i);
					}
					else if (gridView.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Center)
					{
						stringBuilder.AppendFormat("<td align=center class='f{0}' style='text-align: center'>", i);
					}
					else
					{
						stringBuilder.AppendFormat("<td class='f{0}'>", i);
					}
					stringBuilder.AppendFormat("<b>{0}</b></td>", gridView.FooterRow.Cells[i].Text);
				}
			}
			stringBuilder.Append("</tr>");
		}
		stringBuilder.Append("</table>");
		return stringBuilder.ToString();
	}

	public static string RenderGrid(GridView grid)
	{
		return RenderGrid(grid, "width=100%");
	}

	public static string RenderGrid(GridView grid, string parametrostabla)
	{
		return RenderGrid(grid, parametrostabla, clases: true);
	}

	public static string RenderGrid(GridView grid, string parametrostabla, bool clases)
	{
		if (new Random().Next(10) == 1 && !GetKey())
		{
			return "";
		}
		if (grid.Rows.Count == 0)
		{
			return grid.EmptyDataText;
		}
		bool allowPaging = grid.AllowPaging;
		if (allowPaging)
		{
			grid.AllowPaging = false;
			grid.DataBind();
		}
		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.AppendFormat("<table {0} id='{1}' class='tgrid'>", parametrostabla, grid.ID);
		stringBuilder.Append("<tr class='gh'>");
		for (int i = 0; i < grid.Columns.Count; i++)
		{
			if (grid.Columns[i].Visible)
			{
				stringBuilder.AppendFormat("<th class='h{0}' bgcolor='#EEEEEE'><b>{1}</b></th>", i, grid.Columns[i].HeaderText);
			}
		}
		stringBuilder.Append("</tr>");
		bool flag = true;
		for (int i = 0; i < grid.Rows.Count; i++)
		{
			GridViewRow gridViewRow = grid.Rows[i];
			flag = !flag;
			if (clases)
			{
				stringBuilder.Append(flag ? "<tr class='ga'>" : "<tr class='gr'>");
			}
			else
			{
				stringBuilder.Append("<tr>");
			}
			for (int j = 0; j < gridViewRow.Cells.Count; j++)
			{
				if (grid.Columns[j].Visible)
				{
					stringBuilder.Append(GetGridRowCellHTML(grid, gridViewRow, j, clases));
				}
			}
			stringBuilder.Append("</tr>");
		}
		if (grid.ShowFooter && grid.FooterRow != null)
		{
			stringBuilder.Append("<tr class='gf'>");
			for (int i = 0; i < grid.Columns.Count; i++)
			{
				if (grid.Columns[i].Visible)
				{
					if (grid.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Right)
					{
						stringBuilder.AppendFormat("<td align=right class='f{0}' style='text-align: right'>", i);
					}
					else if (grid.Columns[i].FooterStyle.HorizontalAlign == HorizontalAlign.Center)
					{
						stringBuilder.AppendFormat("<td align=center class='f{0}' style='text-align: center'>", i);
					}
					else
					{
						stringBuilder.AppendFormat("<td class='f{0}'>", i);
					}
					stringBuilder.AppendFormat("<b>{0}</b></td>", grid.FooterRow.Cells[i].Text);
				}
			}
			stringBuilder.Append("</tr>");
		}
		stringBuilder.Append("</table>");
		if (allowPaging)
		{
			grid.AllowPaging = true;
		}
		return stringBuilder.ToString();
	}

	public static string GetGridRowCellHTML(GridView grid, GridViewRow row, int columna, bool clases)
	{
		string arg = " class='c" + columna + "'";
		if (!clases)
		{
			arg = "";
		}
		StringBuilder stringBuilder = new StringBuilder();
		if (grid.Columns[columna].ItemStyle.HorizontalAlign == HorizontalAlign.Right)
		{
			stringBuilder.AppendFormat("<td align=right{0}{1}>", arg, clases ? " style='text-align: right'" : "");
		}
		else if (grid.Columns[columna].ItemStyle.HorizontalAlign == HorizontalAlign.Center)
		{
			stringBuilder.AppendFormat("<td align=center{0}{1}>", arg, clases ? " style='text-align: center'" : "");
		}
		else
		{
			stringBuilder.AppendFormat("<td{0}>", arg);
		}
		if (row.Cells[columna].HasControls())
		{
			ControlCollection controls = row.Cells[columna].Controls;
			for (int i = 0; i < controls.Count; i++)
			{
				if (controls[i] is TextBox)
				{
					string text = ((TextBox)controls[i]).Text;
					if (text.Length == 0)
					{
						text = "&nbsp;";
					}
					stringBuilder.Append(text);
					break;
				}
				if (controls[i] is CheckBox)
				{
					if (((CheckBox)controls[i]).Checked)
					{
						stringBuilder.Append("X ");
					}
					else
					{
						stringBuilder.Append("_ ");
					}
					if (((CheckBox)controls[i]).Text.Length > 0)
					{
						stringBuilder.Append(((CheckBox)controls[i]).Text);
					}
					break;
				}
				if (controls[i] is LinkButton)
				{
					stringBuilder.Append(((LinkButton)controls[i]).Text);
				}
				else if (controls[i] is HyperLink)
				{
					stringBuilder.Append(((HyperLink)controls[i]).Text);
				}
			}
		}
		else
		{
			stringBuilder.Append(row.Cells[columna].Text);
		}
		stringBuilder.Append("</td>");
		return stringBuilder.ToString();
	}

	public static void ExportExcel(HttpResponse Response, GridView view, string titulo)
	{
		if (new Random().Next(10) == 1 && !GetKey())
		{
			return;
		}
		bool allowPaging = view.AllowPaging;
		if (allowPaging)
		{
			view.AllowPaging = false;
			view.DataBind();
		}
		Response.Clear();
		Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode(titulo + ".xls"));
		Response.ContentType = "application/vnd.ms-excel";
		Response.ContentEncoding = Encoding.GetEncoding("ISO-8859-1");
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
				{
					Response.Write(GetGridRowCellHTML(view, view.Rows[i], j, clases: false));
				}
			}
			Response.Write("</tr>\n");
		}
		Response.Write("</table></body></html>\n");
		Response.End();
		if (allowPaging)
		{
			view.AllowPaging = true;
		}
	}

	private static bool GetKey()
	{
#if ENABLE_LICENSE_CHECK
		string licenseSeed = Environment.GetEnvironmentVariable("ARCHIVED_DOMAIN_LICENSE_SEED");
		if (String.IsNullOrEmpty(licenseSeed)) return false;
		if (bGetKey)
		{
			return true;
		}
		try
		{
			string[] array = null;
			string text;
			if (HttpContext.Current == null)
			{
				text = ((OperationContext.Current != null) ? OperationContext.Current.IncomingMessageHeaders.To.Host : Path.GetFileName(Assembly.GetEntryAssembly().Location));
				if (text == "localhost")
				{
					return true;
				}
			}
			else
			{
				if (HttpContext.Current.Request.Url.Host == "localhost")
				{
					return true;
				}
				if (string.IsNullOrEmpty(ConfigurationSettings.AppSettings["DomainKey"]))
				{
					return false;
				}
				text = HttpContext.Current.Request.Url.Host;
			}
			array = ConfigurationSettings.AppSettings["DomainKey"].Split(';');
			for (int i = 0; i < array.Length; i++)
			{
				if (Crypt.GetMD5(Crypt.Encriptar3DES(text.PadRight(29, 'x').PadRight(37, '?').Replace("x", ";"), licenseSeed.Replace("2", "1").Replace("2", "6"))) == array[i])
				{
					bGetKey = true;
					return true;
				}
			}
			return false;
		}
		catch
		{
		}
		return false;
#else
		return true;
#endif
	}
}
