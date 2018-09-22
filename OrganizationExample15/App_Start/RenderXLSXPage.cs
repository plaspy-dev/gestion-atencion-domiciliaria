using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace OrganizationExample15
{
    public class RenderXLSXPage
    {
        public static Regex RegexIntegerStartWithZero = new Regex("^0\\d+$", RegexOptions.Compiled);

        public static string GetTypeValueXLSX(string valor)
        {
            if (string.IsNullOrEmpty(valor))
                return ">";
            string cleanvalue = valor;
            if (valor.Contains("$"))
                cleanvalue = valor.Replace("$", "");
            if (!RegexIntegerStartWithZero.IsMatch(cleanvalue))
            {
                try
                {
                    return string.Format("><v>{0}</v>", Convert.ToInt64(cleanvalue));
                }
                catch { }
                try
                {
                    return string.Format(CultureInfo.InvariantCulture, "><v>{0}</v>", Convert.ToDouble(cleanvalue));
                }
                catch { }
                try
                {
                    return string.Format(CultureInfo.InvariantCulture, "><v>{0}</v>", Convert.ToDouble(cleanvalue, CultureInfo.InvariantCulture));
                }
                catch { }
            }
            return string.Format(" t=\"inlineStr\"><is><t>{0}</t></is>", GetXMLString(valor));
        }

        public static string GetXMLString(string valor)
        {
            if (string.IsNullOrEmpty(valor))
                return "";
            try { valor = HttpUtility.HtmlDecode(valor); } catch { }

            return HttpUtility.HtmlEncode(valor
                .Replace("<br/>", "\n")
                .Replace("<br />", "\n")
                .Replace(Convert.ToChar((byte)0x1F), ' ')
                );
            /*return valor.Trim()
                .Replace("<br/>", "&#10;")
                .Replace("<br />", "&#10;")
                .Replace("\r\n", "&#10;")
                .Replace("\n", "&#10;")
                .Replace("\r", "&#10;")
                .Replace("\"", "&quot;")
                .Replace("&", "&amp;")
                .Replace("\'", "&apos;")
                .Replace("<", "&lt;")
                .Replace(">", "&gt;")
                ;*/
        }

        public static List<string> GetFileList(string parentPath)
        {
            List<string> Files = new List<string>();
            Files.AddRange(Directory.GetFiles(parentPath));
            foreach (string directory in Directory.GetDirectories(parentPath))
            {
                Files.AddRange(GetFileList(directory));
            }
            return Files;
        }

        public static void WriteString(Stream zipOutputStream, string value)
        {
            byte[] buffer = UTF8Encoding.UTF8.GetBytes(value);
            zipOutputStream.Write(buffer, 0, buffer.Length);
        }

        public static void RenderXLSX(Controller controller, ZipArchive zipArchive, string fullPath, string title, string author)
        {
            if (!fullPath.EndsWith(Path.DirectorySeparatorChar.ToString()))
                fullPath += Path.DirectorySeparatorChar;
            foreach (string fileName in GetFileList(fullPath))
            {
                if (fileName.EndsWith("sheet1.xml")) // omitimos la hoja
                    continue;

                ZipArchiveEntry zipEntry = zipArchive.CreateEntry(fileName.Replace(fullPath, ""));
                using (Stream zipStream = zipEntry.Open())
                {
                    string fileContent = File.ReadAllText(fileName)
                    .Replace("$szAuthor$", GetXMLString(author)) // core.xml
                    .Replace("$szTitle$", GetXMLString(title)) // app.xml and workbook.xml
                    ;
                    WriteString(zipStream, fileContent);
                    if (!controller.Response.IsClientConnected)
                    {
                        break;
                    }
                }
                controller.Response.Flush();
            }
            controller.Response.Flush();
        }
    }
}