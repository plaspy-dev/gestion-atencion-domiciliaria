using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
using SDG.Web;

namespace OrganizationExample15
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            CConector.UpgradeDBFromFile(Server.MapPath("~/dbupgrade.json"));
            CUsuario.StartPage = "~/Inicio";
           AreaRegistration.RegisterAllAreas();
            RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
        }

        void Application_Error(object sender, EventArgs e)
        {
            Exception exx = Server.GetLastError();
            if (exx is HttpException)
            {
                if (((HttpException)(exx)).GetHttpCode() == 404
                    || ((HttpException)(exx)).GetHttpCode() == 403
                    || ((HttpException)(exx)).GetHttpCode() == 405
                    || ((HttpException)(exx)).GetHttpCode() == 411) // omitimos los errores 403, 404 y 411 The request body is incomplete.
                    return;
            }

            exx = exx.GetBaseException();
            if (exx is HttpException)
            {
                if (((HttpException)(exx)).GetHttpCode() == 404
                    || ((HttpException)(exx)).GetHttpCode() == 403
                    || ((HttpException)(exx)).GetHttpCode() == 405
                    || ((HttpException)(exx)).GetHttpCode() == 411) // omitimos los errores 403, 404 y 411 The request body is incomplete.    
                    return;
            }
#if DEBUG
            SDG.Componentes.Logs.WriteLog(SDG.Componentes.Logs.DumpPage(Server, Request));
#else
        SDG.Componentes.Logs.WriteLog(SDG.Componentes.Logs.DumpPage(Server, Request));
#endif
            // Server.ClearError();
        }

        void RegisterRoutes(RouteCollection routes)
        {
            RouteTable.Routes.Add(new Route("Image/{t}/{ui}.jpg", new HttpHandlerRoute("~/archivo/firma.ashx")));
            routes.MapPageRoute("~/archivo/Browser.aspx", "archivo/GestionDocumental/{*dir}", "~/archivo/Browser.aspx", false, new RouteValueDictionary { { "dir", null } });
            routes.MapPageRoute("~/archivo/consultahistoria.aspx", "archivo/Historia/{key}", "~/archivo/consultahistoria.aspx");
            RouteTable.Routes.Add(new Route("File/Upload/{*r}", new HttpHandlerRoute("~/archivo/UploadFile.ashx")));
            RouteTable.Routes.Add(new Route("File/{*p}", new HttpHandlerRoute("~/file/file.ashx")));
        }
    }
}