using System;
using System.Collections.Generic;
using System.ServiceModel;
using System.Linq;
using System.Text;
using System.Web;
using System.Diagnostics;
using System.IO;
using System.Runtime.CompilerServices;
using log4net;

namespace SDG.Componentes
{
    public class Logs
    {
        public static ILog DefaultLogger = LogManager.GetLogger("");
        public static Dictionary<string, ILog> Loggers = new Dictionary<string, ILog>();
        public static List<string> SkipMessageErrors = new List<string>() { "The client disconnected." };
        public static List<string> SkipUrls = new List<string>() { ".php" };

        public static ILog GetLogger(string loggerName="") {
            if (string.IsNullOrEmpty(loggerName))
                return DefaultLogger;
            try {
                return Loggers[loggerName];
            } catch { }
            ILog info = LogManager.GetLogger(loggerName);
            Loggers[loggerName] = info;
            return info;
        }

        public static string DumpPage(HttpServerUtility Server, HttpRequest Request)
        {
            return DumpPage(Server, Request, new Query(""));
        }

        public static bool DumpPage(HttpServerUtility Server, HttpRequest Request, Conector conector)
        {
            Query query = new Query("pageError");
            if(!string.IsNullOrEmpty(DumpPage(Server, Request, query)))
                return conector.QueryMod(query.GetInsert())!=-1;
            return false;
        }

        public static string DumpPage(HttpServerUtility Server, HttpRequest Request, Query query) {

            string err = "";
            Exception objErr = null;
            
            try
            {
                foreach (string skipurl in SkipUrls)
                {
                    if (Request.Url.AbsolutePath.EndsWith(skipurl))
                        return null;
                }
                objErr = Server.GetLastError().GetBaseException();
            } catch { }
            try
            {
                query["fecha"] = "SYSDATE()";
                query["url"] = Request.Url.ToString();
                query["error"] = objErr.Message.ToString();

                err = DateTime.Now.ToString() + " Error[app] : ";
                if (objErr is HttpException)
                {
                    err += "("
                       + ((HttpException)objErr).GetHttpCode()
                    + ") ";
                    query["httpexception"] = ((HttpException)objErr).GetHttpCode();
                }
                string errMessage = objErr.Message.ToString();
                err += Request.Url.ToString() + " - '"
                     + errMessage + "'";
                err += "\r\n";
                if (SkipMessageErrors.Contains(errMessage))
                    return null;
            } catch { }
            try {
                err+="Headers";
                err += "\r\n";
                string headers = "";
                foreach (string i in Request.Headers)
                {
                    headers+=i + "=" + Request.Headers[i];
                    headers += "\r\n";
                }
                query["headers"] = headers;
                err += headers;
            }
            catch { }
            try
            {
                err += "Contenido";
                err += "\r\n";

                Request.InputStream.Seek(0, SeekOrigin.Begin);
                if (Request.InputStream.Length > 0)
                {
                    byte[] request = Request.BinaryRead(Math.Min((int)Request.InputStream.Length, 1024));
                    Request.InputStream.Seek(0, SeekOrigin.Begin);
                    string contenido = UTF8Encoding.UTF8.GetString(request);
                    if (!string.IsNullOrEmpty(contenido))
                    {
                        err += contenido;
                        err += "\r\n";
                        err += HttpUtility.UrlDecode(contenido);
                        err += "\r\n";

                        query["contenido"] = HttpUtility.UrlDecode(contenido);
                    }
                }                
            } catch { }
            try {
                err+="Form";
                err += "\r\n";
                string form = "";
                foreach (string i in Request.Form)
                {
                    if (i == "__EVENTTARGET" || i == "__EVENTARGUMENT" || i == "__VIEWSTATE" || i == "__VIEWSTATEENCRYPTED" || i == "__EVENTVALIDATION" || i == "__VC")
                        continue;
                    form += i + "=" + Request.Form[i];
                    form += "\r\n";
                }
                query["form"] = form;
                err += form;
            }
            catch { }
            try {
                query["stacktrace"]= objErr.StackTrace.ToString();
                err +=objErr.StackTrace.ToString();
                err += "\r\n";
            } catch { }
            err += "\r\n";
            return err;
        }

        [MethodImpl(MethodImplOptions.NoInlining)]
        public static string GetCurrentMethod(int stack)
        {
            StackTrace st = new StackTrace();
            StackFrame sf = st.GetFrame(stack);

            return sf.GetMethod().Name;
        }

        [MethodImpl(MethodImplOptions.NoInlining)]
        public static string GetCurrentClass(int stack=1) {
            StackTrace st = new StackTrace();
            StackFrame sf = st.GetFrame(stack);

            return sf.GetMethod().DeclaringType.ToString();
        }

        public static void WriteClassLog(string log, string ClassName=null, string functionName=null)
        {
            if (ClassName == null)
                ClassName = GetCurrentClass(2);
            if (functionName == null)
                functionName = GetCurrentMethod(2);

            string err = string.Format("{0} [{1}:{2}] ", DateTime.Now, ClassName, functionName);
            try
            {
                string url = "";
                if (HttpContext.Current == null)
                {
                    if (OperationContext.Current == null)
                        url = System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                    else url = OperationContext.Current.IncomingMessageHeaders.To.ToString();
                } else url = HttpContext.Current.Request.Url.ToString();
                err += string.Format("({0}) ",url);
            } catch { }
            WriteLog(err + log);
        }

        public static void WriteLog(string logs) {

            DefaultLogger.Info(logs);
            // return WriteLog(logs, System.Configuration.ConfigurationManager.AppSettings["filelogs"]);
        }

        public static void Write(string logstring, params object[] args) {

            DefaultLogger.InfoFormat(logstring, args);
            /*if (args.Length > 0)
                log = string.Format(log, args);
            return WriteLog(log);*/
        }

        /*public static void WriteLog(string logs, string loggerName)
        {
            ILog log= GetLogger(loggerName);
            log.Info(logs);
            /*try
            {
                if (string.IsNullOrEmpty(archivo))
                    archivo= System.Configuration.ConfigurationManager.AppSettings["filelogs"];
                if (!string.IsNullOrEmpty(archivo))
                {
                    using (StreamWriter writer= File.AppendText(archivo)) {
                        writer.WriteLine(logs);
                    }
                    return true;
                }
            } catch {
            }
            return false;*/
        // }
    }
}
