using System.Collections;
using System.Configuration;
using System.Web;
using System.Web.UI.WebControls;
using System.Xml;

namespace componentes;

public class Grupo
{
	protected ArrayList m_aURLs;

	public Grupo()
	{
		m_aURLs = new ArrayList();
		XmlDocument xmlDocument = new XmlDocument();
		xmlDocument.Load(HttpContext.Current.Server.MapPath("~/directorio.xml"));
		XmlNodeList elementsByTagName = xmlDocument.GetElementsByTagName("paginas");
		XmlNodeList elementsByTagName2 = ((XmlElement)elementsByTagName[0]).GetElementsByTagName("seccion");
		foreach (XmlElement item in elementsByTagName2)
		{
			XmlNodeList elementsByTagName3 = item.GetElementsByTagName("titulo");
			string innerText = elementsByTagName3[0].InnerText;
			XmlNodeList elementsByTagName4 = item.GetElementsByTagName("pagina");
			foreach (XmlElement item2 in elementsByTagName4)
			{
				XmlNodeList elementsByTagName5 = item2.GetElementsByTagName("titulo");
				XmlNodeList elementsByTagName6 = item2.GetElementsByTagName("url");
				m_aURLs.Add(new CURLs(elementsByTagName6[0].InnerText, elementsByTagName5[0].InnerText, innerText));
			}
		}
	}

	public int GetPermisos(string url)
	{
		for (int i = 0; i < m_aURLs.Count; i++)
		{
			CURLs cURLs = (CURLs)m_aURLs[i];
			if (cURLs.FullURL.ToLower() == url.ToLower())
			{
				return cURLs.Permisos;
			}
		}
		return 0;
	}

	public void AddPermisos(string padre, string nombre, string url, int permiso)
	{
		m_aURLs.Add(new CURLs(url, nombre, padre, permiso));
	}

	public int GetPermisoRaiz(string url)
	{
		for (int i = 0; i < m_aURLs.Count; i++)
		{
			CURLs cURLs = (CURLs)m_aURLs[i];
			if (cURLs.URL == url)
			{
				return cURLs.Permisos;
			}
		}
		return 0;
	}

	public void SetPermiso(string url, int permisos)
	{
		for (int i = 0; i < m_aURLs.Count; i++)
		{
			CURLs cURLs = (CURLs)m_aURLs[i];
			if (cURLs.URL == url)
			{
				cURLs.Permisos = permisos;
			}
		}
	}

	protected TreeNode Add(string titulo, string url)
	{
		TreeNode treeNode = new TreeNode(titulo);
		treeNode.NavigateUrl = url;
		return treeNode;
	}

	public ArrayList GetFullMenu()
	{
		return m_aURLs;
	}

	public void CreateMenu(TreeView tree, string parametros)
	{
		Usuario usuario = Usuario.GetUsuario();
		TreeNode treeNode = null;
		for (int i = 0; i < m_aURLs.Count; i++)
		{
			CURLs cURLs = (CURLs)m_aURLs[i];
			if (usuario.GetGrupo() == 0 || GetPermisoRaiz(cURLs.URL) > 0)
			{
				if (treeNode == null || treeNode.Text != cURLs.Parent)
				{
					treeNode = new TreeNode(cURLs.Parent);
					treeNode.Collapse();
					treeNode.SelectAction = TreeNodeSelectAction.Expand;
					tree.Nodes.Add(treeNode);
				}
				string text = cURLs.URL;
				if (ConfigurationSettings.AppSettings["prefijonuevo"] != null)
				{
					text = text.Replace("~/", ConfigurationSettings.AppSettings["prefijonuevo"]);
				}
				TreeNode treeNode2 = Add(cURLs.Titulo, text + parametros);
				if (cURLs.FullURL == HttpContext.Current.Request.Url.AbsolutePath)
				{
					treeNode2.Selected = true;
					treeNode.Expand();
				}
				treeNode.ChildNodes.Add(treeNode2);
			}
		}
	}
}
