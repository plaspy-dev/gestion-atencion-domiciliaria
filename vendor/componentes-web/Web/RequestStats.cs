using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;

namespace SDG.Componentes.Web
{
    public class RequestStats
    {
        public const string ItemKeyName = "__SDGUIdentity";
        public static readonly string[] SkipFormNames = { "__EVENTTARGET", "__EVENTARGUMENT", "__VIEWSTATE", "__VIEWSTATEENCRYPTED", "__EVENTVALIDATION", "__VC", "__VIEWSTATEGENERATOR" };
        protected static List<RequestStats> _Stats = new List<RequestStats>();
        public const int MAX_MINUTES = 5;
        protected static object _lock = new object();
        public static List<RequestStats> Stats
        {
            get
            {
                List<RequestStats> copy = new List<RequestStats>();
                lock (_lock)
                    _Stats.ForEach(x => copy.Add(x));
                return copy;
            }
        }

        public string UID { get; set; }
        public string URL { get; set; }
        public string User { get; set; }
        public string IP { get; set; }
        public string Form { get; set; }
        public string Headers { get; set; }
        public string Contenido { get; set; }
        public DateTime Date { get; set; }
        public DateTime? FinishTime { get; set; }
        public TimeSpan Elapsed
        {
            get
            {
                return (FinishTime ?? DateTime.Now) - Date;
            }
        }

        public RequestStats()
        {
            Date = DateTime.Now;
            UID = Guid.NewGuid().ToString();
        }

        public RequestStats(HttpRequest Request, bool addForm) : this() {

            URL = Request.Url.ToString();
            IP = Request.ServerVariables["REMOTE_ADDR"];
            Headers = "";
            try
            {
                foreach (string i in Request.Headers)
                {
                    Headers += i + "=" + Request.Headers[i];
                    Headers += "\r\n";
                }
            }
            catch { }

            if (addForm)
            {
                try
                {
                    Usuario usuario = (Usuario)HttpContext.Current.Session["__SDG.Usuario"];
                    if (usuario != null)
                        User = usuario.Login;
                }
                catch { }
            }
            try
            {
                if (string.IsNullOrEmpty(User))
                {
                    User = Request.Cookies["usuario"]?.Value;
                    if(string.IsNullOrEmpty(User))
                        User= HttpUtility.UrlDecode(Request.Cookies["pemail"]?.Value);
                }
            }
            catch { }

            if (addForm)
            {
                try
                {
                    Request.InputStream.Seek(0, SeekOrigin.Begin);
                    if (Request.InputStream.Length > 0)
                    {
                        byte[] request = Request.BinaryRead(Math.Min((int)Request.InputStream.Length, 1024));
                        Request.InputStream.Seek(0, SeekOrigin.Begin);
                        Contenido = UTF8Encoding.UTF8.GetString(request);
                    }
                }
                catch { }
                Form = "";
                try
                {
                    foreach (string i in Request.Form)
                    {
                        if (SkipFormNames.Contains(i))
                            continue;

                        Form += i + "=" + Request.Form[i];
                        Form += "\r\n";
                    }
                }
                catch { }
            }
        }

        public static void AddStats(HttpApplication application, bool addform)
        {
            RequestStats info = new RequestStats(application.Context.Request, addform);
            application.Context.Items.Add(ItemKeyName, info.UID);
            lock (_lock)
            {
                _Stats.Add(info);
            }
        }

        public static void AddStats(HttpApplication application)
        {
            AddStats(application, application.Context.Handler is Page);
        }

        public static void RemoveStats(HttpApplication application)
        {
            try
            {
                string uid = application.Context.Items[ItemKeyName].ToString();
                DateTime cleanTime = DateTime.Now.AddMinutes(-MAX_MINUTES);
                lock (_lock)
                {
                    if (application.Context.Handler == null)
                    {
                        _Stats.RemoveAll(x => x.UID == uid); // is a static resource
                    }
                    else
                    {
                        // Logs.Write("{0} {1}", application.Context.Request.Url, application.Context.Handler.GetType().ToString());
                        var info = _Stats.Find(x => x.UID == uid);
                        if (info != null)
                            info.FinishTime = DateTime.Now;
                        _Stats.RemoveAll(x => x.FinishTime < cleanTime);
                    }
                }
            }
            catch { }
        }
    }
}
