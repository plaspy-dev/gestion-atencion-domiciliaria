using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models;
using OrganizationExample15.Models.Materna;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SDG.Componentes;

namespace OrganizationExample15.Controllers.Materna
{
    public partial class MaternaController : BaseController
    {
        [NonAction]
        public static BootgridResponseData GetBootGridEvolucion(int current, int rowCount, Dictionary<string, string> sort, string pid)
        {
            string where = string.Format(" seguimiento_materno.paciente={0}", Query.GetValor(pid));

            Query query = new Query("seguimiento_materno");

            query["id"] = "seguimiento_materno.id";
            query["pid"] = "seguimiento_materno.paciente";
            query["f"] = "seguimiento_materno.fecha";
            query["p"] = "recurso_humano.perNombre";

            string join = "LEFT JOIN recurso_humano ON (recurso_humano.perId=seguimiento_materno.funcionario)";

            using (CConector conector = new CConector())
            {
                return BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM seguimiento_materno WHERE " + where
                    , query.GetSelect(where, join)
                    , current
                    , rowCount
                    , sort
                    );
            }
        }

        [HttpPost]
        public ActionResult __Evolucion(int current, int rowCount, Dictionary<string, string> sort, uint pid)
        {
            return Content(JsonConvert.SerializeObject(GetBootGridEvolucion(current, rowCount, sort, pid.ToString()), HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
        }

        // GET: Evolucion
        public ActionResult Evolucion(uint? pid, uint? ehid)
        {
            CUsuario usuario = ViewBag.User;
            Evolucion evolucion = new Evolucion(true);

            evolucion.Paciente.ShowLabel = true;
            evolucion.Funcionario.Required = true;

            if (pid != null)
            {
                evolucion.Paciente.Id = pid.ToString();
                evolucion.Funcionario.Id = usuario["personal"];
                evolucion.Funcionario.ReadOnly = !usuario.CanAdmin();
                if (string.IsNullOrEmpty(evolucion.Paciente.Nombre))
                {
                    return Redirect(Request.Url.AbsolutePath);
                }
                evolucion.ProtectedFields["pid"] = pid.ToString();

                ViewBag._Layout.Params = string.Format("?pid=" + pid);

                evolucion.Fecha = Query.GetFromMySQLDate(DateTime.Now, true);
                MySqlDataReader reader;

                using (CConector conector = new CConector())
                {
                    if (ehid != null)
                    {
                        Query query = new Query("seguimiento_materno");

                        query += "id";
                        query += "paciente";
                        query += "fecha";
                        query += "funcionario";
                        query += "data";
                        query += "tipo";

                        reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(ehid)));
                        if (reader != null && reader.Read())
                        {
                            switch (reader["tipo"].ToString())
                            {
                                case "1":
                                    return Redirect(string.Format("~/materna/seguimiento.aspx?pid={0}&emid={1}", reader["paciente"].ToString(), ehid));
                                case "2":
                                    return Redirect(string.Format("~/materna/postparto.aspx?pid={0}&emid={1}", reader["paciente"].ToString(), ehid));
                            }

                            evolucion = JsonConvert.DeserializeObject<Evolucion>(reader["data"].ToString(), HomeCareVersion.JsonSerializerSettingsCamelCase);

                            evolucion.ProtectedFields["id"] =
                            evolucion.Id = reader["id"].ToString();

                            if (usuario.CanPrint())
                            {
                                ViewBag.Print = true;
                                ViewBag.PDF = true;
                            }

                            evolucion.Fecha = Query.GetFromMySQLDate(reader["fecha"], true);
                            evolucion.Funcionario.Id = reader["funcionario"].ToString();
                            evolucion.Paciente.Id = reader["paciente"].ToString();
                        }
                    }
                }
            }

            if (Request.QueryString["pd"] == "1")
                return View("Evolucion_Print", evolucion);
            if (Request.QueryString["pdf"] == "1")
                return PDFConverter.RenderPDF(this, "Seguimiento domiciliario", "Evolucion_Print", evolucion);

            return View(evolucion);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Evolucion(Evolucion evolucion)
        {
            if (ModelState.IsValid)
            {
                CUsuario usuario = (CUsuario)CUsuario.GetInstance();
                string id = evolucion.ProtectedFields["id"];
                string pacienteid = evolucion.ProtectedFields["pid"];
                if ((string.IsNullOrEmpty(id) && !usuario.CanInsert()) || (!string.IsNullOrEmpty(id) && !usuario.CanUpdate()))
                {
                    return HttpNotFound();
                }

                using (CConector conector = new CConector())
                {
                    conector.StartTransaction();

                    Query query = new Query("seguimiento_materno");

                    query["fecha"] = Query.GetMySQLDateFormat(evolucion.Fecha);
                    query["funcionario"] = evolucion.Funcionario.Id;
                    query["tipo"] = "3";
                    query["data"] = JsonConvert.SerializeObject(evolucion, HomeCareVersion.JsonSerializerSettingsCamelCase);
                    

                    if (string.IsNullOrEmpty(id))
                    {
                        query["paciente"] = pacienteid;

                        int res = conector.QueryMod(query.GetInsert(), true);
                        if (res == -1)
                        {
                            ModelState.AddModelError("", conector.LastError);
                            return View(evolucion);
                        }
                        id = res.ToString();
                    }
                    else
                    {
                        if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1)
                        {
                            ModelState.AddModelError("", conector.LastError);
                            return View(evolucion);
                        }
                    }

                    if (conector.InsertModificacion(id) == -1)
                    {
                        ModelState.AddModelError("", conector.LastError);
                        return View(evolucion);
                    }

                    if (string.IsNullOrEmpty(evolucion.Id) && usuario.GetPermisosRaiz("~/App_data/Escalas") == 0)
                        usuario.SetForceURL("~/paciente/barthel.aspx?pid=" + pacienteid + "&f=" + HttpUtility.UrlEncode(Query.GetMySQLDateFormat(evolucion.Fecha, true)), conector);

                    conector.Commit();

                    return Redirect(Request.Url.AbsolutePath + string.Format("?spid={0}&ed=1", pacienteid));
                }

            }
            return View(evolucion);
        }
    }
}