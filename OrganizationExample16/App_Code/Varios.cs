using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.OrganizationExample16;
using SDG.Componentes;

/// <summary>
/// Summary description for Varios
/// </summary>
public class Varios
{
    public enum Tipos {
        EstadoCivil=1,
        EPS=2,
        ARP=3,
        FOP=4,
        Cargo=5,
        MotivoTerminacion=6,
        DocumentosRRHH=7,
        RecursosEvento=8,
        TipoEvento=9,
        ComplejidadEvento=10,
        FormaDePagoEvento=11,
        PlanDeSaludEvento=12,
        CapacidadAmbulancias=13,
        AtributosAmbulancias=14,
        ServiciosRequisicion=15,
        DocumentosEvento=16,
        DocumentosEmpresarios=17,
        DocumentosUbicaciónEvento= 18,
    }

    public string Id { get; set; }
    public string Nombre { get; set; }
    public string Descripcion { get; set; }
    public string Eliminado { get; set; }
    public int Tipo { get; set; }
    public int? Parametro1 { get; set; }
    public int? Estado { get; set; }

    public Varios() { }

    public static void Remove(string id)
    {
        Cache.Remove("sh_" + id);
    }

    public static void Remove(Tipos tipo)
    {
        Cache.Remove("shl_" + tipo);
        string key = "shq_" + tipo;
        Cache.Remove(key); // las consultas
        Cache.FlushAll(key);
    }

    public static List<Varios> Get(Tipos tipo)
    {

        List<Varios> lista = (List<Varios>)Cache.Get("shl_" + tipo);
        if (lista == null)
        {
            using (CConector conector = new CConector())
            {
                lista = new List<Varios>();
                Query query = new Query("varios");
                query += "id";
                query += "nombre";
                query += "descripcion";
                query += "tipo";
                query += "eliminado";
                query += "parametro1";
                query += "estado";

                MySqlDataReader reader = conector.Query(query.GetSelect("tipo=" + Query.GetValor(((int)tipo).ToString()) + " AND eliminado IS NULL ORDER BY nombre"));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        Varios item = new Varios();
                        item.Nombre = reader["nombre"].ToString();
                        item.Id = reader["id"].ToString();
                        item.Descripcion = reader["descripcion"].ToString();
                        item.Eliminado = reader["eliminado"].ToString();
                        item.Tipo = (int)reader["tipo"];
                        item.Parametro1 = reader["parametro1"] as int?;
                        item.Estado = reader["estado"] as int?;
                        lista.Add(item);
                    }
                }
                Cache.Set("shl_" + tipo, lista);
            }
        }
        return lista;
    }

    public static Varios Get(string id)
    {
        if (string.IsNullOrEmpty(id))
            return new Varios();
        Varios item = (Varios)Cache.Get("sh_" + id);
        if (item == null)
        {
            item = new Varios();
            using (CConector conector = new CConector())
            {

                Query query = new Query("varios");
                query += "id";
                query += "nombre";
                query += "descripcion";
                query += "eliminado";
                query += "tipo";
                query += "parametro1";
                query += "estado";

                MySqlDataReader reader = conector.Query(query.GetSelect("id=" + Query.GetValor(id)));
                if (reader != null && reader.Read())
                {
                    item.Nombre = reader["nombre"].ToString();
                    item.Id = reader["id"].ToString();
                    item.Descripcion = reader["descripcion"].ToString();
                    item.Eliminado = reader["eliminado"].ToString();
                    item.Tipo = (int)reader["tipo"];
                    item.Parametro1 = reader["parametro1"] as int?;
                    item.Estado = reader["estado"] as int?;
                }
            }
            Cache.Set("sh_" + id, item);
        }
        return item;
    }
}