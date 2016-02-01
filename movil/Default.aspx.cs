using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            string end = Request.QueryString["end"];
            if (end == "1")
            {
                Session.RemoveAll();
                CConector.SetCookie("contrasena", "");
                Response.Redirect("~/");
            }

            CUsuario usuario = (CUsuario)Usuario.Validate();
            if (usuario != null)
            {
                string url = Request.QueryString["from"];
                if (url == null || url.Length == 0)
                    usuario.Redirect();
                else Response.Redirect(url);
                Response.End();
                return;
            }

            TU.Text = CConector.GetCookie("loginOrganizationExample15");
            if (TU.Text.Length > 0)
                TC.Focus();
            else TU.Focus();
            // LVersion.Text = HomeCareVersion.Number;
        }
    }

    protected void BA_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        CUsuario usuario = (CUsuario)Usuario.Validate(TU.Text, TC.Text);
        if (usuario != null)
        {
            string url = Request.QueryString["from"];
            if (url == null || url.Length == 0)
                usuario.Redirect();
            else Response.Redirect(url);
            Response.End();
            return;
        }
        TC.Text = "";
        TU.Focus();
        LM.Text = "Usuario o contraseña equivocada.";
        System.Threading.Thread.Sleep(3000);
    }
}