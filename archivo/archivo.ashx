<%@ WebHandler Language="C#" Class="archivo" %>

using System;
using System.Web;
using System.Globalization;
using System.IO;
using System.Configuration;

public class archivo : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {

        if (string.IsNullOrEmpty(context.Request.QueryString["p"])
            && string.IsNullOrEmpty(context.Request.QueryString["t"]))
            throw new HttpException(404, "Page not found");

        context.Response.ContentType = "application/octet-stream";
        if (string.IsNullOrEmpty(context.Request.QueryString["a"]))
            context.Response.AddHeader("Content-Disposition", "inline;filename=" + context.Request.QueryString["n"]);
        else context.Response.AddHeader("Content-Disposition", "attachment;filename=" + context.Request.QueryString["n"]);

        string tipo = context.Request.QueryString["t"];
        switch (tipo)
        {
            case "v":
                tipo = "valoracion";
                break;
            case "e":
                tipo = "evolucion";
                break;
            case "r":
                tipo = "rh";
                break;
            case "p":
                tipo = "paciente";
                break;
            case "q":
                tipo = "pqr";
                break;
        }
        string archivo = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], tipo);
        if (context.Request.QueryString["d"] == "True")
        {
            archivo = Path.Combine(archivo, "temp");
            archivo = Path.Combine(archivo, context.Request.QueryString["p"]);
        } else if (!string.IsNullOrEmpty(context.Request.QueryString["i"]))
            archivo = Path.Combine(archivo, context.Request.QueryString["i"]);
        if (!string.IsNullOrEmpty(context.Request.QueryString["hi"]))
            archivo = Path.Combine(archivo, context.Request.QueryString["hi"]);
        if (!string.IsNullOrEmpty(context.Request.QueryString["x"]))
        {
            try
            {
                int posicion = Convert.ToInt32(context.Request.QueryString["x"]);
                foreach (string file in Directory.GetFiles(archivo))
                {
                    posicion--;
                    if (posicion == 0)
                    {
                        archivo = file;
                        break;
                    }
                }
            } catch { // no existe el directorio.
                throw new HttpException(404, "Page not found");
            }
        } else if (!string.IsNullOrEmpty(context.Request.QueryString["n"]))
            archivo = Path.Combine(archivo, context.Request.QueryString["n"]);

        if (File.Exists(archivo))
        {
            DateTime modificacion = File.GetLastWriteTimeUtc(archivo);

            if (!String.IsNullOrEmpty(context.Request.Headers["If-Modified-Since"]))
            {
                CultureInfo provider = CultureInfo.InvariantCulture;
                var lastMod = DateTime.ParseExact(context.Request.Headers["If-Modified-Since"], "r", provider);
                if (lastMod.ToString() == modificacion.ToString())
                {
                    context.Response.StatusCode = 304;
                    context.Response.StatusDescription = "Not Modified";
                    return;
                }
            }

            context.Response.Cache.SetCacheability(HttpCacheability.Public);
            context.Response.Cache.SetLastModified(modificacion);
            context.Response.Flush();
    
            context.Response.WriteFile(archivo);
        }
        else
        {
            throw new HttpException(404, "Page not found");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}