using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SDG.Componentes;

namespace OrganizationExample15
{
    public class FileStorage
    {
        public const int MaxFileLengthKB = 1024;
        public static List<string> ValidFiles = new List<string>() { ".jpg", ".jpeg", ".zip", ".pdf" };
        public static List<string> ValidDocumentFiles = new List<string>() { ".pdf" };
        public static List<string> ValidImages = new List<string>() { ".jpg", ".jpeg" };
        public static List<string> ValidImagesPDF = new List<string>() { ".jpg", ".jpeg", ".pdf" };

        public const string ValidMimeImagesPDF = "image/jpeg,application/pdf";
        public const string ValidMimeImages = "image/jpeg";

        public static string FileStoragePath = ConfigurationManager.AppSettings["pathFiles"];
        public enum Types
        {
            Temporal,
            Cuentas,
            firmas,
            sellos,
            RUT,
            valoracion // valoracion clinica de heridas
        }

        private static IDictionary<string, string> _mappings = new Dictionary<string, string>(StringComparer.InvariantCultureIgnoreCase) {

        #region Big freaking list of mime types
        // combination of values from Windows 7 Registry and 
        // from C:\Windows\System32\inetsrv\config\applicationHost.config
        // some added, including .7z and .dat
        {".323", "text/h323"},
        {".3g2", "video/3gpp2"},
        {".3gp", "video/3gpp"},
        {".3gp2", "video/3gpp2"},
        {".3gpp", "video/3gpp"},
        {".7z", "application/x-7z-compressed"},
        {".aa", "audio/audible"},
        {".AAC", "audio/aac"},
        {".aaf", "application/octet-stream"},
        {".aax", "audio/vnd.audible.aax"},
        {".ac3", "audio/ac3"},
        {".aca", "application/octet-stream"},
        {".accda", "application/msaccess.addin"},
        {".accdb", "application/msaccess"},
        {".accdc", "application/msaccess.cab"},
        {".accde", "application/msaccess"},
        {".accdr", "application/msaccess.runtime"},
        {".accdt", "application/msaccess"},
        {".accdw", "application/msaccess.webapplication"},
        {".accft", "application/msaccess.ftemplate"},
        {".acx", "application/internet-property-stream"},
        {".AddIn", "text/xml"},
        {".ade", "application/msaccess"},
        {".adobebridge", "application/x-bridge-url"},
        {".adp", "application/msaccess"},
        {".ADT", "audio/vnd.dlna.adts"},
        {".ADTS", "audio/aac"},
        {".afm", "application/octet-stream"},
        {".ai", "application/postscript"},
        {".aif", "audio/x-aiff"},
        {".aifc", "audio/aiff"},
        {".aiff", "audio/aiff"},
        {".air", "application/vnd.adobe.air-application-installer-package+zip"},
        {".amc", "application/x-mpeg"},
        {".application", "application/x-ms-application"},
        {".art", "image/x-jg"},
        {".asa", "application/xml"},
        {".asax", "application/xml"},
        {".ascx", "application/xml"},
        {".asd", "application/octet-stream"},
        {".asf", "video/x-ms-asf"},
        {".ashx", "application/xml"},
        {".asi", "application/octet-stream"},
        {".asm", "text/plain"},
        {".asmx", "application/xml"},
        {".aspx", "application/xml"},
        {".asr", "video/x-ms-asf"},
        {".asx", "video/x-ms-asf"},
        {".atom", "application/atom+xml"},
        {".au", "audio/basic"},
        {".avi", "video/x-msvideo"},
        {".axs", "application/olescript"},
        {".bas", "text/plain"},
        {".bcpio", "application/x-bcpio"},
        {".bin", "application/octet-stream"},
        {".bmp", "image/bmp"},
        {".c", "text/plain"},
        {".cab", "application/octet-stream"},
        {".caf", "audio/x-caf"},
        {".calx", "application/vnd.ms-office.calx"},
        {".cat", "application/vnd.ms-pki.seccat"},
        {".cc", "text/plain"},
        {".cd", "text/plain"},
        {".cdda", "audio/aiff"},
        {".cdf", "application/x-cdf"},
        {".cer", "application/x-x509-ca-cert"},
        {".chm", "application/octet-stream"},
        {".class", "application/x-java-applet"},
        {".clp", "application/x-msclip"},
        {".cmx", "image/x-cmx"},
        {".cnf", "text/plain"},
        {".cod", "image/cis-cod"},
        {".config", "application/xml"},
        {".contact", "text/x-ms-contact"},
        {".coverage", "application/xml"},
        {".cpio", "application/x-cpio"},
        {".cpp", "text/plain"},
        {".crd", "application/x-mscardfile"},
        {".crl", "application/pkix-crl"},
        {".crt", "application/x-x509-ca-cert"},
        {".cs", "text/plain"},
        {".csdproj", "text/plain"},
        {".csh", "application/x-csh"},
        {".csproj", "text/plain"},
        {".css", "text/css"},
        {".csv", "text/csv"},
        {".cur", "application/octet-stream"},
        {".cxx", "text/plain"},
        {".dat", "application/octet-stream"},
        {".datasource", "application/xml"},
        {".dbproj", "text/plain"},
        {".dcr", "application/x-director"},
        {".def", "text/plain"},
        {".deploy", "application/octet-stream"},
        {".der", "application/x-x509-ca-cert"},
        {".dgml", "application/xml"},
        {".dib", "image/bmp"},
        {".dif", "video/x-dv"},
        {".dir", "application/x-director"},
        {".disco", "text/xml"},
        {".dll", "application/x-msdownload"},
        {".dll.config", "text/xml"},
        {".dlm", "text/dlm"},
        {".doc", "application/msword"},
        {".docm", "application/vnd.ms-word.document.macroEnabled.12"},
        {".docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"},
        {".dot", "application/msword"},
        {".dotm", "application/vnd.ms-word.template.macroEnabled.12"},
        {".dotx", "application/vnd.openxmlformats-officedocument.wordprocessingml.template"},
        {".dsp", "application/octet-stream"},
        {".dsw", "text/plain"},
        {".dtd", "text/xml"},
        {".dtsConfig", "text/xml"},
        {".dv", "video/x-dv"},
        {".dvi", "application/x-dvi"},
        {".dwf", "drawing/x-dwf"},
        {".dwp", "application/octet-stream"},
        {".dxr", "application/x-director"},
        {".eml", "message/rfc822"},
        {".emz", "application/octet-stream"},
        {".eot", "application/octet-stream"},
        {".eps", "application/postscript"},
        {".etl", "application/etl"},
        {".etx", "text/x-setext"},
        {".evy", "application/envoy"},
        {".exe", "application/octet-stream"},
        {".exe.config", "text/xml"},
        {".fdf", "application/vnd.fdf"},
        {".fif", "application/fractals"},
        {".filters", "Application/xml"},
        {".fla", "application/octet-stream"},
        {".flr", "x-world/x-vrml"},
        {".flv", "video/x-flv"},
        {".fsscript", "application/fsharp-script"},
        {".fsx", "application/fsharp-script"},
        {".generictest", "application/xml"},
        {".gif", "image/gif"},
        {".group", "text/x-ms-group"},
        {".gsm", "audio/x-gsm"},
        {".gtar", "application/x-gtar"},
        {".gz", "application/x-gzip"},
        {".h", "text/plain"},
        {".hdf", "application/x-hdf"},
        {".hdml", "text/x-hdml"},
        {".hhc", "application/x-oleobject"},
        {".hhk", "application/octet-stream"},
        {".hhp", "application/octet-stream"},
        {".hlp", "application/winhlp"},
        {".hpp", "text/plain"},
        {".hqx", "application/mac-binhex40"},
        {".hta", "application/hta"},
        {".htc", "text/x-component"},
        {".htm", "text/html"},
        {".html", "text/html"},
        {".htt", "text/webviewhtml"},
        {".hxa", "application/xml"},
        {".hxc", "application/xml"},
        {".hxd", "application/octet-stream"},
        {".hxe", "application/xml"},
        {".hxf", "application/xml"},
        {".hxh", "application/octet-stream"},
        {".hxi", "application/octet-stream"},
        {".hxk", "application/xml"},
        {".hxq", "application/octet-stream"},
        {".hxr", "application/octet-stream"},
        {".hxs", "application/octet-stream"},
        {".hxt", "text/html"},
        {".hxv", "application/xml"},
        {".hxw", "application/octet-stream"},
        {".hxx", "text/plain"},
        {".i", "text/plain"},
        {".ico", "image/x-icon"},
        {".ics", "application/octet-stream"},
        {".idl", "text/plain"},
        {".ief", "image/ief"},
        {".iii", "application/x-iphone"},
        {".inc", "text/plain"},
        {".inf", "application/octet-stream"},
        {".inl", "text/plain"},
        {".ins", "application/x-internet-signup"},
        {".ipa", "application/x-itunes-ipa"},
        {".ipg", "application/x-itunes-ipg"},
        {".ipproj", "text/plain"},
        {".ipsw", "application/x-itunes-ipsw"},
        {".iqy", "text/x-ms-iqy"},
        {".isp", "application/x-internet-signup"},
        {".ite", "application/x-itunes-ite"},
        {".itlp", "application/x-itunes-itlp"},
        {".itms", "application/x-itunes-itms"},
        {".itpc", "application/x-itunes-itpc"},
        {".IVF", "video/x-ivf"},
        {".jar", "application/java-archive"},
        {".java", "application/octet-stream"},
        {".jck", "application/liquidmotion"},
        {".jcz", "application/liquidmotion"},
        {".jfif", "image/pjpeg"},
        {".jnlp", "application/x-java-jnlp-file"},
        {".jpb", "application/octet-stream"},
        {".jpe", "image/jpeg"},
        {".jpeg", "image/jpeg"},
        {".jpg", "image/jpeg"},
        {".js", "application/x-javascript"},
        {".json", "application/json"},
        {".jsx", "text/jscript"},
        {".jsxbin", "text/plain"},
        {".latex", "application/x-latex"},
        {".library-ms", "application/windows-library+xml"},
        {".lit", "application/x-ms-reader"},
        {".loadtest", "application/xml"},
        {".lpk", "application/octet-stream"},
        {".lsf", "video/x-la-asf"},
        {".lst", "text/plain"},
        {".lsx", "video/x-la-asf"},
        {".lzh", "application/octet-stream"},
        {".m13", "application/x-msmediaview"},
        {".m14", "application/x-msmediaview"},
        {".m1v", "video/mpeg"},
        {".m2t", "video/vnd.dlna.mpeg-tts"},
        {".m2ts", "video/vnd.dlna.mpeg-tts"},
        {".m2v", "video/mpeg"},
        {".m3u", "audio/x-mpegurl"},
        {".m3u8", "audio/x-mpegurl"},
        {".m4a", "audio/m4a"},
        {".m4b", "audio/m4b"},
        {".m4p", "audio/m4p"},
        {".m4r", "audio/x-m4r"},
        {".m4v", "video/x-m4v"},
        {".mac", "image/x-macpaint"},
        {".mak", "text/plain"},
        {".man", "application/x-troff-man"},
        {".manifest", "application/x-ms-manifest"},
        {".map", "text/plain"},
        {".master", "application/xml"},
        {".mda", "application/msaccess"},
        {".mdb", "application/x-msaccess"},
        {".mde", "application/msaccess"},
        {".mdp", "application/octet-stream"},
        {".me", "application/x-troff-me"},
        {".mfp", "application/x-shockwave-flash"},
        {".mht", "message/rfc822"},
        {".mhtml", "message/rfc822"},
        {".mid", "audio/mid"},
        {".midi", "audio/mid"},
        {".mix", "application/octet-stream"},
        {".mk", "text/plain"},
        {".mmf", "application/x-smaf"},
        {".mno", "text/xml"},
        {".mny", "application/x-msmoney"},
        {".mod", "video/mpeg"},
        {".mov", "video/quicktime"},
        {".movie", "video/x-sgi-movie"},
        {".mp2", "video/mpeg"},
        {".mp2v", "video/mpeg"},
        {".mp3", "audio/mpeg"},
        {".mp4", "video/mp4"},
        {".mp4v", "video/mp4"},
        {".mpa", "video/mpeg"},
        {".mpe", "video/mpeg"},
        {".mpeg", "video/mpeg"},
        {".mpf", "application/vnd.ms-mediapackage"},
        {".mpg", "video/mpeg"},
        {".mpp", "application/vnd.ms-project"},
        {".mpv2", "video/mpeg"},
        {".mqv", "video/quicktime"},
        {".ms", "application/x-troff-ms"},
        {".msi", "application/octet-stream"},
        {".mso", "application/octet-stream"},
        {".mts", "video/vnd.dlna.mpeg-tts"},
        {".mtx", "application/xml"},
        {".mvb", "application/x-msmediaview"},
        {".mvc", "application/x-miva-compiled"},
        {".mxp", "application/x-mmxp"},
        {".nc", "application/x-netcdf"},
        {".nsc", "video/x-ms-asf"},
        {".nws", "message/rfc822"},
        {".ocx", "application/octet-stream"},
        {".oda", "application/oda"},
        {".odc", "text/x-ms-odc"},
        {".odh", "text/plain"},
        {".odl", "text/plain"},
        {".odp", "application/vnd.oasis.opendocument.presentation"},
        {".ods", "application/oleobject"},
        {".odt", "application/vnd.oasis.opendocument.text"},
        {".one", "application/onenote"},
        {".onea", "application/onenote"},
        {".onepkg", "application/onenote"},
        {".onetmp", "application/onenote"},
        {".onetoc", "application/onenote"},
        {".onetoc2", "application/onenote"},
        {".orderedtest", "application/xml"},
        {".osdx", "application/opensearchdescription+xml"},
        {".p10", "application/pkcs10"},
        {".p12", "application/x-pkcs12"},
        {".p7b", "application/x-pkcs7-certificates"},
        {".p7c", "application/pkcs7-mime"},
        {".p7m", "application/pkcs7-mime"},
        {".p7r", "application/x-pkcs7-certreqresp"},
        {".p7s", "application/pkcs7-signature"},
        {".pbm", "image/x-portable-bitmap"},
        {".pcast", "application/x-podcast"},
        {".pct", "image/pict"},
        {".pcx", "application/octet-stream"},
        {".pcz", "application/octet-stream"},
        {".pdf", "application/pdf"},
        {".pfb", "application/octet-stream"},
        {".pfm", "application/octet-stream"},
        {".pfx", "application/x-pkcs12"},
        {".pgm", "image/x-portable-graymap"},
        {".pic", "image/pict"},
        {".pict", "image/pict"},
        {".pkgdef", "text/plain"},
        {".pkgundef", "text/plain"},
        {".pko", "application/vnd.ms-pki.pko"},
        {".pls", "audio/scpls"},
        {".pma", "application/x-perfmon"},
        {".pmc", "application/x-perfmon"},
        {".pml", "application/x-perfmon"},
        {".pmr", "application/x-perfmon"},
        {".pmw", "application/x-perfmon"},
        {".png", "image/png"},
        {".pnm", "image/x-portable-anymap"},
        {".pnt", "image/x-macpaint"},
        {".pntg", "image/x-macpaint"},
        {".pnz", "image/png"},
        {".pot", "application/vnd.ms-powerpoint"},
        {".potm", "application/vnd.ms-powerpoint.template.macroEnabled.12"},
        {".potx", "application/vnd.openxmlformats-officedocument.presentationml.template"},
        {".ppa", "application/vnd.ms-powerpoint"},
        {".ppam", "application/vnd.ms-powerpoint.addin.macroEnabled.12"},
        {".ppm", "image/x-portable-pixmap"},
        {".pps", "application/vnd.ms-powerpoint"},
        {".ppsm", "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"},
        {".ppsx", "application/vnd.openxmlformats-officedocument.presentationml.slideshow"},
        {".ppt", "application/vnd.ms-powerpoint"},
        {".pptm", "application/vnd.ms-powerpoint.presentation.macroEnabled.12"},
        {".pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation"},
        {".prf", "application/pics-rules"},
        {".prm", "application/octet-stream"},
        {".prx", "application/octet-stream"},
        {".ps", "application/postscript"},
        {".psc1", "application/PowerShell"},
        {".psd", "application/octet-stream"},
        {".psess", "application/xml"},
        {".psm", "application/octet-stream"},
        {".psp", "application/octet-stream"},
        {".pub", "application/x-mspublisher"},
        {".pwz", "application/vnd.ms-powerpoint"},
        {".qht", "text/x-html-insertion"},
        {".qhtm", "text/x-html-insertion"},
        {".qt", "video/quicktime"},
        {".qti", "image/x-quicktime"},
        {".qtif", "image/x-quicktime"},
        {".qtl", "application/x-quicktimeplayer"},
        {".qxd", "application/octet-stream"},
        {".ra", "audio/x-pn-realaudio"},
        {".ram", "audio/x-pn-realaudio"},
        {".rar", "application/octet-stream"},
        {".ras", "image/x-cmu-raster"},
        {".rat", "application/rat-file"},
        {".rc", "text/plain"},
        {".rc2", "text/plain"},
        {".rct", "text/plain"},
        {".rdlc", "application/xml"},
        {".resx", "application/xml"},
        {".rf", "image/vnd.rn-realflash"},
        {".rgb", "image/x-rgb"},
        {".rgs", "text/plain"},
        {".rm", "application/vnd.rn-realmedia"},
        {".rmi", "audio/mid"},
        {".rmp", "application/vnd.rn-rn_music_package"},
        {".roff", "application/x-troff"},
        {".rpm", "audio/x-pn-realaudio-plugin"},
        {".rqy", "text/x-ms-rqy"},
        {".rtf", "application/rtf"},
        {".rtx", "text/richtext"},
        {".ruleset", "application/xml"},
        {".s", "text/plain"},
        {".safariextz", "application/x-safari-safariextz"},
        {".scd", "application/x-msschedule"},
        {".sct", "text/scriptlet"},
        {".sd2", "audio/x-sd2"},
        {".sdp", "application/sdp"},
        {".sea", "application/octet-stream"},
        {".searchConnector-ms", "application/windows-search-connector+xml"},
        {".setpay", "application/set-payment-initiation"},
        {".setreg", "application/set-registration-initiation"},
        {".settings", "application/xml"},
        {".sgimb", "application/x-sgimb"},
        {".sgml", "text/sgml"},
        {".sh", "application/x-sh"},
        {".shar", "application/x-shar"},
        {".shtml", "text/html"},
        {".sit", "application/x-stuffit"},
        {".sitemap", "application/xml"},
        {".skin", "application/xml"},
        {".sldm", "application/vnd.ms-powerpoint.slide.macroEnabled.12"},
        {".sldx", "application/vnd.openxmlformats-officedocument.presentationml.slide"},
        {".slk", "application/vnd.ms-excel"},
        {".sln", "text/plain"},
        {".slupkg-ms", "application/x-ms-license"},
        {".smd", "audio/x-smd"},
        {".smi", "application/octet-stream"},
        {".smx", "audio/x-smd"},
        {".smz", "audio/x-smd"},
        {".snd", "audio/basic"},
        {".snippet", "application/xml"},
        {".snp", "application/octet-stream"},
        {".sol", "text/plain"},
        {".sor", "text/plain"},
        {".spc", "application/x-pkcs7-certificates"},
        {".spl", "application/futuresplash"},
        {".src", "application/x-wais-source"},
        {".srf", "text/plain"},
        {".SSISDeploymentManifest", "text/xml"},
        {".ssm", "application/streamingmedia"},
        {".sst", "application/vnd.ms-pki.certstore"},
        {".stl", "application/vnd.ms-pki.stl"},
        {".sv4cpio", "application/x-sv4cpio"},
        {".sv4crc", "application/x-sv4crc"},
        {".svc", "application/xml"},
        {".swf", "application/x-shockwave-flash"},
        {".t", "application/x-troff"},
        {".tar", "application/x-tar"},
        {".tcl", "application/x-tcl"},
        {".testrunconfig", "application/xml"},
        {".testsettings", "application/xml"},
        {".tex", "application/x-tex"},
        {".texi", "application/x-texinfo"},
        {".texinfo", "application/x-texinfo"},
        {".tgz", "application/x-compressed"},
        {".thmx", "application/vnd.ms-officetheme"},
        {".thn", "application/octet-stream"},
        {".tif", "image/tiff"},
        {".tiff", "image/tiff"},
        {".tlh", "text/plain"},
        {".tli", "text/plain"},
        {".toc", "application/octet-stream"},
        {".tr", "application/x-troff"},
        {".trm", "application/x-msterminal"},
        {".trx", "application/xml"},
        {".ts", "video/vnd.dlna.mpeg-tts"},
        {".tsv", "text/tab-separated-values"},
        {".ttf", "application/octet-stream"},
        {".tts", "video/vnd.dlna.mpeg-tts"},
        {".txt", "text/plain"},
        {".u32", "application/octet-stream"},
        {".uls", "text/iuls"},
        {".user", "text/plain"},
        {".ustar", "application/x-ustar"},
        {".vb", "text/plain"},
        {".vbdproj", "text/plain"},
        {".vbk", "video/mpeg"},
        {".vbproj", "text/plain"},
        {".vbs", "text/vbscript"},
        {".vcf", "text/x-vcard"},
        {".vcproj", "Application/xml"},
        {".vcs", "text/plain"},
        {".vcxproj", "Application/xml"},
        {".vddproj", "text/plain"},
        {".vdp", "text/plain"},
        {".vdproj", "text/plain"},
        {".vdx", "application/vnd.ms-visio.viewer"},
        {".vml", "text/xml"},
        {".vscontent", "application/xml"},
        {".vsct", "text/xml"},
        {".vsd", "application/vnd.visio"},
        {".vsi", "application/ms-vsi"},
        {".vsix", "application/vsix"},
        {".vsixlangpack", "text/xml"},
        {".vsixmanifest", "text/xml"},
        {".vsmdi", "application/xml"},
        {".vspscc", "text/plain"},
        {".vss", "application/vnd.visio"},
        {".vsscc", "text/plain"},
        {".vssettings", "text/xml"},
        {".vssscc", "text/plain"},
        {".vst", "application/vnd.visio"},
        {".vstemplate", "text/xml"},
        {".vsto", "application/x-ms-vsto"},
        {".vsw", "application/vnd.visio"},
        {".vsx", "application/vnd.visio"},
        {".vtx", "application/vnd.visio"},
        {".wav", "audio/wav"},
        {".wave", "audio/wav"},
        {".wax", "audio/x-ms-wax"},
        {".wbk", "application/msword"},
        {".wbmp", "image/vnd.wap.wbmp"},
        {".wcm", "application/vnd.ms-works"},
        {".wdb", "application/vnd.ms-works"},
        {".wdp", "image/vnd.ms-photo"},
        {".webarchive", "application/x-safari-webarchive"},
        {".webtest", "application/xml"},
        {".wiq", "application/xml"},
        {".wiz", "application/msword"},
        {".wks", "application/vnd.ms-works"},
        {".WLMP", "application/wlmoviemaker"},
        {".wlpginstall", "application/x-wlpg-detect"},
        {".wlpginstall3", "application/x-wlpg3-detect"},
        {".wm", "video/x-ms-wm"},
        {".wma", "audio/x-ms-wma"},
        {".wmd", "application/x-ms-wmd"},
        {".wmf", "application/x-msmetafile"},
        {".wml", "text/vnd.wap.wml"},
        {".wmlc", "application/vnd.wap.wmlc"},
        {".wmls", "text/vnd.wap.wmlscript"},
        {".wmlsc", "application/vnd.wap.wmlscriptc"},
        {".wmp", "video/x-ms-wmp"},
        {".wmv", "video/x-ms-wmv"},
        {".wmx", "video/x-ms-wmx"},
        {".wmz", "application/x-ms-wmz"},
        {".wpl", "application/vnd.ms-wpl"},
        {".wps", "application/vnd.ms-works"},
        {".wri", "application/x-mswrite"},
        {".wrl", "x-world/x-vrml"},
        {".wrz", "x-world/x-vrml"},
        {".wsc", "text/scriptlet"},
        {".wsdl", "text/xml"},
        {".wvx", "video/x-ms-wvx"},
        {".x", "application/directx"},
        {".xaf", "x-world/x-vrml"},
        {".xaml", "application/xaml+xml"},
        {".xap", "application/x-silverlight-app"},
        {".xbap", "application/x-ms-xbap"},
        {".xbm", "image/x-xbitmap"},
        {".xdr", "text/plain"},
        {".xht", "application/xhtml+xml"},
        {".xhtml", "application/xhtml+xml"},
        {".xla", "application/vnd.ms-excel"},
        {".xlam", "application/vnd.ms-excel.addin.macroEnabled.12"},
        {".xlc", "application/vnd.ms-excel"},
        {".xld", "application/vnd.ms-excel"},
        {".xlk", "application/vnd.ms-excel"},
        {".xll", "application/vnd.ms-excel"},
        {".xlm", "application/vnd.ms-excel"},
        {".xls", "application/vnd.ms-excel"},
        {".xlsb", "application/vnd.ms-excel.sheet.binary.macroEnabled.12"},
        {".xlsm", "application/vnd.ms-excel.sheet.macroEnabled.12"},
        {".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"},
        {".xlt", "application/vnd.ms-excel"},
        {".xltm", "application/vnd.ms-excel.template.macroEnabled.12"},
        {".xltx", "application/vnd.openxmlformats-officedocument.spreadsheetml.template"},
        {".xlw", "application/vnd.ms-excel"},
        {".xml", "text/xml"},
        {".xmta", "application/xml"},
        {".xof", "x-world/x-vrml"},
        {".XOML", "text/plain"},
        {".xpm", "image/x-xpixmap"},
        {".xps", "application/vnd.ms-xpsdocument"},
        {".xrm-ms", "text/xml"},
        {".xsc", "application/xml"},
        {".xsd", "text/xml"},
        {".xsf", "text/xml"},
        {".xsl", "text/xml"},
        {".xslt", "text/xml"},
        {".xsn", "application/octet-stream"},
        {".xss", "application/xml"},
        {".xtp", "application/octet-stream"},
        {".xwd", "image/x-xwindowdump"},
        {".z", "application/x-compress"},
        {".zip", "application/x-zip-compressed"},
        #endregion

        };

