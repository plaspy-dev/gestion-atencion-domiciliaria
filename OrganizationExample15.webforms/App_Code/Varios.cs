using System;
using System.Collections.Generic;
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

    public Varios()
    {    
    }

    public static void Remove(string id)
    {
        HttpRuntime.Cache.Remove("sh_" + id);
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