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

namespace SDG.Componentes
{
    public class Usuario
    {
        [Flags]
        public enum Permisos
        {
            Read =      0x01,
            Print =     0x02,
            Insert =    0x04,
            Update =    0x08,
            Delete =    0x10,
            Admin =     0x20,
            Todos =     0xff
        };

        private static bool bHeaderCache = false;
        private static bool bGetKey = false;
        protected string m_szNombre;
        protected int m_nGrupo;
        protected string m_szID;
        protected string m_szLogin;
        protected Grupo m_pGrupo;
        protected string m_szUrl;
        protected ArrayList m_saCampos= new ArrayList();
        protected ArrayList m_saValores = new ArrayList();

        public string Nombre { get { return m_szNombre; } }
        public string Id { get { return m_szID; } }
        public int Grupo { get { return m_nGrupo; } set { m_nGrupo = value; } }
        public string Login { get { return m_szLogin; } }
        public string ForceURL { get { return m_szUrl; } }

        protected Usuario() {
            m_szNombre = "";
            m_nGrupo = 0;
            m_szID = "";
            m_szLogin = "";
            m_pGrupo = new Grupo();
            m_szUrl = "";
        }

	    public Usuario(string id, string nombre, int grupo, string login)
	    {
            if (!GetKey())
                return;
            m_szNombre = nombre;
            m_nGrupo = grupo;
            m_szID = id;
            m_szLogin = login;
            m_pGrupo = new Grupo();
            m_szUrl = "";
            HttpContext.Current.Session["Usuario"] = this;
	    }