        public static bool IsImage(string fileName)
        {
            string extension = Path.GetExtension(fileName);
            return extension == ".jpg" || extension == ".jpeg";
        }

        public static string GetURLPath(Types type, string fileName) {
            return GetURLPath(type, null, fileName);
        }

        public static string AddParams(string path, string _params) {
            if (!string.IsNullOrEmpty(_params)) {
                int index = path.IndexOf("?");
                path += (index == -1 ? "?" : "&") + _params;
            }
            return path;
        }

        public static string GetURLPath(Types type, string folderPath, string fileName, string _params = null)
        {
            if (!string.IsNullOrEmpty(folderPath) && !folderPath.EndsWith("/"))
                folderPath += "/";
            string path = string.Format("~/Files/{0}/{1}{2}", type, folderPath, fileName);
            DateTime? lastwrite = LastWriteTime(type, Path.Combine(folderPath, fileName));
            if (lastwrite != null)
            {
                path += string.Format("?v={0:yyMMddhhmmss}", lastwrite);
                if (!string.IsNullOrEmpty(_params))
                {
                    path += "&" + _params;
                }
            } else {
                return "#";
            } /*else if (!string.IsNullOrEmpty(_params)) {
                path += "?" + _params;
            }*/
            return path;
        }

        public static string GetPublicKey(string type, string fileName)
        {
            string word = string.Format("{0}?{1}?{2}", type, DateTime.Now.ToShortDateString(), fileName)
                .ToLower()
                .Replace("1", "l")
                .Replace("0", "O")
                .Replace("4", "a")
                .Replace("3", "E")
                .Replace("2", "Z")
                .Replace("5", "s")
                .Replace("7", "t")
                .Replace("x", "c")
                .Replace("j", "J")
                .Replace("x", "c")
                .Replace("p", "P")
                ;
            return Crypt.GetMD5(word);
        }

