using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace SDG.Componentes
{
    public class HtmlUtil
    {
        public static Dictionary<string, string> FilesMap = new Dictionary<string, string>();

        public static IHtmlString RenderStyle(string url)
        {
            return new HtmlString(string.Format("<link rel=\"stylesheet\" href=\"{0}\" />", GetAbsoluteURLVersion(url)));
        }

        public static IHtmlString RenderScript(string url)
        {
            return new HtmlString(string.Format("<script type=\"text/javascript\" src=\"{0}\"></script>", GetAbsoluteURLVersion(url)));
        }

        public static string GetAbsoluteURLVersion(string url) {

            return VirtualPathUtility.ToAbsolute(GetURLVersion(url));
        }

        public static string GetURLVersion(string url)
        {
            try { return FilesMap[url]; } catch { }
            string file = HttpContext.Current.Server.MapPath(url);
            file = File.Exists(file) ? (url + "?v=" + File.GetLastWriteTimeUtc(file).ToString("yMdHms")) : url;
            FilesMap[url] = file;
            return file;
        }
    }
}
