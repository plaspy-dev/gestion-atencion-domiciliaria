using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models.terapeutico;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System.Drawing;
using System.Drawing.Imaging;

namespace OrganizationExample15.Controllers.Terapeutico
{
    public partial class TerapeuticoController : BaseController
    {
        [HomeCarePolicy("~/Terapeutico/Cuentas")]
        public ActionResult Documentos(uint? fid) {

            Documentos documentos = new Documentos();
            CUsuario usuario = ViewBag.User;

            documentos.Funcionario.Id = usuario["personal"];
            documentos.Funcionario.ReadOnly = !usuario.CanAdmin();

            if (usuario.CanAdmin() && fid != null)
            {
                documentos.Funcionario.Id = fid.ToString();
            }
            documentos.ProtectedFields["fid"] = documentos.Funcionario.Id;

            ;
            FileStorage.GetPublicURLPath(FileStorage.Types.sellos, documentos.Funcionario.Id + ".jpg");

            return View(documentos);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [HomeCarePolicy("~/Terapeutico/Cuentas")]
        public ActionResult Documentos(Documentos documentos) {
            if(ModelState.IsValid)
            {
                string fid = documentos.ProtectedFields["fid"];

                if (documentos.Firma!=null)
                {
                    try
                    {
                        using (Bitmap imagen = new Bitmap(documentos.Firma.InputStream))
                        {
                            using (Bitmap processedImage = FileStorage.CropSign(imagen))
                            {
                                processedImage.Save(FileStorage.GetFilePath(FileStorage.Types.firmas, fid + ".jpg"), ImageFormat.Jpeg);
                            }
                        }
                    } catch (Exception ex) {
                        ModelState.AddModelError("", "No se puede procesar la firma " + ex.Message);
                        return View(documentos);
                    }
                }

                if (documentos.Sello != null)
                {
                    try
                    {
                        using (Bitmap imagensello = new Bitmap(documentos.Sello.InputStream))
                        {
                            using (Bitmap selloprocesado = FileStorage.CropSign(imagensello))
                            {
                                selloprocesado.Save(FileStorage.GetFilePath(FileStorage.Types.sellos, fid + ".jpg"), ImageFormat.Jpeg);
                            }
                        }
                    } catch (Exception ex) {
                        ModelState.AddModelError("", "No se puede procesar el sello " + ex.Message);
                        return View(documentos);
                    }
                }

                FileStorage.SaveFile(FileStorage.Types.RUT, documentos.RUT, true, fid);

                using (CConector conector = new CConector()) {

                    Query query = new Query("recurso_humano");

                    query["actualizacion"] = "NOW()";

                    if (conector.QueryMod(query.GetUpdate("perId={0}", Query.GetValor(fid))) == -1) {
                        ModelState.AddModelError("", conector.LastError);
                        return View(documentos);
                    }
                }

                return Redirect("~/Terapeutico/Cuentas?du=1");
            }
            return View(documentos);
        }

    }
}