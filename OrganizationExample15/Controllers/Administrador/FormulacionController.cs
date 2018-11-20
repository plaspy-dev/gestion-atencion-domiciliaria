using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models.Administrador;
using Newtonsoft.Json;
using MySql.Data.MySqlClient;
using SDG.Componentes;

namespace OrganizationExample15.Controllers.Administrador
{
    public partial class AdministradorController : BaseController
    {
        public ActionResult __Formulacion(int current, int rowCount, Dictionary<string, string> sort, uint? t, string searchPhrase = null)
        {
            CUsuario usuario = ViewBag.User;
            string where = string.Format(" tipo={0} AND estado IS NULL", Query.GetValor(t));
            if (!string.IsNullOrEmpty(searchPhrase))
            {
                foreach (string text in searchPhrase.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    where += string.Format(" AND (nombre LIKE CONCAT('%',{0},'%') OR codigo LIKE CONCAT('%',{0},'%') OR principio LIKE CONCAT('%',{0},'%') OR concentracion LIKE CONCAT('%',{0},'%')) ", Query.GetValor(text));
                }
            }

            Query query = new Query("medicamentos");

            query["id"] = "id";
            query["n"] = "nombre";
            query["f"] = "forma";
            query["c"]= "codigo";
            query["p"]= "principio";
            query["co"]= "concentracion";
            query["a"]= "aclaracion";
            query["ar"]= "area";

            using (CConector conector = new CConector())
            {
                BootgridResponseData data = BootgridResponseData.GetFormatedData(conector
                    , @"SELECT COUNT(*) FROM medicamentos WHERE " + where
                    , query.GetSelect(where, null)
                    , current
                    , rowCount
                    , sort
                    );

                return Content(JsonConvert.SerializeObject(data, HomeCareVersion.JsonSerializerSettingsCamelCase), HomeCareVersion.JSONContentType);
            }
        }

        [HttpGet]
        public ActionResult _Formulacion(string id, uint? t)
        {
            if (t == null)
                return HttpNotFound();
            MProcedimiento item = MProcedimiento.GetItem(id);
            if (string.IsNullOrEmpty(item.Id))
            {
                item.ProtectedFields["tid"] = t.ToString();
            }
            using (CConector conector = new CConector())
            {
                MySqlDataReader reader = conector.Query("SELECT carId id,carDescripcion nombre FROM cargo ORDER BY 2;");
                if (reader != null)
                {
                    List<SelectListItem> list = new List<SelectListItem>();
                    while (reader.Read())
                    {
                        list.Add(new SelectListItem() { Value = reader["id"].ToString(), Text = reader["nombre"].ToString() });
                    }
                    ViewBag._Cargos = list;
                }
            }
            return PartialView(item);
        }

        [HttpPost]
        public ActionResult ___Formulacion(string id)
        {
            using (CConector conector = new CConector())
            {
                CUsuario user = ViewBag.User;
                conector.StartTransaction();
                Query query = new Query("varios");

                query["estado"] = "-1";
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1 || conector.InsertModificacion(id) == -1)
                {
                    return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                }

                conector.Commit();
                MProcedimiento.CleanCache(id);
                return Content(string.Format("$('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Procedimiento eliminada"))));
            }
        }

        [HttpPost]
        public ActionResult _Formulacion(MProcedimiento item)
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
                    string existid = conector.QueryString("SELECT id FROM medicamentos WHERE nombre={0} AND IFNULL(principio,'')=IFNULL({1},'') AND tipo={2} estado IS NULL LIMIT 1", Query.GetValor(item.Nombre), Query.GetValor(item.Forma), Query.GetValor(item.ProtectedFields["tid"]));
                    if (!string.IsNullOrEmpty(existid) && existid != id)
                        return Content(string.Format("alert({0});", Query.GetValor("Ya existe un procedimiento llamado " + Query.GetValor(item.Nombre))));

                    conector.StartTransaction();
                    Query query = new Query("medicamentos");

                    query["nombre"] = item.Nombre;
                    query["forma"]= item.Forma;
                    query["codigo"]= item.Codigo;
                    query["principio"]= item.PrincipioActivo;
                    query["concentracion"]=item.Concentracion;
                    query["aclaracion"]=item.Aclaracion;
                    query["area"]=item.Area;
                    query["grupo"]=item.Area;
                    query["hoja_sola"] = item.ImprimirUnaHoja ? "1" : null;
                    query["precio_regulado"]= HomeCareVersion.ParseDecimal(item.PrecioRegulado);
                    query["precio"]= HomeCareVersion.ParseDecimal(item.Precio);
                    query["codigoSIIGO"]=item.CodigoSIIGO;
                    query["cuenta_inventario"]= item.CuentaInventario;
                    query["cuenta_costo"]=item.CuentaCosto;
                    query["tipo_servicio"]=item.TipoServicio;

                    if (string.IsNullOrEmpty(id))
                    {
                        query["tipo"] = item.ProtectedFields["tid"];
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

                    // agregamos los cargos que puede programar el usuario
                    if (conector.QueryMod("DELETE FROM medicamento_area WHERE medicamento=" + Query.GetValor(id)) == -1)
                        return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));

                    Query areas = new Query("medicamento_area");
                    areas["medicamento"] = id;

                    foreach (string area in item.Areas) 
                    {
                        areas["area"] = area;
                        if (conector.QueryMod(areas.GetInsert()) == -1)
                            return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                    }

                    // agregamos los cargos que puede programar el usuario
                    if (conector.QueryMod("DELETE FROM costo_proveedor WHERE producto=" + Query.GetValor(id)) == -1)
                        return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                    Query costos = new Query("costo_proveedor");
                    costos["producto"] = id;

                    foreach (var costo in item.Costos) 
                    {
                        if(!string.IsNullOrEmpty(costo.Costo))
                        {
                            decimal? dcosto= HomeCareVersion.ParseDecimal(costo.Costo);
                            if (dcosto != null && dcosto != 0) {
                                costos["proveedor"] = costo.Proveedor;
                                costos["costo"] = dcosto;
                                if (conector.QueryMod(costos.GetInsert()) == -1)
                                    return Content(string.Format("alert({0});", Query.GetValor(conector.LastError)));
                            }
                        }
                    }

                    conector.Commit();
                    MProcedimiento.CleanCache(id);
                    CProductoValor.Delete(id);

                    return Content(string.Format("$('#PP').modal('hide'); $('#gpe').bootgrid('reload'); toastr.success({0});", Query.GetValor(string.Format("Procedimiento {0} editado", item.Nombre))));
                }
            }
            return PartialView(item);
        }

        public ActionResult Formulacion()
        {
            return View();
        }
    }
}