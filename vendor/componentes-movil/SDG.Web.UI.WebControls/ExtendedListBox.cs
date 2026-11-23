using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SDG.Web.UI.WebControls;

public class ExtendedListBox : ListBox
{
	protected override void RenderContents(HtmlTextWriter writer)
	{
		List<string> list = new List<string>();
		foreach (ListItem item in Items)
		{
			if (item.Attributes["OptionGroup"] == null)
			{
				RenderListItem(item, writer);
				continue;
			}
			string text = item.Attributes["OptionGroup"];
			if (list.Contains(text))
			{
				RenderListItem(item, writer);
				continue;
			}
			if (list.Count > 0)
			{
				RenderOptionGroupEndTag(writer);
			}
			RenderOptionGroupBeginTag(text, writer);
			list.Add(text);
			RenderListItem(item, writer);
		}
		if (list.Count > 0)
		{
			RenderOptionGroupEndTag(writer);
		}
	}

	private void RenderOptionGroupBeginTag(string name, HtmlTextWriter writer)
	{
		writer.WriteBeginTag("optgroup");
		writer.WriteAttribute("label", name);
		writer.Write('>');
		writer.WriteLine();
	}

	private void RenderOptionGroupEndTag(HtmlTextWriter writer)
	{
		writer.WriteEndTag("optgroup");
		writer.WriteLine();
	}

	private void RenderListItem(ListItem item, HtmlTextWriter writer)
	{
		writer.WriteBeginTag("option");
		writer.WriteAttribute("value", item.Value, fEncode: true);
		if (item.Selected)
		{
			writer.WriteAttribute("selected", "selected", fEncode: false);
		}
		foreach (string key in item.Attributes.Keys)
		{
			writer.WriteAttribute(key, item.Attributes[key]);
		}
		writer.Write('>');
		HttpUtility.HtmlEncode(item.Text, writer);
		writer.WriteEndTag("option");
		writer.WriteLine();
	}
}
