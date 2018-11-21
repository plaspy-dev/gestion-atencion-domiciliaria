using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models;
using OrganizationExample15.Models.ClinicaHeridas;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using SDG.Componentes;

namespace OrganizationExample15.Controllers
{
    public partial class ClinicaHeridasController : BaseController
    {
        [NonAction]
        public static BootgridResponseData GetBootGridEvolucion(int current, int rowCount, Dictionary<string, string> sort, string pid) {

            string where = string.Format(" evolucion_herida.paciente={0}", Query.GetValor(pid));

            Query query = new Query("evolucion_herida");

            query["id"] = "evolucion_herida.id";
            query["pid"] = "evolucion_herida.paciente";
            query["f"] = "evolucion_herida.fecha";
            query["p"] = "recurso_humano.perNombre";

            string join = "LEFT JOIN recurso_humano ON (recurso_humano.perId=evolucion_herida.funcionario)";

            using (CConector conector = new CConector())
            {
                return BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM evolucion_herida WHERE " + where
                    , query.GetSelect(where, join)
                    , current
                    , rowCount
                    , sort
                    );
            }
        }

        [HttpPost]
        public ActionResult __Evolucion(int current, int rowCount, Dictionary<string, string> sort, uint pid) {

            return Content(JsonConvert.SerializeObject(GetBootGridEvolucion(current, rowCount, sort, pid.ToString()), HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
        }

        [NonAction]
        public void LoadHeridas(CConector conector, CUsuario usuario, Evolucion evolucion, string id, bool isevolucion) {

            Query query = new Query(isevolucion ? "evolucion_herida_herida" : "valoracion_herida_herida");

            query += "id";
            query += "localizacion";
            query += "localizacion2";
            query += "localizacion3";
            query += "mi";
            query += "pies";
            query += "ubicacion_especifica";
            query += "etiologia";
            query += "etiologia_otro";
            query += "clasificacion";
            query += "factores_riesgo";
            query += "longitud";
            query += "anchura";
            query += "profundidad";
            query += "tunelizacion";
            query += "cavidad";
            query += "bolsillo_tamano";
            query += "bolsillo_ubicacion";
            query += "tipo_tejido";
            query += "compacto";
            query += "fibrina";
            query += "epitelizacion";
            query += "escara";
            query += "granulacion";
            query += "hipergranulacion";
            query += "limpio";
            query += "necrosis";
            query += "seleccion_tejido";
            query += "exudado";
            query += "tipo_exudado";
            query += "piel_circundante";
            query += "bordes_herida";
            query += "olor";
            query += "olor_descripcion";
            query += "signos_sintomas";
            query += "exudado_complicacion";
            query += "exudado_definicion";
            if (isevolucion) {
                query += "cambio_herida";
                query += "signo_infeccion";
            }

            List<Heridas> heridas = new List<Heridas>();

            MySqlDataReader reader = conector.Query(query.GetSelect("{0}={1}", null, isevolucion ? "evolucion" : "valoracion", Query.GetValor(id)));
            if (reader != null)
            {
                while (reader.Read())
                {

                    Herida herida = new Herida();

                    herida.Evolucion = true;
                    herida.Id = reader["id"].ToString();
                    herida.Localizacion = reader["localizacion"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["localizacion"]);
                    herida.Localizacion2 = reader["localizacion2"] == DBNull.Value ? 0 : (uint?)Convert.ToUInt32(reader["localizacion2"]);
                    herida.Localizacion3 = reader["localizacion3"] == DBNull.Value ? 0 : (uint?)Convert.ToUInt32(reader["localizacion3"]);
                    herida.MiembrosInferiores = reader["mi"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["mi"]);
                    herida.Pies = reader["pies"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["pies"]);
                    herida.UbicacionEspecifica = reader["ubicacion_especifica"].ToString();
                    herida.Etiologia = reader["etiologia"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["etiologia"]);
                    herida.OtroEtiologia = reader["etiologia_otro"].ToString();
                    herida.Clasificacion = reader["clasificacion"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["clasificacion"]);
                    herida.FactoresRiesgo = reader["factores_riesgo"].ToString();
                    herida.Longitud = reader["longitud"] == DBNull.Value ? null : string.Format(CultureInfo.InvariantCulture, "{0}", reader["longitud"]);
                    herida.Anchura = reader["anchura"] == DBNull.Value ? null : string.Format(CultureInfo.InvariantCulture, "{0}", reader["anchura"]);
                    herida.Profundidad = reader["profundidad"] == DBNull.Value ? null : string.Format(CultureInfo.InvariantCulture, "{0}", reader["profundidad"]);
                    herida.Tunelizacion = reader["tunelizacion"] != DBNull.Value;
                    herida.TunelizacionParametro = reader["tunelizacion"] == DBNull.Value ? null : string.Format(CultureInfo.InvariantCulture, "{0}", reader["tunelizacion"]);
                    herida.Cavidad = reader["cavidad"] == DBNull.Value ? null : string.Format(CultureInfo.InvariantCulture, "{0}", reader["cavidad"]);
                    herida.Bolsillo = reader["bolsillo_tamano"] != DBNull.Value;
                    herida.BolsilloProfundidad = reader["bolsillo_tamano"].ToString();
                    herida.BolsilloUbicacion = reader["bolsillo_ubicacion"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["bolsillo_ubicacion"]);
                    herida.TejidoNecrotico = reader["tipo_tejido"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["tipo_tejido"]);
                    herida.TejidoCompacto = reader["compacto"].ToString();
                    herida.TejidoFibrina = reader["fibrina"].ToString();
                    herida.TejidoEpitelizacion = reader["epitelizacion"].ToString();
                    herida.TejidoEsfacelo = reader["escara"].ToString();
                    herida.TejidoGranulacion = reader["granulacion"].ToString();
                    herida.TejidoHiperGranulacion = reader["hipergranulacion"].ToString();
                    herida.TejidoLimpioNoGranulado = reader["limpio"].ToString();
                    herida.TejidoNecrosis = reader["necrosis"].ToString();
                    herida.TejidoExposicion = reader["seleccion_tejido"].ToString();
                    herida.Exudado = reader["exudado"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["exudado"]);
                    herida.ExudadoTipo = reader["tipo_exudado"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["tipo_exudado"]);
                    herida.ExudadoPiel = reader["piel_circundante"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["piel_circundante"]);
                    herida.ExudadoBordes = reader["bordes_herida"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["bordes_herida"]);
                    herida.ExudadoOlor = reader["olor"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["olor"]);
                    herida.ExudadoDescripcion = reader["olor_descripcion"].ToString();
                    herida.ExudadoSignos = reader["signos_sintomas"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["signos_sintomas"]);
                    herida.ExudadoComplicaciones = reader["exudado_complicacion"] != DBNull.Value;
                    herida.ExudadodComplicacionesParametro = reader["exudado_complicacion"].ToString();
                    herida.ExudadoClasificacion = reader["exudado_definicion"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["exudado_definicion"]);

                    if (isevolucion)
                    {
                        herida.CambioHerida = reader["cambio_herida"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["cambio_herida"]);
                        herida.SignoInfeccion= reader["signo_infeccion"].ToString();
                    }

                    herida.Galeria = new Galeria();
                    herida.Galeria.CanDelete =
                        herida.Galeria.CanUpload = string.IsNullOrEmpty(evolucion.Id) ? usuario.CanInsert() : usuario.CanUpdate();
                    if (id == evolucion.Id)
                    {
                        string path = string.Join("/", new string[] { evolucion.Id, herida.Id });
                        foreach (string file in FileStorage.ListFiles(FileStorage.Types.evolucion, path))
                        {
                            herida.Galeria.Files.Add(Url.Content(FileStorage.GetPublicURLPath(FileStorage.Types.evolucion, path + "/" + file)));
                        }
                    }

                    evolucion.Heridas.Add(herida);
                }
            }
        }

        public ActionResult Evolucion(uint? pid, uint? ehid)
        {
            CUsuario usuario = ViewBag.User;
            Evolucion evolucion = new Evolucion();

            evolucion.Paciente.ShowLabel = true;
            evolucion.Funcionario.Required = true;

            if (pid!=null)
            {
                evolucion.Paciente.Id = pid.ToString();
                evolucion.Funcionario.Id= usuario["personal"];
                evolucion.Funcionario.ReadOnly = !usuario.CanAdmin();
                if (string.IsNullOrEmpty(evolucion.Paciente.Nombre)) {
                    return Redirect(Request.Url.AbsolutePath);
                }
                evolucion.ProtectedFields["pid"] = pid.ToString();
                
                evolucion.Galeria.CanDelete =
                    evolucion.Galeria.CanUpload = usuario.CanInsert();
                evolucion.Galeria.FileMimeTypes = FileStorage.ValidMimeImages;
                evolucion.Galeria.FileType = FileStorage.ValidImages;

                ViewBag._Layout.Params= string.Format("?pid=" + pid);

                evolucion.Fecha= Query.GetFromMySQLDate(DateTime.Now, true);
                MySqlDataReader reader;

                using (CConector conector = new CConector())
                {
                    Query query = new Query("evolucion_herida");
                    if (ehid != null)
                    {
                        query += "id";
                        query += "paciente";
                        query += "fecha";
                        query += "ta";
                        query += "fc";
                        query += "fr";
                        query += "t";
                        query += "pulsosdistales";
                        query += "observacion_pulso";
                        query += "funcionario";
                        query += "manejo";
                        query += "otros";

                        reader = conector.Query(query.GetSelect("paciente={0} AND id={1} ORDER BY id DESC LIMIT 1", null, Query.GetValor(pid), Query.GetValor(ehid)));
                        if (reader != null && reader.Read())
                        {
                            evolucion.ProtectedFields["id"] =
                            evolucion.Id = reader["id"].ToString();

                            evolucion.Galeria.CanDelete =
                                evolucion.Galeria.CanUpload = usuario.CanUpdate();

                            if (usuario.CanPrint())
                            {
                                ViewBag.Print = true;
                                ViewBag.PDF = true;
                            }

                            evolucion.Fecha = Query.GetFromMySQLDate(reader["fecha"], true);
                            evolucion.Funcionario.Id = reader["funcionario"].ToString();
                            evolucion.TA = reader["ta"].ToString();
                            evolucion.FC = reader["fc"].ToString();
                            evolucion.FR = reader["fr"].ToString();
                            evolucion.T = string.Format(CultureInfo.InvariantCulture, "{0:0.#}", Convert.ToSingle(reader["t"]));
                            evolucion.PulsosDistales = reader["pulsosdistales"].ToString();
                            evolucion.ObservacionesPulso = reader["observacion_pulso"].ToString();
                            evolucion.Manejo = reader["manejo"].ToString();
                            evolucion.Otros = reader["otros"].ToString();

                            string procedimientos = Procedimientos.GetPlanDeManejo(conector, pid.ToString(), evolucion.Fecha);
                            if (!string.IsNullOrEmpty(procedimientos))
                            {
                                evolucion.ProtectedFields["procedimientos"]= procedimientos;
                                evolucion.Manejo = procedimientos;
                            }

                            LoadHeridas(conector, usuario, evolucion, evolucion.Id, true);

                            query = new Query("evolucion_herida_educativo");

                            query += "concepto";
                            query += "valor";

                            reader = conector.Query(query.GetSelect("evolucion={0}", null, Query.GetValor(evolucion.Id)));
                            if (reader != null)
                            {
                                while (reader.Read())
                                {
                                    CheckTextParam info = evolucion.ComponenteEducativo.Find(x => x.Id == Convert.ToUInt32(reader["concepto"]));
                                    if (info == null)
                                    {
                                        info = new CheckTextParam() { Id = Convert.ToUInt32(reader["concepto"]) };
                                        evolucion.ComponenteEducativo.Add(info);
                                    }
                                    info.Check = reader["valor"].ToString() == "1";
                                }
                            }

                            query = new Query("evolucion_herida_clinica");

                            query += "concepto";
                            query += "valor";

                            reader = conector.Query(query.GetSelect("evolucion={0}", null, Query.GetValor(evolucion.Id)));
                            if (reader != null)
                            {
                                while (reader.Read())
                                {
                                    CheckTextParam info = evolucion.SeguridadPaciente.Find(x => x.Id == Convert.ToUInt32(reader["concepto"]));
                                    if (info == null)
                                    {
                                        info = new CheckTextParam() { Id = Convert.ToUInt32(reader["concepto"]) };
                                        evolucion.SeguridadPaciente.Add(info);
                                    }
                                    info.Check = reader["valor"].ToString() == "1";
                                }
                            }
                        }
                    }
                    // Fin using
                    query = new Query("valoracion_herida");

                    query += "id";
                    query += "fecha";

                    DateTime date = Convert.ToDateTime(evolucion.Fecha);
                    DateTime fechaEvolucion = DateTime.MinValue;
                    DateTime fechaValoracion = DateTime.MinValue;

                    reader = conector.Query(query.GetSelect("paciente={0} AND fecha<={1} ORDER BY id DESC LIMIT 1", null, Query.GetValor(pid), Query.GetValor(Query.GetMySQLDateFormat(date, true))));
                    if (reader != null && reader.Read())
                    {
                        evolucion.IdValoracion = reader["id"].ToString();
                        fechaValoracion = (DateTime)reader["fecha"];
                        evolucion.ValoracionIncial = Query.GetFromMySQLDate(fechaValoracion);
                        
                        TimeSpan ts = date - fechaValoracion;
                        evolucion.DiasValoracion= ts.Days;
                    }

                    query = new Query("evolucion_herida");

                    query += "id";
                    query += "fecha";

                    reader = conector.Query(query.GetSelect("paciente={0} AND fecha<={1} ORDER BY id DESC LIMIT 1", null, Query.GetValor(pid), Query.GetValor(Query.GetMySQLDateFormat(date, true))));
                    if (reader != null && reader.Read())
                    {
                        evolucion.IdUltimaEvolucion = reader["id"].ToString();
                        fechaEvolucion = (DateTime)reader["fecha"];
                        evolucion.UltimaEvolucion = Query.GetFromMySQLDate(fechaEvolucion);

                        TimeSpan ts = date - fechaEvolucion;
                        evolucion.DiasUltimaEvolucion = ts.Days;
                    }

                    if (evolucion.Heridas.Count == 0) { // Cargamos las heridas por defecto
                        LoadHeridas(conector, usuario, evolucion, fechaEvolucion > fechaValoracion ? evolucion.IdUltimaEvolucion : evolucion.IdValoracion, fechaEvolucion > fechaValoracion);
                    }
                }
            }

            if (Request.QueryString["pd"] == "1")
                return View("Evolucion_Print", evolucion);
            if (Request.QueryString["pdf"] == "1")
                return PDFConverter.RenderPDF(this, "Evolución de heridas", "Evolucion_Print", evolucion);

            return View(evolucion);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Evolucion(Evolucion evolucion) {
            if (ModelState.IsValid) {

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

                    Query query = new Query("evolucion_herida");

                    query["fecha"]= Query.GetMySQLDateFormat(evolucion.Fecha);
                    query["ta"]= evolucion.TA?.Split(' ')[0];
                    query["fc"]= evolucion.FC?.Split(' ')[0];
                    query["fr"] = evolucion.FR?.Split(' ')[0];
                    query["t"] = evolucion.T?.Split(' ')[0];
                    query["pulsosdistales"] = evolucion.PulsosDistales;
                    query["observacion_pulso"] = evolucion.ObservacionesPulso;
                    query["funcionario"] = evolucion.Funcionario.Id;
                    query["otros"] = evolucion.Otros;
                    query["manejo"] = (string.IsNullOrEmpty(evolucion.ProtectedFields["procedimientos"]) || evolucion.Manejo != evolucion.ProtectedFields["procedimientos"])
                        ? evolucion.Manejo
                        : null;

                    if (string.IsNullOrEmpty(id))
                    {
                        query["paciente"] = pacienteid;
                        query["asegurador"] = Paciente.GetPaciente(pacienteid).entidadId;

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

                    foreach (Herida herida in evolucion.Heridas) {

                        query = new Query("evolucion_herida_herida");
                        if (herida.Eliminado==true && !string.IsNullOrEmpty(herida.Id)) {
                            if (conector.QueryMod(query.GetDelete("id={0} AND evolucion={1}",  Query.GetValor(herida.Id), Query.GetValor(id))) == -1)
                            {
                                ModelState.AddModelError("", conector.LastError);
                                return View(evolucion);
                            }
                        }
                        string heridaid = herida.Id;

                        query["localizacion"]= herida.Localizacion;
                        query["localizacion2"] = herida.Localizacion2;
                        query["localizacion3"] = herida.Localizacion3;
                        query["mi"] = herida.MiembrosInferiores;
                        query["pies"] = herida.Pies;
                        query["ubicacion_especifica"]=herida.UbicacionEspecifica;
                        query["etiologia"] = herida.Etiologia;
                        query["etiologia_otro"]=herida.OtroEtiologia;
                        query["clasificacion"] = herida.Clasificacion;
                        query["factores_riesgo"]= herida.FactoresRiesgo;
                        query["longitud"]=herida.Longitud;
                        query["anchura"]=herida.Anchura;
                        query["profundidad"] = herida.Profundidad;
                        query["tunelizacion"] = herida.Tunelizacion ? herida.TunelizacionParametro : null;
                        query["cavidad"] = herida.Cavidad;
                        query["bolsillo_tamano"] = herida.Bolsillo ? herida.BolsilloProfundidad : null;
                        query["bolsillo_ubicacion"]= herida.Bolsillo ? herida.BolsilloUbicacion : null;
                        query["tipo_tejido"]=herida.TejidoNecrotico;
                        query["compacto"]= herida.TejidoCompacto;
                        query["fibrina"]=herida.TejidoFibrina;
                        query["epitelizacion"]=herida.TejidoEpitelizacion;
                        query["escara"]=herida.TejidoEsfacelo;
                        query["granulacion"]=herida.TejidoGranulacion;
                        query["hipergranulacion"]= herida.TejidoHiperGranulacion;
                        query["limpio"]=herida.TejidoLimpioNoGranulado;
                        query["necrosis"]= herida.TejidoNecrosis;
                        query["seleccion_tejido"]= herida.TejidoExposicion;
                        query["exudado"] = herida.Exudado;
                        query["tipo_exudado"] = herida.ExudadoTipo;
                        query["piel_circundante"] = herida.ExudadoPiel;
                        query["bordes_herida"] = herida.ExudadoBordes;
                        query["olor"] = herida.ExudadoOlor;
                        query["olor_descripcion"]=herida.ExudadoDescripcion;
                        query["signos_sintomas"] = herida.ExudadoSignos;
                        query["exudado_complicacion"]= herida.ExudadoComplicaciones ? herida.ExudadodComplicacionesParametro : null;
                        query["exudado_definicion"]= herida.ExudadoClasificacion;
                        query["cambio_herida"] = herida.CambioHerida;
                        query["signo_infeccion"] = herida.SignoInfeccion;

                        // Estas son las llaves primarias
                        query["evolucion"] = id;
                        query["id"] = herida.Id;

                        if (conector.QueryMod(query.GetInsertUpdate()) == -1)
                        {
                            ModelState.AddModelError("", conector.LastError);
                            return View(evolucion);
                        }

                        foreach (string file in herida.Galeria.Files) {
                            if (file.StartsWith("~/") || file.StartsWith("/"))
                                continue;
                            FileStorage.CopyTempFile(conector, FileStorage.Types.evolucion, file, null, id, heridaid);
                        }
                    }

                    Query educativo = new Query("evolucion_herida_educativo");
                    if (conector.QueryMod(educativo.GetDelete("evolucion=" + Query.GetValor(id))) == -1)
                    {
                        ModelState.AddModelError("", conector.LastError);
                        return View(evolucion);
                    }

                    educativo["evolucion"] = id;

                    foreach (var info in evolucion.ComponenteEducativo)
                    {
                        if (info.Check)
                        {
                            educativo["concepto"] = info.Id;
                            educativo["valor"] = "1";

                            if (conector.QueryMod(educativo.GetInsert()) == -1)
                            {
                                ModelState.AddModelError("", conector.LastError);
                                return View(evolucion);
                            }
                        }
                    }

                    Query seguridadpaciente = new Query("evolucion_herida_clinica");
                    if (conector.QueryMod(seguridadpaciente.GetDelete("evolucion=" + Query.GetValor(id))) == -1)
                    {
                        ModelState.AddModelError("", conector.LastError);
                        return View(evolucion);
                    }

                    seguridadpaciente["evolucion"] = id;

                    foreach (var info in evolucion.SeguridadPaciente)
                    {
                        if (info.Check)
                        {
                            seguridadpaciente["concepto"] = info.Id;
                            seguridadpaciente["valor"] = "1";

                            if (conector.QueryMod(seguridadpaciente.GetInsert()) == -1)
                            {
                                ModelState.AddModelError("", conector.LastError);
                                return View(evolucion);
                            }
                        }
                    }

                    if (conector.InsertModificacion(id) == -1)
                    {
                        ModelState.AddModelError("", conector.LastError);
                        return View(evolucion);
                    }

                    if (string.IsNullOrEmpty(evolucion.Id) && usuario.GetPermisosRaiz("~/App_data/Escalas") == 0)
                        usuario.SetForceURL("~/paciente/barthel.aspx?pid=" + pacienteid + "&f=" + HttpUtility.UrlEncode(Query.GetMySQLDateFormat(evolucion.Fecha, true)), conector);

                    foreach (Herida herida in evolucion.Heridas)
                    {
                        foreach (string filename in herida.Galeria._DeletedFiles)
                        {
                            FileStorage.RemoveFile(FileStorage.Types.evolucion, Path.GetFileName(filename), id, herida.Id);
                        }
                        foreach (string file in herida.Galeria.Files)
                        {
                            if (file.StartsWith("~/") || file.StartsWith("/"))
                                continue;
                            FileStorage.DeleteTempFile(conector, file);
                        }
                    }

                    conector.Commit();

                    return Redirect(Request.Url.AbsolutePath + string.Format("?spid={0}&ed=1", pacienteid));
                }

            }
            return View(evolucion);
        }
    }
}