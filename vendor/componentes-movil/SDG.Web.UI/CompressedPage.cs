using System;
using System.Collections.Specialized;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

namespace SDG.Web.UI;

public class CompressedPage : Page
{
	public static byte[] StringToByteArray(string hex)
	{
		hex = hex.Replace("0x", "").Replace(",", "").Replace(" ", "");
		try
		{
			return (from x in Enumerable.Range(0, hex.Length)
				where x % 2 == 0
				select Convert.ToByte(hex.Substring(x, 2), 16)).ToArray();
		}
		catch
		{
		}
		return null;
	}

	public static void FixCheckBoxList(NameValueCollection Form, ControlCollection controles)
	{
		if (!Utilidades.IsMono)
		{
			return;
		}
		foreach (Control controle in controles)
		{
			if (controle is CheckBoxList)
			{
				CheckBoxList checkBoxList = (CheckBoxList)controle;
				for (int i = 0; i < checkBoxList.Items.Count; i++)
				{
					string name = $"{checkBoxList.UniqueID}${i}";
					checkBoxList.Items[i].Selected = !string.IsNullOrEmpty(Form[name]);
				}
			}
			if (controle.HasControls())
			{
				FixCheckBoxList(Form, controle.Controls);
			}
		}
	}

	public void Page_Load()
	{
		if (base.IsPostBack && Utilidades.IsMono)
		{
			FixCheckBoxList(base.Request.Form, Controls);
		}
	}

	protected override object LoadPageStateFromPersistenceMedium()
	{
		if (Type.GetType("Mono.Runtime") != null)
		{
			string text = base.Request.Form["__VC"];
			if (!string.IsNullOrEmpty(text))
			{
				using (MemoryStream memoryStream = new MemoryStream(Serializar.Decompress(MachineKey.Decode(BitConverter.ToString(Convert.FromBase64String(text)).Replace("-", ""), MachineKeyProtection.All))))
				{
					object result = new BinaryFormatter().Deserialize(memoryStream);
					memoryStream.Close();
					return result;
				}
			}
			return null;
		}
		PageStatePersister.Load();
		string input = Convert.ToBase64String(Serializar.Decompress(Convert.FromBase64String(PageStatePersister.ViewState.ToString())));
		object y = new LosFormatter().Deserialize(input);
		return new Pair(PageStatePersister.ControlState, y);
	}

	protected override void SavePageStateToPersistenceMedium(object state)
	{
		if (Type.GetType("Mono.Runtime") != null)
		{
			MemoryStream memoryStream = new MemoryStream();
			new BinaryFormatter().Serialize(memoryStream, state);
			memoryStream.Flush();
			memoryStream.Position = 0L;
			base.ClientScript.RegisterHiddenField("__VC", Convert.ToBase64String(StringToByteArray(MachineKey.Encode(Serializar.Compress(memoryStream.ToArray()), MachineKeyProtection.All))));
			return;
		}
		object value = state;
		if (state is Pair pair)
		{
			PageStatePersister.ControlState = pair.First;
			value = pair.Second;
		}
		using (StringWriter stringWriter = new StringWriter(CultureInfo.InvariantCulture))
		{
			new LosFormatter().Serialize(stringWriter, value);
			byte[] inArray = Serializar.Compress(Convert.FromBase64String(stringWriter.ToString()));
			PageStatePersister.ViewState = Convert.ToBase64String(inArray);
		}
		PageStatePersister.Save();
	}
}
