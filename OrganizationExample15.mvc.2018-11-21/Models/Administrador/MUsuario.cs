using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.Componentes;
using SDG.Componentes.Validator;

namespace OrganizationExample15.Models.Administrador
{
    public class HSUsuario : ProtectedField
    {
        public enum Estado {
            Inactivo,
            Eliminado,
            Activo
        }

        public string Id { get; set; }
        public MFuncionarioSimple Funcionario { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un nombre de usuario")]
        public string Usuario { get; set; }
        [Required(ErrorMessage ="Por favor seleccione un grupo")]
        public string Grupo { get; set; }
        [RequiredIfNot("Id", ErrorMessage ="Por favor ingrese una contraseña")]
        public string Contrasena { get; set; }
        [Compare("Contrasena", ErrorMessage ="Las contraseñas no coinciden")]
        public string Confirmar { get; set; }
        public bool Cumpleanos { get; set; }
        public bool CambioContrasena { get; set; }
        public Estado EstadoUsuario { get; set; }
        public List<string> Cargos { get; set; } = new List<string>();
        public List<string> Entidades { get; set; } = new List<string>();
        public List<string> Alertas { get; set; } = new List<string>();

        public HSUsuario() {
            Funcionario = new MFuncionarioSimple();
        }

        protected static List<HSUsuario> _GetItems(string condition, params object[] args)
        {
            List<HSUsuario> list = new List<HSUsuario>();
            using (CConector conector = new CConector())
            using (CConector conectora= new CConector())
            {
                Query query = new Query("usuario");

                query += "id";
                query += "nombre";
                query += "usuario";
                query += "grupo";
                query += "personal";
                query += "cumpleanos";
                query += "forceurl";
                query += "cargos";
                query += "entidades";
                query += "estado";

                MySqlDataReader reader = conector.Query(query.GetSelect(condition, null, args));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        HSUsuario info = new HSUsuario();
                        info.Id = reader["id"].ToString();
                        info.Funcionario.Id = reader["personal"].ToString();
                        info.Funcionario.Nombre = reader["nombre"].ToString();
                        info.Usuario = reader["usuario"].ToString();
                        info.Grupo = reader["grupo"].ToString();
                        info.Cumpleanos = reader["cumpleanos"].ToString() == "1";
                        info.EstadoUsuario = reader["estado"] == DBNull.Value ? Estado.Activo : (Estado)Convert.ToInt32(reader["estado"]);
                        info.Cargos = reader["cargos"].ToString().Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();
                        info.Entidades = reader["entidades"].ToString().Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();
                        info.Alertas= conectora.QueryString(@"SELECT GROUP_CONCAT(usuario_alerta.tarId) FROM usuario
LEFT JOIN usuario_alerta ON (usuario.usuario=usuario_alerta.usIdUsuario)
WHERE usuario.id={0}
;", Query.GetValor(info.Id)).Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();

                        list.Add(info);
                    }
                }
                else return null;
            }
            return list;
        }

        public static HSUsuario GetItem(string id) {

            string key = string.Format("{0}_{1}", "HSUsuario", id);
            HSUsuario info = Cache.Get<HSUsuario>(key);
            if (info == null)
            {
                info = _GetItems("id={0}", Query.GetValor(id))?.FirstOrDefault() ?? new HSUsuario();
                Cache.Set(key, info);
            }
            return info;
        }

        public static List<HSUsuario> GetList()
        {
            string key = string.Format("{0}", "HSUsuarioes");
            string keylist = string.Format("{0}list", "HSUsuario");
            List<HSUsuario> list = Cache.Get<List<HSUsuario>>(key);
            if (list == null)
            {
                list = _GetItems("estado IS NULL ORDER BY nombre") ?? new List<HSUsuario>();
                Cache.Set(key, list);
                Cache.AddList(keylist, key);
            }
            return list;
        }

        public static void CleanCache(string id=null) {

            string key = string.Format("{0}_{1}", "HSUsuario", id);
            string keylist = string.Format("{0}list", "HSUsuario");
            Cache.Remove(key);
            Cache.RemoveList(keylist);
        }
    }
}