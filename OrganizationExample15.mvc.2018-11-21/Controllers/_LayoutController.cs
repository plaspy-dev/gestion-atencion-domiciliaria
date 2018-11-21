using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models.Shared;
using MySql.Data.MySqlClient;
using SDG.Componentes;

namespace OrganizationExample15.Controllers
{
    public class _LayoutController : Controller
    {
        public ActionResult Alerts(int i) {

            CUsuario usuario = (CUsuario)CUsuario.GetInstance(false);
            if (usuario == null)
            {
                return new EmptyResult();
            }

            List<Alertas> resultado = (from x in Alertas.GetAlertas()
                                       where x.Id == i.ToString()
                                       select x).ToList();
            if (resultado.Count == 0)
                return new EmptyResult();

            Alertas info = resultado.First();
            string url = info.URL;
            resultado = new List<Alertas>();
            using (CConector conector = new CConector()) {
                MySqlDataReader reader= conector.Query(info.SelectCommand);
                if (reader != null) {
                    while(reader.Read()) {
                        info = new Alertas();
                        info.Nombre = reader["nombre"].ToString();
                        info.Id = reader["id"].ToString();
                        info.URL = string.Format(Url.Content(url), info.Id);
                        resultado.Add(info);
                    }
                }
            }

            return Json(resultado);
        }

        [HttpPost]
        public ActionResult Properties(string u, string i) {
            CUsuario usuario = (CUsuario)CUsuario.GetInstance(false);
            if (usuario == null || string.IsNullOrEmpty(u) || string.IsNullOrEmpty(i))
            {
                return HttpNotFound();
            }

            List<Property> list = new List<Property>();

            string prefix = Url.Content("~/");
            if (u.StartsWith(prefix))
            {
                u = u.Remove(0, prefix.Length).Insert(0, "~/");
            }

            using (CConector conector = new CConector())
            {

                string tablename = "modificaciones";

                Query query = new Query(tablename);

                query += tablename + ".fecha";
                query += "usuario.nombre";

                MySqlDataReader reader = conector.Query(query.GetSelect("{2}.url={0} AND {2}.id={1} ORDER BY fecha DESC", "LEFT JOIN usuario ON (usuario.id=" + tablename + ".usuario)", Query.GetValor(u), Query.GetValor(i), tablename));
                if (reader != null)
                {
                    while (reader.Read())
                    {

                        list.Add(new Property() { Date = (DateTime)reader["fecha"], User = reader["nombre"].ToString() });
                    }
                }
            }

            return PartialView(list);
        }
    }
}