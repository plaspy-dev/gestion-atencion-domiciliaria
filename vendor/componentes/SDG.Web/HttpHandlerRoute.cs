using System.Web;
using System.Web.Compilation;
using System.Web.Routing;

namespace SDG.Web;

public class HttpHandlerRoute : IRouteHandler
{
	private string _VirtualPath;

	public HttpHandlerRoute(string virtualPath)
	{
		_VirtualPath = virtualPath;
	}

	public IHttpHandler GetHttpHandler(RequestContext requestContext)
	{
		IHttpHandler httpHandler = (IHttpHandler)BuildManager.CreateInstanceFromVirtualPath(_VirtualPath, typeof(IHttpHandler));
		if (httpHandler is IHttpHandlerEx)
		{
			((IHttpHandlerEx)httpHandler).AppRelativeVirtualPath = _VirtualPath;
		}
		return httpHandler;
	}
}
