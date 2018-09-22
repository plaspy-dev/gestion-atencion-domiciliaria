using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Drawing.Printing;
using System.IO;
using System.Linq;
using System.Web;
using SDG.Componentes;

/// <summary>
/// Summary description for PDFConverter
/// </summary>
public class PDFConverter
{
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
}