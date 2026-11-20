using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using System.Configuration;
using System.Reflection;
using System.ServiceModel;
using SDG.Web;
using System.Text.RegularExpressions;

namespace SDG.Componentes
{
    [Serializable]
    public class Usuario
    {
        [Flags]
        public enum Permisos
        {
            None=       0x00,
            Read =      0x01,
            Print =     0x02,
            Insert =    0x04,
            Update =    0x08,
            Delete =    0x10,
            Admin =     0x20,
            Todos =     0xff
        };

        public static string LoginPage = string.IsNullOrEmpty(ConfigurationManager.AppSettings["LoginPage"]) ? "~/Default.aspx" : ConfigurationManager.AppSettings["LoginPage"];
        public static string StartPage = string.IsNullOrEmpty(ConfigurationManager.AppSettings["StartPage"]) ? "~/inicio.aspx" : ConfigurationManager.AppSettings["StartPage"];
        public static Regex RegexURLReplace = new Regex("^(.+\\/)_+([^\\/_]+)$", RegexOptions.Compiled);

        protected Grupo m_pGrupo;
        protected ArrayList m_saCampos= new ArrayList();
        protected ArrayList m_saValores = new ArrayList();

        public string Nombre { get; protected set; }
        public string Id { get; protected set; }
        public int Grupo { get; protected set; }
        public string Login { get; protected set; }
        public string ForceURL { get; protected set; }

        protected Usuario() {
            m_pGrupo = new Grupo();
        }

	    public Usuario(string id, string nombre, int grupo, string login)
	    {
            Nombre = nombre;
            Grupo = grupo;
            Id = id;
            Login = login;
            m_pGrupo = new Grupo();
            if(HttpContext.Current.Session!=null)
                HttpContext.Current.Session["__SDG.Usuario"] = this;
	    }

        public string GetLogin() {
            return Login;
        }
        public void CreateMenu(TreeView tree)
        {
            m_pGrupo.CreateMenu(tree, "", this);
        }
        public String GetForceURL() {
            return ForceURL;
        }
        public virtual void SetForceURL(string url, Conector conector) {
            ForceURL = url;
            conector.QueryMod("UPDATE usuario SET forceurl=" + Query.GetValor(url) + " WHERE id=" + GetID());
        }
        public void SetForceURL(string url)
        {
            ForceURL = url;
        }
        public void CreateMenu(TreeView tree, string parametros)
        {
            m_pGrupo.CreateMenu(tree, parametros, this);
        }

        public void SetPermiso(string url, int permiso) {

            m_pGrupo.SetPermiso(url, permiso);
        }

        public void AddPermiso(string padre, string nombre, string url, int permiso)
        {
            m_pGrupo.AddPermisos(padre, nombre, url, permiso);
        }

        public List<CURLs> GetFullMenu() {

            return m_pGrupo.GetFullMenu();
        }

        public string GetNombre()
        {
            return Nombre;
        }
        public int GetGrupo()
        {
            return Grupo;
        }
        public string GetID()
        {
            return Id;
        }

        public virtual int GetPermisosRaiz(string url) {

            if (Grupo == 0)
                return (int)Permisos.Todos;
            return m_pGrupo.GetPermisoRaiz(url);
        }

        public virtual int GetPermisos(string url) {

            if (Grupo == 0)
                return (int)Permisos.Todos;
            return m_pGrupo.GetPermisos(url);
        }

        public static string GetCleanURL(string url)
        {
            return string.IsNullOrEmpty(url) ? url : RegexURLReplace.Replace(url, "$1$2");
        }

        public static string GetCurrentURL() {
            
            if (HttpContext.Current.Handler is Page)
                return GetCleanURL(((Page)HttpContext.Current.Handler).AppRelativeVirtualPath);
            if(HttpContext.Current.Handler is IHttpHandlerEx)
                return GetCleanURL(((IHttpHandlerEx)HttpContext.Current.Handler).AppRelativeVirtualPath);
            return GetCleanURL(HttpContext.Current.Request.AppRelativeCurrentExecutionFilePath);
            /*string url = HttpContext.Current.Request.Url.AbsolutePath.Substring(HttpContext.Current.Request.ApplicationPath.Length);
            if (!url.StartsWith("/"))
                url = "/" + url;
            return "~" + url;*/
        }

        public virtual bool Can(Permisos permiso) {

            return Can(GetCurrentURL(), permiso);
        }

        public virtual bool Can(string rootPath, Permisos permiso)
        {
            return Grupo == 0 || (GetPermisosRaiz(rootPath) & (int)permiso) == (int)permiso;
        }

        public virtual int GetPermisos() {

            if (Grupo == 0)
                return (int)Permisos.Todos;
            return GetPermisosRaiz(GetCurrentURL());
        }

