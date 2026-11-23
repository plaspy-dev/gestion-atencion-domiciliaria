using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Web;

namespace SDG.Componentes;

public class Usuario
{
	[Flags]
	public enum Permisos
	{
		Read = 1,
		Print = 2,
		Insert = 4,
		Update = 8,
		Delete = 0x10,
		Admin = 0x20,
		Todos = 0xFF
	}

	protected string m_szNombre;

	protected int m_nGrupo;

	protected string m_szID;

	protected string m_szLogin;

	protected Grupo m_pGrupo;

	protected string m_szUrl;

	protected ArrayList m_saCampos = new ArrayList();

	protected ArrayList m_saValores = new ArrayList();

	public string Nombre
	{
		get
		{
			return m_szNombre;
		}
		set
		{
			m_szNombre = value;
		}
	}

	public string Id => m_szID;

	public int Grupo
	{
		get
		{
			return m_nGrupo;
		}
		set
		{
			m_nGrupo = value;
		}
	}

	public string Login => m_szLogin;

	public string ForceURL => m_szUrl;

	public string this[string campo]
	{
		get
		{
			return m_saValores[GetCampo(campo)].ToString();
		}
		set
		{
			m_saValores[GetCampo((campo.Length == 0) ? value : campo)] = value;
		}
	}

	protected Usuario()
	{
		m_szNombre = "";
		m_nGrupo = 0;
		m_szID = "";
		m_szLogin = "";
		m_pGrupo = new Grupo();
		m_szUrl = "";
	}

	public Usuario(string id, string nombre, int grupo, string login)
	{
		m_szNombre = nombre;
		m_nGrupo = grupo;
		m_szID = id;
		m_szLogin = login;
		m_pGrupo = new Grupo();
		m_szUrl = "";
		HttpContext.Current.Session["__SDG.Usuario"] = this;
	}

	public string GetLogin()
	{
		return m_szLogin;
	}

	public void CreateMenu(TreeView tree)
	{
		m_pGrupo.CreateMenu(tree, "", this);
	}

	public string GetForceURL()
	{
		return m_szUrl;
	}

	public void SetForceURL(string url, Conector conector)
	{
		m_szUrl = url;
		conector.QueryMod("UPDATE usuario SET forceurl=" + Query.GetValor(url) + " WHERE id=" + GetID(), false);
	}

	public void SetForceURL(string url)
	{
		m_szUrl = url;
	}

	public void CreateMenu(TreeView tree, string parametros)
	{
		m_pGrupo.CreateMenu(tree, parametros, this);
	}

	public void SetPermiso(string url, int permiso)
	{
		m_pGrupo.SetPermiso(url, permiso);
	}

	public void AddPermiso(string padre, string nombre, string url, int permiso)
	{
		m_pGrupo.AddPermisos(padre, nombre, url, permiso);
	}

	public List<CURLs> GetFullMenu()
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

	public virtual int GetPermisosRaiz(string url)
	{
		if (m_nGrupo == 0)
		{
			return 255;
		}
		return m_pGrupo.GetPermisoRaiz(url);
	}

	public virtual int GetPermisos(string url)
	{
		if (m_nGrupo == 0)
		{
			return 255;
		}
		return m_pGrupo.GetPermisos(url);
	}

	public static string GetCurrentURL()
	{
		if (HttpContext.Current.Handler is Page)
		{
			return ((Page)HttpContext.Current.Handler).AppRelativeVirtualPath;
		}
		if (HttpContext.Current.Handler is IHttpHandlerEx)
		{
			return ((IHttpHandlerEx)HttpContext.Current.Handler).AppRelativeVirtualPath;
		}
		return HttpContext.Current.Request.AppRelativeCurrentExecutionFilePath;
	}

	public virtual int GetPermisos()
	{
		if (m_nGrupo == 0)
		{
			return 255;
		}
		return GetPermisosRaiz(GetCurrentURL());
	}

	public virtual bool CanRead()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return GetPermisos() > 0;
	}

	public virtual bool CanInsert()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (GetPermisos() & 4) == 4;
	}

	public virtual bool CanPrint()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (GetPermisos() & 2) == 2;
	}

	public virtual bool CanUpdate()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (GetPermisos() & 8) == 8;
	}

	public virtual bool CanDelete()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (GetPermisos() & 0x10) == 16;
	}

	public virtual bool CanAdmin()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		return (GetPermisos() & 0x20) == 32;
	}

	public virtual bool CanAccess()
	{
		if (m_nGrupo == 0)
		{
			return true;
		}
		if (GetCurrentURL().IndexOf(".asmx") != -1)
		{
			return true;
		}
		if (GetCurrentURL() == "~/inicio.aspx")
		{
			return true;
		}
		return GetPermisos() > 0;
	}

	public void Redirect()
	{
		HttpContext.Current.Response.Redirect("~/inicio.aspx");
		HttpContext.Current.Response.End();
	}

	protected virtual Usuario ValidateUser()
	{
		return null;
	}

	protected virtual Usuario ValidateUser(string usuario, string passwd)
	{
		return null;
	}

	protected virtual Usuario IsValidUsuario()
	{
		return this;
	}

	public static Usuario Validate(string usuario, string password)
	{
		if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["Usuario"]))
		{
			try
			{
				return ((Usuario)Activator.CreateInstance(Assembly.Load("App_Code").GetType(ConfigurationManager.AppSettings["Usuario"]))).ValidateUser(usuario, password);
			}
			catch
			{
			}
		}
		return null;
	}

	public static Usuario Validate()
	{
		if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["Usuario"]))
		{
			try
			{
				return ((Usuario)Activator.CreateInstance(Assembly.Load("App_Code").GetType(ConfigurationManager.AppSettings["Usuario"]))).ValidateUser();
			}
			catch
			{
			}
		}
		return null;
	}

	public static Usuario GetInstance(bool redirect = true)
	{
		try
		{
			HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
			HttpContext.Current.Response.Headers["pragma"] = "no-cache";
		}
		catch
		{
			if (HttpContext.Current.Response.Headers["pragma"] != "no-cache")
			{
				HttpContext.Current.Response.AddHeader("pragma", "no-cache");
			}
		}
		HttpContext.Current.Response.CacheControl = "Private";
		HttpContext.Current.Response.Expires = 0;
		Usuario usuario = null;
		try
		{
			usuario = (Usuario)HttpContext.Current.Session["__SDG.Usuario"];
		}
		catch
		{
		}
		usuario = ((usuario != null) ? usuario.IsValidUsuario() : Validate());
		if (usuario == null)
		{
			if (redirect)
			{
				string text = HttpUtility.UrlEncode(HttpContext.Current.Request.Url.AbsolutePath + HttpContext.Current.Request.Url.Query);
				HttpContext.Current.Response.Redirect("~/Default.aspx?from=" + text);
				HttpContext.Current.Response.End();
			}
		}
		else if (redirect && !usuario.CanAccess())
		{
			usuario.Redirect();
		}
		return usuario;
	}

	public static void EndSession()
	{
		HttpContext.Current.Session["__SDG.Usuario"] = null;
	}

	public static Usuario GetUsuario()
	{
		return GetInstance();
	}

	protected int GetCampo(string campo)
	{
		int num = -1;
		for (int i = 0; i < m_saCampos.Count; i++)
		{
			if (m_saCampos[i].ToString() == campo)
			{
				num = i;
				break;
			}
		}
		if (num == -1)
		{
			num = m_saCampos.Add(campo);
			m_saValores.Add("");
		}
		return num;
	}
}
