using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OrganizationExample15.Controllers
{
    public class IndexController : Controller
    {
        public ActionResult Index() {

            return Redirect("~/Default.aspx");
        }
    }
}