var hiddenButton = null;
var funcionesInicio = new Array();
var funcionesRegistradas = new Array();

function imprimir() {

    var venImp = window.open("../imp.htm", "popup");
    var botones= $(":submit,:button").filter(":visible");
    botones.hide();
    venImp.document.write("<html><head><link href='~/css/estilo.css' rel='stylesheet' type='text/css' /><style type='text/css'>body{background: #FFFFFF;}</style></head><body>" + $("#dImprimir").html() + "</body></html>");
    venImp.document.close();
    venImp.print();
    venImp.close();
    botones.show();
}

function addDialog(szPanel, szDialog, showclosebutton) {

    if ($(szDialog + " :submit").length || $(szDialog + " :button").length) {
        
        if (typeof showclosebutton === "undefined")
            showclosebutton = false;
        $(szDialog).show().removeClass("hide").removeClass("hidet");
        g_OpenDialog = szDialog; // guardamos el dialogo abierto para validacion.
        $(szDialog).dialog({
            modal: true,
            autoOpen: true,
            width: 'auto',
            closeOnEscape: showclosebutton,
            open: function(event, ui) { if (!showclosebutton) $(".ui-dialog-titlebar-close").hide(); setTimeout("$('" + szDialog + " :input:first').focus();", 100); }
        });
        if (szPanel!=null)
            $(szDialog).parent().appendTo(jQuery(szPanel));
        $(szDialog + " :submit").button();
        $(szDialog + " :button").button();
        return true;
    }
    return false;
}

function FullRowSelect(grilla) {

    var tr = $(grilla + " tr").each(function(index) {
        var sel = $(this).children("td").children('input[src*="edit.gif"]');
        if (sel.length > 0) {
            $(this).css({ cursor: "hand", cursor: "pointer" }).hover(function() {
                $(this).addClass("GridSelRow");
            }, function() {
                $(this).removeClass("GridSelRow");
            });
            $(this).children("td").each(function(ind) {
                if ($(this).children("input").length == 0) {
                    if (sel.attr("id") == undefined) {
                        $(this).click(function() {
                            eval(" " + sel.attr("onclick"));
                        });
                    } else {
                        $(this).click(function() {
                            $("#" + sel.attr("id")).click();
                        });
                    }
                }
            });
        }
    });
}

// Cuando envia el boton para deshabilitarlo
function obs() {
    var retorno = true;
    if (hiddenButton == this)
        return false;
    if (typeof this.ejecutar !== 'undefined') {
        if (typeof this.ejecutar === 'function')
            retorno = this.ejecutar();
        else retorno = this.ejecutar.indexOf("return") == -1 ? eval(this.ejecutar) : eval("(function(){" + this.ejecutar + "})()");
    } else {
        $(this).closest('div[role="dialog"]').modal('hide');
        return true;
    }
    if ((typeof retorno === 'undefined' || retorno) && (typeof Page_IsValid === 'undefined' || Page_IsValid || typeof this.ejecutar === 'undefined')) {
        hiddenButton = this;
        $(this).hide();
        $(this).after('<input type="button" id="dummybutton" disabled="disabled" value="' + $(this).val() + '" class="' + $(this).attr('class') + '" />');
        $(this).closest('div[role="dialog"]').modal('hide');
    }
    return retorno;
}

$(function () {
    $(document).on('shown.bs.modal', function (e, i) {
        var $input = $(e.target).find(":input:first");
        if ($input.attr("data-dismiss") == "modal")
            $(e.target).find(":input:eq(1)").focus();
        else $input.focus();
    });
});