        public static string GetPublicURLPath(Types type, string fileName, string _params = null)
        {
            string path = string.Format("~/PFiles/{0}/{1}/{2}", type, GetPublicKey(type.ToString(), fileName), fileName);
            DateTime? lastwrite = LastWriteTime(type, fileName);
            if (lastwrite != null)
            {
                path += string.Format("?v={0:yyMMddhhmmss}", lastwrite);
                if (!string.IsNullOrEmpty(_params))
                {
                    path += "&" + _params;
                }
            } else {
                return "#";
            }
            return path;
        }

        public static string GetIcon(string fileName)
        {
            string icon = "fa-file-o";
            string extension = Path.GetExtension(fileName);
            switch (extension)
            {
                case ".jpg":
                case ".jpeg":
                    icon = "fa-file-photo-o";
                    break;
                case ".pdf":
                    icon = "fa-file-pdf-o";
                    break;
                case ".zip":
                    icon = "fa-file-archive-o";
                    break;
                case ".txt":
                    icon = "fa-file-text-o";
                    break;
            }
            return icon;
        }

        public static string GetContentType(string fileName)
        {
            string extension = Path.GetExtension(fileName);
            string mime;
            return _mappings.TryGetValue(extension, out mime) ? mime : "application/octet-stream";
        }

