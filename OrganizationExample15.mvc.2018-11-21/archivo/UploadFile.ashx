<%@ WebHandler Language="C#" Class="UploadFile" %>

using System;
using System.IO;
using System.Web;
using System.Text;
using System.Text.RegularExpressions;
using SDG.Componentes;
using System.Web.SessionState;

public class UploadFile : IHttpHandler, IRequiresSessionState {

    public static Regex regQuery = new Regex("[^a-zA-Z0-9_\\-/\\.\\\\]");
    public void ProcessRequest (HttpContext context) {

        if (context.Request.Files.Count == 0)
            throw new HttpException(404, "Page not found");
        CUsuario usuario = (CUsuario)CUsuario.GetInstance(false);
        if (usuario==null || (usuario.GetPermisosRaiz("~/archivo/Browser.aspx")&(int)Usuario.Permisos.Insert)!=(int)Usuario.Permisos.Insert)
            throw new HttpException(404, "Page not found");

        context.Server.ScriptTimeout = 60*60*24; // 24 horas

        string root = Utilidades.QueryString(context, "r");
        context.Response.ContentType = "application/json";
        if (root.EndsWith("/"))
            root =root.Substring(0, root.Length-1);

        string Message = "";
        int error = 0; // este es en caso de un error pasarlo a uno

        foreach (string s in context.Request.Files)
        {
            HttpPostedFile file = context.Request.Files[s];
            if (!string.IsNullOrEmpty(file.FileName))
            {
                try
                {
                    Query query = new Query("files");

                    string fullPath = root + "/" + file.FileName;
                    query["path"]= fullPath;
                    query["user"] = usuario.Id;
                    query["creation"] = "SYSDATE()";
                    query["size"] = file.InputStream.Length;
                    query.AddCampo("sha", "SHA(" + Query.GetValor(fullPath) + ")", false);
                    query.AddCampo("md5", "MD5(" + Query.GetValor(fullPath) + ")", false);

                    if (fullPath.StartsWith("/"))
                        fullPath = fullPath.Substring(1);
                    if (root.StartsWith("/"))
                        root = root.Substring(1);

                    Directory.CreateDirectory(Path.Combine(HomeCareVersion.FilesPath, "GestionDocumental", regQuery.Replace(root.Replace(" ", "_"), "-").Replace('/', Path.DirectorySeparatorChar)));

                    fullPath= Path.Combine(HomeCareVersion.FilesPath, "GestionDocumental", regQuery.Replace(fullPath.Replace(" ", "_"), "-").Replace('/', Path.DirectorySeparatorChar));
                    file.SaveAs(fullPath);

                    using (CConector conector = new CConector())
                        conector.QueryMod(query.GetInsert(true));
                } catch (Exception ex) {
                    error = 2;
                    Message = ex.ToString();
                }
            }
        }
        context.Response.Write("{\"Error\": " + error + ", \"Message\": \"" + Message + "\"}");
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}