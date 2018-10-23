$.gridLabels = {
    all: "Todos",
    infos: "Mostrando del {{ctx.start}} al {{ctx.end}} de {{ctx.total}} registros",
    loading: "Cargando...",
    noResults: "No se encontraron resultados!",
    refresh: "Actualizar",
    search: "Buscar"
};

var daterangepickerlocale = {
    "format": "DD/MM/YYYY",
    "separator": " - ",
    "applyLabel": "Aplicar",
    "cancelLabel": "Cancelar",
    "fromLabel": "Desde",
    "toLabel": "Hasta",
    "customRangeLabel": "Personalizado",
    "weekLabel": "S",
    "daysOfWeek": [
        "Do",
        "Lu",
        "Ma",
        "Mi",
        "Ju",
        "Vi",
        "Sa"
    ],
    "monthNames": [
        "Enero",
        "Febrero",
        "Marzo",
        "Abril",
        "Mayo",
        "Junio",
        "Julio",
        "Agosto",
        "Septiembre",
        "Octubre",
        "Noviembre",
        "Diciembre"
    ],
    "firstDay": 1
};

if (jQuery.validator && jQuery.validator.setDefaults) {
    jQuery.validator.setDefaults({
        ignore: ":hidden:not(.validate),.novalidate"
    });
}

function getSafeAngularModule() {
    try {
        return angular.module('OrganizationExample15App');
    } catch (e) { }
    return angular.module('OrganizationExample15App', []);
}

if (window.angular) {
    angular.module('OrganizationExample15App', []);
}

var normalize = function (input) {

    /*var charMap = {
        "à": "a",
        "á": "a",
        "â": "a",
        "é": "e",
        "è": "e",
        "ê": "e",
        "ë": "e",
        "É": "e",
        "ï": "i",
        "î": "i",
        "ô": "o",
        "ö": "o",
        "û": "u",
        "ù": "u",
        "ü": "u",
        "ñ": "n"
    };

    $.each(charMap, function (unnormalizedChar, normalizedChar) {
        var regex = new RegExp(unnormalizedChar, 'gi');
        input = input.replace(regex, normalizedChar);
    });*/
    return input.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
};

$.expr[":"].Contains = $.expr.createPseudo(function (arg) {
    return function (elem) {
        return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
    };
});

$.expr[":"].ContainsN = $.expr.createPseudo(function (arg) {
    return function (elem) {
        return normalize($(elem).text()).toUpperCase().indexOf(normalize(arg.toUpperCase())) >= 0;
    };
});

function removeFile(ahref, filename) {
    if (confirm("¿Esta seguro de eliminar el archivo " + filename + "?")) {
        var $deletedfiles = $(ahref).closest(".gallery").find("input.deletedfiles");
        var value = $deletedfiles.val() || "";
        value += "," + filename;
        $deletedfiles.val(value);
        $(ahref).closest(".gallery-item").remove();
    }
    return false;
}

function onSubmitList(form, event, list) {
    if (list && list.length > 0) {
        var index = 0;
        for (var i = 0; i < list.length; i++) {
            if (form._submitbtn == list[i][0]) {
                index = i + 1;
                break;
            }
        }
        if (list.length > index) {
            $(list[index][0]).attr("formaction", $(form._submitbtn).attr("formaction"));
            return list[index][1](form, event);
        }
    }
    return true;
}

$.fn.catchEnter = function (event) {
    return this.keydown(function (e) {
        if (e.which == 13 && !$(e.target).is("textarea")) {
            e.preventDefault(); //stops default action: submitting form
            $(this).blur();
            if (event) {
                event.call(this);
            } else $(this).find("input:submit,button:submit").first().focus().click();//give your submit an ID
        }
    });
};

