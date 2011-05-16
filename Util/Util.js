var caracteres = new Array("Ñ", "Á", "É", "Í", "Ó", "Ú", " "); //Arreglo con los caracteres permitidos para validar una cadena de solo letras
var getEl = function(elementId) {
    return document.getElementById(elementId);
}

Array.prototype.encontrar = //Agrega Función prototipo a la clase Array para buscar un valor en el arreglo
    function(val) {
        for (var i = 0; i <= this.length; i++)
            if (this[i] == val)
            return true
        return false
    }
String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "");
}
String.prototype.ltrim = function() {
    return this.replace(/^\s+/, "");
}
String.prototype.rtrim = function() {
    return this.replace(/\s+$/, "");
}
String.prototype.pad = function(l, s, t) {
    return s || (s = " "), (l -= this.length) > 0 ? (s = new Array(Math.ceil(l / s.length)
        + 1).join(s)).substr(0, t = !t ? l : t == 1 ? 0 : Math.ceil(l / 2))
        + this + s.substr(0, l - t) : this;
};
Date.prototype.convertir = function(fecha, formato) {
    var dia, mes, año
    dia = fecha.substring(0, 2)
    mes = fecha.substring(3, 5)
    año = fecha.substring(6, 10)
    var fecha = new Date(año, mes - 1, dia)
    return fecha
}
function validaEntero(txt) {//Valida para una caja de texto que solamente se digiten números
    if (isNaN(String.fromCharCode(event.keyCode)) && !(String.fromCharCode(event.keyCode) == "-" && txt.value.indexOf("-") < 0))
        return false;
    if (String.fromCharCode(event.keyCode) == "-") {
        txt.value = "-" + txt.value;
        return false;
    }
    return true;
}

function validaFloat(txt, sepDecimal) {//Valida para una caja de texto que solamente se digiten numeros ó el separador decimal ó el sumbolo menos
    if (isNaN(String.fromCharCode(event.keyCode)) && !(String.fromCharCode(event.keyCode) == sepDecimal && txt.value.indexOf(sepDecimal) < 0) && !(String.fromCharCode(event.keyCode) == "-" && txt.value.indexOf("-") < 0))
        return false;
    if (String.fromCharCode(event.keyCode) == "-") {
        txt.value = "-" + txt.value;
        return false;
    }
    return true;
}

function validaTexto() {//Solo Permite digitar letras y los caracteres especificados en el arreglo caracteres
    var car = String.fromCharCode(event.keyCode).toUpperCase();
    if ((event.keyCode >= 65 && event.keyCode <= 90) || (event.keyCode >= 97 && event.keyCode <= 122) || caracteres.encontrar(car))
        return true;
    return false;
}
function validaValorEnt(objTxt) {
    if (isNaN(parseInt(objTxt.value)))
        objTxt.value = ""
    else
        objTxt.value = parseInt(objTxt.value)
}
function validaValorFlo(objTxt) {
    objTxt.value = objTxt.value.replace(/,/, ".")
    if (isNaN(parseFloat(objTxt.value)))
        objTxt.value = ""
    else
        objTxt.value = parseFloat(objTxt.value)
    objTxt.value = objTxt.value.replace(/\./, ',')
}
function imprimir(id) {
    if (getEl(id)) {
        var el = getEl(id);
        var venImp = window.open("imp.htm", "popup");
        venImp.document.write("<head><link href='../App_Themes/Estandar/Estilo.css' rel='stylesheet' type='text/css' /></head>" + el.innerHTML);
        venImp.document.close();
        venImp.print();
        venImp.close();
    }
    else {
        var venImp = window.open(id, "popup");
    }

}
function setValDdlFromTxt(txtObj, ddlObj, postback) {
    if (txtObj.value == '' && ddlObj.options.length > 0)    
        ddlObj.options[0].selected = true;
    else
        ddlObj.value = txtObj.value;
    txtObj.value = ddlObj.value;
    if (postback)
        __doPostBack(ddlObj.name, '');
//        setTimeout('__doPostBack(getEl(\'" + Me.ddl.ClientID + "\').name,\'\')', 0);
}
function findPosX(obj) {
    var curleft = 0;
    if (obj.offsetParent)
        while (1) {
        curleft += obj.offsetLeft;
        if (!obj.offsetParent)
            break;
        obj = obj.offsetParent;
    }
    else if (obj.x)
        curleft += obj.x;
    return curleft;
}

function findPosY(obj) {
    var curtop = 0;
    if (obj.offsetParent)
        while (1) {
        curtop += obj.offsetTop;
        if (!obj.offsetParent)
            break;
        obj = obj.offsetParent;
    }
    else if (obj.y)
        curtop += obj.y;
    return curtop;
}
var lnkMant
function cargarMant(url,lnk) {
    var ven = window.open(url)
    lnkMant = lnk;
    if (ven.objOrigen) {
        ven.pagOrigen = this;
        ven.lnkOrigen = lnk.id;
    }
}
function destinoAct(nomPag) {
    eval(nomPag + "_pstbck();")
}
