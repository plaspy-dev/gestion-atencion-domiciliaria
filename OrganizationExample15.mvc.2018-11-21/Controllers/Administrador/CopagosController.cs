using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models.Administrador;
using SDG.Componentes;

namespace OrganizationExample15.Controllers.Administrador
{
    public partial class AdministradorController : BaseController
    {
        // GET: Copagos
        public ActionResult Copagos()
        {
            List<Copago> list = new List<Copago>();

            list = MVarios.GetList(MVarios.Tipo.CategoriaEPS).Select(x => new Copago() { Id=x.Id, Nombre=x.Nombre }).ToList();
            list.ForEach(x => x.ProtectedFields["id"] = x.Id);

            return View(list);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Copagos(List<Copago> list) {

            if (ModelState.IsValid) {
                using (CConector conector = new CConector())
                {
                    conector.StartTransaction();
                    foreach (Copago info in list)
                    {
                        string id = info.ProtectedFields["id"];
                        MVarios copago = MVarios.GetList(MVarios.Tipo.CopagoCategoriaEPS).Find(x => x.parametro1?.ToString() == id);
                        string copagoid = copago?.Id;

                        Query query = new Query("varios");

                        query["nombre"] = HomeCareVersion.ParseDecimal(info.Valores.Nombre);
                        query["descripcion"] = HomeCareVersion.ParseDecimal(info.Valores.Descripcion);
                        query["szReservado"] = HomeCareVersion.ParseDecimal(info.Valores.szReservado);

                        if (string.IsNullOrEmpty(copagoid))
                        {
                            query["tipo"] = (int)MVarios.Tipo.CopagoCategoriaEPS;
                            query["parametro1"] = id;
                            int res = conector.QueryMod(query.GetInsert(), true);
                            if (res == -1)
                            {
                                ModelState.AddModelError("", conector.LastError);
                                return View(list);
                            }
                            copagoid = res.ToString();
                        }
                        else {
                            if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(copagoid))) == -1)
                            {
                                ModelState.AddModelError("", conector.LastError);
                                return View(list);
                            }
                        }
                        if (conector.InsertModificacion(copagoid) == -1)
                        {
                            ModelState.AddModelError("", conector.LastError);
                            return View(list);
                        }
                        MVarios.CleanCache(copagoid);
                    }
                    conector.Commit();
                    return Redirect(Request.Url.AbsolutePath + "?ce=1");
                }
            }
            return View(list);
        }
    }
}