$.fn._dropZone= function (options) {

    var _options = {
        maxFilesize: 2, // MB
        enqueueForUpload: true,
        dictDefaultMessage: "Arrastre sus archivos para subir",
        dictFallbackMessage: "Su navegador no soporta arrastrar archivos.",
        dictFallbackText: "Por favor use el formulario para subir los archivos.",
        dictFileTooBig: "El archivo es muy grande ({{filesize}}MiB). Tamaño máximo: {{maxFilesize}}MiB.",
        dictInvalidFileType: "No se pueden subir archivos de este tipo.",
        dictResponseError: "El servidor repondio con el código {{statusCode}}.",
        dictCancelUpload: "Cancelar subida",
        dictCancelUploadConfirmation: "¿Está seguro de cancelar esta subida?",
        dictRemoveFile: "Eliminar archivo",
        dictRemoveFileConfirmation: "¿Está seguro de eliminar este archivo?",
        dictMaxFilesExceeded: "No se pueden subir mas archivos."
        /*, accept: function (file, done) {
            var regex = /^\d+.*$/i;
            if (!regex.test(file.name)) {
                done("Por favor seleccione un archivo que comience por el numero de una ODS.");
            } else { done(); }
            done();
        }*/, success: function (file, response) {
            if (options._success)
                options._success.call(this, file, response);
            if (response.error) {
                _ref = file.previewElement.querySelectorAll("[data-dz-errormessage]");
                _results = [];
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                    node = _ref[_i];
                    _results.push(node.textContent = response.message);
                }
                return file.previewElement.classList.add("dz-error");
            }
            file._fileName = response.fileName;
            return file.previewElement.classList.add("dz-success");
        },
        removedfile: function (file) {
            var parent = file.previewElement.parentNode;
            parent.removeChild(file.previewElement);
            if (options._removedfile)
                options._removedfile.call(this, file);
        }
    };
    return this.dropzone($.extend(_options, options));
};

$.fn.catchEnterTab = function () {
    return this.keypress(function (e) {
        if (e.which == 13 && !$(e.target).is("textarea")) {
            var inputs = $(this).closest('form').find(':input:visible');
            if ($(this).attr('type') != 'button' &&
                $(this).attr('type') != 'submit') {
                inputs.eq(inputs.index(this) + 1).focus();
                $(this).change();
                e.preventDefault();
            }
        }
    });
};

/*
 * getData
 */
$.fn.ajaxForm = function (options) {
    return this.each(function () {
        var $This = $(this);
        $This.on("submit", "form", function (e) {
            e.preventDefault();  // prevent standard form submission
            var form = $(this);
            if (!options || !options.enableButtons) {
                form.find(":submit").each(function () {
                    $(this).hide().after('<input type="button" disabled="disabled" value="' + $(this).val() + '" class="' + $(this).attr('class') + '" />');
                });
                form.find("a.btn").each(function () {
                    $(this).hide().after('<a href="#" onclick="return false;" disabled="disabled" class="' + $(this).attr('class') + '">' + $(this).html() + '</a>');
                });
            }
            if (options && options.init) {
                options.init();
            }
            var data = form.serialize();
            if (options && options.getData)
                data = options.getData(data);
            $.ajax({
                url: form.attr("action"),
                method: form.attr("method"),  // post
                data: data,
                success: function (partialResult) {
                    if (options && options.success) {
                        options.success(partialResult);
                    } else {
                        if (partialResult.indexOf("<") == 0) {
                            $This.html($(partialResult).html());
                        } else eval(partialResult);
                    }
                }
            });
        });
    });
}

/*
localData
queryURL
controlDataId
selectURL
onSelected
onUnSelected
autoSelect
minLength
data
prepare
displayName
idField
*/
$.fn.THAutoComplete = function (options) {
    return $(this).each(function () {
        var $This = $(this);
        var dataSource = new Bloodhound({
            datumTokenizer: function (d) {
                return Bloodhound.tokenizers.whitespace(d.value)
            },
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            local: options.localData ? options.localData : undefined,
            remote: options.localData ? undefined : {
                url: options.queryURL + "#%QUERY",
                wildcard: '%QUERY',
                prepare: options.prepare,
                transport: function (opts, onSuccess, onError) {
                    var url = opts.url.split("#")[0];
                    var query = opts.url.split("#")[1];
                    var data = options.data || {};
                    if (typeof (data) == "function")
                        data = data.call(this) || {};
                    $.ajax({
                        url: url,
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify($.extend(data, { q: query })),
                        type: "POST",
                        beforeSend: function () {
                            $This.addClass("ui-autocomplete-loading");
                        },
                        complete: function () {
                            $This.removeClass("ui-autocomplete-loading");
                        },
                        success: function (data) {
                            onSuccess($.map(data.d ? data.d : data, function (item) {
                                return item;
                            }));
                        },
                        error: onError
                    })
                }
            }
        });

        var currentText = "";
        options.displayName = options.displayName || "name";
        options.idField = options.idField || "id";

        if (options.controlDataId && $(this).val() && $("#" + options.controlDataId).val()) {
            currentText = $(this).val();
        }

        function onKillFocus () {
            if (options.controlDataId) {
                if (!$(this).val() || $(this).val() != currentText) {
                    if ($("#" + options.controlDataId).val()) {
                        $("#" + options.controlDataId).val("");
                        if (options.onUnSelected)
                            options.onUnSelected();
                    }
                }
            }
        }

        $(this).typeahead({
            hint: true,
            highlight: true,
            minLength: options.minLength == 0 ? 0 : (options.minLength || 3),
            autoSelect: options.autoSelect
        },
            {
                display: options.displayName,
                limit: 100,
                source: dataSource
            })
            .focusout(onKillFocus)
            .change(onKillFocus)
            .on('typeahead:select', function (e, datum) {
                currentText = datum[options.displayName];
                if (options.controlDataId)
                    $("#" + options.controlDataId).val(datum[options.idField]).change();
                if (options.selectURL)
                    window.location = options.selectURL + datum[options.idField];
                if (options.onSelected != null) {
                    options.onSelected(datum);
                }
            });
    });
};

