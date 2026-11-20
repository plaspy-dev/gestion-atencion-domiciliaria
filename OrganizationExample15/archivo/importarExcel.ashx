<%@ WebHandler Language="C#" Class="migrar" %>

using System;
using System.Web;
using System.IO;
using System.Collections.Generic;
using System.Configuration;
using SDG.Componentes;
using System.Reflection;
// using Excel= Microsoft.Office.Interop.Excel;

public class migrar : IHttpHandler {

    // Excel.Application excelApp = new Excel.Application();
    
     public void ProcessRequest (HttpContext context) {
         context.Response.ContentType = "text/html";
         context.Response.Buffer = false;
         context.Response.Write("<html><body>");
         context.Response.Flush();
         // ConvertDirectory(context.Response, Path.Combine(HomeCareVersion.FilesPath, "entrega6"));
         // ParseExcel(context.Response, @"c:\temp\archivos\entrega6\OrganizationExample15-ECOPETROL (16 myo al 31 Octubre 2014) ok\ECOPETROL con factura y Relacion por cedula =Imagenes y listado\Listado ECOPETROL cantidad Imagenes Con Factura.xlsx");
         // excelApp.Quit();
         context.Response.Write("</body></html>");
     }

     /*public bool ParseExcel(HttpResponse Response, string file)
     {
         try
         {
             Excel.Workbook workbook = excelApp.Workbooks.Open(file);
             Excel.Worksheet worksheet = (Excel.Worksheet)workbook.Sheets[1];
             Excel.Range range = worksheet.UsedRange;
             int total = range.Rows.Count;
             Response.Write("<br/>" + file + " (" + total + ") 0%");
             Response.Flush();

             using (StreamWriter stream = new StreamWriter(Path.Combine(Path.GetDirectoryName(file), Path.GetFileNameWithoutExtension(file) + ".csv")))
             {
                 bool header = true;
                 bool start = false;
                 int fecha = -1;
                 bool empty = false;
                 int currentPer = 0;
                 List<int> columnas = new List<int>();

                 for (int row = 4; row <= range.Rows.Count; row++)
                 {
                     if (header && columnas.Count > 0)
                     {
                         header = false;
                     } else if (!header && !start) {
                         start = true;
                     }
                     string linea = "";
                     for (int column = 1; column <= range.Columns.Count; column++)
                     {
                         string valor;
                         try
                         {
                             valor = ((Excel.Range)range.Cells[row, column]).Value.ToString().Trim();
                         }
                         catch
                         {
                             if (column == 1)
                             {
                                 empty = true;
                             }
                             if (column < 8)
                             {
                                 empty = false;
                                 linea = ""; // omitimos esta linea
                             }
                             break;
                         }
                         if (column == 1 && string.IsNullOrEmpty(valor))
                         {
                             empty = true;
                             break;
                         }
                         if (start)
                         {
                             if (columnas.Contains(column))
                             {
                                 if (fecha == column)
                                     valor = Query.GetMySQLDateFormat(valor).Replace("-", "");
                                 if (!string.IsNullOrEmpty(linea))
                                     linea += ";";
                                 linea += valor;
                             }
                         }
                         else if (header)
                         {
                             switch (valor)
                             {
                                 case "NOMBRE":
                                     valor = "asegura";
                                     break;
                                 case "FECHA":
                                     valor = "fecha";
                                     fecha = column;
                                     break;
                                 case "IDENTIFICACION":
                                     valor = "c.c.";
                                     break;
                                 case "NUMERO":
                                     valor = "factura";
                                     break;
                                 case "CANTIDAD":
                                     valor = "total-img";
                                     break;
                                 default:
                                     continue;
                             }
                             columnas.Add(column);
                             if (!string.IsNullOrEmpty(linea))
                                 linea += ";";
                             linea += valor;
                         }
                     }
                     if (!string.IsNullOrEmpty(linea))
                         stream.WriteLine(linea);
                     if (empty && !header)
                         break;

                     // aumentamos el porcentaje
                     if (((100 * row / total) % 10) == 0)
                     {
                         if (currentPer == (100 * row / total))
                             continue;
                         currentPer = (100 * row / total);
                         Response.Write("..." + currentPer.ToString() + "%");
                         Response.Flush();
                     }
                 }
             }
             workbook.Close(false, Missing.Value, Missing.Value);
             Response.Write(" -> OK\n");
         } catch {
             return false;
         }
         // convertimos
         return true;
     }
    
     public void ConvertDirectory(HttpResponse Response, string ruta) {

         foreach (string file in Directory.EnumerateFiles(ruta, "*.xlsx")) {
             ParseExcel(Response, file);
         }
         foreach (string directorio in Directory.EnumerateDirectories(ruta))
         {
             ConvertDirectory(Response, directorio);
         }
     }*/

    public bool IsReusable {
        get {
            return false;
        }
    }
}