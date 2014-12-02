using System.Web.UI;
using SDG.Componentes;

namespace SDG.Web.UI;

public class CompressedPage : Page
{
	protected override object LoadPageStateFromPersistenceMedium()
	{
		return Serializar.DesSerializeBinary<object>(base.Request.Form["__VC"]);
	}

	protected override void SavePageStateToPersistenceMedium(object state)
	{
		base.ClientScript.RegisterHiddenField("__VC", Serializar.SerializeBinary(state));
	}
}
