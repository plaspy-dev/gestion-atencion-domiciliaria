<%@ WebHandler Language="C#" Class="ver" %>

using System;
using System.Web;
using System.Collections;
using System.Web.SessionState;

public class ver : IHttpHandler, IReadOnlySessionState {
    
    public void ProcessRequest (HttpContext context) {

        if (!string.IsNullOrEmpty(context.Request.QueryString["f"]))
        {
            int id = Convert.ToInt32(context.Request.QueryString["f"]);

            ArrayList archivos = (ArrayList)context.Session["FileUpload"];
            Archivos info = null;

            for (int i = 0; i < archivos.Count; i++)
            {
                info = (Archivos)archivos[i];
                if (info.Id == id)
                {
                    break;
                }
                info = null;
            }
            if (info == null)
                return;

            context.Response.Clear();
            context.Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(info.Nombre).Replace("+", "%20"));
            context.Response.ContentType = info.Tipo;
            context.Response.BinaryWrite(info.Contenido);
        }
        else if (!string.IsNullOrEmpty(context.Request.QueryString["s"]))
        {
            Archivos archivo = (Archivos)context.Session["FileUpload0"];
            if (archivo != null)
                archivo.ShowFile(context.Response);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}