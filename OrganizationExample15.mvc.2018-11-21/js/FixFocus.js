var FixFocus = (function() {
    var lastFocusedControlId = "";

    function focusHandler(e) {
        document.activeElement = e.originalTarget;
    }

    function appInit() {
        if (typeof (window.addEventListener) !== "undefined") {
            window.addEventListener("focus", focusHandler, true);
        }
        Sys.WebForms.PageRequestManager.getInstance().add_pageLoading(pageLoadingHandler);
        Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(pageLoadedHandler);
    }

    function pageLoadingHandler(sender, args) {
        lastFocusedControlId = typeof (document.activeElement) === "undefined"
            ? "" : (document.activeElement ? document.activeElement.id : null);
    }

    function focusControl(targetControl) {
        if (!targetControl)
            return;
        if (!$(targetControl).is(":focusable")) // si no se puede obtener el foco use el siguiente control.
            return focusControl($(':input:eq(' + ($(':input').index(targetControl) + 1) + ')')[0]);
        if (Sys.Browser.agent === Sys.Browser.InternetExplorer) {
            var focusTarget = targetControl;
            if (focusTarget && (typeof (focusTarget.contentEditable) !== "undefined")) {
                oldContentEditableSetting = focusTarget.contentEditable;
                focusTarget.contentEditable = false;
            }
            else {
                focusTarget = null;
            }
            try {
                targetControl.focus();
            } catch (e) { }
            if (focusTarget) {
                focusTarget.contentEditable = oldContentEditableSetting;
            }
        } else {
            targetControl.focus();
        }
    }

    function pageLoadedHandler(sender, args) {
        if (typeof (lastFocusedControlId) !== "undefined" && lastFocusedControlId != "") {
            var newFocused = $get(lastFocusedControlId);
            if (newFocused) {
                focusControl(newFocused);
            }
        }
    }
    Sys.Application.add_init(appInit);
})();