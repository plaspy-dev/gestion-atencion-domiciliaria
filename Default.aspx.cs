using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Security;
using System.Data.SqlClient;
using componentes;
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
                Response.Redirect("~/");
                Response.End();
            }
            m_EUsuario.Text = CConector.GetCookie("loginOrganizationExample15");
            m_EContrasena.Text = CConector.GetCookie("contrasena");
            if (m_EContrasena.Text.Length > 0)
            {
                IngresarOld();
                return;
            }
            m_EUsuario.Text = CConector.GetCookie("usuario");
            if (m_EUsuario.Text.Length > 0)
                m_EContrasena.Focus();
            else m_EUsuario.Focus();

            if (Request.Form["usuario"] != null && Request.Form["contrasena"] != null)
            {
                m_EUsuario.Text = Request.Form["usuario"].ToString();
                m_EContrasena.Text = Request.Form["contrasena"].ToString();
                m_BIngresar_Click(sender, e);
                return;
            }
        }
    }

    protected void IngresarOld()
    {
        CConectorMS conectorMS = CConectorMS.GetConector();
        CConector conector = CConector.GetConector();

        string usuario = m_EUsuario.Text;
        string contrasena = m_EContrasena.Text;

        if (contrasena.Length > 0 && usuario.Length > 0)
        {
            int grupo = 0;
            string id = "";
            string nombre = conectorMS.QueryString("SELECT usIdUsuario FROM seg_Usuarios WHERE usIdUsuario='" + usuario + "' AND usClave='" + contrasena + "' AND usActivo=1");
            if (nombre.Length > 0)
            {
                MySqlDataReader reader = conector.Query("SELECT id,nombre,grupo,usuario FROM usuario WHERE usuario='" + usuario + "' AND (estado IS NULL OR estado!=-1)");
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        usuario = reader["nombre"].ToString();
                        id = reader["id"].ToString();
                        grupo = Convert.ToInt32(reader["grupo"].ToString());
                        break;
                    }
                }
                if (id != "")
                {
                    CConector.SetCookie("usuario", m_EUsuario.Text);

                    Usuario pUsuario = new Usuario(id, usuario, grupo);
                    if (grupo > 0)
                    {
                        reader = conector.Query("SELECT url,permiso FROM permisos WHERE grupo='" + grupo + "'");
                        if (reader != null)
                        {
                            while (reader.Read())
                            {
                                pUsuario.SetPermiso(reader["url"].ToString(), Convert.ToInt32(reader["permiso"]));
                            }
                        }
                    }

                    SqlDataReader readerms= conectorMS.Query("SELECT	seg_Menu.meDescMenu AS nombre, seg_Menu.meRuta AS ruta,ins,modif,elim,parent.meDescMenu AS parent "+
                            "FROM dbo.seg_Menu INNER JOIN dbo.fnSeg_ConMenu('" + m_EUsuario.Text + "',0)menuUs ON seg_Menu.meIdMenu = menuUs.IdMenu " +  
                            "LEFT JOIN seg_Menu AS parent ON (parent.meIdMenu=seg_Menu.meIdMenuPadre) " +
		                    "WHERE seg_Menu.meRuta!='' " + 
		                    " order by seg_Menu.meIdMenuPadre,seg_Menu.meDescMenu,seg_Menu.meidMenu");

                    if (readerms != null)
                    {
                        while (readerms.Read())
                        {
                            int permisos = 0;
                            if(readerms["ins"].ToString()=="1")
                                permisos+=4;
                            if (readerms["modif"].ToString() == "1")
                                permisos += 8;
                            if (readerms["elim"].ToString() == "1")
                                permisos += 16;
                            if (permisos > 0)
                                permisos += 1;

                            pUsuario.AddPermiso(readerms["parent"].ToString(), readerms["nombre"].ToString(), ConfigurationSettings.AppSettings["prefijoold"] + readerms["ruta"].ToString(), permisos);
                        }
                    }

                    conector.Query("UPDATE usuario SET ingreso=SYSDATE() WHERE id='" + id + "'");
                    string url = Request.QueryString["from"];
                    if (url == null || url.Length == 0)
                        pUsuario.Redirect();
                    else Response.Redirect(url);
                    Response.End();
                    return;
                }
            }
        }
        m_EContrasena.Text = "";
        m_EUsuario.Focus();
        m_SMensaje.Text = "Usuario o contraseña equivocada.";
        System.Threading.Thread.Sleep(3000);
    }

    protected void m_BIngresar_Click(object sender, EventArgs e)
    {
        CConectorMS conectorMS = CConectorMS.GetConector();
        CConector conector = CConector.GetConector();
        string usuario = m_EUsuario.Text;
        string contrasena = m_EContrasena.Text;

        if (contrasena.Length > 0 && usuario.Length > 0)
        {
            int grupo = 0;
            string id = "";
            MySqlDataReader reader = conector.Query("SELECT id,nombre,grupo,usuario FROM usuario WHERE usuario='" + usuario + "' AND (estado IS NULL OR estado!=-1) AND contrasena=PASSWORD('" + contrasena + "')");
            if (reader != null)
            {
                while (reader.Read())
                {
                    usuario = reader["nombre"].ToString();
                    id = reader["id"].ToString();
                    grupo = Convert.ToInt32(reader["grupo"].ToString());
                    break;
                }
            }
            if (id != "")
            {
                CConector.SetCookie("usuario", m_EUsuario.Text);
                
                Usuario pUsuario = new Usuario(id, usuario, grupo);
                if (grupo > 0)
                {
                    reader = conector.Query("SELECT url,permiso FROM permisos WHERE grupo='" + grupo + "'");
                    if (reader != null)
                    {
                        while (reader.Read())
                        {
                            pUsuario.SetPermiso(reader["url"].ToString(), Convert.ToInt32(reader["permiso"]));
                        }
                    }
                }

                SqlDataReader readerms = conectorMS.Query("SELECT	seg_Menu.meDescMenu AS nombre, seg_Menu.meRuta AS ruta,ins,modif,elim,parent.meDescMenu AS parent " +
                            "FROM dbo.seg_Menu INNER JOIN dbo.fnSeg_ConMenu('" + m_EUsuario.Text + "',0)menuUs ON seg_Menu.meIdMenu = menuUs.IdMenu " +
                            "LEFT JOIN seg_Menu AS parent ON (parent.meIdMenu=seg_Menu.meIdMenuPadre) " +
                            "WHERE seg_Menu.meRuta!='' " +
                            " order by seg_Menu.meIdMenuPadre,seg_Menu.meDescMenu,seg_Menu.meidMenu");

                if (readerms != null)
                {
                    while (readerms.Read())
                    {
                        int permisos = 0;
                        if (readerms["ins"].ToString() == "1")
                            permisos += 4;
                        if (readerms["modif"].ToString() == "1")
                            permisos += 8;
                        if (readerms["elim"].ToString() == "1")
                            permisos += 16;
                        if (permisos > 0)
                            permisos += 1;

                        pUsuario.AddPermiso(readerms["parent"].ToString(), readerms["nombre"].ToString(), ConfigurationSettings.AppSettings["prefijoold"] + readerms["ruta"].ToString(), permisos);
                    }
                }

                conector.Query("UPDATE usuario SET ingreso=SYSDATE() WHERE id='" + id + "'");
                string url = Request.QueryString["from"];
                if (url == null || url.Length == 0)
                    pUsuario.Redirect();
                else Response.Redirect(url);
                Response.End();
                return;
            }
        }
        m_EContrasena.Text = "";
        m_EUsuario.Focus();
        m_SMensaje.Text = "Usuario o contraseña equivocada.";
        System.Threading.Thread.Sleep(3000);
    }
}
