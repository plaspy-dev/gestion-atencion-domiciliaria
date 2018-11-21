using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.Componentes;

namespace OrganizationExample15.Models.Administrador
{
    public class Grupo : ProtectedField
    {
        public string Id { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un nombre del grupo")]
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public List<Privilege> Privileges { get; set; } = new List<Privilege>();

        public Grupo()
        {
            SDG.Componentes.Grupo grupo = new SDG.Componentes.Grupo();
            foreach (CURLs info in grupo.GetFullMenu()) {
                Privilege item = new Privilege();
                item.Title = info.Titulo;
                item.URL = info.URL;
                Privilege parent= Privileges.Find(x => x.Title == info.Parent);
                if (parent == null) {
                    parent = new Privilege() { Title=info.Parent };
                    Privileges.Add(parent);
                }
                parent.Childrens.Add(item);
            }
        }

        protected static List<Grupo> _GetItems(string condition, params object[] args)
        {
            List<Grupo> list = new List<Grupo>();
            using (CConector conector = new CConector())
            using (CConector conectorp = new CConector())
            {
                Query query = new Query("grupo");

                query += "id";
                query += "nombre";
                query += "descripcion";

                MySqlDataReader reader = conector.Query(query.GetSelect(condition, null, args));
                if (reader != null)
                {
                    query = new Query("permisos");
                    query += "url";
                    query += "permiso";

                    while (reader.Read())
                    {
                        Grupo info = new Grupo();
                        info.Id = reader["id"].ToString();
                        info.Nombre = reader["nombre"].ToString();
                        info.Descripcion = reader["descripcion"].ToString();
                        list.Add(info);

                        MySqlDataReader readerp = conectorp.Query(query.GetSelect("grupo=" + Query.GetValor(info.Id)));
                        if (readerp != null)
                        {
                            while (readerp.Read())
                            {
                                string url = readerp["url"].ToString();
                                int nPermisos = Convert.ToInt32(readerp["permiso"]);
                                foreach (Privilege privilege in info.Privileges)
                                {
                                    Privilege child = privilege.Childrens.Find(x => x.URL == url);
                                    if (child != null)
                                    {
                                        if (child.Hidden != true)
                                            privilege.Granted = Privilege.Privileges.Read;
                                        child.Granted = (Privilege.Privileges)nPermisos;
                                    }
                                }
                            }
                        }
                    }
                } else return null;
            }
            return list;
        }

        public static Grupo GetItem(string id)
        {

            string key = string.Format("{0}_{1}", "grupo", id);
            Grupo info = Cache.Get<Grupo>(key);
            if (info == null)
            {
                info = _GetItems("id={0}", Query.GetValor(id))?.FirstOrDefault() ?? new Grupo();
                Cache.Set(key, info);
            }
            return info;
        }

        public static List<Grupo> GetList()
        {
            string key = string.Format("{0}", "grupos");
            string keylist = string.Format("{0}list", "grupo");
            List<Grupo> list = Cache.Get<List<Grupo>>(key);
            if (list == null)
            {
                list = _GetItems("eliminado IS NULL ORDER BY nombre") ?? new List<Grupo>();
                list.Insert(0, new Grupo() { Id="0", Nombre="(Administrador)" });
                Cache.Set(key, list);
                Cache.AddList(keylist, key);
            }
            return list;
        }

        public static void CleanCache(string id = null)
        {

            string key = string.Format("{0}_{1}", "grupo", id);
            string keylist = string.Format("{0}list", "grupo");
            Cache.Remove(key);
            Cache.RemoveList(keylist);
        }
    }
}