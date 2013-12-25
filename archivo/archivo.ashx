<%@ WebHandler Language="C#" Class="archivo" %>

using System;
using System.Web;
using System.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Globalization;

public class archivo : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {

        if (string.IsNullOrEmpty(context.Request.QueryString["p"]) 
            || string.IsNullOrEmpty(context.Request.QueryString["t"]))
            throw new HttpException(404, "Page not found");
        
        context.Response.ContentType = "image/jpeg";
        if(string.IsNullOrEmpty(context.Request.QueryString["a"]))
            context.Response.AddHeader("Content-Disposition", "inline;filename=" + context.Request.QueryString["n"]);
        else context.Response.AddHeader("Content-Disposition", "attachment;filename=" + context.Request.QueryString["n"]);

        string tipo = context.Request.QueryString["t"];
        if (tipo == "v")
            tipo = "valoracion";
        else if (tipo == "e")
            tipo = "evolucion";
        string archivo = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], tipo);
        if (context.Request.QueryString["d"] == "True")
        {
            archivo = Path.Combine(archivo, "temp");
            archivo = Path.Combine(archivo, context.Request.QueryString["p"]);
        } else archivo = Path.Combine(archivo, context.Request.QueryString["i"]);
        archivo = Path.Combine(archivo, context.Request.QueryString["hi"]);
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
            
            if (!string.IsNullOrEmpty(context.Request.QueryString["h"]) || !string.IsNullOrEmpty(context.Request.QueryString["w"]))
            {
                using (Image img = Image.FromFile(archivo))
                {

                    Size tamano = new Size();
                    tamano.Height = 0;
                    tamano.Width = 0;
                    if (!string.IsNullOrEmpty(context.Request.QueryString["h"]))
                    {
                        tamano.Height = Convert.ToInt32(context.Request.QueryString["h"]);
                    }
                    if (!string.IsNullOrEmpty(context.Request.QueryString["w"]))
                    {
                        tamano.Width = Convert.ToInt32(context.Request.QueryString["w"]);
                    }
                    if (tamano.Height == 0)
                    {
                        tamano.Height = tamano.Width * img.Size.Height / img.Size.Width;
                    }
                    else if (tamano.Width == 0)
                    {
                        tamano.Width = tamano.Height * img.Size.Width / img.Size.Height;
                    }
                    using(Bitmap bmp= new Bitmap(img, tamano))
                        bmp.Save(context.Response.OutputStream, ImageFormat.Jpeg);
                }
            } else {
                context.Response.WriteFile(archivo);
            }            
        }
        else
        {
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