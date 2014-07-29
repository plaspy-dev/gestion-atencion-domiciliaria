using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;
using System.Xml;

namespace SDG.Componentes;

public class Grupo
{
	protected List<CURLs> m_aURLs;

	public Grupo()
	{
		m_aURLs = new List<CURLs>();
		XmlDocument xmlDocument = new XmlDocument();
		try
		{
			xmlDocument.Load(HttpContext.Current.Server.MapPath("~/directorio.xml"));
			XmlNodeList elementsByTagName = xmlDocument.GetElementsByTagName("paginas");
			XmlNodeList elementsByTagName2 = ((XmlElement)elementsByTagName[0]).GetElementsByTagName("seccion");
			foreach (XmlElement item2 in elementsByTagName2)
			{
				XmlNodeList elementsByTagName3 = item2.GetElementsByTagName("titulo");
				string innerText = elementsByTagName3[0].InnerText;
				bool flag = true;
				try
				{
					XmlNodeList elementsByTagName4 = item2.GetElementsByTagName("visible");
					if (elementsByTagName4[0].InnerText == "false")
					{
						flag = false;
					}
				}
				catch
				{
				}
				XmlNodeList elementsByTagName5 = item2.GetElementsByTagName("pagina");
				foreach (XmlElement item3 in elementsByTagName5)
				{
					XmlNodeList elementsByTagName6 = item3.GetElementsByTagName("titulo");
					XmlNodeList elementsByTagName7 = item3.GetElementsByTagName("url");
					bool flag2 = true;
					try
					{
						XmlNodeList elementsByTagName4 = item3.GetElementsByTagName("visible");
						if (elementsByTagName4[0].InnerText == "false")
						{
							flag2 = false;
						}
					}
					catch
					{
					}
					CURLs item = new CURLs(elementsByTagName7[0].InnerText, elementsByTagName6[0].InnerText, innerText, flag && flag2);
					m_aURLs.Add(item);
				}
			}
		}
		catch
		{
		}
	}

	public int GetPermisos(string url)
	{
		return m_aURLs.Find((CURLs x) => x.FullURL.ToLower() == url.ToLower())?.Permisos ?? 0;
	}

	public void AddPermisos(string padre, string nombre, string url, int permiso)
	{
		m_aURLs.Add(new CURLs(url, nombre, padre, (url.Length == 0) ? 1 : permiso));
	}

	public int GetPermisoRaiz(string url)
	{
		return m_aURLs.Find((CURLs x) => x.URL.ToLower() == url.ToLower())?.Permisos ?? 0;
	}

	public void SetPermiso(string url, int permisos)
	{
		CURLs cURLs = m_aURLs.Find((CURLs x) => x.URL.ToLower() == url.ToLower());
		if (cURLs != null)
		{
			cURLs.Permisos = permisos;
		}
	}

	protected TreeNode Add(string titulo, string url)
	{
		TreeNode treeNode = new TreeNode(titulo);
		if (url.Length > 2)
		{
			treeNode.NavigateUrl = url;
		}
		else
		{
			treeNode.Collapse();
			treeNode.SelectAction = TreeNodeSelectAction.Expand;
		}
		return treeNode;
	}

	public List<CURLs> GetFullMenu()
	{
		return m_aURLs;
	}

	protected TreeNode FindParent(TreeNodeCollection treenodo, string buscado)
	{
		foreach (TreeNode item in treenodo)
		{
			if (item.Text == buscado)
			{
				return item;
			}
		}
		return null;
	}

	public bool CreateMenu(TreeView tree, string parametros, Usuario usuario)
	{
		bool result = false;
		TreeNode treeNode = null;
		for (int i = 0; i < m_aURLs.Count; i++)
		{
			CURLs cURLs = m_aURLs[i];
			if (cURLs.Parent == "__no__" || !cURLs.Visible)
			{
				continue;
			}
			result = true;
			if (usuario.GetGrupo() != 0 && GetPermisoRaiz(cURLs.URL) <= 0)
			{
				continue;
			}
			TreeNodeCollection nodes = tree.Nodes;
			if (treeNode == null || treeNode.Text != cURLs.Parent)
			{
				treeNode = null;
				if (cURLs.Parent.Length > 0)
				{
					treeNode = FindParent(nodes, cURLs.Parent);
					if (treeNode == null)
					{
						treeNode = new TreeNode(cURLs.Parent);
						treeNode.SelectAction = TreeNodeSelectAction.Expand;
						nodes.Add(treeNode);
					}
					treeNode.Collapse();
				}
			}
			string text = cURLs.URL;
			if (text.Length > 0 && text != "~")
			{
				text += parametros;
			}
			TreeNode treeNode2 = Add(cURLs.Titulo, text);
			TreeNodeCollection treeNodeCollection = ((treeNode == null) ? nodes : treeNode.ChildNodes);
			treeNodeCollection.Add(treeNode2);
			if (!(cURLs.FullURL == HttpContext.Current.Request.Url.AbsolutePath))
			{
				continue;
			}
			treeNode.Expand();
			treeNode2.Select();
			for (int j = 0; j < treeNode.ChildNodes.Count; j++)
			{
				if (treeNode.ChildNodes[j].Text == cURLs.Titulo)
				{
					treeNode.ChildNodes[j].Select();
				}
			}
		}
		return result;
	}
}
