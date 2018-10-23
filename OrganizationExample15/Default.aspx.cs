using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
#if DEBUG
        Controls.Add(new LiteralControl("<style type='text/css'>.red{background-color: Red;}</style>"));
#endif
        if (!IsPostBack)
        {
            string end = Request.QueryString["end"];
            if (end == "1")
            {
                Session.RemoveAll();
                CConector.SetCookie("contrasena", "");
                FormsAuthentication.SignOut();
                Response.Redirect("~/");
            }

            CUsuario usuario = (CUsuario)Usuario.Validate();
            if (usuario != null)
            {
                FormsAuthentication.SetAuthCookie(usuario.Id, true);
                string url = Request.QueryString["from"];
                if (url == null || url.Length == 0)
                    usuario.Redirect();
                else Response.Redirect(url);
                Response.End();
                return;
            }

            m_EUsuario.Text = CConector.GetCookie("loginOrganizationExample15");
            if (m_EUsuario.Text.Length > 0)
                m_EContrasena.Focus();
            else m_EUsuario.Focus();
        }
    }

    protected void m_BIngresar_Click(object sender, EventArgs e)
    {
        CUsuario usuario = (CUsuario)Usuario.Validate(m_EUsuario.Text, m_EContrasena.Text);
        if (usuario != null)
        {
            FormsAuthentication.SetAuthCookie(usuario.Id, true);
            string url = Request.QueryString["from"];
            if (url == null || url.Length == 0)
                usuario.Redirect();
            else Response.Redirect(url);
            Response.End();
            return;
        }
        m_EContrasena.Text = "";
        m_EUsuario.Focus();
        m_SMensaje.Text = "Usuario o contraseña equivocada.";
        System.Threading.Thread.Sleep(3000);
    }
}