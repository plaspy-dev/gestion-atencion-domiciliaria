using System.Web;

namespace componentes;

public class CURLs
{
	protected string m_szURL;

	protected string m_szTitulo;

	protected string m_szParent;

	protected int m_nPermisos;

	public bool m_bNativo;

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

	public string FullURL => HttpContext.Current.Request.ApplicationPath + "/" + URL.Substring(2);

	public CURLs(string url, string titulo, string parent)
	{
		m_szURL = url;
		m_szTitulo = titulo;
		m_szParent = parent;
		m_nPermisos = 0;
		m_bNativo = false;
	}

	public CURLs(string url, string titulo, string parent, int permisos)
	{
		m_szURL = url;
		m_szTitulo = titulo;
		m_szParent = parent;
		m_nPermisos = permisos;
		m_bNativo = false;
	}

	public static string SwitchApp(string url, string nueva)
	{
		return url.Replace("~/", "/" + nueva + "/");
	}
}