        public static Stream GetFileStream(Types type, string fileName)
        {
            string filepath = GetFilePath(type, fileName);
            if (!File.Exists(filepath))
                return null;
            return new FileStream(filepath, FileMode.Open);
        }

        public static DateTime? LastWriteTime(Types type, string fileName)
        {
            string filepath = GetFilePath(type, fileName);
            if (!File.Exists(filepath))
                return null;
            return File.GetLastWriteTime(filepath);
        }

        public static string GetFileName(Types type, string preifxFileName, params string []path) {

            string directorypath= Path.Combine(FileStoragePath, type.ToString().ToLower());
            if (path?.Length > 0) {
                foreach (string p in path) {
                    directorypath = Path.Combine(directorypath, p);
                }
            }

            if (Directory.Exists(directorypath)) {

                foreach (string file in Directory.EnumerateFiles(directorypath, preifxFileName + "*")) {

                    return Path.GetFileName(file);
                }
            }
            
            return null;
        }

        public static string GetFilePath(Types type, string fileName)
        {
            if(string.IsNullOrEmpty(fileName))
                return Path.Combine(FileStoragePath, type.ToString().ToLower());
            return Path.Combine(FileStoragePath, type.ToString().ToLower(), fileName);
        }

        public static bool CleanTempFiles(CConector conector) {

            string files = conector.QueryString("SELECT GROUP_CONCAT(archivo) FROM archivos_temporales WHERE fecha<NOW()-INTERVAL 1 DAY");
            foreach (string file in (files ?? "").Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)) {
                DeleteTempFile(conector, file);
            }
            return true;
        }