function inicio() {

    // todos los campos hora
    $(".hora:not(.rhora)").wrap('<div class="form-inline wdt"><div class="form-group has-feedback"></div></div>')
        .mask("99:99").datetimepicker({ locale: 'es', format: 'HH:mm', showTodayButton: true, showClear: true }).addClass("rhora")
        .parent().append('<span class="glyphicon glyphicon-calendar form-control-feedback"></span>');
        
    // todos los campos fecha
    $(".fecha:not(.rfecha)").wrap('<div class="form-inline wdt"><div class="form-group has-feedback"></div></div>')
        .mask("99/99/9999").datetimepicker({ locale: 'es', format: 'L', showTodayButton: true, showClear: true }).addClass("rfecha")
        .parent().append('<span class="glyphicon glyphicon-calendar form-control-feedback"></span>');
    $(".fechahora:not(.rfechahora)").wrap('<div class="form-inline wdt"><div class="form-group has-feedback"></div></div>')
        .datetimepicker({ locale: 'es', format: 'DD/MM/YYYY HH:mm', showTodayButton: true, showClear: true }).addClass("rfechahora")
        .parent().append('<span class="glyphicon glyphicon-calendar form-control-feedback"></span>');
    // todos los campos entero
    $('.entero:not(.rentero)').autoNumeric('init', { vMin: 0, mDec: 0, aSep: '' }).addClass("rentero");

    // todos los reales
    $('.float:not(.rfloat)').autoNumeric('init', { vMin: 0, aSep: '', mDec: 8, aPad: false }).addClass("rfloat");
    
    // dinero
    $('.dinero:not(.rdinero)').autoNumeric('init', { vMin: 0, aSign: '$', aPad: false }).addClass("rdinero");

    $('img[src*="menubg.jpg"]').hover(function() {
        $(this).attr("src", $(this).attr("src").replace("menubg", "menuover"));
    }, function() {
        $(this).attr("src", $(this).attr("src").replace("menuover", "menubg"));
    });

    $(".linkMenu").hover(function() {
        if (typeof this.rep == "undefined") {
            var img = $(this).prev().find("img");
            if (img.length) {
                this.rep = img;
            } else this.rep = false;
        }
        if (this.rep)
            this.rep.attr("src", this.rep.attr("src").replace("menubg", "menuover"));
    }, function() {
        if (this.rep)
            this.rep.attr("src", this.rep.attr("src").replace("menuover", "menubg"));
    });
    
    // todos los eliminar
    $('input[src*="eliminar.gif"],.btn-danger').each(function (i) {
        if (this.eliminar == undefined) {
            this.eliminar = $(this).attr("onclick");
            $(this).unbind('click').attr("onclick", "").click(function () {
                if (confirm('¿Esta seguro de eliminar este elemento?')) {
                    if (this.eliminar != undefined) {
                        var retorno = null;
                        if (this.eliminar.toString().indexOf("function") == -1) 
                            retorno = this.eliminar.indexOf("return") == -1 ? eval(this.eliminar) : eval("(function(){" + this.eliminar + "})()");
                        else retorno = this.eliminar();
                        return retorno;
                    }
                    return true;
                } return false;
            });
        }
    });

    $(":submit,:button").each(function(i) {
        if (typeof this.ejecutar === 'undefined') {
            this.ejecutar = $(this).attr("onclick");
            if (typeof this.ejecutar !== 'undefined' && this.ejecutar == "")
                this.ejecutar = undefined;
            $(this).removeAttr("onclick").click(obs);
        }
    });

    for (var funcionInicio in funcionesInicio) {
        funcionesInicio[funcionInicio]();
    }

    // capturamos el enter
    $('input,select').keydown(function(event) { //event==Keyevent
        if (event.which == 13) {
            var inputs = $(this).closest('form').find(':input:visible[tabindex!="-1"]');
            if ($(this).attr('type') != 'button' &&
                $(this).attr('type') != 'submit') {
                inputs.eq(inputs.index(this) + 1).focus();
                $(this).change();
                event.preventDefault();
            }
        }
    });
}

$.extend({
    getUrlVars: function() {
        var vars = [], hash;
        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < hashes.length; i++) {
            hash = hashes[i].split('=');
            vars.push(hash[0]);
            vars[hash[0]] = hash[1];
        }
        return vars;
    },
    getUrlVar: function(name) {
        return $.getUrlVars()[name];
    },
    goURL: function(params) {
        pos = window.location.href.indexOf('?');
        url = pos == -1 ? location.href : location.href.slice(0, window.location.href.indexOf('?'));
        if (params == null)
            location.href = url;
        else location.href= url + "?" + params;
    }
});

