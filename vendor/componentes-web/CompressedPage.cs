using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

namespace SDG.Web.UI
{
    public class CompressedPage : System.Web.UI.Page
    {
        public static byte[] StringToByteArray(string hex)
        {
            hex = hex.Replace("0x", "")
                .Replace(",", "").Replace(" ", "");
            try
            {
                return Enumerable.Range(0, hex.Length)
                             .Where(x => x % 2 == 0)
                             .Select(x => Convert.ToByte(hex.Substring(x, 2), 16))
                             .ToArray();
            }
            catch { }
            return null;
        }

        public static void FixCheckBoxList(NameValueCollection Form, ControlCollection controles) {
            if (!Utilidades.IsMono)
                return;
            foreach (Control control in controles) {
                if (control is CheckBoxList) {
                    CheckBoxList checkboxlist = (CheckBoxList)control;
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

        // corrige el bug del mono que no guarda el estado de los checkboxlist
        public void Page_Load() {

            if (IsPostBack) {
                if(Utilidades.IsMono)
                    FixCheckBoxList(Request.Form, Controls);
            }
        }

        protected override object LoadPageStateFromPersistenceMedium()
        {
            Type t = Type.GetType("Mono.Runtime");
            if (t != null) { // se esta ejecutando en mono

                string variable = Request.Form["__VC"];
                if (!string.IsNullOrEmpty(variable))
                {
                    // esta version de mono no tenia implementado MachineKey.UnProtect
                    using (MemoryStream builder = new MemoryStream(Serializar.Decompress(MachineKey.Decode(
                        BitConverter.ToString(Convert.FromBase64String(variable)).Replace("-", "")
                        , MachineKeyProtection.All))))
                    // using (MemoryStream builder = new MemoryStream(MachineKey.Unprotect(Serializar.Decompress(Convert.FromBase64String(variable)), "ViewState")))
                    {
                        BinaryFormatter deserializer = new BinaryFormatter();
                        object info = deserializer.Deserialize(builder);
                        builder.Close();
                        return (object)info;
                    }
                }
                return null;
                // return Serializar.DesSerializeBinary<object>(Request.Form["__VC"]);
            }

            PageStatePersister.Load();
            var base64 = PageStatePersister.ViewState.ToString();
            var state = Serializar.Decompress(Convert.FromBase64String(base64));
            var serializedState = Convert.ToBase64String(state);

            var viewState = new LosFormatter().Deserialize(serializedState);
            return new Pair(PageStatePersister.ControlState, viewState);
        }

        protected override void SavePageStateToPersistenceMedium(object state)
        {
            Type t = Type.GetType("Mono.Runtime");
            if (t != null) { // se esta ejecutando en mono

                MemoryStream builder = new MemoryStream();
                BinaryFormatter bFormatter = new BinaryFormatter();

                bFormatter.Serialize(builder, state);
                builder.Flush();
                builder.Position = 0;

                ClientScript.RegisterHiddenField("__VC", Convert.ToBase64String(StringToByteArray(
                    MachineKey.Encode(Serializar.Compress(builder.ToArray()), MachineKeyProtection.All))
                ));

                // esta version de mono no tenia implementado MachineKey.Protect
                // ClientScript.RegisterHiddenField("__VC", Convert.ToBase64String(Serializar.Compress(MachineKey.Protect(builder.ToArray(), "ViewState"))));
                // ClientScript.RegisterHiddenField("__VC", Serializar.SerializeBinary(state));
                return;
            }

            var viewState = state;

            // Strip controlstate if necessary.
            var pair = state as Pair;
            if (pair != null)
            {
                // Sometimes the state object contains ControlState and ViewState, this handles that case.
                PageStatePersister.ControlState = pair.First;
                viewState = pair.Second;
            }

            using (var writer = new StringWriter(CultureInfo.InvariantCulture))
            {
                new LosFormatter().Serialize(writer, viewState);
                var base64 = writer.ToString();
                var compressed = Serializar.Compress(Convert.FromBase64String(base64));
                PageStatePersister.ViewState = Convert.ToBase64String(compressed);
            }

            PageStatePersister.Save();
        }
    }
}
