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
        public ActionResult __Terceros(int current, int rowCount, Dictionary<string, string> sort, string searchPhrase = null)
        {
            CUsuario usuario = ViewBag.User;
            string where = " estado IS NULL";
            if (!string.IsNullOrEmpty(searchPhrase))
            {
                foreach (string text in searchPhrase.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)) {
                    where += string.Format(" AND nombre LIKE CONCAT('%',{0},'%') ", Query.GetValor(text));
                }
            }

            Query query = new Query("tercero");

            query["id"]= "id";
            query["n"]= "nombre";
            query["d"] = "descripcion";
            query["i"] = "identificacion";
            query["t"] = "telefono";
            query["di"] = "direccion";
            query["e"] = "email";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM tercero WHERE " + where
                    , query.GetSelect(where, null)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data, HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
            }
        }

        [HttpGet]
        public ActionResult _Terceros(string id)
        {
            MTercero item = MTercero.GetItem(id);
            return PartialView(item);
        }

        [HttpPost]
        public ActionResult ___Terceros(string id)
        {
            using (CConector conector = new CConector())
            {
                CUsuario user = ViewBag.User;
                conector.StartTransaction();
                Query query = new Query("tercero");

                query["estado"] = "-1";
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1 || conector.InsertModificacion(id)==-1)
                {
                    return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                }

                conector.Commit();
                MTercero.CleanCache(id);
                return Content(string.Format("$('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Proveedor eliminado"))));
            }
        }

        [HttpPost]
        public ActionResult _Terceros(MTercero item)
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
                    string existid = conector.QueryString("SELECT id FROM tercero WHERE nombre={0} AND eliminado IS NULL LIMIT 1", Query.GetValor(item.Nombre));
                    if (!string.IsNullOrEmpty(existid) && existid != id)
                        return Content(string.Format("alert({0});", Query.GetValor("Ya existe un proveedor llamado " + Query.GetValor(item.Nombre))));

                    conector.StartTransaction();
                    Query query = new Query("tercero");

                    query["nombre"] = item.Nombre;
                    query["descripcion"] = item.Descripcion;
                    query["tipo"] = "1";
                    query["identificacion"] = item.Identificacion;
                    query["telefono"] = item.Telefono;
                    query["direccion"] = item.Direccion;
                    query["email"] = item.EMail;

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

                    conector.Commit();
                    MTercero.CleanCache(id);

                    return Content(string.Format("$('#PP').modal('hide'); $('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Proveedor {0} editado", item.Nombre))));
                }
            }
            return PartialView(item);
        }

        public ActionResult Terceros()
        {
            return View();
        }
    }
}