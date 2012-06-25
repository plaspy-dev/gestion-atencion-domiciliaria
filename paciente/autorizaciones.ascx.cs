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
    protected void RDetalle_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        Label label = (Label)e.Item.FindControl("LD");
        try {
            Convert.ToInt32(label.Text);
            label.Text = Procedimientos.GetProcedimiento(label.Text);
        } catch(Exception a) {}
        label = (Label)e.Item.FindControl("LI");
        if (label.Text.Length != 0)
            label.Text = " [" + Procedimientos.GetVarios(label.Text) + "]";
    }
}