        public static bool MoveTempFile(CConector conector, Types typedestination, string filename, string destinationfilename, params string[] path) {

            return CopyTempFile(conector, typedestination, filename, destinationfilename, path) && DeleteTempFile(conector, filename);
        }

        public static bool DeleteTempFile(CConector conector, string filename)
        {
            string filepath = GetFilePath(Types.Temporal, filename);
            if (File.Exists(filepath))
                File.Delete(filepath);
            return conector.QueryMod("DELETE FROM archivos_temporales WHERE archivo={0}", false, Query.GetValor(filename)) != -1;
        }

        public static bool CopyTempFile(CConector conector, Types typedestination, string filename, string destinationfilename, params string[] path) {

            string filepath = GetFilePath(Types.Temporal, filename);
            if (!File.Exists(filepath))
                return false;

            string fullpath = null;
            if (path?.Length > 0) {
                fullpath = string.Join("/", path);
            }
            fullpath = GetFilePath(typedestination, fullpath);
            if (!Directory.Exists(fullpath))
                Directory.CreateDirectory(fullpath);

            if (destinationfilename == null) { // consultamos la base de datos
                destinationfilename = conector.QueryString("SELECT original FROM archivos_temporales WHERE archivo={0}", Query.GetValor(filename));
                if (string.IsNullOrEmpty(destinationfilename))
                    return false;
            }

            string newfilepath = Path.Combine(fullpath, destinationfilename);
            if (File.Exists(newfilepath))
                File.Delete(newfilepath);
            File.Copy(filepath, newfilepath);
            return true;
        }

