using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de Version
/// </summary>
public class HomeCareVersion
{
    public const string Number="1.85";
    public const int VERSION_FILES = 0;

    public static string CssPath(string file)
    {
        return VirtualPathUtility.ToAbsolute(string.Format("~/css{0}/{1}", VERSION_FILES, file));
    }

    public static string JSPath(string file)
    {
        return VirtualPathUtility.ToAbsolute(string.Format("~/js{0}/{1}", VERSION_FILES, file));
    }
}
