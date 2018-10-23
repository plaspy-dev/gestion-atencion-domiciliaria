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
        public ActionResult __Indices(int current, int rowCount, Dictionary<string, string> sort, uint? t, string searchPhrase = null)
        {
            CUsuario usuario = ViewBag.User;
            string where = string.Format(" varios.tipo={0} AND varios.eliminado IS NULL", Query.GetValor(t));
            if (!string.IsNullOrEmpty(searchPhrase))
                where += string.Format(" AND (varios.nombre LIKE CONCAT('%',{0},'%') OR grupo.nombre LIKE CONCAT('%',{0},'%'))", Query.GetValor(searchPhrase));

            string join = "LEFT JOIN varios AS grupo ON (grupo.id=varios.parametro1)";

            Query query = new Query("varios");

            query["id"] = "varios.id";
            query["n"] = "varios.nombre";
            query["g"] = "grupo.nombre";
            query["d"] = "varios.descripcion";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM varios " + join + " WHERE " + where
                    , query.GetSelect(where, join)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data), HomeCareVersion.JSONContentType);
            }
        }

        [HttpGet]
        public ActionResult _Indices(string id, uint? t)
        {
            if (t == null)
                return HttpNotFound();
            MVarios item = MVarios.GetItem(id);
            item.ProtectedFields["pid"] = t.ToString();
            return PartialView(item);
        }

        [HttpPost]
        public ActionResult ___Indices(string id)
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
                return Content(string.Format("$('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Pregunta eliminada"))));
            }
        }

        [HttpPost]
        public ActionResult _Indices(MVarios item)
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
                        return Content(string.Format("alert({0});", Query.GetValor("Ya existe un pregunta llamado " + Query.GetValor(item.Nombre))));

                    conector.StartTransaction();
                    Query query = new Query("varios");

                    query["nombre"] = item.Nombre;
                    query["descripcion"] = item.Descripcion;

                    if (string.IsNullOrEmpty(id))
                    {
                        query["tipo"] = item.ProtectedFields["pid"];
                        query["parametro1"] = item.parametro1;
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

                    return Content(string.Format("$('#PP').modal('hide'); $('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Pregunta {0} editado", item.Nombre))));
                }
            }
            return PartialView(item);
        }

        // GET: EncuestaUsuario
        public ActionResult Indices()
        {
            return View();
        }
    }
}