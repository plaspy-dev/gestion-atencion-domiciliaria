using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.Componentes;

namespace OrganizationExample15.Models.Administrador
{
    public class Asegurador : ProtectedField
    {
        public string Id { get; set; }
        [Required(ErrorMessage ="Por favor ingrese un nombre de asegurador")]
        public string Nombre { get; set; }
        public decimal? MaximoPaciente { get; set; }
        public decimal? MaximoMensual { get; set; }
        public bool EPS { get; set; }
        public bool AFP { get; set; }
        public bool ARP { get; set; }
        public bool ProgramarSinAutorizacion { get; set; }


        protected static List<Asegurador> _GetItems(string condition, params object[] args)
        {
            List<Asegurador> list = new List<Asegurador>();
            using (CConector conector = new CConector())
            {
                Query query = new Query("asegurador");

                query += "entId";
                query += "entNombre";
                query += "entEPS";
                query += "entAFP";
                query += "entARP";
                query += "entPrgNoAut";
                query += "maximo_mensual";
                query += "maximo_paciente";

                MySqlDataReader reader = conector.Query(query.GetSelect(condition, null, args));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        Asegurador info = new Asegurador();
                        info.Id = reader["entId"].ToString();
                        info.Nombre = reader["entNombre"].ToString();
                        info.EPS = reader["entEPS"].ToString()=="1" || reader["entEPS"].ToString()=="True";
                        info.AFP = reader["entAFP"].ToString() == "1" || reader["entAFP"].ToString() == "True";
                        info.ARP = reader["entARP"].ToString() == "1" || reader["entARP"].ToString() == "True";
                        info.ProgramarSinAutorizacion = reader["entPrgNoAut"].ToString() == "1" || reader["entPrgNoAut"].ToString() == "True";
                        info.MaximoMensual = reader["maximo_mensual"] as decimal?;
                        info.MaximoPaciente = reader["maximo_paciente"] as decimal?;
                        list.Add(info);
                    }
                }
                else return null;
            }
            return list;
        }

        public static Asegurador GetItem(string id) {

            string key = string.Format("{0}_{1}", "asegurador",id);
            Asegurador info = Cache.Get<Asegurador>(key);
            if (info == null)
            {
                info = _GetItems("entId={0}", Query.GetValor(id))?.FirstOrDefault() ?? new Asegurador();
                Cache.Set(key, info);
            }
            return info;
        }

        public static List<Asegurador> GetList()
        {
            string key = string.Format("{0}", "aseguradores");
            string keylist = string.Format("{0}list", "asegurador");
            List<Asegurador> list = Cache.Get<List<Asegurador>>(key);
            if (list == null)
            {
                list = _GetItems("eliminado IS NULL ORDER BY entNombre") ?? new List<Asegurador>();
                Cache.Set(key, list);
                Cache.AddList(keylist, key);
            }
            return list;
        }

        public static void CleanCache(string id=null) {

            string key = string.Format("{0}_{1}", "asegurador", id);
            string keylist = string.Format("{0}list", "asegurador");
            Cache.Remove(key);
            Cache.RemoveList(keylist);
        }
    }
}