using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using SDG.Componentes;

/// <summary>
/// Descripción breve de servicios
/// </summary>
[WebService(Namespace = "https://org-15.example.test/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// Para permitir que se llame a este servicio web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente. 
[System.Web.Script.Services.ScriptService]
public class servicios : System.Web.Services.WebService
{
    public servicios()
    {
    }

    [WebMethod]
    public List<Miscelaneos> Empresario(string q)
    {
        List<Miscelaneos> resultset = new List<Miscelaneos>();
        Query query = new Query("empresario");
        string condicion = "";

        string[] split = q.Trim().Split(new Char[] { ' ', '\0' }, StringSplitOptions.RemoveEmptyEntries);

        condicion += "(";

        for (int i = 0; i < split.Length; i++)
        {
            if (i > 0)
                condicion += " AND ";
            condicion += String.Format(" (nombre LIKE '%{0}%' OR documento LIKE '%{0}%' OR nombres LIKE '%{0}%' OR apellidos LIKE '%{0}%')", split[i]);
        }
        condicion += ")";

        query += "id";
        query["nombre"]= "CONCAT(documento, ' - ', nombre)";

        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query(query.GetSelect(condicion + " ORDER BY nombre LIMIT 20"));
            if (reader != null)
            {
                while (reader.Read())
                {
                    resultset.Add(new Miscelaneos(reader["id"].ToString(), reader["nombre"].ToString()));
                }
            }
        }

        return resultset;
    }

    [WebMethod]
    public List<Miscelaneos> Ubicacion(string q)
    {
        List<Miscelaneos> resultset = new List<Miscelaneos>();
        Query query = new Query("ubicacion");
        string condicion = "";

        string[] split = q.Trim().Split(new Char[] { ' ', '\0' }, StringSplitOptions.RemoveEmptyEntries);

        condicion += "(";

        for (int i = 0; i < split.Length; i++)
        {
            if (i > 0)
                condicion += " AND ";
            condicion += String.Format(" nombre LIKE '%{0}%'", split[i]);
        }
        condicion += ")";

        query += "id";
        query += "nombre";

        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query(query.GetSelect(condicion + " ORDER BY nombre LIMIT 20"));
            if (reader != null)
            {
                while (reader.Read())
                {
                    resultset.Add(new Miscelaneos(reader["id"].ToString(), reader["nombre"].ToString()));
                }
            }
        }

        return resultset;
    }

    [WebMethod]
    public List<Miscelaneos> Ambulancia(string q) {

        List<Miscelaneos> resultset = new List<Miscelaneos>();
        Query query = new Query("ambulancia");
        string condicion = "";

        string[] split = q.Trim().Split(new Char[] { ' ', '\0' }, StringSplitOptions.RemoveEmptyEntries);

        condicion += "(";

        for (int i = 0; i < split.Length; i++)
        {
            if (i > 0)
                condicion += " AND ";
            condicion += String.Format(" ambulancia.placa LIKE '%{0}%'", split[i]);
        }
        condicion += ")";

        query += "ambulancia.id";
        query["nombre"]= "CONCAT(ambulancia.placa, ' - ', empresa.nombre)";

        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query(query.GetSelect(condicion + " ORDER BY placa LIMIT 20", "LEFT JOIN empresa ON (empresa.id=ambulancia.empresa)"));
            if (reader != null)
            {
                while (reader.Read())
                {
                    resultset.Add(new Miscelaneos(reader["id"].ToString(), reader["nombre"].ToString()));
                }
            }
        }

        return resultset;
    }

    [WebMethod]
    public List<Miscelaneos> Evento(string q)
    {
        List<Miscelaneos> resultset = new List<Miscelaneos>();
        Query query = new Query("evento");
        string condicion = "";

        string[] split = q.Trim().Split(new Char[] { ' ', '\0' }, StringSplitOptions.RemoveEmptyEntries);

        condicion += "(";

        for (int i = 0; i < split.Length; i++)
        {
            if (i > 0)
                condicion += " AND ";
            condicion += String.Format(" nombre LIKE '%{0}%'", split[i]);
        }
        condicion += ")";

        query += "id";
        query += "nombre";

        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query(query.GetSelect(condicion + " ORDER BY nombre LIMIT 20"));
            if (reader != null)
            {
                while (reader.Read())
                {
                    resultset.Add(new Miscelaneos(reader["id"].ToString(), reader["nombre"].ToString()));
                }
            }
        }

        return resultset;
    }

    [WebMethod]
    public List<Miscelaneos> Empresa(string q)
    {
        List<Miscelaneos> resultset = new List<Miscelaneos>();
        Query query = new Query("empresa");
        string condicion = "";

        string[] split = q.Trim().Split(new Char[] { ' ', '\0' }, StringSplitOptions.RemoveEmptyEntries);

        if (split.Length == 1)
        { // solo un dato puede ser un documento
            condicion += " nit LIKE '%" + q.Trim() + "%' OR ";
        }
        condicion += "(";

        for (int i = 0; i < split.Length; i++)
        {
            if (i > 0)
                condicion += " AND ";
            condicion += String.Format(" nombre LIKE '%{0}%'", split[i]);
        }
        condicion += ")";

        query += "id";
        query += "nit";
        query += "nombre";

        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query(query.GetSelect(condicion + " ORDER BY nombre LIMIT 20"));
            if (reader != null)
            {
                while (reader.Read())
                {
                    resultset.Add(new Miscelaneos(reader["id"].ToString(),
                        string.Format("{0} - {1}", reader["nit"], reader["nombre"])));
                }
            }
        }

        return resultset;
    }

    [WebMethod]
    public List<Miscelaneos> RH(string q) {

        List<Miscelaneos> resultset = new List<Miscelaneos>();
        Query query = new Query("rh");
        string condicion = "";

        string[] split = q.Trim().Split(new Char[] { ' ', '\0' }, StringSplitOptions.RemoveEmptyEntries);

        if (split.Length == 1)
        { // solo un dato puede ser un documento
            condicion += " documento LIKE '%" + q.Trim() + "%' OR ";
        }
        condicion += "(";

        for (int i = 0; i < split.Length; i++)
        {
            if (i > 0)
                condicion += " AND ";
            condicion += String.Format(" (nombres LIKE '%{0}%' OR apellidos LIKE '%{0}%') ", split[i]);
        }
        condicion += ")";

        query += "id";
        query += "documento";
        query += "nombres";
        query += "apellidos";

        using (CConector conector = new CConector())
        {
            MySqlDataReader reader= conector.Query(query.GetSelect(condicion + " ORDER BY apellidos,nombres LIMIT 20"));
            if (reader != null)
            {
                while (reader.Read())
                {
                    resultset.Add(new Miscelaneos(reader["id"].ToString(),
                        string.Format("{0} - {1} {2}", reader["documento"], reader["apellidos"], reader["nombres"])));
                }
            }
        }

        return resultset;
    }
}

