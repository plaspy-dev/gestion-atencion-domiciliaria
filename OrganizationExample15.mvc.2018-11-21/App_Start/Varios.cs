using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.Caching;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public class Varios
{
    public string Id { get; set; }
    public string Nombre { get; set; }
    public string Descripcion { get; set; }
    public string szReservado { get; set; }
    public int tipo { get; set; }
    public int? parametro1 { get; set; }
    public int? estado { get; set; }

    public enum Tipo {
        [Description("Apoyo Terapeutico/Estado cuenta")]
        EstadoCuenta=178
    }

    public Varios()
    {    
    }

    public static void Remove(Tipo tipo) {
        HttpRuntime.Cache.Remove("shl_" + (int)tipo);
    }

    public static void Remove(string id)
    {
        HttpRuntime.Cache.Remove("sh_" + id);
    }

    public static List<Varios> Get(Tipo tipo) {

        List<Varios> lista = HttpRuntime.Cache.Get("shl_" + (int)tipo) as List<Varios>;
        if (lista == null) {
            lista= new List<Varios>();
            using (CConector conector = new CConector())
            {
                Query query = new Query("varios");
                query += "id";
                query += "nombre";
                query += "descripcion";
                query += "szReservado";
                query += "tipo";
                query += "parametro1";
                query += "estado";

                MySqlDataReader reader = conector.Query(query.GetSelect("tipo=" + Query.GetValor((int)tipo)));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        Varios item = new Varios();
                        item.Nombre = reader["nombre"].ToString();
                        item.Id = reader["id"].ToString();
                        item.Descripcion = reader["descripcion"].ToString();
                        item.szReservado = reader["szReservado"].ToString();
                        if (reader["parametro1"] != DBNull.Value)
                            item.parametro1 = Convert.ToInt32(reader["parametro1"]);
                        if (reader["estado"] != DBNull.Value)
                            item.estado = Convert.ToInt32(reader["parametro1"]);
                        item.tipo = Convert.ToInt32(reader["tipo"]);
                        lista.Add(item);
                    }
                    HttpRuntime.Cache.Insert("shl_" + (int)tipo, lista);
                }
            }
        }
        return lista;
    }

    public static Varios Get(string id)
    {
        if (string.IsNullOrEmpty(id))
            return new Varios();
        Varios item = (Varios)HttpRuntime.Cache.Get("sh_" + id);
        if (item == null)
        {
            item = new Varios();
            using (CConector conector = new CConector())
            {
                Query query = new Query("varios");
                query += "id";
                query += "nombre";
                query += "descripcion";
                query += "szReservado";
                query += "tipo";
                query += "parametro1";
                query += "estado";

                MySqlDataReader reader = conector.Query(query.GetSelect("id=" + Query.GetValor(id)));
                if (reader != null && reader.Read())
                {
                    item.Nombre = reader["nombre"].ToString();
                    item.Id = reader["id"].ToString();
                    item.Descripcion = reader["descripcion"].ToString();
                    item.szReservado = reader["szReservado"].ToString();
                    if (reader["parametro1"] != DBNull.Value)
                        item.parametro1 = Convert.ToInt32(reader["parametro1"]);
                    if (reader["estado"] != DBNull.Value)
                        item.estado = Convert.ToInt32(reader["parametro1"]);
                    item.tipo = Convert.ToInt32(reader["tipo"]);
                }
            }
            HttpRuntime.Cache.Insert("sh_" + id, item);
        }
        return item;
    }
}