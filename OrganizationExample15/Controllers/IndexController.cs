using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using OrganizationExample15.Models;

namespace OrganizationExample15.Controllers
{
    public class IndexController : Controller
    {
        public ActionResult Index() {
            LogIn login = new LogIn();

            string end = Request.QueryString["end"];
            if (end == "1")
            {
                Session.RemoveAll();
                CConector.SetCookie("contrasena", "");
                FormsAuthentication.SignOut();
                Response.Redirect("~/");
            }

            CUsuario usuario = (CUsuario)CUsuario.Validate();
            if (usuario != null)
            {
                FormsAuthentication.SetAuthCookie(usuario.Id, true);
                string url = Request.QueryString["from"];
                if (url == null || url.Length == 0)
                {
                    usuario.Redirect();
                    return new EmptyResult();
                }
                return Redirect(url);
            }

            login.User = CConector.GetCookie("loginOrganizationExample15");
            return View(login);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(LogIn login)
        {
            if (ModelState.IsValid) {
                CUsuario usuario = (CUsuario)CUsuario.Validate(login.User, login.Password);
                if (usuario != null)
                {
                    FormsAuthentication.SetAuthCookie(usuario.Id, true);
                    string url = Request.QueryString["from"];
                    if (url == null || url.Length == 0)
                    {
                        usuario.Redirect();
                        return new EmptyResult();
                    } else return Redirect(url);
                }
                login.Password = null;
                ModelState.AddModelError("", "Usuario o contraseña equivocada.");
                System.Threading.Thread.Sleep(3000);
            }
            return View(login);
        }
    }
}