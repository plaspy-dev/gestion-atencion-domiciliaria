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
        public ActionResult __Parametros(int current, int rowCount, Dictionary<string, string> sort, uint? t, string searchPhrase = null)
        {
            CUsuario usuario = ViewBag.User;
            string where = string.Format(" tipo={0} AND eliminado IS NULL", Query.GetValor(t));
            if (!string.IsNullOrEmpty(searchPhrase))
                where += string.Format(" AND nombre LIKE CONCAT('%',{0},'%') ", Query.GetValor(searchPhrase));

            Query query = new Query("varios");

            query["id"] = "id";
            query["n"] = "nombre";
            query["d"] = "descripcion";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM varios WHERE " + where
                    , query.GetSelect(where, null)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data, HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
            }
        }

        [HttpGet]
        public ActionResult _Parametros(string id, uint? t)
        {
            if (t == null)
                return HttpNotFound();
            MVarios item = MVarios.GetItem(id);
            if (string.IsNullOrEmpty(item.Id)) {
                item._Tipo = (MVarios.Tipo)t;
            }
            return PartialView(item);
        }

        [HttpPost]
        public ActionResult ___Parametros(string id)
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
                MVarios.CleanCache(id);
                return Content(string.Format("$('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Parámetro eliminado"))));
            }
        }

        [HttpPost]
        public ActionResult _Parametros(MVarios item)
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
                        return Content(string.Format("alert({0});", Query.GetValor("Ya existe un parámetro llamado " + Query.GetValor(item.Nombre))));

                    conector.StartTransaction();
                    Query query = new Query("varios");

                    query["nombre"] = item.Nombre;
                    query["descripcion"] = item.Descripcion;

                    if (string.IsNullOrEmpty(id))
                    {
                        query["tipo"] = (int)item._Tipo;
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

                    conector.Commit();
                    MVarios.CleanCache(id);

                    return Content(string.Format("$('#PP').modal('hide'); $('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Parámetro {0} editado", item.Nombre))));
                }
            }
            return PartialView(item);
        }

        public ActionResult Parametros(uint? t)
        {
            return View();
        }
    }
}