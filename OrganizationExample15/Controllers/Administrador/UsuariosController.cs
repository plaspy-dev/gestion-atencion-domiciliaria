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
        public ActionResult __Usuarios(int current, int rowCount, Dictionary<string, string> sort, string searchPhrase = null)
        {
            CUsuario usuario = ViewBag.User;
            string where = " (usuario.estado IS NULL OR usuario.estado NOT IN (1,-1))";
            if (!string.IsNullOrEmpty(searchPhrase))
            {
                foreach(string text in searchPhrase.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries))
                    where += string.Format(" AND (usuario.nombre LIKE CONCAT('%',{0},'%') OR usuario.usuario LIKE CONCAT('%',{0},'%'))", Query.GetValor(text));
            }

            Query query = new Query("usuario");

            query["id"]= "usuario.id";
            query["n"] = "usuario.nombre";
            query["u"] = "usuario.usuario";
            query["g"] = "IF(usuario.grupo=0, '(Administrador)',grupo.nombre)";
            query["i"] = "usuario.ingreso";
            query["e"] = "IF(usuario.estado=0, 1, NULL)";
            query["c"] = "usuario.cumpleanos";

            string join = "LEFT JOIN grupo ON (grupo.id=usuario.grupo)";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM usuario WHERE " + where
                    , query.GetSelect(where, join)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data, HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
            }
        }

        [HttpGet]
        public ActionResult _Usuarios(string id)
        {
            HSUsuario item = HSUsuario.GetItem(id);
            if (string.IsNullOrEmpty(item.Id)) {
                item.CambioContrasena = true;
                item.Cumpleanos = true;
            }
            return PartialView(item);
        }

        [HttpPost]
        public ActionResult ___Usuarios(string id)
        {
            using (CConector conector = new CConector())
            {
                CUsuario user = ViewBag.User;
                conector.StartTransaction();
                Query query = new Query("usuario");

                query["estado"] = "-1";
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1 || conector.InsertModificacion(id)==-1)
                {
                    return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                }

                conector.Commit();
                HSUsuario.CleanCache(id);
                return Content(string.Format("$('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Usuario eliminado"))));
            }
        }

        [HttpPost]
        public ActionResult _Usuarios(HSUsuario item)
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
                    string existid = conector.QueryString("SELECT id FROM usuario WHERE usuario={0} AND estado IS NULL LIMIT 1", Query.GetValor(item.Usuario));
                    if (!string.IsNullOrEmpty(existid) && existid != id)
                        return Content(string.Format("alert({0});", Query.GetValor("Ya existe un usuario llamado " + Query.GetValor(item.Usuario))));

                    if (string.IsNullOrEmpty(item.Funcionario.Nombre)) {
                        return Content(string.Format("alert({0});", Query.GetValor("Por favor ingrese el nombre del usuario")));
                    }

                    conector.StartTransaction();
                    Query query = new Query("usuario");

                    if(string.IsNullOrEmpty(item.Funcionario.Id))
                        query["nombre"] = item.Funcionario.Nombre;
                    else query["nombre"] = Funcionario.GetFuncionario(item.Funcionario.Id).Nombres;
                    query["usuario"] = item.Usuario;
                    query["grupo"] = item.Grupo;
                    query["personal"] = item.Funcionario.Id;
                    query["cumpleanos"] = item.Cumpleanos ? "1": null;
                    if (item.CambioContrasena)
                        query["forceurl"] = "~/Contrasena";
                    else query["forceurl"] = ""; // reseteamos el usuario para evitar que entre en un bucle.
                    query["cargos"] = string.Join(",", item.Cargos);
                    query["entidades"] = string.Join(",", item.Entidades);
                    if (!string.IsNullOrEmpty(item.Contrasena))
                        query.AddCampo("contrasena", "PASSWORD(" + Query.GetValor(item.Contrasena) + ")", false);

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

                    if (conector.QueryMod("DELETE FROM usuario_alerta WHERE usIdUsuario=" + Query.GetValor(item.Usuario)) == -1)
                        return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));

                    Query alertas = new Query("usuario_alerta");
                    alertas["usIdUsuario"] = item.Usuario;

                    foreach(string alerta in item.Alertas)
                    {
                        alertas["tarId"] = alerta;
                        if (conector.QueryMod(alertas.GetInsert()) == -1)
                            return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                    }

                    conector.Commit();
                    HSUsuario.CleanCache(id);

                    return Content(string.Format("$('#PP').modal('hide'); $('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Usuario {0} editado", item.Usuario))));
                }
            }
            return PartialView(item);
        }

        public ActionResult Usuarios()
        {
            return View();
        }
    }
}