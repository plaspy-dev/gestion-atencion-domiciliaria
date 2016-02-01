using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPageI : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            LT.Text = Page.Title;
            LV.Text = HomeCareVersion.Number;
        }
    }

    public void SetParametros(string parametros)
    {
        Session["parametros"] = parametros;
    }
}