$.getUrlParameter = function (sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

var hiddenButtons = [];

function restoreSubmitButton() {
    $(".dummybutton").remove();
    for (var i = 0; i < hiddenButtons.length; i++)
        $(hiddenButtons[i]).removeClass("hide").show();
    hiddenButtons = [];
}

function onSelectAlert(id, titulo) {
    $.ajax({
        url: rootPath + "_Layout/Alerts",
        method: "post",
        data: { i: id},
        success: function (data) {
            var $modal = $("#malertas");
            var $list = $modal.find("ul.list-group");
            $modal.find(".modal-title").text(titulo);
            $list.find("li").remove();
            for (var i = 0; i < data.length; i++) {
                $list.append('<li class="list-group-item"><a href="' + data[i].URL + '">' + data[i].Nombre + '</a></li>');
            }
            $modal.modal("show");
        }
    });
    return false;
}
function resetForm(form) {
    var lastCheckBox = null;
    $(form).find("input,select").each(function () {
        var $this = $(this);
        var name = $this.attr("name");
        if (name && name != lastCheckBox) {
            if ($this.prop("tagName") == "SELECT") {
                $this.find("option[value='']").prop("selected", true);
            } else if ($this.prop("type") == "radio") {
                $this.prop("checked", false);
            } else if ($this.prop("type") == "checkbox") {
                $this.prop("checked", false);
                lastCheckBox = $this.attr("name");
            } else {
                $this.val("");
            }
            $this.change();
        }
    });
    $(form).find(".validation-summary-errors").html("");
}

function getSafeValue(value) {

    if (value == "true")
        return true;
    if (value == "false")
        return false;
    if (value || value===0)
        return value;
    return "";
}

function setFormValues(form, values) {

    resetForm(form);
    var lastCheckBox = null;
    $(form).find("input,select").each(function () {
        var $this = $(this);
        var name = $this.attr("name");
        
        if (name && name != lastCheckBox) {
            name = name.split(".").pop(-1);
            name = name.charAt(0).toLowerCase() + name.substr(1);
            var value = getSafeValue(values[name]);
            if (typeof (AutoNumeric) != "undefined") {
                var autonumeric = AutoNumeric.getAutoNumericElement(this);
                if (autonumeric) {
                    autonumeric.set(value);
                    $this.change();
                    return;
                }
            }
            // getNumber
            if ($this.prop("tagName") == "SELECT") {
                $this.find("option[value='" + value + "']").prop("selected", true);
            } else if ($this.prop("type") == "radio") {
                if (getSafeValue($this.val()) == value)
                    $this.prop("checked", true);
            } else if ($this.prop("type") == "checkbox") {
                if (value) 
                    $this.prop("checked", true);
                lastCheckBox = $this.attr("name");
            } else {
                $this.val(value);
            }
            $this.change();
        }
    });
}

function getFormValues(form) {

    var values = {};
    var lastCheckBox = null;
    $(form).find("input,select").each(function () {
        var $this = $(this);
        var name = $this.attr("name");
        if (name && name != lastCheckBox) {
            var value = getSafeValue($this.val());
            if (value || value==0) {
                name = name.split(".").pop(-1);
                name = name.charAt(0).toLowerCase() + name.substr(1);
                if (typeof (AutoNumeric) != "undefined") {
                    var autonumeric = AutoNumeric.getAutoNumericElement(this);
                    if (autonumeric) {
                        values[name] = autonumeric.getNumber();
                        return;
                    }
                }
                // getNumber
                if ($this.prop("type") == "radio") {
                    if ($this.is(":checked"))
                        values[name] = value;
                } else if ($this.prop("type") == "checkbox") {
                    if ($this.is(":checked"))
                        values[name] = value;
                    lastCheckBox = $this.attr("name");
                } else {
                    values[name] = value;
                    if ($this.prop("tagName") == "SELECT")
                        values[name + "Label"] = $this.find("option:selected").text();
                }
            }
        }
    });

    return values;
}

$(function () {

    var cUrl = window.location.pathname.toLowerCase();

    $("#navegador").find("div>a").each(function () {
        if ($(this).attr("href").split('?')[0].toLowerCase() == cUrl) {
            $(this).addClass("active");
            $(this).closest("div.parent").find("div").collapse("show");
            return false;
        }
    });

    function minValue(i, j) {
        return j > i ? i : j;
    }

    function maxValue(i, j) {
        return i > j ? i : j;
    }

    var $header = $("#headerm");
    var $headerNext = $header.parent().next();
    var $headerParent = $header.parent();
    function updateHeader() {
        var rigthNext = $headerNext.width() + $headerNext.position().left;
        var rigthParent = $headerParent.position().left + $headerParent.width();
        // var maxAncho = maxValue($headerNext.position().left + $headerNext.width() - $headerParent.position().left - $headerParent.width() - 3, 0);
        var ancho = 0;
        if (rigthNext > $(window).width() + $(window).scrollLeft()) {
            ancho = maxValue($(window).width() + $(window).scrollLeft() - rigthParent -3, -$headerParent.position().left);
        } else {
            ancho = $headerNext.width();
        }
        $header.css({
            'left': ancho
        });
    }
    $(window).scroll(updateHeader).resize(updateHeader);
    updateHeader();
    setTimeout(updateHeader, 1000);




    var loadingCount = 0;
    $(document).ajaxStart(function () {
        loadingCount++;
        if (loadingCount)
            $("#loading").show();
    });
    $(document).ajaxComplete(function () {
        loadingCount--;
        if (loadingCount < 0)
            loadingCount = 0;
        if (!loadingCount)
            $("#loading").hide();
    });

    var rms = $.getUrlParameter('rms');
    if (rms)
        toastr.success(decodeURIComponent(rms));

    var dlgopen = 0; // fix close function on ajax request
    $(window).on('show.bs.modal', function (e) {
        dlgopen++;
    }).on('hidden.bs.modal', function (e) {
        dlgopen--;
        if (dlgopen == 0)
            $("body").removeClass("modal-open");
        else $("body").addClass("modal-open");
        $(window).resize();
    }).on('shown.bs.modal', function (e) {
        $(e.target).find(":input:not(button):not(:hidden):not(.tt-hint):first").focus();
    });

    function evalInContext(js, context) {
        //# Return the results of the in-line anonymous function we .call with the passed context
        var evfunction = new Function(js);
        return evfunction.call(context);
        // return eval.call(context, "(function (){ " + js + " })()");
        // return function () { return eval(js); }.call(context);
    }

    function _onSubmitClickBtn() {
        var retorno = true;
        if (hiddenButtons.length > 0 && hiddenButtons[hiddenButtons.length - 1] == this)
            return false;
        if (typeof (this.ejecutar) !== 'undefined') {
            if (typeof (this.ejecutar) === 'function')
                retorno = this.ejecutar();
            else retorno = evalInContext(this.ejecutar, this);
        }

        if ($(this).attr("data-close-dlg"))
            $($(this).attr("data-close-dlg")).modal('hide');
        if (!$.validator || $(this).attr("formnovalidate") != undefined)
            return true;
        var $form = $(this).closest("form");
        try {
            if ($form.length == 0 || !$form.valid())
                return true;
        } catch (e) {
            return true;
        }

        if ((typeof retorno === 'undefined' || retorno) && (typeof Page_IsValid === 'undefined' || Page_IsValid || typeof this.ejecutar === 'undefined')) {
            hiddenButtons.push(this);
            if ($(this).prop("tagName") == "BUTTON")
                $(this).after('<button disabled="disabled" class="dummybutton ' + $(this).attr('class') + '">' + $(this).html() + '</button>');
            else $(this).after('<input type="button" disabled="disabled" value="' + $(this).val() + '" class="dummybutton ' + $(this).attr('class') + '" />');
            $(this).addClass("hide").hide();
            if ($(this).attr("data-close-dlg"))
                $($(this).attr("data-close-dlg")).modal('hide');
        }
        return retorno;
    }

    $("._date").wrap('<div class="input-group"></div>')
        .datetimepicker({ locale: 'es', format: 'L', showTodayButton: true, showClear: true, maxDate: moment(new Date()).add(1, 'h') })
        ;

    $(".datetime").wrap('<div class="input-group"></div>')
        .datetimepicker({ locale: 'es', format: 'DD/MM/YYYY HH:mm', showTodayButton: true, showClear: true, maxDate: moment(new Date()).add(1, 'h') })
        ;

    $(":submit,:button").each(function (i) {
        if (this.ejecutar == undefined && !$(this).data("psv") && $(this).closest(".fakeform").length==0) {
            this.ejecutar = $(this).attr("onclick");
            $(this).removeAttr("onclick").click(_onSubmitClickBtn);
        }
    });

    $(".fakeform").on("submit", function (e) {
        e.preventDefault();
        return false;
    });

    $("h5>a>i.fa-chevron-down").each(function () {
        var $a = $(this).closest("a");
        var save = $a.data("toggle-save");
        if (save) {
            save = "toggle-save-" + $a.data("target");
        }
        $a.click(function () {
            var $ibutn = $(this).find("i.fa-chevron-down,i.fa-chevron-up");
            $ibutn.toggleClass("fa-chevron-down");
            $ibutn.toggleClass("fa-chevron-up");
            if ($ibutn.hasClass("fa-chevron-up"))
                localStorage[save] = 1;
            else localStorage.removeItem(save);
        });
        if (save) {
            if (localStorage[save]) {
                $($a.data("target")).collapse("show");
                $a.click();
            }
        }
    });

    $.setStoreProperties = function (url, id) {
        $.setDocumentProperties(url, id, 1);
    };
    // Propiedades del documento
    $.setDocumentProperties = (function () {

        var url, id, post;
        function updateProperties() {
            if (url && id) {
                $.ajax({
                    url: rootPath + "_Layout/Properties",
                    data: { u: url, i: id, p: post },
                    method: "post",
                    success: function (data) {
                        var $parent = $("#mld").parent();
                        $("#mld").remove();
                        var $data = $(data);
                        $parent.append($data);
                        $(window).resize();
                    }
                });
                url = "";
                id = "";
            }
        }

        $('#lidocprop').click(function () {
            if (url && id) {
                updateProperties();
            }
        });

        return function setProperties(_url, _id, _post) {
            url = _url;
            id = _id;
            post = _post;
            if (!!(url && id))
                $("#lidocprop").closest("ul").removeClass("hidet");
            else $("#lidocprop").closest("ul").addClass("hidet");
            if ($("#lidocprop").find("a").hasClass("show")) {
                updateProperties();
            }
        };
    })();

    if (typeof (__id) != "undefined") {
        $.setDocumentProperties(docPath, __id);
    }
});

Number.prototype.formatCurrency = function (c, d, t) {
    var n = this,
        c = isNaN(c = Math.abs(c)) ? 0 : c,
        d = d == undefined ? "," : d,
        t = t == undefined ? "." : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
        j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};


/*
 * readonly
 * idMirrorTextArea
 */
$.fn._tinyMCE = function (options) {

    options = options || {};
    var length = tinyMCE.editors.length;
    for (var i = length; i > 0; i--) {
        tinyMCE.editors[i - 1].remove();
    };
    var ctrlid = "#" + this.attr("id");

    function rel(text) {
        text = text.replace(/\r/gi, '');
        text = text.replace(/&nbsp;/gi, '');
        while (text[0] == '\n') {
            text = text.substring(1);
        }
        text = text.split('\n');
        var szfinal = "";
        for (x = 0; x < text.length; x++) {
            text[x] = text[x].trim();
            if (text[x].match(/[\S]/g) != null) {
                if (szfinal.length)
                    szfinal += "\n";
                szfinal += text[x];
            }
        }
        // text = text.join('\n').replace(/\n{2,}/g, '\n');
        return szfinal;
    }

    function lim() {
        var limpio = rel(editor.getContent().replace(/<\S[^><]*>/g, ""));
        $(ctrlid).val(limpio);
        var completa = "<ol><li>" + limpio.replace(/\n/g, "</li><li>") + "</li></ol>";
        editor.setContent(completa);
    }

    tinyMCE.init({
        mode: "exact"
        , selector: "#" + options.idMirrorTextArea
        , readonly: options.readonly
        , menubar: false
        , statusbar: false
        , toolbar: false
        , valid_elements: "ol,li,p,br"
        , setup: function (ed) {
            editor = ed;
            ed.on('submit', function (e) {
                lim();
            });
            ed.on('init', function (ed) {
                var completa = $(ctrlid).val();
                completa = "<ol><li>" + completa.replace(/\n/g, "</li><li>") + "</li></ol>";
                editor.setContent(completa);
                $("#" + options.idMirrorTextArea).remove();
            });
            ed.on('blur', function (e) {
                tinyMCE.triggerSave();
                lim();
            });
        }
        , paste_preprocess: function (pl, o) {
            o.content = o.content.replace(/<\S[^><]*>/g, "");
        }
    });

    return this;
};