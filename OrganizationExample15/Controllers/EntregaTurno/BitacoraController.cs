using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models.EntregaTurno;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using SDG.Componentes;

namespace OrganizationExample15.Controllers
{
    public class EntregaTurnoController : BaseController
    {
        public ActionResult __Bitacora(int current, int rowCount, Dictionary<string, string> sort, BitacoraFilter filter, string searchPhrase = null)
        {
            if (filter == null)
                return HttpNotFound();

            CUsuario usuario = ViewBag.User;
            string where = string.Format(@"bitacora_turno.bitFecha BETWEEN {0} AND {1}
                AND ({2}=0 OR bitacora_turno.tpaId={2})
                AND ({3}=0 OR bitacora_turno.NAdministrativa = {3})
                AND ({4} = 0 OR bitacora_turno.NServicio = {4})
                AND ({5} = 0 OR bitacora_turno.pacId = {5})
                AND ({6}=0 OR bitacora_turno.estado={6})
"
, Query.GetValor(filter.Desde)
, Query.GetValor(filter.Hasta)
, filter.Tipo ?? 0
, filter.NovedadAdministrativa ?? 0
, filter.NovedadServicio ?? 0
, filter.Paciente?.Id ?? "0"
, filter.Estado ?? 0
);
            if (!string.IsNullOrEmpty(searchPhrase))
            {
                foreach (string text in searchPhrase.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    where += string.Format(" AND bitacora_turno.bitObservaciones LIKE CONCAT('%',{0},'%') ", Query.GetValor(text));
                }
            }

            Query query = new Query("bitacora_turno");

            query["id"] = "bitacora_turno.bitId";
            query["f"] = "bitacora_turno.bitFecha";
            query["o"] = "bitacora_turno.bitObservaciones";
            query["t"] = "tipo_actividad.tpaDescripcion";
            query["ns"] = "nservicio.nombre";
            query["na"] = "nadministrativa.nombre";
            query["p"] = "paciente.pacNombres";

            string join = @"LEFT JOIN tipo_actividad ON (tipo_actividad.tpaId=bitacora_turno.tpaId)
                    LEFT JOIN paciente ON (paciente.pacId=bitacora_turno.pacId)
                    LEFT JOIN varios nservicio ON (nservicio.id=bitacora_turno.NServicio)
                    LEFT JOIN varios nadministrativa ON (nadministrativa.id=bitacora_turno.NAdministrativa)
                    ";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM bitacora_turno " + join + " WHERE " + where
                    , query.GetSelect(where, join)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data, HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
            }
        }

        [NonAction]
        protected static Bitacora GetBitacora(CConector conector, string id)
        {
            Bitacora item = new Bitacora();
            Query query = new Query("bitacora_turno");

            query += "bitacora_turno.bitId";
            query += "bitacora_turno.bitFecha";
            query += "bitacora_turno.bitObservaciones";
            query += "bitacora_turno.tpaId";
            query += "bitacora_turno.NAdministrativa";
            query += "bitacora_turno.NServicio";
            query += "bitacora_turno.pacId";
            query += "segUsuarioRegistro";
            query += "estado";

            MySqlDataReader reader = conector.Query(query.GetSelect("bitId=" + Query.GetValor(id)));
            if (reader != null && reader.Read())
            {
                item.Id = reader["bitId"].ToString();
                item.Fecha = Query.GetFromMySQLDate(reader["bitFecha"]);
                item.Observaciones = reader["bitObservaciones"].ToString();
                item.Tipo = reader["tpaId"] as short?;
                item.Paciente.Id = reader["pacId"].ToString();
                item.NovedadAdministrativa = reader["NAdministrativa"] as long?;
                item.NovedadServicio = reader["NServicio"] as long?;
                item.Estado = reader["estado"] as ulong?;
                item.NombreFuncionario = reader["segUsuarioRegistro"].ToString();
            }
            return item;
        }

