var hiddenButton = null;
var funcionesInicio = new Array();
var funcionesRegistradas = new Array();

function imprimir() {

    var venImp = window.open("../imp.htm", "popup");
    var botones= $(":submit,:button").filter(":visible");
    botones.hide();
    venImp.document.write("<html><head><link href='../css/estilo.css' rel='stylesheet' type='text/css' /><style type='text/css'>body{background: #FFFFFF;}</style></head><body>" + $("#dImprimir").html() + "</body></html>");
    venImp.document.close();
    venImp.print();
    venImp.close();
    botones.show();
}

function addDialog(szPanel, szDialog, showclosebutton) {

    if ($(szDialog + " :submit").length || $(szDialog + " :button").length) {

        $(szDialog).show();
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
        else retorno = eval(this.ejecutar);
    }
    if ((typeof retorno === 'undefined' || retorno) && (typeof Page_IsValid === 'undefined' || Page_IsValid || typeof this.ejecutar === 'undefined')) {
        hiddenButton = this;
        $(this).hide();
        $(this).after('<input type="button" id="dummybutton" disabled="disabled" value="' + $(this).val() + '" class="' + $(this).attr('class') + '" />');
    }
    return retorno;
}

function inicio() {

    // todos los campos hora
    $(".hora").mask("99:99");
    $(".hora").timeEntry({ show24Hours: true });
    $(".hora").timepicker({ hourText: 'Horas',
        minuteText: 'Minutos',
        amPmText: ['AM', 'PM']
    });
    // todos los campos fecha
    $(".fecha").mask("99/99/9999");
    // $(".fecha").datepicker({ onSelect: function() { } });
    $(".fecha").datepicker($.datepicker.regional["es"]);
    
    // todos los campos entero
    $('.entero').numeric({ format: "0", buttons: false, minValue: 0 });

    // todos los reales
    $('.float').numeric({ format: "0.########", buttons: false, minValue: 0 });
    // $('.float').numeric({ format: "0.00", buttons: false, minValue: 0 });
    
    // dinero
    $('.dinero').numeric({ format: "#,000.##", buttons: false, minValue: 0 });

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
    $('input[src*="eliminar.gif"]').each(function(i) {
        if (this.eliminar == undefined) {
            this.eliminar = $(this).attr("onclick");
            $(this).unbind('click').attr("onclick", "").click(function() { if (confirm('¿Esta seguro de eliminar este elemento?')) { if (this.eliminar != undefined) { if (this.eliminar.toString().indexOf("function") == -1) eval(this.eliminar); else this.eliminar(); } return true; } return false; });
        }
    });

    $(":submit,:button").each(function(i) {
        if (typeof this.ejecutar === 'undefined') {
            this.ejecutar = $(this).attr("onclick");
            if (typeof this.ejecutar !== 'undefined' && this.ejecutar == "")
                this.ejecutar = undefined;
            //            if ($(this).data("events")) {
            //                $.each($(this).data("events"), function(evento, event) {
            //                    alert(evento);
            //                    $.each(event, function(j, h) {
            //                        alert(h.handler);
            //                    });
            //                });
            //            }
            $(this).unbind('click').attr("onclick", "").click(obs);
        }
    });

    for (var funcionInicio in funcionesInicio) {
        funcionesInicio[funcionInicio]();
    }
    
    // funcion propia de la pagina
    /*if (typeof iniciopagina == "function") {
        iniciopagina();
    }*/

    // capturamos el enter
    $('input,select').keydown(function(event) { //event==Keyevent
        if (event.which == 13) {
            var inputs = $(this).closest('form').find(':input:visible');
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
function restoreSummit() {

    $("#dummybutton").remove();
    var h = hiddenButton;
    hiddenButton = null;
    return $(h).show();
}

function EndRequestHandler(sender, args) {
    //if UpdatePanel error occurs...
    if (args.get_error() != undefined) {
        var Error = "[Code]:" +
                    args.get_response().get_statusCode() + "  [Message]: " +
                    args.get_error().message;
        //Hide default ajax error popup
        args.set_errorHandled(true);
        //Show your custom popup or...
        if (confirm("¿Se ha perdido conexión con el servidor desea reintentar?")) {
            restoreSummit().click();
        } else {
            restoreSummit();
        }
    } else restoreSummit();
}

$(function() {
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
});

$.fn.sortSelect = function() {
    var sel = this.val();
    var op = this.children("option");
    op.sort(function(a, b) {
        return a.text > b.text ? 1 : -1;
    })
    return this.empty().append(op).val(sel);
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