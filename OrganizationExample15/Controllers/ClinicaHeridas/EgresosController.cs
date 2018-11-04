using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models.ClinicaHeridas;
using Newtonsoft.Json;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Text;
using System.IO;
using System.Net;
using System.Web.Security;
using System.Text.RegularExpressions;

namespace OrganizationExample15.Controllers
{
    public partial class ClinicaHeridasController : BaseController
    {
        public ActionResult __Egresos(int current, int rowCount, Dictionary<string, string> sort, Egresos cuentas, string searchPhrase = null)
        {
            string where = string.Format(@"paciente.egresoClinicaHeridas BETWEEN {0} AND {1}
                            AND (0={2} OR {2}=paciente.entId)"
                , Query.GetValor(cuentas.Desde)
                , Query.GetValor(cuentas.Hasta)
                , cuentas.Entidad ?? 0
                );

            Query query = new Query("paciente");

            query["f"]= "CAST(DATE(paciente.egresoClinicaHeridas) AS CHAR)";
            query["d"] = "paciente.pacDocumento";
            query["n"] = "paciente.pacNombres";
            query["a"] = "asegurador.entNombre";

            string join = @"LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , "SELECT COUNT(*) FROM paciente " + join + " WHERE " + where
                    , query.GetSelect(where, join)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data), HomeCareVersion.JSONContentType);
            }
        }

        [HttpPost]
        public ActionResult Egresos(Egresos cuentas)
        {
            if (ModelState.IsValid)
            {
                string where = string.Format(@"paciente.egresoClinicaHeridas BETWEEN {0} AND {1}
                            AND (0={2} OR {2}=paciente.entId)"
                , Query.GetValor(cuentas.Desde)
                , Query.GetValor(cuentas.Hasta)
                , cuentas.Entidad ?? 0
                );

                Query query = new Query("paciente");

                query["Fecha Egreso"] = "paciente.egresoClinicaHeridas";
                query["Documento"] = "paciente.pacDocumento";
                query["Paciente"] = "paciente.pacNombres";
                query["Asegurador"] = "asegurador.entNombre";

                string join = @"LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)";

                CUsuario usuario = ViewBag.User;
                if (!Excel.SaveExcel(this, usuario, "Informe EPS", query.GetSelect(where + " ORDER BY paciente.egresoClinicaHeridas", join)))
                {
                    return HttpNotFound();
                }
                return new EmptyResult();
            }
            return View(cuentas);
        }

        public ActionResult Egresos()
        {
            CUsuario usuario = ViewBag.User;
            Egresos cuentas = new Egresos();
            cuentas.Desde = Query.GetMySQLDateFormat(DateTime.Now.AddDays(-30));
            cuentas.Hasta = Query.GetMySQLDateFormat(DateTime.Now);

            ViewBag.Excel = 1;

            return View(cuentas);
        }
    }
}