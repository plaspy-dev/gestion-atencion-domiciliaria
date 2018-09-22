using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

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
        public CUsuario User { get; set; }
        // protected _TreeView {get;set;}
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

    protected override void OnActionExecuting(ActionExecutingContext context) {

        ViewBag.User = CUsuario.GetInstance();
        if (IsResponseEnd || (_OnActionExecuting != null && !_OnActionExecuting(this)))
        {
            context.Result = new EmptyResult();
            return;
        }
        ViewBag._Layout = new _Layout(ViewBag.User);
        base.OnActionExecuting(context);
    }
}