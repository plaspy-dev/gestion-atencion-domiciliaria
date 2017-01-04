using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;

public class BundleConfig
{
    public static void RegisterBundles(BundleCollection bundles)
    {
        bundles.Add(new ScriptBundle("~/js/0").Include(
                    "~/Scripts/jquery-{version}.js"
                    , "~/Scripts/bootstrap.js"
                    , "~/Scripts/moment-with-locales.min.js"
                    , "~/js/bootstrap-datetimepicker.min.js"
                    , "~/Scripts/bloodhound.min.js"
                    , "~/Scripts/typeahead.bundle.min.js"
                    , "~/Scripts/typeahead.jquery.js"
                    , "~/js/jquery.updatepanel.js"
                    , "~/js/jquery.autonumeric.js"
                    , "~/js/jquery.maskedinput-1.4.1.min.js"
                    , "~/js/main.js"
                    , "~/js/autocomplete.js"
                    ));

        bundles.Add(new StyleBundle("~/css/0").Include(
            "~/Content/bootstrap.css"
            , "~/Content/font-awesome.css"
            , "~/css/bootstrap-datetimepicker.css"
            ,"~/css/estilo.css"
            ));

        // BundleTable.EnableOptimizations = true;
    }
}