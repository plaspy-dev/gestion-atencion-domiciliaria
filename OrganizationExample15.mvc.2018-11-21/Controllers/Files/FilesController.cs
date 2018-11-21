using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models;
using Newtonsoft.Json;
using SDG.Componentes;

namespace OrganizationExample15.Controllers.File
{
    public class FilesController : BaseController
    {
        public class UploadFileResponse
        {
            public int Error { get; set; }
            public string Message { get; set; }
            public string FileName { get; set; }
        }

        [HomeCarePolicy("*")]
        [OutputCache(NoStore = false, Duration = 7 * 24 * 60 * 60, Location = System.Web.UI.OutputCacheLocation.Any)]
        public ActionResult Index(string type, string filename)
        {
            return FileStorage.GetActionResult(this, type, filename, null, ViewBag.User);
        }

        [AllowAnonymous]
        [OutputCache(NoStore = false, Duration = 7 * 24 * 60 * 60, Location = System.Web.UI.OutputCacheLocation.Any)]
        public ActionResult Public(string type, string key, string filename)
        {
            return FileStorage.GetActionResult(this, type, filename, key, ViewBag.User);
        }

        [HomeCarePolicy("*")]
        public ActionResult Upload(string p, string p1) {

            CUsuario user = ViewBag.User;
            UploadFileResponse response = new UploadFileResponse();

            if (HttpContext.Request.Files.Count == 0 || string.IsNullOrEmpty(p))
            {
                return HttpNotFound();
            }
            FileParam param;
            try
            {
                param = JsonConvert.DeserializeObject<FileParam>(Crypt.Unprotect(p));
            } catch {
                return HttpNotFound();
            }
            switch (param.Tipo) {
                case FileStorage.Types.Temporal:
                    break;
                case FileStorage.Types.Cuentas:
                    if (!user.CanAccess("~/Terapeutico/Cuentas"))
                    {
                        return HttpNotFound();
                    }
                    break;
                case FileStorage.Types.valoracion:
                    if (!user.CanAccess("~/ClinicaHeridas/Valoracion")) {
                        return HttpNotFound();
                    }
                    break;
                default:
                    return HttpNotFound();
            }

            foreach (string sfile in HttpContext.Request.Files)
            {
                HttpPostedFileBase file = HttpContext.Request.Files[sfile];
                if (!string.IsNullOrEmpty(file.FileName))
                {
                    try
                    {
                        if (param != null && !param.ValidExtensions.Contains(Path.GetExtension(file.FileName)))
                        {
                            response.Error = 3;
                            response.Message = "Extensión de archivo no valido";
                        } else {
                            response.FileName = FileStorage.SaveFile(param.Tipo, file, false, file.FileName, param.Path==null ? null : string.Format(param.Path, p1));
                            if (string.IsNullOrEmpty(response.FileName))
                            {
                                response.Error = 2;
                                response.Message = "No se pudo guardar el archivo " + file.FileName;
                                break;
                            }
                            if (param.Tipo == FileStorage.Types.Temporal)
                            {
                                using (CConector conector = new CConector())
                                {
                                    Query query = new Query("archivos_temporales");

                                    query["archivo"] = response.FileName;
                                    query["fecha"] = "NOW()";
                                    query["original"] = file.FileName;

                                    if (conector.QueryMod(query.GetInsert()) == -1) {
                                        response.Error = 4;
                                        response.Message = "SQL " + conector.LastError;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        response.Error = 5;
                        response.Message = ex.ToString();
                    }
                }
            }

            return Content(JsonConvert.SerializeObject(response, HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
        }
    }
}