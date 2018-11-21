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
        public ActionResult __Aseguradores(int current, int rowCount, Dictionary<string, string> sort, string searchPhrase = null)
        {
            CUsuario usuario = ViewBag.User;
            string where = " eliminado IS NULL";
            if (!string.IsNullOrEmpty(searchPhrase))
                where += string.Format(" AND entNombre LIKE CONCAT('%',{0},'%') ", Query.GetValor(searchPhrase));

            Query query = new Query("asegurador");

            query["id"]= "entId";
            query["n"]= "entNombre";
            query["e"] = "entEPS";
            query["a"] = "entAFP";
            query["r"] = "entARP";
            query["na"] = "entPrgNoAut";
            query["m"] = "maximo_mensual";
            query["p"] = "maximo_paciente";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM asegurador WHERE " + where
                    , query.GetSelect(where, null)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data, HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
            }
        }

        [HttpGet]
        public ActionResult _Aseguradores(string id)
        {
            Asegurador item = Asegurador.GetItem(id);
            return PartialView(item);
        }

        [HttpPost]
        public ActionResult ___Aseguradores(string id)
        {
            using (CConector conector = new CConector())
            {
                CUsuario user = ViewBag.User;
                conector.StartTransaction();
                Query query = new Query("asegurador");

                query["eliminado"] = "NOW()";
                if (conector.QueryMod(query.GetUpdate("entId={0}", Query.GetValor(id))) == -1 || conector.InsertModificacion(id)==-1)
                {
                    return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                }

                conector.Commit();
                Asegurador.CleanCache(id);
                return Content(string.Format("$('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Asegurador eliminado"))));
            }
        }

        [HttpPost]
        public ActionResult _Aseguradores(Asegurador item)
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
                    string existid = conector.QueryString("SELECT entId FROM asegurador WHERE entNombre={0} AND eliminado IS NULL LIMIT 1", Query.GetValor(item.Nombre));
                    if (!string.IsNullOrEmpty(existid) && existid != id)
                        return Content(string.Format("alert({0});", Query.GetValor("Ya existe un asegurador llamado " + Query.GetValor(item.Nombre))));

                    conector.StartTransaction();
                    Query query = new Query("asegurador");

                    query["entNombre"] = item.Nombre;
                    query["entEPS"] = item.EPS ? "1" : "0";
                    query["entAFP"] = item.AFP ? "1" : "0";
                    query["entARP"] = item.ARP ? "1" : "0";
                    query["entPrgNoAut"] = item.ProgramarSinAutorizacion ? "1" : "0";
                    query["maximo_mensual"] = item.MaximoMensual;
                    query["maximo_paciente"] = item.MaximoPaciente;

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
                        if (conector.QueryMod(query.GetUpdate("entId={0}", Query.GetValor(id))) == -1)
                        {
                            return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                        }
                    }
                    if (conector.InsertModificacion(id)==-1)
                    {
                        return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                    }

                    conector.Commit();
                    Asegurador.CleanCache(id);

                    return Content(string.Format("$('#PP').modal('hide'); $('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Asegurador {0} editado", item.Nombre))));
                }
            }
            return PartialView(item);
        }

        public ActionResult Aseguradores()
        {
            return View();
        }
    }
}