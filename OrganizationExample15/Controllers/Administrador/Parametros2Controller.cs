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
        public ActionResult __Parametros2(int current, int rowCount, Dictionary<string, string> sort, uint? t, string searchPhrase = null)
        {
            CUsuario usuario = ViewBag.User;
            Parametro2.Tipo tipo = (Parametro2.Tipo)t.Value;
            Query queryparametro = Parametro2.GetTables(tipo);
            var list = queryparametro.Fields.ToList();

            string where = Parametro2.GetCondicion(tipo);
            if (!string.IsNullOrEmpty(searchPhrase))
            {
                where += string.Format(" AND {1} LIKE CONCAT('%',{0},'%') ", Query.GetValor(searchPhrase), list[1].Key);
            }
            
            Query query = new Query(queryparametro.TableName);
            
            query["id"] = list[0].Key;
            query["n"] = list[1].Key;

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM " + queryparametro.TableName + " WHERE " + where
                    , query.GetSelect(where, null)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data, HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
            }
        }

        [HttpGet]
        public ActionResult _Parametros2(string id, uint? t)
        {
            if (t == null)
                return HttpNotFound();
            Parametro2 item = Parametro2.GetItem((Parametro2.Tipo)t.Value,id);
            item.ProtectedFields["tid"] = t.ToString();
            return PartialView(item);
        }

        [HttpPost]
        public ActionResult ___Parametros2(string id, uint? t)
        {
            using (CConector conector = new CConector())
            {
                Parametro2.Tipo tipo = (Parametro2.Tipo)t.Value;
                Query query = Parametro2.GetTables(tipo);
                var list = query.Fields.ToList();
                string keyidname = list[0].Key;

                CUsuario user = ViewBag.User;
                conector.StartTransaction();

                query.Fields.Clear();

                query["eliminado"] = "NOW()";

                if (conector.QueryMod(query.GetUpdate("{0}={1}", keyidname, Query.GetValor(id))) == -1 || conector.InsertModificacion(id) == -1)
                {
                    return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                }

                conector.Commit();
                Parametro2.CleanCache(tipo, id);
                return Content(string.Format("$('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Parámetro eliminado"))));
            }
        }

        [HttpPost]
        public ActionResult _Parametros2(Parametro2 item)
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
                    Parametro2.Tipo tipo = (Parametro2.Tipo)Convert.ToInt32(item.ProtectedFields["tid"]);
                    Query query = Parametro2.GetTables(tipo);
                    var list = query.Fields.ToList();
                    string keyidname = list[0].Key;

                    string existid = conector.QueryString("SELECT {0} FROM {1} WHERE {2}={3} AND eliminado IS NULL LIMIT 1", keyidname, query.TableName, list[1].Key, Query.GetValor(item.Nombre));
                    if (!string.IsNullOrEmpty(existid) && existid != id)
                        return Content(string.Format("alert({0});", Query.GetValor("Ya existe un parámetro llamado " + Query.GetValor(item.Nombre))));

                    conector.StartTransaction();
                    

                    query[list[1].Key] = item.Nombre;
                    query.RemoveCampo(keyidname); // id

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
                        if (conector.QueryMod(query.GetUpdate("{0}={1}", keyidname, Query.GetValor(id))) == -1)
                        {
                            return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                        }
                    }
                    if (conector.InsertModificacion(id) == -1)
                    {
                        return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                    }

                    conector.Commit();
                    Parametro2.CleanCache(tipo, id);

                    return Content(string.Format("$('#PP').modal('hide'); $('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Parámetro {0} editado", item.Nombre))));
                }
            }
            return PartialView(item);
        }

        public ActionResult Parametros2(uint? t)
        {
            return View();
        }
    }
}