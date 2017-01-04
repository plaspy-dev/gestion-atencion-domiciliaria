using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class evento_eventoselect : System.Web.UI.UserControl
{
    public string IdEvento {
        get {
            return I.Text;
        }
        set {
            I.Text = value;
            T.Text = "";
            if (!string.IsNullOrEmpty(value)) {
                using (CConector conector = new CConector())
                    T.Text = conector.QueryString("SELECT nombre FROM evento WHERE id=" + Query.GetValor(value));
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) { }
    }
}