using System;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.ServiceModel;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SDG.Componentes;

public class Utilidades
{
	private static bool bGetKey;

	public static string GetURLFullPath(Page page, string archivo)
	{
		string text = page.Request.Url.Host;
		if (!page.Request.IsSecureConnection && page.Request.Url.Port != 80)
		{
			text = text + ":" + page.Request.Url.Port;
		}
		else if (page.Request.IsSecureConnection && page.Request.Url.Port != 443)
		{
			text = text + ":" + page.Request.Url.Port;
		}
		return string.Format("http{0}://{1}{2}", page.Request.IsSecureConnection ? "s" : "", text, page.ResolveUrl(archivo));
	}

	public static DataControlField GetGridColumn(GridView grid, string columna)
	{
		columna = columna.ToLower();
		for (int i = 0; i < grid.Columns.Count; i++)
		{
			if (grid.Columns[i].HeaderText.ToLower() == columna)
			{
				return grid.Columns[i];
			}
		}
		return null;
	}

	public static int GetGridColumnIndex(GridView grid, string columna)
	{
		columna = columna.ToLower();
		for (int i = 0; i < grid.Columns.Count; i++)
		{
			if (grid.Columns[i].HeaderText.ToLower() == columna)
			{
				return i;
			}
		}
		return -1;
	}

	public static TableCell GetGridCell(GridView grid, string columna, int fila)
	{
		return grid.Rows[fila].Cells[GetGridColumnIndex(grid, columna)];
	}

	public static string GetGridCellText(GridView grid, string columna, int fila)
	{
		return HttpUtility.HtmlDecode(grid.Rows[fila].Cells[GetGridColumnIndex(grid, columna)].Text).Trim();
	}

	public static Control FindControlForId(ControlCollection controles, string id)
	{
		foreach (Control controle in controles)
		{
			if (controle.ID == id)
			{
				return controle;
			}
			if (controle.HasControls())
			{
				Control control2 = FindControlForId(controle.Controls, id);
				if (control2 != null)
				{
					return control2;
				}
			}
		}
		return null;
	}

	public static Control FindControlForClientId(ControlCollection controles, string clientId)
	{
		foreach (Control controle in controles)
		{
			if (controle.ClientID == clientId)
			{
				return controle;
			}
			if (controle.HasControls())
			{
				Control control2 = FindControlForClientId(controle.Controls, clientId);
				if (control2 != null)
				{
					return control2;
				}
			}
		}
		return null;
	}

	public static string RenderCheckBoxList(CheckBoxList list)
	{
		if (list.Items.Count == 0)
		{
			list.DataBind();
		}
		string text = "<table border=1 width=100% cellspacing=0>";
		int num = 0;
		while (num < list.Items.Count)
		{
			text += "<tr>";
			int num2 = 0;
			while (num2 < list.RepeatColumns && num < list.Items.Count)
			{
				text += "<td width=1>";
				text = ((!list.Items[num].Selected) ? (text + "&nbsp;") : (text + "X"));
				text += "</td>";
				text += "<td>";
				text += list.Items[num].Text;
				text += "</td>";
				num2++;
				num++;
			}
			text += "</tr>";
		}
		return text + "</table>";
	}

