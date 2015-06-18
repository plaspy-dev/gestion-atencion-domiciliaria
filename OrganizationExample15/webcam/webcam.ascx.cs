using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class webcam_webcam : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {
            Session["webcam_foto"] = null;
        }
    }
    public byte[] GetFoto() {
        return (byte[])Session["webcam_foto"];
    }
}
