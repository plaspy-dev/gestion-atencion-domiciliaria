using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de CURLs
/// </summary>
public class CURLs
{
    protected string m_szURL;
    protected string m_szTitulo;
    protected string m_szParent;
    protected int m_nPermisos;

	public CURLs(string url, string titulo, string parent)
	{
        m_szURL = url;
        m_szTitulo = titulo;
        m_szParent = parent;
        m_nPermisos = 0;
	}

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

    public string URL
    {
        get
        {
            return m_szURL;
        }
    }
    public string Titulo
    {
        get
        {
            return m_szTitulo;
        }
    }
    public string Parent
    {
        get
        {
            return m_szParent;
        }
    }
    public string FullURL
    {
        get
        {
            return HttpContext.Current.Request.ApplicationPath + "/" + URL.Substring(2);
        }
    }
}
