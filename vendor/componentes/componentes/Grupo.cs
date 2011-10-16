using System.Collections;
using System.Configuration;
using System.Web;
using System.Web.UI.WebControls;
using System.Xml;

namespace componentes;

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
			if (treeNode == null || treeNode.Text != cURLs.Parent)
			{
				treeNode = null;
				TreeNodeCollection treeNodeCollection = tree.Nodes;
				if (m_bInicio)
				{
					treeNodeCollection = tree.Nodes[0].ChildNodes;
				}
				int num = -1;
				for (int j = 0; j < treeNodeCollection.Count; j++)
				{
					string text = treeNodeCollection[j].Text;
					text = text.Replace("<div onclick='noPreguntar();'>", "");
					text = text.Replace("</div>", "");
					if (text == cURLs.Parent)
					{
						treeNode = treeNodeCollection[j];
						break;
					}
					if (text.CompareTo(cURLs.Parent) > 0)
					{
						if (j != 0)
						{
							text = treeNodeCollection[j - 1].Text;
							text = text.Replace("<div onclick='noPreguntar();'>", "");
							text = text.Replace("</div>", "");
						}
						if (j == 0 || text.CompareTo(cURLs.Parent) < 0)
						{
							num = j;
							break;
						}
					}
				}
				if (treeNode == null)
				{
					treeNode = new TreeNode(cURLs.Parent);
					treeNode.Collapse();
					treeNode.SelectAction = TreeNodeSelectAction.Expand;
					if (num == -1)
					{
						treeNodeCollection.Add(treeNode);
					}
					else
					{
						treeNodeCollection.AddAt(num, treeNode);
					}
				}
			}
			string text2 = cURLs.URL;
			if (m_bInicio == cURLs.m_bNativo && ConfigurationSettings.AppSettings["app"] != null)
			{
				text2 = CURLs.SwitchApp(text2, ConfigurationSettings.AppSettings["app"]);
			}
			TreeNode treeNode2 = Add(cURLs.Titulo, text2 + parametros);
			if (cURLs.FullURL == HttpContext.Current.Request.Url.AbsolutePath)
			{
				treeNode2.Selected = true;
				treeNode.Expand();
			}
			TreeNode treeNode3 = null;
			for (int j = 0; j < treeNode.ChildNodes.Count; j++)
			{
				if (treeNode.ChildNodes[j].Text == treeNode2.Text)
				{
					treeNode3 = treeNode.ChildNodes[j];
					break;
				}
			}
			if (treeNode3 != null)
			{
				treeNode.ChildNodes.Remove(treeNode3);
			}
			treeNode.ChildNodes.Add(treeNode2);
		}
		return result;
	}

	public void CreateMenu(TreeView tree, string parametros, Usuario usuario)
	{
		m_bInicio = false;
		if (!CreateMenu(tree, parametros, nativo: false, usuario))
		{
			m_bInicio = false;
		}
		CreateMenu(tree, parametros, nativo: true, usuario);
	}
}