        public virtual bool CanRead()
        {
            if (Grupo == 0)
                return true;
            return GetPermisos()>0;
        }
        public virtual bool CanInsert()
        {
            if (Grupo == 0)
                return true;
            return (GetPermisos() & (int)Permisos.Insert) == (int)Permisos.Insert;
        }
        public virtual bool CanPrint()
        {
            if (Grupo == 0)
                return true;
            return (GetPermisos() & (int)Permisos.Print) == (int)Permisos.Print;
        }
        public virtual bool CanUpdate()
        {
            if (Grupo == 0)
                return true;
            return (GetPermisos() & (int)Permisos.Update) == (int)Permisos.Update;
        }
        public virtual bool CanDelete()
        {
            if (Grupo == 0)
                return true;
            return (GetPermisos() & (int)Permisos.Delete) == (int)Permisos.Delete;
        }
        public virtual bool CanAdmin()
        {
            if (Grupo == 0)
                return true;
            return (GetPermisos() & (int)Permisos.Admin) == (int)Permisos.Admin;
        }

        public virtual bool CanAccess(string url)
        {
            if (Grupo == 0)
                return true;
            url = GetCleanURL(url);
            if (url.IndexOf(".asmx") != -1)
                return true;
            if (url == StartPage || url == "~/inicio.aspx")
                return true;
            return GetPermisosRaiz(url) > 0;
        }

        public virtual bool CanAccess()
        {
            return CanAccess(GetCurrentURL());
            /*if (Grupo == 0)
                return true;
            if (GetCurrentURL().IndexOf(".asmx") != -1)
                return true;
            if (GetCurrentURL() == StartPage || GetCurrentURL() == "~/inicio.aspx")
                return true;
            return GetPermisos()>0;*/
        }

        public void Redirect()
        {
            HttpContext.Current.Response.Redirect(StartPage);
            HttpContext.Current.Response.End();
        }

        virtual protected Usuario ValidateUser() {
            return null;
        }

        virtual protected Usuario ValidateUser(string usuario, string passwd)
        {
            return null;
        }

        virtual protected Usuario IsValidUsuario() {
            return this;
        }

        public static string UserClass = null;
        public static string UserNameSpace = null;

        static protected bool LoadUserClass() {
            if (UserClass != null)
                return true;
            UserNameSpace = "App_Code";
            UserClass = ConfigurationManager.AppSettings["Usuario"];
            if (UserClass != null && UserClass.Contains(","))
            {
                string[] types = UserClass.Split(',');
                UserClass = types[1];
                UserNameSpace = types[0];
            }
            return !string.IsNullOrEmpty(UserClass);
        }

        static public Usuario Validate(string usuario, string password)
        {
            if (LoadUserClass())
            {
                try
                {
                    Usuario pUsuario = (Usuario)Activator.CreateInstance(Assembly.Load(UserNameSpace).GetType(UserClass));
                    return pUsuario.ValidateUser(usuario, password);
                }
                catch { }
            }
            return null;
        }

        static public Usuario Validate() {

            if (LoadUserClass())
            {
                try
                {
                    Usuario pUsuario = (Usuario)Activator.CreateInstance(Assembly.Load(UserNameSpace).GetType(UserClass));
                    return pUsuario.ValidateUser();
                } catch  { }
            }
            return null;
        }

        static public Usuario GetInstance(bool redirect=true) {

            Usuario usuario = null;
            try
            {
                try
                {
                    HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    HttpContext.Current.Response.Headers["pragma"] = "no-cache";
                }
                catch
                {
                    if (HttpContext.Current.Response.Headers["pragma"] != "no-cache")
                        HttpContext.Current.Response.AddHeader("pragma", "no-cache");
                }

                HttpContext.Current.Response.CacheControl = "Private";
                HttpContext.Current.Response.Expires = 0;
                try { usuario = (Usuario)HttpContext.Current.Session["__SDG.Usuario"]; } catch { }
                if (usuario == null)
                    usuario = Validate();
                else usuario = usuario.IsValidUsuario();

                if (usuario == null)
                {
                    if (redirect)
                    {
                        string url = HttpUtility.UrlEncode(HttpContext.Current.Request.Url.AbsolutePath + HttpContext.Current.Request.Url.Query);
                        HttpContext.Current.Response.Redirect(LoginPage + "?from=" + url);
                        HttpContext.Current.Response.End();
                    }
                }
                else if (redirect && !usuario.CanAccess())
                    usuario.Redirect();
            } catch { }
            return usuario;
        }

        static public void EndSession() {

            HttpContext.Current.Session["__SDG.Usuario"] = null; // corrige bug en las sesiones en ASP.NET
        }

        static public Usuario GetUsuario()
        {
            return GetInstance();
        }

        protected int GetCampo(string campo)
        {
            int index = -1;
            for (int i = 0; i < m_saCampos.Count; i++)
                if (m_saCampos[i].ToString() == campo)
                {
                    index = i;
                    break;
                }
            if (index == -1)
            {
                index = m_saCampos.Add(campo);
                m_saValores.Add("");
            }
            return index;
        }

        public string this[string campo]
        {
            get
            {
                return m_saValores[GetCampo(campo)].ToString();
            }
            set
            {
                m_saValores[GetCampo(campo.Length == 0 ? value : campo)] = value;
            }
        }
    }
}
