using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using componentes;

public partial class MasterPageI : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Usuario usuario = Usuario.GetUsuario();
        usuario.CreateMenu(TMenu, Session["parametros"]==null ? "" : Session["parametros"].ToString());

        /*
            SELECT seg_Menu.meIdMenu,seg_Menu.meDescMenu,seg_Menu.meIdMenuPadre,seg_Menu.meEsTarea,seg_Menu.meRuta,ins,modif,elim,meFechaIngreso
		    FROM dbo.seg_Menu INNER JOIN fnSeg_ConMenu('Administrador',0)menuUs ON seg_Menu.meIdMenu = menuUs.IdMenu order by seg_Menu.meIdMenuPadre,seg_Menu.meDescMenu,seg_Menu.meidMenu
        */
        Session.Remove("parametros");
        lblNombre.Text = usuario.GetNombre();

        titulo_aux.Attributes["title"] = "";
        LAuxDiag.Text = "";
        lblTitulo.Text = Page.Title;
        if (Request.QueryString["m"]!=null)
            lblTitulo.Text += " " + Request.QueryString["m"];
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
