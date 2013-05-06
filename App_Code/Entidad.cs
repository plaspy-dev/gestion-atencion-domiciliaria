using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;
using System.Data.SqlClient;

[Serializable]
public class Entidad
{
    public string Id { get; set; }
    public string Nombre { get; set; }
    public Decimal MaximoEntidad { get; set; }
    public Decimal MaximoPaciente { get; set; }

    public Entidad()
    {
    }
    public static Entidad GetEntidad(string id) {
        Entidad entidad = (Entidad)HttpRuntime.Cache["e" + id];
        if (entidad == null)
        {
            entidad = new Entidad();
            Query query = new Query("admEntidad");

            query += "maximo_paciente";
            query += "maximo_mensual";
            query+="entNombre";

            using (CConectorMS conector = new CConectorMS())
            {

                SqlDataReader reader = conector.Query(query.GetSelect("entId=" + Query.GetValor(id)));
                if (reader != null && reader.Read())
                {

                    entidad.Id = id;
                    entidad.Nombre = reader["entNombre"].ToString();
                    entidad.MaximoEntidad = reader["maximo_mensual"].ToString() == "" ? 0 : Convert.ToDecimal(reader["maximo_mensual"].ToString());
                    entidad.MaximoPaciente = reader["maximo_paciente"].ToString() == "" ? 0 : Convert.ToDecimal(reader["maximo_paciente"].ToString());
                }
            }
            HttpRuntime.Cache.Insert("e"+ id, entidad);
        }
        return entidad;
    }
    public static void RemoveEntidad(string id) {
        HttpRuntime.Cache.Remove("e" + id);
    }
}
