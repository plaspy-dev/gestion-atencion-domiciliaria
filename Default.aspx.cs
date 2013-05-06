using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Security;
using System.Data.SqlClient;
using SDG.Componentes;
using System.Configuration;

public partial class _Default : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string end = Request.QueryString["end"];
            if (end == "1")
            {
                Session.RemoveAll();
                CConector.SetCookie("contrasena", "");
                FormsAuthentication.SignOut();
                Response.Redirect(CURLs.SwitchApp("~/Inicio.aspx", ConfigurationSettings.AppSettings["app"]));
                // Response.Redirect("~/");
                Response.End();
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

            /*m_EUsuario.Text = CConector.GetCookie("loginOrganizationExample15");
            m_EContrasena.Text = HttpUtility.UrlDecode(CConector.GetCookie("contrasena"));
            if (m_EContrasena.Text.Length > 0)
            {
                IngresarOld();
                return;
            }*/
            m_EUsuario.Text = CConector.GetCookie("loginOrganizationExample15");
            if (m_EUsuario.Text.Length > 0)
                m_EContrasena.Focus();
            else m_EUsuario.Focus();
            LVersion.Text = Version.GetVersion();
        }
    }

    protected void m_BIngresar_Click(object sender, EventArgs e)
    {
        CUsuario usuario = (CUsuario)Usuario.Validate(m_EUsuario.Text, Crypt.EncriptarDES(m_EContrasena.Text, System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_4")));
        if (usuario != null)
        {
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
