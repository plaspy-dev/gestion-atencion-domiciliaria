var FixFocus = (function () {
    jQuery.expr[':'].focusable = function (element) {

        var map, mapName, img,
        nodeName = element.nodeName.toLowerCase(),
        isTabIndexNotNaN = !isNaN($.attr(element, "tabindex"));
        if ("area" === nodeName) {
            map = element.parentNode;
            mapName = map.name;
            if (!element.href || !mapName || map.nodeName.toLowerCase() !== "map") {
                return false;
            }
            img = $("img[usemap=#" + mapName + "]")[0];
            return !!img && visible(img);
        }
        return (/input|select|textarea|button|object/.test(nodeName) ?
            !element.disabled :
            "a" === nodeName ?
                element.href || isTabIndexNotNaN :
                isTabIndexNotNaN) &&
            // the element and all of its ancestors must be visible
            visible(element);

        function visible(element) {
            return $.expr.filters.visible(element) &&
              !$(element).parents().addBack().filter(function () {
                  return $.css(this, "visibility") === "hidden";
              }).length;
        }
    }

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