function ValidateFileUploadJPG(Source, args) {

    var FileUploadPath = args.Value;
    if (FileUploadPath == '') {
        // There is no file selected 
        args.IsValid = false;
    } else {
        var Extension = FileUploadPath.substring(FileUploadPath.lastIndexOf('.') + 1).toLowerCase();
        args.IsValid = Extension == "jpg" || Extension == "jpeg"; // Valid file type
    }
}

function ValidateFileUploadJPGPDF(Source, args) {

    var FileUploadPath = args.Value;
    if (FileUploadPath == '') {
        // There is no file selected 
        args.IsValid = false;
    } else {
        var Extension = FileUploadPath.substring(FileUploadPath.lastIndexOf('.') + 1).toLowerCase();
        args.IsValid = Extension == "jpg" || Extension == "jpeg" || Extension=="pdf"; // Valid file type
    }
}

function restoreSummit() {

    $("#dummybutton").remove();
    var h = hiddenButton;
    hiddenButton = null;
    return $(h).show();
}

$.fn.sortSelect = function() {
    var sel = this.val();
    var op = this.children("option");
    op.sort(function(a, b) {
        return a.text > b.text ? 1 : -1;
    })
    return this.empty().append(op).val(sel);
}

function $inicio(funcion) {
    funcionesInicio.push(funcion);
}
function addFunctionToStart(funcion) {
    funcionesInicio.push(funcion);
}

function RegisterStarUpScript(nombre_contenedor) {

    for (var funcion in funcionesRegistradas) {
        if (funcionesRegistradas[funcion] == nombre_contenedor)
            return;
    }
    var contenedor = $('#' + nombre_contenedor);
    if (contenedor.length > 0) {
        contenedor.append(contenedor.html());
        funcionesRegistradas.push(nombre_contenedor);
    }
}

function drawPieChart(divid, data, titulo_u_opciones) {
    if (data.length == 0)
        return;
    data = google.visualization.arrayToDataTable(data);
    var options;
    if (typeof titulo_u_opciones == "string")
        options = {
            title: titulo_u_opciones
        };
    else options = titulo_u_opciones;

    var chart = new google.visualization.PieChart(document.getElementById(divid));
    chart.draw(data, options);
}

var hasStorage = (function() {
    try {
        var mod = "test_hasStorage";
        localStorage.setItem(mod, mod);
        localStorage.removeItem(mod);
        return true;
    } catch (e) {
        return false;
    }
} ());


function currencyFormatted(amount) {
    var i = parseFloat(amount);
    if (isNaN(i)) { i = 0.00; }
    var minus = '';
    if (i < 0) { minus = '-'; }
    i = Math.abs(i);
    i = parseInt((i + .005) * 100);
    i = i / 100;
    s = new String(i);
    /* if (s.indexOf('.') < 0) { s += '.00'; }
    if (s.indexOf('.') == (s.length - 2)) { s += '0'; }*/
    s = minus + s;
    return '$' + commaFormatted(s);
}

function commaFormatted(amount) {

    var delimiter = ","; // replace comma if desired
    var a = amount.split('.', 2)
    var d = a[1];
    var i = parseInt(a[0]);
    if (isNaN(i)) { return ''; }
    var minus = '';
    if (i < 0) { minus = '-'; }
    i = Math.abs(i);
    var n = new String(i);
    var a = [];
    while (n.length > 3) {
        var nn = n.substr(n.length - 3);
        a.unshift(nn);
        n = n.substr(0, n.length - 3);
    }
    if (n.length > 0) { a.unshift(n); }
    n = a.join(delimiter);
    if (d==undefined || d.length < 1) { amount = n; }
    else { amount = n + '.' + d; }
    amount = minus + amount;
    return amount;
}