        public string GetLogin() {
            return m_szLogin;
        }
        public void CreateMenu(TreeView tree)
        {
            m_pGrupo.CreateMenu(tree, "", this);
        }
        public String GetForceURL() {
            return m_szUrl;
        }
        public void SetForceURL(string url, Conector conector) {
            m_szUrl = url;
            conector.QueryMod("UPDATE usuario SET forceurl=" + Query.GetValor(url) + " WHERE id=" + GetID());
        }
        public void SetForceURL(string url)
        {
            m_szUrl = url;
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

        public virtual int GetPermisosRaiz(string url) {

            if (m_nGrupo == 0)
                return (int)Permisos.Todos;
            return m_pGrupo.GetPermisoRaiz(url);
        }

        public virtual int GetPermisos(string url) {

            if (m_nGrupo == 0)
                return (int)Permisos.Todos;
            return m_pGrupo.GetPermisos(url);
        }

        public virtual int GetPermisos() {

            if (m_nGrupo == 0)
                return (int)Permisos.Todos;
            return GetPermisos(HttpContext.Current.Request.Url.AbsolutePath);
        }

        public virtual bool CanRead()
        {
            if (m_nGrupo == 0)
                return true;
            return GetPermisos()>0;
        }
        public virtual bool CanInsert()
        {
            if (m_nGrupo == 0)
                return true;
            return (GetPermisos() & (int)Permisos.Insert) == (int)Permisos.Insert;
        }
        public virtual bool CanPrint()
        {
            if (m_nGrupo == 0)
                return true;
            return (GetPermisos() & (int)Permisos.Print) == (int)Permisos.Print;
        }
        public virtual bool CanUpdate()
        {
            if (m_nGrupo == 0)
                return true;
            return (GetPermisos() & (int)Permisos.Update) == (int)Permisos.Update;
        }
        public virtual bool CanDelete()
        {
            if (m_nGrupo == 0)
                return true;
            return (GetPermisos() & (int)Permisos.Delete) == (int)Permisos.Delete;
        }
        public virtual bool CanAdmin()
        {
            if (m_nGrupo == 0)
                return true;
            return (GetPermisos() & (int)Permisos.Admin) == (int)Permisos.Admin;
        }

        public virtual bool CanAccess()
        {
            if (m_nGrupo == 0)
                return true;
            if (HttpContext.Current.Request.Url.AbsolutePath.IndexOf(".asmx") != -1)
                return true;
            if(HttpContext.Current.Request.Url.AbsolutePath==HttpContext.Current.Request.ApplicationPath + "/inicio.aspx")
                return true;
            return GetPermisos()>0;
        }

        public void Redirect()
        {
            HttpContext.Current.Response.Redirect("~/inicio.aspx");
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

        static public Usuario Validate(string usuario, string password)
        {
            if (!string.IsNullOrEmpty(System.Configuration.ConfigurationSettings.AppSettings["Usuario"]))
            {
                try
                {
                    Usuario pUsuario = (Usuario)Activator.CreateInstance(System.Reflection.Assembly.Load("App_Code").GetType(System.Configuration.ConfigurationSettings.AppSettings["Usuario"]));
                    return pUsuario.ValidateUser(usuario, password);
                }
                catch { }
            }
            return null;
        }

        static public Usuario Validate() {

            if (!string.IsNullOrEmpty(System.Configuration.ConfigurationSettings.AppSettings["Usuario"]))
            {
                try
                {
                    Usuario usuario = (Usuario)Activator.CreateInstance(System.Reflection.Assembly.Load("App_Code").GetType(System.Configuration.ConfigurationSettings.AppSettings["Usuario"]));
                    return usuario.ValidateUser();
                } catch  { }
            }
            return null;
        }

        static public Usuario GetInstance(bool redirect) {

            if (!bHeaderCache)
            {
                try {
                    HttpContext.Current.Response.Headers["pragma"] = "no-cache";
                }
                catch {
                    HttpContext.Current.Response.AddHeader("pragma", "no-cache");
                }
                bHeaderCache = true;
            }
            HttpContext.Current.Response.CacheControl = "Private";
            HttpContext.Current.Response.Expires = 0;
            Usuario usuario = (Usuario)HttpContext.Current.Session["Usuario"];
            if (usuario == null)
                usuario = Validate();
            else usuario = usuario.IsValidUsuario();

            if (usuario == null)
            {
                if (redirect)
                {
                    string url = HttpUtility.UrlEncode(HttpContext.Current.Request.Url.AbsolutePath + HttpContext.Current.Request.Url.Query);
                    HttpContext.Current.Response.Redirect("~/Default.aspx?from=" + url);
                    HttpContext.Current.Response.End();
                }
            } else if (redirect && !usuario.CanAccess())
                usuario.Redirect();

            return usuario;
        }

        static public Usuario GetInstance() {

            return GetInstance(true);
        }

        static public Usuario GetUsuario()
        {
            return GetInstance(true);
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

        static private bool GetKey()
        {
            if (bGetKey)
                return true;
            try
            {
                string[] keys = null;
                string dominio;
                if (HttpContext.Current == null) // es una pagina web
                {
                    if (OperationContext.Current == null)
                        dominio = System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                    else dominio = OperationContext.Current.IncomingMessageHeaders.To.Host;
                    if (dominio == "localhost")
                        return true;
                }
                else
                {
                    if (HttpContext.Current.Request.Url.Host == "localhost")
                        return true;
                    if (string.IsNullOrEmpty(ConfigurationSettings.AppSettings["DomainKey"]))
                        return false;
                    dominio = HttpContext.Current.Request.Url.Host;
                }
                keys = ConfigurationSettings.AppSettings["DomainKey"].Split(';');

                for (int i = 0; i < keys.Length; i++)
                {
                    if (Crypt.GetMD5(Crypt.Encriptar3DES(
                        dominio.PadRight(29, 'x').PadRight(37, '?').Replace("x", ";")
                        , "23B9134382220883".Replace("2", "1").Replace("2", "6"))) == keys[i])
                    {
                        bGetKey = true;
                        return true;
                    }
                }
                return false;
            }
            catch { }
            return false;
        }
    }
}
