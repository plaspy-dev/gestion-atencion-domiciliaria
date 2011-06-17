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
        CUsuario usuario = CUsuario.GetUsuario();
        usuario.CreateMenu(TMenu, Session["parametros"]==null ? "" : Session["parametros"].ToString());
        Session.Remove("parametros");
        lblNombre.Text = usuario.GetNombre();

        titulo_aux.Attributes["title"] = "";
        LAuxDiag.Text = "";
        lblTitulo.Text = Request.QueryString["m"];
    }

    public TreeNode Add(string titulo, string url) {

        TreeNode hijo = new TreeNode(titulo);
        hijo.NavigateUrl = url;
        return hijo;
    }

    public void SetModificacion(string idModificaciones)
    {
        MModificaciones.IdModificacion = idModificaciones;
    }

    public void SetMensaje(String mensaje) {

        LMensaje.Text = mensaje;
    }

    public void SetResultado(String titulo) {

        Response.Redirect(Request.Url.AbsolutePath + "?m=" + titulo);
    }

    public void SetAuxDiag(String titulo, String texto) {

        titulo_aux.Attributes["title"] = titulo;
        LAuxDiag.Text = texto;
    }
}
