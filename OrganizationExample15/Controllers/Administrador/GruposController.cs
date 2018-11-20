using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models.Administrador;
using Newtonsoft.Json;
using SDG.Componentes;

namespace OrganizationExample15.Controllers.Administrador
{
    public partial class AdministradorController : BaseController
    {
        public ActionResult __Grupos(int current, int rowCount, Dictionary<string, string> sort, string searchPhrase = null)
        {
            CUsuario usuario = ViewBag.User;
            string where = " grupo.eliminado IS NULL";
            if (!string.IsNullOrEmpty(searchPhrase))
                where += string.Format(" AND grupo.nombre LIKE CONCAT('%',{0},'%') ", Query.GetValor(searchPhrase));

            Query query = new Query("grupo");

            query["id"]= "grupo.id";
            query["n"]= "grupo.nombre";
            query["d"] = "grupo.descripcion";

            string groupby = " GROUP BY " + string.Join(",", query.Fields.Select(x => x.Key));

            query["c"] = "COUNT(*)";

            string join = "LEFT JOIN usuario ON (usuario.grupo=grupo.id)";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(DISTINCT grupo.id) FROM grupo WHERE " + where
                    , query.GetSelect(where + groupby, join)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data, HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
            }
        }

        [HttpGet]
        public ActionResult _Grupos(string id)
        {
            OrganizationExample15.Models.Administrador.Grupo item = OrganizationExample15.Models.Administrador.Grupo.GetItem(id);
            return PartialView(item);
        }

        [HttpPost]
        public ActionResult ___Grupos(string id)
        {
            using (CConector conector = new CConector())
            {
                CUsuario user = ViewBag.User;
                conector.StartTransaction();
                Query query = new Query("grupo");

                query["eliminado"] = "NOW()";
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1 || conector.InsertModificacion(id)==-1)
                {
                    return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                }

                conector.Commit();
                OrganizationExample15.Models.Administrador.Grupo.CleanCache(id);
                return Content(string.Format("$('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Grupo eliminado"))));
            }
        }

        [HttpPost]
        public ActionResult _Grupos(OrganizationExample15.Models.Administrador.Grupo item)
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
                    string existid = conector.QueryString("SELECT id FROM grupo WHERE nombre={0} AND eliminado IS NULL LIMIT 1", Query.GetValor(item.Nombre));
                    if (!string.IsNullOrEmpty(existid) && existid != id)
                        return Content(string.Format("alert({0});", Query.GetValor("Ya existe un grupo llamado " + Query.GetValor(item.Nombre))));

                    conector.StartTransaction();
                    Query query = new Query("grupo");

                    query["nombre"] = item.Nombre;
                    query["descripcion"] = item.Descripcion;

                    if (string.IsNullOrEmpty(id))
                    {
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
                    if (conector.InsertModificacion(id)==-1)
                    {
                        return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                    }

                    if (conector.QueryMod("DELETE FROM permisos WHERE grupo=" + Query.GetValor(id)) == -1)
                        return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));

                    Query permisos = new Query("permisos");

                    permisos["grupo"] = id;

                    foreach (var parent in item.Privileges) {

                        foreach (var privilegio in parent.Childrens.Where(x => (int)x.Granted > 0))
                        {
                            permisos["permiso"] = (int)privilegio.Granted;
                            permisos["url"] = privilegio.URL;

                            if (conector.QueryMod(permisos.GetInsert()) == -1)
                                return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                        }
                    }

                    conector.Commit();
                    OrganizationExample15.Models.Administrador.Grupo.CleanCache(id);

                    return Content(string.Format("$('#PP').modal('hide'); $('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Grupo {0} editado", item.Nombre))));
                }
            }
            return PartialView(item);
        }

        public ActionResult Grupos()
        {
            return View();
        }
    }
}