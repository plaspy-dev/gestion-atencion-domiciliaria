// arreglos para el mono
var Page_IsValid = true;
var webForm = window;

ValidatorEnable = function(elemento, enable) { try { elemento._enabled = enable; } catch (e) { } };
webForm.WebForm_DoPostBackWithOptions = function(options) {
    Page_IsValid = true;
    if (options.validation && typeof (webForm.Page_ClientValidate) == "function")
        Page_IsValid = webForm.Page_ClientValidate(options.validationGroup);

    if (Page_IsValid) {
        if ((typeof (options.actionUrl) != "undefined") && (options.actionUrl != null) && (options.actionUrl.length > 0))
            webForm._form.action = options.actionUrl;
        if (options.trackFocus) {
            var lastFocus = webForm._form.elements["__LASTFOCUS"];
            if ((typeof (lastFocus) != "undefined") && (lastFocus != null))
                lastFocus.value = options.eventTarget;
        }
    }
    if (options.clientSubmit)
        webForm.__doPostBack(options.eventTarget, options.eventArgument);
}

Sys.Browser.WebKit = {};
if (navigator.userAgent.indexOf('WebKit/') > -1) {
    Sys.Browser.agent = Sys.Browser.WebKit;
    Sys.Browser.version = parseFloat(navigator.userAgent.match(/WebKit\/(\d+(\.\d+)?)/)[1]);
    Sys.Browser.name = 'WebKit';
}

// corregimos la deteccion del Internet explorer 11
Sys.Browser.IE11 = {};
if (!!(navigator.userAgent.match(/Trident/) && !navigator.userAgent.match(/MSIE/))) {
    Sys.Browser.agent = Sys.Browser.IE11;
    Sys.Browser.version = parseFloat(navigator.userAgent.match(/rv:(\d+(\.\d+)?)/)[1]);
    Sys.Browser.name = 'Internet Explorer';
}

// arregla el problema con los ImageButton que causan una excepcion no controlada por los decimales de las imagenes
$(function() {
    // Patch fractional .x, .y form parameters for IE10.
    if (typeof (Sys) !== 'undefined' && (Sys.Browser.agent === Sys.Browser.IE11 || (Sys.Browser.agent === Sys.Browser.InternetExplorer && Sys.Browser.version > 9))) {
        Sys.WebForms.PageRequestManager.getInstance()._onFormElementActive = function Sys$WebForms$PageRequestManager$_onFormElementActive(element, offsetX, offsetY) {
            if (element.disabled) {
                return;
            }
            this._activeElement = element;
            this._postBackSettings = this._getPostBackSettings(element, element.name);
            if (element.name) {
                var tagName = element.tagName.toUpperCase();
                if (tagName === 'INPUT') {
                    var type = element.type;
                    if (type === 'submit') {
                        this._additionalInput = encodeURIComponent(element.name) + '=' + encodeURIComponent(element.value);
                    }
                    else if (type === 'image') {
                        this._additionalInput = encodeURIComponent(element.name) + '.x=' + Math.floor(offsetX) + '&' + encodeURIComponent(element.name) + '.y=' + Math.floor(offsetY);
                    }
                }
                else if ((tagName === 'BUTTON') && (element.name.length !== 0) && (element.type === 'submit')) {
                    this._additionalInput = encodeURIComponent(element.name) + '=' + encodeURIComponent(element.value);
                }
            }
        };
    }
});