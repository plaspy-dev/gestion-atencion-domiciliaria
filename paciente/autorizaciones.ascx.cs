using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;

public partial class paciente_autorizaciones : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [Bindable(true), Category("Appearance"), DefaultValue("")]
    public string Value
    {
        get { return HId.Value; }
        set { HId.Value = value; }
    }
}
