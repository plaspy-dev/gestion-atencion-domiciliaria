using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class rh_funcionarioc : System.Web.UI.UserControl
{
    public string Id
    {
        set { HIdFuncionario.Value = value; }
    }
    public string Nombre
    {
        set { TFuncionario.Text = value; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {

    }
}
