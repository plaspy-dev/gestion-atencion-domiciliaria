using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using System.Configuration;

public partial class inicio : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
#if DEBUG
#else
        // Response.Redirect(CURLs.SwitchApp("~/Inicio.aspx", ConfigurationSettings.AppSettings["app"]));
#endif
    }
}
