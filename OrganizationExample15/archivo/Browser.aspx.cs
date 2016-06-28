using System;
using System.IO;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;
using System.Text.RegularExpressions;

public partial class archivo_Browser : System.Web.UI.Page
{
    public static Regex regQuery = new Regex("[^a-zA-Z0-9\\-_/\\.\\\\:]");
    public static string PathFiles = "GestionDocumental";

    public class HeaderPath
    {
        public string Path { get; set; }
        public string Name { get; set; }
        public HeaderPath() { }
        public HeaderPath(string path, string name)
        {
            Path = path;
            Name = name;
        }
    }

    public static string GetCleanFile(string file) {

        return regQuery.Replace(file.Replace(" ", "_"), "-");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetInstance();
            string directory = Utilidades.QueryString(this, "dir");
            if (string.IsNullOrEmpty(directory))
                directory = "/";

            if (!directory.EndsWith("/"))
            {
                try
                {
                    if (directory.StartsWith("/"))
                        directory = directory.Substring(1);

                    Response.Clear();

                    DateTime fecha = File.GetLastWriteTime(Path.Combine(HomeCareVersion.FilesPath, PathFiles, GetCleanFile(directory)));

                    if (!String.IsNullOrEmpty(Request.Headers["If-Modified-Since"]))
                    {
                        if (Request.Headers["If-Modified-Since"] == fecha.ToUniversalTime().ToString("r"))
                        {
                            Response.StatusCode = 304;
                            Response.StatusDescription = "Not Modified";
                            if(Utilidades.IsMono)
                                HttpContext.Current.ApplicationInstance.CompleteRequest(); // Mono Fix
                            Response.End();
                            return;
                        }
                    }

                    Server.ScriptTimeout = 60 * 60 * 48; // dos dias

                    Response.ContentType = "application/octet-stream"; // buscamos el logo jpg
                    Response.AddHeader("Last-Modified", fecha.ToUniversalTime().ToString("r"));
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlPathEncode(Path.GetFileName(directory)));
                    Response.Flush();
                    Response.WriteFile(Path.Combine(HomeCareVersion.FilesPath, PathFiles, GetCleanFile(directory)));
                    if (Utilidades.IsMono)
                        HttpContext.Current.ApplicationInstance.CompleteRequest(); // Mono Fix
                    Response.End();
                    return;
                }
                catch
                {
                    System.Threading.Thread.Sleep(3000);
                    throw new HttpException(404, "No se encontro el archivo");
                }
            }

            BDelete.Visible = usuario.CanDelete();

            GFiles.Columns[0].Visible =
            dZUpload.Visible =
            PF.Visible =
            PU.Visible =
            BFolder.Visible = usuario.CanInsert();

            ViewState["root"] = directory;
            SFiles.SelectParameters["dir"].DefaultValue = directory;

            string[] split = directory.Split(new char[] { '/' }, StringSplitOptions.RemoveEmptyEntries);
            List<HeaderPath> rutas = new List<HeaderPath>();
            rutas.Add(new HeaderPath("/", "Inicio"));

            for (int i = 0; i < split.Length; i++)
            {
                rutas.Add(new HeaderPath("/" + string.Join("/", split, 0, i + 1) + "/", split[i]));
            }
            RPath.DataSource = rutas;
            RPath.DataBind();
        }
    }

    protected string GetHumanFileSize(object value)
    {
        if (value == null || value == DBNull.Value)
            return null;
        string[] sizes = { "B", "KB", "MB", "GB" };
        double len = (int)value;
        int order = 0;
        while (len >= 1024 && order + 1 < sizes.Length)
        {
            order++;
            len = len / 1024;
        }
        return string.Format("{0:0.##} {1}", len, sizes[order]);
    }

    protected string GetFileIcon(object value)
    {
        string filename = (string)value;
        if (filename.EndsWith("/"))
            return "fa-folder";
        return "fa-file";
    }
    protected void BFolder_Click(object sender, EventArgs e)
    {
        if (TFolder.Text.Length == 0)
            return;

        string root = (string)ViewState["root"];
        Query query = new Query("files");

        string fullpath = root + TFolder.Text + "/";
        query["path"] = fullpath;
        query["creation"] = "SYSDATE()";
        query.AddCampo("sha", "SHA(" + Query.GetValor(fullpath) + ")", false);
        query.AddCampo("md5", "MD5(" + Query.GetValor(fullpath) + ")", false);

        using (CConector conector = new CConector())
        {
            if (conector.QueryMod(query.GetInsert(true)) == -1)
            {
                LMessage.Text = conector.LastError;
                return;
            }
        }
        GFiles.DataBind();
        TFolder.Text = "";
    }

    protected void BUpdate_Click(object sender, EventArgs e)
    {
        GFiles.DataBind();
    }

    public bool DeleteDirectory(Conector conector, string DirectoryPath) {

        Query query = new Query("files");
        string localRootPath = Path.Combine(HomeCareVersion.FilesPath, PathFiles);

        if (Directory.Exists(GetCleanFile(DirectoryPath)))
        {
            foreach (string path in Directory.GetDirectories(GetCleanFile(DirectoryPath)))
            {
                if (!DeleteDirectory(conector, path))
                    return false;
                Directory.Delete(GetCleanFile(path));
            }

            foreach (string path in Directory.GetFiles(GetCleanFile(DirectoryPath)))
            {
                string dbpathf = path.Replace(localRootPath, "").Replace(Path.DirectorySeparatorChar, '/');
                if (conector.QueryMod(query.GetDelete("sha=SHA({0}) AND md5=MD5({0})", Query.GetValor(dbpathf))) == -1)
                {
                    LMessage.Text = conector.LastError;
                    return false;
                }
                File.Delete(GetCleanFile(path));
            }
        }
        string dbpath = DirectoryPath.Replace(localRootPath, "").Replace(Path.DirectorySeparatorChar, '/');
        if (conector.QueryMod(query.GetDelete("path LIKE {0}", Query.GetValor(dbpath + "%"))) == -1)
        {
            LMessage.Text = conector.LastError;
            return false;
        }
        return true;
    }

    protected bool DeleteFile(Conector conector, string filepath)
    {
        try
        {
            Query query = new Query("files");
            string localpath = filepath;
            if (localpath.StartsWith("/"))
                localpath = localpath.Substring(1);
            localpath= localpath.Replace('/', Path.DirectorySeparatorChar);
            string fulllocalpath = Path.Combine(HomeCareVersion.FilesPath, PathFiles, localpath);

            if (filepath.EndsWith("/")) { // es una carpeta
                if (!DeleteDirectory(conector, fulllocalpath))
                    return false;
                try { Directory.Delete(GetCleanFile(fulllocalpath)); } catch { }
            } else {
                File.Delete(GetCleanFile(fulllocalpath));
            }

            if (conector.QueryMod(query.GetDelete("sha=SHA({0}) AND md5=MD5({0})", Query.GetValor(filepath))) == -1)
            {
                LMessage.Text = conector.LastError;
                return false;
            }
        } catch (Exception ex) {
            LMessage.Text = ex.ToString();
            return false;
        }
        return true;
    }

    protected void BDelete_Click(object sender, EventArgs e)
    {
        string root = (string)ViewState["root"];

        using (CConector conector = new CConector())
        {
            for (int i = 0; i < GFiles.Rows.Count; i++)
            {
                CheckBox selected = (CheckBox)GFiles.Rows[i].FindControl("C");
                if (selected.Checked)
                {
                    if (!DeleteFile(conector, GFiles.DataKeys[i].Values["path"].ToString()))
                        return;
                }
            }
        }
        GFiles.DataBind();
    }
}