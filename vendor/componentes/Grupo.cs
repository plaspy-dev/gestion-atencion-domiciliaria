using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Xml;
using System.Collections;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Configuration;
using System.Web.Routing;

namespace SDG.Componentes
{
    [Serializable]
    public class Grupo
    {
        protected List<CURLs> m_aURLs;
        protected List<CURLs> OrdenedURL;

	    public Grupo()
	    {
            m_aURLs = new List<CURLs>();
            XmlDocument xDoc = new XmlDocument();

            try
            {
                xDoc.Load(HttpContext.Current.Server.MapPath("~/directorio.xml"));
                XmlNodeList paginas = xDoc.GetElementsByTagName("paginas");
                XmlNodeList lista = ((XmlElement)paginas[0]).GetElementsByTagName("seccion");
                foreach (XmlElement nodo in lista)
                {
                    XmlNodeList titulo = nodo.GetElementsByTagName("titulo");
                    string parent = titulo[0].InnerText;

                    bool visible = true;
                    try
                    {
                        foreach(XmlNode tnodo in nodo.GetElementsByTagName("visible")) {
                            if(tnodo.ParentNode==nodo) {
                                visible=false;
                                break;
                            }
                        }
                    } catch { }

                    XmlNodeList urls = nodo.GetElementsByTagName("pagina");
                    foreach (XmlElement nodo1 in urls)
                    {
                        CURLs curl = new CURLs(parent, visible);

                        foreach (XmlNode nodopage in nodo1.ChildNodes) {
                            if (nodopage.Name == "titulo")
                                curl.Titulo = nodopage.InnerText.Trim();
                            else if (nodopage.Name == "url")
                                curl.URL = nodopage.InnerText.Trim();
                            else if (nodopage.Name == "visible")
                                curl.Visible = nodopage.InnerText.Trim() == "false" && visible;
                            else curl[nodopage.Name] = nodopage.InnerText.Trim();
                        }
                        m_aURLs.Add(curl);
                    }
                }
                OrdenedURL = m_aURLs.OrderByDescending(x=>x.URL).ToList();
            }
            catch /*(System.IO.FileNotFoundException ex)*/ { }
	    }

        public int GetPermisos(string url)
        {
            CURLs info = OrdenedURL.Find(x => url.ToLower().StartsWith(x.FullURL.ToLower()));
            if (info != null)
                return info.Permisos;
            return 0;
        }

        public void AddPermisos(string padre, string nombre, string url, int permiso)
        {
            m_aURLs.Add(new CURLs(url, nombre, padre, url.Length==0 ? 1 : permiso));
            OrdenedURL = m_aURLs.OrderByDescending(x => x.URL).ToList();
        }

        public int GetPermisoRaiz(string url)
        {
            CURLs info = OrdenedURL.Find(x => url.ToLower().StartsWith(x.URL.ToLower()));
            if (info != null)
                return info.Permisos;
            return 0;
        }

        public void SetPermiso(string url, int permisos) {

            CURLs info = m_aURLs.Find(x => x.URL.ToLower() == url.ToLower());
            if (info != null)
                info.Permisos = permisos;
        }

        protected TreeNode Add(string titulo, string url) {

            TreeNode hijo = new TreeNode(titulo);
            if (url.Length > 2)
            {
                hijo.NavigateUrl = url;
            } else
            {
                hijo.Collapse();
                hijo.SelectAction = TreeNodeSelectAction.Expand;
            }
            return hijo;
        }

        public List<CURLs> GetFullMenu() {

            return m_aURLs;
        }

        protected TreeNode FindParent(TreeNodeCollection treenodo, string buscado) {
            foreach (TreeNode nodo in treenodo) {
                if (nodo.Text == buscado)
                    return nodo;
            }
            return null;
        }

        public bool CreateMenu(TreeView tree, string parametros, Usuario usuario)
        {
            HttpContextWrapper wrapper = new HttpContextWrapper(HttpContext.Current);
            System.Web.Routing.RequestContext requestContext= new System.Web.Routing.RequestContext(wrapper, new RouteData());

            bool add = false;
            // menu antiguo
            TreeNode parent = null;
            for (int i = 0; i < m_aURLs.Count; i++)
            {
                CURLs url = (CURLs)m_aURLs[i];
                if (url.Parent == "__no__" || !url.Visible) // es invisible
                    continue;
                add = true;

                if (usuario.GetGrupo() == 0 || GetPermisoRaiz(url.URL) > 0)
                {
                    TreeNodeCollection treenodo = tree.Nodes;
                    if (parent == null || parent.Text != url.Parent)
                    {
                        parent = null;
                        if (url.Parent.Length > 0)
                        {
                            parent = FindParent(treenodo, url.Parent);
                            if (parent == null)
                            {
                                parent = new TreeNode(url.Parent);
                                parent.SelectAction = TreeNodeSelectAction.Expand;
                                treenodo.Add(parent);
                            }
                            parent.Collapse();
                        }
                    }

                    string finalurl = url.URL;
                    bool seleccionado= ((Page)HttpContext.Current.Handler).AppRelativeVirtualPath==finalurl;
                    try { finalurl= RouteTable.Routes.GetVirtualPath(requestContext, finalurl, null).VirtualPath; } catch { } // tratamos de encontrar la ruta virtual 
                    if (finalurl.Length > 0 && finalurl != "~")
                        finalurl += parametros;
                    TreeNode hijo = Add(url.Titulo, finalurl);
                    TreeNodeCollection hijos = parent==null ? treenodo  : parent.ChildNodes ;
                    hijos.Add(hijo);
                    if (seleccionado)
                    {
                        parent.Expand();
                        hijo.Select();
                        for (int k = 0; k < parent.ChildNodes.Count; k++) {
                            if (parent.ChildNodes[k].Text == url.Titulo) {
                                parent.ChildNodes[k].Select();
                            }
                        }
                    }
                }
            }
            return add;
        }
    }
}