        public static bool MoveFile(Types type, string pathName, string fileName, string newPathName, string newFileName)
        {
            string filepath = GetFilePath(type, pathName);
            filepath = Path.Combine(filepath, fileName);
            if (!File.Exists(filepath))
                return false;

            string newfilepath = GetFilePath(type, newPathName);
            if (!Directory.Exists(newfilepath))
                Directory.CreateDirectory(newfilepath);
            newfilepath = Path.Combine(newfilepath, newFileName);

            if (File.Exists(newfilepath))
                File.Delete(newfilepath);
            File.Move(filepath, newfilepath);
            return true;
        }

        public static bool MoveFile(Types type, string pathName, string fileName, string newFileName) {

            return MoveFile(type, pathName, fileName, pathName, newFileName);
        }

        public static bool MoveFile(Types type, string fileName, string newFileName)
        {
            return MoveFile(type, null, fileName, null, newFileName);
        }

        public static bool RemoveFile(Types type, string fileName, params string[] filepart)
        {
            string filepath = GetFilePath(type, null);
            if (filepart != null)
            {
                foreach (string part in filepart) {
                    filepath= Path.Combine(filepath, part);
                }
            }
            filepath = Path.Combine(filepath, fileName);
            if (File.Exists(filepath))
                File.Delete(filepath);
            return true;
        }

