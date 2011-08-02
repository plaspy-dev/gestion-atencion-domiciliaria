using System.Collections;
using System.Web;
using System.Web.UI.WebControls;

namespace componentes;

public class Usuario
{
	protected string m_szNombre;

	protected int m_nGrupo;

	protected string m_szID;

	protected Grupo m_pGrupo;

	public Usuario(string id, string nombre, int grupo)
	{
		m_szNombre = nombre;
		m_nGrupo = grupo;
		m_szID = id;
		m_pGrupo = new Grupo();
		HttpContext.Current.Session["Usuario"] = this;
	}

	public void CreateMenu(TreeView tree, string parametros)
	{
		m_pGrupo.CreateMenu(tree, parametros);
	}

	public void SetPermiso(string url, int permiso)
	{
		m_pGrupo.SetPermiso(url, permiso);
	}

	public void AddPermiso(string padre, string nombre, string url, int permiso)
	{
		m_pGrupo.AddPermisos(padre, nombre, url, permiso);
	}

	public ArrayList GetFullMenu()
	{
		return m_pGrupo.GetFullMenu();
	}

	public string GetNombre()
	{
		return m_szNombre;
	}

	public int GetGrupo()
	{
		return m_nGrupo;
	}

	public string GetID()
	{
		return m_szID;
	}

	public bool CanRead()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 1) == 1;
	}

	public bool CanInsert()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 4) == 4;
	}

	public bool CanPrint()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 2) == 2;
	}

	public bool CanUpdate()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 8) == 8;
	}

	public bool CanDelete()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 0x10) == 16;
	}

	public bool CanAdmin()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 0x20) == 32;
	}

	public bool CanAccess()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		if (HttpContext.Current.Request.Url.AbsolutePath == HttpContext.Current.Request.ApplicationPath + "/inicio.aspx")
		{
			return true;
		}
		int permisos = m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath);
		return permisos > 0;
	}

	public void Redirect()
	{
		HttpContext.Current.Response.Redirect("~/inicio.aspx");
		HttpContext.Current.Response.End();
	}

	public static Usuario GetUsuario()
	{
		HttpContext.Current.Response.AddHeader("pragma", "no-cache");
		HttpContext.Current.Response.CacheControl = "Private";
		HttpContext.Current.Response.Expires = 0;
		Usuario usuario = (Usuario)HttpContext.Current.Session["Usuario"];
		if (usuario == null)
		{
			string text = HttpUtility.UrlEncode(HttpContext.Current.Request.Url.AbsoluteUri);
			HttpContext.Current.Response.Redirect("~/?from=" + text);
			HttpContext.Current.Response.End();
		}
		if (!usuario.CanAccess())
		{
			usuario.Redirect();
		}
		return usuario;
	}
}
