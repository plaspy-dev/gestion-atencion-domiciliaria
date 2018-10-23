using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.Componentes;
using Newtonsoft.Json;

namespace OrganizationExample15.Models.Administrador
{
    public class CategoriaCenso : MVarios
    {
        public List<MProcedimiento> LProcedimientos { get; set; } = new List<MProcedimiento>();
        public string Procedimientos {
            set {
                LProcedimientos = new List<MProcedimiento>();
                try
                {
                    LProcedimientos = new List<MProcedimiento>();
                    foreach (string id in value.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                    {
                        LProcedimientos.Add(new MProcedimiento() { Id = id });
                    }
                }
                catch (Exception e)
                {
                }
            }
        }
        public string _Procedimientos {
            get {
                return JsonConvert.SerializeObject(LProcedimientos, HomeCareVersion.JsonSerializerSettingsCamelCase);
            }
            set {
                LProcedimientos = new List<MProcedimiento>();
                try {
                    LProcedimientos = JsonConvert.DeserializeObject<List<MProcedimiento>>(value, HomeCareVersion.JsonSerializerSettingsCamelCase);
                } catch (Exception e) {
                }
            }
        }

        protected new static List<CategoriaCenso> _GetItems(string condition, params object[] args)
        {
            List<CategoriaCenso> list = new List<CategoriaCenso>();
            using (CConector conector = new CConector())
            using (CConector conector2 = new CConector())
            {
                Query querycc = new Query("categoria_censo");

                querycc["t"]= "GROUP_CONCAT(hora)";

                Query query = new Query("varios");

                query += "id";
                query += "nombre";
                query += "descripcion";
                query += "tipo";
                query += "szReservado";
                query += "parametro1";
                query += "estado";

                MySqlDataReader reader = conector.Query(query.GetSelect(condition, null, args));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        CategoriaCenso item = new CategoriaCenso();
                        item.Id = reader["id"].ToString();
                        item.Nombre = reader["nombre"].ToString();
                        item.Descripcion = reader["descripcion"].ToString();
                        item._Tipo = (Tipo)(int)reader["tipo"];
                        item.szReservado = reader["szReservado"] as string;
                        item.parametro1 = reader["parametro1"] as ulong?;
                        item.estado = reader["estado"] as long?;
                        item.Procedimientos = conector2.QueryString(querycc.GetSelect("categoria={0}", null, Query.GetValor(item.Id)));

                        list.Add(item);
                    }
                }
                else return null;
            }
            return list;
        }

        public new static CategoriaCenso GetItem(string id)
        {
            string key = string.Format("{0}_{1}", "CategoriaCenso", id);
            CategoriaCenso item = Cache.Get<CategoriaCenso>(key);
            if (item == null)
            {
                item = _GetItems("id={0}", Query.GetValor(id))?.FirstOrDefault() ?? new CategoriaCenso();
                Cache.Set(key, item);
            }
            return item;
        }

        public new static List<CategoriaCenso> GetList(Tipo tipo)
        {
            string key = string.Format("{0}", "CategoriaCenso");
            string keylist = string.Format("{0}list", "CategoriaCenso");
            List<CategoriaCenso> list = Cache.Get<List<CategoriaCenso>>(key);
            if (list == null)
            {
                list= _GetItems("tipo={0} AND eliminado IS NULL", (int)tipo) ?? new List<CategoriaCenso>();
                Cache.Set(key, list);
                Cache.AddList(keylist, key);
            }
            return list;
        }

        public new static void CleanCache(string id = null)
        {
            string key = string.Format("{0}_{1}", "CategoriaCenso", id);
            string keylist = string.Format("{0}list", "CategoriaCenso");
            Cache.Remove(key);
            Cache.RemoveList(keylist);
            MVarios.CleanCache(id);
        }
    }
}