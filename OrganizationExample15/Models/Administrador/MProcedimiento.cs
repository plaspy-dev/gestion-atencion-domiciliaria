using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.Componentes;

namespace OrganizationExample15.Models.Administrador
{
    public class MProcedimiento : ProtectedField
    {
        public class CostoProcedimiento {
            public string Proveedor { get; set; }
            public string Nombre { get; set; }
            public string Identificacion { get; set; }
            public string Costo { get; set; }
        }

        public string Id { get; set; }
        [Required(ErrorMessage ="Por favor ingrese un código")]
        public string Codigo { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un nombre")]
        public string Nombre { get; set; }
        public string PrincipioActivo { get; set; }
        public string Forma { get; set; }
        public string Concentracion { get; set; }
        public string Aclaracion { get; set; }
        public string Area { get; set; }
        public string TipoServicio { get; set; }
        public string Precio { get; set; }
        public string PrecioRegulado { get; set; }
        public string CodigoSIIGO { get; set; }
        public string CuentaInventario { get; set; }
        public string CuentaCosto { get; set; }
        public string Tipo { get; set; }
        public bool ImprimirUnaHoja { get; set; }
        public List<string> Areas { get; set; } = new List<string>();
        protected List<CostoProcedimiento> _Costos { get; set; }
        public List<CostoProcedimiento> Costos {
            get {
                if (_Costos == null) {
                    _Costos = new List<CostoProcedimiento>();
                    using (CConector conector = new CConector()) {
                        MySqlDataReader reader= conector.Query(@"SELECT tercero.id, tercero.nombre, tercero.identificacion, costo_proveedor.costo
FROM tercero 
LEFT JOIN costo_proveedor ON (costo_proveedor.producto={0} AND costo_proveedor.proveedor=tercero.id)
WHERE tercero.estado IS NULL 
ORDER BY nombre
;", Query.GetValor(Id));
                        if (reader != null) {
                            while (reader.Read()) {
                                CostoProcedimiento info = new CostoProcedimiento();
                                info.Proveedor = reader["id"].ToString();
                                info.Nombre = reader["nombre"].ToString();
                                info.Identificacion = reader["identificacion"].ToString();
                                info.Costo = string.Format(CultureInfo.InvariantCulture, "{0}", reader["costo"]);
                                _Costos.Add(info);
                            }
                        }
                    }
                }
                return _Costos;
            }
            set {
                _Costos = value;
            }
        }
        

        protected static List<MProcedimiento> _GetItems(string condition, params object[] args)
        {
            List<MProcedimiento> list = new List<MProcedimiento>();
            using (CConector conector = new CConector())
            using (CConector conectora = new CConector())
            {
                Query query = new Query("medicamentos");

                query += "id";
                query += "nombre";
                query += "forma";
                query += "codigo";
                query += "principio";
                query += "concentracion";
                query += "aclaracion";
                query += "area";
                query += "tipo";
                query += "grupo";
                query += "hoja_sola";
                query += "precio_regulado";
                query += "precio";
                query += "codigoSIIGO";
                query += "cuenta_inventario";
                query += "cuenta_costo";
                query += "tipo_servicio";

                MySqlDataReader reader = conector.Query(query.GetSelect(condition, null, args));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        MProcedimiento info = new MProcedimiento();

                        info.Id = reader["id"].ToString();
                        info.Nombre = reader["nombre"].ToString();
                        info.Forma = reader["forma"].ToString();
                        info.Codigo = reader["codigo"].ToString();
                        info.PrincipioActivo = reader["principio"].ToString();
                        info.Concentracion = reader["concentracion"].ToString();
                        info.Aclaracion = reader["aclaracion"].ToString();
                        info.Area = reader["area"].ToString();
                        info.Tipo = reader["tipo"].ToString();
                        info.Area = reader["grupo"].ToString();
                        info.ImprimirUnaHoja = reader["hoja_sola"].ToString() == "1";
                        info.PrecioRegulado = reader["precio_regulado"].ToString();
                        info.Precio = reader["precio"].ToString();
                        info.CodigoSIIGO = reader["codigoSIIGO"].ToString();
                        info.CuentaInventario = reader["cuenta_inventario"].ToString();
                        info.CuentaCosto = reader["cuenta_costo"].ToString();
                        info.TipoServicio = reader["tipo_servicio"].ToString();

                        info.Areas = conectora.QueryString("SELECT GROUP_CONCAT(area) FROM medicamento_area WHERE medicamento={0}", Query.GetValor(info.Id)).Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();

                        list.Add(info);
                    }
                }
                else return null;
            }
            return list;
        }

        public static MProcedimiento GetItem(string id)
        {

            string key = string.Format("{0}_{1}", "MProcedimiento", id);
            MProcedimiento info = Cache.Get<MProcedimiento>(key);
            if (info == null)
            {
                info = _GetItems("id={0}", Query.GetValor(id))?.FirstOrDefault() ?? new MProcedimiento();
                Cache.Set(key, info);
            }
            return info;
        }

        public static List<MProcedimiento> GetList()
        {
            string key = string.Format("{0}", "MProcedimientos");
            string keylist = string.Format("{0}list", "MProcedimiento");
            List<MProcedimiento> list = Cache.Get<List<MProcedimiento>>(key);
            if (list == null)
            {
                list = _GetItems("estado IS NULL ORDER BY nombre") ?? new List<MProcedimiento>();
                Cache.Set(key, list);
                Cache.AddList(keylist, key);
            }
            return list;
        }

        public static void CleanCache(string id = null)
        {
            string key = string.Format("{0}_{1}", "MProcedimiento", id);
            string keylist = string.Format("{0}list", "MProcedimiento");
            Cache.Remove(key);
            Cache.RemoveList(keylist);
        }
    }
}