        public static bool RemoveFiles(Types type, string searchPattern)
        {

            string filepath = Path.Combine(FileStoragePath, type.ToString().ToLower());
            foreach (string file in Directory.GetFiles(filepath, searchPattern))
            {
                File.Delete(file);
            }
            return true;
        }

        public static List<string> ListFiles(Types type, params string[] paths) {
            List<string> files = new List<string>();
            string filepath = Path.Combine(FileStoragePath, type.ToString().ToLower());
            if (paths != null)
            {
                foreach (string path in paths)
                {
                    filepath = Path.Combine(filepath, path);
                }
            }
            if (Directory.Exists(filepath))
            {
                foreach (string file in Directory.EnumerateFiles(filepath))
                {
                    files.Add(Path.GetFileName(file));
                }
            }
            return files;
        }

        public static string GetSafeFileName(string fullPath) {

            int count = 1;

            string fileNameOnly = Path.GetFileNameWithoutExtension(fullPath);
            string extension = Path.GetExtension(fullPath);
            string path = Path.GetDirectoryName(fullPath);
            string newFullPath = fullPath;

            while (File.Exists(newFullPath))
            {
                string tempFileName = string.Format("{0}-{1}", fileNameOnly, count++);
                newFullPath = Path.Combine(path, tempFileName + extension);
            }

            return newFullPath;
        }

        public static string SaveFile(Types type, HttpPostedFileBase file, bool replaceIfExists=false, string filename = null, params string[] paths)
        {
            if (file == null || file.ContentLength == 0)
                return null;
            string filepath = Path.Combine(FileStoragePath, type.ToString().ToLower());
            if (!Directory.Exists(filepath))
                Directory.CreateDirectory(filepath);
            if (type == Types.Temporal)
            {
                filename = Guid.NewGuid().ToString();
            } else if (paths != null) {
                foreach (string path in paths) {
                    filepath = Path.Combine(filepath, path);
                    if (!Directory.Exists(filepath))
                        Directory.CreateDirectory(filepath);
                }
            }
            if (filename == null)
                filename = file.FileName;
            else if (!filename.ToLower().EndsWith(Path.GetExtension(file.FileName).ToLower()))
                filename = filename + Path.GetExtension(file.FileName).ToLower();
            filepath = Path.Combine(filepath, filename);
            if (File.Exists(filepath))
            {
                if(replaceIfExists)
                    File.Delete(filepath);
                else filepath = GetSafeFileName(filepath);
            }
            using (var stream = new FileStream(filepath, FileMode.Create))
            {
                file.InputStream.CopyTo(stream);
            }
            return Path.GetFileName(filepath);
        }

        public static bool ResponseWriteImage(Controller context, Stream streamimage, string filename)
        {
            try
            {
                int width = 0;
                int height = 0;
                int maxwidth = 0;
                int maxheight = 0;

                int.TryParse(context.Request.QueryString["mw"], out maxwidth);
                int.TryParse(context.Request.QueryString["mh"], out maxheight);
                int.TryParse(context.Request.QueryString["h"], out height);
                int.TryParse(context.Request.QueryString["w"], out width);

                if (maxheight != 0 || maxwidth != 0 || width != 0 && height != 0)
                {
                    using (Image imgPhoto = Image.FromStream(streamimage))
                    {
                        return ResponseWriteImage(context, imgPhoto, filename, width, height, maxwidth, maxheight);
                    }
                }
            }
            catch (Exception ex)
            {
                Logs.Write("{0}: {1}", context.Request.Path, ex.ToString());
            }
            return false;
        }

        public static bool ResponseWriteImage(Controller context, Image imgPhoto, string filename, int width, int height, int maxwidth, int maxheight)
        {
            if (width == 0)
                width = imgPhoto.Width;
            if (height == 0)
                height = imgPhoto.Height;

            if (maxwidth != 0)
            {
                if (maxwidth < width)
                {
                    height = maxwidth * height / width;
                    width = maxwidth;
                }
            }
            if (maxheight != 0)
            {
                if (maxheight < height)
                {
                    width = maxheight * width / height;
                    height = maxheight;
                }
            }
            if (height != 0 && width == 0)
                width = maxheight * width / height;
            else if (width != 0 && height == 0)
                height = maxwidth * height / width;
            if (width != 0 && height != 0 && (width != imgPhoto.Width || imgPhoto.Height != height))
            {
                using (Image tumb = imgPhoto.GetThumbnailImage(width, height, null, IntPtr.Zero))
                {
                    {
                        switch (Path.GetExtension(filename).ToLower())
                        {
                            case ".jpg":
                            case ".jpeg":
                                tumb.Save(context.Response.OutputStream, ImageFormat.Jpeg);
                                break;
                            case ".png":
                                tumb.Save(context.Response.OutputStream, ImageFormat.Png);
                                break;
                            case ".bmp":
                                tumb.Save(context.Response.OutputStream, ImageFormat.Bmp);
                                break;
                            case ".gif":
                                tumb.Save(context.Response.OutputStream, ImageFormat.Gif);
                                break;
                            default:
                                return false;
                        }
                        return true;
                    }
                }
            }
            return false;
        }

