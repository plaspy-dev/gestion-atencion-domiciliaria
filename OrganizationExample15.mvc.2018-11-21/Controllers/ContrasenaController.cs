using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OrganizationExample15.Models;
using SDG.Componentes;

namespace OrganizationExample15.Controllers
{
    public class ContrasenaController : BaseController
    {
        public ActionResult Index() {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(Contrasena contrasena) {

            if (ModelState.IsValid) {
                using (CConector conector = new CConector())
                {
                    CUsuario usuario = ViewBag.User;
                    Query query = new Query("usuario");

                    String id = conector.QueryString("SELECT id FROM usuario WHERE id='" + usuario.GetID() + "' AND contrasena=PASSWORD(" + Query.GetValor(contrasena.CurrentPassword) + ")");
                    if (id.Length == 0)
                    {
                        ModelState.AddModelError("", "Contraseña actual incorrecta.");
                        System.Threading.Thread.Sleep(3000);
                        return View(contrasena);
                    }
                    else
                    {
                        query.AddCampo("contrasena", "PASSWORD(" + Query.GetValor(contrasena.Password) + ")", false);
                        if (conector.QueryMod(query.GetUpdate("id=" + usuario.GetID())) == -1)
                        {
                            ModelState.AddModelError("", conector.LastError);
                            return View(contrasena);
                        }
                        else
                        {
                            usuario.SetForceURL("", conector);
                            Usuario.Validate(usuario.GetLogin(), Crypt.EncriptarDES(contrasena.Password, System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_4")));
                            return Redirect(Request.Url.AbsolutePath + "?sp=1");
                        }
                    }
                }
            }
            return View(contrasena);
        }
    }
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 