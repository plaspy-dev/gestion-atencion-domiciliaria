<%@ WebHandler Language="C#" Class="file" %>

using System;
using System.Linq;
using System.Web;
using System.IO;
using System.Globalization;
using SDG.Componentes;

public class file : IHttpHandler {

    public void ProcessRequest (HttpContext context) {

        string path = Utilidades.QueryString(context, "p");
        if (string.IsNullOrEmpty(path)) {
            throw new HttpException(404, "Page not found");
        }

        string fileName = Path.GetFileName(path);
        string type="";
        if (path.StartsWith("i/"))
        {
            path = path.Substring(2);
            type = "inline;filename=" + HttpUtility.UrlPathEncode(fileName);
        } else if (path.StartsWith("a/")) {
            path = path.Substring(2);
            type = "attachment;filename=" + HttpUtility.UrlPathEncode(fileName);
        }
        string file= Files.GetFilePath(path);

        if (!File.Exists(file)) {
            string []parts= path.Split('/');
            string extension= Path.GetExtension(parts.Last());
            file = Files.GetFilePath(parts.Take(parts.Length-1).ToArray()) + extension;
            if (!File.Exists(file))
                throw new HttpException(404, "Page not found");
        }
        DateTime modificacion=File.GetLastWriteTime(file);
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
        if (!string.IsNullOrEmpty(type))
            context.Response.AddHeader("Content-Disposition", type);
        context.Response.Flush();
        context.Response.WriteFile(file);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}