using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models.terapeutico;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;

namespace OrganizationExample15.Controllers.Terapeutico
{
    public partial class TerapeuticoController : BaseController
    {
        public ActionResult __ListadoCuentas(int current, int rowCount, Dictionary<string, string> sort, ListadoCuentas cuentas, string searchPhrase = null) {

            CUsuario usuario = ViewBag.User;
            string personalId = usuario["personal"];
            if (usuario.CanAdmin())
            {
                personalId = cuentas.Funcionario.Id;
                if (string.IsNullOrEmpty(personalId))
                    personalId = "0";
            }

            string where = string.Format(" WHERE cuenta.fecha BETWEEN {0} AND {1} AND ({2}=0 OR cuenta.personal={2}) AND ({3}=0 OR cuenta.estado={3}) AND cuenta.eliminado IS NULL"
                , Query.GetValor(cuentas.Desde)
                , Query.GetValor(cuentas.Hasta)
                , Query.GetValor(personalId)
                , cuentas.Estado ?? 0
                );

            string groupby = " GROUP BY n,f,h,e";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM cuenta" + where
                    , @"SELECT cuenta.personal i, recurso_humano.perNombre n,CONVERT(DATE(cuenta.fecha), CHAR) f,CONVERT(DATE(cuenta.final),CHAR) h,estado.nombre e,SUM(cuenta_servicio.cantidad) c 
,SUM(IFNULL(cuenta_servicio.valor, medicamentos.precio)) t
FROM cuenta
LEFT JOIN recurso_humano ON (recurso_humano.perId=cuenta.personal)
LEFT JOIN varios estado ON (estado.id=cuenta.estado)
LEFT JOIN cuenta_servicio ON (cuenta_servicio.cuenta=cuenta.id) 
LEFT JOIN medicamentos ON (medicamentos.id=cuenta_servicio.servicio)
 " + where + groupby
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data), "application/json");
            }
        }

        [HttpPost]
        public ActionResult ListadoCuentas(ListadoCuentas cuentas) {
            if(ModelState.IsValid)
            {
                CUsuario usuario = ViewBag.User;
                string personalId = usuario["personal"];
                if (usuario.CanAdmin())
                {
                    personalId = cuentas.Funcionario.Id;
                    if (string.IsNullOrEmpty(personalId))
                        personalId = "0";
                }

                string where = string.Format(" WHERE cuenta.fecha BETWEEN {0} AND {1} AND ({2}=0 OR cuenta.personal={2}) AND ({3}=0 OR cuenta.estado={3}) AND cuenta.eliminado IS NULL"
                    , Query.GetValor(cuentas.Desde)
                    , Query.GetValor(cuentas.Hasta)
                    , Query.GetValor(personalId)
                    , cuentas.Estado ?? 0
                    );

                string groupby = " GROUP BY Funcionario,Final,Fecha,Estado";

                if (!Excel.SaveExcel(this, usuario, "Cuentas", @"SELECT recurso_humano.perNombre Funcionario,DATE(cuenta.fecha) Fecha,DATE(cuenta.final) Final,estado.nombre Estado,cuenta.total Total,SUM(cuenta_servicio.cantidad) Servicios 
FROM cuenta
LEFT JOIN recurso_humano ON (recurso_humano.perId=cuenta.personal)
LEFT JOIN varios estado ON (estado.id=cuenta.estado)
LEFT JOIN cuenta_servicio ON (cuenta_servicio.cuenta=cuenta.id) " + where + groupby)) {
                    return HttpNotFound();
                }
                return new EmptyResult();
            }
            return View(cuentas);
        }

        public ActionResult ListadoCuentas() {

            CUsuario usuario = ViewBag.User;
            ListadoCuentas cuentas = new ListadoCuentas();
            cuentas.Desde= Query.GetMySQLDateFormat(DateTime.Now.AddDays(-30));
            cuentas.Hasta = Query.GetMySQLDateFormat(DateTime.Now);
            cuentas.Funcionario.Id = usuario["personal"];
            cuentas.Funcionario.ReadOnly = !usuario.CanAdmin();

            ViewBag.Excel = "onSaveExcel()";

            return View(cuentas);
        }
    }
}