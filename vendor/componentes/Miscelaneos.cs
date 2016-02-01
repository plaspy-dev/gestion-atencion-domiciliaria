using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MySql.Data.MySqlClient;

namespace SDG.Componentes
{
    [Serializable]
    public class Miscelaneos
    {
        public String Id { set; get; }
        public String Nombre { set; get; }
        public Miscelaneos(string id, string nombre) {
            Id = id;
            Nombre = nombre;
        }
        public Miscelaneos()
        {
        }

        public static List<Miscelaneos> GetList(Conector conector, string query) {
            List<Miscelaneos> list = new List<Miscelaneos>();
            MySqlDataReader reader = conector.Query(query);
            if (reader != null) {
                while (reader.Read()) {
                    list.Add(new Miscelaneos(reader[0].ToString(), reader[1].ToString()));
                }
            }
            return list;
        }
    }
}
