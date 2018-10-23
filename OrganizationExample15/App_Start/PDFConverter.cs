using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Drawing.Printing;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using SDG.Componentes;

/// <summary>
/// Summary description for PDFConverter
/// </summary>
public class PDFConverter
{
    public static Regex RegexTagSrc = new Regex("(href|src)=\\\"\\/(.*?)\\\"", RegexOptions.Compiled | RegexOptions.IgnoreCase);

    // PDF Converter
    private static void ErrorDataHandler(object sendingProcess, DataReceivedEventArgs errLine)
    {
        if (errLine.Data == null)
            return;
        Logs.WriteLog(errLine.Data);
    }

    private static void OutputDataHandler(object sendingProcess, DataReceivedEventArgs outputLine)
    {
        if (outputLine.Data == null)
            return;
        Logs.WriteLog(outputLine.Data);
    }

    public static int Execute(string ExeName, string arguments)
    {
        // Console.WriteLine(ExeName + " " + arguments);
        // return 0;
        // Prepare the process to run
        ProcessStartInfo start = new ProcessStartInfo();
        // Enter in the command line arguments, everything you would enter after the executable name itself
        start.Arguments = arguments;
        // Enter the executable to run, including the complete path
        start.FileName = ExeName;
        start.UseShellExecute = false;
        start.RedirectStandardOutput = true;
        start.RedirectStandardError = true;
        // Do you want to show a console window?
        start.WindowStyle = ProcessWindowStyle.Hidden;
        start.CreateNoWindow = true;

        int exitCode = -1;

        // Run the external process & wait for it to finish
        using (Process proc = Process.Start(start))
        {
            proc.ErrorDataReceived += ErrorDataHandler;
            proc.OutputDataReceived += OutputDataHandler;

            proc.BeginErrorReadLine();
            proc.BeginOutputReadLine();

            proc.WaitForExit();

            // Retrieve the app's exit code
            exitCode = proc.ExitCode;
        }
        if (exitCode != 0)
        {
            // Logs.WriteLog(DateTime.Now + " [PDF]: Error generando PDF");
        }
        return exitCode;
    }

    public static Byte[] ConvertToPDFExe(string htmlContent, string PageSize= "Letter")
    {

        string htmlFile = Path.GetTempPath() + Guid.NewGuid().ToString();
        string pdfFile = htmlFile + ".pdf";
        htmlFile += ".html";

        try
        {
            File.WriteAllText(htmlFile, htmlContent);

            Execute(ConfigurationManager.AppSettings["PDF:GeneratorProgram"]
                , string.Format("-q --page-size {0} \"{1}\" \"{2}\"", PageSize, htmlFile, pdfFile));

            return File.ReadAllBytes(pdfFile);
        } finally {
            File.Delete(htmlFile);
            File.Delete(pdfFile);
        }
    }

    public static ActionResult RenderPDF(Controller controller, string title, string html)
    {
        HttpResponseBase Response = controller.Response;

        Response.ContentType = "application/pdf";
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.AddHeader("content-disposition", "attachment;filename=" + HttpUtility.UrlPathEncode("Cuenta") + ".pdf");

        string serverpath = HomeCareVersion.GetURLLocalhost() + "/";

        html = RegexTagSrc.Replace(html, string.Format("$1=\"{0}$2\"", serverpath));

        Response.Flush();
        Response.BinaryWrite(PDFConverter.ConvertToPDFExe(html));
        Response.Flush();

        return new EmptyResult();
    }

    public static ActionResult RenderPDF(Controller controller, string title, string viewPath, object model=null, bool partial=false) {

        return RenderPDF(controller, title, PDFConverter.RenderViewToString(controller.ControllerContext, viewPath, model, partial));
    }

    public static string RenderViewToString(ControllerContext context,
                                    string viewPath,
                                    object model = null,
                                    bool partial = false)
    {
        // first find the ViewEngine for this view
        ViewEngineResult viewEngineResult = null;
        if (partial)
            viewEngineResult = ViewEngines.Engines.FindPartialView(context, viewPath);
        else
            viewEngineResult = ViewEngines.Engines.FindView(context, viewPath, null);

        if (viewEngineResult == null)
            throw new FileNotFoundException("View cannot be found.");

        // get the view and attach the model to view data
        var view = viewEngineResult.View;
        context.Controller.ViewData.Model = model;

        string result = null;

        using (var sw = new StringWriter())
        {
            var ctx = new ViewContext(context, view,
                                        context.Controller.ViewData,
                                        context.Controller.TempData,
                                        sw);
            view.Render(ctx, sw);
            result = sw.ToString();
        }

        return result;
    }
}