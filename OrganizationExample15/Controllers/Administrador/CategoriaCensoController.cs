using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models;
using OrganizationExample15.Models.Administrador;
using Newtonsoft.Json;
using SDG.Componentes;

namespace OrganizationExample15.Controllers.Administrador
{
    public partial class AdministradorController : BaseController
    {
        public ActionResult __CategoriaCenso(int current, int rowCount, Dictionary<string, string> sort, string searchPhrase = null)
        {
            CUsuario usuario = ViewBag.User;
            string where = string.Format(" tipo={0} AND eliminado IS NULL", (int)MVarios.Tipo.CategoriaCenso);
            if (!string.IsNullOrEmpty(searchPhrase))
                where+= string.Format(" AND nombre LIKE CONCAT('%',{0},'%') ", Query.GetValor(searchPhrase));

            Query query = new Query("varios");

            query += "id";
            query["n"]= "nombre";
            query["d"]= "descripcion";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM varios WHERE " + where
                    , query.GetSelect(where, null)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data), HomeCareVersion.JSONContentType);
            }
        }

        [HttpGet]
        public ActionResult _CategoriaCenso(string id)
        {
            CategoriaCenso item = OrganizationExample15.Models.Administrador.CategoriaCenso.GetItem(id);
            return PartialView(item);
        }

        [HttpPost]
        public ActionResult ___CategoriaCenso(string id)
        {
            using (CConector conector = new CConector())
            {
                CUsuario user = ViewBag.User;
                conector.StartTransaction();
                Query query = new Query("varios");

                query["eliminado"] = "NOW()";
                query["szReservado"] = "-1";
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1 || conector.InsertModificacion(id) == -1)
                {
                    return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                }

                conector.Commit();
                OrganizationExample15.Models.Administrador.CategoriaCenso.CleanCache(id);
                return Content(string.Format("$('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Asegurador eliminado"))));
            }
        }

        [HttpPost]
        public ActionResult _CategoriaCenso(CategoriaCenso item)
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
                    string existid = conector.QueryString("SELECT id FROM varios WHERE nombre={0} AND eliminado IS NULL LIMIT 1", Query.GetValor(item.Nombre));
                    if (!string.IsNullOrEmpty(existid) && existid != id)
                        return Content(string.Format("alert({0});", Query.GetValor("Ya existe una categoría llamada " + Query.GetValor(item.Nombre))));

                    conector.StartTransaction();
                    Query query = new Query("varios");

                    query["nombre"] = item.Nombre;
                    query["descripcion"] = item.Descripcion;
                    
                    if (string.IsNullOrEmpty(id))
                    {
                        query["tipo"] = (int)MVarios.Tipo.CategoriaCenso;
                        int res = conector.QueryMod(query.GetInsert(), true);
                        if (res == -1)
                        {
                            return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                        }
                        id = res.ToString();
                    }
                    else
                    {
                        if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1)
                        {
                            return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                        }
                    }

                    if (conector.InsertModificacion(id) == -1)
                    {
                        return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                    }

                    if (conector.QueryMod("DELETE FROM categoria_censo WHERE categoria=" + Query.GetValor(id)) == -1)
                        return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));

                    query = new Query("categoria_censo");
                    query["categoria"] = id;

                    foreach (MProcedimiento info in item.LProcedimientos)
                    {
                        query["hora"] = info.Id;
                        if (conector.QueryMod(query.GetInsert()) == -1)
                            return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                    }

                    conector.Commit();
                    MVarios.CleanCache(id);

                    return Content(string.Format("$('#PP').modal('hide'); $('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Categoría {0} editada", item.Nombre))));
                }
            }
            return PartialView(item);
        }

        public ActionResult CategoriaCenso()
        {
            return View();
        }
    }
}