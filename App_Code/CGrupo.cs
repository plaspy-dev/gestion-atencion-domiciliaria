using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Collections;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public class CGrupo
{
    protected ArrayList m_aURLs;

	public CGrupo()
	{
        m_aURLs = new ArrayList();
        XmlDocument xDoc = new XmlDocument();

        xDoc.Load(HttpContext.Current.Server.MapPath("~/directorio.xml"));
        XmlNodeList paginas = xDoc.GetElementsByTagName("paginas");
        XmlNodeList lista = ((XmlElement)paginas[0]).GetElementsByTagName("seccion");
        foreach (XmlElement nodo in lista)
        {
            XmlNodeList titulo= nodo.GetElementsByTagName("titulo");
            string parent= titulo[0].InnerText;

            XmlNodeList urls = nodo.GetElementsByTagName("pagina");
            foreach (XmlElement nodo1 in urls)
            {
                XmlNodeList nTitulo = nodo1.GetElementsByTagName("titulo");
                XmlNodeList url = nodo1.GetElementsByTagName("url");
                m_aURLs.Add(new CURLs(url[0].InnerText, nTitulo[0].InnerText, parent));
            }
        }
	}

    public int GetPermisos(string url)
    {
        for (int i = 0; i < m_aURLs.Count; i++)
        {
            CURLs info = (CURLs)m_aURLs[i];
            if (info.FullURL.ToLower() == url.ToLower())
                return info.Permisos;
        }
        return 0;
    }

    public int GetPermisoRaiz(string url)
    {
        for (int i = 0; i < m_aURLs.Count; i++)
        {
            CURLs info = (CURLs)m_aURLs[i];
            if (info.URL == url)
                return info.Permisos;
        }
        return 0;
    }

    public void SetPermiso(string url, int permisos) {

        for (int i = 0; i < m_aURLs.Count; i++)
        {
            CURLs info = (CURLs)m_aURLs[i];
            if (info.URL == url)
            {
                info.Permisos = permisos;
            }
        }
    }

    protected TreeNode Add(string titulo, string url) {

        TreeNode hijo = new TreeNode(titulo);
        hijo.NavigateUrl = url;
        return hijo;
    }

    public ArrayList GetFullMenu() {

        return m_aURLs;
    }

    public void CreateMenu(TreeView tree, string parametros)
    {
        CUsuario usuario = CUsuario.GetUsuario();

        TreeNode parent = null;
        for (int i = 0; i < m_aURLs.Count; i++)
        {
            CURLs url = (CURLs)m_aURLs[i];
            if(usuario.GetGrupo()==0 || GetPermisoRaiz(url.URL)>0) {
                
                if (parent == null || parent.Text != url.Parent)
                {
                    parent = new TreeNode(url.Parent);
                    tree.Nodes.Add(parent);
                }
                TreeNode hijo= Add(url.Titulo, url.URL + parametros);
                if (url.FullURL == HttpContext.Current.Request.Url.AbsolutePath)
                {
                    hijo.Selected = true;
                    parent.Expand();
                }
                parent.ChildNodes.Add(hijo);
            }
        }
    }
}
