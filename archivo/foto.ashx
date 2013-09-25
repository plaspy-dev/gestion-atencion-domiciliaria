<%@ WebHandler Language="C#" Class="foto" %>

using System;
using System.Web;
using SDG.Componentes;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Web.SessionState;
using System.IO;

public class foto : IHttpHandler, IReadOnlySessionState {
    
    public void ProcessRequest (HttpContext context) {

        if (!string.IsNullOrEmpty( context.Request.QueryString["i"]))
        {
            if (context.Session["foto_tabla"] == null)
                return;
            string id = context.Request.QueryString["i"];
            Query query = new Query(context.Session["foto_tabla"].ToString());

            query["id"]= context.Session["foto_id"].ToString();
            query+= "nombre";
            query += "tipo";

            Archivos archivo = new Archivos(query.GetSelect(context.Session["foto_id"].ToString() + "='" + id + "'")
                , "SELECT archivo FROM " + context.Session["foto_tabla"].ToString()  + " WHERE " + context.Session["foto_id"].ToString() + "='" + id + "'");

            Stream s = new MemoryStream(archivo.Contenido);
            System.Drawing.Image img = System.Drawing.Image.FromStream(s);

            if (!string.IsNullOrEmpty(context.Request.QueryString["h"]) || !string.IsNullOrEmpty(context.Request.QueryString["w"]))
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
                img = new System.Drawing.Bitmap(img, tamano);
            }

            context.Response.Clear();
            context.Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(archivo.Nombre).Replace("+","%20"));
            context.Response.ContentType = "image/jpeg";
            img.Save(context.Response.OutputStream, ImageFormat.Jpeg);
            img.Dispose();
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}