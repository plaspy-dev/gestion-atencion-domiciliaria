using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.IO;
using System.Web.UI.WebControls;

public class Files
{
    public enum Directorys
    {
        RHDocumentos
    }

    public enum ContentDisposition
    {
        None,
        Attachment,
        Inline
    }
    public static string FilePath = HomeCareVersion.FilesPath;

    public Files() { }


    public static string GetDirectoryPath(Directorys directory, params string[] paths)
    {

        string path = Path.Combine(Path.Combine(FilePath, directory.ToString(), Path.Combine(paths)));
        Directory.CreateDirectory(path);
        return path;
    }

    public static string GetDirectoryPath(params string[] paths)
    {

        string directory = Path.Combine(FilePath, Path.Combine(paths));
        Directory.CreateDirectory(directory);
        return directory;
    }

    public static string GetFilePath(Directorys directory, params string[] paths)
    {
        return GetFilePath(directory, false, paths);
    }

    public static string GetFilePath(Directorys directory, bool remove, params string[] paths)
    {

        GetDirectoryPath(directory, paths.Take(paths.Length - 1).ToArray());
        string path = Path.Combine(FilePath, directory.ToString(), Path.Combine(paths));
        if (remove)
        {
            if (File.Exists(path))
                File.Delete(path);
        }
        return path;
    }

    public static string GetFilePath(params string[] paths)
    {

        GetDirectoryPath(paths.Take(paths.Length - 1).ToArray());
        return Path.Combine(FilePath, Path.Combine(paths));
    }

    public static string GetURL(params string[] paths)
    {
        string url = "~/File";
        foreach (string part in paths)
        {
            url += "/" + HttpUtility.UrlPathEncode(part);
        }
        return url;
    }

    public static string GetURL(Directorys directory, params object[] paths)
    {

        return GetURL(directory, ContentDisposition.None, paths);
    }

    public static string GetURL(Directorys directory, ContentDisposition cd, params object[] paths)
    {
        return GetURL(directory, cd, paths.Where(x=>x!=null).Select(x => x.ToString()).ToArray());
    }

    public static string GetURL(Directorys directory, params string[] paths)
    {
        return GetURL(directory, ContentDisposition.None, paths);
    }

    public static string GetURL(Directorys directory, ContentDisposition cd, params string[] paths)
    {

        string url = "~/File/";
        switch (cd)
        {
            case ContentDisposition.Attachment:
                url += "a/";
                break;
            case ContentDisposition.Inline:
                url += "i/";
                break;
        }
        url += HttpUtility.UrlPathEncode(directory.ToString());
        foreach (string part in paths)
        {
            url += "/" + HttpUtility.UrlPathEncode(part);
        }
        return url;
    }

    public static void OnValidaFileJPG(object sender, ServerValidateEventArgs e)
    {
        e.IsValid = false;
        if (e.Value.Length != 0)
        {
            string Extension = e.Value.Substring(e.Value.LastIndexOf(".") + 1).ToLower();
            e.IsValid = Extension == "jpg" || Extension == "jpeg"; // Valid file type
        }
    }

    public static void OnValidaFileJPGPDF(object sender, ServerValidateEventArgs e)
    {
        e.IsValid = false;
        if (e.Value.Length != 0)
        {
            string Extension = e.Value.Substring(e.Value.LastIndexOf(".") + 1).ToLower();
            e.IsValid = Extension == "jpg" || Extension == "jpeg" || Extension == "pdf"; // Valid file type
        }
    }
}