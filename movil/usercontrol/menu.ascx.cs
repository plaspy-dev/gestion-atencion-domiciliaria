using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Routing;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class usercontrol_menu : System.Web.UI.UserControl
{
    public class Menu
    {
        public string Icon { get; set; }
        public string Text { get; set; }
        public string URL { get; set; }
        public bool Separador { get; set; }
        public string Extra { get; set; }

        public Menu(string text, string url, string icon, string extra = null)
        {
            Icon = icon;
            Text = text;
            URL = url;
            Extra = extra;
        }
        public Menu()
        {
            Separador = true;
            URL = "";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            /*menu.Add(new Menu("Inicio", "~/inicio.aspx", "home"));
            menu.Add(new Menu());
            menu.Add(new Menu("Contraseña", "/contrasena.aspx", "user"));
            menu.Add(new Menu());
            menu.Add(new Menu("Cerrar sesión", "~/Default.aspx?end=1", "forbidden"));*/

            RM.DataSource = GetMenu();
             
            // RM.DataSource = menu;
            RM.DataBind();
        }
    }

    public List<CURLs> GetMenu()
    {
        CUsuario usuario = (CUsuario)CUsuario.GetInstance();
        if (usuario.menu != null)
            return usuario.menu;
        List<CURLs> lista= usuario.GetFullMenu().Where(x => x.Visible && usuario.GetPermisosRaiz(x.URL) > 0 && x.Parent != "__no__").ToList();

        List <CURLs> newlista = new List<CURLs>();
        newlista.AddRange(lista.Where(x => x.Visible));
        lista = newlista;
        string currentParent = "";
        for (int i = 0; i < lista.Count; i++)
        {
            if (!File.Exists(Server.MapPath(lista[i].URL))) {
                lista.RemoveAt(i);
                i--;
                continue;
            }

            if (currentParent != lista[i].Parent)
            {
                currentParent = lista[i].Parent;
                lista.Insert(i, new CURLs(null, currentParent, null));
                i++;
            }
        }
        lista.Add(new CURLs(null, "", null));
        lista.Add(new CURLs("~/contrasena.aspx", "Contraseña", null));
        lista.Add(new CURLs("~/Default.aspx?end=1", "Salir", null));
        usuario.menu = lista;
        return lista;
    }

    public string GetURL(object url)
    {
        string finalurl = (string)url;
        if (string.IsNullOrEmpty(finalurl))
            return finalurl;
        HttpContextWrapper wrapper = new HttpContextWrapper(HttpContext.Current);
        System.Web.Routing.RequestContext requestContext = new System.Web.Routing.RequestContext(wrapper, new RouteData());

        bool seleccionado = ((Page)HttpContext.Current.Handler).AppRelativeVirtualPath == finalurl;
        try { finalurl = RouteTable.Routes.GetVirtualPath(requestContext, finalurl, null).VirtualPath; } catch { } // tratamos de encontrar la ruta virtual 
        if (finalurl.Length > 0 && finalurl != "~" && !finalurl.Contains("?"))
            finalurl += Session["parametros"] == null ? "" : Session["parametros"].ToString();
        return finalurl;
    }
}