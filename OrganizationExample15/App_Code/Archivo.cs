using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.Componentes;

/// <summary>
/// Summary description for Archivo
/// </summary>
public class Archivo
{
	public Archivo() {}

    private static string GetVariable(string nombre, string valor) {
        if (string.IsNullOrEmpty(valor))
            return "";
        return "&" + nombre + "=" + valor;
    }

    public static string GetURL(string tipo, string id, string nombre = null, string paciente = null, string hid = null, string numero = null, string temporal = null, bool adjunto = true)
    {

        string url = "~/archivo/imagen.ashx?t=" + tipo;

        url += GetVariable("p", paciente);
        url += GetVariable("i", id);
        url += GetVariable("n", nombre);
        url += GetVariable("hi", hid);
        url += GetVariable("x", numero);
        url += GetVariable("d", temporal);
        if (adjunto)
            url += GetVariable("a", "1");

        return url;
    }

    public static string GetFileName(string tipo, string id, string nombre = null, string paciente=null, string hid = null, string numero = null, string temporal = null) {

        string archivo = "";
        switch (tipo) { 
            case "v":
                tipo = "valoracion";
                break;
            case "e":
                tipo = "evolucion";
                break;
            case "r":
                tipo = "rh";
                break;
            case "p":
                tipo = "paciente";
                break;
            case "q":
                tipo = "pqr";
                break;
        }
        
        archivo = Path.Combine(HomeCareVersion.FilesPath, tipo);
        if (temporal == "True")
        {
            archivo = Path.Combine(archivo, "temp");
            archivo = Path.Combine(archivo, paciente);
        } else if(!string.IsNullOrEmpty(id))
            archivo = Path.Combine(archivo, id);
        if (!string.IsNullOrEmpty(hid))
            archivo = Path.Combine(archivo, hid);
        if (!string.IsNullOrEmpty(numero)) {
            try
            {
                int posicion = Convert.ToInt32(numero);
                foreach (string file in Directory.GetFiles(archivo))
                {
                    posicion--;
                    if (posicion == 0)
                    {
                        archivo = file;
                        break;
                    }
                }
            } catch { //no existe el directorio
                return null;
            }
        } else if (!string.IsNullOrEmpty(nombre)) {
            archivo = Path.Combine(archivo, nombre);
        }

        return archivo;
    }


    public static string GetLocalhost()
    {
        string url = "http://localhost";
        if (HttpContext.Current.Request.Url.Port != 80)
            url += ":" + HttpContext.Current.Request.Url.Port;
        return url + "/";
    }

    public static string GetHistoryFromCode(string code) {

        string funcionario = null;
        string fecha = null;
        return GetHistoryFromCode(code, out funcionario, out fecha);
    }

    public static string GetHistoryFromCode(string code, out string funcionario, out string fecha) {

        funcionario = null;
        fecha = null;
        string url = "";
        Query query = new Query("");

        switch (code.ToLower()[0])
        {
            case 'i':
                query.TableName = "ingreso_paciente";
                url = "~/paciente/ingreso.aspx?pid={0}&userloginvalidate=1&pdf=1";
                break;
            case 'e':
                query.TableName = "evolucion_paciente";
                url = "~/paciente/evolucion.aspx?pid={0}&evolid={1}&userloginvalidate=1&pdf=1";
                break;
            default:
                return null;
        }

        query += "id";
        query += "paciente";
        query += "medico";
        query += "fecha";

        using (CConector conector = new CConector())
        {
            string condicionfecha = "fecha>NOW()-INTERVAL 7 DAY AND ";
            // condicionfecha = ""; // quitar tambien en share history
            MySqlDataReader reader = conector.Query(query.GetSelect(condicionfecha + "codigo=" + Query.GetValor(code) + " ORDER BY id DESC"));

            if (reader != null && reader.Read())
            {

                string id = reader["id"].ToString();
                string paciente = reader["paciente"].ToString();
                fecha = reader["fecha"].ToString();
                Funcionario info= Funcionario.GetFuncionario(reader["medico"].ToString());
                funcionario = info.Nombres;

                string fileName = Path.GetTempFileName();
                try
                {
                    using (WebClient client = new WebClient())
                    {
                        client.DownloadFile(GetLocalhost() + VirtualPathUtility.ToAbsolute(string.Format(url, paciente, id)), fileName);
                        return fileName;
                    }
                }
                catch (Exception ex)
                {
                    Logs.Write(url + "\n" + ex.ToString());
                }
            }
        }
        return null;
    }
}