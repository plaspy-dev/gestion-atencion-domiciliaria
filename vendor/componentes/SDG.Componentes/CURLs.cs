using System.Web;

namespace SDG.Componentes;

public class CURLs
{
	protected string m_szURL;

	protected string m_szTitulo;

	protected string m_szParent;

	protected int m_nPermisos;

	public bool Visible { get; set; }

	public int Permisos
	{
		get
		{
			return m_nPermisos;
		}
		set
		{
			m_nPermisos = value;
		}
	}

	public string URL => m_szURL;

	public string Titulo => m_szTitulo;

	public string Parent => m_szParent;

	public string FullURL
	{
		get
		{
			try
			{
				return VirtualPathUtility.ToAbsolute(URL);
			}
			catch
			{
			}
			return "";
		}
	}

	public CURLs(string url, string titulo, string parent)
	{
		Visible = true;
		m_szURL = url;
		m_szTitulo = titulo;
		m_szParent = parent;
		m_nPermisos = 0;
	}

	public CURLs(string url, string titulo, string parent, bool visible)
	{
		Visible = visible;
		m_szURL = url;
		m_szTitulo = titulo;
		m_szParent = parent;
		m_nPermisos = 0;
	}

	public CURLs(string url, string titulo, string parent, int permisos)
	{
		Visible = true;
		m_szURL = url;
		m_szTitulo = titulo;
		m_szParent = parent;
		m_nPermisos = permisos;
	}

	public CURLs(string url, string titulo, string parent, int permisos, bool visible)
	{
		Visible = visible;
		m_szURL = url;
		m_szTitulo = titulo;
		m_szParent = parent;
		m_nPermisos = permisos;
	}
}
