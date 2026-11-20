using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Routing;

namespace SDG.Componentes
{
    [Serializable]
    public class CURLs
    {
        public int Permisos { get; set; }
        public string URL { get; set; }
        public bool Visible { get; set; }
        public string Titulo { get; set; }
        public string Parent { get; protected set; }
        protected Dictionary<string, string> Attributes = new Dictionary<string, string>();
        public string FullURL
        {
            get
            {
                try { return VirtualPathUtility.ToAbsolute(URL); } catch { }
                return "";
            }
        }
        public string RoutedURL {
            get {
                HttpContextWrapper wrapper = new HttpContextWrapper(HttpContext.Current);
                System.Web.Routing.RequestContext requestContext = new System.Web.Routing.RequestContext(wrapper, new RouteData());
                try { return RouteTable.Routes.GetVirtualPath(requestContext, URL, null).VirtualPath; } catch { } // tratamos de encontrar la ruta virtual 
                return URL;
            }
        }

        public CURLs() { }
        public CURLs(string parent, bool visible) {
            Visible = visible;
            Parent = parent;
            Permisos = 0;
        }

	    public CURLs(string url, string titulo, string parent)
	    {
            Visible = true;
            URL = url;
            Titulo = titulo;
            Parent = parent;
            Permisos = 0;
	    }

        public CURLs(string url, string titulo, string parent, bool visible)
        {
            Visible = visible;
            URL = url;
            Titulo = titulo;
            Parent = parent;
            Permisos = 0;
        }

        public CURLs(string url, string titulo, string parent, int permisos)
        {
            Visible = true;
            URL = url;
            Titulo = titulo;
            Parent = parent;
            Permisos = permisos;
        }

        public CURLs(string url, string titulo, string parent, int permisos, bool visible)
        {
            Visible = visible;
            URL = url;
            Titulo = titulo;
            Parent = parent;
            Permisos = permisos;
        }

        public string this[string key]
        {
            get
            {
                try
                {
                    return Attributes[key];
                } catch { }
                return null;
            }
            set
            {
                Attributes[key] = value;
            }
        }
    }
}