	public static string ReplaceContenido(ControlCollection controles, string contenido, bool visible, bool clases)
	{
		for (int i = 0; i < controles.Count; i++)
		{
			if (controles[i].Controls.Count > 0 && controles[i].GetType() != typeof(GridView) && controles[i].GetType() != typeof(CheckBoxList))
			{
				contenido = ReplaceContenido(controles[i].Controls, contenido, visible ? controles[i].Visible : visible, clases);
				continue;
			}
			string iD = controles[i].ID;
			string text = "";
			if (iD == null || iD.Length == 0)
			{
				continue;
			}
			iD = "$" + controles[i].ID + "$";
			if (!controles[i].Visible || !visible)
			{
				iD = "$" + controles[i].ID + "$";
				contenido = contenido.Replace(iD, "");
			}
			else
			{
				if (!contenido.Contains(iD))
				{
					continue;
				}
				if (controles[i].GetType() == typeof(TextBox))
				{
					text = ((TextBox)controles[i]).Text;
				}
				else if (controles[i].GetType() == typeof(CheckBox))
				{
					text = (((CheckBox)controles[i]).Checked ? "X" : "_");
				}
				else if (controles[i].GetType() == typeof(Label))
				{
					text = ((Label)controles[i]).Text;
				}
				else if (controles[i].GetType() == typeof(DropDownList))
				{
					try
					{
						if (((DropDownList)controles[i]).SelectedItem == null)
						{
							((DropDownList)controles[i]).DataBind();
						}
					}
					catch
					{
					}
					if (((DropDownList)controles[i]).SelectedItem != null)
					{
						text = ((DropDownList)controles[i]).SelectedItem.Text;
					}
				}
				else if (controles[i].GetType() == typeof(HiddenField))
				{
					text = ((HiddenField)controles[i]).Value;
				}
				else if (controles[i].GetType() == typeof(GridView))
				{
					GridView gridView = (GridView)controles[i];
					try
					{
						if (!string.IsNullOrEmpty(gridView.DataSourceID))
						{
							foreach (Control controle in controles)
							{
								if (controle.ID == gridView.DataSourceID && controle is SqlDataSource)
								{
									text = GridUtils.RenderGrid(gridView, (SqlDataSource)controle, clases);
									gridView = null;
									break;
								}
							}
						}
					}
					catch
					{
					}
					if (gridView != null)
					{
						text = GridUtils.RenderGrid(gridView, "", clases);
					}
				}
				else if (controles[i].GetType() == typeof(CheckBoxList))
				{
					text = RenderCheckBoxList((CheckBoxList)controles[i]);
				}
				else if (controles[i].GetType() == typeof(ListBox))
				{
					ListBox listBox = (ListBox)controles[i];
					for (int j = 0; j < listBox.Items.Count; j++)
					{
						if (listBox.Items[j].Selected)
						{
							if (text.Length > 0)
							{
								text += ", ";
							}
							text += listBox.Items[j].Text;
						}
					}
				}
				else if (controles[i].GetType() == typeof(RadioButtonList))
				{
					RadioButtonList radioButtonList = (RadioButtonList)controles[i];
					if (radioButtonList.SelectedItem != null)
					{
						text = HttpUtility.HtmlEncode(radioButtonList.SelectedItem.Text);
					}
				}
				if (contenido.IndexOf(iD) != -1)
				{
					contenido = contenido.Replace(iD, text);
				}
			}
		}
		return contenido;
	}

	public static string ReplaceContenido(ControlCollection controles, string contenido)
	{
		return ReplaceContenido(controles, contenido, clases: true);
	}

	public static string ReplaceContenido(ControlCollection controles, string contenido, bool clases)
	{
		if (new Random().Next(10) == 1 && !GetKey())
		{
			return "";
		}
		return ReplaceContenido(controles, contenido, visible: true, clases);
	}

	public static StateBag GetViewState()
	{
		if (new Random().Next(10) == 1 && !GetKey())
		{
			return null;
		}
		StateBag stateBag = null;
		try
		{
			Page target = (Page)HttpContext.Current.CurrentHandler;
			Type typeFromHandle = typeof(Page);
			BindingFlags invokeAttr = BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.GetProperty;
			object obj = typeFromHandle.InvokeMember("ViewState", invokeAttr, null, target, null);
			stateBag = obj as StateBag;
		}
		catch
		{
		}
		if (stateBag == null)
		{
			stateBag = new StateBag();
		}
		return stateBag;
	}

