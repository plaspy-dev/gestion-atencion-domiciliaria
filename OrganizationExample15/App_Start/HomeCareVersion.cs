using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
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
    public const string JSONContentType = "application/json";
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

    public static Cookie CopyCookie(HttpCookie cookie, string domain) {

        return new Cookie()
        {
            Expires = cookie.Expires,
            Name = cookie.Name,
            Path = cookie.Path,
            Secure = cookie.Secure,
            Value = cookie.Value,
            Domain = domain,
            HttpOnly = cookie.HttpOnly,
        };
    }

    public static string DownloadURLAuth(Controller controller, string url) {

        Uri fileDownloadURI = new Uri(url);
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
        HttpCookie authCookie = FormsAuthentication.GetAuthCookie(controller.User.Identity.Name, true);
        request.CookieContainer = new CookieContainer();
        request.CookieContainer.Add(CopyCookie(authCookie, fileDownloadURI.Host));
        // Solo por compatibilidad con webforms
        request.CookieContainer.Add(CopyCookie(controller.Request.Cookies["loginOrganizationExample15"], fileDownloadURI.Host));
        request.CookieContainer.Add(CopyCookie(controller.Request.Cookies["contrasena"], fileDownloadURI.Host));
        // request.CookieContainer.Add(CopyCookie(controller.Request.Cookies["ASP.NET_SessionId"], fileDownloadURI.Host));

        HttpWebResponse webResponse = (HttpWebResponse)request.GetResponse();
        using (Stream myStreamReader = webResponse.GetResponseStream())
        {
            using (var textreader = new StreamReader(myStreamReader))
            {
                return textreader.ReadToEnd();
            }
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

    public static string GetDateVersion(DateTime datetime) {

        return string.Format("{0:yyMMddhhmmss}", datetime);
    }

    public static string GetCleanNumber(string value) {

        string temp = "";
        foreach (char character in value) {
            if(char.IsNumber(character) || character=='.')
                temp += character;
        }
        return temp;
    }

    public static int? ParseInt(string value) {
        try
        {
            return int.Parse(GetCleanNumber(value), CultureInfo.InvariantCulture);
        } catch { }
        return null;
    }

    public static decimal? ParseDecimal(string value) {
        try
        {
            return decimal.Parse(GetCleanNumber(value), CultureInfo.InvariantCulture);
        }
        catch { }
        return null;
    }

    public static double? ParseDouble(string value)
    {
        try
        {
            return double.Parse(GetCleanNumber(value), CultureInfo.InvariantCulture);
        }
        catch { }
        return null;
    }

    public static ViewDataDictionary GetPrefixPartial(string prefix) {
        return new ViewDataDictionary()
        {
            TemplateInfo = new TemplateInfo { HtmlFieldPrefix = prefix },
        };
    }

    public static string URLAppendParam(HttpRequestBase Request, string parametro, string valor)
    {
        return URLAppendParam(Request.Url.AbsolutePath, Request.Url.Query, parametro, valor);
    }

    public static string URLAppendParam(string url, string query, string parametro, string valor) {

        var bquery = HttpUtility.ParseQueryString(query);
        bquery[parametro] = valor;
        return url + "?" + bquery.ToString();
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
