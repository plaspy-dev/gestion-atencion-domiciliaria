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
        public static BootgridResponseData GetBootGridValoracion(int current, int rowCount, Dictionary<string, string> sort, string pid) {

            string where = string.Format(" valoracion_herida.paciente={0}", Query.GetValor(pid));

            Query query = new Query("valoracion_herida");

            query["id"] = "valoracion_herida.id";
            query["pid"] = "valoracion_herida.paciente";
            query["f"] = "CAST(DATE(valoracion_herida.fecha) AS CHAR)";
            query["p"] = "recurso_humano.perNombre";

            string join = "LEFT JOIN recurso_humano ON (recurso_humano.perId=valoracion_herida.funcionario)";

            using (CConector conector = new CConector())
            {
                return BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM valoracion_herida WHERE " + where
                    , query.GetSelect(where, join)
                    , current
                    , rowCount
                    , sort
                    );
            }
        }

        [HttpPost]
        public ActionResult __Valoracion(int current, int rowCount, Dictionary<string, string> sort, uint pid) {

            return Content(JsonConvert.SerializeObject(GetBootGridValoracion(current, rowCount, sort, pid.ToString())), HomeCareVersion.JSONContentType);
        }

        public ActionResult Valoracion(uint? pid, uint? hveid)
        {
            CUsuario usuario = ViewBag.User;
            Valoracion valoracion = new Valoracion();

            valoracion.Paciente.ShowLabel = true;
            valoracion.Funcionario.Required = true;

            /*if (hveid!=null)
            {
                using (CConector conector = new CConector())
                    Response.Redirect(string.Format("~/clinicaheridas/valoracion.aspx?pid={0}"
                        , conector.QueryString("SELECT paciente FROM valoracion_herida WHERE id=" + Query.GetValor(hveid))
                        ));
            }*/

            if (pid!=null)
            {
                valoracion.Paciente.Id = pid.ToString();
                valoracion.Funcionario.Id= usuario["personal"];
                valoracion.Funcionario.ReadOnly = !usuario.CanAdmin();
                if (string.IsNullOrEmpty(valoracion.Paciente.Nombre)) {
                    return Redirect(Request.Url.AbsolutePath);
                }
                valoracion.ProtectedFields["pid"] = pid.ToString();
                
                valoracion.Galeria.CanDelete =
                    valoracion.Galeria.CanUpload = usuario.CanInsert();
                valoracion.Galeria.FileMimeTypes = FileStorage.ValidMimeImages;
                valoracion.Galeria.FileType = FileStorage.ValidImages;

                ViewBag._Layout.Params= string.Format("?pid=" + pid);

                valoracion.Fecha= Query.GetFromMySQLDate(DateTime.Now, true);

                    using (CConector conector = new CConector())
                    {
                        Query query = new Query("valoracion_herida");

                        query += "id";
                        query += "paciente";
                        query += "fecha";
                        query += "ta";
                        query += "fc";
                        query += "fr";
                        query += "t";
                        query += "pulsosdistales";
                        query += "ostomias";
                        query += "ubicacion";
                        query += "color";
                        query += "estoma";
                        query += "complicaciones";
                        query += "estado_piel";
                        query += "tipo_dispositivo";
                        query += "funcional";
                        query += "funcional_descripcion";
                        query += "dolor";
                        query += "tiempo_evolucion_ulcera";
                        query += "lugar_origen_ulcera";
                        query += "tejido_profundo";
                        query += "manejo";
                        query += "costomias";
                        query += "cdispositivos_medicos";
                        query += "hogar_geriatrico";
                        query += "consentimiento";
                        query += "periodicidad";
                        query += "fistula";
                        query += "localizacion_fistula";
                        query += "signos_infeccion";
                        query += "cantidad_afluente";
                        query += "observacion_pulso";
                        query += "funcionario";

                        MySqlDataReader reader = conector.Query(query.GetSelect("paciente={0} AND ({1} IS NULL OR id={1}) ORDER BY id DESC LIMIT 1", null, Query.GetValor(pid), Query.GetValor(hveid)));
                        if (reader != null && reader.Read())
                        {
                            valoracion.ProtectedFields["id"]=
                            valoracion.Id = reader["id"].ToString();

                            valoracion.Galeria.CanDelete =
                                valoracion.Galeria.CanUpload = usuario.CanUpdate();

                        if (usuario.CanPrint())
                        {
                            ViewBag.Print = true;
                            ViewBag.PDF = true;
                        }

                        valoracion.Fecha= Query.GetFromMySQLDate(reader["fecha"]);
                            valoracion.Funcionario.Id = reader["funcionario"].ToString();
                            valoracion.TA = reader["ta"].ToString();
                            valoracion.FC = reader["fc"].ToString();
                            valoracion.FR = reader["fr"].ToString();
                            valoracion.T = string.Format(CultureInfo.InvariantCulture, "{0:0.#}", Convert.ToSingle(reader["t"]));
                        valoracion.PulsosDistales= reader["pulsosdistales"].ToString();
                        valoracion.TipoOstomia= reader["ostomias"].ToString();
                        valoracion.UbicacionEstoma = reader["ubicacion"].ToString();
                        valoracion.ColorEstoma= reader["color"]==DBNull.Value ? null : (uint ?)Convert.ToUInt32(reader["color"]);
                        valoracion.EstomaNivelPiel = reader["estoma"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["estoma"]);
                        valoracion.EstomaComplicaciones= reader["complicaciones"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["complicaciones"]);
                        valoracion.EstadoPiel= reader["estado_piel"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["estado_piel"]);
                        valoracion.TipoDispositivo= reader["tipo_dispositivo"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["tipo_dispositivo"]);
                        valoracion.Funcional= reader["funcional"]==DBNull.Value;
                        valoracion.FuncionalParametro = reader["funcional"]==DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["funcional"]);
                        valoracion.EscalaDolor = reader["dolor"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["dolor"]);
                        valoracion.FuncionalDescripcion = reader["funcional_descripcion"].ToString();

                            // TTiempoEvolucion.Text = reader["tiempo_evolucion_ulcera"].ToString();
                            // Utilidades.SelectInDropDown(DLugarOrigen, reader["lugar_origen_ulcera"]);
                            // Utilidades.SelectInDropDown(DTejidoSospechoso, reader["tejido_profundo"]);

                        valoracion.Ostomias= reader["costomias"].ToString() == "1";
                        valoracion.DispositivosMedicosInsertados = reader["cdispositivos_medicos"].ToString() == "1";
                        
                            // THogarGeriatrico.Text = reader["hogar_geriatrico"].ToString();
                            valoracion.ConsentimientoInformado = reader["consentimiento"].ToString() == "1";
                        valoracion.Periodicidad = reader["periodicidad"].ToString();
                        valoracion.Fistulas = reader["fistula"].ToString() == "1";
                        valoracion.LocalizacionFistula = reader["localizacion_fistula"].ToString();
                        valoracion.SignosDeInfeccion = reader["signos_infeccion"].ToString() == "1";
                        valoracion.CantidadAfluente = Utilidades.TryConverToDoubleInvariantCulture(reader["cantidad_afluente"]);
                        valoracion.ObservacionesPulso = reader["observacion_pulso"].ToString();
                        valoracion.Manejo = reader["manejo"].ToString();

                            query = new Query("valoracion_herida_herida");

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

                            List<Heridas> heridas = new List<Heridas>();

                            reader = conector.Query(query.GetSelect("valoracion=" + Query.GetValor(valoracion.Id)));
                            if (reader != null)
                            {
                                while (reader.Read())
                                {

                                Herida herida = new Herida();

                                herida.Id= reader["id"].ToString();
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
                                herida.Longitud = reader["longitud"]==DBNull.Value ? null : string.Format(CultureInfo.InvariantCulture, "{0}", reader["longitud"]);
                                herida.Anchura = reader["anchura"] == DBNull.Value ? null : string.Format(CultureInfo.InvariantCulture, "{0}", reader["anchura"]);
                                herida.Profundidad = reader["profundidad"] == DBNull.Value ? null : string.Format(CultureInfo.InvariantCulture, "{0}", reader["profundidad"]);
                                herida.Tunelizacion = reader["tunelizacion"]!=DBNull.Value;
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
                                herida.ExudadoTipo= reader["tipo_exudado"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["tipo_exudado"]);
                                herida.ExudadoPiel = reader["piel_circundante"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["piel_circundante"]);
                                herida.ExudadoBordes = reader["bordes_herida"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["bordes_herida"]);
                                herida.ExudadoOlor = reader["olor"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["olor"]);
                                herida.ExudadoDescripcion = reader["olor_descripcion"].ToString();
                                herida.ExudadoSignos = reader["signos_sintomas"] == DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["signos_sintomas"]);
                                herida.ExudadoComplicaciones = reader["exudado_complicacion"] != DBNull.Value;
                                herida.ExudadodComplicacionesParametro = reader["exudado_complicacion"].ToString();
                                herida.ExudadoClasificacion= reader["exudado_definicion"]==DBNull.Value ? null : (uint?)Convert.ToUInt32(reader["exudado_definicion"]);


                                herida.Galeria = new Galeria();
                                herida.Galeria.CanDelete =
                                    herida.Galeria.CanUpload = usuario.CanUpdate();
                                string path = string.Join("/", new string[] { valoracion.Id, herida.Id });
                                foreach (string file in FileStorage.ListFiles(FileStorage.Types.valoracion, path))
                                {
                                    herida.Galeria.Files.Add(Url.Content(FileStorage.GetPublicURLPath(FileStorage.Types.valoracion, path  + "/" + file)));
                                }

                                valoracion.Heridas.Add(herida);
                            }
                        }

                        query = new Query("valoracion_herida_antecedentes");

                        query += "motivo";
                        query += "estado";
                        query += "observaciones";

                        reader= conector.Query(query.GetSelect("valoracion={0}", null, Query.GetValor(valoracion.Id)));
                        if (reader != null) {
                            while (reader.Read()) {

                                CheckTextParam info= valoracion.Antecendentes.Find(x => x.Id == Convert.ToUInt32(reader["motivo"]));
                                if (info == null) {
                                    info = new CheckTextParam() { Id= Convert.ToUInt32(reader["motivo"]) };
                                    valoracion.Antecendentes.Add(info);
                                }
                                
                                info.Check = reader["estado"].ToString() == "1";
                                info.Text = reader["observaciones"].ToString();
                            }
                        }


                        query = new Query("valoracion_herida_riesgos");

                        query += "motivo";
                        query += "estado";
                        query += "observaciones";

                        reader = conector.Query(query.GetSelect("valoracion={0}", null, Query.GetValor(valoracion.Id)));
                        if (reader != null)
                        {
                            while (reader.Read())
                            {

                                CheckTextParam info = valoracion.Riesgos.Find(x => x.Id == Convert.ToUInt32(reader["motivo"]));
                                if (info == null)
                                {
                                    info = new CheckTextParam() { Id = Convert.ToUInt32(reader["motivo"]) };
                                    valoracion.Riesgos.Add(info);
                                }
                                info.Check = reader["estado"].ToString() == "1";
                                info.Text = reader["observaciones"].ToString();
                            }
                        }


                        query = new Query("valoracion_herida_educativo");

                        query += "concepto";
                        query += "valor";

                        reader = conector.Query(query.GetSelect("valoracion={0}", null, Query.GetValor(valoracion.Id)));
                        if (reader != null)
                        {
                            while (reader.Read())
                            {
                                CheckTextParam info = valoracion.ComponenteEducativo.Find(x => x.Id == Convert.ToUInt32(reader["concepto"]));
                                if (info == null)
                                {
                                    info = new CheckTextParam() { Id = Convert.ToUInt32(reader["concepto"]) };
                                    valoracion.ComponenteEducativo.Add(info);
                                }
                                info.Check = reader["valor"].ToString() == "1";
                            }
                        }
                    }
                }
            }

            if (Request.QueryString["pd"] == "1")
                return View("Valoracion_Print", valoracion);
            if (Request.QueryString["pdf"] == "1")
                return PDFConverter.RenderPDF(this, "Valoración de heridas", "Valoracion_Print", valoracion);

            return View(valoracion);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Valoracion(Valoracion valoracion) {
            if (ModelState.IsValid) {

                CUsuario usuario = (CUsuario)CUsuario.GetInstance();
                string id = valoracion.ProtectedFields["id"];
                string pacienteid = valoracion.ProtectedFields["pid"];
                if ((string.IsNullOrEmpty(id) && !usuario.CanInsert()) || (!string.IsNullOrEmpty(id) && !usuario.CanUpdate()))
                {
                    return HttpNotFound();
                }

                using (CConector conector = new CConector())
                {
                    conector.StartTransaction();

                    Query query = new Query("valoracion_herida");

                    query["fecha"]= Query.GetMySQLDateFormat(valoracion.Fecha);
                    query["ta"]= valoracion.TA?.Split(' ')[0];
                    query["fc"]= valoracion.FC?.Split(' ')[0];
                    query["fr"] = valoracion.FR?.Split(' ')[0];
                    query["t"] = valoracion.T?.Split(' ')[0];
                    query["pulsosdistales"] = valoracion.PulsosDistales;
                    query["ostomias"] = valoracion.TipoOstomia;
                    query["ubicacion"] = valoracion.UbicacionEstoma;
                    query["color"] = valoracion.ColorEstoma;
                    query["estoma"] = valoracion.EstomaNivelPiel;
                    query["complicaciones"] = valoracion.EstomaComplicaciones;
                    query["estado_piel"] = valoracion.EstadoPiel;
                    query["tipo_dispositivo"] = valoracion.TipoDispositivo;
                    query["funcional"] = valoracion.FuncionalParametro;
                    query["funcional_descripcion"] = valoracion.FuncionalDescripcion;
                    query["dolor"] = valoracion.EscalaDolor;
                    // query["tiempo_evolucion_ulcera"] = valoracion.;
                    // query["lugar_origen_ulcera"] = valoracion.;
                    // query["tejido_profundo"] = valoracion.;
                    query["manejo"] = valoracion.Manejo;
                    query["costomias"] = valoracion.Ostomias ? "1" : null;
                    query["cdispositivos_medicos"]= valoracion.DispositivosMedicosInsertados ? "1" : null;
                    // query["hogar_geriatrico"] = valoracion.hoga;
                    query["consentimiento"] = valoracion.ConsentimientoInformado ? "1" : null;
                    query["periodicidad"] = valoracion.Periodicidad;
                    query["fistula"] = valoracion.Fistulas ? "1" : null;
                    query["localizacion_fistula"] = valoracion.LocalizacionFistula;
                    query["signos_infeccion"] = valoracion.SignosDeInfeccion ? "1" : null;
                    query["cantidad_afluente"] = valoracion.CantidadAfluente?.Split(' ')[0];
                    query["observacion_pulso"] = valoracion.ObservacionesPulso;
                    query["funcionario"] = valoracion.Funcionario.Id;

                    if (string.IsNullOrEmpty(id))
                    {
                        query["paciente"] = pacienteid;
                        query["asegurador"] = Paciente.GetPaciente(pacienteid).entidadId;

                        int res = conector.QueryMod(query.GetInsert(), true);
                        if (res == -1)
                        {
                            ModelState.AddModelError("", conector.LastError);
                            return View(valoracion);
                        }
                        id = res.ToString();
                    }
                    else
                    {
                        if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1)
                        {
                            ModelState.AddModelError("", conector.LastError);
                            return View(valoracion);
                        }
                    }

                    if (conector.InsertModificacion(id) == -1)
                    {
                        ModelState.AddModelError("", conector.LastError);
                        return View(valoracion);
                    }

                    foreach (Herida herida in valoracion.Heridas) {

                        query = new Query("valoracion_herida_herida");
                        if (herida.Eliminado==true && !string.IsNullOrEmpty(herida.Id)) {
                            if (conector.QueryMod(query.GetDelete("id=" + Query.GetValor(herida.Id))) == -1)
                            {
                                ModelState.AddModelError("", conector.LastError);
                                return View(valoracion);
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

                        if (string.IsNullOrEmpty(heridaid)) {
                            query["valoracion"] = id;
                            int res = conector.QueryMod(query.GetInsert(), true);
                            if (res == -1)
                            {
                                ModelState.AddModelError("", conector.LastError);
                                return View(valoracion);
                            }
                            heridaid = res.ToString();
                        } else {
                            if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(heridaid))) == -1)
                            {
                                ModelState.AddModelError("", conector.LastError);
                                return View(valoracion);
                            }
                        }

                        foreach (string file in herida.Galeria.Files) {
                            if (file.StartsWith("~/") || file.StartsWith("/"))
                                continue;
                            FileStorage.CopyTempFile(conector, FileStorage.Types.valoracion, file, null, id, heridaid);
                        }
                    }

                    Query educativo = new Query("valoracion_herida_educativo");
                    if (conector.QueryMod(educativo.GetDelete("valoracion=" + Query.GetValor(id))) == -1)
                    {
                        ModelState.AddModelError("", conector.LastError);
                        return View(valoracion);
                    }

                    educativo["valoracion"] = id;

                    foreach (var info in valoracion.ComponenteEducativo)
                    {
                        if (info.Check)
                        {
                            educativo["concepto"] = info.Id;
                            educativo["valor"] = "1";

                            if (conector.QueryMod(educativo.GetInsert()) == -1)
                            {
                                ModelState.AddModelError("", conector.LastError);
                                return View(valoracion);
                            }
                        }
                    }

                    Query antecendentes = new Query("valoracion_herida_antecedentes");
                    if (conector.QueryMod(antecendentes.GetDelete("valoracion=" + Query.GetValor(id))) == -1)
                    {
                        ModelState.AddModelError("", conector.LastError);
                        return View(valoracion);
                    }
                    antecendentes["valoracion"] = id;

                    foreach (var info in valoracion.Antecendentes)
                    {
                        antecendentes["motivo"] = info.Id;
                        antecendentes["estado"] = info.Check ? "1" : null;
                        antecendentes["observaciones"] = info.Text;

                        if (!Paciente.SaveAntecedente(conector, pacienteid, antecendentes["motivo"].ToString(), antecendentes["estado"].ToString(), antecendentes["observaciones"].ToString())
                            || conector.QueryMod(antecendentes.GetInsert()) == -1)
                        {
                            ModelState.AddModelError("", conector.LastError);
                            return View(valoracion);
                        }
                    }

                    Query riesgos = new Query("valoracion_herida_riesgos");
                    if (conector.QueryMod(riesgos.GetDelete("valoracion=" + Query.GetValor(id))) == -1)
                    {
                        ModelState.AddModelError("", conector.LastError);
                        return View(valoracion);
                    }
                    riesgos["valoracion"] = id;

                    foreach (var info in valoracion.Riesgos)
                    {
                        riesgos["estado"] = info.Check ? "1" : null;
                        riesgos["observaciones"] = info.Text;
                        riesgos["motivo"] = info.Id;

                        if (conector.QueryMod(riesgos.GetInsert()) == -1)
                        {
                            ModelState.AddModelError("", conector.LastError);
                            return View(valoracion);
                        }
                    }

                    if (conector.InsertModificacion(id) == -1)
                    {
                        ModelState.AddModelError("", conector.LastError);
                        return View(valoracion);
                    }

                    if (string.IsNullOrEmpty(valoracion.Id) && usuario.GetPermisosRaiz("~/App_data/Escalas") == 0)
                        Usuario.GetUsuario().SetForceURL("~/paciente/barthel.aspx?pid=" + pacienteid + "&f=" + HttpUtility.UrlEncode(Query.GetMySQLDateFormat(valoracion.Fecha, true)), conector);

                    foreach (Herida herida in valoracion.Heridas)
                    {
                        foreach (string filename in herida.Galeria._DeletedFiles)
                        {
                            FileStorage.RemoveFile(FileStorage.Types.valoracion, Path.GetFileName(filename), id, herida.Id);
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
            return View(valoracion);
        }
    }
}