        public static bool WriteStream(Controller context, Stream stream)
        {

            stream.Position = 0;
            context.Response.Headers.Add(@"Content-Length", stream.Length.ToString());
            // context.Response.ContentLength = stream.Length;
            byte[] buffer = new byte[1024];
            int read;
            while ((read = stream.Read(buffer, 0, buffer.Length)) > 0)
            {
                if (!context.Response.IsClientConnected)
                    break;
                context.Response.BinaryWrite(buffer);
                context.Response.Flush();
            }
            return true;
        }




        public static ActionResult GetActionResult(Controller controller, string type, string filename, string key, CUsuario user)
        {
            HttpRequestBase Request = controller.Request;
            HttpResponseBase Response = controller.Response;

            FileStorage.Types types = (FileStorage.Types)Enum.Parse(typeof(FileStorage.Types), type, true);
            if (string.IsNullOrEmpty(key))
            {
                switch (types)
                {
                    case Types.Temporal:
                        break;
                    case Types.Cuentas:
                        if (!user.CanAccess("~/Terapeutico/Cuentas"))
                        {
                            return new HttpNotFoundResult();
                        }
                        break;
                    case Types.valoracion:
                        if (!user.CanAccess("~/ClinicaHeridas/Valoracion")) {
                            return new HttpNotFoundResult();
                        }
                        break;
                }
            }
            else
            {
                if (GetPublicKey(type, filename) != key)
                {
                    System.Threading.Thread.Sleep(3000);
                    return new HttpNotFoundResult();
                }
            }
            DateTime? lastwrite = FileStorage.LastWriteTime(types, filename);
            if (lastwrite == null)
                return new HttpNotFoundResult();

            if (!String.IsNullOrEmpty(Request.Headers["If-Modified-Since"]))
            {
                if (Request.Headers["If-Modified-Since"] == lastwrite.Value.ToUniversalTime().ToString("r"))
                {
                    Response.StatusCode = 304;
                    // Response.StatusDescription = "Not Modified";
                    return new EmptyResult();
                }
            }

            try
            {
                using (Stream stream = FileStorage.GetFileStream(types, filename))
                {
                    if (stream == null)
                        return new HttpNotFoundResult();

                    Response.ContentType = FileStorage.GetContentType(filename); // buscamos el logo jpg
                    Response.Headers.Add("Last-Modified", lastwrite.Value.ToUniversalTime().ToString("r"));
                    string display = Request.QueryString["d"] == "i" ? "inline" : "attachment";
                    Response.Headers.Add("Content-Disposition", display + "; filename=" + HttpUtility.UrlPathEncode(filename));

                    if (FileStorage.IsImage(filename) && FileStorage.ResponseWriteImage(controller, stream, filename))
                    {
                    }
                    else
                    {
                        FileStorage.WriteStream(controller, stream);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Threading.Thread.Sleep(3000);
                return new HttpNotFoundResult();
            }
            return new EmptyResult();
        }


        public static Bitmap CropSign(Bitmap firma)
        {
            int whites = 0;
            int blacks = 0;
            int initialline = 0;
            int finalline = 0;
            int initialrow = 0;
            int finalrow = 0;
            int lastwhite = 0;

            for (int x = 0; x < firma.Width; x++)
            {
                bool hasblacks = false;
                for (int y = 0; y < firma.Height; y++)
                {
                    Color color = firma.GetPixel(x, y);
                    if (color.R > 150 && color.B > 150 && color.G > 150)
                    {
                        whites++;
                    }
                    else
                    {
                        hasblacks = true;
                        blacks++;
                    }
                }
                if (hasblacks)
                {
                    if (initialrow == 0)
                    {
                        initialrow = x - 1;
                    }
                    else
                    {
                        if (x - finalrow > 5)
                            lastwhite = finalrow;
                        finalrow = x + 1;
                    }
                }
                else if (x - initialrow < 10)
                {
                    initialrow = 0;
                    lastwhite = 0;
                    finalrow = 0;
                }
                else if (lastwhite > 0 && x - finalrow < 10)
                {
                    finalrow = lastwhite;
                }
            }

            double percentage = (double)blacks / whites;
            if (percentage > 0.005 && percentage < 0.10)
            { // si la cantidad de negros en la imagen es menor al 1% la rechazamos o mayor al 10%

                for (int y = 0; y < firma.Height; y++)
                {
                    bool hasblacks = false;
                    for (int x = 0; x < firma.Width; x++)
                    {
                        Color color = firma.GetPixel(x, y);
                        if (color.R > 150 && color.B > 150 && color.G > 150)
                        {
                            /*if (color.R > 240 && color.B > 240 && color.G > 240)
                                firma.SetPixel(x, y, Color.White);*/
                        }
                        else
                        {
                            hasblacks = true;
                        }
                    }
                    if (hasblacks)
                    {
                        if (initialline == 0)
                        {
                            initialline = y - 1;
                        }
                        else
                        {
                            if (y - finalline > 5)
                                lastwhite = finalline;
                            finalline = y + 1;
                        }
                    }
                    else if (y - initialline < 10)
                    {
                        initialline = 0;
                        lastwhite = 0;
                        finalline = 0;
                    }
                    else if (lastwhite > 0 && y - finalline < 10)
                    {
                        finalline = lastwhite;
                    }
                }

                if (finalline == 0 || finalline > firma.Height)
                    finalline = firma.Height;
                if (finalrow == 0 || finalrow > firma.Width)
                    finalrow = firma.Width;
                if (initialline < 0)
                    initialline = 0;
                if (initialrow < 0)
                    initialrow = 0;

                return firma.Clone(new Rectangle(initialrow, initialline, finalrow - initialrow, finalline - initialline), firma.PixelFormat);
            }
            return firma.Clone(new Rectangle(0, 0, firma.Width, firma.Height), firma.PixelFormat);
        }

    }
}