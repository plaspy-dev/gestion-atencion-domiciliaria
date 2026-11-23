using System.Web;

namespace SDG.Web;

public interface IHttpHandlerEx : IHttpHandler
{
	string AppRelativeVirtualPath { get; set; }
}
