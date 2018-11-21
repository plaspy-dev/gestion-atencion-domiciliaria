using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.Componentes;

namespace OrganizationExample15.Models.Administrador
{
    public class MTercero : ProtectedField
    {
        public string Id { get; set; }
        [Required(ErrorMessage ="Por favor ingrese un nombre")]
        public string Nombre { get; set; }
        [Required(ErrorMessage ="Por favor ingrese una identificación")]
        public string Identificacion { get; set; }
        public string Descripcion { get; set; }
        public string Direccion { get; set; }
        public string Telefono { get; set; }
        [EmailAddress(ErrorMessage ="Por favor ingrese una dirección de correo valida")]
        public string EMail { get; set; }

        protected static List<MTercero> _GetItems(string condition, params object[] args)
        {
            List<MTercero> list = new List<MTercero>();
            using (CConector conector = new CConector())
            {
                Query query = new Query("tercero");

                query += "id";
                query += "nombre";
                query += "descripcion";
                query += "tipo";
                query += "identificacion";
                query += "telefono";
                query += "direccion";
                query += "email";

                MySqlDataReader reader = conector.Query(query.GetSelect(condition, null, args));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        MTercero info = new MTercero();

                        info.Id = reader["id"].ToString();

                        info.Nombre = reader["nombre"].ToString();
                        info.Descripcion = reader["descripcion"].ToString();
                        info.Identificacion = reader["identificacion"].ToString();
                        info.Telefono = reader["telefono"].ToString();
                        info.Direccion = reader["direccion"].ToString();
                        info.EMail = reader["email"].ToString();

                        list.Add(info);
                    }
                }
                else return null;
            }
            return list;
        }

        public static MTercero GetItem(string id) {

            string key = string.Format("{0}_{1}", "MTercero", id);
            MTercero info = Cache.Get<MTercero>(key);
            if (info == null)
            {
                info = _GetItems("id={0}", Query.GetValor(id))?.FirstOrDefault() ?? new MTercero();
                Cache.Set(key, info);
            }
            return info;
        }

        public static List<MTercero> GetList()
        {
            string key = string.Format("{0}", "MTerceroes");
            string keylist = string.Format("{0}list", "MTercero");
            List<MTercero> list = Cache.Get<List<MTercero>>(key);
            if (list == null)
            {
                list = _GetItems("estado IS NULL ORDER BY nombre") ?? new List<MTercero>();
                Cache.Set(key, list);
                Cache.AddList(keylist, key);
            }
            return list;
        }

        public static void CleanCache(string id=null) {

            string key = string.Format("{0}_{1}", "MTercero", id);
            string keylist = string.Format("{0}list", "MTercero");
            Cache.Remove(key);
            Cache.RemoveList(keylist);
        }
    }
}