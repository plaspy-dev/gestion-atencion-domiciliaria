using System.Web;
using System.Web.Routing;

namespace SDG.Componentes;

public class CURLs
{
	public int Permisos { get; set; }

	public string URL { get; protected set; }

	public bool Visible { get; set; }

	public string Titulo { get; protected set; }

	public string Parent { get; protected set; }

	public string FullURL
	{
		get
		{
			try
			{
				return VirtualPathUtility.ToAbsolute(URL);
			}
			catch
			{
			}
			return "";
		}
	}

	public string RoutedURL
	{
		get
		{
			RequestContext requestContext = new RequestContext(new HttpContextWrapper(HttpContext.Current), new RouteData());
			try
			{
				return RouteTable.Routes.GetVirtualPath(requestContext, URL, null).VirtualPath;
			}
			catch
			{
			}
			return URL;
		}
	}

	public CURLs(string url, string titulo, string parent)
	{
		Visible = true;
		URL = url;
		Titulo = titulo;
		Parent = parent;
		Permisos = 0;
	}

	public CURLs(string url, string titulo, string parent, bool visible)
	{
		Visible = visible;
		URL = url;
		Titulo = titulo;
		Parent = parent;
		Permisos = 0;
	}

	public CURLs(string url, string titulo, string parent, int permisos)
	{
		Visible = true;
		URL = url;
		Titulo = titulo;
		Parent = parent;
		Permisos = permisos;
	}

	public CURLs(string url, string titulo, string parent, int permisos, bool visible)
	{
		Visible = visible;
		URL = url;
		Titulo = titulo;
		Parent = parent;
		Permisos = permisos;
	}
}
