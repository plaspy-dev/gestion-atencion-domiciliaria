using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using SDG.Componentes;

namespace OrganizationExample15.Controllers
{
    public class DebugController : BaseController
    {
        [AllowAnonymous]
        public ActionResult FlushCache()
        {
            Cache.FlushAll();
            return Content("OK");
        }

        protected async Task WriteString(Stream zipStream, string value)
        {
            byte[] buffer = UTF8Encoding.UTF8.GetBytes(value);
            await zipStream.WriteAsync(buffer, 0, buffer.Length);
        }

        public async Task<ActionResult> DumpDB()
        {
            int MaxRowsInsert = 1024;

            using (CConector conector = new CConector())
            {
                Request.Headers["Accept-Encoding"] = "";

                string fileName = Query.GetMySQLDateFormat(DateTime.Now);
                Response.Headers.Add("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode(fileName) + ".zip");
                Response.ContentType = "application/zip";

                using (var outputStream = new PositionWrapperStream(Response.OutputStream))
                using (var zipArchive = new ZipArchive(outputStream, ZipArchiveMode.Create))
                {

                    ZipArchiveEntry zipEntry = zipArchive.CreateEntry(fileName + ".sql");
                    using (Stream zipStream = zipEntry.Open())
                    {

                        List<string> tables = new List<string>();
                        var reader = conector.Query("SHOW TABLES;");
                        if (reader == null)
                            return HttpNotFound();
                        while (reader.Read())
                        {
                            tables.Add(reader[0].ToString());
                        }

                        await WriteString(zipStream, @"/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
");

                        foreach (string table in tables)
                        {
                            await WriteString(zipStream, string.Format("-- {0}{1}{1}", table, Environment.NewLine));
                            await WriteString(zipStream, string.Format("DROP TABLE IF EXISTS `{0}`;{1}", table, Environment.NewLine));

                            reader = conector.Query("SHOW CREATE TABLE {0}", table);
                            if (reader != null && reader.Read())
                                await WriteString(zipStream, string.Format("{0};{1}", reader[1], Environment.NewLine));

                            await Response.FlushAsync();

                            reader = conector.Query("SELECT * FROM {0}", table);
                            if (reader != null)
                            {
                                await WriteString(zipStream, Environment.NewLine);
                                await WriteString(zipStream, Environment.NewLine);
                                await WriteString(zipStream, string.Format("LOCK TABLES `{0}` WRITE;{1}", table, Environment.NewLine));
                                await WriteString(zipStream, string.Format("/*!40000 ALTER TABLE `{0}` DISABLE KEYS */;{1}", table, Environment.NewLine));

                                string query = string.Format("INSERT INTO `{0}` VALUES ", table);
                                /*for (int i = 0; i < reader.FieldCount; i++) {
                                    if (i != 0)
                                        query += ",";
                                    query += reader.GetName(i);
                                }*/

                                int count = 0;
                                while (reader.Read())
                                {
                                    string insertvalues = count % MaxRowsInsert != 0 ? ",(" : "(";
                                    if (count % MaxRowsInsert == 0)
                                    {
                                        if (count > 0)
                                        {
                                            await WriteString(zipStream, ";");
                                            await WriteString(zipStream, Environment.NewLine);
                                        }
                                        await WriteString(zipStream, query);
                                        await Response.FlushAsync();
                                    }
                                    for (int i = 0; i < reader.FieldCount; i++)
                                    {
                                        if (i != 0)
                                            insertvalues += ",";
                                        insertvalues += Query.GetValor(reader[i]).Replace("\n", "\\n").Replace("\r", "\\r").Replace("\t", "\\t");
                                    }
                                    insertvalues += ")";
                                    await WriteString(zipStream, insertvalues);
                                    count++;
                                    if (!Response.IsClientConnected)
                                        break;
                                }
                                if (count > 0)
                                {
                                    await WriteString(zipStream, ";");
                                    await WriteString(zipStream, Environment.NewLine);
                                }
                                await WriteString(zipStream, string.Format("/*!40000 ALTER TABLE `{0}` ENABLE KEYS */;{1}", table, Environment.NewLine));
                                await WriteString(zipStream, string.Format("UNLOCK TABLES;{1}", table, Environment.NewLine));
                                await WriteString(zipStream, Environment.NewLine);
                                await WriteString(zipStream, Environment.NewLine);
                                if (!Response.IsClientConnected)
                                    break;
                            }
                            await Response.FlushAsync();
                            if (!Response.IsClientConnected)
                                break;
                        }
                        // zipStream.Write
                        await WriteString(zipStream, @"
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
");
                        zipStream.Close();
                    }
                }
            }
            return new EmptyResult();
        }
    }
}