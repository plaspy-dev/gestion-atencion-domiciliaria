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
        public ActionResult __InformeEPS(int current, int rowCount, Dictionary<string, string> sort, InformeEPS cuentas, string searchPhrase = null)
        {
            string where = string.Format(@"{{0}}.fecha BETWEEN {0} AND {1}
                            AND (0={2} OR {2}={{0}}.paciente)
                            AND (0={3} OR {3}=paciente.entId)"
                , Query.GetValor(cuentas.Desde)
                , Query.GetValor(cuentas.Hasta)
                , Query.GetValor(cuentas.Paciente?.Id ?? "0")
                , cuentas.Entidad ?? 0
                );


            string query = string.Format(@"(SELECT 
                        valoracion_herida.id
                        ,valoracion_herida.paciente p
                        ,NULL t
                        ,paciente.pacDocumento d
                        ,paciente.pacNombres n
                        ,valoracion_herida.fecha f
                        ,recurso_humano.perNombre e
                        ,asegurador.entNombre a
                        FROM valoracion_herida
                        LEFT JOIN paciente ON (valoracion_herida.paciente=paciente.pacId)
                        LEFT JOIN recurso_humano ON (valoracion_herida.funcionario=recurso_humano.perId)
                        LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                        WHERE {0}
                        )", string.Format(where, "valoracion_herida"));
                        query+= string.Format(@" UNION (
                            SELECT 
                                evolucion_herida.id,evolucion_herida.paciente,1
                                ,paciente.pacDocumento
                                ,paciente.pacNombres
                                ,evolucion_herida.fecha
                                ,recurso_humano.perNombre,asegurador.entNombre
                                FROM evolucion_herida
                                LEFT JOIN paciente ON (evolucion_herida.paciente=paciente.pacId)
                                LEFT JOIN recurso_humano ON (evolucion_herida.funcionario=recurso_humano.perId)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                                WHERE {0}
                        )", string.Format(where, "evolucion_herida"));

            string querycount = @"SELECT COUNT(*) FROM (
(
SELECT valoracion_herida.id 
FROM valoracion_herida
LEFT JOIN paciente ON (valoracion_herida.paciente=paciente.pacId)
                        LEFT JOIN recurso_humano ON (valoracion_herida.funcionario=recurso_humano.perId)
                        LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                        WHERE 
" + string.Format(where, "valoracion_herida") +
@") UNION (
SELECT evolucion_herida.id
FROM evolucion_herida
                                LEFT JOIN paciente ON (evolucion_herida.paciente=paciente.pacId)
                                LEFT JOIN recurso_humano ON (evolucion_herida.funcionario=recurso_humano.perId)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                                WHERE 
" + string.Format(where, "evolucion_herida")
+ ")) t"
;

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , querycount
                    , query
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data), HomeCareVersion.JSONContentType);
            }
        }

        [HttpPost]
        public ActionResult InformeEPS(InformeEPS cuentas)
        {
            if (ModelState.IsValid)
            {
                string where = string.Format(@"{{0}}.fecha BETWEEN {0} AND {1}
                            AND (0={2} OR {2}={{0}}.paciente)
                            AND (0={3} OR {3}=paciente.entId)"
                , Query.GetValor(cuentas.Desde)
                , Query.GetValor(cuentas.Hasta)
                , Query.GetValor(cuentas.Paciente?.Id ?? "0")
                , cuentas.Entidad ?? 0
                );

                if (cuentas.PDF == 1)
                {
                    // return pdf
                    string query = string.Format(@"(SELECT 
                        valoracion_herida.id
                        ,valoracion_herida.paciente
                        ,NULL t
                        FROM valoracion_herida
                        LEFT JOIN paciente ON (valoracion_herida.paciente=paciente.pacId)
                        LEFT JOIN recurso_humano ON (valoracion_herida.funcionario=recurso_humano.perId)
                        LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                        WHERE {0}
                        )", string.Format(where, "valoracion_herida"));
                    query += string.Format(@" UNION (
                            SELECT 
                                evolucion_herida.id
                                ,evolucion_herida.paciente
                                ,1
                                FROM evolucion_herida
                                LEFT JOIN paciente ON (evolucion_herida.paciente=paciente.pacId)
                                LEFT JOIN recurso_humano ON (evolucion_herida.funcionario=recurso_humano.perId)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                                WHERE {0}
                        )", string.Format(where, "evolucion_herida"));

                    using (CConector conector = new CConector()) {
                        MySqlDataReader reader= conector.Query(query);
                        if (reader != null) {
                            StringBuilder htmlcompleto = new StringBuilder();
                            Regex regx = new Regex(".*<body.*?>(?<theBody>.*)\n.*</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);

                            while (reader.Read()) {
                                string id = reader["id"].ToString();
                                string paciente = reader["paciente"].ToString();
                                string html = null;
                                if (reader["t"].ToString() == "1") { // evolucion
                                    html = HomeCareVersion.DownloadURLAuth(this, string.Format("{0}/{1}?pid={2}&ehid={3}&p=1", HomeCareVersion.GetURLLocalhost(), Url.Content("~/ClinicaHeridas/evolucion.aspx"), paciente, id));
                                } else { // valoracion
                                    html = HomeCareVersion.DownloadURLAuth(this, string.Format("{0}/{1}?pid={2}&hveid={3}&pd=1", HomeCareVersion.GetURLLocalhost(), Url.Content("~/ClinicaHeridas/Valoracion"), paciente, id));
                                }
                                if (htmlcompleto.Length==0)
                                {
                                    htmlcompleto.Append(html);
                                    htmlcompleto.Replace("</body>", "");
                                    htmlcompleto.Replace("</html>", "");
                                } else {
                                    Match match= regx.Match(html);
                                    if (match.Success) {
                                        htmlcompleto.Append(match.Groups[1].Value);
                                    }
                                }
                            }
                            htmlcompleto.Append("</body>");
                            htmlcompleto.Append("</html>");
                            return PDFConverter.RenderPDF(this, "Valoración de heridas", htmlcompleto.ToString());
                        }
                    }
                }
                else
                {

                    string query = string.Format(@"(SELECT 
                        valoracion_herida.fecha 'Fecha'                        
                        ,paciente.pacDocumento 'Documento'
                        ,paciente.pacNombres 'Paciente'
                        ,asegurador.entNombre 'Asegurador'
                        ,recurso_humano.perNombre 'Funcionario'
                        FROM valoracion_herida
                        LEFT JOIN paciente ON (valoracion_herida.paciente=paciente.pacId)
                        LEFT JOIN recurso_humano ON (valoracion_herida.funcionario=recurso_humano.perId)
                        LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                        WHERE {0}
                        )", string.Format(where, "valoracion_herida"));
                    query += string.Format(@" UNION (
                            SELECT 
                                evolucion_herida.fecha
                                ,paciente.pacDocumento
                                ,paciente.pacNombres
                                ,asegurador.entNombre
                                ,recurso_humano.perNombre
                                FROM evolucion_herida
                                LEFT JOIN paciente ON (evolucion_herida.paciente=paciente.pacId)
                                LEFT JOIN recurso_humano ON (evolucion_herida.funcionario=recurso_humano.perId)
                                LEFT JOIN asegurador ON (asegurador.entId=paciente.entId)
                                WHERE {0}
                        )", string.Format(where, "evolucion_herida"));

                    CUsuario usuario = ViewBag.User;
                    if (!Excel.SaveExcel(this, usuario, "Informe EPS", query))
                    {
                        return HttpNotFound();
                    }
                }
                return new EmptyResult();
            }
            return View(cuentas);
        }

        public ActionResult InformeEPS()
        {
            CUsuario usuario = ViewBag.User;
            InformeEPS cuentas = new InformeEPS();
            cuentas.Desde = Query.GetMySQLDateFormat(DateTime.Now.AddDays(-30));
            cuentas.Hasta = Query.GetMySQLDateFormat(DateTime.Now);
            cuentas.Paciente.Entidades = usuario["entidades"];

            ViewBag.Excel = 1;
            ViewBag.PDF = 1;

            return View(cuentas);
        }
    }
}