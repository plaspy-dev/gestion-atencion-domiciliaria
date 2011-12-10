using System.Collections;
using System.Configuration;
using System.Web;
using System.Web.UI.WebControls;
using System.Xml;

namespace SDG.Componentes;

public class Grupo
{
	protected ArrayList m_aURLs;

	protected bool m_bInicio = false;

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
				CURLs value = new CURLs(elementsByTagName6[0].InnerText, elementsByTagName5[0].InnerText, innerText)
				{
					m_bNativo = true
				};
				m_aURLs.Add(value);
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
		m_aURLs.Add(new CURLs(url, nombre, padre, (url.Length == 0) ? 1 : permiso));
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

	public ArrayList GetFullMenu()
	{
		return m_aURLs;
	}

	protected TreeNode FindParent(TreeNodeCollection treenodo, string buscado, ref int old)
	{
		if (buscado == "")
		{
			return null;
		}
		old = -1;
		for (int i = 0; i < treenodo.Count; i++)
		{
			int old2 = -1;
			TreeNode treeNode = FindParent(treenodo[i].ChildNodes, buscado, ref old2);
			if (treeNode != null)
			{
				old = old2;
				return treeNode;
			}
			string text = treenodo[i].Text;
			text = text.Replace("<div onclick='noPreguntar();'>", "");
			text = text.Replace("</div>", "");
			if (text == buscado)
			{
				return treenodo[i];
			}
			if (text.CompareTo(buscado) > 0)
			{
				if (i != 0)
				{
					text = treenodo[i - 1].Text;
					text = text.Replace("<div onclick='noPreguntar();'>", "");
					text = text.Replace("</div>", "");
				}
				if (i == 0 || text.CompareTo(buscado) < 0)
				{
					old = i;
					break;
				}
			}
		}
		return null;
	}

	protected bool CreateMenu(TreeView tree, string parametros, bool nativo, Usuario usuario)
	{
		bool result = false;
		TreeNode treeNode = null;
		for (int i = 0; i < m_aURLs.Count; i++)
		{
			CURLs cURLs = (CURLs)m_aURLs[i];
			if (cURLs.m_bNativo != nativo)
			{
				continue;
			}
			result = true;
			if (usuario.GetGrupo() != 0 && GetPermisoRaiz(cURLs.URL) <= 0 && cURLs.m_bNativo)
			{
				continue;
			}
			TreeNodeCollection treeNodeCollection = tree.Nodes;
			if (m_bInicio)
			{
				if (tree.Nodes.Count > 0)
				{
					treeNodeCollection = tree.Nodes[0].ChildNodes;
				}
				else
				{
					m_bInicio = false;
				}
			}
			if (treeNode == null || treeNode.Text != cURLs.Parent)
			{
				treeNode = null;
				if (cURLs.Parent.Length > 0)
				{
					int old = -1;
					treeNode = FindParent(treeNodeCollection, cURLs.Parent, ref old);
					if (treeNode == null)
					{
						treeNode = new TreeNode(cURLs.Parent);
						treeNode.Collapse();
						treeNode.SelectAction = TreeNodeSelectAction.Expand;
						if (old == -1)
						{
							treeNodeCollection.Add(treeNode);
						}
						else
						{
							treeNodeCollection.AddAt(old, treeNode);
						}
					}
				}
			}
			string text = cURLs.URL;
			if (m_bInicio == cURLs.m_bNativo && ConfigurationSettings.AppSettings["app"] != null)
			{
				text = CURLs.SwitchApp(text, ConfigurationSettings.AppSettings["app"]);
			}
			TreeNode treeNode2 = Add(cURLs.Titulo, text + parametros);
			if (cURLs.FullURL == HttpContext.Current.Request.Url.AbsolutePath)
			{
				treeNode2.Selected = true;
				treeNode.Expand();
			}
			TreeNode treeNode3 = null;
			TreeNodeCollection treeNodeCollection2 = ((treeNode == null) ? treeNodeCollection : treeNode.ChildNodes);
			for (int j = 0; j < treeNodeCollection2.Count; j++)
			{
				if (treeNodeCollection2[j].Text == treeNode2.Text)
				{
					treeNode3 = treeNodeCollection2[j];
					break;
				}
			}
			if (treeNode3 != null)
			{
				treeNodeCollection2.Remove(treeNode3);
			}
			treeNodeCollection2.Add(treeNode2);
		}
		return result;
	}

	public void CreateMenu(TreeView tree, string parametros, Usuario usuario)
	{
		m_bInicio = false;
		if (!CreateMenu(tree, parametros, nativo: false, usuario))
		{
			m_bInicio = true;
		}
		CreateMenu(tree, parametros, nativo: true, usuario);
	}
}
