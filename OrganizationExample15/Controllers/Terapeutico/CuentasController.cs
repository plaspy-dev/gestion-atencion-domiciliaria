using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models.terapeutico;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Text.RegularExpressions;

namespace OrganizationExample15.Controllers.Terapeutico
{
    public partial class TerapeuticoController : BaseController
    {
        public ActionResult Cuentas(uint? fid, string ds) {

            CUsuario usuario = ViewBag.User;
            Cuentas cuentas = new Cuentas();

            DateTime fecha = DateTime.Now;
            cuentas.Inicio = Query.GetFromMySQLDate(new DateTime(fecha.Year, fecha.Month, fecha.Day>15 ? 16 : 1));
            cuentas.Fin = Query.GetFromMySQLDate(fecha);
            cuentas.Funcionario.Id = usuario["personal"];
            cuentas.Funcionario.ReadOnly = !usuario.CanAdmin();

            if (usuario.CanAdmin() && fid!=null)
            {
                cuentas.Funcionario.Id = fid.ToString();
            }
            if (!string.IsNullOrEmpty(ds)) {
                try
                {
                    fecha = DateTime.Parse(ds);
                    cuentas.Inicio = Query.GetFromMySQLDate(new DateTime(fecha.Year, fecha.Month, fecha.Day > 15 ? 16 : 1));

                    if(fecha.Day > 15)
                        fecha = new DateTime(fecha.Year, fecha.Month, 1).AddMonths(1).AddDays(-1);
                    else fecha = new DateTime(fecha.Year, fecha.Month, 16);
                    if (fecha > DateTime.Now)
                        fecha = DateTime.Now;
                    cuentas.Fin = Query.GetFromMySQLDate(fecha);
                } catch {
                    
                }
            }

            cuentas.ProtectedFields["fid"] = cuentas.Funcionario.Id;
            cuentas.ProtectedFields["ds"] = cuentas.Inicio;
            cuentas.Galeria.CanDelete = usuario.CanInsert();
            cuentas.Galeria.CanUpload = usuario.CanInsert();
            cuentas.Galeria.FileMimeTypes = FileStorage.ValidMimeImagesPDF;
            cuentas.Galeria.FileType = FileStorage.ValidImagesPDF;
            // cuentas.Galeria.Path = string.Format("{0}/{1}", cuentas.ProtectedFields["fid"], cuentas.ProtectedFields["id"] ?? "0");

            using (CConector conector = new CConector()) {

                Query query;
                if (!usuario.CanAdmin()) {
                    query = new Query("recurso_humano");
                    query += "actualizacion";

                    if (string.IsNullOrEmpty(conector.QueryString(query.GetSelect("perId={0}", null, Query.GetValor(cuentas.Funcionario.Id))))) { // no ha actualizado documentos

                        return Redirect("~/Terapeutico/Documentos");
                    }
                }

                query = new Query("cuenta");

                query += "id";
                query += "final";
                query += "estado";

                MySqlDataReader reader= conector.Query(query.GetSelect("cuenta.personal={0} AND cuenta.fecha={1}", null, Query.GetValor(cuentas.Funcionario.Id), Query.GetValor(Query.GetMySQLDateFormat(cuentas.Inicio))));
                if (reader != null && reader.Read()) {

                    string id = reader["id"].ToString();
                    cuentas.ProtectedFields["id"] = id;
                    cuentas.Estado = (uint?)(reader["estado"] as int?);
                    cuentas.Galeria.CanUpload= 
                    cuentas.Galeria.CanDelete = usuario.CanUpdate();
                    if (usuario.CanPrint()) {
                        ViewBag.Print = true;
                        ViewBag.PDF = true;
                    }

                    query = new Query("cuenta_servicio");

                    query += "paciente";
                    query += "servicio";
                    query += "cantidad";
                    query += "valor";

                    reader= conector.Query(query.GetSelect("cuenta={0}", null, Query.GetValor(id)));
                    if (reader != null) {
                        while (reader.Read()) {
                            Cuentas.Servicio info = new Cuentas.Servicio();

                            info.PacienteId= reader["paciente"].ToString();
                            info.ServicioId = reader["servicio"].ToString();
                            info.Cantidad = reader["cantidad"] as uint?;
                            info.Valor = reader["valor"] as decimal?;

                            cuentas.Servicios.Add(info);
                        }
                    }
                }
                string path = string.Join("/", new string[] { cuentas.ProtectedFields["fid"], cuentas.ProtectedFields["id"] ?? "0" });
                // cuentas.Galeria.Path = string.Format("{0}/{1}", cuentas.ProtectedFields["fid"], cuentas.ProtectedFields["id"] ?? "0");
                foreach (string file in FileStorage.ListFiles(FileStorage.Types.Cuentas, path))
                {
                    cuentas.Galeria.Files.Add(Url.Content(FileStorage.GetPublicURLPath(FileStorage.Types.Cuentas, path + "/" + file)));
                }
            }

            if (Request.QueryString["pd"] == "1")
                return View("Cuentas_Print", cuentas);
            if (Request.QueryString["pdf"] == "1")
                return PDFConverter.RenderPDF(this, "Cuenta", "Cuentas_Print", cuentas);

            return View(cuentas);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Cuentas(Cuentas cuentas) {
            if (ModelState.IsValid) {

                CUsuario usuario = (CUsuario)CUsuario.GetInstance();
                string id = cuentas.ProtectedFields["id"];
                Query query = new Query("cuenta");
                if ((string.IsNullOrEmpty(id) && !usuario.CanInsert()) || (!string.IsNullOrEmpty(id) && !usuario.CanUpdate())) {
                    return HttpNotFound();
                }

                using (CConector conector = new CConector()) {

                    conector.StartTransaction();

                    query["personal"] = cuentas.ProtectedFields["fid"];
                    query["fecha"] = Query.GetMySQLDateFormat(cuentas.ProtectedFields["ds"]);
                    query["final"] = Query.GetMySQLDateFormat(cuentas.Fin);
                    if(usuario.CanAdmin())
                        query["estado"] = cuentas.Estado;

                    if (string.IsNullOrEmpty(id))
                    {

                        int res = conector.QueryMod(query.GetInsert(), true);
                        if (res == -1)
                        {
                            ModelState.AddModelError("", conector.LastError);
                            return View(cuentas);
                        }
                        id = res.ToString();
                    }
                    else {
                        if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1) {
                            ModelState.AddModelError("", conector.LastError);
                            return View(cuentas);
                        }
                    }

                    if (conector.InsertModificacion(id) == -1) {
                        ModelState.AddModelError("", conector.LastError);
                        return View(cuentas);
                    }

                    query = new Query("cuenta_servicio");

                    if (conector.QueryMod(query.GetDelete("cuenta={0}", Query.GetValor(id))) == -1)
                    {
                        ModelState.AddModelError("", conector.LastError);
                        return View(cuentas);
                    }

                    query["cuenta"] = id;


                    dynamic listcuentas= cuentas.GetPacientesServicio();
                    List<Cuentas.Servicio> lista = listcuentas.l;

                    foreach (Cuentas.Servicio info in cuentas.Servicios.GroupBy(x => new { x.PacienteId, x.ServicioId }).Select(x => new Cuentas.Servicio() { ServicioId = x.Key.ServicioId, PacienteId = x.Key.PacienteId, Cantidad = (uint)x.Sum(y => y.Cantidad) })) {

                        Cuentas.Servicio servicio = lista.Find(x => x.PacienteId == info.PacienteId && x.ServicioId == info.ServicioId);
                        if (servicio==null)
                            continue;
                        if (info.Cantidad > servicio.Cantidad)
                            info.Cantidad = servicio.Cantidad;

                        query["paciente"] = info.PacienteId;
                        query["servicio"] = info.ServicioId;
                        query["cantidad"] = info.Cantidad;
                        query["valor"] = servicio.Valor;

                        if (conector.QueryMod(query.GetInsert()) == -1) {
                            ModelState.AddModelError("", conector.LastError);
                            return View(cuentas);
                        }
                    }

                    foreach (string filename in cuentas.Galeria._DeletedFiles)
                    {
                        FileStorage.RemoveFile(FileStorage.Types.Cuentas, Path.GetFileName(filename), cuentas.ProtectedFields["fid"], id);
                    }
                    
                    string path= string.Format("{0}/{1}", cuentas.ProtectedFields["fid"], id);
                    foreach (string filename in cuentas.Galeria._AddedFiles) {
                        FileStorage.MoveTempFile(conector, FileStorage.Types.Cuentas, filename, null, path);
                    }

                    /*if (string.IsNullOrEmpty(cuentas.ProtectedFields["id"]))
                    {
                        cuentas.Galeria.Path = string.Format("{0}/{1}", cuentas.ProtectedFields["fid"], "0");
                        foreach (string file in FileStorage.ListFiles(FileStorage.Types.Cuentas, cuentas.Galeria.Path))
                        {
                            if (!FileStorage.MoveFile(FileStorage.Types.Cuentas, cuentas.Galeria.Path, file, string.Format("{0}/{1}", cuentas.ProtectedFields["fid"], id), file))
                            {
                                ModelState.AddModelError("", "No se puede guardar el archivo " + file);
                                return View(cuentas);
                            }
                        }
                    }*/

                    conector.Commit();

                    return Redirect(Request.Url.AbsolutePath + "?er=1");
                }
            }
            return View(cuentas);
        }
    }
}