        [HttpGet]
        [HomeCarePolicy("~/EntregaTurno/Bitacora", Usuario.Permisos.Print | Usuario.Permisos.Read)]
        public ActionResult _Bitacora(string id, uint? pdf, uint? pd)
        {
            Bitacora item = new Bitacora();

            if (!string.IsNullOrEmpty(id))
            {
                using (CConector conector = new CConector())
                {
                    item = GetBitacora(conector, id);
                    if (!string.IsNullOrEmpty(item.Id))
                    {
                        if (pd == 1)
                        {
                            return View("BitacoraPrint", item);
                        }
                        if (pdf == 1)
                        {
                            PDFConverter.RenderPDF(this, "Bitácora", "BitacoraPrint", item);
                            return new EmptyResult();
                        }
                    }
                }
            }

            return PartialView(item);
        }

        [HttpPost]
        public ActionResult ___Bitacora(string id)
        {
            using (CConector conector = new CConector())
            {
                CUsuario user = ViewBag.User;
                conector.StartTransaction();
                Query query = new Query("bitacora_seguimiento");

                if (conector.QueryMod(query.GetDelete("bitId={0}", Query.GetValor(id))) == -1 || conector.InsertModificacion(id) == -1)
                {
                    return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                }

                conector.Commit();
                return Content(string.Format("$('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Bitácora eliminada"))));
            }
        }

        [HttpPost]
        public ActionResult _Bitacora(Bitacora item)
        {
            if (ModelState.IsValid)
            {
                using (CConector conector = new CConector())
                {
                    string id = item.Id;
                    CUsuario user = ViewBag.User;
                    if ((!user.CanInsert() && string.IsNullOrEmpty(id)) || (!user.CanUpdate() && !string.IsNullOrEmpty(id)))
                    {
                        return HttpNotFound();
                    }

                    conector.StartTransaction();

                    Query query = new Query("bitacora_turno");

                    query["bitFecha"] = Query.GetMySQLDateFormat(item.Fecha);
                    query["bitObservaciones"] = item.Observaciones;
                    query["tpaId"] = item.Tipo;
                    query["NAdministrativa"] = item.NovedadAdministrativa;
                    query["NServicio"] = item.NovedadServicio;
                    query["pacId"] = item.Paciente.Id;
                    query["estado"] = item.Estado;

                    if (string.IsNullOrEmpty(id))
                    {
                        query["segUsuarioRegistro"] = user.Login;
                        query["segFechaRegistro"] = "NOW()";

                        int res = conector.QueryMod(query.GetInsert(), true);
                        if (res == -1)
                        {
                            return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                        }
                        id = res.ToString();
                    }
                    else
                    {
                        if (conector.QueryMod(query.GetUpdate("bitId=" + Query.GetValor(id))) == -1)
                        {
                            return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                        }
                    }
                    if (conector.InsertModificacion(id) == -1)
                    {
                        return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                    }

                    conector.Commit();

                    return Content(string.Format("$('#PP').modal('hide'); $('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Bitácora editada"))));
                }
            }
            return PartialView(item);
        }

        [HttpPost]
        public ActionResult Bitacora(BitacoraFilter filter) {
            if (ModelState.IsValid) {
                CUsuario usuario = ViewBag.User;

                string where = string.Format(@"bitacora_turno.bitFecha BETWEEN {0} AND {1}
                AND ({2}=0 OR bitacora_turno.tpaId={2})
                AND ({3}=0 OR bitacora_turno.NAdministrativa = {3})
                AND ({4} = 0 OR bitacora_turno.NServicio = {4})
                AND ({5} = 0 OR bitacora_turno.pacId = {5})
                AND ({6}=0 OR bitacora_turno.estado={6})
ORDER BY bitacora_turno.bitFecha"
, Query.GetValor(filter.Desde)
, Query.GetValor(filter.Hasta)
, filter.Tipo ?? 0
, filter.NovedadAdministrativa ?? 0
, filter.NovedadServicio ?? 0
, filter.Paciente?.Id ?? "0"
, filter.Estado ?? 0
);
                Query query = new Query("bitacora_turno");

                if (filter.PDF == 1 || filter.Print == 1)
                {
                    query["id"] = "bitacora_turno.bitId";
                    query["pacId"] = "bitacora_turno.pacId";

                    string join = @"LEFT JOIN tipo_actividad ON (tipo_actividad.tpaId=bitacora_turno.tpaId)
                    LEFT JOIN paciente ON (paciente.pacId=bitacora_turno.pacId)
                    LEFT JOIN varios nservicio ON (nservicio.id=bitacora_turno.NServicio)
                    LEFT JOIN varios nadministrativa ON (nadministrativa.id=bitacora_turno.NAdministrativa)
                    ";

                    string oldPaciente = "";

                    using (CConector conectorr= new CConector())
                    using (CConector conector = new CConector())
                    {
                        MySqlDataReader reader = conector.Query(query.GetSelect(where, join));
                        if (reader != null)
                        {
                            StringBuilder htmlcompleto = new StringBuilder();

                            while (reader.Read())
                            {
                                string id = reader["id"].ToString();
                                string paciente = reader["pacId"].ToString();
                                Bitacora bitacora = GetBitacora(conectorr, id);
                                bitacora.OmitirEncabezado = oldPaciente == paciente;
                                oldPaciente = paciente;

                                string html =  PDFConverter.RenderViewToString(ControllerContext, "BitacoraPrint", bitacora);
                                if (htmlcompleto.Length == 0)
                                {
                                    htmlcompleto.Append(html);
                                    htmlcompleto.Replace("</body>", "");
                                    htmlcompleto.Replace("</html>", "");
                                }
                                else
                                {
                                    Match match = PDFConverter.RegexHtmlBody.Match(html);
                                    if (match.Success)
                                    {
                                        htmlcompleto.Append(match.Groups[1].Value);
                                    }
                                }
                            }
                            htmlcompleto.Append("</body>");
                            htmlcompleto.Append("</html>");
                            return filter.Print == 1 ? Content(htmlcompleto.ToString()) : PDFConverter.RenderPDF(this, "Bitacoras", htmlcompleto.ToString());
                        }
                    }
                } else { // save excel
                    query["Fecha"] = "bitacora_turno.bitFecha";
                    query["Tipo"] = "tipo_actividad.tpaDescripcion";
                    query["Novedad administrativa"] = "nservicio.nombre";
                    query["Novedad de servicio"] = "nadministrativa.nombre";
                    query["Paciente"] = "paciente.pacNombres";
                    query["Observaciones"] = "bitacora_turno.bitObservaciones";

                    string join = @"LEFT JOIN tipo_actividad ON (tipo_actividad.tpaId=bitacora_turno.tpaId)
                    LEFT JOIN paciente ON (paciente.pacId=bitacora_turno.pacId)
                    LEFT JOIN varios nservicio ON (nservicio.id=bitacora_turno.NServicio)
                    LEFT JOIN varios nadministrativa ON (nadministrativa.id=bitacora_turno.NAdministrativa)
                    ";

                    using (CConector conector = new CConector())
                    {
                        GridUtils.ExportExcelXLSX(Response, conector, query.GetSelect(where, join), Server.MapPath("~/xlsx/"), "Informe EPS", usuario.Nombre);
                    }
                }
            }
            return View(filter);
        }

        // GET: Bitacora
        public ActionResult Bitacora()
        {
            BitacoraFilter filter = new BitacoraFilter();
            filter.Desde = Query.GetMySQLDateFormat(DateTime.Now);
            filter.Hasta = Query.GetMySQLDateFormat(DateTime.Now);

            ViewBag.Excel = 1;
            ViewBag.PDF = 1;
            ViewBag.Print = 1;

            return View(filter);
        }
    }
}