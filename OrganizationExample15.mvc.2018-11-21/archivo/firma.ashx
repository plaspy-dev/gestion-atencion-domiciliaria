<%@ WebHandler Language="C#" Class="firma" %>

using System;
using System.Web;
using System.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Globalization;
using SDG.Componentes;

public class firma : IHttpHandler {

    public void ProcessRequest (HttpContext context) {

        string id = Utilidades.QueryString(context, "ui");
        string type= Utilidades.QueryString(context, "t");
        if (string.IsNullOrEmpty(id) || string.IsNullOrEmpty(type))
            throw new HttpException(404, "Page not found");
        context.Response.ContentType = "image/jpeg";
        string archivo = Path.Combine(HomeCareVersion.FilesPath, type, id + ".jpg");
        if (File.Exists(archivo))
        {
            DateTime modificacion=File.GetLastWriteTime(archivo);

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
        } else {
            using (var bmp = new System.Drawing.Bitmap(1, 1))
            {
                using (Graphics g = Graphics.FromImage(bmp))
                {
                    g.Clear(Color.White);
                }
                using (MemoryStream memStream = new MemoryStream())
                {
                    bmp.Save(memStream, ImageFormat.Jpeg);
                    context.Response.BinaryWrite(memStream.ToArray());
                }
            }
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}