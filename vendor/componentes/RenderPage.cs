using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SDG.Componentes
{
    public class RenderPage
    {
        public static bool AreParentsVisible(Control control)
        {
            while (control.Parent != null)
            {
                if (!control.Visible)
                    return false;
                control = control.Parent;
            }
            return control.Visible;
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

        public static bool RenderControl(HttpResponse Response, ControlCollection controles, string ID, bool clases, bool xml)
        {
            foreach (char character in ID) {
                if (!char.IsLetterOrDigit(character)) // no es una variable
                    return false;
            }
            Control control = Utilidades.FindControlForId(controles, ID);
            if (control == null)
                return false;
            if (AreParentsVisible(control))
            {
                if (control.GetType() == typeof(TextBox))
                {
                    Response.Write(xml ? GetXMLString(((TextBox)control).Text) : HttpUtility.HtmlEncode(((TextBox)control).Text));
                }
                else if (control.GetType() == typeof(CheckBox))
                {
                    Response.Write(((CheckBox)control).Checked ? "X" : "_");
                }
                else if (control.GetType() == typeof(Label))
                {
                    Response.Write(xml ? GetXMLString(((Label)control).Text) : HttpUtility.HtmlEncode(((Label)control).Text));
                }
                else if (control.GetType() == typeof(Literal))
                {
                    Response.Write(xml ? GetXMLString(((Literal)control).Text) : ((Literal)control).Text);
                } else if (control.GetType() == typeof(HyperLink)) {
                    Response.Write(xml ? GetXMLString(((HyperLink)control).Text) : HttpUtility.HtmlEncode(((HyperLink)control).Text));
                } else if (control.GetType() == typeof(DropDownList)) {
                    try
                    {
                        if (((DropDownList)control).SelectedItem == null)
                            ((DropDownList)control).DataBind(); // solo para depuracion
                    }
                    catch { }
                    if (((DropDownList)control).SelectedItem != null)
                        Response.Write(xml ? GetXMLString(((DropDownList)control).SelectedItem.Text) : HttpUtility.HtmlEncode(((DropDownList)control).SelectedItem.Text));
                }
                else if (control.GetType() == typeof(HiddenField))
                {
                    Response.Write(xml ? GetXMLString(((HiddenField)control).Value) : ((HiddenField)control).Value);
                }
                else if (control.GetType() == typeof(GridView))
                {
                    GridView grid = (GridView)control;
                    try
                    {
                        if (!string.IsNullOrEmpty(grid.DataSourceID))
                        {
                            Control sql = Utilidades.FindControlForId(controles, grid.DataSourceID);
                            if (sql != null && sql is SqlDataSource)
                            {  // lo encontrtamos
                                if (xml)
                                    GridUtils.RenderGridXML(Response, grid, (SqlDataSource)sql);
                                else GridUtils.RenderGrid(Response, grid, (SqlDataSource)sql, clases);
                                grid = null;
                            }
                        }
                    }
                    catch { }
                    if (grid != null)
                    {
                        if (xml)
                            GridUtils.RenderGridXML(Response, grid);
                        else GridUtils.RenderGrid(Response, grid, "", clases);
                    }
                }
                else if (control.GetType() == typeof(CheckBoxList))
                {
                    Response.Write(Utilidades.RenderCheckBoxList((CheckBoxList)control));
                }
                else if (control.GetType() == typeof(ListBox))
                {
                    string valor = "";
                    ListBox list = ((ListBox)control);
                    for (int j = 0; j < list.Items.Count; j++)
                    {
                        if (list.Items[j].Selected)
                        {
                            if (valor.Length > 0)
                                valor += ", ";
                            valor += HttpUtility.HtmlEncode(list.Items[j].Text);
                        }
                    }
                    Response.Write(xml ? GetXMLString(valor) : valor);
                }
                else if (control.GetType() == typeof(RadioButtonList))
                {
                    RadioButtonList radio = (RadioButtonList)control;
                    if (radio.SelectedItem != null)
                    {
                        Response.Write(xml ? GetXMLString(radio.SelectedItem.Text) : HttpUtility.HtmlEncode(radio.SelectedItem.Text));
                    }
                }
            }
            return true;
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

        public static void RenderXLSX(HttpResponseBase Response, ZipArchive zipArchive, string fullPath, string title, string author)
        {
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
                    if (!Response.IsClientConnected)
                    {
                        break;
                    }
                }
                Response.Flush();
            }
            Response.Flush();
        }

        public static void RenderXLSX(HttpResponse Response, ZipArchive zipArchive, string fullPath, string title, string author)
        {
            foreach (string fileName in GetFileList(fullPath))
            {
                if (fileName.EndsWith("sheet1.xml")) // omitimos la hoja
                    continue;

                ZipArchiveEntry zipEntry = zipArchive.CreateEntry(fileName.Replace(fullPath, ""));
                using (Stream zipStream = zipEntry.Open()) {
                    string fileContent = File.ReadAllText(fileName)
                    .Replace("$szAuthor$", GetXMLString(author)) // core.xml
                    .Replace("$szTitle$", GetXMLString(title)) // app.xml and workbook.xml
                    ;
                    WriteString(zipStream, fileContent);
                    if (!Response.IsClientConnected)
                    {
                        break;
                    }
                }
                Response.Flush();
            }
            Response.Flush();
        }

        public static void RenderXLSX(HttpResponse Response, ControlCollection controles, string fullPath, string contenido, string title, string author) {

            byte[] buffer = new byte[4096];

            Response.Clear();
            Response.Buffer = false;
            Response.BufferOutput = false;

            using (var outputStream = new PositionWrapperStream(Response.OutputStream))
            using (var zipArchive = new ZipArchive(outputStream, ZipArchiveMode.Create))
            {
                // zipOutputStream.SetLevel(3); //0-9, 9 being the highest level of compression
                RenderXLSX(Response, zipArchive, fullPath, title, author);
                ZipArchiveEntry zipEntry = zipArchive.CreateEntry("xl/worksheets/sheet1.xml");
                using (Stream zipStream = zipEntry.Open())
                {
                    RenderXLSX(Response, zipStream, controles, contenido);
                    // zipOutputStream.Write(buffer, 0, count);
                    Response.Flush();
                    zipStream.Close();
                }
            }

            Response.Flush();
            Response.End();
        }

        public static bool RenderControlXLSX(HttpResponse HttpResponse, Stream zipOutputStream, ControlCollection controles, string ID)
        {
            foreach (char character in ID)
            {
                if (!char.IsLetterOrDigit(character)) // no es una variable
                    return false;
            }
            Control control = Utilidades.FindControlForId(controles, ID);
            if (control == null)
                return false;
            if (AreParentsVisible(control))
            {
                if (control.GetType() == typeof(TextBox))
                {
                    WriteString(zipOutputStream, GetXMLString(((TextBox)control).Text));
                }
                else if (control.GetType() == typeof(CheckBox))
                {
                    WriteString(zipOutputStream, ((CheckBox)control).Checked ? "X" : "_");
                }
                else if (control.GetType() == typeof(Label))
                {
                    WriteString(zipOutputStream, GetXMLString(((Label)control).Text));
                }
                else if (control.GetType() == typeof(Literal))
                {
                    WriteString(zipOutputStream, GetXMLString(((Literal)control).Text));
                }
                else if (control.GetType() == typeof(DropDownList))
                {
                    try
                    {
                        if (((DropDownList)control).SelectedItem == null)
                            ((DropDownList)control).DataBind(); // solo para depuracion
                    }
                    catch { }
                    if (((DropDownList)control).SelectedItem != null)
                        WriteString(zipOutputStream,GetXMLString(((DropDownList)control).SelectedItem.Text));
                }
                else if (control.GetType() == typeof(HiddenField))
                {
                    WriteString(zipOutputStream,GetXMLString(((HiddenField)control).Value));
                }
                else if (control.GetType() == typeof(GridView))
                {
                    GridView grid = (GridView)control;
                    try
                    {
                        if (!string.IsNullOrEmpty(grid.DataSourceID))
                        {
                            Control sql = Utilidades.FindControlForId(controles, grid.DataSourceID);
                            if (sql != null && sql is SqlDataSource)
                            {  // lo encontrtamos
                                GridUtils.RenderGridXLSX(HttpResponse, zipOutputStream, grid, (SqlDataSource)sql);
                                grid = null;
                            }
                        }
                    }
                    catch { }
                    if (grid != null)
                    {
                        GridUtils.RenderGridXLSX(HttpResponse, zipOutputStream, grid);
                    }
                }
                else if (control.GetType() == typeof(CheckBoxList))
                {
                    // Response.Write(Utilidades.RenderCheckBoxList((CheckBoxList)control));
                }
                else if (control.GetType() == typeof(ListBox))
                {
                    string valor = "";
                    ListBox list = ((ListBox)control);
                    for (int j = 0; j < list.Items.Count; j++)
                    {
                        if (list.Items[j].Selected)
                        {
                            if (valor.Length > 0)
                                valor += ", ";
                            valor += HttpUtility.HtmlEncode(list.Items[j].Text);
                        }
                    }
                    WriteString(zipOutputStream,GetXMLString(valor));
                }
                else if (control.GetType() == typeof(RadioButtonList))
                {
                    RadioButtonList radio = (RadioButtonList)control;
                    if (radio.SelectedItem != null)
                    {
                        WriteString(zipOutputStream,GetXMLString(radio.SelectedItem.Text));
                    }
                }
            }
            return true;
        }

        public static void WriteString(Stream zipOutputStream, string value) {

            byte[] buffer = UTF8Encoding.UTF8.GetBytes(value);
            zipOutputStream.Write(buffer, 0, buffer.Length);
        }

        public static void RenderXLSX(HttpResponse HttpResponse, Stream zipOutputStream, ControlCollection controles, string contenido) {

            int currentIndex = -1;
            int lastIndex = 0;
            bool startwithMoneySymbol = false;

            while ((currentIndex = contenido.IndexOf("$", ++currentIndex)) != -1)
            {
                WriteString(zipOutputStream, contenido.Substring(lastIndex, currentIndex - lastIndex));
                HttpResponse.Flush();
                if (!HttpResponse.IsClientConnected)
                {
                    HttpResponse.End();
                    return;
                }
                lastIndex = ++currentIndex;
                currentIndex = contenido.IndexOf("$", currentIndex);
                if (currentIndex == -1)
                { // se acabo del documento
                    break;
                }
                startwithMoneySymbol = false;

                string variable = contenido.Substring(lastIndex, currentIndex - lastIndex);
                lastIndex = currentIndex + 1;

                if (RenderControlXLSX(HttpResponse, zipOutputStream, controles, variable))
                {
                }
                else
                {
                    startwithMoneySymbol = true;
                    currentIndex--;
                    lastIndex--;
                    WriteString(zipOutputStream,"$" + variable);
                }

                HttpResponse.Flush();
                if (!HttpResponse.IsClientConnected)
                {
                    HttpResponse.End();
                    return;
                }
            }
            if (startwithMoneySymbol)
                WriteString(zipOutputStream,"$");
            WriteString(zipOutputStream,contenido.Substring(lastIndex));
            HttpResponse.Flush();
            HttpResponse.End();
        }

        public static void RenderXML(HttpResponse Response, ControlCollection controles, string contenido) {
            Render(Response, controles, contenido, true, true);
        }

        public static void Render(HttpResponse Response, ControlCollection controles, string contenido)
        {
            Render(Response, controles, contenido, true, false);
        }

        public static void Render(HttpResponse Response, ControlCollection controles, string contenido, bool clases, bool xml)
        {
            Response.Clear();
            Response.Buffer = false;
            Response.BufferOutput = false;

            int currentIndex = -1;
            int lastIndex = 0;
            bool startwithMoneySymbol = false;

            while ((currentIndex = contenido.IndexOf("$", ++currentIndex)) != -1)
            {
                Response.Write(contenido.Substring(lastIndex, currentIndex - lastIndex));
                Response.Flush();
                if (!Response.IsClientConnected)
                {
                    Response.End();
                    return;
                }
                lastIndex = ++currentIndex;
                currentIndex = contenido.IndexOf("$", currentIndex);
                if (currentIndex == -1)
                { // se acabo del documento
                    break;
                }
                startwithMoneySymbol = false;

                string variable = contenido.Substring(lastIndex, currentIndex - lastIndex);
                lastIndex = currentIndex + 1;

                if (RenderControl(Response, controles, variable, clases, xml)) {
                } else {
                    startwithMoneySymbol = true;
                    currentIndex--;
                    lastIndex--;
                    Response.Write("$");
                    Response.Write(variable);
                }

                Response.Flush();
                if (!Response.IsClientConnected)
                {
                    Response.End();
                    return;
                }
            }
            if(startwithMoneySymbol)
                Response.Write("$");
            Response.Write(contenido.Substring(lastIndex));
            Response.Flush();
            Response.End();
        }

        public static void Render(HttpResponse Response, object values, StringBuilderEx contenido) {

            Response.Clear();
            Response.Buffer = false;
            Response.BufferOutput = false;
            Type type= values.GetType();

            int currentIndex = -1;
            int lastIndex = 0;
            bool startwithMoneySymbol = false;

            while ((currentIndex = contenido.IndexOf("$", ++currentIndex)) != -1)
            {
                Response.Write(contenido.Substring(lastIndex, currentIndex - lastIndex));
                Response.Flush();
                if (!Response.IsClientConnected)
                {
                    Response.End();
                    return;
                }
                lastIndex = ++currentIndex;
                currentIndex = contenido.IndexOf("$", currentIndex);
                if (currentIndex == -1)
                { // se acabo del documento
                    break;
                }
                startwithMoneySymbol = false;

                string variable = contenido.Substring(lastIndex, currentIndex - lastIndex);
                lastIndex = currentIndex + 1;

                try
                {
                    object value= type.GetProperty(variable).GetValue(values);
                    if(value!=null)
                        Response.Write(HttpUtility.HtmlEncode(value.ToString()));
                } catch {
                    startwithMoneySymbol = true;
                    currentIndex--;
                    lastIndex--;
                    Response.Write("$");
                    Response.Write(variable);
                }
                
                Response.Flush();
                if (!Response.IsClientConnected)
                {
                    Response.End();
                    return;
                }
            }
            if (startwithMoneySymbol)
                Response.Write("$");
            Response.Write(contenido.Substring(lastIndex));
            Response.Flush();
            Response.End();
        }
    }
}
