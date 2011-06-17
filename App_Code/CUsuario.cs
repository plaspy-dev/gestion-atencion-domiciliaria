using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;

public class CUsuario
{
    protected string m_szNombre;
    protected int m_nGrupo;
    protected string m_szID;
    protected CGrupo m_pGrupo;

	public CUsuario(string id, string nombre, int grupo)
	{
        m_szNombre = nombre;
        m_nGrupo = grupo;
        m_szID = id;
        m_pGrupo = new CGrupo();
        HttpContext.Current.Session["Usuario"] = this;
	}

    public void CreateMenu(TreeView tree, string parametros)
    {
        m_pGrupo.CreateMenu(tree, parametros);
    }

    public void SetPermiso(string url, int permiso) {

        m_pGrupo.SetPermiso(url, permiso);
    }

    public ArrayList GetFullMenu() {

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
            return true;
        return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath)&1)==1;
    }
    public bool CanInsert()
    {
        if (m_nGrupo == 0)
            return true;
        return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 4) == 4;
    }
    public bool CanPrint()
    {
        if (m_nGrupo == 0)
            return true;
        return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 2) == 2;
    }
    public bool CanUpdate()
    {
        if (m_nGrupo == 0)
            return true;
        return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 8) == 8;
    }
    public bool CanDelete()
    {
        if (m_nGrupo == 0)
            return true;
        return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 16) == 16;
    }
    public bool CanAdmin()
    {
        if (m_nGrupo == 0)
            return true;
        return (m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath) & 32) == 32;
    }

    public bool CanAccess()
    {
        if (m_nGrupo == 0)
            return true;
        if(HttpContext.Current.Request.Url.AbsolutePath==HttpContext.Current.Request.ApplicationPath + "/inicio.aspx")
            return true;
        int permisos= m_pGrupo.GetPermisos(HttpContext.Current.Request.Url.AbsolutePath);
        return permisos>0;
    }

    public void Redirect()
    {
        HttpContext.Current.Response.Redirect("~/inicio.aspx");
        HttpContext.Current.Response.End();
    }

    static public CUsuario GetUsuario()
    {
        HttpContext.Current.Response.AddHeader("pragma", "no-cache");
        HttpContext.Current.Response.CacheControl = "Private";
        HttpContext.Current.Response.Expires = 0;
        CUsuario usuario = (CUsuario)HttpContext.Current.Session["Usuario"];
        if(usuario==null) {
            
            string url = HttpUtility.UrlEncode(HttpContext.Current.Request.Url.AbsoluteUri);
            HttpContext.Current.Response.Redirect("~/?from=" + url);
            HttpContext.Current.Response.End();
        }
        if (!usuario.CanAccess())
            usuario.Redirect();
        return usuario;
    }
}
