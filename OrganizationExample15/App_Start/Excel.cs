using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Globalization;

namespace OrganizationExample15
{
    public class Excel
    {
        [Obsolete("Usar clase GridUtils.ExportExcelXLSX", true)]
        public static bool SaveExcel(Controller controller, CUsuario user, string title, string query)
        {
            HttpRequestBase Request = controller.Request;
            HttpResponseBase Response = controller.Response;

            Request.Headers["Accept-Encoding"] = "";

            // Response.ContentEncoding = System.Text.Encoding.UTF8;// .GetEncoding("ISO-8859-1");
            Response.Headers.Add("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode(title) + ".xlsx");
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

            using (var outputStream = new PositionWrapperStream(Response.OutputStream))
            using (var zipArchive = new ZipArchive(outputStream, ZipArchiveMode.Create))
            {
                // zipOutputStream.SetLevel(3); //0-9, 9 being the highest level of compression
                RenderXLSXPage.RenderXLSX(controller, zipArchive, controller.Server.MapPath("~/xlsx/"), title, user.Nombre);

                ZipArchiveEntry zipEntry = zipArchive.CreateEntry("xl/worksheets/sheet1.xml");
                using (Stream zipStream = zipEntry.Open())
                {
                    RenderXLSXPage.WriteString(zipStream, @"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>
<worksheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"" xmlns:r=""http://schemas.openxmlformats.org/officeDocument/2006/relationships"" xmlns:mc=""http://schemas.openxmlformats.org/markup-compatibility/2006"" mc:Ignorable=""x14ac"" xmlns:x14ac=""http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"">
	<sheetData>");

                    using (CConector conector = new CConector())
                    {
                        MySqlDataReader reader = conector.Query(query);
                        if (reader != null)
                        {
                            RenderXLSXPage.WriteString(zipStream, "<row>\n");
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                RenderXLSXPage.WriteString(zipStream, string.Format("<c s=\"1\" t=\"inlineStr\"><is><t>{0}</t></is></c>", reader.GetName(i)));
                            }
                            RenderXLSXPage.WriteString(zipStream, "</row>\n");

                            while (reader.Read())
                            {
                                RenderXLSXPage.WriteString(zipStream, "<row>\n");
                                for (int i = 0; i < reader.FieldCount; i++)
                                {
                                    if (reader[i] is DateTime)
                                    {
                                        DateTime date= (DateTime)reader[i];
                                        RenderXLSXPage.WriteString(zipStream, string.Format(CultureInfo.InvariantCulture, "<c s=\"{1}\"><v>{0}</v></c>", date.ToOADate(), date.Hour==0 && date.Minute==0 && date.Second==0 ? 7 : 6));
                                    }
                                    else RenderXLSXPage.WriteString(zipStream, string.Format("<c{0}</c>", RenderXLSXPage.GetTypeValueXLSX(reader[i].ToString())));
                                }
                                RenderXLSXPage.WriteString(zipStream, "</row>\n");
                                Response.Flush();
                                if (!controller.Response.IsClientConnected)
                                    break;
                            }
                        }
                    }

                    RenderXLSXPage.WriteString(zipStream, @"</sheetData></worksheet>");
                    Response.Flush();
                    zipStream.Close();
                    return true;
                }
            }
        }
    }
}