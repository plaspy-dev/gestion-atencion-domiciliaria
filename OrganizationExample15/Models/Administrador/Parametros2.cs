using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.Componentes;

namespace OrganizationExample15.Models.Administrador
{
    public class Parametro2 : ProtectedField
    {
        public enum Tipo {
            Ninguno=0,
            [Description("Personal/Cargos")]
            PersonalCargos=1,
            [Description("Reporte PQR/Tipos")]
            ReportePQRTipos=2,
            [Description("Bitácoras/Tipo")]
            BitacorasTipo=3,
            [Description("Recursos humanos/Documentos entregados a Atención Domiciliaria")]
            RecursosHumanosDocumentosEntregadosaHS =4,
            [Description("Recursos humanos/Documentos entregados al contratista")]
            RecursosHumanosDocumentosEntregadosContratista = 5
        }

        public string Id { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un nombre")]
        public string Nombre { get; set; }

        public static string GetCondicion(Tipo tipo)
        {
            switch (tipo)
            {
                case Tipo.PersonalCargos:
                case Tipo.ReportePQRTipos:
                case Tipo.BitacorasTipo:
                    return "eliminado IS NULL";
                case Tipo.RecursosHumanosDocumentosEntregadosaHS:
                    return "docTipoEntrega=1 AND eliminado IS NULL";
                case Tipo.RecursosHumanosDocumentosEntregadosContratista:
                    return "docTipoEntrega=2 AND eliminado IS NULL";
                default:
                    return null;
            }
        }

        public static string GetCondicion(Tipo tipo, string id) {
            switch (tipo)
            {
                case Tipo.PersonalCargos:
                    return string.Format("carId={0} ", Query.GetValor(id));
                case Tipo.ReportePQRTipos:
                    return string.Format("tqrIdTipo={0}", Query.GetValor(id));
                case Tipo.BitacorasTipo:
                    return string.Format("tpaId={0}", Query.GetValor(id));
                case Tipo.RecursosHumanosDocumentosEntregadosaHS:
                    return string.Format("docId={0}", Query.GetValor(id));
                case Tipo.RecursosHumanosDocumentosEntregadosContratista:
                    return string.Format("docId={0}", Query.GetValor(id));
                default:
                    return null;
            }
        }

        public static Query GetTables(Tipo tipo) {
            Query query = new Query("");
            switch (tipo) {
                case Tipo.PersonalCargos:
                    query.TableName = "cargo";
                    query+= "carId";
                    query += "carDescripcion";
                    break;
                case Tipo.ReportePQRTipos:
                    query.TableName = "tipo_queja_reclamo";
                    query += "tqrIdTipo";
                    query += "tqrDescripcion";
                    break;
                case Tipo.BitacorasTipo:
                    query.TableName = "tipo_actividad";
                    query += "tpaId";
                    query += "tpaDescripcion";
                    break;
                case Tipo.RecursosHumanosDocumentosEntregadosaHS:
                    query.TableName = "funcionario_documentos";
                    query += "docId";
                    query += "docDesc";
                    query["docTipoEntrega"] = 1;
                    break;
                case Tipo.RecursosHumanosDocumentosEntregadosContratista:
                    query.TableName = "funcionario_documentos";
                    query += "docId";
                    query += "docDesc";
                    query["docTipoEntrega"] = 2;
                    break;
                default:
                    return null;
            }
            return query;
        }

        protected static List<Parametro2> _GetItems(Tipo tipo, string condition, params object[] args)
        {
            List<Parametro2> list = new List<Parametro2>();
            using (CConector conector = new CConector())
            {
                Query query = GetTables(tipo);

                MySqlDataReader reader = conector.Query(query.GetSelect(condition + " ORDER BY 2", null, args));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        Parametro2 item = new Parametro2();
                        item.Id = reader[0].ToString();
                        item.Nombre = reader[1].ToString();
                        list.Add(item);
                    }
                }
                else return null;
            }
            return list;
        }

        public static Parametro2 GetItem(Tipo tipo, string id)
        {
            string key = string.Format("{0}_{1}_{2}", "Parametros2",(int)tipo, id);
            Parametro2 item = Cache.Get<Parametro2>(key);
            if (item == null)
            {
                item = _GetItems(tipo, GetCondicion(tipo, id))?.FirstOrDefault() ?? new Parametro2();
                Cache.Set(key, item);
            }
            return item;
        }

        public static List<Parametro2> GetList(Tipo tipo)
        {
            string key = string.Format("{0}_{1}", "Parametros2", (int)tipo);
            string keylist = string.Format("{0}_{1}list", "Parametros2", (int)tipo);
            List<Parametro2> list = Cache.Get<List<Parametro2>>(key);
            if (list == null)
            {
                list = _GetItems(tipo, GetCondicion(tipo), (int)tipo) ?? new List<Parametro2>();
                Cache.Set(key, list);
                Cache.AddList(keylist, key);
            }
            return list;
        }

        public static void CleanCache(Tipo tipo, string id = null)
        {
            string key = string.Format("{0}_{1}_{2}", "Parametros2", tipo, id);
            string keylist = string.Format("{0}_{1}list", "Parametros2", (int)tipo);
            Cache.Remove(key);
            Cache.RemoveList(keylist);
        }
    }
}