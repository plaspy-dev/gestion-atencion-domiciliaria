using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

/// <summary>
/// Descripción breve de Version
/// </summary>
public static class DateTimeExtensions
{
    public static DateTime StartOfWeek(this DateTime dt, DayOfWeek startOfWeek)
    {
        int diff = (7 + (dt.DayOfWeek - startOfWeek)) % 7;
        return dt.AddDays(-1 * diff).Date;
    }
}

public class HomeCareVersion
{
    public const string Number="1.89";
    public const int VERSION_FILES = 1;
    public static string FilesPath= ConfigurationManager.AppSettings["pathFiles"];

    public static JsonSerializerSettings jsonSerializerSettings = new JsonSerializerSettings() { NullValueHandling = NullValueHandling.Ignore };
    public static JsonSerializerSettings JsonSerializerSettingsCamelCase = new JsonSerializerSettings() { NullValueHandling = NullValueHandling.Ignore, ContractResolver = new CamelCasePropertyNamesContractResolver() };

    public static bool IsDebug {
        get {
#if DEBUG
            return true;
#else
            return false;
#endif
        }
    }
    public static string GetURLLocalhost()
    {
        if (HttpContext.Current.Request.Url.Host == "localhost" && !HttpContext.Current.Request.Url.IsDefaultPort)
        {
            return "http://localhost:" + HttpContext.Current.Request.Url.Port;
        }
        return "http://localhost";
    }

    public static ViewDataDictionary GetPrefixPartial(string prefix) {
        return new ViewDataDictionary()
        {
            TemplateInfo = new System.Web.Mvc.TemplateInfo { HtmlFieldPrefix = prefix }
        };
    }
    /*public static string CssPath(string file)
    {
        return VirtualPathUtility.ToAbsolute(string.Format("~/css{0}/{1}", VERSION_FILES, file));
    }

    public static string JSPath(string file)
    {
        return VirtualPathUtility.ToAbsolute(string.Format("~/js{0}/{1}", VERSION_FILES, file));
    }*/
}
