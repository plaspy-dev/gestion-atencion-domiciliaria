using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class renewSes : System.Web.UI.Page
{
    static byte[] gif = {   0x47,0x49,0x46,0x38,0x39,0x61,0x01,0x00,0x01,0x00,0x91,0x00,0x00,0x00,0x00,
                            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x21,0xf9,0x04,0x09,0x00,
                            0x00,0x00,0x00,0x2c,0x00,0x00,0x00,0x00,0x01,0x00,0x01,0x00,0x00,0x08,0x04,
                            0x00,0x01,0x04,0x04,0x00,0x3b,0x00};

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["passwdtemp"] != null)
        {
            Response.Cookies["contrasena"].Value = Session["passwdtemp"].ToString();
            Response.Cookies["contrasena"].Expires = DateTime.Now.AddMinutes(60);
        }

        Response.AddHeader("ContentType", "image/gif");
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        // actualizamos la contraseña
        Response.BinaryWrite(gif);
        Response.End();
    }
}
