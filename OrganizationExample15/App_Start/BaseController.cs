using System;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using OrganizationExample15;

[Authorize]
public class BaseController : Controller
{
    public static Func<BaseController, bool> _OnActionExecuting = null;
    public bool IsResponseEnd
    {
        get
        {
            return Response.IsRequestBeingRedirected || System.Web.HttpContext.Current.Items["Response.End"] != null;
        }
    }

    public class _Layout {

        public string Params { get; set; }
        public CUsuario User { get; set; }
        protected List<Alertas> _Alertas { get; set; }
        public List<Alertas> ListAlertas {
            get {
                if(_Alertas==null)
                    _Alertas=Alertas.GetAlertas();
                return _Alertas;
            }
        }

        public _Layout(CUsuario user) {
            User = user;
        }
    }

    protected override void OnAuthorization(AuthorizationContext filterContext) {

        if (User?.Identity?.IsAuthenticated==true)
        {
            using (CConector conector = new CConector()) {
                CUsuario usuario= CUsuario.GetUser(conector, User.Identity.Name);
                ViewBag.User = usuario;

                List<HomeCarePolicyAttribute> list = HomeCarePolicyAttribute.GetHSPolicy(filterContext.ActionDescriptor);
                if (list != null)
                {
                    foreach (HomeCarePolicyAttribute attr in list)
                    {
                        if (attr.CanAccess(usuario))
                            return;
                    }
                } else {
                    list = HomeCarePolicyAttribute.GetHSPolicy(this.GetType().GetTypeInfo());
                    if (list != null) {
                        foreach (HomeCarePolicyAttribute attr in list)
                        {
                            if (attr.CanAccess(usuario))
                                return;
                        }
                    }
                }

                if (!usuario.CanAccess()) {
                    filterContext.Result = new RedirectResult(FormsAuthentication.DefaultUrl);
                }
            }
        }
    }

    protected override void OnActionExecuting(ActionExecutingContext context) {

        if (IsResponseEnd || (_OnActionExecuting != null && !_OnActionExecuting(this)))
        {
            context.Result = new EmptyResult();
            return;
        }
        ViewBag._Layout = new _Layout(ViewBag.User);
        if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
            ViewBag._Layout.Params = "?pid=" + Request.QueryString["pid"];
        else if (!string.IsNullOrEmpty(Request.QueryString["spid"]))
            ViewBag._Layout.Params = "?pid=" + Request.QueryString["spid"];
        base.OnActionExecuting(context);
    }
}