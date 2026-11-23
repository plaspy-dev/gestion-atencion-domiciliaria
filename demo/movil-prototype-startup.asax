<%@ Application Language="C#" %>
<script runat="server">
    void Application_Start(object sender, System.EventArgs args)
    {
        movil.BundleConfig.RegisterBundles(System.Web.Optimization.BundleTable.Bundles);
        Map("MsAjaxBundle", "~/bundles/MsAjaxJs");
        Map("WebFormsBundle", "~/bundles/WebFormsJs");
        Map("jquery", "~/Scripts/jquery-1.10.2.min.js");
        Map("bootstrap", "~/Scripts/bootstrap.min.js");
    }
    void Map(string name, string path)
    {
        System.Web.UI.ScriptManager.ScriptResourceMapping.AddDefinition(name,
            new System.Web.UI.ScriptResourceDefinition { Path = path, DebugPath = path });
    }
</script>
