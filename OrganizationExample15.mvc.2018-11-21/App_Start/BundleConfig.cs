using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;

public class BundleConfig
{
    public static void RegisterBundles(BundleCollection bundles)
    {
        // MasterPage
        bundles.Add(new ScriptBundle("~/js/m").Include(
                    "~/js/jquery-1.7.2.min.js"
                    , "~/js/jquery.cookie.js"
                    , "~/js/jquery-ui-1.8.13.custom.min.js"
                    , "~/js/jquery.ui.autocomplete.selectFirst.js"
                    , "~/js/jquery.ui.datepicker-es.js"
                    , "~/js/jquery-ui-timepicker-addon.js"
                    , "~/js/jquery.updatepanel.js"
                    , "~/js/jquery.maskedinput-1.3.min.js"
                    , "~/js/jquery.autonumeric.js"
                    , "~/js/combo.js"
                    , "~/js/main.js"
                    ));

        bundles.Add(new ScriptBundle("~/js/mb").Include(
                    "~/lib/popper.js/popper.min.js"
                    , "~/lib/bootstrap-4.1.2/js/bootstrap.min.js"
                    , "~/lib/momentjs/moment-with-locales.js"
                      , "~/lib/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js"
                      , "~/lib/bloodhound/bloodhound.js"
                      , "~/lib/typeahead.jquery/typeahead.jquery.mod.js"
                    , "~/js/jquery.cookie.js"
                    , "~/lib/autonumeric-4.1.0/autonumeric.min.js"
                    , "~/lib/jquery-validation/dist/jquery.validate.js"
                    , "~/lib/jquery-validation-unobtrusive/jquery.validate.unobtrusive.js"
                    , "~/lib/toastr/toastr.min.js"
                    , "~/js/validators.js"
                    , "~/js/mainmvc.js"
                    ));

        bundles.Add(new StyleBundle("~/css/mb").Include(
            "~/lib/bootstrap-4.1.2/css/bootstrap.min.css"
            , "~/css/font-awesome.min.css"
            , "~/lib/bootstrap-datetimepicker/css/bootstrap-datetimepicker-standalone.css"
            , "~/lib/bootstrap-datetimepicker/css/bootstrap-datetimepicker.min.css"
            , "~/lib/toastr/toastr.min.css"
            , "~/css/estilo.css"
            ));

        bundles.Add(new StyleBundle("~/css/m").Include(
            "~/css/ui-lightness/jquery-ui-1.8.13.custom.css"
            , "~/css/ui-lightness/jquery-ui-numeric-min.css"
            , "~/css/bootstrap.min.css"
            , "~/css/font-awesome.min.css"
            , "~/css/estilo.css"
            ));

        // BundleTable.EnableOptimizations = true;
        /*
        bundles.Add(new ScriptBundle("~/js/m").Include(
                    "~/js/"
                    ,"~/js/"
                    ));

        bundles.Add(new StyleBundle("~/css/m").Include(
            "~/css/"
            , "~/css/"
            ));
        */
    }
}