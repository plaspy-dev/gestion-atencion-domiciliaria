<%@ WebHandler Language="C#" Class="importarCSV" %>

using System;
using System.Web;
using System.IO;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using SDG.Componentes;

public class importarCSV : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/html";
        context.Response.Buffer = false;
        context.Response.Write("<html><head><style>.a { color: red; }.b { color: green; } .c { font-weight: bold;color: blue;}</style></head><body>");
        context.Response.Flush();
        ConvertDirectory(context.Response, Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "entrega4"));
        context.Response.Write("</body></html>");
    }

    public bool ConvertDirectory(HttpResponse Response, string ruta)
    {
        foreach (string file in Directory.EnumerateFiles(ruta, "*.csv"))
        {
            if (!ImportarArchivo(Response, file))
                return false;
        }

        foreach (string directorio in Directory.EnumerateDirectories(ruta))
        {
            if (!ConvertDirectory(Response, directorio))
                return false;
        }
        return true;
    }

    public string FindFile(string directory, string archivo) {

        foreach (string file in Directory.EnumerateFiles(directory, "*" + archivo + "*.tif"))
        {
            return file;
        }

        string fileFound = null;
        foreach (string directorio in Directory.EnumerateDirectories(directory))
        {
            fileFound= FindFile(directorio, archivo);
            if (!string.IsNullOrEmpty(fileFound))
                break;
        }
        return fileFound;
    }

    protected bool ImportarArchivo(HttpResponse Response, string file)
    {
        List<string> campos = new List<string>();
        string debug = "";
        int id = -1;

        string directory = Path.GetDirectoryName(file);
        string subdirectory = null;
        foreach (string directorio in Directory.GetDirectories(directory)) {
            subdirectory = directorio;
            break;
        }
        bool subcarpetas = Directory.GetDirectories(subdirectory).Length != 0;

        Response.Write("<span class=c>" + file + "</span><br/>");
        Query query = new Query("digitalizacion");
        StreamReader reader = new StreamReader(file, System.Text.Encoding.UTF7);
        if (reader.Peek() < 0)
        {
            Response.Write("No se puede leer el archivo<br/>");
            return false;
        }
        string header = reader.ReadLine();
        string[] textos = header.ToLower().Split(';');
        for (int i = 0; i < textos.Length; i++)
        {
            textos[i] = textos[i].Trim();
            if (textos[i] == "fecha")
            {
                campos.Add("fecha");
            }
            else if (textos[i] == "factura")
            {
                campos.Add("factura");
            }
            else if (textos[i] == "c.c.")
            {
                campos.Add("documento");
                id = i;
            }
            else if (textos[i] == "asegura")
            {
                campos.Add("aseguradora");
            }
            else if (textos[i] == "nombre-imagen")
            {
                campos.Add("archivo");
            }
            else if (textos[i] == "total-img")
            {
                campos.Add("paginas");
            }
            else
            {
                Response.Write("No se encontro la columna '" + textos[i] + "'<br/>");
                return false;
            }
        }
        if (id == -1)
        {
            // no se encontro el id
            Response.Write("No se encontro la columna C.C.<br/>");
            return false;
        }
        if (campos.Count < 4)
        {
            Response.Write("No se encontraron columnas a modificar<br/>");
            return true;
        }

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            int nuevos = 0, actualizados = 0;
            string valor;
            int linea = 1;

            while (reader.Peek() >= 0)
            {
                header = reader.ReadLine();
                textos = header.Split(';');
                string currentID = "";
                linea++;

                // hasta aca hacemos la importacion.
                if (textos[0].Length == 0)
                    break;

                for (int i = 0; i < textos.Length && i < campos.Count; i++)
                {
                    if (i == id)
                    {                        
                        valor = textos[i].Trim().Replace(".", "").Replace(",", "");
                        if (valor.ToLower().StartsWith("rela"))
                            break;
                        currentID = conector.QueryString(string.Format("SELECT pacId FROM paciente WHERE pacDocumento={0}", Query.GetValor(valor)));

                        if (string.IsNullOrEmpty(currentID))
                        {
                            currentID = "0";
                            debug += "<span class=b>Paciente no encontrado " + Query.GetValor(valor) + " en línea " + linea + "</span><br/>";
                        }
                        query["paciente"] = currentID;
                        query["documento"] = valor;
                    }
                    else
                    {
                        valor = textos[i].Trim();
                        if (valor.Length == 0)
                        {
                            Response.Write("No se puede ingresar el valor " + i + " en blanco en la línea " + linea + "<br/>");
                            return false;
                        }
                        switch (campos[i])
                        {
                            case "fecha":
                                try
                                {
                                    valor = Query.GetMySQLDateFormat(DateTime.ParseExact(valor, "yyyyMMdd", CultureInfo.InvariantCulture));
                                }
                                catch
                                {
                                    Response.Write("La fecha no tiene el formato correcto YYYYMMDD en la línea " + linea + "<br/>");
                                    return false;
                                }
                                break;
                        }
                        query[campos[i]] = valor;
                    }
                }
                
                // tenemos que buscar el archivo de factura y el archivo del paciente

                string archivo = FindFile(subdirectory, subcarpetas ? query["documento"] : query["factura"]);
                if (string.IsNullOrEmpty(archivo))
                {
                    debug += "<span class=a>No se encontro la historia clinica del paciente con documento " + query["documento"] + "</span><br/>";
                } else {
                    archivo = archivo.Replace(subdirectory + Path.DirectorySeparatorChar, "");
                }
                
                if (subcarpetas)
                {
                    string factura = FindFile(subdirectory, query["factura"]);
                    if (string.IsNullOrEmpty(factura))
                    {
                        debug += "<span class=a>No se encontro el archivo con la factura " + query["factura"] + "</span><br/>";
                    } else {
                        factura = factura.Replace(subdirectory + Path.DirectorySeparatorChar, "");
                    }
                    query["factura_archivo"] = factura;
                }
                query["archivo"] = archivo;

                if (conector.QueryString("SELECT fecha FROM digitalizacion WHERE paciente=" + Query.GetValor(query["paciente"]) + " AND factura=" + Query.GetValor(query["factura"])).Length == 0)
                {
                    nuevos++;
                    if (conector.QueryMod(query.GetInsert()) == -1)
                    {
                        Response.Write(conector.LastError + "<br/>");
                        return false;
                    }
                } else {
                    if (conector.QueryMod(query.GetUpdate("paciente=" + Query.GetValor(query["paciente"]) + " AND factura=" + Query.GetValor(query["factura"]))) == -1)
                    {
                        Response.Write(conector.LastError + "<br/>");
                        return false;
                    }
                    actualizados++;
                    debug += "Paciente actualizado paciente " + Query.GetValor(query["documento"]) + " y factura " + Query.GetValor(query["factura"]) + " en línea " + linea + "<br/>";
                }
            }
            reader.Close();
            // conector.Commit();

            Response.Write(string.Format("<span class=c>{0} archivos, {1} Nuevos y {2} actualizados</span><br/>", nuevos + actualizados, nuevos, actualizados) + debug + "<br/>");
            return true;
        }
    }
            
    public bool IsReusable {
        get {
            return false;
        }
    }

}