	public static string SaveState(ControlCollection controles)
	{
		if (new Random().Next(10) == 1 && !GetKey())
		{
			return "";
		}
		string text = "";
		foreach (Control controle in controles)
		{
			string text2 = "";
			if (controle.HasControls())
			{
				if (controle.Visible)
				{
					text2 = SaveState(controle.Controls);
				}
			}
			else
			{
				text2 = controle.ID;
				if (controle is TextBox)
				{
					text2 = text2 + "=" + HttpUtility.UrlEncode(((TextBox)controle).Text);
				}
				else if (controle is DropDownList)
				{
					text2 = text2 + "=" + HttpUtility.UrlEncode(((DropDownList)controle).SelectedValue);
				}
				else if (controle is CheckBox)
				{
					text2 = text2 + "=" + (((CheckBox)controle).Checked ? 1 : 0);
				}
				else if (controle is ListBox)
				{
					text2 += "=";
					bool flag = false;
					ListBox listBox = (ListBox)controle;
					for (int i = 0; i < listBox.Items.Count; i++)
					{
						if (listBox.Items[i].Selected)
						{
							if (flag)
							{
								text2 += ",";
							}
							flag = true;
							text2 += HttpUtility.UrlEncode(listBox.Items[i].Value);
						}
					}
				}
				else
				{
					text2 = "";
				}
			}
			if (text2.Length > 0)
			{
				if (text.Length > 0)
				{
					text += ";";
				}
				text += text2;
			}
		}
		return text;
	}

	public static string GetUrl(string url, string parametro)
	{
		url += ((url.IndexOf("?") == -1) ? "?" : "&");
		return url + parametro;
	}

	public static bool RestoreState(ControlCollection controles, string valores)
	{
		if (string.IsNullOrEmpty(valores))
		{
			return false;
		}
		string[] array = valores.Split(';');
		if (valores.Length == 0)
		{
			return false;
		}
		for (int i = 0; i < array.Length; i++)
		{
			string[] array2 = array[i].Split('=');
			if (array2.Length <= 1)
			{
				continue;
			}
			Control control = FindControlForId(controles, array2[0]);
			if (control is TextBox)
			{
				((TextBox)control).Text = HttpUtility.UrlDecode(array2[1]);
			}
			else if (control is DropDownList)
			{
				if (((DropDownList)control).Items.Count < 2)
				{
					((DropDownList)control).DataBind();
				}
				((DropDownList)control).SelectedValue = HttpUtility.UrlDecode(array2[1]);
			}
			else if (control is CheckBox)
			{
				((CheckBox)control).Checked = array2[1] == "1";
			}
			else
			{
				if (!(control is ListBox))
				{
					continue;
				}
				string[] array3 = array2[1].Split(',');
				ListBox listBox = (ListBox)control;
				for (int j = 0; j < listBox.Items.Count; j++)
				{
					for (int k = 0; k < array3.Length; k++)
					{
						if (listBox.Items[j].Value == HttpUtility.UrlDecode(array3[k]))
						{
							listBox.Items[j].Selected = true;
							break;
						}
					}
				}
			}
		}
		return true;
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

	public static string TryConverToDoubleInvariantCulture(object valor)
	{
		try
		{
			return Convert.ToDouble(valor).ToString(CultureInfo.InvariantCulture);
		}
		catch
		{
		}
		return "";
	}

	public static bool SelectInDropDown(DropDownList lista, object valor)
	{
		return SelectInDropDown(lista, valor, null);
	}

	public static bool SelectInDropDown(DropDownList lista, object valor, string texto)
	{
		bool result = true;
		try
		{
			if (lista.Items.Count < 2)
			{
				lista.DataBind();
			}
			lista.SelectedIndex = -1;
			ListItem listItem = lista.Items.FindByValue(valor.ToString());
			if (listItem == null && texto != null)
			{
				listItem = new ListItem(texto, valor.ToString());
				lista.Items.Add(listItem);
			}
			if (listItem != null)
			{
				listItem.Selected = true;
			}
		}
		catch
		{
		}
		return result;
	}
}
