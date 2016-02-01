using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(movil.Startup))]
namespace movil
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
