using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Web.Security;
using System.Web.UI;
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

	protected override object LoadPageStateFromPersistenceMedium()
	{
		Type type = Type.GetType("Mono.Runtime");
		if (type != null)
		{
			string text = base.Request.Form["__VC"];
			if (!string.IsNullOrEmpty(text))
			{
				using (MemoryStream memoryStream = new MemoryStream(Serializar.Decompress(MachineKey.Decode(BitConverter.ToString(Convert.FromBase64String(text)).Replace("-", ""), MachineKeyProtection.All))))
				{
					BinaryFormatter binaryFormatter = new BinaryFormatter();
					object result = binaryFormatter.Deserialize(memoryStream);
					memoryStream.Close();
					return result;
				}
			}
			return null;
		}
		PageStatePersister.Load();
		string s = PageStatePersister.ViewState.ToString();
		byte[] inArray = Serializar.Decompress(Convert.FromBase64String(s));
		string input = Convert.ToBase64String(inArray);
		object y = new LosFormatter().Deserialize(input);
		return new Pair(PageStatePersister.ControlState, y);
	}

	protected override void SavePageStateToPersistenceMedium(object state)
	{
		Type type = Type.GetType("Mono.Runtime");
		if (type != null)
		{
			MemoryStream memoryStream = new MemoryStream();
			BinaryFormatter binaryFormatter = new BinaryFormatter();
			binaryFormatter.Serialize(memoryStream, state);
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
			string s = stringWriter.ToString();
			byte[] inArray = Serializar.Compress(Convert.FromBase64String(s));
			PageStatePersister.ViewState = Convert.ToBase64String(inArray);
		}
		PageStatePersister.Save();
	}
        public static void FixCheckBoxList(System.Collections.Specialized.NameValueCollection Form, System.Web.UI.ControlCollection controles) {

            if (System.Type.GetType("Mono.Runtime") == null)

                return;

            foreach (System.Web.UI.Control control in controles) {

                if (control is System.Web.UI.WebControls.CheckBoxList) {

                    System.Web.UI.WebControls.CheckBoxList checkboxlist = (System.Web.UI.WebControls.CheckBoxList)control;

                    for (int i = 0; i < checkboxlist.Items.Count; i++)

                    {

                        string uniqueid = string.Format("{0}${1}", checkboxlist.UniqueID, i);

                        checkboxlist.Items[i].Selected = !string.IsNullOrEmpty(Form[uniqueid]);

                    }

                }

                if(control.HasControls())

                    FixCheckBoxList(Form, control.Controls);

            }

        }
}
